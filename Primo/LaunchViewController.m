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

@property (nonatomic,strong) UIImageView *launchImage;

@end

@implementation LaunchViewController

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
    
    self.launchImage = [[UIImageView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:self.launchImage];
    
    UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc]init];
    [loadingView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [loadingView startAnimating];
    [self.view addSubview:loadingView];
    
    if (IS_IPAD) {
        self.launchImage.translatesAutoresizingMaskIntoConstraints=NO;
        loadingView.translatesAutoresizingMaskIntoConstraints=NO;
        
        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
        if(orientation == UIInterfaceOrientationPortrait){
                //Do something if the orientation is in Portrait
            [self.launchImage setImage:[UIImage imageNamed:@"blackboardBackground"]];
            
        }
        else if((orientation == UIInterfaceOrientationLandscapeLeft) || (orientation == UIInterfaceOrientationLandscapeRight)){
            [self.launchImage setImage:[UIImage imageNamed:@"blackboardBackground"]];
        }
        
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_launchImage]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_launchImage)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_launchImage]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_launchImage)]];
        
        //Loading View
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:loadingView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:loadingView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:150]];
    }
    else if (IS_IPHONE){
        [self.launchImage setImage:[UIImage imageNamed:@"blackboardBackground"]];
        [loadingView setFrame:CGRectMake(self.view.frame.size.width/2-15,self.view.frame.size.height/2+50, 30, 30)];
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration {
    
    if ((toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)) {
        [self.launchImage setImage:[UIImage imageNamed:@"loadingBackgroundLandscape"]];
    }
    else {
        [self.launchImage setImage:[UIImage imageNamed:@"loadingBackgroundPortrait"]];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden=YES;
}

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"introteach"]){
        ClassTableViewController *classTableVC = (ClassTableViewController*)segue.destinationViewController;
        classTableVC.managedObjectContext = [self managedObjectContext];
        classTableVC.demoManagedObjectContext = [self demoManagedObjectContext];
    }
    else if ([segue.identifier isEqualToString:@"newusersegue"]){
        IntroViewController *introVC = (IntroViewController*)segue.destinationViewController;
        introVC.managedObjectContext = [self managedObjectContext];
        introVC.demoManagedObjectContext = [self demoManagedObjectContext];
    }
//    else if([segue.identifier isEqualToString:@"introstu"]){
//        ClassTableViewController *classTableVC = (ClassTableViewController*)segue.destinationViewController;
//        classTableVC.managedObjectContext = [self managedObjectContext];
//        classTableVC.demoManagedObjectContext = [self demoManagedObjectContext];
//    }
    

}


@end
