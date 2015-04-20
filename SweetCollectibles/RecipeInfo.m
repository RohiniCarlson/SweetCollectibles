//
//  RecipeInfo.m
//  SweetCollectibles
//
//  Created by it-högskolan on 2015-04-15.
//  Copyright (c) 2015 it-högskolan. All rights reserved.
//

#import "RecipeInfo.h"

@interface RecipeInfo ()
@property (strong, nonatomic) IBOutlet UIImageView *recipePicture;
@property (strong, nonatomic) IBOutlet UILabel *recipeTitle;
@end

@implementation RecipeInfo

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"RecipeInfo - viewDidLoad()");
    NSLog(self.recipe.title);
    self.recipePicture.image = [UIImage imageWithData:self.recipe.picture];
    self.recipeTitle.text = self.recipe.title;
    // Do any additional setup after loading the view.
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
