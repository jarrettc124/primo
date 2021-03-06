//
//  DemoPieViewController.h
//  Primo
//
//  Created by Jarrett Chen on 8/27/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYPieChart.h"
#import "DemoStudentObject+CreateClassList.h"
#import "DemoEndViewController.h"

#define IS_IPHONE  ( [[[UIDevice currentDevice] model] rangeOfString:@"iPhone"].location != NSNotFound )
#define IS_IPAD  ( [[[UIDevice currentDevice] model] rangeOfString:@"iPad"].location != NSNotFound )

@interface DemoPieViewController : UIViewController<XYPieChartDataSource,XYPieChartDelegate>

@property (nonatomic,strong) DemoStudentObject *selectedStudent;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectContext *demoManagedObjectContext;

@property (nonatomic,strong) NSString *userType;

@end
