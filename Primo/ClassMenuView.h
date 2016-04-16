//
//  ClassMenuView.h
//  TeacherApp
//
//  Created by Jarrett Chen on 3/21/14.
//  Copyright (c) 2014 Jarrett Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

#define IS_IPHONE  ( [[[UIDevice currentDevice] model] rangeOfString:@"iPhone"].location != NSNotFound )
#define IS_IPAD  ( [[[UIDevice currentDevice] model] rangeOfString:@"iPad"].location != NSNotFound )

@interface ClassMenuView : UIView

@property(nonatomic,strong) UIButton *addNewClass;
@property(nonatomic,strong) UIButton *moveClass;
@property(nonatomic,strong) UIButton *changeNameClass;


@property(nonatomic,strong) UILabel *addNewClassLabel;
@property(nonatomic,strong) UILabel *moveClassLabel;
@property(nonatomic,strong) UILabel *changeNameClassLabel;

@property(nonatomic,strong) NSString *menuOption;

@property(nonatomic,strong) NSLayoutConstraint *hiddenState;

-(void)removeAllButtonsInMenu;
-(void)menuButtons;
@end
