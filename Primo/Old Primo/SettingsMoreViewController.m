//
//  SettingsMoreViewController.m
//  Primo
//
//  Created by Jarrett Chen on 6/3/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import "SettingsMoreViewController.h"

@interface SettingsMoreViewController ()

//Change Password
@property (nonatomic,strong) UITextField *oldPasswordField;
@property (nonatomic,strong) UITextField *EnterNewPasswordField;
@property (nonatomic,strong) UITextField *reEnterNewPasswordField;
@property (nonatomic,strong) UIBarButtonItem *changePasswordButton;

//Change Email
@property (nonatomic,strong) UITextField *oldEmailField;
@property (nonatomic,strong) UITextField *EnterNewEmailField;
@property (nonatomic,strong) UITextField *reEnterNewEmailField;
@property (nonatomic,strong) UIBarButtonItem *changeEmailButton;

@end

@implementation SettingsMoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImageView *backgroundView = [[UIImageView alloc] init];
    [backgroundView setImage:[UIImage imageNamed:@"blackboardBackground"]];
    backgroundView.userInteractionEnabled=YES;
    [self.view addSubview:backgroundView];
    
    [self.navigationItem setTitle:self.selectedSection];
    
    UIImageView *textfieldView = [[UIImageView alloc]init];
    textfieldView.userInteractionEnabled=YES;
    [textfieldView setImage:[UIImage imageNamed:@"textfieldThree"]];
    [self.view addSubview:textfieldView];
    
    
    if (IS_IPAD) {
        backgroundView.translatesAutoresizingMaskIntoConstraints=NO;
        textfieldView.translatesAutoresizingMaskIntoConstraints=NO;
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[backgroundView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(backgroundView)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[backgroundView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(backgroundView)]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:textfieldView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-230-[textfieldView(104)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(textfieldView)]];
        [textfieldView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[textfieldView(300)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(textfieldView)]];
    }
    else if (IS_IPHONE){
        [backgroundView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [textfieldView setFrame:CGRectMake(20,90, 280, 104)];
    }
    
    
    if ([self.selectedSection isEqualToString:@"Change Email"]) {
        
        _oldEmailField = [[UITextField alloc] initWithFrame:CGRectMake(5,4, 275, 30)];
        _oldEmailField.borderStyle=UITextBorderStyleNone;
        [_oldEmailField setKeyboardType:UIKeyboardTypeEmailAddress];
        _oldEmailField.placeholder = @"Old Email";
        _oldEmailField.delegate = self;
        [_oldPasswordField addTarget:self action:@selector(checkEmptyConditionsEmail) forControlEvents:UIControlEventEditingChanged];
        [textfieldView addSubview:_oldEmailField];
        
        _EnterNewEmailField = [[UITextField alloc] initWithFrame:CGRectMake(5,39, 275, 30)];
        _EnterNewEmailField.borderStyle=UITextBorderStyleNone;
        [_EnterNewEmailField setKeyboardType:UIKeyboardTypeEmailAddress];
        _EnterNewEmailField.delegate = self;
        _EnterNewEmailField.placeholder=@"New Email";
        [_EnterNewPasswordField addTarget:self action:@selector(checkEmptyConditionsEmail) forControlEvents:UIControlEventEditingChanged];
        [textfieldView addSubview:_EnterNewEmailField];
        
        _reEnterNewEmailField = [[UITextField alloc] initWithFrame:CGRectMake(5,72, 275, 30)];
        _reEnterNewEmailField.borderStyle=UITextBorderStyleNone;
        [_reEnterNewEmailField setKeyboardType:UIKeyboardTypeEmailAddress];
        _reEnterNewEmailField.delegate = self;
        _reEnterNewEmailField.placeholder=@"ReEnter New Email";
        [_reEnterNewEmailField addTarget:self action:@selector(checkEmptyConditionsEmail) forControlEvents:UIControlEventEditingChanged];
        [textfieldView addSubview:_reEnterNewEmailField];
        
        _changeEmailButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(restartEmailActionWithStudentObjectsFromDatabase)];
        [self.navigationItem setRightBarButtonItem:_changeEmailButton];
        [self checkEmptyConditionsEmail];
    }
    else if ([self.selectedSection isEqualToString:@"Change Password"]){
        
        _oldPasswordField = [[UITextField alloc] initWithFrame:CGRectMake(6,4, 274, 30)];
        _oldPasswordField.borderStyle=UITextBorderStyleNone;
        _oldPasswordField.secureTextEntry=YES;
        _oldPasswordField.placeholder = @"Old Password";
        _oldPasswordField.delegate = self;
        [_oldPasswordField addTarget:self action:@selector(checkEmptyConditionsPassword) forControlEvents:UIControlEventEditingChanged];
        [textfieldView addSubview:_oldPasswordField];
        
        _EnterNewPasswordField = [[UITextField alloc] initWithFrame:CGRectMake(6,39, 274, 30)];
        _EnterNewPasswordField.borderStyle=UITextBorderStyleNone;
        _EnterNewPasswordField.secureTextEntry=YES;
        _EnterNewPasswordField.delegate = self;
        _EnterNewPasswordField.placeholder=@"New Password";
        [_EnterNewPasswordField addTarget:self action:@selector(checkEmptyConditionsPassword) forControlEvents:UIControlEventEditingChanged];
        [textfieldView addSubview:_EnterNewPasswordField];
        
        _reEnterNewPasswordField = [[UITextField alloc] initWithFrame:CGRectMake(6,72, 274, 30)];
        _reEnterNewPasswordField.borderStyle=UITextBorderStyleNone;
        _reEnterNewPasswordField.secureTextEntry=YES;
        _reEnterNewPasswordField.delegate = self;
        _reEnterNewPasswordField.placeholder=@"ReEnter New Password";
        [_reEnterNewPasswordField addTarget:self action:@selector(checkEmptyConditionsPassword) forControlEvents:UIControlEventEditingChanged];
        [textfieldView addSubview:_reEnterNewPasswordField];
        
        _changePasswordButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(restartPasswordAction)];
        [self.navigationItem setRightBarButtonItem:_changePasswordButton];

        [self checkEmptyConditionsPassword];
    }

}

-(void)viewDidAppear:(BOOL)animated{
    
    if ([self.selectedSection isEqualToString:@"Change Email"]){
        [_oldEmailField becomeFirstResponder];
    }
    else if ([self.selectedSection isEqualToString:@"Change Password"]){
        [_oldPasswordField becomeFirstResponder];
    }
}

//Change Password Code
-(void)checkEmptyConditionsPassword{
    if ([_oldPasswordField.text isEqualToString:@""] || [_EnterNewPasswordField.text isEqualToString:@""] || [_reEnterNewPasswordField.text isEqualToString:@""]) {
        _changePasswordButton.enabled=NO;
    }
    else{
        _changePasswordButton.enabled=YES;
    }
}

-(void)restartPasswordAction{
//    
//    PFUser *currentUser = [PFUser currentUser];
//    if ([_EnterNewPasswordField.text isEqualToString:_reEnterNewPasswordField.text] && [_oldPasswordField.text isEqualToString:currentUser[@"Recovery"]]) {
//        
//        //Change Password Here
//        [currentUser setPassword:_EnterNewPasswordField.text];
//        [currentUser setObject:_EnterNewPasswordField.text forKey:@"Recovery"];
//        [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//            if (error) {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed." message:@"You must have a network connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [alert show];
//            }
//            else{
//                
//                NSString *emailString = [[NSUserDefaults standardUserDefaults] objectForKey:@"Email"];
//                
//                UpdateWebService *updatePassword = [[UpdateWebService alloc]initWithTable:@"User"];
//                [updatePassword setRowToUpdateWhereColumn:@"Password" equalTo:_EnterNewPasswordField.text];
//                [updatePassword selectRowToUpdateWhereColumn:@"Username" equalTo:emailString];
//                [updatePassword saveUpdateInBackgroundWithBlock:^(NSError *error) {
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Done!" message:@"Your password has changed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                    [alert show];
//                    
//                    [self.navigationController popViewControllerAnimated:YES];
//                }];
//            }
//        }];
//        
//    }
//    else if (![_EnterNewPasswordField.text isEqualToString:_reEnterNewPasswordField.text]){
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Your new passwords don't match" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//    }
//    else if (![_oldPasswordField.text isEqualToString:currentUser[@"Recovery"]]){
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Password" message:@"Input your old password again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//    }
//    else{
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//    }
}

//Change Email Code
-(void)checkEmptyConditionsEmail{
    if ([_oldEmailField.text isEqualToString:@""] || [_EnterNewEmailField.text isEqualToString:@""] || [_reEnterNewEmailField.text isEqualToString:@""]) {
        _changeEmailButton.enabled=NO;
    }
    else{
        _changeEmailButton.enabled=YES;
    }
}

-(void)restartEmailActionWithStudentObjectsFromDatabase{
//    
//    PFUser *currentUser = [PFUser currentUser];
//    NSString *lowerEnterNewEmail = [_EnterNewEmailField.text lowercaseString];
//    NSString *lowerReEnterNewEmail = [_reEnterNewEmailField.text lowercaseString];
//    NSString *lowerOldEmail = [_oldEmailField.text lowercaseString];
//    
//    NSString *userType = [currentUser objectForKey:@"UserType"];
//    if ([lowerEnterNewEmail isEqualToString:lowerReEnterNewEmail] && [lowerOldEmail isEqualToString:currentUser.email]) {
//        //Change Email Here
//        
//        [currentUser setEmail:lowerEnterNewEmail];
//        [currentUser setUsername:lowerEnterNewEmail];
//        [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//            if (error) {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed." message:@"You must have a network connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [alert show];
//            }
//            else{
//                NSString *emailString = [[NSUserDefaults standardUserDefaults] objectForKey:@"Email"];
//                UpdateWebService *updateEmail = [[UpdateWebService alloc]initWithTable:@"User"];
//                [updateEmail setRowToUpdateWhereColumn:@"Username" equalTo:lowerEnterNewEmail];
//                [updateEmail selectRowToUpdateWhereColumn:@"Username" equalTo:emailString];
//                [updateEmail saveUpdateInBackgroundWithBlock:^(NSError *error) {
//                    if (!error) {
//                        [[NSUserDefaults standardUserDefaults] setObject:lowerEnterNewEmail forKey:@"Email"];
//                        [[NSUserDefaults standardUserDefaults] synchronize];
//
//                    }
//                    else{
//                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed." message:@"You must have a network connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                        [alert show];
//                    }
//                }];
//            }
//        }];
//        
//        //
//        if ([userType isEqualToString:@"Teacher"]) {
//            
//            UpdateWebService *updateRows = [[UpdateWebService alloc]initWithTable:@"StudentObject"];
//            [updateRows setRowToUpdateWhereColumn:@"teacherEmail" equalTo:lowerEnterNewEmail];
//            [updateRows selectRowToUpdateWhereColumn:@"teacher" equalTo:objId];
//            [updateRows saveUpdateInBackgroundWithBlock:^(NSError *error) {
//                if (error) {
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed." message:@"You must have a network connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                    [alert show];
//                }
//                else{
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Done!" message:@"Your email has changed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                    [alert show];
//                    
//                    [self.navigationController popViewControllerAnimated:YES];
//                }
//            }];
//            
//        }
//    }
//    else if (![lowerEnterNewEmail isEqualToString:lowerReEnterNewEmail]){
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Your new emails don't match" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//    }
//    else if (![lowerOldEmail isEqualToString:currentUser.email]){
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Email" message:@"Input your old email again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//    }
//    else{
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//    }
}




@end
