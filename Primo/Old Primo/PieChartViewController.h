//
//  PieChartViewController.h
//  Primo
//
//  Created by Jarrett Chen on 8/23/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYPieChart.h"
#import <QuartzCore/QuartzCore.h>
#import "StudentObject+CreateClassList.h"
#import "QueryWebService.h"
#import "MonthLogViewController.h"

#define IS_IPHONE  ( [[[UIDevice currentDevice] model] rangeOfString:@"iPhone"].location != NSNotFound )
#define IS_IPAD  ( [[[UIDevice currentDevice] model] rangeOfString:@"iPad"].location != NSNotFound )

@interface PieChartViewController : UIViewController<XYPieChartDataSource,XYPieChartDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,strong) StudentObject *selectedStudent;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectContext *demoManagedObjectContext;

@end
