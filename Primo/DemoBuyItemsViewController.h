//
//  DemoBuyItemsViewController.h
//  Primo
//
//  Created by Jarrett Chen on 8/27/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DemoStudentViewController.h"
#import "DemoStoreObject+CreateStore.h"
#import "DemoTeacher+CheckProgress.h"
#import "DemoRateAppView.h"

#define IS_IPHONE  ( [[[UIDevice currentDevice] model] rangeOfString:@"iPhone"].location != NSNotFound )
#define IS_IPAD  ( [[[UIDevice currentDevice] model] rangeOfString:@"iPad"].location != NSNotFound )

@interface DemoBuyItemsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,UIActionSheetDelegate>

@property (nonatomic,strong) UITableView *studentTable;
@property (nonatomic,strong) DemoStoreObject *storeObject;
@property (nonatomic,strong) NSMutableArray *studentsArray;

@property (nonatomic,strong) NSString *className;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectContext *demoManagedObjectContext;

@end
