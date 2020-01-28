//
//  PrivacyAndTermsViewController.m
//  Primo
//
//  Created by Jarrett Chen on 5/5/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import "PrivacyAndTermsViewController.h"

@interface PrivacyAndTermsViewController ()

@end

@implementation PrivacyAndTermsViewController

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
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    UIImageView *toolbarBackground = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"blackboardBar"]];
    toolbarBackground.userInteractionEnabled=YES;
    [self.view addSubview:toolbarBackground];
    
    [self.navigationItem setTitle:@"Privacy Terms"];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    NSURL *url = [NSURL URLWithString:@"http://www.pixelandprocessor.com/primo/terms/terms.html"];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    UIWebView *privacyWebViews = [[UIWebView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, 64, self.view.frame.size.width, self.view.frame.size.height-120)];
    [privacyWebViews loadRequest:urlRequest];
    [self.view addSubview:privacyWebViews];
    
    //Set view constraints
    toolbarBackground.translatesAutoresizingMaskIntoConstraints=NO;
    privacyWebViews.translatesAutoresizingMaskIntoConstraints=NO;
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[toolbarBackground]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(toolbarBackground)]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[privacyWebViews]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(privacyWebViews)]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[toolbarBackground]-0-[privacyWebViews]-tabBarHeight-|" options:0 metrics:@{@"tabBarHeight": @((int)self.tabBarController.tabBar.frame.size.height)} views:NSDictionaryOfVariableBindings(toolbarBackground,privacyWebViews)]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
