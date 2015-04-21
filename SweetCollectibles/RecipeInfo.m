//
//  RecipeInfo.m
//  SweetCollectibles
//
//  Created by it-högskolan on 2015-04-15.
//  Copyright (c) 2015 it-högskolan. All rights reserved.
//

#import "RecipeInfo.h"
#import "RecipeDetail.h"
#import "Ingredient.h"

@interface RecipeInfo ()
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIImageView *recipePicture;
@property (strong, nonatomic) IBOutlet UILabel *recipeTitle;
@property (strong, nonatomic) IBOutlet CollapseClick *collapseClick;
@property (nonatomic) UITextView *ingredientsTextView;
@property (nonatomic) UIView *ingredientsView;
@end

@implementation RecipeInfo

- (void)viewDidLoad {
    [super viewDidLoad];
    self.recipePicture.image = [UIImage imageWithData:self.recipe.picture];
    self.recipeTitle.text = self.recipe.title;
    self.collapseClick.CollapseClickDelegate = self;
    [self.collapseClick reloadCollapseClick];
    
    // If you want a cell open on load, run this method:
    [self.collapseClick openCollapseClickCellAtIndex:0 animated:NO];
}

-(void)createIngrdientsView {
    float y = CGRectGetMaxY(self.headerView.frame);
    float x = CGRectGetMinX(self.headerView.frame);
    NSArray *details = [self.recipe.recipeDetails allObjects];
    RecipeDetail *detail = details[0];
    NSString *temp = detail.subTitle;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    // Create the attributes dictionary with the font and paragraph style
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:14.0],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    CGRect textRect = [temp boundingRectWithSize:CGSizeMake(100.0f, 999999.0f)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:attributes
                                           context:nil];
    CGSize size = textRect.size;
    self.ingredientsView = [[UIView alloc] initWithFrame:CGRectMake(x, y+20, 300, size.height + 16)];
    self.ingredientsTextView = [[UITextView alloc] initWithFrame:CGRectMake(x, y+20, 300, size.height + 16)];
    [self.ingredientsTextView setFont:[UIFont boldSystemFontOfSize:14.0]];
    self.ingredientsTextView.text = temp;
    self.ingredientsTextView.userInteractionEnabled = NO;
    [self.ingredientsView addSubview:self.ingredientsTextView];
   // [self.collapseClick addSubview:self.ingredientsView];
    
    /*NSArray *ingredients = [detail.ingredients allObjects];
    NSString *individualIngredient = @"";
    NSString *listIngredients = detail.subTitle;
    for (Ingredient *ingredient in ingredients) {
        individualIngredient = [NSString stringWithFormat:@"%@ %@ %@",ingredient.amount, ingredient.unitOfMeasure, ingredient.ingredientType];
        individualIngredient = [NSString stringWithFormat:@"%@\n", individualIngredient];
        listIngredients = [listIngredients stringByAppendingString:individualIngredient];
    }*/
}

-(int)numberOfCellsForCollapseClick {
    return 1;
}


-(NSString *)titleForCollapseClickAtIndex:(int)index {
    switch (index) {
        case 0:
            return @"Ingredients";
            //break;
        default:
            return @"";
            //break;
    }
}


-(UIView *)viewForCollapseClickContentViewAtIndex:(int)index {
    switch (index) {
        case 0:
            return self.headerView;
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
