//
//  LoginViewController.h
//  Register1
//
//  Created by Jarrett Chen on 2/13/14.
//  Copyright (c) 2014 Jarrett Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PushWebService.h"
#import "HelpViewController.h"
#import "ClassTableViewController.h"

@interface LoginViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) UITextField *emailField;
@property (strong, nonatomic) UITextField *passwordField;
@property (strong,nonatomic) UITextField *trying;

@property (strong, nonatomic) UIImageView *backgroundView;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,strong) NSManagedObjectContext *demoManagedObjectContext;
@end
