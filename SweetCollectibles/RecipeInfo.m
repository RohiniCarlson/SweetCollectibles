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
@property (nonatomic) CGFloat screenWidth;
@property (nonatomic) CGFloat screenHeight;
@property (nonatomic) CGRect newFrame;
@end

@implementation RecipeInfo

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    self.screenWidth = screenRect.size.width;
    self.screenHeight = screenRect.size.height;
    [self createAccordionView];
    [self createAndStyleHeaderButtons];
    [self createHeaderView];
    [self createIngredientsView];
    [self addHeadersAndViewsToAccordionView];
}

-(void)createAccordionView{
    self.accordion = [[AccordionView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    [self.view insertSubview:self.accordion atIndex:0];
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
    // Create main header view
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 92)];
    self.headerView.backgroundColor = [UIColor colorWithRed:(246/255.0) green:(238/255.0) blue:(246/255.0) alpha:1.000];
    
    // Create image view
    UIImageView *recipeImage =[[UIImageView alloc] initWithFrame:CGRectMake(0,5,100,82)];
    recipeImage.image = [UIImage imageWithData:self.recipe.picture];
    [recipeImage setContentMode:UIViewContentModeScaleAspectFit];
    [self.headerView addSubview:recipeImage];
    
    // Create label
    UILabel *recipeLabel =[[UILabel alloc] initWithFrame:CGRectMake(108,14,167,70)];
    [recipeLabel setFont:[UIFont boldSystemFontOfSize:14]];
    recipeLabel.text = [self.recipe.title uppercaseString];
    [recipeLabel setTextAlignment:NSTextAlignmentLeft];
    [recipeLabel setBaselineAdjustment:UIBaselineAdjustmentAlignBaselines];
    recipeLabel.lineBreakMode = NSLineBreakByWordWrapping;
    recipeLabel.numberOfLines = 5;
    [self.headerView addSubview:recipeLabel];
}

-(void)createIngredientsView {
    NSArray *details = [self.recipe.recipeDetails allObjects];
    CGSize size, adjustedSize;
    float offsetFromViewTop = 8.0f;
    float offsetbetweenItems = 5.0f;
    
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0,50)];
    tempView.backgroundColor = [UIColor colorWithRed:(246/255.0) green:(238/255.0) blue:(246/255.0) alpha:1.000];
    
    // create subviews
    for (RecipeDetail *detail in details) {
        size = [detail.subTitle sizeWithAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:12]}];
        adjustedSize = CGSizeMake(ceilf(size.width), ceilf(size.height));
        
        // Create ingredients sub-title
        UILabel *recipeSubTitle =[[UILabel alloc] initWithFrame:CGRectMake(10,offsetFromViewTop,self.screenWidth-10.0f,adjustedSize.height+16)];
        [recipeSubTitle setFont:[UIFont boldSystemFontOfSize:12]];
        recipeSubTitle.text = detail.subTitle;
        [recipeSubTitle setTextAlignment:NSTextAlignmentLeft];
        [recipeSubTitle setBaselineAdjustment:UIBaselineAdjustmentAlignBaselines];
        recipeSubTitle.lineBreakMode = NSLineBreakByWordWrapping;
        recipeSubTitle.numberOfLines = 2;
        
        // Add label to view and resize view
        CGSize newSize;
        newSize.height = 500;
        newSize.width = self.screenWidth;
        [tempView addSubview:recipeSubTitle];
        [tempView sizeThatFits:newSize];
        [tempView sizeToFit];
        [tempView setNeedsLayout];
        [tempView setNeedsDisplayInRect:tempView.frame];
        
        
        // Create list of ingredients
        NSArray *ingredients = [detail.ingredients allObjects];
        NSString *individualIngredient = @"";
        NSString *listIngredients = @"";
        for (Ingredient *ingredient in ingredients) {
            individualIngredient = [NSString stringWithFormat:@"%@ %@ %@\n",ingredient.amount, ingredient.unitOfMeasure, ingredient.ingredientType];
            listIngredients = [listIngredients stringByAppendingString:individualIngredient];
        }
        size = [listIngredients sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:11]}];
        adjustedSize = CGSizeMake(ceilf(size.width), ceilf(size.height));
        
        // Create textview
         UITextView *ingredientsList =[[UITextView alloc] initWithFrame:CGRectMake(30,recipeSubTitle.frame.size.height+offsetbetweenItems,self.screenWidth-20.0f,adjustedSize.height+16)];
        [ingredientsList setFont:[UIFont systemFontOfSize:11]];
        ingredientsList.text = listIngredients;
        [ingredientsList setTextAlignment:NSTextAlignmentLeft];
         ingredientsList.backgroundColor = [UIColor colorWithRed:(246/255.0) green:(238/255.0) blue:(246/255.0) alpha:1.000];
        
        // Add textview to view and resize view
        [tempView addSubview:ingredientsList];
        [tempView sizeToFit];
        [tempView setNeedsLayout];

        [tempView setNeedsDisplayInRect:tempView.frame];
        // Create ingredients view
        self.ingredientsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, tempView.frame.size.height)];
        self.ingredientsView.backgroundColor = [UIColor colorWithRed:(246/255.0) green:(238/255.0) blue:(246/255.0) alpha:1.000];
        [self.ingredientsView addSubview:tempView];
    }
}

-(void)addHeadersAndViewsToAccordionView {
    [self.accordion addHeader:self.headerButton withView:self.headerView];
    [self.accordion addHeader:self.ingredientsButton withView:self.ingredientsView];
    [self.accordion setNeedsLayout];
    
    // Set this if you want to allow multiple selection
    [self.accordion setAllowsMultipleSelection:YES];
    
    // Set this to NO if you want to have at least one open section at all times
    [self.accordion setAllowsEmptySelection:YES];
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
