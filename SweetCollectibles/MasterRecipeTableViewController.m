//
//  MasterRecipeTableViewController.m
//  SweetCollectibles
//
//  Created by it-högskolan on 2015-04-25.
//  Copyright (c) 2015 it-h&#246;gskolan. All rights reserved.
//
#import "MasterRecipeTableViewController.h"
#import "AppDelegate.h"
#import "CustomRecipeCell.h"
#import "Recipe.h"
#import "Recipe+RecipeCategory.h"
#import "RecipeInfo.h"

@interface MasterRecipeTableViewController () < NSFetchedResultsControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating>
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) NSFetchRequest *searchFetchRequest;
@property (strong, nonatomic) NSManagedObjectContext *context;
//@property (strong, nonatomic) NSFetchRequest *fetchRequest;
@property (strong, nonatomic) AppDelegate *delegate;
@property (strong, nonatomic) NSArray *fetchedObjects;
@property (strong, nonatomic) NSArray *filteredList;
@property (strong, nonatomic) NSArray *titlesArray;
@property (strong, nonatomic) NSMutableArray *sectionRecipeTitles;
@property (strong, nonatomic) NSArray *recipeIndexTitles;
@end


@implementation MasterRecipeTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    UINib *recipeNib = [UINib nibWithNibName:@"CustomRecipeCell" bundle:nil];
    [self.tableView registerNib:recipeNib
         forCellReuseIdentifier:@"RecipeCell"];
    self.delegate = [UIApplication sharedApplication].delegate;
    self.context = self.delegate.managedObjectContext;
    self.filteredList = [[NSMutableArray alloc] init];
    self.sectionRecipeTitles = [[NSMutableArray alloc] init];
    self.recipeIndexTitles = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
    //[self fetchRecipes];
    //[self createArrayForSectionRecipeTitles];
    
   /* [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didChangePreferredContentSize:)
                                                 name:UIContentSizeCategoryDidChangeNotification object:nil];*/
    self.tableView.estimatedRowHeight = 50.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    // Search results shown in same view so initialised with nil searchresutscontroller
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.scopeButtonTitles = nil;
    
    self.searchController.searchBar.delegate = self;
    
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    self.definesPresentationContext = YES;
}


- (void)didChangePreferredContentSize:(NSNotification *)notification
{
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    //self.searchFetchRequest = nil;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"ShowDetailView"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];

        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:indexPath.section];
        NSLog(@"sectionInfo: %lu",(unsigned long)[sectionInfo numberOfObjects]);
        Recipe *recipe = nil;
        recipe = [self.fetchedResultsController objectAtIndexPath:
                  indexPath];
        NSLog(@"Before if section: %ld", (long)indexPath.section);
        NSLog(@"Before if row: %ld", (long)indexPath.row);
        RecipeInfo *recipeInfo = [segue destinationViewController];
        if (self.searchController.isActive)
        {
            recipe = [self.filteredList objectAtIndex:indexPath.row];
        } else {
            recipe = [self.fetchedResultsController objectAtIndexPath:
                      indexPath];
            NSLog(@"searchcontroller not active and recipe title is: %@",recipe.title);
        }
        
        recipeInfo.recipe = recipe;
        NSLog(@"RecipeTitle: %@", recipeInfo.title);
        
    } else {
        
        NSLog(@"You forgot the segue %@",segue);
    }
}

- (NSFetchRequest *)searchFetchRequest
{
    if (_searchFetchRequest != nil)
    {
        return _searchFetchRequest;
    }
    
    _searchFetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Recipe" inManagedObjectContext:self.context];
    [_searchFetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    [_searchFetchRequest setSortDescriptors:sortDescriptors];
    
    return _searchFetchRequest;
}

/*-(void)fetchRecipes{
    
    NSError *error;
    
    self.fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *recipe = [NSEntityDescription entityForName:@"Recipe"
                                              inManagedObjectContext:self.context];
    [self.fetchRequest setEntity:recipe];
    self.fetchedObjects = [self.context executeFetchRequest:self.fetchRequest error:&error];
    NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    self.fetchedObjects = [self.fetchedObjects sortedArrayUsingDescriptors:@[sd]];
}*/


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
    NSArray *temp = [self.sectionRecipeTitles sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    self.sectionRecipeTitles = [[NSMutableArray alloc] initWithArray:temp];
   /* for (int i=0; i<self.sectionRecipeTitles.count; i++) {
        NSLog(self.sectionRecipeTitles[i]);
    }*/
}


-(BOOL) isLetterExists:(NSString*)letter {
    
    for(int i=0; i<self.sectionRecipeTitles.count; i++) {
        if([self.sectionRecipeTitles[i] isEqualToString:letter]){
            return YES;
        }
    }
    return NO;
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil)
    {
        return _fetchedResultsController;
    }
    
    if (self.context)
    {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Recipe" inManagedObjectContext:self.context];
        [fetchRequest setEntity:entity];
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
        [fetchRequest setSortDescriptors:sortDescriptors];
        
        NSFetchedResultsController *frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                              managedObjectContext:self.context
                                                                                sectionNameKeyPath:@"sectionTitle"
                                                                                         cacheName:@"Recipe"];
        frc.delegate = self;
        self.fetchedResultsController = frc;
        
        NSError *error = nil;
        if (![self.fetchedResultsController performFetch:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
    }
    
    return _fetchedResultsController;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView reloadData];
}


#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *) searchController {
    
    NSString *searchString = searchController.searchBar.text;
    [self searchForText:searchString];
    [self.tableView reloadData];
}


-(void)searchForText:(NSString *)searchText {
    
    self.filteredList = nil; // First clear the filtered array.
    
    // Search the main list for recipes where title matches recipeName and
    // items that match to the filtered array.

    /*for (Recipe *recipe in self.fetchedObjects) {
        NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
        NSRange recipeNameRange = NSMakeRange(0, recipe.title.length);
        NSRange foundRange = [recipe.title rangeOfString:recipeName options:searchOptions range:recipeNameRange];
        if (foundRange.length > 0) {
            [self.filteredList addObject:recipe];
        }
    }*/
    
    if (self.context)
    {
        NSString *predicateFormat = @"%K BEGINSWITH[cd] %@";
        NSString *searchAttribute = @"title";
        
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFormat, searchAttribute, searchText];
        [self.searchFetchRequest setPredicate:predicate];
        
        NSError *error = nil;
        
        self.filteredList = [self.context executeFetchRequest:self.searchFetchRequest error:&error];
        if (error)
        {
            NSLog(@"searchFetchRequest failed: %@",[error localizedDescription]);
        }
        /*self.filteredList = [self.context executeFetchRequest:self.searchFetchRequest error:&error];
        if (error)
        {
            NSLog(@"searchFetchRequest failed: %@",[error localizedDescription]);
        }*/
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.searchController.active)
    {
        return 1;
    } else {
        return [[self.fetchedResultsController sections] count];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    {
        if (self.searchController.active)
        {
            return [self.filteredList count];
        }
        else {
            id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
            return [sectionInfo numberOfObjects];
        }
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CustomRecipeCell *cell = [self.tableView dequeueReusableCellWithIdentifier: @"RecipeCell" forIndexPath:indexPath];
    
    Recipe *recipe = nil;
    if (self.searchController.active)
    {
        recipe = [self.filteredList objectAtIndex:indexPath.row];
    } else {
        /*NSString *sectionTitle = [self.sectionRecipeTitles objectAtIndex:indexPath.section];
        NSMutableArray *allRecipes = [[NSMutableArray alloc]init];
        NSString *firstLetter;
        for (int i=0; i<self.fetchedObjects.count; i++) {
            recipe = self.fetchedObjects[i];
            firstLetter = [recipe.title substringToIndex:1];
            if ([sectionTitle isEqualToString:firstLetter]) {
                [allRecipes addObject:recipe];
            }
        }
        NSArray *sortedArray = [allRecipes sortedArrayUsingComparator:^(Recipe *a, Recipe *b) {
            return [a.title caseInsensitiveCompare:b.title];
        }];
        recipe = [sortedArray objectAtIndex:indexPath.row];*/
        recipe = [self.fetchedResultsController objectAtIndexPath:indexPath];
    }
    cell.recipeLabel.text = recipe.title;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.numberOfLines = 1;
    
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (!self.searchController.active)
    {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo name];
    }
    return nil;
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (!self.searchController.active)
    {
        NSMutableArray *index = [NSMutableArray arrayWithObject:UITableViewIndexSearch];
        NSArray *initials = [self.fetchedResultsController sectionIndexTitles];
        [index addObjectsFromArray:initials];
        return index;
    }
    return nil;
}


- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (!self.searchController.active)
    {
        if (index > 0)
        {
           return [self.fetchedResultsController sectionForSectionIndexTitle:title atIndex:index-1];
        } else {
            // The first entry in the index is for the search icon so we return section not found
            // and force the table to scroll to the top.
            
            CGRect searchBarFrame = self.searchController.searchBar.frame;
            [self.tableView scrollRectToVisible:searchBarFrame animated:NO];
            return NSNotFound;
        }
    }
    return 0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"ShowDetailView" sender:tableView];
}




@end
