//
//  MenuTable.h
//  TeacherApp
//
//  Created by Jarrett Chen on 3/10/14.
//  Copyright (c) 2014 Jarrett Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

#define IS_IPHONE  ( [[[UIDevice currentDevice] model] rangeOfString:@"iPhone"].location != NSNotFound )
#define IS_IPAD  ( [[[UIDevice currentDevice] model] rangeOfString:@"iPad"].location != NSNotFound )

@interface MenuTable : UIView <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray *menuArray;
@property (nonatomic,strong) NSArray *menuArrayImages;
@property (nonatomic,strong) UITableView *menuViewTable;
-(void)displayStudentMenu;
-(void)menuAnimation;

@property(readonly,nonatomic) UITapGestureRecognizer *tapCloseRecognizer;

//@property(readonly,nonatomic)UISwipeGestureRecognizer *swipeCloseRecognizer;

@property (nonatomic,strong) NSString *sortString;

@property(nonatomic,strong) NSString *menuOption;
@end
