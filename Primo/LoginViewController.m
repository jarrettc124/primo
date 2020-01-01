//
//  LoginViewController.m
//  Register1
//
//  Created by Jarrett Chen on 2/13/14.
//  Copyright (c) 2014 Jarrett Chen. All rights reserved.
//

#import "LoginViewController.h"
#import "MyUser.h"
@interface LoginViewController ()

@end

@implementation LoginViewController

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
    
    //navigationBar invisible
    self.navigationController.navigationBarHidden =NO;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationItem.title = @"Welcome!";
 
    self.backgroundView = [[UIImageView alloc] init];
    [self.backgroundView setImage:[UIImage imageNamed:@"blackboardBackground"]];
    self.backgroundView.userInteractionEnabled=YES;
    [self.view addSubview:self.backgroundView];
    
    UILabel *loginDirection = [[UILabel alloc]init];
    loginDirection.text = @"Enter Your Login";
    loginDirection.textColor = [UIColor whiteColor];
    loginDirection.font = [UIFont fontWithName:@"Eraser" size:27];
    loginDirection.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:loginDirection];
    

    UIImageView *loginTextfieldImage = [[UIImageView alloc]init];
    loginTextfieldImage.userInteractionEnabled=YES;
    [loginTextfieldImage setImage:[UIImage imageNamed:@"loginTextfield"]];
    [self.view addSubview:loginTextfieldImage];

    //Disable button if not complete
    self.emailField = [[UITextField alloc]initWithFrame:CGRectMake(40,3,240,30)];
    [self.emailField setKeyboardType:UIKeyboardTypeEmailAddress];
    self.emailField.placeholder = @"Email";
    self.emailField.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
    self.emailField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.emailField.backgroundColor = [UIColor whiteColor];
    [self.emailField addTarget:self action:@selector(checkConditionLogin) forControlEvents:UIControlEventEditingChanged];
    _emailField.delegate =self;
    
    self.passwordField = [[UITextField alloc]initWithFrame:CGRectMake(40,38,210,30)];
    self.passwordField.placeholder = @"Password";
    self.passwordField.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
    self.passwordField.secureTextEntry = YES;
    [self.passwordField addTarget:self action:@selector(checkConditionLogin) forControlEvents:UIControlEventEditingChanged];
    _passwordField.delegate=self;
    
    UIButton *forgotPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [forgotPasswordButton setFrame:CGRectMake(self.passwordField.frame.origin.x+self.passwordField.frame.size.width,38,30,30)];
    [forgotPasswordButton setImage:[UIImage imageNamed:@"questionMark"] forState:UIControlStateNormal];
    [forgotPasswordButton addTarget:self action:@selector(forgotPasswordAction) forControlEvents:UIControlEventTouchUpInside];
    
    [loginTextfieldImage addSubview:forgotPasswordButton];
    [loginTextfieldImage addSubview:self.emailField];
    [loginTextfieldImage addSubview:self.passwordField];
    
    UIButton *privacyButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [privacyButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]];
    [privacyButton setTitle:@"Terms of Agreement" forState:UIControlStateNormal];
    [privacyButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [privacyButton addTarget:self action:@selector(privacySegue) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:privacyButton];
    
    //UIrotation
//    if(IS_IPAD){
        self.backgroundView.translatesAutoresizingMaskIntoConstraints=NO;
        loginDirection.translatesAutoresizingMaskIntoConstraints=NO;
        loginTextfieldImage.translatesAutoresizingMaskIntoConstraints=NO;
        privacyButton.translatesAutoresizingMaskIntoConstraints=NO;
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_backgroundView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_backgroundView)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_backgroundView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_backgroundView)]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:loginDirection attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-90-[loginDirection(70)]-20-[loginTextfieldImage(69)]-13-[privacyButton(20)]" options:NSLayoutFormatAlignAllCenterX metrics:0 views:NSDictionaryOfVariableBindings(loginDirection,loginTextfieldImage,privacyButton)]];
        
        
//    }
//    else if (IS_IPHONE){
//        CGFloat heightOfTextFields = 150;
//        [self.backgroundView setFrame:self.view.frame];
//        [loginDirection setFrame:CGRectMake((self.view.frame.size.width/2)-(300/2), 70,300, 70)];
//        [loginTextfieldImage setFrame:CGRectMake(20, heightOfTextFields, 280, 69)];
//        [privacyButton setFrame:CGRectMake(self.view.frame.size.width/2-70,loginTextfieldImage.frame.origin.y + loginTextfieldImage.frame.size.height+10,140,20)];
//        
//    }
}

-(void)forgotPasswordAction{
    [self performSegueWithIdentifier:@"forgotPasswordSegue" sender:self];
}

-(void)privacySegue{
    [self performSegueWithIdentifier:@"termsSegue" sender:self];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [_emailField becomeFirstResponder];

}
-(void)viewWillDisappear:(BOOL)animated{
    
    if([_emailField isFirstResponder]){
        [_passwordField resignFirstResponder];
    }
    else{
        
        [_emailField resignFirstResponder];
    }
    
}
    
    //keyboard stuff
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if([_emailField isFirstResponder]){
        [_passwordField becomeFirstResponder];
        return YES;
    }
    else{
        
        [self loginButtonAction];
        return YES;
    }
}

-(void)checkConditionLogin{

    if (self.navigationItem.rightBarButtonItem == nil) {
    

        if( ![_emailField.text isEqualToString:@""] && ![_passwordField.text isEqualToString:@""]){
                UIBarButtonItem *rightButton=[[UIBarButtonItem alloc]initWithTitle:@"Login" style:UIBarButtonItemStyleDone target:self action:@selector(loginButtonAction)];
                [self.navigationItem setRightBarButtonItem:rightButton];
        }
    }
    else{
        if([_emailField.text isEqualToString:@""] || [_passwordField.text isEqualToString:@""]){
            self.navigationItem.rightBarButtonItem = nil;
        }
        
    }
    
}

-(void)loginButtonAction{
    //Unable all buttons
    [self.view endEditing:YES];
    
    self.navigationItem.rightBarButtonItem.enabled=NO;
    self.navigationItem.hidesBackButton=YES;
    UIView *loadingView = [[UIView alloc]initWithFrame:self.view.frame];
    loadingView.backgroundColor = [UIColor blackColor];
    loadingView.alpha=0.5;
    [self.view addSubview:loadingView];
    
    UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-25, (self.view.frame.size.height)/2, 50, 50)];
    [self.view addSubview:loading];
    [loading setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [loading hidesWhenStopped];
    [loading startAnimating];
    
    
    NSString *lowerEmail = [_emailField.text lowercaseString];
    NSString *devicetoken = [[NSUserDefaults standardUserDefaults] objectForKey:@"DeviceToken"];
    
    //Login to database
    [QueryWebService emailLogin:lowerEmail withPassword:_passwordField.text withCompletionHandler:^(NSError *error, id result) {
        self.navigationItem.rightBarButtonItem.enabled=YES;
        self.navigationItem.hidesBackButton=NO;
        [loadingView removeFromSuperview];
        [loading stopAnimating];
        [loading removeFromSuperview];
        
        
        if (error) {
            NSString *alertTitle= nil;
            NSString *alertMsg = nil;
            
            if(error.code == 404){
                alertTitle = @"Login Error";
                alertMsg = error.userInfo[@"errorMessage"];
            }else{
                alertTitle = @"Error";
            }
            
            UIAlertController *alert =  [UIAlertController alertControllerWithTitle:alertTitle message:alertMsg preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:alertAction];
            [self presentViewController:alert animated:YES completion:nil];

        }else{
            
            // Store the data
            [MyUser storeDefaults:result];
            
            [self performSegueWithIdentifier:@"loginView" sender:self];

        }

    }];

}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"loginView"]){
       ClassTableViewController *classTableVC = (ClassTableViewController*)segue.destinationViewController;
        classTableVC.managedObjectContext = _managedObjectContext;
        classTableVC.demoManagedObjectContext=_demoManagedObjectContext;
    }

    else if ([segue.identifier isEqualToString:@"forgotPasswordSegue"]){
        HelpViewController *helpVC = (HelpViewController*)segue.destinationViewController;
        helpVC.previousSegue=segue.identifier;
    }

}


@end
