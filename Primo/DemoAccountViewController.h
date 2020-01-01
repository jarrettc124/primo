//
//  DemoAccountViewController.h
//  Primo
//
//  Created by Jarrett Chen on 8/28/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DemoStudentObject+CreateClassList.h"
#import "DemoEndViewController.h"
#import "DemoPieViewController.h"

#define IS_IPHONE  ( [[[UIDevice currentDevice] model] rangeOfString:@"iPhone"].location != NSNotFound )
#define IS_IPAD  ( [[[UIDevice currentDevice] model] rangeOfString:@"iPad"].location != NSNotFound )

@interface DemoAccountViewController : UIViewController

@property (nonatomic,strong) DemoStudentObject *studentObj;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectContext *demoManagedObjectContext;

@property (nonatomic,strong) NSString *userType;
@end
