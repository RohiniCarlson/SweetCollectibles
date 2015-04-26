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
@property (nonatomic) NSMutableArray *fetchedObjects;

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


-(void) fetchFavoriteRecipes {
    
    NSFetchRequest *fetchRequest;
    NSError *error;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"favorite = %@", @1];
    
    fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *recipe = [NSEntityDescription entityForName:@"Recipe"
                                              inManagedObjectContext:self.context];
    [fetchRequest setEntity:recipe];
    [fetchRequest setPredicate:predicate];
    self.fetchedObjects = [[self.context executeFetchRequest:fetchRequest error:&error]mutableCopy];
    NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    self.fetchedObjects = [[self.fetchedObjects sortedArrayUsingDescriptors:@[sd]]mutableCopy];
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSManagedObject *recipeObject;
    NSError *error = nil;
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        recipeObject = (NSManagedObject *)[self.fetchedObjects objectAtIndex:indexPath.row];
        [recipeObject setValue:@0 forKey:@"favorite"];
        if (![recipeObject.managedObjectContext save:&error]) {
            NSLog(@"Unable to save managed object context.");
            NSLog(@"%@, %@", error, error.localizedDescription);
        }
        [self.fetchedObjects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"ShowDetailView" sender:tableView];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowDetailView"])
    {
        RecipeInfo *recipeInfo = [segue destinationViewController];
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        
        recipeInfo.recipe = [self.fetchedObjects objectAtIndex:indexPath.row];
        
    } else {
        
        NSLog(@"You forgot the segue %@",segue);
    }
}

@end
