//
//  moreViewController.m
//  TeacherApp
//
//  Created by Jarrett Chen on 2/25/14.
//  Copyright (c) 2014 Jarrett Chen. All rights reserved.
//

#import "moreViewController.h"
@interface moreViewController ()

@property (nonatomic,strong) UITableView *moreTable;
@property (nonatomic,strong) NSArray *accountSetting;
@property (nonatomic,strong) NSArray *companySetting;
@property (nonatomic,strong) NSArray *logoutSetting;
@property (nonatomic) NSMutableArray *dataArray;
@property (nonatomic,strong) NSString *userType;

@property (nonatomic,strong) NSArray *demoSettings;

@property (nonatomic,strong) UITapGestureRecognizer *gestureRecognizer;

@end

@implementation moreViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *toolbarBackground = [[UIImageView alloc]init];
    [toolbarBackground setImage:[UIImage imageNamed:@"blackboardBar"]];
    toolbarBackground.userInteractionEnabled=YES;
    [self.view addSubview:toolbarBackground];
    
    // Do any additional setup after loading the view.
    _userType = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserType"];
    _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    //initializing grouped table
    if ([_userType isEqualToString:@"Teacher"]) {
        _accountSetting = [[NSArray alloc]initWithObjects:@"Settings",@"Restart Bank",@"Clear Broadcast", nil];
        _demoSettings = [[NSArray alloc]initWithObjects:@"Play Demo to learn more",@"Rate this App!",@"Sign your students up now!", nil];

    }
    else{
        _accountSetting = [[NSArray alloc]initWithObjects:@"Settings", nil];
        _demoSettings = [[NSArray alloc]initWithObjects:@"Play Demo to learn more",@"Rate this App!", nil];

    }
    
    NSDictionary *demoItemsArrayDict = [NSDictionary dictionaryWithObject:_demoSettings forKey:@"data"];
    [_dataArray addObject:demoItemsArrayDict];

    NSDictionary *firstItemsArrayDict = [NSDictionary dictionaryWithObject:_accountSetting forKey:@"data"];
    [_dataArray addObject:firstItemsArrayDict];
    //

    _companySetting =[[NSArray alloc]initWithObjects:@"Ask Us A Question!",@"Privacy & Terms", nil];
    NSDictionary *secondItemsArrayDict = [NSDictionary dictionaryWithObject:_companySetting forKey:@"data"];
    [_dataArray addObject:secondItemsArrayDict];
    //
    _logoutSetting = [[NSArray alloc]initWithObjects:@"Logout", nil];
    NSDictionary *thirdItemsArrayDict = [NSDictionary dictionaryWithObject:_logoutSetting forKey:@"data"];
    [_dataArray addObject:thirdItemsArrayDict];
    
    
    UILabel *versionLabel = [[UILabel alloc]init];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.text = @"Version: 2.0.0";
    versionLabel.textColor = [UIColor grayColor];
    
    if (IS_IPAD) {
        _moreTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _moreTable.delegate =self;
        _moreTable.dataSource =self;
        [self.view addSubview:_moreTable];
        [self.view addSubview:versionLabel];

        toolbarBackground.translatesAutoresizingMaskIntoConstraints=NO;
        self.moreTable.translatesAutoresizingMaskIntoConstraints=NO;
        versionLabel.translatesAutoresizingMaskIntoConstraints=NO;
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[toolbarBackground(64)]-0-[_moreTable]-56-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(toolbarBackground,_moreTable)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_moreTable]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_moreTable)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[toolbarBackground]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(toolbarBackground)]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[versionLabel]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(versionLabel)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-580-[versionLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(versionLabel)]];
        
    }
    else if(IS_IPHONE){
        
        [toolbarBackground setFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];

        _moreTable = [[UITableView alloc]initWithFrame:CGRectMake(0.0, 64, 320.0, self.view.frame.size.height - self.tabBarController.tabBar.frame.size.height-67) style:UITableViewStyleGrouped];
        _moreTable.delegate =self;
        _moreTable.dataSource =self;
        [self.view addSubview:_moreTable];
        [_moreTable reloadData];
        [_moreTable addSubview:versionLabel];

        [versionLabel setFrame:CGRectMake(self.view.frame.size.width/2-60, self.moreTable.contentSize.height-40, 120, 40)];
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.navigationItem.rightBarButtonItem=nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_dataArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary *dictionary = [_dataArray objectAtIndex:section];
    NSArray *array = [dictionary objectForKey:@"data"];
    return [array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"studentCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"studentCell"];
    //The code simply loops through our ‘dataArray’ and gets the text object for each row and then adds it to the cell
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    NSDictionary *dictionary = [_dataArray objectAtIndex:indexPath.section]; //get dictionary
    NSArray *array = [dictionary objectForKey:@"data"]; //get array
    NSString *cellValue = [array objectAtIndex:indexPath.row];
    if ([cellValue isEqualToString:@"Play Demo to learn more"]||[cellValue isEqualToString:@"Sign your students up now!"]||[cellValue isEqualToString:@"How to sign up"]||[cellValue isEqualToString:@"Rate this App!"]) {
        [cell.textLabel setFont:[UIFont fontWithName:@"Eraser" size:18]];
    }
    else{
        [cell.textLabel setFont:nil];
    }
    
    if ([cellValue isEqualToString:@"Rate this App!"]) {
        [cell.imageView setImage:[UIImage imageNamed:@"starImg"]];
    }
    else{
        [cell.imageView setImage:nil];
    }
    
    cell.textLabel.text = cellValue;
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //selectedCell is nill first
    NSString *selectedCell = nil;
    NSDictionary *dictionary = [_dataArray objectAtIndex:indexPath.section];
    NSArray *array=[dictionary objectForKey:@"data"];
    selectedCell = [array objectAtIndex:indexPath.row];
    
    if ([selectedCell isEqualToString:@"Logout"]){
        
        UIView *loadingView = [[UIView alloc]initWithFrame:self.view.frame];
        loadingView.backgroundColor = [UIColor blackColor];
        loadingView.alpha=0.5;
        [self.view addSubview:loadingView];
        
        UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-25, (self.view.frame.size.height)/2, 50, 50)];
        [self.view addSubview:loading];
        [loading setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [loading hidesWhenStopped];
        [loading startAnimating];

        
        PushWebService *pushService = [[PushWebService alloc]init];
        NSString *devicetoken = [[NSUserDefaults standardUserDefaults] objectForKey:@"DeviceToken"];
        
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault removeObjectForKey:@"UserType"];
        [userDefault removeObjectForKey:@"Email"];
        [userDefault removeObjectForKey:@"UserId"];
        [userDefault removeObjectForKey:@"FirstName"];
        [userDefault removeObjectForKey:@"LastName"];
        [userDefault removeObjectForKey:@"Gender"];
        [userDefault synchronize];
        
        NSString *objId = [[NSUserDefaults standardUserDefaults] objectForKey:@"ObjectId"];
        [pushService removeTokenFromUserId:objId deviceToken:devicetoken];
        if ([_userType isEqualToString:@"Teacher"]) {
            
            [self performSegueWithIdentifier:@"logout" sender:self];
        }
        else{
            
            //Sign out the user student object
            UpdateWebService *updateService = [[UpdateWebService alloc]initWithTable:@"StudentObject"];
            [updateService setRowToUpdateWhereColumn:@"signedIn" equalTo:@"0"];
            [updateService selectRowToUpdateWhereColumn:@"taken" equalTo:objId];
            [updateService saveUpdate];
            
            [self performSegueWithIdentifier:@"stuLogout" sender:self];
        }
    }
    else if ([selectedCell isEqualToString:@"Sign your students up now!"]||[selectedCell isEqualToString:@"How to sign up"]){
        
        //initialize
        [self showSignUpView];
        
        
    }
    else if ([selectedCell isEqualToString:@"Rate this App!"]){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=892544489"]];
    }
    else if ([selectedCell isEqualToString:@"Play Demo to learn more"]){
        if ([self.userType isEqualToString:@"Teacher"]) {
            [self performSegueWithIdentifier:@"teacherToDemoSegue" sender:self];

        }
        else{
            [self performSegueWithIdentifier:@"studentToDemoSegue" sender:self];

        }

    }
    else if([selectedCell isEqualToString:@"Restart Bank"]){
        [self performSegueWithIdentifier:@"restartsegue" sender:self];
    }
    else if([selectedCell isEqualToString:@"Clear Broadcast"]){
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Are you sure you want to clear your broadcast?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete" otherButtonTitles:nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
        [actionSheet showInView:self.view];
        
    }
    else if([selectedCell isEqualToString:@"Settings"]){
        if ([_userType isEqualToString:@"Teacher"]) {
            [self performSegueWithIdentifier:@"settings" sender:self];
        }
        else{
            [self performSegueWithIdentifier:@"stuSettings" sender:self];
        }

    }
    else if([selectedCell isEqualToString:@"Ask Us A Question!"]){
        
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        [mc setSubject:@"Feedback"];
        [mc setToRecipients:@[@"info@www.pixelandprocessor.com"]];
        // Present mail view controller on screen
        [self presentViewController:mc animated:YES completion:NULL];
        
    }
    
    else if ([selectedCell isEqualToString:@"Privacy & Terms"]){
        [self performSegueWithIdentifier:@"TeacherTermsPrivacySegue" sender:self];
    }
    
    [_moreTable deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
	{
        UIView *loadingView = [[UIView alloc]initWithFrame:self.view.frame];
        loadingView.backgroundColor = [UIColor blackColor];
        loadingView.alpha=0.5;
        [self.view addSubview:loadingView];
        
        UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-25, (self.view.frame.size.height-25)/2, 50, 50)];
        [self.view addSubview:loading];
        [loading setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [loading hidesWhenStopped];
        [loading startAnimating];
        
        NSString *objId = [[NSUserDefaults standardUserDefaults] objectForKey:@"ObjectId"];
        DeleteWebService *deleteBroadcast = [[DeleteWebService alloc]initWithTable:@"Broadcast"];
        [deleteBroadcast selectRowToDeleteWhereColumn:@"TeacherId" equalTo:objId];
        [deleteBroadcast deleteRowInBackgroundWithBlock:^(NSError *error) {
            if (error) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed." message:@"You must have a network connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            else{
            
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Your broadcast has been successfully cleared" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                
                [loading stopAnimating];
                [loading removeFromSuperview];
                [loadingView removeFromSuperview];
            }
        }];
    
    }
}

-(void)showSignUpView{

    self.gestureRecognizer =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideSignUpView)];
    
    UIView *studentSignUpBackground = [UIView new];
    [studentSignUpBackground setTag:1000];
    [self.view addSubview:studentSignUpBackground];
    [studentSignUpBackground addGestureRecognizer:self.gestureRecognizer];
    
    UIImageView *blackboardDirection = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"blackboardBorder"]];
    [blackboardDirection setTag:2000];
    [blackboardDirection setAlpha:0];
    [blackboardDirection setUserInteractionEnabled:YES];
    [studentSignUpBackground addSubview:blackboardDirection];
    
    if (IS_IPHONE) {
        [studentSignUpBackground setFrame:self.view.frame];
        [blackboardDirection setFrame:CGRectMake(0, 64, 320, 420)];
    }
    else if (IS_IPAD){
        studentSignUpBackground.translatesAutoresizingMaskIntoConstraints=NO;
        blackboardDirection.translatesAutoresizingMaskIntoConstraints=NO;
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[studentSignUpBackground]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(studentSignUpBackground)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[studentSignUpBackground]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(studentSignUpBackground)]];
        
        [studentSignUpBackground addConstraint:[NSLayoutConstraint constraintWithItem:blackboardDirection attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:studentSignUpBackground attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [studentSignUpBackground addConstraint:[NSLayoutConstraint constraintWithItem:blackboardDirection attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:studentSignUpBackground attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        
        [blackboardDirection addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[blackboardDirection(500)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(blackboardDirection)]];
        [blackboardDirection addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[blackboardDirection(500)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(blackboardDirection)]];

    }
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [blackboardDirection setAlpha:1];
        [blackboardDirection setTransform:CGAffineTransformMakeScale(0.9, 0.9)];
        
    } completion:^(BOOL finished) {
        
        UILabel *directionLabel = [UILabel new];
        [directionLabel setNumberOfLines:0];
        [directionLabel setTextColor:[UIColor whiteColor]];
        [directionLabel setFrame:CGRectMake(10, 15, blackboardDirection.frame.size.width+15, blackboardDirection.frame.size.height-200)];
        [blackboardDirection addSubview:directionLabel];
        [directionLabel setText:@"Your students will need three things to sign up! \n\n-The student's name on your list.\n-Your email address on Primo.\n-The class name"];
        
        UIImageView *directionImage = [UIImageView new];
        [directionImage setImage:[UIImage imageNamed:@"tutorialImg8"]];
        [blackboardDirection addSubview:directionImage];
        
        if (IS_IPHONE) {
            [directionLabel setFont:[UIFont fontWithName:@"Eraser" size:15]];
            [directionImage setFrame:CGRectMake(blackboardDirection.center.x-150,directionLabel.frame.origin.y+directionLabel.frame.size.height,295,blackboardDirection.frame.size.height-directionLabel.frame.size.height+10 )];
            NSLog(@"directionImage: %f",directionImage.frame.size.height);

        }
        else if (IS_IPAD){
            [directionLabel setFont:[UIFont fontWithName:@"Eraser" size:20]];
            [directionImage setFrame:CGRectMake(directionLabel.center.x-206,directionLabel.frame.origin.y+directionLabel.frame.size.height,412,210 )];

        }
        
    }];

}

-(void)hideSignUpView{
    
    UIView *backgroundView = [self.view viewWithTag:1000];
    
    UIImageView *blackboardImageView = (UIImageView*)[backgroundView viewWithTag:2000];
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        [blackboardImageView setTransform:CGAffineTransformMakeScale(10/9, 10/9)];
        [blackboardImageView setAlpha:0];
        
    } completion:^(BOOL finished) {
        
        [blackboardImageView removeFromSuperview];
        [backgroundView removeFromSuperview];

    }];
}


- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if(section == 1)
        return @"Settings";
    else if(section == 2)
        return @"About Us";
    else if(section == 3)
        return @"Logout";
    else
        return nil;
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"restartsegue"]) {

        RestartCoinsViewController *restartVC = (RestartCoinsViewController*)segue.destinationViewController;
        
        restartVC.classNameInRestart = self.classNameInMore;
        restartVC.managedObjectContext=_managedObjectContext;
        restartVC.demoManagedObjectContext=self.demoManagedObjectContext;
    }
    else if ([segue.identifier isEqualToString:@"settings"]){
        SettingsViewController *settingsVC = (SettingsViewController*)segue.destinationViewController;
        settingsVC.className = self.classNameInMore;
        settingsVC.managedObjectContext=_managedObjectContext;
        settingsVC.demoManagedObjectContext=self.demoManagedObjectContext;
    
    }
    else if([segue.identifier isEqualToString:@"logout"]){
        UINavigationController *navigationController = (UINavigationController *)segue.destinationViewController;
        LaunchViewController *controller = [navigationController.viewControllers objectAtIndex:0];
        controller.managedObjectContext = self.managedObjectContext;
        controller.demoManagedObjectContext=self.demoManagedObjectContext;
    }
    //students segues
    else if ([segue.identifier isEqualToString:@"stuSettings"]){
        SettingsViewController *settingsVC = (SettingsViewController*)segue.destinationViewController;
        settingsVC.studentObj=self.studentObj;
        settingsVC.teacherObj=self.teacherObj;
        settingsVC.demoManagedObjectContext=self.demoManagedObjectContext;
    }
    else if([segue.identifier isEqualToString:@"stuLogout"]){
        UINavigationController *navigationController = (UINavigationController *)segue.destinationViewController;
        LaunchViewController *controller = [navigationController.viewControllers objectAtIndex:0];
        controller.managedObjectContext = self.studentObj.managedObjectContext;
        controller.demoManagedObjectContext=self.demoManagedObjectContext;
    }
    else if ([segue.identifier isEqualToString:@"teacherToDemoSegue"]||[segue.identifier isEqualToString:@"studentToDemoSegue"]){
        StartViewController *startVC = (StartViewController*)segue.destinationViewController;
        startVC.managedObjectContext=self.managedObjectContext;
        startVC.demoManagedObjectContext=self.demoManagedObjectContext;
        startVC.isDemo=YES;
    }
}


@end
