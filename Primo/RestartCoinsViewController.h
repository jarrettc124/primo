//
//  RestartCoinsViewController.h
//  Primo
//
//  Created by Jarrett Chen on 4/30/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "StudentsViewController.h"
#import "TeacherStoreViewController.h"
#import "moreViewController.h"

@interface RestartCoinsViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic,strong) NSString *classNameInRestart;
@property (nonatomic,strong) UITextField *editCoinTextField;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectContext *demoManagedObjectContext;


@end
