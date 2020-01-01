//
//  firstappViewController.h
//  Register1
//
//  Created by Jarrett Chen on 2/12/14.
//  Copyright (c) 2014 Jarrett Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassRegViewController.h"
#import "InsertWebService.h"
#import "UIImage+ImageEffects.h"

#define IS_IPHONE  ( [[[UIDevice currentDevice] model] rangeOfString:@"iPhone"].location != NSNotFound )
#define IS_IPAD  ( [[[UIDevice currentDevice] model] rangeOfString:@"iPad"].location != NSNotFound )

@interface RegisterViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectContext *demoManagedObjectContext;


@property (strong, nonatomic) UITextField *emailField;
@property (strong, nonatomic) UITextField *passwordField;
@property (strong, nonatomic) UIButton *signUpButton;

@property (nonatomic,strong) NSString *userType;


@end
