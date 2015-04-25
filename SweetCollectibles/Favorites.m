//
//  Favorites.m
//  SweetCollectibles
//
//  Created by it-högskolan on 2015-04-15.
//  Copyright (c) 2015 it-högskolan. All rights reserved.
//

#import "Favorites.h"
#import "AppDelegate.h"
#import "CustomRecipeCell.h"
#import "AddToFavorites.h"
#import "Recipe.h"
#import "RecipeInfo.h"

@interface Favorites ()

@property (strong, nonatomic) AppDelegate *delegate;
@property (strong, nonatomic) NSManagedObjectContext *context;
@property (nonatomic) NSArray *fetchedObjects;

@end

@implementation Favorites

-(void) viewWillAppear:(BOOL)animated {
    self.delegate = [UIApplication sharedApplication].delegate;
    self.context = self.delegate.managedObjectContext;
    [self fetchFavoriteRecipes];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UINib *recipeNib = [UINib nibWithNibName:@"CustomRecipeCell" bundle:nil];
    [self.tableView registerNib:recipeNib
         forCellReuseIdentifier:@"RecipeCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.fetchedObjects.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomRecipeCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"RecipeCell" forIndexPath:indexPath];
    Recipe *recipe = nil;
    recipe = [self.fetchedObjects objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.recipeLabel.text = recipe.title;
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.numberOfLines = 1;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"ShowDetailViewForFavorites" sender:tableView];
}


-(void) fetchFavoriteRecipes {
    
    NSFetchRequest *fetchRequest;
    NSError *error;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"favorite = %@", @1];
    
    fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *recipe = [NSEntityDescription entityForName:@"Recipe"
                                              inManagedObjectContext:self.context];
    [fetchRequest setEntity:recipe];
    [fetchRequest setPredicate:predicate];
    self.fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    self.fetchedObjects = [self.fetchedObjects sortedArrayUsingDescriptors:@[sd]];    
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


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"ShowDetailViewForFavorites"])
    {
        RecipeInfo *recipeInfo = [segue destinationViewController];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        recipeInfo.recipe = [self.fetchedObjects objectAtIndex:indexPath.row];
    } else if ([segue.identifier isEqualToString:@"AddToFavorites"]) {
      //Just go to view
    } else {
        NSLog(@"You forgot the segue %@",segue);
    }
}


@end
