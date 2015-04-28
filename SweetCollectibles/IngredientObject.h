//
//  IngredientObject.h
//  SweetCollectibles
//
//  Created by it-högskolan on 2015-04-28.
//  Copyright (c) 2015 it-h&#246;gskolan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IngredientObject : NSObject
@property (nonatomic) NSString *ingredientName;
@property (nonatomic) NSNumber *amount;
@property (nonatomic) NSString *unitOfMeasure;
@property (nonatomic) NSNumber *addedToList;

-(instancetype)init;
@end
