//
//  AllRecipes.m
//  SweetCollectibles
//
//  Created by it-högskolan on 2015-04-15.
//  Copyright (c) 2015 it-högskolan. All rights reserved.
//

#import "AllRecipes.h"
#import "AppDelegate.h"
#import "Recipe.h"
#import "RecipeDetail.h"
#import "Ingredient.h"
#import "RecipeCell.h"
#import "RecipeInfo.h"

@interface AllRecipes ()
@property (nonatomic) NSArray *fetchedObjects;
@property (nonatomic) NSArray *titlesArray;
@property (nonatomic) NSMutableArray *sectionRecipeTitles;
@property (nonatomic) NSArray *recipeIndexTitles;
@property (nonatomic) NSMutableArray *filteredResult;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation AllRecipes

- (void)viewWillAppear:(BOOL)animated {
   // self.searchBar.showsCancelButton = YES;
    [self.tableView reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.filteredResult = [[NSMutableArray alloc] init];
    self.sectionRecipeTitles = [[NSMutableArray alloc] init];
    self.recipeIndexTitles = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
    //[self addNewRecipe];
    [self fetchRecipes];
    [self createArrayForSectionRecipeTitles];
    [self.tableView registerClass: [RecipeCell class] forCellReuseIdentifier:@"FilteredCell"];
}

/*- (void)viewDidUnload
{
    [ self.filteredResult removeAllObjects];
}*/

-(void)addNewRecipe {
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = delegate.managedObjectContext;
    // Camera app maybe ???
    //NSString *picturePath = [[NSBundle mainBundle] pathForResource:@"nutellalayercake" ofType:@"jpg"];
    //NSLog(@"Picture path: %@", picturePath);
    //UIImage *picture = [UIImage imageWithContentsOfFile:picturePath];
    UIImage *picture =[UIImage imageNamed: @"nutellalayercake"];
    NSData *cakePicture = UIImageJPEGRepresentation(picture, 1.0f);
    NSLog(@"Image size: %lu", (unsigned long)cakePicture.length);
    
    // Creating a recipe
    Recipe *recipe = [NSEntityDescription insertNewObjectForEntityForName:@"Recipe" inManagedObjectContext:context];
    recipe.title = @"Best Ever Chocolate and Nutella Layer Cake";
    recipe.picture = cakePicture;
    recipe.category = [self convertEnumToNumber:chocolateLayerCake];
    NSString *assemble = @"Put a dollop of frosting on a 7-inch round cake board (or cake plate) or 8-inch scalloped cake board.*Put your first layer top-up on the cake board or plate, and spread about 1 cup of frosting evenly across layer. Put the second cake layer on top and repeat with another layer of frosting. Put the final cake layer top-down. Cover the cake with plastic wrap and wiggle the layers into place. Refrigerate the cake for about 30 minutes.*Using a turntable, if possible, frost entire outside of cake with a thin layer of frosting to seal in the crumbs. Chill until the frosting begins to firm-up, about 15 minutes. Repeat with another thin layer of frosting, this time working to achieve a smooth finish. Chill for another 15 minutes.*Apply a third coat of frosting to the cake. Holding a tall pastry comb in your dominant hand, press it gently against the side of the cake and keep it steady. Use the other hand to slowly rotate the turntable until you have gone all the way around the cake. Gently press some chocolate sprinkles around the bottom edge of the cake.*Fit a medium pastry bag with a medium-large closed star tip, such as 1M, and fill about 2/3 full with frosting. Pipe a border around the top of the cake. Chill the cake until the frosting border firms up, at least 30 minutes.*Cover the top of the cake (but not the piped border) with chocolate sprinkles. Once frosting softens again, the sprinkles will adhere to top. The cake will keep refrigerated for up to 3 days.*";
    recipe.howToAssemble = assemble;
    
    
    // Creating recipe details - cake
    RecipeDetail *cake = [NSEntityDescription insertNewObjectForEntityForName:@"RecipeDetail" inManagedObjectContext:context];
    cake.recipe = recipe;
    cake.subTitle = @"For the Cake:";
    NSString *cakeInstructions = @"Preheat oven to 180° C. Prepare three 7-inch round cake pans with nonstick spray and parchment rounds.*In bowl of electric mixer fitted with the whisk attachment, sift all dry ingredients, including sugar. Combine eggs, buttermilk, coffee, oil and vanilla in a measuring cup and beat lightly with a fork.*Add milk mixture to the dry ingredients mix for 1 minute on medium speed (you may need the plastic splash-guard that comes with mixer). Divide batter evenly among prepared pans--each pan should contain about 600 grams of batter.*Bake the first 2 layers for 20 minutes and rotate pans in oven. Continue to bake until toothpick or skewer comes almost clean (a few crumbs), about 5 more minutes. Cool on wire racks for 20 minutes. Repeat with remaining layer, and then gently invert onto racks until completely cool.*";
    
   cake.instructions = cakeInstructions;
    
    // Creating ingredients for cake
    Ingredient *cakeIngredient1 = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
    cakeIngredient1.ingredientType = @"(2 1/4 cups) all-purpose flour";
    cakeIngredient1.amount = @285;
    cakeIngredient1.unitOfMeasure = @"grams";
    cakeIngredient1.recipeDetail = cake;
    [cake addIngredientsObject:cakeIngredient1];
    
    Ingredient *cakeIngredient2 = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
    cakeIngredient2.ingredientType = @"(2 1/3 cups) superfine sugar";
    cakeIngredient2.amount = @470;
    cakeIngredient2.unitOfMeasure = @"grams";
    cakeIngredient2.recipeDetail = cake;
    [cake addIngredientsObject:cakeIngredient2];
    
    Ingredient *cakeIngredient3 = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
    cakeIngredient3.ingredientType = @"(3/4 cup) dark Dutch-process cocoa powder";
    cakeIngredient3.amount = @90;
    cakeIngredient3.unitOfMeasure = @"grams";
    cakeIngredient3.recipeDetail = cake;
    [cake addIngredientsObject:cakeIngredient3];
    
    Ingredient *cakeIngredient4 = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
    cakeIngredient4.ingredientType = @"(12 grams) baking soda";
    cakeIngredient4.amount = @2.5;
    cakeIngredient4.unitOfMeasure = @"teaspoons";
    cakeIngredient4.recipeDetail = cake;
    [cake addIngredientsObject:cakeIngredient4];
    
    Ingredient *cakeIngredient5 = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
    cakeIngredient5.ingredientType = @"(10 grams) baking powder";
    cakeIngredient5.amount = @2;
    cakeIngredient5.unitOfMeasure = @"teaspoons";
    cakeIngredient5.recipeDetail = cake;
    [cake addIngredientsObject:cakeIngredient5];
    
    Ingredient *cakeIngredient6 = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
    cakeIngredient6.ingredientType = @"(8 grams) salt";
    cakeIngredient6.amount = @1;
    cakeIngredient6.unitOfMeasure = @"teaspoon";
    cakeIngredient6.recipeDetail = cake;
    [cake addIngredientsObject:cakeIngredient6];
    
    Ingredient *cakeIngredient7 = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
    cakeIngredient7.ingredientType = @"(1 1/4 cups) buttermilk";
    cakeIngredient7.amount = @300;
    cakeIngredient7.unitOfMeasure = @"ml";
    cakeIngredient7.recipeDetail = cake;
    [cake addIngredientsObject:cakeIngredient7];
    
    Ingredient *cakeIngredient8 = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
    cakeIngredient8.ingredientType = @"(3/4 cup) brewed coffee or espresso";
    cakeIngredient8.amount = @180;
    cakeIngredient8.unitOfMeasure = @"ml";
    cakeIngredient8.recipeDetail = cake;
    [cake addIngredientsObject:cakeIngredient8];
    
    Ingredient *cakeIngredient9 = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
    cakeIngredient9.ingredientType = @"(2/3 cup) vegetable oil";
    cakeIngredient9.amount = @160;
    cakeIngredient9.unitOfMeasure = @"ml";
    cakeIngredient9.recipeDetail = cake;
    [cake addIngredientsObject:cakeIngredient9];
    
    Ingredient *cakeIngredient10 = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
    cakeIngredient10.ingredientType = @"eggs, room temperature";
    cakeIngredient10.amount = @3;
    //cakeIngredient10.unit_of_measure = @"";
    cakeIngredient10.recipeDetail = cake;
    [cake addIngredientsObject:cakeIngredient10];
    
    Ingredient *cakeIngredient11 = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
    cakeIngredient11.ingredientType = @"(15 ml) pure vanilla extract";
    cakeIngredient11.amount = @1;
    cakeIngredient11.unitOfMeasure = @"tablespoon";
    cakeIngredient11.recipeDetail = cake;
    [cake addIngredientsObject:cakeIngredient11];
    
    // Add details of cake to recipe
    [recipe addRecipeDetailsObject:cake];
    
    
    // Creating recipe details - frosting
    RecipeDetail *frosting = [NSEntityDescription insertNewObjectForEntityForName:@"RecipeDetail" inManagedObjectContext:context];
    frosting.recipe = recipe;
    frosting.subTitle = @"For the Chocolate Frosting:";
    NSString *frostingInstructions = @"Put all of the ingredients in a food processor, and pulse until smooth and glossy, about 1 minute. The frosting will be very soft. Refrigerate the frosting until it thickens slightly, about 15 minutes.*";
    frosting.instructions = frostingInstructions;
    
    
    // Creating ingredients for frosting
    Ingredient *frostingIngredient1 = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
    frostingIngredient1.ingredientType = @"(4 1/2 cups) confectioners' sugar";
    frostingIngredient1.amount = @565;
    frostingIngredient1.unitOfMeasure = @"grams";
    frostingIngredient1.recipeDetail = frosting;
    [frosting addIngredientsObject:frostingIngredient1];
    
    Ingredient *frostingIngredient2 = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
    frostingIngredient2.ingredientType = @"(1 1/2 cups) unsalted butter, room temperature ";
    frostingIngredient2.amount = @340;
    frostingIngredient2.unitOfMeasure = @"";
    frostingIngredient2.recipeDetail = frosting;
    [frosting addIngredientsObject:frostingIngredient2];
    
    Ingredient *frostingIngredient3 = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
    frostingIngredient3.ingredientType = @"(1 cup) Nutella";
    frostingIngredient3.amount = @280;
    frostingIngredient3.unitOfMeasure = @"grams";
    frostingIngredient3.recipeDetail = frosting;
    [frosting addIngredientsObject:frostingIngredient3];
    
    Ingredient *frostingIngredient4 = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
    frostingIngredient4.ingredientType = @"(3/4 cup) full-fat sour cream";
    frostingIngredient4.amount = @180;
    frostingIngredient4.unitOfMeasure = @"ml";
    frostingIngredient4.recipeDetail = frosting;
    [frosting addIngredientsObject:frostingIngredient4];
    
    Ingredient *frostingIngredient5 = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
    frostingIngredient5.ingredientType = @"best-quality dark chocolate, melted and cooled slightly";
    frostingIngredient5.amount = @330;
    frostingIngredient5.unitOfMeasure = @"grams";
    frostingIngredient5.recipeDetail = frosting;
    [frosting addIngredientsObject:frostingIngredient5];
    
    Ingredient *frostingIngredient6 = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
    frostingIngredient6.ingredientType = @"(15 ml) pure vanilla extract";
    frostingIngredient6.amount = @1;
    frostingIngredient6.unitOfMeasure = @"tablespoon";
    frostingIngredient6.recipeDetail = frosting;
    [frosting addIngredientsObject:frostingIngredient6];
    
    Ingredient *frostingIngredient7 = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
    frostingIngredient7.ingredientType = @"salt, just a pinch";
    //frostingIngredient7.amount = @0;
    //frostingIngredient7.unitOfMeasure = @"";
    frostingIngredient7.recipeDetail = frosting;
    [frosting addIngredientsObject:frostingIngredient7];
    
    // Add details of frosting to recipe
    [recipe addRecipeDetailsObject:frosting];
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    } else {
        NSLog(@"Recipe successfully saved!");
    }
}

-(NSNumber*)convertEnumToNumber:(NSInteger) category {
    
    return [NSNumber numberWithInteger:category];
}

-(void)fetchRecipes{
    
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = delegate.managedObjectContext;
    NSError *error;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *recipe = [NSEntityDescription entityForName:@"Recipe"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:recipe];
    self.fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    self.fetchedObjects = [self.fetchedObjects sortedArrayUsingDescriptors:@[sd]];
    
}

-(void)sortFetchedObjects{
    NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
        self.fetchedObjects = [self.fetchedObjects sortedArrayUsingDescriptors:@[sd]];
}

-(void) createArrayForSectionRecipeTitles {
    Recipe *recipe;
    NSString *firstLetter;
    [self sortFetchedObjects];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = YES;
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = NO;
    return YES;
}*/

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //return self.sectionRecipeTitles.count + 1;
    if(self.tableView == tableView) {
        return self.sectionRecipeTitles.count;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    /*if (section == 0) {
        return 1;
    }*/
    if (self.tableView == tableView) {
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
    } else {
        return self.filteredResult.count;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSLog(@"In titleForHeaderInSection()");
    if (self.tableView == tableView) {
        NSLog(@"In titleForHeaderInSection() - original tableview");
        return [self.sectionRecipeTitles objectAtIndex:section];
    } else {
        NSLog(@"In titleForHeaderInSection() - filtered tableview");
        return nil;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UILabel *recipeNameLabel;
     Recipe *recipe;
    
    NSString *cellIdentifier = @"";
    
    if (tableView == self.tableView) {
        cellIdentifier = @"AllRecipes";
    } else {
        cellIdentifier = @"FilteredCell";
    }
    RecipeCell *cell = (RecipeCell*)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    recipeNameLabel = (UILabel *)[cell.contentView viewWithTag:1];
    //SearchResultCell *cell = ( SearchResultCell*)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (tableView == self.tableView) {
        //recipeNameLabel = (UILabel*)[cell.contentView viewWithTag:1];
        NSString *sectionTitle = [self.sectionRecipeTitles objectAtIndex:indexPath.section];
        NSMutableArray *allRecipes = [[NSMutableArray alloc]init];
        NSString *firstLetter;
        for (int i=0; i<self.fetchedObjects.count; i++) {
            recipe = self.fetchedObjects[i];
            firstLetter = [recipe.title substringToIndex:1];
            if ([sectionTitle isEqualToString:firstLetter]) {
                [allRecipes addObject:recipe];
            }
        }
        recipe = [allRecipes objectAtIndex:indexPath.row];
        //cell.searchResultTitle.text = recipe.title;
    } else {
        //recipeNameLabel = (UILabel*)[cell.contentView viewWithTag:2];
        recipe = self.filteredResult[indexPath.row];
        //cell.filteredCellTitle.text = recipe.title;
    }
    recipeNameLabel.text = recipe.title;
    NSLog(@"In deque, recipeNameLabel.text: %@",recipeNameLabel.text);
    cell.recipeTitle = recipe.title;
    NSLog(@"In deque, cell.recipeTitle: %@",recipe.title);
    return cell;
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (self.tableView == tableView) {
        return self.recipeIndexTitles;
    } else {
        return nil;
    }
   // return [[NSArray arrayWithObject:@"{search}"] arrayByAddingObjectsFromArray:self.recipeIndexTitles];
}


- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (self.tableView == tableView) {
        return [self.sectionRecipeTitles indexOfObject:title];
    } else {
        return 0;
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"In textDidChange()");
    [self.filteredResult removeAllObjects];
    for (Recipe *recipe in self.fetchedObjects) {
        NSComparisonResult result = [recipe.title compare:searchText
                                                  options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch)
                                                    range:NSMakeRange(0, [searchText length])];
        if (result == NSOrderedSame)
        {
            NSLog(@"Adding recipe.title '%@' to searchResults as it begins with search text '%@'", recipe.title, searchText);
            [self.filteredResult addObject:recipe];
            NSLog(@"Number of items in filtered result: %lu",(unsigned long)self.filteredResult.count);
        }
    }
    NSLog(@"Number of items in filtered result: %lu",(unsigned long)self.filteredResult.count);
    [self.tableView reloadData];
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

-(Recipe*)getRecipeObject:(NSString*)recipeTitle {
    Recipe *recipe;
    for (int i=0; i<self.fetchedObjects.count; i++) {
        recipe = self.fetchedObjects[i];
        if ([recipeTitle isEqualToString:recipe.title]) {
            return recipe;
        }
    }
    return nil;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    RecipeInfo *recipeInfo = [segue destinationViewController];
    RecipeCell *cell = (RecipeCell*)sender;
    if ([segue.identifier isEqualToString:@"fromAllRecipes"] ) {
        //NSLog(@"All Recipes");
        //NSLog(cell.recipeTitle);
        recipeInfo.recipe = [self getRecipeObject:cell.recipeTitle];
    } else {
        NSLog(@"You forgot the segue %@",segue);
    }
}

@end
