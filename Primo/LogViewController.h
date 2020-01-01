//
//  LogViewController.h
//  TeacherApp
//
//  Created by Jarrett Chen on 3/24/14.
//  Copyright (c) 2014 Jarrett Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LogWebService.h"
#import "StudentObject+CreateClassList.h"
#import "AnnouncementObject.h"

@interface LogViewController : UIViewController

@property (nonatomic) NSInteger monthNumberInLogVC;
@property (nonatomic,strong) NSString *classNameInLog;
@property (nonatomic,strong) NSString *monthLabelStringInLogVC;
@property (nonatomic,strong) NSString *teacherID;

@property(nonatomic,strong)NSMutableArray *monthsArray;

//Teacher's parameters
@property(nonatomic,strong)NSString *teachersLogOptionInLog;
@property(nonatomic,strong)StudentObject *selectedStudentObjFromClassTable;
@property (strong, nonatomic) NSManagedObjectContext *demoManagedObjectContext;


//Broadcast Log
@property(nonatomic,strong)NSString *previousSegue;
@end
