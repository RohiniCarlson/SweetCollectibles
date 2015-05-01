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
@property (nonatomic) NSMutableDictionary * shoppingList;
@end

@implementation ShoppingList

- (void)viewDidLoad {
    [super viewDidLoad];
    self.shoppingList = [[NSMutableDictionary alloc] init];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Under Construction!"
                                                    message:@"Your patience is greatly appreciated."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [self addToShoppingList];
    [self createShoppingList];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)addToShoppingList {
    for (Recipe *recipe in self.recipeList) {
        NSArray *recipeDetails = [recipe.recipeDetails allObjects];
        for (RecipeDetail *recipeDetail in recipeDetails) {
            NSArray *ingredients = [recipeDetail.ingredients allObjects];
            for (Ingredient *ingredient in ingredients) {
                NSString *name = ingredient.ingredientType;
                if ([name rangeOfString:@"egg white" options:NSCaseInsensitiveSearch].location != NSNotFound) {
                    name = @"egg white";
                } else if ([name rangeOfString:@"egg" options:NSCaseInsensitiveSearch].location != NSNotFound) {
                    name = @"egg";
                } else if ([name rangeOfString:@"salt" options:NSCaseInsensitiveSearch].location != NSNotFound) {
                    name = @"salt";
                } else if ([name rangeOfString:@"unsalted butter" options:NSCaseInsensitiveSearch].location != NSNotFound) {
                    name = @"unsalted butter";
                } else if ([name rangeOfString:@"dark chocolate" options:NSCaseInsensitiveSearch].location != NSNotFound) {
                    name = @"dark chocolate";
                } else if ([name rangeOfString:@"unsweetened chocolate" options:NSCaseInsensitiveSearch].location != NSNotFound) {
                    name = @"unsweetened chocolate";
                } else if ([name rangeOfString:@"coffee" options:NSCaseInsensitiveSearch].location != NSNotFound) {
                    name = @"coffee";
                } else {
                    if ([name rangeOfString:@")"].location != NSNotFound) {
                        name = [name substringFromIndex:[name rangeOfString:@")"].location +2 ];
                    }
                    if ([name rangeOfString:@","].location != NSNotFound) {
                        NSUInteger index = [name rangeOfString:@","].location;
                        name = [name substringToIndex:index];
                    }
                }
                IngredientObject *ingredientObject = [[IngredientObject alloc]init];
                if (ingredient.amount == nil) {
                    ingredientObject.amount = @0;
                } else {
                    ingredientObject.amount = ingredient.amount;
                }
                if (ingredient.unitOfMeasure == nil) {
                   ingredientObject.unitOfMeasure = @"none";
                } else {
                    ingredientObject.unitOfMeasure = ingredient.unitOfMeasure;
                }
                IngredientObject *savedIngredient;
                if ((savedIngredient = [self.shoppingList objectForKey:name])) {
                    if (![savedIngredient.unitOfMeasure isEqualToString:@"none"]) {
                        savedIngredient.amount = [NSNumber numberWithDouble:[savedIngredient.amount doubleValue]  + [ingredientObject.amount doubleValue]];
                        [self.shoppingList setObject:savedIngredient forKey:name];
                    }
                } else {
                    [self.shoppingList setObject:ingredientObject forKey:name];
                }
            }
        }
    }
}

-(void)createShoppingList {
    IngredientObject *ingredient = [[IngredientObject alloc] init];
    NSString *listItem;
    NSString *ingredientType;
    for (id key in self.shoppingList) {
        ingredient = [self.shoppingList objectForKey:key];
        ingredientType = key;
        if ([ingredient.unitOfMeasure isEqualToString:@"none"] && [ingredient.amount doubleValue] == 0) {
            listItem = ingredientType;
        } else if([ingredient.unitOfMeasure isEqualToString:@"none"] && [ingredient.amount doubleValue] != 0) {
            if ([@"egg" isEqualToString:key] && [ingredient.amount doubleValue] > 1) {
                ingredientType = @"eggs";
            } else {
                ingredientType = key;
            }
            listItem = [NSString stringWithFormat:@"%@ %@",ingredient.amount, ingredientType ];
        } else {
            listItem = [NSString stringWithFormat:@"%@ %@ %@",ingredient.amount, ingredient.unitOfMeasure, ingredientType];
        }
        NSLog(@"Shopping List Item: %@",listItem);
    }
}


@end
