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
@property (nonatomic) UIButton *headerButton, *ingredientsButton, *ingredientsButton2, *instructionsButton;
@property (nonatomic) UIView *headerView, *ingredientsView, *ingredientsView2, *instructionsView;
@property (nonatomic) AccordionView *accordion;
@property (nonatomic) CGFloat screenWidth;
@property (nonatomic) CGFloat screenHeight;
@property (nonatomic) CGRect newFrame;
@end

@implementation RecipeInfo

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.translucent = NO;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    self.screenWidth = screenRect.size.width;
    self.screenHeight = screenRect.size.height;
    [self createAccordionView];
    [self createAndStyleHeaderButtons];
    [self createHeaderView];
    [self createIngredientsView];
    [self createInstructionsView];
    [self addHeadersAndViewsToAccordionView];
}

-(void)createAccordionView{
    self.accordion = [[AccordionView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    self.accordion.backgroundColor = [UIColor colorWithRed:(246/255.0) green:(238/255.0) blue:(246/255.0) alpha:1.000];
    [self.view addSubview:self.accordion];
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
    CGRect newFrame;
    
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth,0)];
    tempView.backgroundColor = [UIColor colorWithRed:(246/255.0) green:(238/255.0) blue:(246/255.0) alpha:1.000];
    
    // create subviews
    for (RecipeDetail *detail in details) {
        size = [detail.subTitle sizeWithAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:12]}];
        adjustedSize = CGSizeMake(ceilf(size.width), ceilf(size.height));
        
        // Create label for sub-title
        UILabel *recipeSubTitle =[[UILabel alloc] initWithFrame:CGRectMake(10,tempView.frame.size.height, self.screenWidth-10.0f,adjustedSize.height+10)];
        [recipeSubTitle setFont:[UIFont boldSystemFontOfSize:12]];
        recipeSubTitle.text = detail.subTitle;
        [recipeSubTitle setTextAlignment:NSTextAlignmentLeft];
        [recipeSubTitle setBaselineAdjustment:UIBaselineAdjustmentAlignBaselines];
        recipeSubTitle.lineBreakMode = NSLineBreakByWordWrapping;
        recipeSubTitle.numberOfLines = 2;
        
        // Add sub-title label to view and resize view
        newFrame.size.height = recipeSubTitle.frame.size.height;
        tempView.frame = CGRectMake(0,0,self.screenWidth,tempView.frame.size.height + newFrame.size.height);
        [tempView addSubview:recipeSubTitle];
        
        // Create list of ingredients
        NSArray *ingredients = [detail.ingredients allObjects];
        NSString *temp = @"";
        NSString *individualIngredient = @"";
        NSString *listIngredients = @"";
        for (Ingredient *ingredient in ingredients) {
            if ([ingredient.amount intValue] != 0) {
                temp = [ingredient.amount stringValue];
                temp = [NSString stringWithFormat:@"%@ ",temp];
            }
            if (![self stringIsNullOrEmpty:ingredient.unitOfMeasure]) {
                if ([self stringIsNullOrEmpty:temp]) {
                    temp = ingredient.unitOfMeasure;
                } else {
                  temp = [temp stringByAppendingString:ingredient.unitOfMeasure];
                }
                temp = [NSString stringWithFormat:@"%@ ",temp];
            }
            if ([self stringIsNullOrEmpty:temp]) {
                temp = ingredient.ingredientType;
            } else {
                temp = [temp stringByAppendingString:ingredient.ingredientType];
            }
            individualIngredient = [NSString stringWithFormat:@"%@\n",temp];
            temp = @"";
            listIngredients = [listIngredients stringByAppendingString:individualIngredient];
        }
        size = [listIngredients sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:11]}];
        adjustedSize = CGSizeMake(ceilf(size.width), ceilf(size.height));
        
        // Create textview for ingredients
         UITextView *ingredientsList =[[UITextView alloc] initWithFrame:CGRectMake(15,tempView.bounds.size.height,self.screenWidth-20.0f,adjustedSize.height+10)];
        [ingredientsList setFont:[UIFont systemFontOfSize:11]];
        ingredientsList.text = listIngredients;
        [ingredientsList setTextAlignment:NSTextAlignmentLeft];
         ingredientsList.backgroundColor = [UIColor colorWithRed:(246/255.0) green:(238/255.0) blue:(246/255.0) alpha:1.000];
        
        // Add textview to view and resize view
        newFrame.size.height = ingredientsList.frame.size.height;
        tempView.frame = CGRectMake(0,0,self.screenWidth,tempView.frame.size.height + newFrame.size.height);
        [tempView addSubview:ingredientsList];
    }
    
    // Create ingredients view
    self.ingredientsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, tempView.frame.size.height)];
    self.ingredientsView.backgroundColor = [UIColor colorWithRed:(246/255.0) green:(238/255.0) blue:(246/255.0) alpha:1.000];
    [self.ingredientsView addSubview:tempView];
}


-(NSMutableAttributedString*)createAtrributedStringForInstructions:(NSArray*)instructions {
    NSString *instruction = @"";
    NSString *instructionStep = @"";
    NSMutableAttributedString *instructionList = [[NSMutableAttributedString alloc]init];
    NSDictionary *defaultAttrs = @{NSFontAttributeName : [UIFont systemFontOfSize:11]};
    NSDictionary *boldAttrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:11]};
    
    for (int i=0; i<instructions.count-1; i++) {
        instructionStep = [NSString stringWithFormat: @"Step %d: ",i+1];
        NSAttributedString *attributedInstructionStep = [[NSAttributedString alloc] initWithString:instructionStep attributes:boldAttrs];
        
        instruction = [NSString stringWithFormat: @"%@\n\n",instructions[i]];
        NSAttributedString *attributedinstruction = [[NSAttributedString alloc] initWithString:instruction attributes:defaultAttrs];
        
        [instructionList appendAttributedString:attributedInstructionStep];
        [instructionList appendAttributedString:attributedinstruction];
    }
    return instructionList;
}

-(void)createInstructionsView {
    NSArray *details = [self.recipe.recipeDetails allObjects];
    CGSize size, adjustedSize;
    CGRect newFrame;
    NSArray *instructionsArray;
    NSMutableAttributedString *instructionList = [[NSMutableAttributedString alloc]init];
    
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth,0)];
    tempView.backgroundColor = [UIColor colorWithRed:(246/255.0) green:(238/255.0) blue:(246/255.0) alpha:1.000];
    
    // create subviews
    for (RecipeDetail *detail in details) {
        size = [detail.subTitle sizeWithAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:12]}];
        adjustedSize = CGSizeMake(ceilf(size.width), ceilf(size.height));
        
        // Create label for sub-title
        UILabel *recipeSubTitle =[[UILabel alloc] initWithFrame:CGRectMake(10,tempView.frame.size.height, self.screenWidth-10.0f,adjustedSize.height+10)];
        [recipeSubTitle setFont:[UIFont boldSystemFontOfSize:12]];
        recipeSubTitle.text = detail.subTitle;
        [recipeSubTitle setTextAlignment:NSTextAlignmentLeft];
        [recipeSubTitle setBaselineAdjustment:UIBaselineAdjustmentAlignBaselines];
        recipeSubTitle.lineBreakMode = NSLineBreakByWordWrapping;
        recipeSubTitle.numberOfLines = 2;
        
        // Add label to view and resize view
        newFrame.size.height = recipeSubTitle.frame.size.height;
        tempView.frame = CGRectMake(0,0,self.screenWidth,tempView.frame.size.height + newFrame.size.height);
        [tempView addSubview:recipeSubTitle];
        
        // Create textview for instructions
        instructionsArray = [detail.instructions componentsSeparatedByString:@"*"];
        instructionList = [self createAtrributedStringForInstructions:instructionsArray];
        UITextView *instructions =[[UITextView alloc] initWithFrame:CGRectMake(15,tempView.bounds.size.height,self.screenWidth-20.0f,10.0f)];
        instructions.textContainerInset = UIEdgeInsetsZero;
        instructions.attributedText = instructionList;
        CGRect newTextViewFrame = [instructions.attributedText boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.view.frame)-8.0f, 9999.0f) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil];
        CGFloat newHeight = ceilf(newTextViewFrame.size.height);
        instructions.frame = CGRectMake(15,tempView.bounds.size.height,self.screenWidth-20.0f,newHeight);
        [instructions setTextAlignment:NSTextAlignmentLeft];
        instructions.backgroundColor = [UIColor colorWithRed:(246/255.0) green:(238/255.0) blue:(246/255.0) alpha:1.000];
        
        // Add textview to view and resize view
        newFrame.size.height = instructions.frame.size.height;
        tempView.frame = CGRectMake(0,0,self.screenWidth,tempView.frame.size.height + newFrame.size.height);
        [tempView addSubview:instructions];
    }
    // Create instructions for assembly - TO DOOOO
    // Create label for sub-title
    NSString *assembly = @"Assembly of the Cake:";
    size = [assembly sizeWithAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:12]}];
    adjustedSize = CGSizeMake(ceilf(size.width), ceilf(size.height));
    UILabel *assemblySubTitle =[[UILabel alloc] initWithFrame:CGRectMake(10,tempView.frame.size.height, self.screenWidth-10.0f,adjustedSize.height+10)];
    [assemblySubTitle setFont:[UIFont boldSystemFontOfSize:12]];
    assemblySubTitle.text = assembly;
    [assemblySubTitle setTextAlignment:NSTextAlignmentLeft];
    [assemblySubTitle setBaselineAdjustment:UIBaselineAdjustmentAlignBaselines];
    assemblySubTitle.lineBreakMode = NSLineBreakByWordWrapping;
    assemblySubTitle.numberOfLines = 2;
    
    // Add label to view and resize view
    newFrame.size.height = assemblySubTitle.frame.size.height;
    tempView.frame = CGRectMake(0,0,self.screenWidth,tempView.frame.size.height + newFrame.size.height);
    [tempView addSubview:assemblySubTitle];
    
    // Create textview for instructions
    instructionsArray = [self.recipe.howToAssemble componentsSeparatedByString:@"*"];
    instructionList = [self createAtrributedStringForInstructions:instructionsArray];
    
    UITextView *instructions =[[UITextView alloc] initWithFrame:CGRectMake(15,tempView.bounds.size.height,self.screenWidth-20.0f,10.0f)];
    instructions.textContainerInset = UIEdgeInsetsZero;
    instructions.attributedText = instructionList;
    CGRect newTextViewFrame = [instructions.attributedText boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.view.frame)-8.0f, 9999.0f) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil];
    CGFloat newHeight = ceilf(newTextViewFrame.size.height);
    instructions.frame = CGRectMake(15,tempView.bounds.size.height,self.screenWidth-20.0f,newHeight);
    [instructions setTextAlignment:NSTextAlignmentLeft];
    instructions.backgroundColor = [UIColor colorWithRed:(246/255.0) green:(238/255.0) blue:(246/255.0) alpha:1.000];
    
    // Add textview to view and resize view
    newFrame.size.height = instructions.frame.size.height;
    tempView.frame = CGRectMake(0,0,self.screenWidth,tempView.frame.size.height + newFrame.size.height);
    [tempView addSubview:instructions];
    
    // Create instructions view
    self.instructionsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, tempView.frame.size.height+ 10.0f)];
    self.instructionsView.backgroundColor = [UIColor colorWithRed:(246/255.0) green:(238/255.0) blue:(246/255.0) alpha:1.000];
    [self.instructionsView addSubview:tempView];
}


-(void)addHeadersAndViewsToAccordionView {
    [self.accordion addHeader:self.headerButton withView:self.headerView];
    [self.accordion addHeader:self.ingredientsButton withView:self.ingredientsView];
    [self.accordion addHeader:self.instructionsButton withView:self.instructionsView];
    [self.accordion setNeedsLayout];
    
    // Set this if you want to allow multiple selection
    [self.accordion setAllowsMultipleSelection:YES];
    
    // Set this to NO if you want to have at least one open section at all times
    [self.accordion setAllowsEmptySelection:YES];
}


-(BOOL)stringIsNullOrEmpty:(NSString*)string {
    return string.length == 0;
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
