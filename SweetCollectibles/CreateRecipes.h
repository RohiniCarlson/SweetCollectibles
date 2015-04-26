//
//  CreateRecipes.h
//  SweetCollectibles
//
//  Created by it-högskolan on 2015-04-26.
//  Copyright (c) 2015 it-h&#246;gskolan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CreateRecipes : NSObject

typedef NS_ENUM(NSInteger, recipeCategory) {
    chocolateLayerCake,
    vanillaLayerCake,
};

-(void)addRecipes;

@end
