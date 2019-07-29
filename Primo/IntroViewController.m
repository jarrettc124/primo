//
//  IntroViewController.m
//  TeacherApp
//
//  Created by Jarrett Chen on 3/8/14.
//  Copyright (c) 2014 Jarrett Chen. All rights reserved.
//

#import "IntroViewController.h"

@interface IntroViewController ()
@property (nonatomic) BOOL isDemo;
@end

@implementation IntroViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (IBAction)learnMoreButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"tutorialSegue" sender:self];
}
- (IBAction)loginButtonClick:(id)sender {
    [self performSegueWithIdentifier:@"loginSegue" sender:self];
}
- (IBAction)registerButtonClick:(id)sender {
    self.isDemo=NO;
    [self performSegueWithIdentifier:@"accountTypeSegue" sender:self];
}
- (IBAction)demoButtonClick:(id)sender {
    self.isDemo = YES;
    [self performSegueWithIdentifier:@"accountTypeSegue" sender:self];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"accountTypeSegue"]){
        StartViewController *startVC =(StartViewController*)segue.destinationViewController;
        startVC.isDemo=self.isDemo;
    }
    
}

@end
