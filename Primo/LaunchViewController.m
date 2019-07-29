//
//  LaunchViewController.m
//  Primo
//
//  Created by Jarrett Chen on 4/18/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import "LaunchViewController.h"
#import "MyUser.h"

@interface LaunchViewController ()
@end

@implementation LaunchViewController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if ([MyUser isLoggedIn]){

        //Login to database
        QueryWebService *userLogin = [[QueryWebService alloc]initWithTable:@"User"];
        [userLogin selectColumnWhere:@"universalToken" equalTo:[[NSUserDefaults standardUserDefaults] objectForKey:@"UniversalToken"]];
        [userLogin findAllObjectsInRowWithCompletion:^(NSError *error, NSArray *rows) {
                    
            NSDictionary *userDict = [rows firstObject];
            [MyUser storeDefaults:userDict];
            
            [self performSegueWithIdentifier:@"introteach" sender:self];
                    
        }];

    }
    else{

        [self performSegueWithIdentifier:@"newusersegue" sender:self];
    }

}

@end
