//
//  BroadcastMoreViewController.h
//  Primo
//
//  Created by Jarrett Chen on 5/19/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MonthLogViewController.h"

#define IS_IPHONE  ( [[[UIDevice currentDevice] model] rangeOfString:@"iPhone"].location != NSNotFound )
#define IS_IPAD  ( [[[UIDevice currentDevice] model] rangeOfString:@"iPad"].location != NSNotFound )
@interface BroadcastMoreViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,strong) NSManagedObjectContext *demoManagedObjectContext;

@property (nonatomic,strong) NSDictionary *announcementObj;

@property(nonatomic,strong) NSArray *tableArray;
@property(nonatomic,strong) NSArray *labelArray;

//pass in variables to query for log
@property(nonatomic,strong) NSString *className;

//student pass in
@property(nonatomic,strong) StudentObject *studentObj;

@end
