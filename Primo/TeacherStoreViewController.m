//
//  TeacherStoreViewController.m
//  TeacherApp
//
//  Created by Jarrett Chen on 3/5/14.
//  Copyright (c) 2014 Jarrett Chen. All rights reserved.
//

#import "TeacherStoreViewController.h"
#import "BuyItemsViewController.h"
#import "AnnouncementObject.h"
#import "QueryWebService.h"
#import "StudentObject+CreateClassList.h"
#import "TeacherObject+CreateTeacher.h"

@interface TeacherStoreViewController ()

@property (nonatomic,strong) NSString *dateString;
@property (nonatomic) NSInteger month;
@property (nonatomic) UILabel *connection;
@property (nonatomic,strong) UIView *closedBackground;
@property (nonatomic,strong) NSString *teacherId;

//Teacher's parameters
@property (nonatomic,strong) StoreObject *storeItem;

@end

@implementation TeacherStoreViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *toolbarBackground = [[UIImageView alloc]init];
    [toolbarBackground setImage:[UIImage imageNamed:@"blackboardBar"]];
    toolbarBackground.userInteractionEnabled=YES;
    [self.view addSubview:toolbarBackground];
    
    NSString *objId = [[NSUserDefaults standardUserDefaults] objectForKey:@"ObjectId"];
    _userType = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserType"];
    
    if ([_userType isEqualToString:@"Teacher"]){
        self.teacherId = objId;
    }
    else{
        self.teacherId = self.teacherObj.teacherId;
    }
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
    
    
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    
    //ToolBar
    
    //background image
    UIImageView *shieldImage = [[UIImageView alloc]init];
    [shieldImage setImage:[UIImage imageNamed:@"storeIconWelcome"]];
    shieldImage.contentMode=UIViewContentModeScaleAspectFill;
    [self.view addSubview:shieldImage];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text=@"Welcome to the Store!";
    nameLabel.textColor = [UIColor grayColor];
    nameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:28];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:nameLabel];
    
    UIImage * dividerImage=[UIImage imageNamed:@"Divider"];
    UIImageView *dividerUnderLabel = [[UIImageView alloc]init];
    [dividerUnderLabel setImage:dividerImage];
    [self.view addSubview:dividerUnderLabel];
    
    
    if (IS_IPAD) {
        
        toolbarBackground.translatesAutoresizingMaskIntoConstraints=NO;
        shieldImage.translatesAutoresizingMaskIntoConstraints=NO;
        dividerUnderLabel.translatesAutoresizingMaskIntoConstraints=NO;
        nameLabel.translatesAutoresizingMaskIntoConstraints=NO;

        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[toolbarBackground]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(toolbarBackground)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[toolbarBackground(64)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(toolbarBackground)]];
        
        //Vertical
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:shieldImage attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-94-[shieldImage(109)]-25-[nameLabel(45)]-0-[dividerUnderLabel(10)]" options:NSLayoutFormatAlignAllCenterX metrics:nil views:NSDictionaryOfVariableBindings(shieldImage,nameLabel,dividerUnderLabel)]];
        
    }
    else if (IS_IPHONE){

        //Tall screen
        [toolbarBackground setFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
        [shieldImage setFrame:CGRectMake((self.view.frame.size.width/2)-45,64+20, 90, 90)];
        [nameLabel setFrame:CGRectMake((self.view.frame.size.width/2)-150,180, 300, 40)];
        [dividerUnderLabel setFrame:CGRectMake((self.view.frame.size.width/2)-dividerImage.size.width/2, nameLabel.frame.origin.y+nameLabel.frame.size.height, dividerImage.size.width, dividerImage.size.height)];
        
        if (self.view.frame.size.height<568) {
            //Short 3.5 screen
            
            [shieldImage setFrame:CGRectMake(shieldImage.frame.origin.x, shieldImage.frame.origin.y-10, shieldImage.frame.size.width, shieldImage.frame.size.height)];
            [nameLabel setFrame:CGRectMake(nameLabel.frame.origin.x, nameLabel.frame.origin.y-20, nameLabel.frame.size.width, nameLabel.frame.size.height)];
            [dividerUnderLabel setFrame:CGRectMake(dividerUnderLabel.frame.origin.x,dividerUnderLabel.frame.origin.y-20, dividerUnderLabel.frame.size.width, dividerUnderLabel.frame.size.height)];
            
        }

        
    }
    
    [self itemsFromParse]; //store

}

-(void)viewWillAppear:(BOOL)animated{

    if ([_userType isEqualToString:@"Teacher"]){
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(segueButtonActions:)];
        [rightButton setTag:100];
        [self.tabBarController.navigationItem setRightBarButtonItem:rightButton];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(didBecomeActive) name: UIApplicationDidBecomeActiveNotification object: nil];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    //Check connection
    if (self.connection!=nil && self.storeTable!=nil) {
        [self.connection removeFromSuperview];
        self.connection=nil;
        [self refreshTeacherStore];
    }
    else if(self.connection !=nil && self.storeTable ==nil){
        [self.connection removeFromSuperview];
        self.connection=nil;
        [self itemsFromParse];
    }
    
}

-(void)didBecomeActive{
    
    if (self.connection!=nil && self.storeTable!=nil) {
        [self.connection removeFromSuperview];
        self.connection=nil;
        [self refreshTeacherStore];
    }
    else if(self.connection !=nil && self.storeTable ==nil){
        [self.connection removeFromSuperview];
        self.connection=nil;
        [self itemsFromParse];
    }
    else if(self.connection == nil && self.storeTable !=nil){
        [self refreshTeacherStore];
    }
    else if(self.connection == nil && self.storeTable ==nil){
        [self itemsFromParse];
    }
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

-(void)emptyStoreView{
    
    self.closedBackground = [UIView new];
    [self.closedBackground setUserInteractionEnabled:YES];
    [self.closedBackground setBackgroundColor:[UIColor colorWithWhite:0.1 alpha:0.8]];
    [self.view addSubview:self.closedBackground];
    
    UILabel *directionLabel = [UILabel new];
    [directionLabel setNumberOfLines:0];
    [directionLabel setTextColor:[UIColor whiteColor]];
    [directionLabel setTextAlignment:NSTextAlignmentCenter];
    [self.closedBackground addSubview:directionLabel];
    
    if ([self.userType isEqualToString:@"Teacher"]) {
        [directionLabel setText:[NSString stringWithFormat:@"Let's start by stocking up your store for a \nGRAND OPENING!"]];
    }
    else{
        [directionLabel setText:[NSString stringWithFormat:@"Your teacher didn't open the store yet!"]];
    }
    
    UIImageView *tutorialbackground = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"blackboardBorder"]];
    [tutorialbackground setTag:1000];
    [tutorialbackground setAlpha:0];
    [self.closedBackground addSubview:tutorialbackground];
    
//    if (IS_IPHONE) {
//        [tutorialbackground setFrame:CGRectMake(0, 240, 320, 180)];
//        
//        if ([self.userType isEqualToString:@"Teacher"]) {
//            BouncingPencil *pencilArrow = [[BouncingPencil alloc]initWithFrame:CGRectMake(220, 44, 60, 60)];
//            [pencilArrow setTag:2000];
//            [pencilArrow setUpPencilBounceFrame:pencilArrow.frame targetX:15 targetY:-9 rotation:5*M_PI_4];
//            [self.closedBackground addSubview:pencilArrow];
//        }
//        
//        [self.closedBackground setFrame:self.view.frame];
//        [directionLabel setFrame:CGRectMake(30, 90, 280,100)];
//        
//    }
//    else if (IS_IPAD){
    
        self.closedBackground.translatesAutoresizingMaskIntoConstraints=NO;
        directionLabel.translatesAutoresizingMaskIntoConstraints=NO;
        tutorialbackground.translatesAutoresizingMaskIntoConstraints=NO;
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_closedBackground]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_closedBackground)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_closedBackground]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_closedBackground)]];
        
        [self.closedBackground addConstraint:[NSLayoutConstraint constraintWithItem:directionLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.closedBackground attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];

    [self.closedBackground addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-90-[directionLabel]-100-[tutorialbackground]" options:NSLayoutFormatAlignAllCenterX metrics:nil views:NSDictionaryOfVariableBindings(directionLabel,tutorialbackground)]];
    
    
        [self.closedBackground addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[tutorialbackground]-10-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:NSDictionaryOfVariableBindings(tutorialbackground)]];

        if ([self.userType isEqualToString:@"Teacher"]) {
            
            //Set bouncing Pencil
            BouncingPencil *pencilArrow = [[BouncingPencil alloc]init];
            [pencilArrow setTag:2000];
            [self.closedBackground addSubview:pencilArrow];
            
            pencilArrow.translatesAutoresizingMaskIntoConstraints=NO;
            
            [self.closedBackground addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-45-[pencilArrow(60)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(pencilArrow)]];
            [self.closedBackground addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[pencilArrow(60)]-50-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(pencilArrow)]];
            [pencilArrow setUpPencilBounceForiPad:CGSizeMake(60, 60) targetX:15 targetY:-9 rotation:5*M_PI_4];
        }
//    }
    
    CGAffineTransform transform = CGAffineTransformMakeScale(0.9, 0.9);
    [tutorialbackground.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        [tutorialbackground setAlpha:1];
        [tutorialbackground setTransform:transform];
        
    } completion:^(BOOL finished) {
        
        UILabel *closedLabel = [UILabel new];
        [closedLabel setFrame:CGRectMake(20,5,tutorialbackground.frame.size.width-40,tutorialbackground.frame.size.height-10)];
        [closedLabel setText:[NSString stringWithFormat:@"Uh oh! \n Your store is closed."]];
        [closedLabel setNumberOfLines:0];
        [closedLabel setFont:[UIFont fontWithName:@"Eraser" size:18]];
        [closedLabel setTextColor:[UIColor whiteColor]];
        [closedLabel setTextAlignment:NSTextAlignmentCenter];
        [tutorialbackground addSubview:closedLabel];
        
    }];
}


-(void)itemsFromParse{
    UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-50, (self.view.frame.size.height-64)/2, 30, 30)];
    [self.view addSubview:loadingView];
    UILabel *loadingLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-20,(self.view.frame.size.height-64)/2, 70, 30)];
    [loadingLabel setText:@"Loading..."];
    [loadingLabel setFont:[UIFont systemFontOfSize:14]];
    [loadingLabel setTextColor:[UIColor lightGrayColor]];
    [self.view addSubview:loadingLabel];
    
    [loadingView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [loadingView hidesWhenStopped];
    [loadingView startAnimating];
    
    QueryWebService *query = [[QueryWebService alloc]initWithTable:@"Store"];
    [query selectColumnWhere:@"Teacher" equalTo:self.teacherId];
    [query findAllObjectsInRowWithCompletion:^(NSError *error, NSArray *rows) {
        
        if(error) {
            
            if (self.connection ==nil) {
                
                self.connection = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, 64, self.view.frame.size.width,30)];
                [self.connection setBackgroundColor:[UIColor redColor]];
                [self.connection setTextColor:[UIColor whiteColor]];
                self.connection.textAlignment = NSTextAlignmentCenter;
                [self.connection setText:@"No Internet Connection"];
                [self.view addSubview:self.connection];
            }
            
        }
        else{
            
            if (self.connection !=nil) {
                [self.connection removeFromSuperview];
                self.connection =nil;
            }
            
            CGFloat tableHeight = 180;
            _storeTable = [[UITableView alloc]init];
            _storeTable.cellLayoutMarginsFollowReadableWidth = NO;
            _storeTable.delegate =self;
            _storeTable.dataSource =self;
            [self.view addSubview:_storeTable];
            [_storeTable addSubview:_refreshControl];
            self.storeItemsArray = [[NSMutableArray alloc]initWithArray:rows];

            
            if (IS_IPAD) {
                
                _storeTable.translatesAutoresizingMaskIntoConstraints=NO;
                
                [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_storeTable]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_storeTable)]];
                
                [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-314-[_storeTable]-56-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_storeTable)]];
                
                
            }
            else if(IS_IPHONE){
                
                [_storeTable setFrame:CGRectMake(0.0,64+tableHeight,self.view.frame.size.width, self.view.frame.size.height - self.tabBarController.tabBar.frame.size.height-64-tableHeight)];

                
                if (self.view.frame.size.height<568) {
                    NSLog(@"short");
                    
                    [_storeTable setFrame:CGRectMake(0.0,64,self.view.frame.size.width, self.view.frame.size.height - self.tabBarController.tabBar.frame.size.height-64-150)];
                    
                }

            }
            
            [self.storeTable reloadData];

            if ([_userType isEqualToString:@"Teacher"]){
                UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(segueButtonActions:)];
                [rightButton setTag:100];
                self.tabBarController.navigationItem.rightBarButtonItem = rightButton;
            }
        }
        [loadingView stopAnimating];
        [loadingLabel removeFromSuperview];
        
        //Put in empty store directions
        if ([self.storeItemsArray count] == 0) {
            
            if (self.closedBackground ==nil) {
                
                [self emptyStoreView];
            }
        }
        else{
            if (self.closedBackground !=nil) {
                [self.closedBackground removeFromSuperview];
                self.closedBackground=nil;
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CONGRATULATIONS!" message:@"You just opened your store!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }
    }];
    
}//query starts now

-(void)refreshTeacherStore{
    
    UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc]init];
    [loadingView setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:0.5]];
    [self.view addSubview:loadingView];
    UILabel *loadingLabel = [[UILabel alloc]init];
    [loadingLabel setText:@"Refresh..."];
    [loadingLabel setFont:[UIFont systemFontOfSize:14]];
    [loadingLabel setTextColor:[UIColor blackColor]];
    [loadingLabel setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:0.5]];
    [self.view addSubview:loadingLabel];
    [loadingView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [loadingView hidesWhenStopped];
    [loadingView startAnimating];

    if (IS_IPAD) {
        loadingView.translatesAutoresizingMaskIntoConstraints=NO;
        loadingLabel.translatesAutoresizingMaskIntoConstraints=NO;
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:loadingView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:-50]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[loadingView(30)]-56-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(loadingView)]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:loadingLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:loadingView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[loadingLabel(30)]-56-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(loadingLabel)]];
    }
    else if (IS_IPHONE){
        [loadingView setFrame:CGRectMake(self.view.frame.size.width/2-50,self.view.frame.size.height-self.tabBarController.tabBar.frame.size.height-30, 30, 30)];
        [loadingLabel setFrame:CGRectMake(self.view.frame.size.width/2-20,self.view.frame.size.height-self.tabBarController.tabBar.frame.size.height-30, 70, 30)];
    }
    
    QueryWebService *query = [[QueryWebService alloc]initWithTable:@"Store"];
    [query selectColumnWhere:@"Teacher" equalTo:self.teacherId];
    [query findAllObjectsInRowWithCompletion:^(NSError *error, NSArray *rows) {
        
        if(error) {
            
            if (self.connection ==nil) {
                
                self.connection = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, 64, self.view.frame.size.width,30)];
                [self.connection setBackgroundColor:[UIColor redColor]];
                [self.connection setTextColor:[UIColor whiteColor]];
                self.connection.textAlignment = NSTextAlignmentCenter;
                [self.connection setText:@"No Internet Connection"];
                [self.view addSubview:self.connection];
            }
            
        }
        else{
            
            if (self.connection !=nil) {
                [self.connection removeFromSuperview];
                self.connection =nil;
            }
            
            [self.storeItemsArray removeAllObjects];
            [self.storeItemsArray addObjectsFromArray:rows];
            [self.storeTable reloadData];
            
            if ([self.storeItemsArray count] == 0) {
                if (self.closedBackground == nil) {
                    [self emptyStoreView];
                }
            }
            else{
                if (self.closedBackground !=nil) {
                    [self.closedBackground removeFromSuperview];
                    self.closedBackground =nil;
                }
            }
            
        }
        [loadingView stopAnimating];
        [loadingView removeFromSuperview];
        [loadingLabel removeFromSuperview];
    }];

    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_storeItemsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *CellIdentifier = @"storeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"storeCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

        UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        buyButton.layer.cornerRadius = 3;
        buyButton.layer.borderWidth = 2;
        buyButton.layer.borderColor = [[UIColor colorWithRed:0.0 green:0.478431 blue:1.0 alpha:1.0]CGColor];

        buyButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [buyButton addTarget:self action:@selector(buyButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [buyButton setTag:500];
        [cell.contentView addSubview:buyButton];

//        if (IS_IPAD) {
            buyButton.translatesAutoresizingMaskIntoConstraints=NO;
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-7-[buyButton(30)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(buyButton)]];
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[buyButton(74)]-40-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(buyButton)]];
            
//        }
//        else if (IS_IPHONE){
//            buyButton.frame = CGRectMake(238, 7, 74, 30);
//
//        }

    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    NSNumber *cost = [self.storeItemsArray objectAtIndex:indexPath.row][@"Cost"];
    NSString *costString = [NSString stringWithFormat:@"%@ Coins",cost];
    
    cell.textLabel.text = [_storeItemsArray objectAtIndex:indexPath.row][@"Item"];
    [(UIButton*)[cell.contentView viewWithTag:500] setTitle:costString forState:UIControlStateNormal];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    if ([self.userType isEqualToString:@"Teacher"]) {
        return YES;
    }
    else{
        return NO;
    }
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString *objId = [[NSUserDefaults standardUserDefaults] objectForKey:@"ObjectId"];
        DeleteWebService *deleteStore = [[DeleteWebService alloc]initWithTable:@"Store"];
        [deleteStore selectRowToDeleteWhereColumn:@"Teacher" equalTo:objId];
        [deleteStore selectRowToDeleteWhereColumn:@"Item" equalTo:[_storeItemsArray objectAtIndex:indexPath.row][@"Item"]];
        [deleteStore deleteRow];
        
        [self.storeItemsArray removeObjectAtIndex:indexPath.row];
        
        [self.storeTable beginUpdates];
        [self.storeTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.storeTable endUpdates];

        if ([self.storeItemsArray count] == 0) {
            [self emptyStoreView];
        }
        
    }
}

//buying action
-(void)buyButtonAction: (UIButton*)sender{
    
    if (self.connection ==nil) {
        
        UIButton *btn = (UIButton *)sender;
        UITableViewCell *cell = [self parentCellForView:btn];
        
        //buy action

        if (cell != nil) {
            
            NSIndexPath *indexPath = [_storeTable indexPathForCell:cell];
            
            NSNumber *storeCost = [_storeItemsArray objectAtIndex:indexPath.row][@"Cost"];
            NSString *storeItem = [_storeItemsArray objectAtIndex:indexPath.row][@"Item"];
            
            self.storeItem = [[StoreObject alloc]initWithItem:storeItem atCost:storeCost];
            
            //Action when button is pressed
            if ([self.userType isEqualToString:@"Teacher"]) {
                
                [self performSegueWithIdentifier:@"buystudent" sender:self];
            }
            else{
                NSString *actionTitle = [NSString stringWithFormat:@"Are you sure you want to purchase: %@ for %d",storeItem,[storeCost intValue]];
                
                UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:actionTitle delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Buy", nil];
                actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
                [actionSheet showInView:self.view];
            }

        }
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Theres an error" message:@"Please check your wireless connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

//students buy
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	// The user tapped one of the OK/Cancel buttons.
	if (buttonIndex == 0)
	{

        NSNumber *studentCoins = self.studentObj.coins;
        NSInteger studentCoinsInt = [studentCoins intValue];
        
        if (studentCoinsInt<[self.storeItem.cost intValue]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You do not have enough coins to purchase this item" message:@"Please select another item" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else{
            
            [self.studentObj buyCoinsStudentObject:self.storeItem.cost];

            [_managedObjectContext save:nil];
            
            NSString *alertMessage = [NSString stringWithFormat:@"You now have %d coins in your account",[self.studentObj.coins intValue]];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat: @"YAY! You've just bought: %@!",self.storeItem.item] message:alertMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
            
            //Update Database
            UpdateWebService *updateService = [[UpdateWebService alloc]initWithTable:@"StudentObject"];
            [updateService setRowToUpdateWhereColumn:@"coins" equalTo:[self.studentObj.coins stringValue]];
            [updateService selectRowToUpdateWhereColumn:@"objectId" equalTo:self.studentObj.objectId];
            [updateService saveUpdate];

            //update log
            LogWebService *studentLogService = [[LogWebService alloc]initWithLogType:@"class_logs"];
            NSString *studentLogText =[NSString stringWithFormat:@"%@ purchased %@ for %@ coins",self.studentObj.studentName,self.storeItem.item,self.storeItem.cost];
            [studentLogService updateLogWithUserId:self.studentObj.objectId className:self.studentObj.nameOfclass updateLogString:studentLogText];
            
            NSString *announcementBody = [NSString stringWithFormat:@"%@ has purchased %@ for %@ coins",self.studentObj.studentName,self.storeItem.item,self.storeItem.cost];
            
            LogWebService *studentAnnouncementLog= [[LogWebService alloc]initWithLogType:@"announcement"];
            [studentAnnouncementLog updateLogWithUserId:self.studentObj.objectId className:self.studentObj.nameOfclass updateLogString:announcementBody];
            
            LogWebService *teacherAnnouncementLog = [[LogWebService alloc]initWithLogType:@"announcement"];
            [teacherAnnouncementLog updateLogWithUserId:self.teacherId className:self.studentObj.nameOfclass updateLogString:announcementBody];
            
            //set notification for teacher
            AnnouncementObject *annObj = [[AnnouncementObject alloc]initWithTeacherId:self.teacherId];
            
            [annObj updateBadgeToDatabaseWithId:self.teacherId className:self.studentObj.nameOfclass];
            
            [annObj postAnnouncementTo:[self.studentObj.nameOfclass capitalizedString] announcementType:@"Store" personType:@"Teacher" announcementBody:announcementBody];
            
            PushWebService *pushWeb = [[PushWebService alloc]init];
            [pushWeb sendPushToUserIDS:@[self.teacherId] pushMessage:announcementBody];
            
            [self.tabBarController setSelectedIndex:0];
        }
    }
}



-(UITableViewCell *)parentCellForView:(id)theView{
    id viewSuperView = [theView superview];
    while (viewSuperView != nil) {
        if ([viewSuperView isKindOfClass:[UITableViewCell class]]) {
            return (UITableViewCell *)viewSuperView;
        }
        else {
            viewSuperView = [viewSuperView superview];
        }
    }
    return nil;
}


//keyboard stuff
-(void)hideKeyboard{
    [self.view endEditing:YES];
}

- (void)refresh:(UIRefreshControl *)refreshControl {

    QueryWebService *query = [[QueryWebService alloc]initWithTable:@"Store"];
    [query selectColumnWhere:@"Teacher" equalTo:self.teacherId];
    [query findAllObjectsInRowWithCompletion:^(NSError *error, NSArray *rows) {
        
        if(error) {
            
            if (self.connection ==nil) {
                
                self.connection = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, 64, self.view.frame.size.width,30)];
                [self.connection setBackgroundColor:[UIColor redColor]];
                [self.connection setTextColor:[UIColor whiteColor]];
                self.connection.textAlignment = NSTextAlignmentCenter;
                [self.connection setText:@"No Internet Connection"];
                [self.view addSubview:self.connection];
            }
            
        }
        else{
            
            if (self.connection !=nil) {
                [self.connection removeFromSuperview];
                self.connection =nil;
            }
            
            [self.storeItemsArray removeAllObjects];
            [self.storeItemsArray addObjectsFromArray:rows];
            [self.storeTable reloadData];

        }
        [refreshControl endRefreshing];
    }];
    
}

-(void)segueButtonActions:(UIButton*)sender{
 
    if (self.connection ==nil) {
        
        [self performSegueWithIdentifier:@"addStoreSegue" sender:self];
        
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Check your wireless connection" message:@"You cannot add items until you have a connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    

}

//addStoreDelegate
-(void)refreshStoreAfterDoneAddStoreVC:(AddStoreViewController *)viewController{
    
    if (self.closedBackground !=nil) {
        [self.closedBackground removeFromSuperview];
        self.closedBackground=nil;
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CONGRATULATIONS!" message:@"You just opened your store!" delegate:self cancelButtonTitle:@"YAY!" otherButtonTitles:nil];
        [alert show];
    }

    [self refreshTeacherStore];

    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"buystudent"]) {
        // teachers buy
        BuyItemsViewController* pickStudentVC = (BuyItemsViewController*)segue.destinationViewController;
        pickStudentVC.managedObjectContext=self.managedObjectContext;
        pickStudentVC.storeItem = _storeItem;
        pickStudentVC.className = self.className;
        pickStudentVC.demoManagedObjectContext=self.demoManagedObjectContext;
        
    }
    else if([segue.identifier isEqualToString:@"addStoreSegue"]){
        
        AddStoreViewController *studentBufferVC = (AddStoreViewController*)segue.destinationViewController;
        studentBufferVC.delegate=self;
    }

    

}

@end
