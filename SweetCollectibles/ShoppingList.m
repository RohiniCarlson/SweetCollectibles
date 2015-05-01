//
//  ShoppingList.m
//  SweetCollectibles
//
//  Created by it-högskolan on 2015-04-15.
//  Copyright (c) 2015 it-högskolan. All rights reserved.
//

#import "ShoppingList.h"
#import "Recipe.h"
#import "RecipeDetail.h"
#import "Ingredient.h"
#import "IngredientObject.h"
#import "AccordionView.h" // code included from https://github.com/appsome/AccordionView

@interface ShoppingList ()
@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) NSString *recipeTitles;
@property (nonatomic) NSMutableDictionary * shoppingList;
@property (nonatomic) UIButton *shoppingListButton;
@property (nonatomic) UIView *shoppingListView;
@property (nonatomic) AccordionView *accordion;
@property (nonatomic) CGFloat screenWidth;
@property (nonatomic) CGFloat screenHeight;
@end

@implementation ShoppingList

- (void)viewDidLoad {
    [super viewDidLoad];
    self.shoppingList = [[NSMutableDictionary alloc] init];
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.translucent = NO;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    self.screenWidth = screenRect.size.width;
    self.screenHeight = screenRect.size.height;
    [self createAccordionView];
    [self createAndStyleShoppingListButton];
    [self createShoppingListView];
    [self addHeadersAndViewsToAccordionView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)createAccordionView{
    self.accordion = [[AccordionView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    self.accordion.backgroundColor = [UIColor colorWithRed:(246/255.0) green:(238/255.0) blue:(246/255.0) alpha:1.000];
    [self.view addSubview:self.accordion];
}

-(void)createAndStyleShoppingListButton{
    self.shoppingListButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 30)];
    self.shoppingListButton.titleLabel.numberOfLines = 1;
    self.shoppingListButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.shoppingListButton.titleLabel.lineBreakMode = NSLineBreakByClipping;
    self.shoppingListButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.shoppingListButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [self.shoppingListButton setTitle:@"Shopping List For" forState:UIControlStateNormal];
    [self.shoppingListButton setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    self.shoppingListButton.backgroundColor = [UIColor colorWithRed:(153/255.0) green:(153/255.0) blue:(204/255.0) alpha:1.000];
    [self.shoppingListButton setImage:[UIImage imageNamed:@"expand"] forState:UIControlStateNormal];
}

-(NSString*)createSubstring:(NSString*)word {
    NSString *newWord;
    NSUInteger startIndex = [word rangeOfString:word options:NSCaseInsensitiveSearch].location;
    NSUInteger lengthOfWord = word.length;
    newWord = [word substringFromIndex:startIndex+lengthOfWord];
    return newWord;
}

-(NSString*)addToShoppingList {
    NSString *recipeTitles = @"";
    for (Recipe *recipe in self.recipeList) {
        NSArray *recipeDetails = [recipe.recipeDetails allObjects];
        for (RecipeDetail *recipeDetail in recipeDetails) {
            NSArray *ingredients = [recipeDetail.ingredients allObjects];
            for (Ingredient *ingredient in ingredients) {
                NSString *name = ingredient.ingredientType;
                NSString *key = @"";
                if ([name rangeOfString:@"egg white" options:NSCaseInsensitiveSearch].location != NSNotFound) {
                    key = @"egg white";
                    name = [self createSubstring:name];
                } else if ([name rangeOfString:@"egg" options:NSCaseInsensitiveSearch].location != NSNotFound) {
                    key = @"egg";
                } else if ([name rangeOfString:@"unsalted butter" options:NSCaseInsensitiveSearch].location != NSNotFound) {
                    key = @"unsalted butter";
                    name = [self createSubstring:name];
                } else if ([name rangeOfString:@"salt" options:NSCaseInsensitiveSearch].location != NSNotFound) {
                    key = @"salt";
                } else if ([name rangeOfString:@"dark chocolate" options:NSCaseInsensitiveSearch].location != NSNotFound) {
                    key = @"dark chocolate";
                } else if ([name rangeOfString:@"unsweetened chocolate" options:NSCaseInsensitiveSearch].location != NSNotFound) {
                    key = @"unsweetened chocolate";
                } else if ([name rangeOfString:@"coffee" options:NSCaseInsensitiveSearch].location != NSNotFound) {
                    key = @"coffee";
                } else {
                    if ([name rangeOfString:@")"].location != NSNotFound) {
                        name = [name substringFromIndex:[name rangeOfString:@")"].location +2 ];
                        key = name;
                    }
                    if ([key rangeOfString:@","].location != NSNotFound) {
                        NSUInteger index = [key rangeOfString:@","].location;
                        key = [key substringToIndex:index];
                    }
                }
                IngredientObject *ingredientObject = [[IngredientObject alloc]init];
                ingredientObject.amount = ingredient.amount;
                if (ingredient.unitOfMeasure == nil) {
                   ingredientObject.unitOfMeasure = @"none";
                } else {
                    ingredientObject.unitOfMeasure = ingredient.unitOfMeasure;
                }
                IngredientObject *savedIngredient;
                if ((savedIngredient = [self.shoppingList objectForKey:key])) {
                        savedIngredient.amount = [NSNumber numberWithDouble:[savedIngredient.amount doubleValue]  + [ingredientObject.amount doubleValue]];
                        [self.shoppingList setObject:savedIngredient forKey:key];
                    
                } else {
                    [self.shoppingList setObject:ingredientObject forKey:key];
                }
            }
        }
        NSString *recipeTitle = [NSString stringWithFormat:@"%@*",recipe.title];
        recipeTitles = [recipeTitles stringByAppendingString:recipeTitle];
    }
    return recipeTitles;
}

-(NSAttributedString*)createShoppingList {
    IngredientObject *ingredient = [[IngredientObject alloc] init];
    
    NSString *listItem;
    NSString *shoppingList = @"";
    NSString *ingredientType;
    for (id key in self.shoppingList) {
        ingredient = [self.shoppingList objectForKey:key];
        ingredientType = key;
        if ([ingredient.unitOfMeasure isEqualToString:@"none"] && [ingredient.amount doubleValue] == 0) {
            listItem = ingredientType;
        } else if([ingredient.unitOfMeasure isEqualToString:@"none"] && [ingredient.amount doubleValue] != 0) {
            if ([@"egg" isEqualToString:key] && [ingredient.amount doubleValue] > 1) {
                ingredientType = @"eggs";
            } else {
                ingredientType = key;
            }
            listItem = [NSString stringWithFormat:@"%@ %@",ingredient.amount, ingredientType ];
        } else {
            listItem = [NSString stringWithFormat:@"%@ %@ %@",ingredient.amount, ingredient.unitOfMeasure, ingredientType];
        }
        shoppingList = [shoppingList stringByAppendingString:[NSString stringWithFormat: @"%@\n\n",listItem]];
    }
    
    NSDictionary *defaultAttrs = @{NSFontAttributeName : [UIFont systemFontOfSize:11]};
    NSAttributedString *attributedShoppingList =  [[NSAttributedString alloc] initWithString:shoppingList attributes:defaultAttrs];
    return attributedShoppingList;
}

-(void)createShoppingListView {
    CGRect newFrame;
    
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth,0)];
    tempView.backgroundColor = [UIColor colorWithRed:(246/255.0) green:(238/255.0) blue:(246/255.0) alpha:1.000];
    
    // Create text view for recipe titles
    NSArray *titlesArray = [[self addToShoppingList] componentsSeparatedByString:@"*"];
    NSString *titleString = @"";
    for (int i=0; i<titlesArray.count-1; i++) {
        NSString *temp = titlesArray[i];
        temp = [NSString stringWithFormat:@"%@\n\n",temp];
        
        titleString = [titleString stringByAppendingString:temp];
    }
    NSDictionary *boldAttrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:14]};
    NSAttributedString *attributedShoppingList =  [[NSAttributedString alloc] initWithString:titleString attributes:boldAttrs];
    
    UITextView *title =[[UITextView alloc] initWithFrame:CGRectMake(0,tempView.bounds.size.height,self.screenWidth-5.0f,10.0f)];
    title.textContainerInset = UIEdgeInsetsZero;
    title.attributedText = attributedShoppingList;
    CGRect newTextViewFrame = [title.attributedText boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.view.frame)-8.0f, 9999.0f) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil];
    CGFloat newHeight = ceilf(newTextViewFrame.size.height);
    title.frame = CGRectMake(10,tempView.bounds.size.height,self.screenWidth-10.0f,newHeight);
    [title setTextAlignment:NSTextAlignmentLeft];
    title.backgroundColor = [UIColor colorWithRed:(246/255.0) green:(238/255.0) blue:(246/255.0) alpha:1.000];
    
    // Add textview to view and resize view
    newFrame.size.height = title.frame.size.height;
    tempView.frame = CGRectMake(0,0,self.screenWidth,tempView.frame.size.height + newFrame.size.height);
    [tempView addSubview:title];
    
    // Create text view for shopping list
    NSAttributedString *shoppingList = [self createShoppingList];
    
    UITextView *list =[[UITextView alloc] initWithFrame:CGRectMake(15,tempView.bounds.size.height,self.screenWidth-10.0f,10.0f)];
    list.textContainerInset = UIEdgeInsetsZero;
    list.attributedText = shoppingList;
    newTextViewFrame = [list.attributedText boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.view.frame)-8.0f, 9999.0f) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil];
    newHeight = ceilf(newTextViewFrame.size.height);
    list.frame = CGRectMake(15,tempView.bounds.size.height,self.screenWidth-10.0f,newHeight);
    [list setTextAlignment:NSTextAlignmentLeft];
    list.backgroundColor = [UIColor colorWithRed:(246/255.0) green:(238/255.0) blue:(246/255.0) alpha:1.000];
    
    // Add textview to view and resize view
    newFrame.size.height = list.frame.size.height;
    tempView.frame = CGRectMake(0,0,self.screenWidth,tempView.frame.size.height + newFrame.size.height);
    [tempView addSubview:list];
    
    
    // Create shopping list view
    self.shoppingListView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, tempView.frame.size.height)];
    self.shoppingListView.backgroundColor = [UIColor colorWithRed:(246/255.0) green:(238/255.0) blue:(246/255.0) alpha:1.000];
    [self.shoppingListView addSubview:tempView];
}

-(void)addHeadersAndViewsToAccordionView {
    [self.accordion addHeader:self.shoppingListButton withView:self.shoppingListView];
    
    [self.accordion setNeedsLayout];
    
    // Set this if you want to allow multiple selection
    [self.accordion setAllowsMultipleSelection:YES];
    
    // Set this to NO if you want to have at least one open section at all times
    [self.accordion setAllowsEmptySelection:YES];
}

@end
