//
//  Recipe.h
//  SweetCollectibles
//
//  Created by it-högskolan on 2015-04-19.
//  Copyright (c) 2015 it-högskolan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Recipe : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSData * picture;
@property (nonatomic, retain) NSNumber * category;
@property (nonatomic, retain) NSNumber * favorite;
@property (nonatomic, retain) NSString * howToAssemble;
@property (nonatomic, retain) NSSet *recipeDetails;
@end

@interface Recipe (CoreDataGeneratedAccessors)

- (void)addRecipeDetailsObject:(NSManagedObject *)value;
- (void)removeRecipeDetailsObject:(NSManagedObject *)value;
- (void)addRecipeDetails:(NSSet *)values;
- (void)removeRecipeDetails:(NSSet *)values;

@end
