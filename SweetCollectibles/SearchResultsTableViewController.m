//
//  SearchResultsTableViewController.m
//  Sample-UISearchController
//
//  Created by James Dempsey on 9/20/14.
//  Copyright (c) 2014 Tapas Software. All rights reserved.
//

#import "SearchResultsTableViewController.h"
#import "RecipeInfo.h"
#import "Recipe.h"

@implementation SearchResultsTableViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.searchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SearchResultCell" forIndexPath:indexPath];

    Recipe *recipe = [self.searchResults objectAtIndex:indexPath.row];

    cell.textLabel.text = recipe.title;

    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Recipe *recipe = [self.searchResults objectAtIndex:indexPath.row];
    RecipeInfo *vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"DetailViewController"];
    self.presentingViewController.navigationItem.title = @"Search";
    vc.recipe = recipe;
    [self.presentingViewController.navigationController pushViewController:vc animated:YES];
}


@end
