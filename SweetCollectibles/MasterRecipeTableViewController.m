//
//  MasterRecipeTableViewController.m
//  SweetCollectibles
//
//  Created by it-högskolan on 2015-04-25.
//  Copyright (c) 2015 it-h&#246;gskolan. All rights reserved.
//
#import "MasterRecipeTableViewController.h"
#import "AppDelegate.h"
#import "RecipeCell.h"
#import "Recipe.h"
#import "Recipe+RecipeCategory.h"
#import "RecipeInfo.h"

@interface MasterRecipeTableViewController () < NSFetchedResultsControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating>
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) NSFetchRequest *searchFetchRequest;
@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) AppDelegate *delegate;
@property (strong, nonatomic) NSArray *filteredList;
@property (strong, nonatomic) NSArray *recipeIndexTitles;
@end


@implementation MasterRecipeTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    //self.tableView.backgroundView = nil;
    //[self.tableView setBackgroundColor : [UIColor colorWithRed : 39.0f/255.0f green : 39.0f/255.0f blue : 39.0f/255.0f alpha : 1.0]];
    self.delegate = [UIApplication sharedApplication].delegate;
    self.context = self.delegate.managedObjectContext;
    self.filteredList = [[NSMutableArray alloc] init];
    self.recipeIndexTitles = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
    
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


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    self.searchFetchRequest = nil;
}


#pragma mark - NSFetchRequest setup

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

#pragma mark - NSFetchedResultsController setup

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
                                                                                         cacheName:nil];
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
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier: @"CustomRecipeCell" forIndexPath:indexPath];
    
    Recipe *recipe = nil;
    if (self.searchController.active)
    {
        recipe = [self.filteredList objectAtIndex:indexPath.row];
    } else {
        recipe = [self.fetchedResultsController objectAtIndexPath:indexPath];
    }
    cell.textLabel.text = recipe.title;
    cell.textLabel.font=[UIFont systemFontOfSize:12];
    cell.textLabel.lineBreakMode= NSLineBreakByTruncatingTail;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


/*- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (!self.searchController.active)
    {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo name];
    }
    return nil;
}*/

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (!self.searchController.active) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
        
        // Create custom view to display section header
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 18)];
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        label.text =[sectionInfo name];
        label.font = [UIFont boldSystemFontOfSize:14];
        [view addSubview:label];
        view.backgroundColor = [UIColor colorWithRed:241/255.0 green:229/255.0 blue:255/255.0 alpha:1.0];
        return view;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowDetailView"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        Recipe *recipe = nil;
        recipe = [self.fetchedResultsController objectAtIndexPath:
                  indexPath];
        if (self.searchController.isActive)
        {
            recipe = [self.filteredList objectAtIndex:indexPath.row];
        } else {
            recipe = [self.fetchedResultsController objectAtIndexPath:
                      indexPath];
        }
        RecipeInfo *recipeInfo = [segue destinationViewController];
        recipeInfo.recipe = recipe;
    } else {
        NSLog(@"You forgot the segue %@",segue);
    }
}

@end
