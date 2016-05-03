//
//  IntroPageContentViewController.m
//  Primo
//
//  Created by Jarrett Chen on 5/13/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import "IntroPageContentViewController.h"

@interface IntroPageContentViewController ()

@end

@implementation IntroPageContentViewController

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
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    UIImageView *tutorialbackground = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"blackboardBorder"]];
    [self.view addSubview:tutorialbackground];
    
    self.backgroundImage = [UIImageView new];
    [self.backgroundImage setImage:[UIImage imageNamed:self.pictureText]];
    [self.view addSubview:self.backgroundImage];
    
    
    if(IS_IPHONE){
        
        //Supports small screens
        if (self.view.frame.size.height<568) {
            //short
        }
        else{
            [self.backgroundImage setFrame:CGRectMake(self.view.center.x-195/2, 64, 195, 300)];
        }
        
        [tutorialbackground setFrame:CGRectMake((self.view.frame.size.width-300)/2,self.backgroundImage.frame.origin.y+self.backgroundImage.frame.size.height+5, 300, 120)];
        
        self.tutorialLabel = [[UILabel alloc]initWithFrame:CGRectMake((tutorialbackground.frame.size.width - (tutorialbackground.frame.size.width-50))/2, 5, tutorialbackground.frame.size.width-50, tutorialbackground.frame.size.height-30)];
        self.tutorialLabel.numberOfLines=0;

        self.tutorialLabel.font = [UIFont fontWithName:@"Eraser" size:15];
        [self.tutorialLabel setTextColor:[UIColor whiteColor]];
        self.tutorialLabel.text = self.tutorialText;
        [tutorialbackground addSubview:self.tutorialLabel];

    }
    else if(IS_IPAD){
        tutorialbackground.translatesAutoresizingMaskIntoConstraints=NO;
        self.backgroundImage.translatesAutoresizingMaskIntoConstraints=NO;
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-70-[_backgroundImage(370)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_backgroundImage)]];

        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_backgroundImage attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];

        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tutorialbackground attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:155]];
        [tutorialbackground addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[tutorialbackground(200)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tutorialbackground)]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tutorialbackground attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
//        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[tutorialbackground(400)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tutorialbackground)]];
     
        self.tutorialLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 400-40, 200-10)];
        self.tutorialLabel.numberOfLines=0;
            self.tutorialLabel.font = [UIFont fontWithName:@"Eraser" size:25];
               [self.tutorialLabel setTextColor:[UIColor whiteColor]];
        self.tutorialLabel.text = self.tutorialText;
        [tutorialbackground addSubview:self.tutorialLabel];
    }

    

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSNumber *numIndex = [NSNumber numberWithUnsignedInteger:self.pageIndex];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pageIndex" object:numIndex];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
