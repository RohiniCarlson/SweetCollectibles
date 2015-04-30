//
//  ShoppingList.m
//  SweetCollectibles
//
//  Created by it-högskolan on 2015-04-15.
//  Copyright (c) 2015 it-högskolan. All rights reserved.
//

#import "ShoppingList.h"
#import "Recipe.h"
#import "RecipeDetail.h"
#import "Ingredient.h"
#import "IngredientObject.h"

@interface ShoppingList ()

@end

@implementation ShoppingList

- (void)viewDidLoad {
    [super viewDidLoad];
    Recipe *recipe;
    for (int i=0; i< self.recipeList.count; i++) {
        recipe = self.recipeList[i];
        NSLog(@"Title: %@", recipe.title);
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Under Construction!"
                                                    message:@"Your patience is greatly appreciated."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    /*NSMutableArray *array = [self createIngredientsArray];
    for (int i=0; i<array.count; i++) {
        NSArray *items = array[i];
        for (IngredientObject *ingredientObject in items) {
            NSString *string = [NSString stringWithFormat: @"%@ %@ %@", ingredientObject.ingredientName, ingredientObject.amount, ingredientObject.unitOfMeasure];
            NSLog(string);
        }
    }*/
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSMutableArray*)createIngredientsArray{
    
    NSMutableArray *ingredientsArray = [[NSMutableArray alloc] init];
    IngredientObject *ingredientObject = [[IngredientObject alloc]init];
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"ingredientName" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    for (Recipe *recipe in self.recipeList) {
         NSArray *recipeDetails = [recipe.recipeDetails allObjects];
        for (RecipeDetail *recipeDetail in recipeDetails) {
            NSArray *ingredients = [recipeDetail.ingredients allObjects];
            NSMutableArray *subRecipeIngredients = [[NSMutableArray alloc] init];
            for (Ingredient *ingredient in ingredients) {
                NSString *name = ingredient.ingredientType;
                if ([name rangeOfString:@"egg" options:NSCaseInsensitiveSearch].location != NSNotFound) {
                    name = @"egg";
                } else if ([name rangeOfString:@"salt" options:NSCaseInsensitiveSearch].location != NSNotFound) {
                    name = @"salt";
                } else if ([name rangeOfString:@"unsalted butter" options:NSCaseInsensitiveSearch].location != NSNotFound) {
                    name = @"unsalted butter";
                } else {
                    name = [name substringFromIndex:[name rangeOfString:@")"].location +2 ];
                }
                ingredientObject.ingredientName = name;
                ingredientObject.amount = ingredient.amount;
                ingredientObject.unitOfMeasure = ingredient.unitOfMeasure;
                ingredientObject.addedToList = @0;
                [subRecipeIngredients addObject:ingredientObject];
            }
           subRecipeIngredients = [[subRecipeIngredients sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
             //subRecipeIngredients = [[subRecipeIngredients sortedArrayUsingComparator:^(IngredientObject *a, IngredientObject *b) {
               //return [a.ingredientName caseInsensitiveCompare:b.ingredientName];}];
             [ingredientsArray addObject:subRecipeIngredients];
        }
    }
    return ingredientsArray;
}

@end
