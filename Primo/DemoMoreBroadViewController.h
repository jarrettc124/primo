//
//  DemoMoreBroadViewController.h
//  Primo
//
//  Created by Jarrett Chen on 8/27/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DemoBroadcast+CreateBroadcast.h"
#import "DemoEndViewController.h"

#define IS_IPHONE  ( [[[UIDevice currentDevice] model] rangeOfString:@"iPhone"].location != NSNotFound )
#define IS_IPAD  ( [[[UIDevice currentDevice] model] rangeOfString:@"iPad"].location != NSNotFound )


@interface DemoMoreBroadViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) DemoBroadcast *broadcastItem;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectContext *demoManagedObjectContext;

@property (nonatomic,strong) NSString *className;
@property (nonatomic,strong) NSString *userType;

@end
