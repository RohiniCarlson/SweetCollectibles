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
#import "AccordionView.h" // code included from https://github.com/appsome/AccordionView

@interface RecipeInfo ()
//@property (nonatomic) UITextView *ingredientsTextView;
//@property (nonatomic) UIView *ingredientsView;
@property (nonatomic) UIButton *headerButton, *ingredientsButton, *instructionsButton;
@property (nonatomic) UIView *headerView, *ingredientsView, *instructionsView;
@property (nonatomic) AccordionView *accordion;
@end

@implementation RecipeInfo

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    [self createAccordionView];
    [self createAndStyleHeaderButtons];
    [self createHeaderView];
    [self addHeadersAndViewsToAccordionView];
    //self.recipePicture.image = [UIImage imageWithData:self.recipe.picture];
    //self.recipeTitle.text = self.recipe.title;
}

-(void)createAccordionView{
    self.accordion = [[AccordionView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    [self.view insertSubview:self.accordion atIndex:0];
    //[self.view addSubview:self.accordion];
}


- (void)styleButton:(UIButton*)button withTitle:(NSString*)title andImage:(NSString*)image colorRed:(float)red colorBlue:(float)blue colorGreen:(float)green{
    button.titleLabel.numberOfLines = 1;
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    button.titleLabel.lineBreakMode = NSLineBreakByClipping;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    button.backgroundColor = [UIColor colorWithRed:(red/255.0) green:(blue/255.0) blue:(green/255.0) alpha:1.000];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
}


-(void)createAndStyleHeaderButtons{
    self.headerButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 30)];
    [self styleButton:self.headerButton withTitle:@"Recipe Title & Image" andImage:@"expand" colorRed:153 colorBlue:153 colorGreen:204];
    
    self.ingredientsButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 30)];
    [self styleButton:self.ingredientsButton withTitle:@"Ingredients" andImage:@"collapse" colorRed:204 colorBlue:153 colorGreen:204];
    
    self.instructionsButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 30)];
    [self styleButton:self.instructionsButton withTitle:@"Instructions" andImage:@"collapse"colorRed:153 colorBlue:153 colorGreen:204];
}


-(void)createHeaderView {
    // Create header view
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 82)];
    self.headerView.backgroundColor = [UIColor colorWithRed:(246/255.0) green:(238/255.0) blue:(246/255.0) alpha:1.000];
    
    // Create detail element image in header view
    UIImageView *recipeImage =[[UIImageView alloc] initWithFrame:CGRectMake(0,0,100,82)];
    recipeImage.image = [UIImage imageWithData:self.recipe.picture];
    [recipeImage setContentMode:UIViewContentModeScaleAspectFit];
    [self.headerView addSubview:recipeImage];
    
    // Create detail element image in header view
    UILabel *recipeLabel =[[UILabel alloc] initWithFrame:CGRectMake(108,14,167,70)];
    [recipeLabel setFont:[UIFont boldSystemFontOfSize:14]];
    recipeLabel.text = [self.recipe.title uppercaseString];
    [recipeLabel setTextAlignment:NSTextAlignmentLeft];
    [recipeLabel setBaselineAdjustment:UIBaselineAdjustmentAlignBaselines];
    recipeLabel.lineBreakMode = NSLineBreakByWordWrapping;
    recipeLabel.numberOfLines = 5;
    [self.headerView addSubview:recipeLabel];
}

-(void)addHeadersAndViewsToAccordionView {
    [self.accordion addHeader:self.headerButton withView:self.headerView];
}

/*-(void)createIngrdientsView {
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
    //CGSize size = textRect.size;
    
    [self.ingredientsTextView setFont:[UIFont boldSystemFontOfSize:14.0]];
    self.ingredientsTextView.text = temp;
    self.ingredientsTextView.userInteractionEnabled = NO;
}*/
/*NSArray *ingredients = [detail.ingredients allObjects];
 NSString *individualIngredient = @"";
 NSString *listIngredients = detail.subTitle;
 for (Ingredient *ingredient in ingredients) {
 individualIngredient = [NSString stringWithFormat:@"%@ %@ %@",ingredient.amount, ingredient.unitOfMeasure, ingredient.ingredientType];
 individualIngredient = [NSString stringWithFormat:@"%@\n", individualIngredient];
 listIngredients = [listIngredients stringByAppendingString:individualIngredient];
 }*/


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
