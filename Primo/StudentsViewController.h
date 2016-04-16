//
//  ViewController.h
//  tableViewExample
//
//  Created by Jarrett Chen on 2/19/14.
//  Copyright (c) 2014 Jarrett Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuTable.h"
#import "manageCoinView.h"
#import "AddViewController.h"
#import "MonthLogViewController.h"
#import "AnnouncementObject.h"
#import "ClassObject+CreateClass.h"
#import "StudentObject+CreateClassList.h"
#import "QueryWebService.h"
#import "UpdateWebService.h"
#import "StudentGroupViewController.h"
#import "PieChartViewController.h"

@interface StudentsViewController : UIViewController  <UITableViewDataSource, UITableViewDelegate,UIActionSheetDelegate,UIPickerViewDelegate,UIPickerViewDataSource,AddViewDelegate>

@property (nonatomic,strong) UITableView *studentTable;
@property(nonatomic,strong) NSMutableArray *studentSignedUpArray;

@property(nonatomic,strong) NSString *className;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectContext *demoManagedObjectContext;
@property(nonatomic,strong) ClassObject *classObj;

-(NSArray*)sortStudentsBy:(NSString*)sortBy;
-(NSMutableArray*)sortArrayFinal:(NSArray*)arrayToSort;

-(void)updateTableFromDatabaseIntoCore;

@end
