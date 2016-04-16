//
//  SettingsMoreViewController.h
//  Primo
//
//  Created by Jarrett Chen on 6/3/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "UpdateWebService.h"
#import "LaunchViewController.h"


@interface SettingsMoreViewController : UIViewController<UITextFieldDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectContext *demoManagedObjectContext;


@property (nonatomic,strong) NSString *selectedSection;




@end
