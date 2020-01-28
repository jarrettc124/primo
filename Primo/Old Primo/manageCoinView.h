//
//  manageCoinView.h
//  TeacherApp
//
//  Created by Jarrett Chen on 3/12/14.
//  Copyright (c) 2014 Jarrett Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudentObject+CreateClassList.h"
#import "LogWebService.h"

#define IS_IPHONE  ( [[[UIDevice currentDevice] model] rangeOfString:@"iPhone"].location != NSNotFound )
#define IS_IPAD  ( [[[UIDevice currentDevice] model] rangeOfString:@"iPad"].location != NSNotFound )

@interface manageCoinView : UIView

@property (nonatomic,strong) UITextField *coinsField;
@property (nonatomic,strong) UIButton *addButtonGroupButton;
@property (nonatomic,strong) UIButton *minusButtonGroupButton;

@property (nonatomic,strong) UIImageView *linedPaperBackground;
@property (nonatomic,strong) UIImageView *holesLinedPaperBackground;

@property (nonatomic,strong) NSString *className;
@property (nonatomic,strong) NSString *teacherName;

@property (nonatomic) BOOL isOpen;
@property (nonatomic,strong) NSArray *hiddenState;
@property (nonatomic,strong) NSArray *showState;

@property (nonatomic,strong) UILabel *directLabel;

-(void)manageCoinsWithSelectedArray:(NSArray*)nameOfSelectedArrays studentArray:(NSArray*)studentOfArray inManagedObjectContext:(NSManagedObjectContext*)context typeOfSign:(BOOL)sign;
//-(void)animateCoinViewUpAndDown:(UITableView*)table;
@end
