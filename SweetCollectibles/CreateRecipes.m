//
//  CreateRecipes.m
//  SweetCollectibles
//
//  Created by it-högskolan on 2015-04-26.
//  Copyright (c) 2015 it-h&#246;gskolan. All rights reserved.
//

#import "CreateRecipes.h"
#import "AppDelegate.h"
#import "Recipe.h"
#import "RecipeDetail.h"
#import "Ingredient.h"

@implementation CreateRecipes


-(void)addRecipes {
    // Do a fetch to check if there are records before inserting.
    NSError *error;
    NSFetchRequest *fetchRequest;
    NSManagedObjectContext *context;
    AppDelegate *delegate;
    NSArray *fetchedObjects;
    delegate = [UIApplication sharedApplication].delegate;
    context = delegate.managedObjectContext;
    
    fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *recipe = [NSEntityDescription entityForName:@"Recipe"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:recipe];
    fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    fetchedObjects = [fetchedObjects sortedArrayUsingDescriptors:@[sd]];
    if (fetchedObjects.count == 0) {
        [self addRecipe1];
        [self addRecipe2];
    }
}

-(NSNumber*)convertEnumToNumber:(NSInteger) category {
    
    return [NSNumber numberWithInteger:category];
}

-(void)addRecipe1 {
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = delegate.managedObjectContext;
    UIImage *picture =[UIImage imageNamed: @"nutellalayercake"];
    NSData *cakePicture = UIImageJPEGRepresentation(picture, 1.0f);
    //NSLog(@"Image size: %lu", (unsigned long)cakePicture.length);
    
    // Creating a recipe
    Recipe *recipe = [NSEntityDescription insertNewObjectForEntityForName:@"Recipe" inManagedObjectContext:context];
    recipe.title = @"Best Ever Chocolate and Nutella Layer Cake";
    recipe.picture = cakePicture;
    recipe.category = [self convertEnumToNumber:chocolateLayerCake];
    NSString *assemble = @"Put a dollop of frosting on a 7-inch round cake board (or cake plate) or 8-inch scalloped cake board.*Put your first layer top-up on the cake board or plate, and spread about 1 cup of frosting evenly across layer. Put the second cake layer on top and repeat with another layer of frosting. Put the final cake layer top-down. Cover the cake with plastic wrap and wiggle the layers into place. Refrigerate the cake for about 30 minutes.*Using a turntable, if possible, frost entire outside of cake with a thin layer of frosting to seal in the crumbs. Chill until the frosting begins to firm-up, about 15 minutes. Repeat with another thin layer of frosting, this time working to achieve a smooth finish. Chill for another 15 minutes.*Apply a third coat of frosting to the cake. Holding a tall pastry comb in your dominant hand, press it gently against the side of the cake and keep it steady. Use the other hand to slowly rotate the turntable until you have gone all the way around the cake. Gently press some chocolate sprinkles around the bottom edge of the cake.*Fit a medium pastry bag with a medium-large closed star tip, such as 1M, and fill about 2/3 full with frosting. Pipe a border around the top of the cake. Chill the cake until the frosting border firms up, at least 30 minutes.*Cover the top of the cake (but not the piped border) with chocolate sprinkles. Once frosting softens again, the sprinkles will adhere to top. The cake will keep refrigerated for up to 3 days.";
    recipe.howToAssemble = assemble;
    
    
    // Creating recipe details - cake
    RecipeDetail *cake = [NSEntityDescription insertNewObjectForEntityForName:@"RecipeDetail" inManagedObjectContext:context];
    cake.recipe = recipe;
    cake.subTitle = @"For the Cake:";
    NSString *cakeInstructions = @"Preheat oven to 350°F (180° C). Prepare three 7-inch round cake pans with nonstick spray and parchment rounds.*In bowl of electric mixer fitted with the whisk attachment, sift all dry ingredients, including sugar. Combine eggs, buttermilk, coffee, oil and vanilla in a measuring cup and beat lightly with a fork.*Add milk mixture to the dry ingredients mix for 1 minute on medium speed (you may need the plastic splash-guard that comes with mixer). Divide batter evenly among prepared pans--each pan should contain about 600 grams of batter.*Bake the first 2 layers for 20 minutes and rotate pans in oven. Continue to bake until toothpick or skewer comes almost clean (a few crumbs), about 5 more minutes. Cool on wire racks for 20 minutes. Repeat with remaining layer, and then gently invert onto racks until completely cool.";
    
    cake.instructions = cakeInstructions;
    
    // Creating ingredients for cake
    Ingredient *cakeIngredient1 = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
    cakeIngredient1.ingredientType = @"(2 1/4 cups) all-purpose flour";
    cakeIngredient1.amount = @285;
    cakeIngredient1.unitOfMeasure = @"g";
    cakeIngredient1.recipeDetail = cake;
    [cake addIngredientsObject:cakeIngredient1];
    
    Ingredient *cakeIngredient2 = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
    cakeIngredient2.ingredientType = @"(2 1/3 cups) superfine sugar";
    cakeIngredient2.amount = @470;
    cakeIngredient2.unitOfMeasure = @"g";
    cakeIngredient2.recipeDetail = cake;
    [cake addIngredientsObject:cakeIngredient2];
    
    Ingredient *cakeIngredient3 = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
    cakeIngredient3.ingredientType = @"(3/4 cup) dark Dutch-process cocoa powder";
    cakeIngredient3.amount = @90;
    cakeIngredient3.unitOfMeasure = @"g";
    cakeIngredient3.recipeDetail = cake;
    [cake addIngredientsObject:cakeIngredient3];
    
    Ingredient *cakeIngredient4 = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
    cakeIngredient4.ingredientType = @"(2 1/2 teaspoons) baking soda";
    cakeIngredient4.amount = @12;
    cakeIngredient4.unitOfMeasure = @"g";
    cakeIngredient4.recipeDetail = cake;
    [cake addIngredientsObject:cakeIngredient4];
    
    Ingredient *cakeIngredient5 = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
    cakeIngredient5.ingredientType = @"2 teaspoons baking powder";
    cakeIngredient5.amount = @10;
    cakeIngredient5.unitOfMeasure = @"g";
    cakeIngredient5.recipeDetail = cake;
    [cake addIngredientsObject:cakeIngredient5];
    
    Ingredient *cakeIngredient6 = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
    cakeIngredient6.ingredientType = @"(1 teaspoon) salt";
    cakeIngredient6.amount = @8;
    cakeIngredient6.unitOfMeasure = @"g";
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
    cakeIngredient11.ingredientType = @"(1 tablespoon) pure vanilla extract";
    cakeIngredient11.amount = @15;
    cakeIngredient11.unitOfMeasure = @"ml";
    cakeIngredient11.recipeDetail = cake;
    [cake addIngredientsObject:cakeIngredient11];
    
    // Add details of cake to recipe
    [recipe addRecipeDetailsObject:cake];
    
    
    // Creating recipe details - frosting
    RecipeDetail *frosting = [NSEntityDescription insertNewObjectForEntityForName:@"RecipeDetail" inManagedObjectContext:context];
    frosting.recipe = recipe;
    frosting.subTitle = @"For the Chocolate Frosting:";
    NSString *frostingInstructions = @"Put all of the ingredients in a food processor, and pulse until smooth and glossy, about 1 minute. The frosting will be very soft. Refrigerate the frosting until it thickens slightly, about 15 minutes.";
    frosting.instructions = frostingInstructions;
    
    
    // Creating ingredients for frosting
    Ingredient *frostingIngredient1 = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
    frostingIngredient1.ingredientType = @"(4 1/2 cups) confectioners' sugar";
    frostingIngredient1.amount = @565;
    frostingIngredient1.unitOfMeasure = @"g";
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
    frostingIngredient3.unitOfMeasure = @"g";
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
    frostingIngredient5.unitOfMeasure = @"g";
    frostingIngredient5.recipeDetail = frosting;
    [frosting addIngredientsObject:frostingIngredient5];
    
    Ingredient *frostingIngredient6 = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
    frostingIngredient6.ingredientType = @"(1 teaspoon) pure vanilla extract";
    frostingIngredient6.amount = @15;
    frostingIngredient6.unitOfMeasure = @"ml";
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
        NSLog(@"Recipe for : %@ saved!",recipe.title);
    }
}

-(void) addRecipe2{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = delegate.managedObjectContext;
    UIImage *picture =[UIImage imageNamed: @"perfectlydelightful"];
    NSData *cakePicture = UIImageJPEGRepresentation(picture, 1.0f);
    
    // Creating a recipe
    Recipe *recipe = [NSEntityDescription insertNewObjectForEntityForName:@"Recipe" inManagedObjectContext:context];
    recipe.title = @"Perfectly Delightful Vanilla Birthday Cake";
    recipe.picture = cakePicture;
    recipe.category = [self convertEnumToNumber:vanillaLayerCake];
    NSString *assemble = @"Trim any doming or top crust from cake layers using a very sharp serrated knife.*Use a cake turntable for filling, frosting and decorating, if a possible. Place a small dollop of frosting in the center of a cake plate or 8″ round thin foil-covered cake board, and place the bottom cake layer on top, face-up.*Place ~1 cup of frosting on top of the cake layer, and spread evenly with a small offset palette knife. Gently place 2nd cake layer, face up, on top. Repeat until you come to your 4th layer, which you will place face down.*Put a generous scoop of frosting on top, spreading evenly with a small offset palette knife and working your way down the sides until you have a thin layer of frosting over the entire cake. Chill until set, about 30 minutes.*Remove from refrigerator and apply another 'coat' of frosting.*For the top of the cake border, place a large star decorating tip in a large Decorating Bag filled no more than 1/2 full with pink frosting.*Hold pastry bag in one hand (your dominant hand) and slowly rotate the turntable with the other. Holding frosting-filled bag at a directly above the top of the cake (90° angle), squeeze a small bit of frosting and turn the table a bit at the same time, releasing pressure slowly then stop (this will create a tapered decoration). Repeat all the way around the cake, overlapping slightly each time you pipe a new 'shell.'*For bottom border, you will want to have the cake on the plate or pedestal which you plan to serve it upon. Fill another pastry bag the same way, and this time use tip 1M. You will pipe at about a 45° angle this time (give or take). Sprinkle with your favourite sugar pearls or sprinkles atop the top border. For some kitschy charm, add a few Vintage Ballerina Cupcake Toppers to your cake!*Store, covered in a cake dome, at room temperature for up to 2 days, or in refrigerator for up to 5 days. Best enjoyed day 1 or 2 at room temperature.";
    recipe.howToAssemble = assemble;
    
    // Creating recipe details - cake
    RecipeDetail *cake = [NSEntityDescription insertNewObjectForEntityForName:@"RecipeDetail" inManagedObjectContext:context];
    cake.recipe = recipe;
    cake.subTitle = @"For the Cake:";
    NSString *cakeInstructions = @"Preheat oven to 350°F (180°C). Grease, line with parchment and flour two round 8-inch pans (you will be using each one twice), or four 8-inch pans (if you're lucky enough to have four on hand).*In a medium bowl or measuring cup, combine and stir 1/2 cup of the milk, stir the egg whites, whole egg, vanilla and the almond extract. Set aside.*Sift cake flour twice. In the bowl of an electric mixer fitted with the paddle attachment, combine the dry ingredients, including the sugar, together on low-speed (I use the “stir” setting on my mixer) for 30 seconds.*Add the butter and shortening, blending on low-speed for about 30 seconds, then add remaining 1 cup of milk, and mix on low-speed until just moistened. Increase to medium speed and mix for 1 -1/2 minutes (90 seconds), but no more.*Scrape the sides of the bowl and begin to add the egg/milk/extract mixture in 3 separate batches; beat on medium speed for 20 seconds after each addition.*Pour 1/4 of your batter (~2 cups)(445 grams) into each prepared pan (if you have 2 pans, you will bake 2 layers first followed by the remaining 2), spreading it evenly with a small offset palette knife. If possible, weigh the batter in the pans to ensure 2 even layers.*Bake cake layers two-at-a-time in center of oven and 2 inches apart for 20 minutes or until a cake tester comes clean when inserted into the center. Be so careful to not over-bake. Check cake at 20 minutes, but not before, and once you feel it’s almost ready, set the timer for 2 minute intervals. Let cool on racks for 10 minutes before loosening the sides with a small metal spatula, and invert onto greased wire racks. Gently turn cakes back up, so the tops are up and cool completely.*Wash the 2 cake pans and line, grease and flour again and repeat.*Wrap tightly and store at room temperature for up to 2 days, refrigerator for up to 5 days, or frozen for up to 2 months. Best enjoyed day 1 or 2.";
    cake.instructions = cakeInstructions;
    
    // Creating ingredients for cake
    Ingredient *cakeIngredient1 = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
    cakeIngredient1.ingredientType = @"(1-1/2 cups) whole milk, at room temperature";
    cakeIngredient1.amount = @360;
    cakeIngredient1.unitOfMeasure = @"ml";
    cakeIngredient1.recipeDetail = cake;
    [cake addIngredientsObject:cakeIngredient1];
    
    Ingredient *cakeIngredient2 = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
    cakeIngredient2.ingredientType = @"(210 g) large egg whites, at room temperature";
    cakeIngredient2.amount = @7;
    //cakeIngredient2.unitOfMeasure = @"ml";
    cakeIngredient2.recipeDetail = cake;
    [cake addIngredientsObject:cakeIngredient2];
    
    Ingredient *cakeIngredient3 = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
    cakeIngredient3.ingredientType = @"whole egg, at room temperature";
    cakeIngredient3.amount = @1;
    //cakeIngredient2.unitOfMeasure = @"ml";
    cakeIngredient3.recipeDetail = cake;
    [cake addIngredientsObject:cakeIngredient3];

    Ingredient *cakeIngredient4 = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
    cakeIngredient4.ingredientType = @"(1 tablespoon) pure vanilla extract";
    cakeIngredient4.amount = @15;
    cakeIngredient2.unitOfMeasure = @"ml";
    cakeIngredient4.recipeDetail = cake;
    [cake addIngredientsObject:cakeIngredient4];
    
    Ingredient *cakeIngredient5 = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
    cakeIngredient5.ingredientType = @"(1/2 teaspoon) almond extract";
    cakeIngredient5.amount = @2.5;
    cakeIngredient5.unitOfMeasure = @"ml";
    cakeIngredient5.recipeDetail = cake;
    [cake addIngredientsObject:cakeIngredient5];
    
    Ingredient *cakeIngredient6 = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
    cakeIngredient6.ingredientType = @"(3-3/4 cups) cake flour, sifted";
    cakeIngredient6.amount = @430;
    cakeIngredient6.unitOfMeasure = @"g";
    cakeIngredient6.recipeDetail = cake;
    [cake addIngredientsObject:cakeIngredient6];
    
    Ingredient *cakeIngredient7 = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
    cakeIngredient7.ingredientType = @"(2-1/4 cups) sugar";
    cakeIngredient7.amount = @450;
    cakeIngredient7.unitOfMeasure = @"g";
    cakeIngredient7.recipeDetail = cake;
    [cake addIngredientsObject:cakeIngredient7];
    
    Ingredient *cakeIngredient8 = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
    cakeIngredient8.ingredientType = @"(1-3/4 tablespoons) baking powder";
    cakeIngredient8.amount = @25;
    cakeIngredient8.unitOfMeasure = @"g";
    cakeIngredient8.recipeDetail = cake;
    [cake addIngredientsObject:cakeIngredient8];
    
    Ingredient *cakeIngredient9 = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
    cakeIngredient9.ingredientType = @"(1 teaspoon) salt";
    cakeIngredient9.amount = @8;
    cakeIngredient9.unitOfMeasure = @"g";
    cakeIngredient9.recipeDetail = cake;
    [cake addIngredientsObject:cakeIngredient9];
    
    Ingredient *cakeIngredient10 = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
    cakeIngredient10.ingredientType = @"(1-1/2 sticks) unsalted butter, at room temperature and cut into cubes";
    cakeIngredient10.amount = @170;
    cakeIngredient10.unitOfMeasure = @"g";
    cakeIngredient10.recipeDetail = cake;
    [cake addIngredientsObject:cakeIngredient10];
    
    Ingredient *cakeIngredient11 = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
    cakeIngredient11.ingredientType = @"(6 tablespoon) vegetable shortening";
    cakeIngredient11.amount = @85;
    cakeIngredient11.unitOfMeasure = @"g";
    cakeIngredient11.recipeDetail = cake;
    [cake addIngredientsObject:cakeIngredient11];
    
    // Add details of cake to recipe
    [recipe addRecipeDetailsObject:cake];
    
    // Creating recipe details - frosting
    RecipeDetail *frosting = [NSEntityDescription insertNewObjectForEntityForName:@"RecipeDetail" inManagedObjectContext:context];
    frosting.recipe = recipe;
    frosting.subTitle = @"For the Whipped Vanilla Frosting:";
    NSString *frostingInstructions = @"In the bowl of an electric mixer fitted with the paddle attachment, whip butter for 8 minutes on medium speed. Butter will become very pale & creamy.*Add remaining ingredients and mix on low-speed for 1 minute, then on medium speed for 6 minutes. Frosting will be very light, creamy, and fluffy. If you want all of your frosting (for filling and frosting cake) pink, then add a drop of pink gel colour and mix again, adding one drop at a time until desired pink shade is achieved. If you want just the outside of the cake pink, you will fill the cake layers first, and then colour the remaining frosting pink.*Best used right away (for ideal spreading consistency), but keeps well once frosted.";
    frosting.instructions = frostingInstructions;
    
    // Creating ingredients for frosting
    Ingredient *frostingIngredient1 = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
    frostingIngredient1.ingredientType = @"(2-1/2 cups or 5 sticks) unsalted butter, softened and cut into cubes";
    frostingIngredient1.amount = @575;
    frostingIngredient1.unitOfMeasure = @"g";
    frostingIngredient1.recipeDetail = frosting;
    [frosting addIngredientsObject:frostingIngredient1];
    
    Ingredient *frostingIngredient2 = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
    frostingIngredient2.ingredientType = @"(5-1/4 cups) confectioners’ sugar, sifted";
    frostingIngredient2.amount = @600;
    frostingIngredient2.unitOfMeasure = @"g";
    frostingIngredient2.recipeDetail = frosting;
    [frosting addIngredientsObject:frostingIngredient2];
    
    Ingredient *frostingIngredient3 = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
    frostingIngredient3.ingredientType = @"(4-1/2 tablespoons) milk";
    frostingIngredient3.amount = @70;
    frostingIngredient3.unitOfMeasure = @"ml";
    frostingIngredient3.recipeDetail = frosting;
    [frosting addIngredientsObject:frostingIngredient3];
    
    Ingredient *frostingIngredient4 = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
    frostingIngredient4.ingredientType = @"(1-1/2 tablespoons) pure vanilla extract";
    frostingIngredient4.amount = @23;
    frostingIngredient4.unitOfMeasure = @"ml";
    frostingIngredient4.recipeDetail = frosting;
    [frosting addIngredientsObject:frostingIngredient4];
    
    Ingredient *frostingIngredient5 = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
    frostingIngredient5.ingredientType = @"pinch or two of salt";
    //frostingIngredient5.amount = @23;
    //frostingIngredient5.unitOfMeasure = @"ml";
    frostingIngredient5.recipeDetail = frosting;
    [frosting addIngredientsObject:frostingIngredient5];
    
    Ingredient *frostingIngredient6 = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
    frostingIngredient6.ingredientType = @"few drops pink gel colour";
    //frostingIngredient6.amount = @23;
    //frostingIngredient6.unitOfMeasure = @"ml";
    frostingIngredient6.recipeDetail = frosting;
    [frosting addIngredientsObject:frostingIngredient6];
    
    Ingredient *frostingIngredient7 = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
    frostingIngredient7.ingredientType = @"pastel sugar pearls, or any other sprinkles for decorating";
    //frostingIngredient7.amount = @23;
    //frostingIngredient7.unitOfMeasure = @"ml";
    frostingIngredient7.recipeDetail = frosting;
    [frosting addIngredientsObject:frostingIngredient7];

    [recipe addRecipeDetailsObject:frosting];
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    } else {
        NSLog(@"Recipe for : %@ saved!",recipe.title);
    }
}

-(void) addRecipe3 {
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = delegate.managedObjectContext;
    UIImage *picture =[UIImage imageNamed: @"buttermilk"];
    NSData *cakePicture = UIImageJPEGRepresentation(picture, 1.0f);
    
    // Creating a recipe
    Recipe *recipe = [NSEntityDescription insertNewObjectForEntityForName:@"Recipe" inManagedObjectContext:context];
    recipe.title = @"Vanilla Buttermilk Cake with Instant Fudge Frosting";
    recipe.picture = cakePicture;
    recipe.category = [self convertEnumToNumber:vanillaLayerCake];
    NSString *assemble = @"Place one layer, face-up on a cake stand or plate. Spread 3/4 cup of the frosting over the layer right to the edge using a small offset palette knife. Repeat with the next layer.*Place the last layer on top and use all but 3/4 cup of the frosting to cover the top and sides of the cake. With an offset palette knife or spatula, smooth out the frosting all over. Place the remaining 3/4 cup frosting in a pastry bag fitted with a medium star tube and pipe a shell border around the top and bottom edges of the cake.";
    recipe.howToAssemble = assemble;
    
    // Creating recipe details - cake
    RecipeDetail *cake = [NSEntityDescription insertNewObjectForEntityForName:@"RecipeDetail" inManagedObjectContext:context];
    cake.recipe = recipe;
    cake.subTitle = @"For the Cake:";
    NSString *cakeInstructions = @"Preheat the oven to 350° F (180°C). Butter the bottoms and sides of three 8-inch round cake pans, line bottoms with parchment round, butter the rounds and dust with flour.*Put the eggs and yolks in a medium mixing mixing bowl, add 1/4 cup of the buttermilk and the vanilla. Whisk to blend well.*Combine the flour, sugar, baking powder and salt in a large mixer bowl; whisk to blend. Add the butter and the remaining 1 cup buttermilk to these dry ingredients and with the mixer on low, blend together. Raise the mixer speed to medium and beat until light and fluffy, about 2 minutes.*Add the egg mixture in 3 additions, scraping down the side of the bowl and mixing only until thoroughly incorporated.*Divide batter evenly among the 3 prepared pan (use a kitchen scale to ensure 3 even layers). Bake the cake layers for 28-32 minutes, or until a cake tester or wooden toothpick inserted into the center comes clean and the cake begins to pull away from the sides of the pan. Let the layers cool in the pans for 10 minutes, then carefully turn out onto wire racks, peel of the paper liners, and let cool completely.";
    cake.instructions = cakeInstructions;
    
    // Creating ingredients for cake
    Ingredient *cakeIngredient1 = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
    cakeIngredient1.ingredientType = @"whole eggs, at room temperature";
    cakeIngredient1.amount = @4;
    //cakeIngredient1.unitOfMeasure = @"ml";
    cakeIngredient1.recipeDetail = cake;
    [cake addIngredientsObject:cakeIngredient1];
    
    Ingredient *cakeIngredient2 = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
    cakeIngredient2.ingredientType = @"egg yolks, at room temperature";
    cakeIngredient2.amount = @2;
    //cakeIngredient2.unitOfMeasure = @"ml";
    cakeIngredient2.recipeDetail = cake;
    [cake addIngredientsObject:cakeIngredient2];

    Ingredient *cakeIngredient3 = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
    cakeIngredient3.ingredientType = @"(1-1/4 cups) buttermilk, at room temperature";
    cakeIngredient3.amount = @297;
    cakeIngredient3.unitOfMeasure = @"ml";
    cakeIngredient3.recipeDetail = cake;
    [cake addIngredientsObject:cakeIngredient3];
    
    Ingredient *cakeIngredient4 = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
    cakeIngredient4.ingredientType = @"(2 teaspoons) pure vanilla extract";
    cakeIngredient4.amount = @10;
    cakeIngredient4.unitOfMeasure = @"ml";
    cakeIngredient4.recipeDetail = cake;
    [cake addIngredientsObject:cakeIngredient4];
    
    Ingredient *cakeIngredient5 = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
    cakeIngredient5.ingredientType = @"(3 cups) cake flour, sifted";
    cakeIngredient5.amount = @360;
    cakeIngredient5.unitOfMeasure = @"g";
    cakeIngredient5.recipeDetail = cake;
    [cake addIngredientsObject:cakeIngredient5];
    
    Ingredient *cakeIngredient6 = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
    cakeIngredient6.ingredientType = @"(2 cups) sugar";
    cakeIngredient6.amount = @400;
    cakeIngredient6.unitOfMeasure = @"g";
    cakeIngredient6.recipeDetail = cake;
    [cake addIngredientsObject:cakeIngredient6];

    Ingredient *cakeIngredient7 = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
    cakeIngredient7.ingredientType = @"(1 tablespoon plus 1/2 teaspoon) baking powder";
    cakeIngredient7.amount = @17;
    cakeIngredient7.unitOfMeasure = @"g";
    cakeIngredient7.recipeDetail = cake;
    [cake addIngredientsObject:cakeIngredient7];
    
    Ingredient *cakeIngredient8 = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
    cakeIngredient8.ingredientType = @"(1/2 teaspoon) salt";
    cakeIngredient8.amount = @4;
    cakeIngredient8.unitOfMeasure = @"g";
    cakeIngredient8.recipeDetail = cake;
    [cake addIngredientsObject:cakeIngredient8];

    Ingredient *cakeIngredient9 = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
    cakeIngredient9.ingredientType = @"(1 cup) unsalted butter, at room temperature";
    cakeIngredient9.amount = @227;
    cakeIngredient9.unitOfMeasure = @"g";
    cakeIngredient9.recipeDetail = cake;
    [cake addIngredientsObject:cakeIngredient9];
    
    // Add details of cake to recipe
    [recipe addRecipeDetailsObject:cake];
    
    // Creating recipe details - frosting
    RecipeDetail *frosting = [NSEntityDescription insertNewObjectForEntityForName:@"RecipeDetail" inManagedObjectContext:context];
    frosting.recipe = recipe;
    frosting.subTitle = @"For the Frosting:";
    NSString *frostingInstructions = @"Place all of the ingredients in a food processor and pulse to incorporate. Then process until the frosting is smooth.";
    frosting.instructions = frostingInstructions;
    
    // Creating ingredients for frosting
    Ingredient *frostingIngredient1 = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
    frostingIngredient1.ingredientType = @"(6 oz.) quality unsweetened chocolate, melted and cooled";
    frostingIngredient1.amount = @180;
    frostingIngredient1.unitOfMeasure = @"g";
    frostingIngredient1.recipeDetail = frosting;
    [frosting addIngredientsObject:frostingIngredient1];
    
    Ingredient *frostingIngredient2 = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
    frostingIngredient2.ingredientType = @"(4-1/2 cups) confectioners' sugar";
    frostingIngredient2.amount = @563;
    frostingIngredient2.unitOfMeasure = @"g";
    frostingIngredient2.recipeDetail = frosting;
    [frosting addIngredientsObject:frostingIngredient2];
    
    Ingredient *frostingIngredient3 = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
    frostingIngredient3.ingredientType = @"(1-1/2 cups) unsalted butter, at room temperature";
    frostingIngredient3.amount = @340;
    frostingIngredient3.unitOfMeasure = @"g";
    frostingIngredient3.recipeDetail = frosting;
    [frosting addIngredientsObject:frostingIngredient3];
    
    Ingredient *frostingIngredient4 = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
    frostingIngredient4.ingredientType = @"(6 tablespoons) half-and-half";
    frostingIngredient4.amount = @90;
    frostingIngredient4.unitOfMeasure = @"ml";
    frostingIngredient4.recipeDetail = frosting;
    [frosting addIngredientsObject:frostingIngredient4];
    
    Ingredient *frostingIngredient5 = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
    frostingIngredient5.ingredientType = @"(1 tablespoon) pure vanilla extract";
    frostingIngredient5.amount = @15;
    frostingIngredient5.unitOfMeasure = @"ml";
    frostingIngredient5.recipeDetail = frosting;
    [frosting addIngredientsObject:frostingIngredient5];
    
    [recipe addRecipeDetailsObject:frosting];
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    } else {
        NSLog(@"Recipe for : %@ saved!",recipe.title);
    }
}

-(void) addRecipe4 {
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = delegate.managedObjectContext;
    UIImage *picture =[UIImage imageNamed: @"lattecake"];
    NSData *cakePicture = UIImageJPEGRepresentation(picture, 1.0f);
    
    // Creating a recipe
    Recipe *recipe = [NSEntityDescription insertNewObjectForEntityForName:@"Recipe" inManagedObjectContext:context];
    recipe.title = @"Vanilla Bean Latte Layer Cake";
    recipe.picture = cakePicture;
    recipe.category = [self convertEnumToNumber:vanillaLayerCake];
    NSString *assemble = @"Place cooled cake layer on cake pedestal, or cake board, face-up. Spread 1 cup of buttercream on top using a small offset palette knife, leaving narrow border along outside edge.*Gently place 2nd cake layer on top, and be sure to center it with bottom layer. Apply another 1 cup of buttercream and spread as you did the first layer.*Gently place final cake layer on top, face-down (so the clean bottom side is facing up). Apply a final layer of buttercream.*Fill a pastry bag fitted with decorative tip (Eg: Ateco #887), and pipe desired designs on cake to trim and decorate. Sprinkle sliced cake servings with cinnamon, and garnish with espresso beans (optional).";
    recipe.howToAssemble = assemble;
    
    // Creating recipe details - cake
    RecipeDetail *cake = [NSEntityDescription insertNewObjectForEntityForName:@"RecipeDetail" inManagedObjectContext:context];
    cake.recipe = recipe;
    cake.subTitle = @"For the Cake:";
    NSString *cakeInstructions = @"Preheat oven to 350° F (180° C). Butter three 8-inch x 2-inch round cake pans, line with parchment rounds, butter paper and dust with flour, tapping out the excess.*In a stand mixer fitted with the paddle attachment, beat the butter and sugar on medium-high speed until lighter in color and slightly increased in volume, about 5 minutes. Lower the speed to medium and add the egg whites gradually, mixing until fully incorporated.*Sift the flour, baking powder, and salt into a medium bowl. Mix vanilla extract and vanilla paste (or contents of vanilla bean) into buttermilk. Alternate dry ingredients and buttermilk into creamed mixture, beginning and ending with dry ingredients. Mix until just incorporated or finish by hand gently.*Divide the batter evenly between the prepared pans. If possible, weigh the batter in each cake pan on a digital kitchen scale to ensure even layers. Smooth with small offset palette knife, and bake for about 30 minutes, rotating once after 20 minutes. Cake is done when toothpick or skewer comes clean. Try not to over-bake.*Let pans cool on wire rack for 10 minutes, then invert cakes onto racks, gently, peeling away parchment rounds. Let cool completely.";
    cake.instructions = cakeInstructions;
    
    // Creating ingredients for cake
    Ingredient *cakeIngredient1 = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
    cakeIngredient1.ingredientType = @"(1-1/2 cups) unsalted butter, at room temperature";
    cakeIngredient1.amount = @341;
    cakeIngredient1.unitOfMeasure = @"g";
    cakeIngredient1.recipeDetail = cake;
    [cake addIngredientsObject:cakeIngredient1];
    
    Ingredient *cakeIngredient2 = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
    cakeIngredient2.ingredientType = @"(2-2/3 cups) granulated sugar";
    cakeIngredient2.amount = @540;
    cakeIngredient2.unitOfMeasure = @"g";
    cakeIngredient2.recipeDetail = cake;
    [cake addIngredientsObject:cakeIngredient2];
    
    Ingredient *cakeIngredient3 = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
    cakeIngredient3.ingredientType = @"(275 g) egg whites, at room temperature";
    cakeIngredient3.amount = @9;
    //cakeIngredient3.unitOfMeasure = @"g";
    cakeIngredient3.recipeDetail = cake;
    [cake addIngredientsObject:cakeIngredient3];
    
    Ingredient *cakeIngredient4 = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
    cakeIngredient4.ingredientType = @"(4-1/2 cups) all-purpose flour";
    cakeIngredient4.amount = @570;
    cakeIngredient4.unitOfMeasure = @"g";
    cakeIngredient4.recipeDetail = cake;
    [cake addIngredientsObject:cakeIngredient4];
    
    Ingredient *cakeIngredient5 = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
    cakeIngredient5.ingredientType = @"(2 tablespoons) baking powder";
    cakeIngredient5.amount = @22;
    cakeIngredient5.unitOfMeasure = @"g";
    cakeIngredient5.recipeDetail = cake;
    [cake addIngredientsObject:cakeIngredient5];
    
    Ingredient *cakeIngredient6 = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
    cakeIngredient6.ingredientType = @"(1 teaspoon) salt";
    cakeIngredient6.amount = @6;
    cakeIngredient6.unitOfMeasure = @"g";
    cakeIngredient6.recipeDetail = cake;
    [cake addIngredientsObject:cakeIngredient6];
    
    Ingredient *cakeIngredient7 = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
    cakeIngredient7.ingredientType = @"(2 cups) buttermilk, at room temperature";
    cakeIngredient7.amount = @480;
    cakeIngredient7.unitOfMeasure = @"ml";
    cakeIngredient7.recipeDetail = cake;
    [cake addIngredientsObject:cakeIngredient7];
    
    Ingredient *cakeIngredient8 = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
    cakeIngredient8.ingredientType = @"(1 tablespoon) vanilla bean paste or 1 vanilla bean, split & scraped";
    cakeIngredient8.amount = @15;
    cakeIngredient8.unitOfMeasure = @"ml";
    cakeIngredient8.recipeDetail = cake;
    [cake addIngredientsObject:cakeIngredient8];
    
    Ingredient *cakeIngredient9 = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
    cakeIngredient9.ingredientType = @"(1 teaspoon) pure vanilla extract";
    cakeIngredient9.amount = @5;
    cakeIngredient9.unitOfMeasure = @"ml";
    cakeIngredient9.recipeDetail = cake;
    [cake addIngredientsObject:cakeIngredient9];

    // Add details of cake to recipe
    [recipe addRecipeDetailsObject:cake];
    
    // Creating recipe details - frosting
    RecipeDetail *frosting = [NSEntityDescription insertNewObjectForEntityForName:@"RecipeDetail" inManagedObjectContext:context];
    frosting.recipe = recipe;
    frosting.subTitle = @"For the Buttercream:";
    NSString *frostingInstructions = @"Wipe the bowl of an electric mixer with paper towel and lemon juice, to remove any trace of grease. Add egg whites and sugar, and simmer over a pot of water (not boiling), whisking constantly but gently, until temperature reaches 160°F (71°C), or if you don't have a candy thermometer, until the sugar has completely dissolved and the egg whites are hot.*With whisk attachment of mixer, begin to whip until the meringue is thick, glossy, and the bottom of the bowl feels neutral to the touch (this can take up to 10 minutes or so). *Don't begin adding butter until the bottom of the bowl feels neutral, and not warm.*Switch over to paddle attachment and, with mixer on low speed, add butter cubes, one at a time, until incorporated, and mix until it has reached a silky smooth texture (if curdles, keep mixing and it will come back to smooth). *If mixture is too runny, refrigerate for about 15 minutes and continue mixing with paddle attachment until it comes together. Mix espresso powder with 1 teaspoon (5 ml) boiling water. Add espresso mixture, vanilla, cinnamon and salt, continuing to beat on low speed until well combined. (Note: you can replace the vanilla bean paste wtih 1 vanilla bean, split & scraped).";
    frosting.instructions = frostingInstructions;
    
    // Creating ingredients for frosting
    Ingredient *frostingIngredient1 = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
    frostingIngredient1.ingredientType = @"(180 g) large egg whites";
    frostingIngredient1.amount = @6;
    //frostingIngredient1.unitOfMeasure = @"g";
    frostingIngredient1.recipeDetail = frosting;
    [frosting addIngredientsObject:frostingIngredient1];
    
    Ingredient *frostingIngredient2 = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
    frostingIngredient2.ingredientType = @"(1 cup) granulated sugar";
    frostingIngredient2.amount = @200;
    frostingIngredient2.unitOfMeasure = @"g";
    frostingIngredient2.recipeDetail = frosting;
    [frosting addIngredientsObject:frostingIngredient2];
    
    Ingredient *frostingIngredient3 = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
    frostingIngredient3.ingredientType = @"(1-1/2 cups) unsalted butter, softened but cool, cut into cubes";
    frostingIngredient3.amount = @340;
    frostingIngredient3.unitOfMeasure = @"g";
    frostingIngredient3.recipeDetail = frosting;
    [frosting addIngredientsObject:frostingIngredient3];
    
    Ingredient *frostingIngredient4 = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
    frostingIngredient4.ingredientType = @"(1 teaspoon) pure vanilla extract";
    frostingIngredient4.amount = @5;
    frostingIngredient4.unitOfMeasure = @"ml";
    frostingIngredient4.recipeDetail = frosting;
    [frosting addIngredientsObject:frostingIngredient4];
    
    Ingredient *frostingIngredient5 = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
    frostingIngredient5.ingredientType = @"(1 tablespoon) vanilla bean paste";
    frostingIngredient5.amount = @15;
    frostingIngredient5.unitOfMeasure = @"ml";
    frostingIngredient5.recipeDetail = frosting;
    [frosting addIngredientsObject:frostingIngredient5];
    
    Ingredient *frostingIngredient6 = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
    frostingIngredient6.ingredientType = @"(1 tablespoon) instant espresso powder";
    frostingIngredient6.amount = @15;
    frostingIngredient6.unitOfMeasure = @"g";
    frostingIngredient6.recipeDetail = frosting;
    [frosting addIngredientsObject:frostingIngredient6];
    
    Ingredient *frostingIngredient7 = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
    frostingIngredient7.ingredientType = @"(1/4 teaspoon) cinnamonpowder";
    frostingIngredient7.amount = @1.5;
    frostingIngredient7.unitOfMeasure = @"g";
    frostingIngredient7.recipeDetail = frosting;
    [frosting addIngredientsObject:frostingIngredient7];
    
    Ingredient *frostingIngredient8 = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
    frostingIngredient8.ingredientType = @"Pinch of salt";
    //frostingIngredient8.amount = @1.5;
    //frostingIngredient8.unitOfMeasure = @"g";
    frostingIngredient8.recipeDetail = frosting;
    [frosting addIngredientsObject:frostingIngredient8];
    
    [recipe addRecipeDetailsObject:frosting];
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    } else {
        NSLog(@"Recipe for : %@ saved!",recipe.title);
    }
}

-(void) addRecipe5 {
    
}

@end
