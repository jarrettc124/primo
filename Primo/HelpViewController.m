//
//  HelpViewController.m
//  Primo
//
//  Created by Jarrett Chen on 6/16/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()

@property (nonatomic,strong) UITextField *emailField;

@end

@implementation HelpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:self.view.frame];
    [backgroundView setImage:[UIImage imageNamed:@"blackboardBackground"]];
    backgroundView.userInteractionEnabled=YES;
    [self.view addSubview:backgroundView];
    
    //Forgot Password
    self.navigationItem.title=@"Password Recovery";
    
    UILabel *directionLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 80, self.view.frame.size.width-40, 80)];
    directionLabel.numberOfLines=0;
    directionLabel.textColor = [UIColor whiteColor];
    directionLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    directionLabel.text = @"Enter your email you registered for LCEdu. Your password will be sent to you.";
    [self.view addSubview:directionLabel];
    
    self.emailField = [[UITextField alloc]initWithFrame:CGRectMake(30,directionLabel.frame.origin.y+directionLabel.frame.size.height+20, self.view.frame.size.width-60, 30)];
    self.emailField.placeholder = @"Email";
    self.emailField.borderStyle=UITextBorderStyleRoundedRect;
    [self.emailField addTarget:self action:@selector(checkCondition) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:self.emailField];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(forgotPasswordAction)];
    [self.navigationItem setRightBarButtonItem:doneButton];
    
    [self checkCondition];

}

-(void)viewDidAppear:(BOOL)animated{
    [self.emailField becomeFirstResponder];
}

-(void)checkCondition{
    
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    if  ([emailTest evaluateWithObject:self.emailField.text] != YES )
    {
        self.navigationItem.rightBarButtonItem.enabled=NO;
    }
    else{
        self.navigationItem.rightBarButtonItem.enabled=YES;
    }
    
}



-(void)forgotPasswordAction{
    
    //Disable to button
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
    
    
    QueryWebService *query = [[QueryWebService alloc]initWithTable:@"User"];
    [query selectColumnWhere:@"Email" equalTo:self.emailField.text];
    [query findAllObjectsInRowWithCompletion:^(NSError *error, NSArray *rows) {
       
        if ([rows count] !=1) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enter a valid email address" message:@"Please try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
            //Stop animation
            [loading stopAnimating];
            [loading removeFromSuperview];
            [loadingView removeFromSuperview];
            
            //Enable the button
            self.navigationItem.rightBarButtonItem.enabled=YES;
            self.navigationItem.hidesBackButton=NO;

        }
        else{
            
            NSString *post = [NSString stringWithFormat:@"to_email=%@",self.emailField.text];
            
            NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
            
            NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:[NSURL URLWithString:@"https://lcedu-php.herokuapp.com/user_login.php"]];
            [request setHTTPMethod:@"POST"];
            [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:postData];
            
            NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
            NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
            NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [loading stopAnimating];
                    [loading removeFromSuperview];
                    [loadingView removeFromSuperview];
                    
                    //Enable the button
                    self.navigationItem.rightBarButtonItem.enabled=YES;
                    self.navigationItem.hidesBackButton=NO;
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Your Password is sent to your email" message:@"Done." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                });
                
            }];
            [task resume];

        }
        
    }];
}

@end
