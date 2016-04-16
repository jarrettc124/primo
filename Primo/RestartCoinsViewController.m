//
//  RestartCoinsViewController.m
//  Primo
//
//  Created by Jarrett Chen on 4/30/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import "RestartCoinsViewController.h"

@interface RestartCoinsViewController ()

@end

@implementation RestartCoinsViewController

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
    //background image
    UIImageView *backgroundView = [[UIImageView alloc] init];
    [backgroundView setImage:[UIImage imageNamed:@"blackboardBackground"]];
    backgroundView.userInteractionEnabled=YES;
    [self.view addSubview:backgroundView];
    
    
    UILabel *directionRestart = [[UILabel alloc]init];
    directionRestart.text = [NSString stringWithFormat:@"To restart your student's bank account for %@ class, enter the number of coins below:",self.classNameInRestart];
    directionRestart.numberOfLines=0;
    directionRestart.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
    directionRestart.textColor = [UIColor whiteColor];
    [self.view addSubview:directionRestart];

    UIImage * dividerImage=[UIImage imageNamed:@"Divider"];
    UIImageView *dividerUnderLabel = [[UIImageView alloc]init];
    [dividerUnderLabel setImage:dividerImage];
    [self.view addSubview:dividerUnderLabel];
    
    UILabel *coinText = [[UILabel alloc]init];
    coinText.text = @"Coins :";
    coinText.textColor = [UIColor whiteColor];
    coinText.font = [UIFont fontWithName:@"Eraser" size:28];
    [self.view addSubview:coinText];
    
    _editCoinTextField = [[UITextField alloc] init];
    _editCoinTextField.delegate = self;
    _editCoinTextField.textColor = [UIColor whiteColor];
    _editCoinTextField.font = [UIFont fontWithName:@"Eraser" size:28];
    [_editCoinTextField addTarget:self action:@selector(checkCondition) forControlEvents:UIControlEventEditingChanged];
    [_editCoinTextField setKeyboardType:UIKeyboardTypeNumberPad];
    [self.view addSubview:_editCoinTextField];
    
    if (IS_IPAD) {
        
        backgroundView.translatesAutoresizingMaskIntoConstraints=NO;
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[backgroundView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(backgroundView)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[backgroundView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(backgroundView)]];
        
        directionRestart.translatesAutoresizingMaskIntoConstraints=NO;
        dividerUnderLabel.translatesAutoresizingMaskIntoConstraints=NO;
        coinText.translatesAutoresizingMaskIntoConstraints=NO;
        self.editCoinTextField.translatesAutoresizingMaskIntoConstraints=NO;
        
        directionRestart.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:22];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-130-[directionRestart(43)]-30-[dividerUnderLabel(8)]-[coinText(40)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(directionRestart,dividerUnderLabel,coinText)]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[directionRestart]-20-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(directionRestart)]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:dividerUnderLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[coinText]-10-[_editCoinTextField]" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(coinText,_editCoinTextField)]];
        
        [_editCoinTextField addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_editCoinTextField(60)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_editCoinTextField)]];
    }
    else if (IS_IPHONE){
        [backgroundView setFrame:self.view.frame];
        [directionRestart setFrame:CGRectMake(20, 120, self.view.frame.size.width-40, 100)];
        [dividerUnderLabel setFrame:CGRectMake((self.view.frame.size.width/2)-dividerImage.size.width/2, directionRestart.frame.origin.y+directionRestart.frame.size.height, dividerImage.size.width, dividerImage.size.height)];
        [coinText setFrame:CGRectMake(50, 230, 120, 40)];
        [_editCoinTextField setFrame:CGRectMake((self.view.frame.size.width/2), 230, 55, 40)];
    }
    
    
    [self checkCondition];
    
}

-(void)checkCondition{
    if ([_editCoinTextField.text isEqualToString:@""]) {
        self.navigationItem.rightBarButtonItem.enabled=NO;
    }
    else{
        self.navigationItem.rightBarButtonItem.enabled=YES;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    
    self.navigationItem.title = @"Restart Class Coins";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Restart" style:UIBarButtonItemStylePlain target:self action:@selector(restartCoinAction)];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    
}

-(void)viewDidAppear:(BOOL)animated{
    [self.editCoinTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)restartCoinAction{

    self.navigationItem.hidesBackButton=YES;
    self.navigationItem.rightBarButtonItem.enabled=NO;
    
    UIView *loadingView = [[UIView alloc]initWithFrame:self.view.frame];
    loadingView.backgroundColor = [UIColor blackColor];
    loadingView.alpha=0.5;
    [self.view addSubview:loadingView];
    
    UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-25, (self.view.frame.size.height)/2, 50, 50)];
    [self.view addSubview:loading];
    [loading setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [loading hidesWhenStopped];
    [loading startAnimating];

    
    if(![_editCoinTextField.text isEqualToString:@""]){
            NSString *objId = [[NSUserDefaults standardUserDefaults] objectForKey:@"ObjectId"];
        NSNumber* newCoins = [NSNumber numberWithInt:[_editCoinTextField.text intValue]];
        
        UpdateWebService *updateRows = [[UpdateWebService alloc]initWithTable:@"StudentObject"];
        [updateRows setRowToUpdateWhereColumn:@"coins" equalTo:[newCoins stringValue]];
        [updateRows selectRowToUpdateWhereColumn:@"teacher" equalTo:objId];
        [updateRows selectRowToUpdateWhereColumn:@"className" equalTo:[self.classNameInRestart lowercaseString]];
        [updateRows saveUpdateInBackgroundWithBlock:^(NSError *error) {
            if (error) {
                self.navigationItem.hidesBackButton=NO;
                self.navigationItem.rightBarButtonItem.enabled=YES;
                
                [loadingView removeFromSuperview];
                [loading stopAnimating];
                [loading removeFromSuperview];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed." message:@"You must have a network connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            else{
                //Update logs
                LogWebService *logService = [[LogWebService alloc]initWithLogType:@"class_logs"];
                [logService updateLogWithUserId:objId className:self.classNameInRestart updateLogString:[NSString stringWithFormat:@"You have restarted %@ class with %@ coins",[self.classNameInRestart lowercaseString],[newCoins stringValue]]];
                
                //Update in core data and log string
                NSString *studentLogString = [NSString stringWithFormat:@"Your teacher has restarted your account with %@ coins",newCoins];
                
                NSError *error;
                NSFetchRequest *studentsRequest = [NSFetchRequest fetchRequestWithEntityName:@"StudentObject"];
                studentsRequest.predicate= [NSPredicate predicateWithFormat:@"(teacher = %@) AND (nameOfclass = %@)",objId,[self.classNameInRestart lowercaseString]];
                NSArray *studentObjArray = [_managedObjectContext executeFetchRequest:studentsRequest error:&error];
                for (StudentObject *studentObj in studentObjArray){
                    studentObj.coins = newCoins;
                    [logService updateLogWithUserId:studentObj.objectId className:[self.classNameInRestart lowercaseString] updateLogString:studentLogString];
                }
                [_managedObjectContext save:nil];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Restarted Class Coins!" message:[NSString stringWithFormat:@"You restarted your class account with %@ coins",newCoins] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
                
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
        
    }
    else{
        self.navigationItem.hidesBackButton=NO;
        self.navigationItem.rightBarButtonItem.enabled=YES;
        
        [loadingView removeFromSuperview];
        [loading stopAnimating];
        [loading removeFromSuperview];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Wrong Login Information" message:@"Please try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"donerestartsegue"]) {
   
        UITabBarController *tabbarC = (UITabBarController*)segue.destinationViewController;
        
        StudentsViewController *studentVC = [tabbarC.viewControllers objectAtIndex:0];
        
        TeacherStoreViewController *storeVC = [tabbarC.viewControllers objectAtIndex:1];
        
        AnnouncementViewController *annVC = [tabbarC.viewControllers objectAtIndex:2];
        
        moreViewController *moreVC = [tabbarC.viewControllers objectAtIndex:3];
        
        annVC.className=self.classNameInRestart;
        annVC.managedObjectContext = _managedObjectContext;
        annVC.demoManagedObjectContext = _demoManagedObjectContext;
        
        moreVC.classNameInMore = self.classNameInRestart;
        moreVC.managedObjectContext=_managedObjectContext;
        moreVC.demoManagedObjectContext=_demoManagedObjectContext;
        
        storeVC.className=self.classNameInRestart;
        storeVC.managedObjectContext = self.managedObjectContext;
        storeVC.demoManagedObjectContext = storeVC.demoManagedObjectContext;
        
        studentVC.className=self.classNameInRestart;
        studentVC.managedObjectContext = self.managedObjectContext;
        studentVC.demoManagedObjectContext =self.managedObjectContext;
    }
}



@end
