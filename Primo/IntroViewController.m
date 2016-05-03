//
//  IntroViewController.m
//  TeacherApp
//
//  Created by Jarrett Chen on 3/8/14.
//  Copyright (c) 2014 Jarrett Chen. All rights reserved.
//

#import "IntroViewController.h"

@interface IntroViewController ()

@property (strong, nonatomic) UIButton *signUpButton;
@property (strong, nonatomic) UIButton *loginButton;
@property (nonatomic,strong) UIView *redView;
@property (nonatomic,strong) UIImageView *backgroundIntro;
@property (nonatomic) BOOL isDemo;

@end

@implementation IntroViewController


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
    
    self.backgroundIntro = [[UIImageView alloc]init];
    self.backgroundIntro.userInteractionEnabled=YES;
    [self.backgroundIntro setImage:[UIImage imageNamed:@"blackboardBackground"]];
    [self.view addSubview:self.backgroundIntro];
    
	// Do any additional setup after loading the view.
    self.loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.loginButton setTag:100];
    self.loginButton.backgroundColor = [UIColor grayColor];
    [self.loginButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.loginButton setTitle:@"Login" forState:UIControlStateNormal];
    self.loginButton.layer.cornerRadius = 2;
    [self.loginButton addTarget:self action:@selector(buttonActions:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginButton];
    
    self.signUpButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.signUpButton setTag:200];
    [self.signUpButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
    self.signUpButton.backgroundColor = [UIColor colorWithRed:0.0705882 green:0.082353 blue:0.243137 alpha:1];
    [self.signUpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.signUpButton setTitle:@"Sign Up" forState:UIControlStateNormal];
    self.signUpButton.layer.cornerRadius = 2;
    [self.signUpButton addTarget:self action:@selector(buttonActions:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.signUpButton];
    
    UIImage *logoImage = [UIImage imageNamed:@"lcicon"];
    UIImageView *logoView = [[UIImageView alloc]init];
    [logoView setImage:logoImage];
    logoView.contentMode=UIViewContentModeScaleAspectFit;
    [self.view addSubview:logoView];
    
    UILabel *manageClassLabel = [UILabel new];
    [manageClassLabel setTextColor:[UIColor whiteColor]];
    [manageClassLabel setText:@"LCEdu helps you manage your class with a touch of a button!"];
    [manageClassLabel setNumberOfLines:0];
    [manageClassLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:manageClassLabel];

    
    UIButton *learnMoreButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [learnMoreButton setTag:300];
    [learnMoreButton setTitle:@"Learn More! >" forState:UIControlStateNormal];
    [learnMoreButton setTitleColor:[UIColor colorWithRed:0.435294 green:0.90588 blue:0.8588 alpha:1] forState:UIControlStateNormal];
    [learnMoreButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [learnMoreButton addTarget:self action:@selector(buttonActions:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:learnMoreButton];
    
    UIButton *demoClassButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [demoClassButton setTag:400];
    [demoClassButton setTitle:@"Play with our demo class!" forState:UIControlStateNormal];
    [demoClassButton setTitleColor:[UIColor colorWithRed:0.435294 green:0.90588 blue:0.8588 alpha:1] forState:UIControlStateNormal];
    [demoClassButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [demoClassButton addTarget:self action:@selector(buttonActions:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:demoClassButton];
    
    if (IS_IPAD) {
        [manageClassLabel setFont:[UIFont systemFontOfSize:20]];
        NSMutableAttributedString *attributeTouchString = [[NSMutableAttributedString alloc] initWithString:manageClassLabel.text];
        [attributeTouchString addAttribute:NSFontAttributeName
                                     value:[UIFont fontWithName:@"Eraser" size:20]
                                     range:NSMakeRange(41,5)];
        
        [manageClassLabel setAttributedText:attributeTouchString];
        [learnMoreButton.titleLabel setFont:[UIFont fontWithName:@"Eraser" size:22]];
        [demoClassButton.titleLabel setFont:[UIFont fontWithName:@"Eraser" size:30]];

        
        [self.loginButton.titleLabel setFont:[UIFont systemFontOfSize:28]];
        [self.signUpButton.titleLabel setFont:[UIFont systemFontOfSize:28]];
        
        
        self.loginButton.translatesAutoresizingMaskIntoConstraints=NO;
        self.signUpButton.translatesAutoresizingMaskIntoConstraints=NO;
        manageClassLabel.translatesAutoresizingMaskIntoConstraints=NO;
        learnMoreButton.translatesAutoresizingMaskIntoConstraints=NO;
        demoClassButton.translatesAutoresizingMaskIntoConstraints=NO;

        self.backgroundIntro.translatesAutoresizingMaskIntoConstraints=NO;
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_backgroundIntro]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_backgroundIntro)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_backgroundIntro]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_backgroundIntro)]];
        
        
        NSArray *signUpConstraintsH = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_signUpButton(60)]"
                                                                              options:0
                                                                              metrics:nil
                                                                                views:NSDictionaryOfVariableBindings(_signUpButton)];
        [_signUpButton addConstraints:signUpConstraintsH];
        
        
        NSArray *buttonVertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_loginButton(60)]-100-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_loginButton)];
        
        
        NSArray *buttonsHorizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-30-[_loginButton(==_signUpButton)]-20-[_signUpButton]-30-|"
                                                                        options:NSLayoutFormatAlignAllTop
                                                                        metrics:nil
                                                                          views:NSDictionaryOfVariableBindings(_loginButton,_signUpButton)];

        
        
        [self.view addConstraints:buttonsHorizontal];
        
        [self.view addConstraints:buttonVertical];
        
        //logo Position
        logoView.translatesAutoresizingMaskIntoConstraints=NO;
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:logoView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:logoView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:-150]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[logoView(200)]-30-[manageClassLabel(30)]-[learnMoreButton(30)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(logoView,manageClassLabel,learnMoreButton)]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[demoClassButton]-20-[_loginButton]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(demoClassButton,_loginButton)]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[manageClassLabel]-40-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(manageClassLabel)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-90-[learnMoreButton]-90-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(learnMoreButton)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-60-[demoClassButton]-60-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(demoClassButton)]];
        
        
    }
    else if (IS_IPHONE){
        
        //Set iphone using frames
        NSMutableAttributedString *attributeTouchString = [[NSMutableAttributedString alloc] initWithString:manageClassLabel.text];
        
        [attributeTouchString addAttribute:NSFontAttributeName
                                     value:[UIFont fontWithName:@"Eraser" size:18]
                                     range:NSMakeRange(41,5)];
        
        
        [manageClassLabel setAttributedText:attributeTouchString];
        [learnMoreButton.titleLabel setFont:[UIFont fontWithName:@"Eraser" size:19]];
        [demoClassButton.titleLabel setFont:[UIFont fontWithName:@"Eraser" size:19]];
        
        [self.backgroundIntro setFrame:self.view.frame];
        
        if (self.view.frame.size.height<568) {
            
            //Short iphone
            
            [self.loginButton setFrame:CGRectMake(self.view.frame.origin.x+10,self.view.frame.size.height-75,(self.view.frame.size.width/2)-15, 45)];
            
            [self.signUpButton setFrame:CGRectMake((self.view.frame.size.width/2)+5,self.view.frame.size.height-75,(self.view.frame.size.width/2)-15, 45)];
            
            [logoView setFrame:CGRectMake(self.view.frame.size.width/2-(logoImage.size.width/2)+20, 35, logoImage.size.width-150, logoImage.size.height-150)];
            
            [manageClassLabel setFrame:CGRectMake(10, logoView.frame.origin.y+logoView.frame.size.height+30, self.view.frame.size.width-20, 60)];

        }
        else{
            
            //Tall iphone
            
            [self.loginButton setFrame:CGRectMake(self.view.frame.origin.x+10,self.view.frame.size.height-90,(self.view.frame.size.width/2)-15, 45)];
            
            [self.signUpButton setFrame:CGRectMake((self.view.frame.size.width/2)+5,self.view.frame.size.height-90,(self.view.frame.size.width/2)-15, 45)];
            
            [logoView setFrame:CGRectMake((self.view.frame.size.width - (logoImage.size.width-150))/2, 50, logoImage.size.width-150, logoImage.size.height-150)];
            
            [manageClassLabel setFrame:CGRectMake(10, logoView.frame.origin.y+logoView.frame.size.height+5, self.view.frame.size.width-20, 60)];
            
            [learnMoreButton setFrame:CGRectMake(self.view.frame.size.width/2-100, manageClassLabel.frame.origin.y+60, 200, 30)];
            
            [demoClassButton setFrame:CGRectMake(self.view.frame.size.width/2-150, self.loginButton.frame.origin.y-50, 300, 30)];

        }
    }
    
}




-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden=YES;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

}


-(void)buttonActions:(UIButton*)sender{
    if (sender.tag==100) {
        [self performSegueWithIdentifier:@"loginSegue" sender:self];
    }
    else if(sender.tag==200){
        
        self.isDemo=NO;
        [self performSegueWithIdentifier:@"accountTypeSegue" sender:self];
    }
    else if (sender.tag==300){
        [self performSegueWithIdentifier:@"tutorialSegue" sender:self];
    }
    else if (sender.tag==400){
        self.isDemo = YES;
        [self performSegueWithIdentifier:@"accountTypeSegue" sender:self];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"loginSegue"]){
        LoginViewController *loginVC = (LoginViewController*)segue.destinationViewController;
        loginVC.managedObjectContext = _managedObjectContext;
        loginVC.demoManagedObjectContext = _demoManagedObjectContext;
    }
    else if ([segue.identifier isEqualToString:@"tutorialSegue"]){
        TutorialViewController *tutVC =(TutorialViewController*)segue.destinationViewController;
        tutVC.managedObjectContext = self.demoManagedObjectContext;
        tutVC.demoManagedObjectContext = self.demoManagedObjectContext;
    }
    else if ([segue.identifier isEqualToString:@"accountTypeSegue"]){
        StartViewController *startVC =(StartViewController*)segue.destinationViewController;
        startVC.managedObjectContext = self.managedObjectContext;
        startVC.demoManagedObjectContext = self.demoManagedObjectContext;
        startVC.isDemo=self.isDemo;
        
    }
    
}

@end
