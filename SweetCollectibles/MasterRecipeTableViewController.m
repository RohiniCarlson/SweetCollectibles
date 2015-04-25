//
//  MasterRecipeTableViewController.m
//  SweetCollectibles
//
//  Created by it-högskolan on 2015-04-25.
//  Copyright (c) 2015 it-h&#246;gskolan. All rights reserved.
//
//#import <CoreData/CoreData.h>
#import "MasterRecipeTableViewController.h"
#import "AppDelegate.h"
#import "RecipeCell.h"
#import "Recipe.h"
#import "RecipeInfo.h"

@interface MasterRecipeTableViewController () <UISearchBarDelegate, UISearchResultsUpdating>
@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSFetchRequest *fetchRequest;
//@property (strong, nonatomic) NSFetchRequest *searchFetchRequest;
@property (strong, nonatomic) AppDelegate *delegate;
@property (strong, nonatomic) NSArray *fetchedObjects;
@property (strong, nonatomic) NSMutableArray *filteredList;
@property (strong, nonatomic) NSArray *titlesArray;
@property (strong, nonatomic) NSMutableArray *sectionRecipeTitles;
@property (strong, nonatomic) NSArray *recipeIndexTitles;
@end


@implementation MasterRecipeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = [UIApplication sharedApplication].delegate;
    self.context = self.delegate.managedObjectContext;
    self.filteredList = [[NSMutableArray alloc] init];
    self.sectionRecipeTitles = [[NSMutableArray alloc] init];
    self.recipeIndexTitles = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
    [self fetchRecipes];
    [self createArrayForSectionRecipeTitles];
    NSLog(@"Recipe count: %lu", (unsigned long)self.fetchedObjects.count);
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didChangePreferredContentSize:)
                                                 name:UIContentSizeCategoryDidChangeNotification object:nil];
    self.tableView.estimatedRowHeight = 50.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    // No search results controller to display the search results in the current view
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    
    self.searchController.searchBar.delegate = self;
    
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    self.definesPresentationContext = YES;

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didChangePreferredContentSize:(NSNotification *)notification
{
    [self.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowDetailView"])
    {
        RecipeInfo *recipeInfo = [segue destinationViewController];

        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        Recipe *recipe = nil;
        if (self.searchController.isActive)
        {
            recipe = [self.filteredList objectAtIndex:indexPath.row];
        }
        else
        {
            recipe = [self.fetchedObjects objectAtIndex:indexPath.row];
        }
        recipeInfo.recipe = recipe;
    } else {
        NSLog(@"You forgot the segue %@",segue);
    }
}


// TO DO
- (void)updateSearchResultsForSearchController:(UISearchController *) searchController {
    NSString *searchString = searchController.searchBar.text;
    //[self searchForText:searchString scope:searchController.searchBar.selectedScopeButtonIndex];
    [self searchForText:searchString];
    [self.tableView reloadData];
}

-(void)searchForText:(NSString *)recipeName {
    
    // Update the filtered array based on the search.
    
    [self.filteredList removeAllObjects]; // First clear the filtered array.
    
    /*  Search the main list for recipes whose name matches searchText; add items that match to the filtered array.
     */
    for (Recipe *recipe in self.fetchedObjects) {
        NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
        NSRange recipeNameRange = NSMakeRange(0, recipe.title.length);
        NSRange foundRange = [recipe.title rangeOfString:recipeName options:searchOptions range:recipeNameRange];
        if (foundRange.length > 0) {
            [self.filteredList addObject:recipe];
        }
    }
    /*
     NSString *predicateFormat = @"%K BEGINSWITH[cd] %@";
     NSString *searchAttribute = @"name";
     
     NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFormat, searchAttribute, searchText];
     [self.searchFetchRequest setPredicate:predicate];
     
     NSError *error = nil;
     self.filteredList = [self.managedObjectContext executeFetchRequest:self.searchFetchRequest error:&error];
     if (error)
     {
     NSLog(@"searchFetchRequest failed: %@",[error localizedDescription]);
     }
     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   // self.searchFetchRequest = nil;
}

-(void)fetchRecipes{
    
    NSError *error;
    
    self.fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *recipe = [NSEntityDescription entityForName:@"Recipe"
                                              inManagedObjectContext:self.context];
    [self.fetchRequest setEntity:recipe];
    self.fetchedObjects = [self.context executeFetchRequest:self.fetchRequest error:&error];
    NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    self.fetchedObjects = [self.fetchedObjects sortedArrayUsingDescriptors:@[sd]];
    
}

-(void) createArrayForSectionRecipeTitles {
    Recipe *recipe;
    NSString *firstLetter;
    for(int i=0; i<self.fetchedObjects.count; i++) {
        recipe = self.fetchedObjects[i];
        firstLetter = [recipe.title substringToIndex:1];
        if(![self isLetterExists:firstLetter]) {
            [self.sectionRecipeTitles addObject:firstLetter];
        }
    }
}

-(BOOL) isLetterExists:(NSString*)letter {
    for(int i=0; i<self.sectionRecipeTitles.count; i++) {
        if([self.sectionRecipeTitles[i] isEqualToString:letter]){
            return YES;
        }
    }
    return NO;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.searchController.active)
    {
        return 1;
    }
    else
    {
        return self.sectionRecipeTitles.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    {
        if (self.searchController.active)
        {
            return [self.filteredList count];
        }
        else
        {
            NSString *sectionTitle = [self.sectionRecipeTitles objectAtIndex:section];
            NSMutableArray *allRecipes = [[NSMutableArray alloc]init];
            Recipe *recipe;
            NSString *firstLetter;
            for (int i=0; i<self.fetchedObjects.count; i++) {
                recipe = self.fetchedObjects[i];
                firstLetter = [recipe.title substringToIndex:1];
                if ([sectionTitle isEqualToString:firstLetter]) {
                    [allRecipes addObject:recipe];
                } else {
                    NSLog(@"Number of rows in section: %lu",(unsigned long)allRecipes.count );
                    return allRecipes.count;
                }
            }
            return allRecipes.count;
        }
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"In cellForRowAtIndexPath");
     RecipeCell *cell = [self.tableView dequeueReusableCellWithIdentifier: @"RecipeCell" forIndexPath:indexPath];
    
    Recipe *recipe = nil;
    if (self.searchController.active)
    {
        recipe = [self.filteredList objectAtIndex:indexPath.row];
    }
    else
    {
        recipe = [self.fetchedObjects objectAtIndex:indexPath.row];
    }
    cell.recipeLabel.text = recipe.title;
    NSLog(@"recipe label: %@",cell.recipeLabel.text);
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (!self.searchController.active)
    {
        return [self.sectionRecipeTitles objectAtIndex:section];
    }
    return nil;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (!self.searchController.active)
    {
        return self.recipeIndexTitles;
    }
    return nil;
}


- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (!self.searchController.active)
    {
        if (index > 0)
        {
           return [self.sectionRecipeTitles indexOfObject:title];;
        }
        else
        {
            // The first entry in the index is for the search icon so we return section not found
            // and force the table to scroll to the top.
            
            CGRect searchBarFrame = self.searchController.searchBar.frame;
            [self.tableView scrollRectToVisible:searchBarFrame animated:NO];
            return NSNotFound;
        }
    }
    return 0;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end