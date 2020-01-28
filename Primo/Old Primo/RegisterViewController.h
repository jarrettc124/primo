//
//  firstappViewController.h
//  Register1
//
//  Created by Jarrett Chen on 2/12/14.
//  Copyright (c) 2014 Jarrett Chen. All rights reserved.
//



#import <UIKit/UIKit.h>

@class RegisterViewController;
@protocol RegisterViewDelegate;
@protocol RegisterViewDelegate <NSObject>
    -(void) didRegister: (RegisterViewController*) viewController;
    -(void) didClickOnPrivacy: (RegisterViewController*) viewController;
@end

#import "ClassRegViewController.h"
#import "InsertWebService.h"
#import "UIImage+ImageEffects.h"

#define IS_IPHONE  ( [[[UIDevice currentDevice] model] rangeOfString:@"iPhone"].location != NSNotFound )
#define IS_IPAD  ( [[[UIDevice currentDevice] model] rangeOfString:@"iPad"].location != NSNotFound )

@interface RegisterViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, weak) id<RegisterViewDelegate> delegate;

@property (nonatomic,strong) NSString *userType;
@property (strong, nonatomic) UITextField *emailField;
@property (strong, nonatomic) UITextField *passwordField;
@property (strong, nonatomic) UIButton *signUpButton;


@end
