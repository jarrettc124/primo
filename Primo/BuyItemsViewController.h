//
//  BuyItemsViewController.h
//  TeacherApp
//
//  Created by Jarrett Chen on 3/16/14.
//  Copyright (c) 2014 Jarrett Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreObject.h"
#import "PushWebService.h"
#import "LogWebService.h"
#import "StudentObject+CreateClassList.h"
#import "ClassObject+CreateClass.h"
#import "AnnouncementObject.h"

#define IS_IPHONE  ( [[[UIDevice currentDevice] model] rangeOfString:@"iPhone"].location != NSNotFound )
#define IS_IPAD  ( [[[UIDevice currentDevice] model] rangeOfString:@"iPad"].location != NSNotFound )

//@protocol BuyItemsDelegate;
//@class BuyItemsViewController;
//
//@protocol BuyItemsDelegate <NSObject>
//
//-(void)buyingComplete:(BuyItemsViewController*)viewController;
//
//@end


@interface BuyItemsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>


@property(nonatomic,strong) StoreObject *storeItem;

//parameters passed in
@property (nonatomic,strong) NSMutableArray *signedInStudents;
@property(nonatomic,strong) NSString* className;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectContext *demoManagedObjectContext;

//@property (nonatomic,unsafe_unretained) id<BuyItemsDelegate> delegate;


@end
