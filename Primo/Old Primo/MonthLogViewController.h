//
//  MonthLogViewController.h
//  TeacherApp
//
//  Created by Jarrett Chen on 3/24/14.
//  Copyright (c) 2014 Jarrett Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LogViewController.h"
#import "StudentObject+CreateClassList.h"

#define IS_IPHONE  ( [[[UIDevice currentDevice] model] rangeOfString:@"iPhone"].location != NSNotFound )
#define IS_IPAD  ( [[[UIDevice currentDevice] model] rangeOfString:@"iPad"].location != NSNotFound )

@interface MonthLogViewController : UIViewController

@property (nonatomic,strong) NSString *previousSegue;

//Teacher's parameters

@property(nonatomic,strong) NSString *teachersLogOption;

@property (nonatomic,strong) NSString *classNameInMonth;
@property (nonatomic,strong) NSString *teacherID;

@property (strong, nonatomic) NSMutableArray *months;
@property (nonatomic,strong) NSString *monthLabelStringInMonthVC;

@property(nonatomic) NSInteger currentMonth;

//teacher and student
@property (nonatomic,strong) StudentObject *selectedStudentObjFromClassTable;
@property (strong, nonatomic) NSManagedObjectContext *demoManagedObjectContext;

//broadcast log


@end
