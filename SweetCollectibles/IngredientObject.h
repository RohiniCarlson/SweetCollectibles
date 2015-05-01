//
//  IngredientObject.h
//  SweetCollectibles
//
//  Created by it-högskolan on 2015-04-28.
//  Copyright (c) 2015 it-h&#246;gskolan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IngredientObject : NSObject
@property (nonatomic) NSNumber *amount;
@property (nonatomic) NSString *unitOfMeasure;

-(instancetype)init;
@end
