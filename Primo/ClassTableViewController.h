//
//  ClassTableViewController.h
//  TeacherApp
//
//  Created by Jarrett Chen on 3/18/14.
//  Copyright (c) 2014 Jarrett Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnnouncementObject.h"
#import "StudentsViewController.h"
#import "ClassNameView.h"
#import "AddViewController.h"
#import "TeacherStoreViewController.h"
#import "ClassMenuView.h"
#import "moreViewController.h"
#import "Reachability.h"
#import "AccountViewController.h"
#import "UIImage+ImageEffects.h"
#import "AnnouncementViewController.h"
#import <CoreData/CoreData.h>
#import "QueryWebService.h"
#import "StudentObject+CreateClassList.h"
#import "ClassObject+CreateClass.h"
#import "TeacherObject+CreateTeacher.h"
#import "UpdateWebService.h"

@interface ClassTableViewController : UIViewController <UITableViewDataSource,UITableViewDelegate, UIActionSheetDelegate,NSURLConnectionDelegate,AddViewDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectContext *demoManagedObjectContext;

@property (nonatomic) BOOL isNewUser;


@property (nonatomic,strong) UITableView *classesTable;
@property (nonatomic,strong) NSString *selectedClass;
@property (nonatomic,strong) UIBarButtonItem *rightBarButton;
@property (nonatomic,strong) ClassNameView *enterClassName;
@property (nonatomic,strong) ClassMenuView *menuClassView;
@property (nonatomic,strong) UIBarButtonItem *menuButton;
@property (nonatomic,strong) NSString *nameOfTeacher;

//teacher labels
@property (nonatomic,strong) UILabel *totalStudentsLabel;
@property (nonatomic,strong) UILabel *totalCoinsLabel;
@property(nonatomic,strong) UILabel *totalSignedUp;
@property(nonatomic,strong) UILabel *totalCoins;
@property(nonatomic,strong) UILabel *totalStudents;
@property(nonatomic,strong) UILabel *totalSigned;
@property(nonatomic,strong) UILabel *nameLabel;
@property(nonatomic,strong) UILabel *moveDirection;

//Student Labels
@property (nonatomic,strong) UILabel *totalStudentCoinsLabel;
@property (nonatomic,strong) UILabel *totalStudentCoins;
@property (nonatomic,strong) UIBarButtonItem *studentAddClassButton;

//TeacherObjects
@property (nonatomic,strong) TeacherObject *teacherObject;

@end
