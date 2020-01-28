//
//  LaunchViewController.h
//  Primo
//
//  Created by Jarrett Chen on 4/18/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassRegViewController.h"
#import "PushWebService.h"
#import "AppDelegate.h"
#import "ClassTableViewController.h"
#import <CoreData/CoreData.h>
#import "IntroViewController.h"

@interface LaunchViewController : UIViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,strong) NSManagedObjectContext *demoManagedObjectContext;

@end
