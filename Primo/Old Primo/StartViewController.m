//
//  StartViewController.m
//  Primo
//
//  Created by Jarrett Chen on 8/29/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import "StartViewController.h"

@interface StartViewController ()

@property (nonatomic,strong) NSString *userType;

@end

@implementation StartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden=NO;
    
    //set color for navigation bar
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    
    UIImageView *globeBackground = [[UIImageView alloc]init];
    UIImage *backgroundImage = [UIImage imageNamed:@"classroomBackground"];
    [globeBackground setImage:[backgroundImage applyBlurWithRadius:0 tintColor:[UIColor colorWithWhite:0.4 alpha:0.5] saturationDeltaFactor:2 maskImage:nil]];
    globeBackground.userInteractionEnabled=YES;
    [self.view addSubview:globeBackground];
    
    
    UILabel *startLabel = [UILabel new];
    if (self.isDemo) {

        [startLabel setText:[NSString stringWithFormat:@"Welcome to the demo! \n\n\n\nYou are a:"]];
        
    }
    else{
        [startLabel setText:[NSString stringWithFormat:@"Let the class begin! \n\n\n\nYou are a:"]];

    }
    [startLabel setNumberOfLines:0];
    [startLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:startLabel];
    
    UIImageView *blackboardButtonImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"blackboardBorder"]];
    [blackboardButtonImageView setUserInteractionEnabled:YES];
    blackboardButtonImageView.layer.cornerRadius=10;
    blackboardButtonImageView.layer.borderWidth=1;
    blackboardButtonImageView.clipsToBounds = YES;
    [self.view addSubview:blackboardButtonImageView];
    
    UIButton *teacherButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [teacherButton setTitle:@"Teacher" forState:UIControlStateNormal];
    [teacherButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [teacherButton addTarget:self action:@selector(demoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [blackboardButtonImageView addSubview:teacherButton];
    
    UIButton *studentButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [studentButton addTarget:self action:@selector(demoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [studentButton setTitle:@"Student/Parent" forState:UIControlStateNormal];
    [studentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [blackboardButtonImageView addSubview:studentButton];


    if (IS_IPHONE) {
        [globeBackground setFrame:self.view.frame];
        
        [blackboardButtonImageView setFrame:CGRectMake(10, 270, self.view.frame.size.width-20, 200)];
        
        [startLabel setFrame:CGRectMake(10, 60, self.view.frame.size.width-20, 200)];
        
        [teacherButton setFrame:CGRectMake(10, 40, blackboardButtonImageView.frame.size.width-20, 30)];
        [studentButton setFrame:CGRectMake(10, 100, blackboardButtonImageView.frame.size.width-20, 30)];
        
        //font attributes
        [teacherButton.titleLabel setFont:[UIFont fontWithName:@"Eraser" size:23]];
        [studentButton.titleLabel setFont:[UIFont fontWithName:@"Eraser" size:23]];

        if (self.isDemo) {
            [startLabel setFont:[UIFont fontWithName:@"Eraser" size:19]];
            
            
            NSMutableAttributedString *attributeTouchString = [[NSMutableAttributedString alloc] initWithString:startLabel.text];
            [attributeTouchString addAttribute:NSFontAttributeName
                                         value:[UIFont fontWithName:@"Eraser" size:30]
                                         range:NSMakeRange(0,[@"Welcome to the demo!" length])];
            [startLabel setAttributedText:attributeTouchString];
        }
        else{
            [startLabel setFont:[UIFont fontWithName:@"Eraser" size:19]];
            
            NSMutableAttributedString *attributeTouchString = [[NSMutableAttributedString alloc] initWithString:startLabel.text];
            [attributeTouchString addAttribute:NSFontAttributeName
                                         value:[UIFont fontWithName:@"Eraser" size:30]
                                         range:NSMakeRange(0,[@"Let the class begin!" length])];
            [startLabel setAttributedText:attributeTouchString];

        }
        
    }
    else if (IS_IPAD){
        
        //font attributes
        [teacherButton.titleLabel setFont:[UIFont fontWithName:@"Eraser" size:35]];
        [studentButton.titleLabel setFont:[UIFont fontWithName:@"Eraser" size:35]];
        if (self.isDemo) {
            [startLabel setFont:[UIFont fontWithName:@"Eraser" size:30]];
            
            
            NSMutableAttributedString *attributeTouchString = [[NSMutableAttributedString alloc] initWithString:startLabel.text];
            [attributeTouchString addAttribute:NSFontAttributeName
                                         value:[UIFont fontWithName:@"Eraser" size:50]
                                         range:NSMakeRange(0,[@"Welcome to the demo!" length])];
            [startLabel setAttributedText:attributeTouchString];
        }
        else{
            [startLabel setFont:[UIFont fontWithName:@"Eraser" size:30]];
            NSMutableAttributedString *attributeTouchString = [[NSMutableAttributedString alloc] initWithString:startLabel.text];
            [attributeTouchString addAttribute:NSFontAttributeName
                                         value:[UIFont fontWithName:@"Eraser" size:50]
                                         range:NSMakeRange(0,[@"Let the class begin!" length])];
            [startLabel setAttributedText:attributeTouchString];


        }
        
        globeBackground.translatesAutoresizingMaskIntoConstraints=NO;
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[globeBackground]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(globeBackground)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[globeBackground]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(globeBackground)]];
        
        startLabel.translatesAutoresizingMaskIntoConstraints=NO;
        blackboardButtonImageView.translatesAutoresizingMaskIntoConstraints=NO;
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:startLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-130-[startLabel(240)]-[blackboardButtonImageView(340)]" options:NSLayoutFormatAlignAllCenterX metrics:nil views:NSDictionaryOfVariableBindings(startLabel,blackboardButtonImageView)]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:startLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [blackboardButtonImageView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[blackboardButtonImageView(600)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(blackboardButtonImageView)]];
        
        [teacherButton setFrame:CGRectMake(10, 80, 580, 50)];
        [studentButton setFrame:CGRectMake(10, 190, 580, 50)];
    }
    
    // Do any additional setup after loading the view.
}

-(void)demoButtonAction:(UIButton*)sender{
    
    self.userType = sender.titleLabel.text;
    
    if (self.isDemo) {
        [self performSegueWithIdentifier:@"demoTableSegue" sender:self];

    }
    else{
        [self performSegueWithIdentifier:@"createAccountSegue" sender:self];
    }
    
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if ([segue.identifier isEqualToString:@"demoTableSegue"]){
//        DemoClassViewController *demoTableVC = (DemoClassViewController*)segue.destinationViewController;
//        demoTableVC.managedObjectContext = [self managedObjectContext];
//        demoTableVC.demoManagedObjectContext = self.demoManagedObjectContext;
//        demoTableVC.userType=self.userType;
//    }
//    else if ([segue.identifier isEqualToString:@"createAccountSegue"]){
//        RegisterViewController *regVC = (RegisterViewController*)segue.destinationViewController;
//        regVC.managedObjectContext=self.managedObjectContext;
//        regVC.demoManagedObjectContext=self.demoManagedObjectContext;
//        regVC.userType=self.userType;
//    }
//}
@end
