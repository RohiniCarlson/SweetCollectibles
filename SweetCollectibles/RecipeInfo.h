//
//  RecipeInfo.h
//  SweetCollectibles
//
//  Created by it-högskolan on 2015-04-15.
//  Copyright (c) 2015 it-högskolan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipe.h"
#import "CollapseClick.h"

@interface RecipeInfo : UIViewController<CollapseClickDelegate, UITextFieldDelegate>
@property (nonatomic) Recipe *recipe;
@end
