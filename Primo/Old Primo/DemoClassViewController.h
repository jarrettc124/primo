//
//  DemoClassViewController.h
//  Primo
//
//  Created by Jarrett Chen on 8/26/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassMenuView.h"
#import "ClassNameView.h"
#import "DemoStudentViewController.h"
#import "DemoStoreViewController.h"
#import "DemoAnnounceViewController.h"
#import "DemoAddStudentsViewController.h"

#import "DemoStudentObject+CreateClassList.h"
#import "DemoTeacherObject+CreateTeacher.h"
#import "DemoAccountViewController.h"

#import "DemoTeacher+CheckProgress.h"
#import "DemoStudent.h"

#import <CoreData/CoreData.h>
#import "UIImage+ImageEffects.h"
#import <QuartzCore/QuartzCore.h>
#import "BouncingPencil.h"

#define IS_IPHONE  ( [[[UIDevice currentDevice] model] rangeOfString:@"iPhone"].location != NSNotFound )
#define IS_IPAD  ( [[[UIDevice currentDevice] model] rangeOfString:@"iPad"].location != NSNotFound )

@interface DemoClassViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (nonatomic,strong) NSString *userType;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectContext *demoManagedObjectContext;


@property (nonatomic,strong) UITableView *classesTable;
@property (nonatomic,strong) NSString *selectedClass;

@property (nonatomic,strong) UIBarButtonItem *rightBarButton;
@property (nonatomic,strong) ClassNameView *enterClassName;
@property (nonatomic,strong) ClassMenuView *menuClassView;
@property (nonatomic,strong) UIBarButtonItem *menuButton;

//teacher labels
@property (nonatomic,strong) UILabel *totalStudentsLabel;
@property (nonatomic,strong) UILabel *totalCoinsLabel;
@property(nonatomic,strong) UILabel *totalSignedUp;
@property(nonatomic,strong) UILabel *totalCoins;
@property(nonatomic,strong) UILabel *totalStudents;
@property(nonatomic,strong) UILabel *totalSigned;
@property(nonatomic,strong) UILabel *moveDirection;

//Student Labels
@property (nonatomic,strong) UILabel *totalStudentCoinsLabel;
@property (nonatomic,strong) UILabel *totalStudentCoins;
@property (nonatomic,strong) UIBarButtonItem *studentAddClassButton;

//TeacherObjects
@property (nonatomic,strong) DemoTeacherObject *teacherObject;

@end
