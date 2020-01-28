//
//  DemoEndViewController.m
//  Primo
//
//  Created by Jarrett Chen on 8/27/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import "DemoEndViewController.h"

@interface DemoEndViewController ()

@end

@implementation DemoEndViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImageView *backgroundImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"groupBackground"]];
    [self.view addSubview:backgroundImage];
    
    UIImageView *demoImageView = [[UIImageView alloc]init];
    [self.view addSubview:demoImageView];
    
    UIImageView *tutorialbackground = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"blackboardBorder"]];
    [self.view addSubview:tutorialbackground];
    
    UIImageView *toolbarBackground = [[UIImageView alloc]init];
    [toolbarBackground setImage:[UIImage imageNamed:@"blackboardBar"]];
    toolbarBackground.userInteractionEnabled=YES;
    [self.view addSubview:toolbarBackground];
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton addTarget:self action:@selector(loginButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setTitle:@"Already have an account" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:loginButton];
    
    UIButton *signUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [signUpButton addTarget:self action:@selector(signUpButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [signUpButton setTitle:@"Sign Up Now!" forState:UIControlStateNormal];
    [signUpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:signUpButton];
    
    UIButton *backToClassButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [backToClassButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [backToClassButton setTitle:@"I'm done! \n Take me back to my classes" forState:UIControlStateNormal];
    [backToClassButton.titleLabel setNumberOfLines:0];
    [backToClassButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backToClassButton addTarget:self action:@selector(backToClass) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backToClassButton];
    
    UILabel *tutorialLabel = [UILabel new];
    tutorialLabel.numberOfLines=0;
    [tutorialLabel setTextColor:[UIColor whiteColor]];
    [tutorialLabel setTextAlignment:NSTextAlignmentCenter];
    [tutorialbackground addSubview:tutorialLabel];
    
    
    NSUserDefaults *standDef = [NSUserDefaults standardUserDefaults];
    if ([standDef objectForKey:@"UserType"]) {
        signUpButton.hidden=YES;
        loginButton.hidden=YES;
    }
    else{
        backToClassButton.hidden=YES;
    }
    
    if (IS_IPHONE) {
        [toolbarBackground setFrame:CGRectMake(0, 0, 320, 64)];
        [backgroundImage setFrame:self.view.frame];
        [tutorialbackground setFrame:CGRectMake(10, 70, 300, 100)];
        
        [demoImageView setFrame:CGRectMake(self.view.center.x-195/2, tutorialbackground.frame.origin.y+tutorialbackground.frame.size.height-50, 195, 300)];
        
        [backToClassButton setFrame:CGRectMake(10,demoImageView.frame.origin.y+demoImageView.frame.size.height+3,300, 80)];
        
        [signUpButton setFrame:CGRectMake(10,self.view.frame.size.height-150,300, 50)];
        [loginButton setFrame:CGRectMake(10, self.view.frame.size.height-90, 300, 50)];
        
        [signUpButton.titleLabel setFont:[UIFont fontWithName:@"Eraser" size:28]];
        [backToClassButton.titleLabel setFont:[UIFont fontWithName:@"Eraser" size:20]];
        [loginButton.titleLabel setFont:[UIFont fontWithName:@"Eraser" size:13]];
        
        BouncingPencil *pencilArrow = [[BouncingPencil alloc]initWithFrame:CGRectMake(20, signUpButton.frame.origin.y-50, 60, 60)];
        [pencilArrow setTag:2000];
        [pencilArrow setUpPencilBounceFrame:pencilArrow.frame targetX:15 targetY:9 rotation:-M_PI_4];
        [self.view addSubview:pencilArrow];
        
        [tutorialLabel setFrame:CGRectMake(20, 5, tutorialbackground.frame.size.width-40, tutorialbackground.frame.size.height-10)];
        tutorialLabel.font = [UIFont fontWithName:@"Eraser" size:15];

    }
    else if(IS_IPAD){

        toolbarBackground.translatesAutoresizingMaskIntoConstraints=NO;
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[toolbarBackground]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(toolbarBackground)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[toolbarBackground]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(toolbarBackground)]];
        
        
        backgroundImage.translatesAutoresizingMaskIntoConstraints=NO;
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[backgroundImage]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(backgroundImage)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[backgroundImage]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(backgroundImage)]];
        
        tutorialbackground.translatesAutoresizingMaskIntoConstraints=NO;
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-75-[tutorialbackground(150)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tutorialbackground)]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tutorialbackground attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        
        demoImageView.translatesAutoresizingMaskIntoConstraints=NO;
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:demoImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:demoImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:35]];
        [demoImageView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[demoImageView(380)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(demoImageView)]];
//        [demoImageView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[demoImageView(475)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(demoImageView)]];
//        
        backToClassButton.translatesAutoresizingMaskIntoConstraints=NO;
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[backToClassButton(70)]-80-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(backToClassButton)]];
        [backToClassButton addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[backToClassButton(380)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(backToClassButton)]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:backToClassButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        
        signUpButton.translatesAutoresizingMaskIntoConstraints=NO;
        loginButton.translatesAutoresizingMaskIntoConstraints=NO;
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:signUpButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
//        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:signUpButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:-200]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[signUpButton(50)]-5-[loginButton(35)]-90-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:NSDictionaryOfVariableBindings(signUpButton,loginButton)]];
        [signUpButton addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[signUpButton(250)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(signUpButton)]];
        [loginButton addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[loginButton(260)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(loginButton)]];
        
 
        [signUpButton.titleLabel setFont:[UIFont fontWithName:@"Eraser" size:30]];
        [signUpButton setBackgroundColor:[UIColor colorWithWhite:0.1 alpha:0.5]];
        [backToClassButton.titleLabel setFont:[UIFont fontWithName:@"Eraser" size:20]];
        [backToClassButton setBackgroundColor:[UIColor colorWithWhite:0.1 alpha:0.5]];
        [loginButton.titleLabel setFont:[UIFont fontWithName:@"Eraser" size:17]];
        [loginButton setBackgroundColor:[UIColor colorWithWhite:0.1 alpha:0.5]];
        
        //Set bouncing Pencil
        BouncingPencil *pencilArrow = [[BouncingPencil alloc]init];
        [pencilArrow setTag:2000];
        [self.view addSubview:pencilArrow];
        pencilArrow.translatesAutoresizingMaskIntoConstraints=NO;
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[pencilArrow(60)]-165-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(pencilArrow)]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:pencilArrow attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view  attribute:NSLayoutAttributeCenterX multiplier:1 constant:-188]];
        [pencilArrow setUpPencilBounceForiPad:CGSizeMake(60, 60) targetX:15 targetY:9 rotation:-M_PI_4];
        
        tutorialLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, tutorialbackground.frame.size.width-40, 150-10)];
        tutorialLabel.font = [UIFont fontWithName:@"Eraser" size:20];
        tutorialLabel.numberOfLines=0;
        [tutorialLabel setTextColor:[UIColor whiteColor]];
        [tutorialLabel setNumberOfLines:0];
        [tutorialLabel setTextAlignment:NSTextAlignmentCenter];
        [tutorialbackground addSubview:tutorialLabel];
    }

    

    
    if ([self.previousSegue isEqualToString:@"demoBroadEndSegue"]||[self.previousSegue isEqualToString:@"demoPieEndSegue"]||[self.previousSegue isEqualToString:@"demoStuBroadToEnd"]) {
        //log
        [tutorialLabel setText:@"Aww, you have to sign up in order to record your activities in the log"];
        [demoImageView setImage:[UIImage imageNamed:@"tutorialImg5"]];
        
    }
    else if ([self.previousSegue isEqualToString:@"demoStudentViewSegue"]){
        
        if ([self.studentsViewOptions isEqualToString:@"Teacher's Log"]) {
            [tutorialLabel setText:@"Aww, you have to sign up in order to record your activities in the log"];
            [demoImageView setImage:[UIImage imageNamed:@"tutorialImg5"]];

        }
        else if([self.studentsViewOptions isEqualToString:@"Group Students"]){
            
            [tutorialLabel setText:[NSString stringWithFormat:@"Let's us form groups with your students for you \n But first, you have to sign up!"]];
            [demoImageView setImage:[UIImage imageNamed:@"tutorialImg4"]];

        }
        else if([self.studentsViewOptions isEqualToString:@"Sort Students By:"]){
            [tutorialLabel setText:@"Wouldn't it be nice if we just sort all your students with a touch of a button? Sign up now!"];
            [demoImageView setImage:[UIImage imageNamed:@"tutorialImg6"]];
        }
    }
    else if ([self.previousSegue isEqualToString:@"demoAccountEnd"]){
        if ([self.studentsViewOptions isEqualToString:@"Show Log"]) {
            [tutorialLabel setText:@"Oh no, you have to sign up in order to record your activities in the log"];
            [demoImageView setImage:[UIImage imageNamed:@"tutorialImg5"]];
        }
        else if ([self.studentsViewOptions isEqualToString:@"Show Teacher"]){
            [tutorialLabel setText:@"Have a question? You may easily email your teachers here. Sign up to use this feature!"];
            [demoImageView setImage:[UIImage imageNamed:@"tutorialImg7"]];
        }
        else if ([self.studentsViewOptions isEqualToString:@"Show Group"]){
            [tutorialLabel setText:@"Wouldn't it be nice if we just sort all your students with a touch of a button? Sign up now!"];
            [demoImageView setImage:[UIImage imageNamed:@"tutorialImg6"]];
        }
    }

}

-(void)loginButtonAction{
    [self performSegueWithIdentifier:@"demoToLogin" sender:self];
}
-(void)signUpButtonAction{
    [self performSegueWithIdentifier:@"demoToSignup" sender:self];
}


-(void)backToClass{
    
    for (UIViewController* viewController in self.navigationController.viewControllers) {
        
        //This if condition checks whether the viewController's class is MyGroupViewController
        // if true that means its the MyGroupViewController (which has been pushed at some point)
        if ([viewController isKindOfClass:[ClassTableViewController class]] ) {
            
            // Here viewController is a reference of UIViewController base class of MyGroupViewController
            // but viewController holds MyGroupViewController  object so we can type cast it here
            [self.navigationController popToViewController:viewController animated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"demoToSignup"]) {

        RegisterViewController *regVC = (RegisterViewController*)segue.destinationViewController;
//        regVC.demoManagedObjectContext=self.demoManagedObjectContext;
//        regVC.managedObjectContext=self.managedObjectContext;
    }
    else if ([segue.identifier isEqualToString:@"demoToLogin"]){
        LoginViewController *logVC = (LoginViewController*)segue.destinationViewController;
//        logVC.demoManagedObjectContext=self.demoManagedObjectContext;
//        logVC.managedObjectContext=self.managedObjectContext;
    }
    
    
}

@end
