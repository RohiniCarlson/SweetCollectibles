//
//  EntireRecipe.m
//  SweetCollectibles
//
//  Created by it-högskolan on 2015-04-20.
//  Copyright (c) 2015 it-h&#246;gskolan. All rights reserved.
//

#import "EntireRecipe.h"

@interface EntireRecipe ()

@property (strong, nonatomic) IBOutlet UILabel *recipeTitle;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet CollapseClick *collapseClick;
@property (strong, nonatomic) IBOutlet UIImageView *recipeImage;
@property (strong, nonatomic) IBOutlet UIView *testView;

@end

@implementation EntireRecipe

- (void)viewDidLoad {
    [super viewDidLoad];
    self.recipeImage.image = [UIImage imageWithData:self.recipe.picture];
    self.recipeTitle.text = self.recipe.title;
    self.collapseClick.CollapseClickDelegate = self;
    [self.collapseClick reloadCollapseClick];
    
    // If you want a cell open on load, run this method:
    [self.collapseClick openCollapseClickCellAtIndex:0 animated:NO];
    // Do any additional setup after loading the view from its nib.
}


-(int)numberOfCellsForCollapseClick {
    return 2;
}


-(NSString *)titleForCollapseClickAtIndex:(int)index {
    switch (index) {
        case 0:
            return self.recipe.title;
        case 1:
            return @"Just Testing";
        default:
            return @"";
    }
}


-(UIView *)viewForCollapseClickContentViewAtIndex:(int)index {
    switch (index) {
        case 0:
            return self.headerView;
        case 1:
            return self.testView;
        default:
            return self.headerView;
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
