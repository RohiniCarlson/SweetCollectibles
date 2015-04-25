//
//  TPSMasterViewController.m
//  Sample-UISearchController
//
//  Created by James Dempsey on 7/4/14.
//  Copyright (c) 2014 Tapas Software. All rights reserved.
//
//  Based on Apple sample code TableSearch version 2.0
//

#import "MasterViewControllerTableResults.h"
#import "RecipeInfo.h"
#import "SearchResultsTableViewController.h"
#import "Recipe.h"
#import "AppDelegate.h"
#import "RecipeCell.h"

#define ENABLE_SCOPE_BUTTONS 1


@interface MasterViewControllerTableResults () <UISearchResultsUpdating, UISearchBarDelegate>

@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray *searchResults; // Filtered search results
@property (nonatomic) NSMutableArray *sectionRecipeTitles;
@property (nonatomic) NSArray *recipeIndexTitles;
@end

#pragma mark -

@implementation MasterViewControllerTableResults

- (void)viewDidLoad {

    [super viewDidLoad];
    //self.filteredResult = [[NSMutableArray alloc] init];
    //self.products = [Product allProducts];
    [self fetchRecipes];
    [self createArrayForSectionRecipeTitles];
    self.sectionRecipeTitles = [[NSMutableArray alloc] init];
    self.recipeIndexTitles = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];

    // Create a mutable array to contain products for the search results table.
    self.searchResults = [NSMutableArray arrayWithCapacity:[self.recipes count]];

    // The table view controller is in a nav controller, and so the containing nav controller is the 'search results controller'
    UINavigationController *searchResultsController = [[self storyboard] instantiateViewControllerWithIdentifier:@"TableSearchResultsNavController"];

    self.searchController = [[UISearchController alloc] initWithSearchResultsController:searchResultsController];

    self.searchController.searchResultsUpdater = self;

    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);

    self.tableView.tableHeaderView = self.searchController.searchBar;
/*
#if ENABLE_SCOPE_BUTTONS
    
    NSMutableArray *scopeButtonTitles = [[NSMutableArray alloc] init];
    [scopeButtonTitles addObject:NSLocalizedString(@"All", @"Search display controller All button.")];

    for (NSString *deviceType in [Product deviceTypeNames]) {
        NSString *displayName = [Product displayNameForType:deviceType];
        [scopeButtonTitles addObject:displayName];
    }

    self.searchController.searchBar.scopeButtonTitles = scopeButtonTitles;
    self.searchController.searchBar.delegate = self;

#endif*/

    self.definesPresentationContext = YES;
    
}

-(void)fetchRecipes{
    
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = delegate.managedObjectContext;
    NSError *error;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *recipe = [NSEntityDescription entityForName:@"Recipe"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:recipe];
    self.recipes = [context executeFetchRequest:fetchRequest error:&error];
    NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    self.recipes = [self.recipes sortedArrayUsingDescriptors:@[sd]];
}

-(void)sortFetchedObjects{
    NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    self.recipes = [self.recipes sortedArrayUsingDescriptors:@[sd]];
}

-(void) createArrayForSectionRecipeTitles {
    Recipe *recipe;
    NSString *firstLetter;
    [self sortFetchedObjects];
    for(int i=0; i<self.recipes.count; i++) {
        recipe = self.recipes[i];
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier
         isEqualToString:@"pushDetailView"]) {
        NSLog(@"Found segue");
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        Recipe *recipe = self.recipes[indexPath.row];

        RecipeInfo *destinationController = segue.destinationViewController;
        destinationController.recipe = recipe;
    } else {
        NSLog(@"No segue");
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSLog(@"numberOfSectionsInTableView");
    return self.sectionRecipeTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"numberOfRowsInSection");

    NSString *sectionTitle = [self.sectionRecipeTitles objectAtIndex:section];
    NSMutableArray *allRecipes = [[NSMutableArray alloc]init];
    Recipe *recipe;
    NSString *firstLetter;
    for (int i=0; i<self.recipes.count; i++) {
        recipe = self.recipes[i];
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


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSLog(@"titleForHeaderInSection");
    return [self.sectionRecipeTitles objectAtIndex:section];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"cellForRowAtIndexPath");
    static NSString *CellIdentifier = @"AllRecipes";

     RecipeCell *cell = (RecipeCell*)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    Recipe *recipe = [self.recipes objectAtIndex:indexPath.row];
    //cell.textLabel.text = recipe.title;
    cell.recipeLabel.text = recipe.title;
    NSLog(@"recipe title: %@",recipe.title);
   // NSLog(@"cell title: %@", cell.filteredCellTitle.text);
    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.recipeIndexTitles;
}


- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [self.sectionRecipeTitles indexOfObject:title];
}


#pragma mark - UISearchResultsUpdating

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {

    NSString *searchString = [self.searchController.searchBar text];

   // NSString *scope = nil;

   // NSInteger selectedScopeButtonIndex = [self.searchController.searchBar selectedScopeButtonIndex];
   /* if (selectedScopeButtonIndex > 0) {
        scope = [[Product deviceTypeNames] objectAtIndex:(selectedScopeButtonIndex - 1)];
    }*/

    [self updateFilteredContentForRecipeName:searchString];
    
    if (self.searchController.searchResultsController) {
        UINavigationController *navController = (UINavigationController *)self.searchController.searchResultsController;

        SearchResultsTableViewController *vc = (SearchResultsTableViewController *)navController.topViewController;
        vc.searchResults = self.searchResults;
        [vc.tableView reloadData];
    }
}

#pragma mark - UISearchBarDelegate

// Workaround for bug: -updateSearchResultsForSearchController: is not called when scope buttons change
- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    [self updateSearchResultsForSearchController:self.searchController];
}


#pragma mark - Content Filtering

-(void)updateFilteredContentForRecipeName:(NSString *)recipeName {
    
    // Update the filtered array based on the search.
    
    [self.searchResults removeAllObjects]; // First clear the filtered array.
    
    /*  Search the main list for recipes whose name matches searchText; add items that match to the filtered array.
     */
    for (Recipe *recipe in self.recipes) {
        NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
        NSRange recipeNameRange = NSMakeRange(0, recipe.title.length);
        NSRange foundRange = [recipe.title rangeOfString:recipeName options:searchOptions range:recipeNameRange];
        if (foundRange.length > 0) {
            [self.searchResults addObject:recipe];
        }
    }
}

@end
