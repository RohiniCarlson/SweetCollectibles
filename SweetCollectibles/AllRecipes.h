//
//  AllRecipes.h
//  SweetCollectibles
//
//  Created by it-högskolan on 2015-04-15.
//  Copyright (c) 2015 it-högskolan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllRecipes : UITableViewController <UISearchBarDelegate>

typedef NS_ENUM(NSInteger, recipeCategory) {
    chocolateLayerCake,
    vanillaLayerCake,
};

@end
