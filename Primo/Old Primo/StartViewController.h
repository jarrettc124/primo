//
//  StartViewController.h
//  Primo
//
//  Created by Jarrett Chen on 8/29/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DemoClassViewController.h"
#import "RegisterViewController.h"
#import "UIImage+ImageEffects.h"

#define IS_IPHONE  ( [[[UIDevice currentDevice] model] rangeOfString:@"iPhone"].location != NSNotFound )
#define IS_IPAD  ( [[[UIDevice currentDevice] model] rangeOfString:@"iPad"].location != NSNotFound )

@interface StartViewController : UIViewController

@property (nonatomic) BOOL isDemo;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,strong) NSManagedObjectContext *demoManagedObjectContext;
@end
