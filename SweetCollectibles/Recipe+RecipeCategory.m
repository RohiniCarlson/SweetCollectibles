//
//  Recipe+RecipeCategory.m
//  SweetCollectibles
//
//  Created by it-högskolan on 2015-04-27.
//  Copyright (c) 2015 it-h&#246;gskolan. All rights reserved.
//

#import "Recipe+RecipeCategory.h"

@implementation Recipe (RecipeCategory)
- (NSString *)sectionTitle
{
    return [self.title substringToIndex:1];
}
@end
