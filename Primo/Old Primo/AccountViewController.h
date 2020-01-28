//
//  AccountViewController.h
//  TeacherApp
//
//  Created by Jarrett Chen on 2/28/14.
//  Copyright (c) 2014 Jarrett Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MonthLogViewController.h"
#import "TeacherInfoViewController.h"
#import "ClassTableViewController.h"
#import "QueryWebService.h"
#import "TeacherObject+CreateTeacher.h"
#import "StudentObject+CreateClassList.h"
#import "PieChartViewController.h"
#import "StudentGroupViewController.h"

@interface AccountViewController : UIViewController

@property (strong, nonatomic) UILabel *coinLabel;
@property (strong, nonatomic) UIActivityIndicatorView *loading;
@property (strong, nonatomic) UILabel *coinText;



-(void)showCoinsAccount;
@property (strong, nonatomic) NSManagedObjectContext *demoManagedObjectContext;


//new with core
@property (nonatomic,strong) StudentObject *studentObj;
@property (nonatomic,strong) TeacherObject *teacherObj;


@end
