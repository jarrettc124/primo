//
//  TeacherStoreViewController.h
//  TeacherApp
//
//  Created by Jarrett Chen on 3/5/14.
//  Copyright (c) 2014 Jarrett Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountViewController.h"
#import "PushWebService.h"
#import "UpdateWebService.h"
#import "TeacherObject+CreateTeacher.h"
#import "StudentObject+CreateClassList.h"
#import "AddStoreViewController.h"
#import "BuyItemsViewController.h"

@interface TeacherStoreViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,UIActionSheetDelegate, AddStoreViewDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectContext *demoManagedObjectContext;


@property (nonatomic, strong) UITableView *storeTable;
@property(nonatomic) UIRefreshControl *refreshControl;
@property(nonatomic,strong) NSString *userType;
@property(nonatomic,strong) NSMutableArray *storeItemsArray;
@property(nonatomic,strong) NSMutableDictionary *storeDict;


//parameters passed in from teacher view
@property(nonatomic,strong) NSString* className;


//student parameters
@property (nonatomic,strong) StudentObject *studentObj;
@property (nonatomic,strong) TeacherObject *teacherObj;

//Add more store paramters
@property (nonatomic) BOOL didAddstore;

//@property (strong,nonatomic) NSNumber *studentCoinsValue;
//@property (nonatomic,strong) NSString *studentObjectID;
//@property (nonatomic,strong) NSString *teachersID;
//@property (nonatomic,strong) NSString *nameOfStudent;
//@property (nonatomic,strong) NSString *teachersName;

@end
