//
//  Ingredient.h
//  SweetCollectibles
//
//  Created by it-högskolan on 2015-04-19.
//  Copyright (c) 2015 it-högskolan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RecipeDetail;

@interface Ingredient : NSManagedObject

@property (nonatomic, retain) NSString * ingredientType;
@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSString * unitOfMeasure;
@property (nonatomic, retain) RecipeDetail *recipeDetail;

@end
