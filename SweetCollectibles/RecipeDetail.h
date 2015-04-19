//
//  RecipeDetail.h
//  SweetCollectibles
//
//  Created by it-högskolan on 2015-04-19.
//  Copyright (c) 2015 it-högskolan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Recipe;

@interface RecipeDetail : NSManagedObject

@property (nonatomic, retain) NSString * subTitle;
@property (nonatomic, retain) NSString * instructions;
@property (nonatomic, retain) Recipe *recipe;
@property (nonatomic, retain) NSSet *ingredients;
@end

@interface RecipeDetail (CoreDataGeneratedAccessors)

- (void)addIngredientsObject:(NSManagedObject *)value;
- (void)removeIngredientsObject:(NSManagedObject *)value;
- (void)addIngredients:(NSSet *)values;
- (void)removeIngredients:(NSSet *)values;

@end
