//
//  ShoppingList.m
//  SweetCollectibles
//
//  Created by it-högskolan on 2015-04-15.
//  Copyright (c) 2015 it-högskolan. All rights reserved.
//

#import "ShoppingList.h"
#import "Recipe.h"

@interface ShoppingList ()

@end

@implementation ShoppingList

- (void)viewDidLoad {
    [super viewDidLoad];
    Recipe *recipe;
    for (int i=0; i< self.recipeList.count; i++) {
        recipe = self.recipeList[i];
        NSLog(@"Title: %@", recipe.title);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
