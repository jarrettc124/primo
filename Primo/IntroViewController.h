//
//  IntroViewController.h
//  TeacherApp
//
//  Created by Jarrett Chen on 3/8/14.
//  Copyright (c) 2014 Jarrett Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassRegViewController.h"
#import "LoginViewController.h"
#import "StartViewController.h"
#import "TutorialViewController.h"


#import "DemoRateAppView.h"





#define IS_IPHONE  ( [[[UIDevice currentDevice] model] rangeOfString:@"iPhone"].location != NSNotFound )
#define IS_IPAD  ( [[[UIDevice currentDevice] model] rangeOfString:@"iPad"].location != NSNotFound )

@interface IntroViewController : UIViewController 


//background image

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectContext *demoManagedObjectContext;


@end
