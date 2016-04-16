//
//  firstappViewController.m
//  Register1
//
//  Created by Jarrett Chen on 2/12/14.
//  Copyright (c) 2014 Jarrett Chen. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()

@property (nonatomic,strong) UIImageView* blackboardView;
@property (nonatomic) BOOL isEditing;
@property (nonatomic,strong) NSMutableDictionary* createParam;

@end

@implementation RegisterViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    _isEditing=NO;
    
    //Short
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
    
    [self.navigationItem setTitle:[NSString stringWithFormat:@"%@",self.userType]];
    
    //background image
    UIImageView *behindView = [[UIImageView alloc] init];
    UIImage *behindViewImage = [UIImage imageNamed:@"signupImg"];
    [behindView setImage: [behindViewImage applyBlurWithRadius:5 tintColor:[UIColor colorWithWhite:0.2 alpha:0.3] saturationDeltaFactor:1.0 maskImage:nil]];
    behindView.userInteractionEnabled=YES;
    
    [self.view addSubview:behindView];
    
    UILabel *welcomeLabel = [UILabel new];
    [welcomeLabel setText:[NSString stringWithFormat:@"Creating a %@ account!", self.userType]];
    [welcomeLabel setNumberOfLines:0];
    [welcomeLabel setTextAlignment:NSTextAlignmentCenter];
    [welcomeLabel setTextColor:[UIColor whiteColor]];
    
    NSMutableAttributedString *underlineString = [[NSMutableAttributedString alloc]initWithString:welcomeLabel.text];
    [underlineString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(11, [self.userType length])];
    [welcomeLabel setAttributedText:underlineString];
    
    [self.view addSubview:welcomeLabel];
    
    //background image
    self.blackboardView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"blackboardBackground"]];
    self.blackboardView.userInteractionEnabled=YES;
    _blackboardView.layer.shadowColor = [UIColor blackColor].CGColor;
    _blackboardView.layer.shadowOffset = CGSizeMake(0, -3);
    _blackboardView.layer.shadowOpacity = 0.5;
    _blackboardView.layer.shadowRadius = 2.0;
    [self.view addSubview:self.blackboardView];
    
    UIImageView *topLogo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"homeworkIcon50x"]];
    [self.blackboardView addSubview:topLogo];
    
    UIImageView *textfieldImage = [[UIImageView alloc]init];
    [textfieldImage setImage:[[UIImage imageNamed:@"loginTextfield"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 50, 0, 5)]];
    textfieldImage.userInteractionEnabled=YES;
    [self.blackboardView addSubview:textfieldImage];
    
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationController.navigationBarHidden = NO;

    //navigationBar
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];

    self.emailField = [[UITextField alloc]init];
    self.emailField.placeholder = @"Enter Email";
    [self.emailField setKeyboardType:UIKeyboardTypeEmailAddress];
    self.emailField.borderStyle = UITextBorderStyleNone;
    self.emailField.autocorrectionType = UITextAutocorrectionTypeNo;
    
    self.passwordField = [[UITextField alloc]init];
    self.passwordField.placeholder = @"Password";
    self.passwordField.secureTextEntry = YES;
    self.passwordField.borderStyle = UITextBorderStyleNone;
    self.passwordField.autocorrectionType = UITextAutocorrectionTypeNo;


    _emailField.delegate = self;
    _passwordField.delegate = self;

    //button
    self.signUpButton= [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.signUpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.signUpButton.layer.cornerRadius=4;
    self.signUpButton.layer.borderWidth = 1.5;
    self.signUpButton.layer.borderColor = [[UIColor whiteColor]CGColor];
    [self.signUpButton.titleLabel setFont:[UIFont fontWithName:@"Eraser" size:18]];
    [self.signUpButton addTarget:self action:@selector(signUpAction:)forControlEvents:UIControlEventTouchDown];
    [self.signUpButton setTitle:@"Sign Up!" forState:UIControlStateNormal];
    [self.blackboardView addSubview:self.signUpButton];

    UILabel *privacyLabel = [[UILabel alloc]init];
    privacyLabel.userInteractionEnabled=YES;
    [privacyLabel setTextColor:[UIColor whiteColor]];
    privacyLabel.numberOfLines=0;
    [self.blackboardView addSubview:privacyLabel];
    
    UIButton *privacyButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [privacyButton.titleLabel setFont:[UIFont fontWithName:@"Eraser" size:13]];
    [privacyButton setTitle:@"Privacy Policy" forState:UIControlStateNormal];
    [privacyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [privacyButton addTarget:self action:@selector(privacySegue) forControlEvents:UIControlEventTouchUpInside];

    if (IS_IPAD) {
        //font
        [welcomeLabel setFont:[UIFont fontWithName:@"TravelingTypewriter" size:50]];
        welcomeLabel.adjustsFontSizeToFitWidth=YES;
        welcomeLabel.minimumScaleFactor=0.5;
        
        [self.view setBackgroundColor:[UIColor blackColor]];
        
        textfieldImage.translatesAutoresizingMaskIntoConstraints=NO;
        _signUpButton.translatesAutoresizingMaskIntoConstraints=NO;
        privacyLabel.translatesAutoresizingMaskIntoConstraints=NO;
        _blackboardView.translatesAutoresizingMaskIntoConstraints=NO;
        behindView.translatesAutoresizingMaskIntoConstraints =NO;
        topLogo.translatesAutoresizingMaskIntoConstraints=NO;
        welcomeLabel.translatesAutoresizingMaskIntoConstraints=NO;
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-155-[welcomeLabel(70)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(welcomeLabel)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[welcomeLabel]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(welcomeLabel)]];
         
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[behindView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(behindView)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[behindView]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(behindView)]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_blackboardView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_blackboardView)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-500-[_blackboardView]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_blackboardView)]];
        
        //badge
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:topLogo attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_blackboardView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:topLogo attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_blackboardView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        
        [topLogo addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topLogo(100)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(topLogo)]];
        
        //Vertical constraints
        [self.blackboardView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-60-[textfieldImage(69)]-20-[_signUpButton(40)]-10-[privacyLabel(50)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(textfieldImage,_signUpButton,privacyLabel)]];
        
        
        //Horizontal constraints
        [self.signUpButton addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_signUpButton(210)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_signUpButton)]];
        [privacyLabel addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[privacyLabel(290)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(privacyLabel)]];
        [privacyLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:13]];
        [privacyLabel setText:[NSString stringWithFormat:@"By signing up you agree to the\nand Terms of Agreement that governs the use of Primo"]];
        
        
        [privacyButton setFrame:CGRectMake(173, -6, 120, 30)];
        [privacyLabel addSubview:privacyButton];

        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:privacyLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:textfieldImage attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_signUpButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        
        self.emailField.frame = CGRectMake(40,4, 340, 30);
        self.passwordField.frame = CGRectMake(40,39, 340, 30);
        
        [textfieldImage addSubview:self.emailField];
        [textfieldImage addSubview:self.passwordField];
        
    }
    else{
        //font
        [welcomeLabel setFont:[UIFont fontWithName:@"TravelingTypewriter" size:23]];
        
        [welcomeLabel setFrame:CGRectMake(10, 70, self.view.frame.size.width-20, 60)];
        [behindView setFrame:CGRectMake(0, 0, self.view.frame.size.width, 338)];
        [_blackboardView setFrame:CGRectMake(0,300,self.view.frame.size.width, self.view.frame.size.height)];

        [topLogo setFrame:CGRectMake(_blackboardView.center.x-25,-25, 50, 50)];
        
        //Long
        [textfieldImage setFrame:CGRectMake(20, 30, self.view.frame.size.width-40, 69)];
        self.signUpButton.frame = CGRectMake((self.view.frame.size.width/2)-105,textfieldImage.frame.origin.y+textfieldImage.frame.size.height+8, 210, 40);
        self.emailField.frame = CGRectMake(40,4, textfieldImage.frame.size.width-80, 30);
        self.passwordField.frame = CGRectMake(40,39, textfieldImage.frame.size.width-80, 30);
    
        [textfieldImage addSubview:self.emailField];
        [textfieldImage addSubview:self.passwordField];
        
        [privacyLabel setFrame:CGRectMake(20, self.signUpButton.frame.origin.y+self.signUpButton.frame.size.height+7,self.view.frame.size.width-20, 50)];
        [privacyLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:13]];
        [privacyLabel setText:@"By signing up you agree to the                                 and Terms of Agreement"];
        
        [privacyButton setFrame:CGRectMake(184, privacyLabel.frame.origin.y+4, 135, 30)];
        [self.blackboardView addSubview:privacyButton];

    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    if ((toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)) {

        if (self.isEditing) {
            [self hideKeyboard];
        }
    }
    else {

        if (self.isEditing) {
            self.blackboardView.center = CGPointMake(self.blackboardView.center.x, self.blackboardView.center.y+350);
            [self hideKeyboard];
        }
    }
}


-(void)privacySegue{
    [self performSegueWithIdentifier:@"privacySegue" sender:self];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if (self.isEditing) {
    
        [self hideKeyboard];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//see if fields are complete
-(void)checkFieldsComplete{
    if ([_emailField.text isEqualToString:@""] || [_passwordField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops! You need to complete all fields" message:@"Check your text fields again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else{
        [self registerNew];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (!_isEditing) {
        _isEditing=YES;
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            if (IS_IPHONE) {
                self.blackboardView.center = CGPointMake(self.blackboardView.center.x, self.blackboardView.center.y-160);
            }
            else if (IS_IPAD){
                NSLog(@"%f %f",self.blackboardView.center.y,self.blackboardView.center.y-350);
                self.blackboardView.center = CGPointMake(self.blackboardView.center.x, self.blackboardView.center.y-350);

            }
            
        } completion:nil];
    }

}

-(void)registerNew{
    
    //Input the loading view
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

    
    //Set Info In Database
//    PFUser *newUser = [PFUser user];
    NSString *lowerEmail = [[_emailField.text lowercaseString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    QueryWebService *query = [[QueryWebService alloc]initWithTable:@"User"];
    [query selectColumnWhere:@"Email" equalTo:lowerEmail];
    [query findAllObjectsInRowWithCompletion:^(NSError *error, NSArray *rows) {
        self.navigationItem.hidesBackButton=NO;
        [loadingView removeFromSuperview];
        [loading stopAnimating];

        if (error) {
            NSLog(@"print error here");
            return;
        }
        
        if (rows.count > 0) {
            NSLog(@"print error here");
        }else{
            self.createParam = [@{@"Email":lowerEmail,@"Password":self.passwordField.text} mutableCopy];
            
            [self performSegueWithIdentifier:@"profileseg" sender:self];

        }
    }];
    
//    int userNumType = 0;
//    
//    if([self.userType isEqualToString:@"Teacher"]){
//        userNumType=0;
//    }else{
//        userNumType=1;
//    }
//    
//    InsertWebService *insertUser = [[InsertWebService alloc]initWithTable:@"User"];
//    [insertUser insertObjectInColumnWhere:@"Username" setObjectValue:lowerEmail];
//    [insertUser insertObjectInColumnWhere:@"Email" setObjectValue:lowerEmail];
//    [insertUser insertObjectInColumnWhere:@"Password" setObjectValue:_passwordField.text];
//    [insertUser insertObjectInColumnWhere:@"UserType" setObjectValue:[NSString stringWithFormat:@"%d",userNumType]];
//    [insertUser insertObjectInColumnWhere:@"UniversalToken" setObjectValue:[[NSProcessInfo processInfo] globallyUniqueString]];
//    [insertUser saveTheUserInDatabaseInBackground:^(NSError *error, id result) {
//        if (error) {
//            if (error.code == 400) {
//                NSLog(@"DUPLICATE!");
//            }
//        }else{
//        
//        
//        // Store the data
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        [defaults setObject:result[@"UserType"] forKey:@"UserType"];
//        [defaults setObject:result[@"Email"] forKey:@"Email"];
//        [defaults setObject:result[@"UserId"] forKey:@"UserId"];
//            [defaults setObject:result[@"UniversalToken"] forKey:@"UniversalToken"];
//        [defaults synchronize];
//        
//        self.navigationItem.hidesBackButton=NO;
//        [loadingView removeFromSuperview];
//        [loading stopAnimating];
//        [loading removeFromSuperview];
//        
//        [self performSegueWithIdentifier:@"profileseg" sender:self];
//        }
//
//    }];

}


-(void)hideKeyboard{
    if (_isEditing) {
        _isEditing=NO;
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            if (IS_IPAD) {
                self.blackboardView.center = CGPointMake(self.blackboardView.center.x, self.blackboardView.center.y+350);
            }
            else if(IS_IPHONE){
                self.blackboardView.center = CGPointMake(self.blackboardView.center.x, self.blackboardView.center.y+160);
            }
        } completion:nil];
    }
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([_emailField isFirstResponder]) {
        [_passwordField becomeFirstResponder];
        return YES;
    }
    else{
        return NO;
    }
}


- (void)signUpAction:(id)sender {
    [self.view endEditing:YES];
    [self checkFieldsComplete];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    if ([segue.identifier isEqualToString:@"profileseg"]){
        ClassRegViewController *classRegVC = (ClassRegViewController*)segue.destinationViewController;
        classRegVC.managedObjectContext=_managedObjectContext;
        classRegVC.demoManagedObjectContext=_demoManagedObjectContext;
        classRegVC.userType = self.userType;
        classRegVC.createParam = self.createParam;
    }
    
}

@end
