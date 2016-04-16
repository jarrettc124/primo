//
//  SettingsViewController.h
//  TeacherApp
//
//  Created by Jarrett Chen on 3/3/14.
//  Copyright (c) 2014 Jarrett Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeleteWebService.h"
#import "SettingsMoreViewController.h"
#import <CoreData/CoreData.h>
#import "TeacherObject+CreateTeacher.h"
#import "ClassObject+CreateClass.h"
#import "StudentObject+CreateClassList.h"

@interface SettingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,UIActionSheetDelegate>
@property (nonatomic) UITableView *settingsTable;
@property (nonatomic, strong) NSArray *settingsArray;
@property (nonatomic, strong) NSString *userType;



@property (nonatomic,strong) NSString *className;
@property (nonatomic,strong) NSString *selectedSection;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectContext *demoManagedObjectContext;


@property (nonatomic,strong) StudentObject *studentObj;
@property (nonatomic,strong) TeacherObject *teacherObj;

@end


