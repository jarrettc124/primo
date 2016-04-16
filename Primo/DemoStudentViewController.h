//
//  DemoStudentViewController.h
//  Primo
//
//  Created by Jarrett Chen on 8/27/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuTable.h"
#import "manageCoinView.h"
#import "DemoStudentObject+CreateClassList.h"
#import "DemoClassObject+CreateClass.h"
#import "DemoPieViewController.h"
#import <CoreData/CoreData.h>
#import "DemoAddStudentsViewController.h"
#import "DemoEndViewController.h"

#import "DemoStudent+CheckProgress.h"
#import "DemoTeacher+CheckProgress.h"
#import "BouncingPencil.h"


@interface DemoStudentViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>

@property (nonatomic,strong) NSString *className;
@property (nonatomic,strong) NSString *userType;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectContext *demoManagedObjectContext;

@end
