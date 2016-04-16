//
//  DemoAddStoreViewController.h
//  Primo
//
//  Created by Jarrett Chen on 8/27/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "DemoStoreObject+CreateStore.h"
#import "DemoTeacher+CheckProgress.h"

#define IS_IPHONE  ( [[[UIDevice currentDevice] model] rangeOfString:@"iPhone"].location != NSNotFound )
#define IS_IPAD  ( [[[UIDevice currentDevice] model] rangeOfString:@"iPad"].location != NSNotFound )


@interface DemoAddStoreViewController : UIViewController<UITextFieldDelegate>

@property (nonatomic) int objectStoreCount;
@property (nonatomic,strong) NSString *userType;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectContext *demoManagedObjectContext;

@end
