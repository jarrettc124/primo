//
//  DemoStoreViewController.h
//  Primo
//
//  Created by Jarrett Chen on 8/27/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DemoBuyItemsViewController.h"
#import "DemoStoreObject+CreateStore.h"
#import "DemoAddStoreViewController.h"
#import "DemoStudentObject+CreateClassList.h"
#import "BouncingPencil.h"

#define IS_IPHONE  ( [[[UIDevice currentDevice] model] rangeOfString:@"iPhone"].location != NSNotFound )
#define IS_IPAD  ( [[[UIDevice currentDevice] model] rangeOfString:@"iPad"].location != NSNotFound )

@interface DemoStoreViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>

@property (nonatomic,strong) NSString *className;
@property (nonatomic,strong) NSString *userType;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectContext *demoManagedObjectContext;

@property (nonatomic,strong) DemoStudentObject *studentObj;


@end
