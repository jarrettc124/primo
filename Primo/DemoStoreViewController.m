//
//  DemoStoreViewController.m
//  Primo
//
//  Created by Jarrett Chen on 8/27/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import "DemoStoreViewController.h"

@interface DemoStoreViewController ()
@property (nonatomic, strong) UITableView *storeTable;
@property(nonatomic,strong) NSMutableArray *storeItemsArray;
@property (nonatomic,strong) UIView *closedBackground;
@property (nonatomic,strong) DemoStoreObject *storeObjectToPass;

@property (nonatomic,strong) DemoTeacher *teacherProgress;
@property (nonatomic,strong) DemoStudent *studentProgress;

@property (nonatomic,strong) UIProgressView *demoProgressBar;
@end

@implementation DemoStoreViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
    
    UIImageView *toolbarBackground = [[UIImageView alloc]init];
    [toolbarBackground setImage:[UIImage imageNamed:@"blackboardBar"]];
    toolbarBackground.userInteractionEnabled=YES;
    [self.view addSubview:toolbarBackground];
    
    self.storeItemsArray = [[NSMutableArray alloc]initWithCapacity:0];
    
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
    
    CGFloat tableHeight = 180;
    _storeTable = [[UITableView alloc]init];
    _storeTable.delegate =self;
    _storeTable.dataSource =self;
    [self.view addSubview:_storeTable];
    
    
    if (IS_IPAD) {
        
        _storeTable.translatesAutoresizingMaskIntoConstraints=NO;
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_storeTable]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_storeTable)]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-314-[_storeTable]-99-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_storeTable)]];
        
        
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
        [shieldImage setFrame:CGRectMake((self.view.frame.size.width/2)-45,84, 90, 90)];
        [nameLabel setFrame:CGRectMake((self.view.frame.size.width/2)-150,180, 300, 40)];
        [dividerUnderLabel setFrame:CGRectMake((self.view.frame.size.width/2)-dividerImage.size.width/2, nameLabel.frame.origin.y+nameLabel.frame.size.height, dividerImage.size.width, dividerImage.size.height)];
        [toolbarBackground setFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
        
        [_storeTable setFrame:CGRectMake(0.0,64+tableHeight,self.view.frame.size.width, self.view.frame.size.height - self.tabBarController.tabBar.frame.size.height-64-tableHeight-35)];
        
        
        if (self.view.frame.size.height<568) {
            //Short 3.5 screen
            
            [_storeTable setFrame:CGRectMake(0.0,64+150,self.view.frame.size.width, self.view.frame.size.height - self.tabBarController.tabBar.frame.size.height-64-60)];
            [shieldImage setFrame:CGRectMake(shieldImage.frame.origin.x, shieldImage.frame.origin.y-10, shieldImage.frame.size.width, shieldImage.frame.size.height)];
            [nameLabel setFrame:CGRectMake(nameLabel.frame.origin.x, nameLabel.frame.origin.y-20, nameLabel.frame.size.width, nameLabel.frame.size.height)];
            [dividerUnderLabel setFrame:CGRectMake(dividerUnderLabel.frame.origin.x,dividerUnderLabel.frame.origin.y-20, dividerUnderLabel.frame.size.width, dividerUnderLabel.frame.size.height)];
            
        }
    }
    
    self.demoProgressBar= [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    [self.view addSubview:self.demoProgressBar];
    self.demoProgressBar.translatesAutoresizingMaskIntoConstraints=NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_demoProgressBar]-20-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_demoProgressBar)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_demoProgressBar(12)]-60-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_demoProgressBar)]];
    
    if ([self.userType isEqualToString:@"Teacher"]) {
        self.teacherProgress = [DemoTeacher findTeacherProgress:_demoManagedObjectContext];
    }
    else{
        self.studentProgress = [DemoStudent findStudentProgress:_demoManagedObjectContext];
    }
    
}

-(void)startBuyTutorial{
    
    if ([self.userType isEqualToString:@"Teacher"]){
    
        if ([self.teacherProgress.openStoreDone boolValue] && ![self.teacherProgress.buyStoreDone boolValue]) {
            [self hideTutorialArrow:YES hideBlackboard:YES];

            UIImageView *tutorialbackground = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"blackboardBorder"]];
            [tutorialbackground setUserInteractionEnabled:YES];
            [tutorialbackground setTag:1000];
            [tutorialbackground setAlpha:0];
            [self.view addSubview:tutorialbackground];

            if(IS_IPHONE){
                [tutorialbackground setFrame:CGRectMake(10, 120, 240, 100)];
                
                BouncingPencil *pencilArrow = [[BouncingPencil alloc]initWithFrame:CGRectMake(190, 195, 60, 60)];
                [pencilArrow setTag:2000];
                [pencilArrow setUpPencilBounceFrame:pencilArrow.frame targetX:-15 targetY:-9 rotation:-M_PI_4];
                [self.view addSubview:pencilArrow];
            }
            else if (IS_IPAD){
                tutorialbackground.translatesAutoresizingMaskIntoConstraints=NO;
                [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[tutorialbackground(300)]-150-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tutorialbackground)]];
                [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-400-[tutorialbackground(170)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tutorialbackground)]];
                
                //Set bouncing pencil
                BouncingPencil *pencilArrow = [[BouncingPencil alloc]init];
                [pencilArrow setTag:2000];
                [self.view addSubview:pencilArrow];
                
                pencilArrow.translatesAutoresizingMaskIntoConstraints=NO;
                [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-330-[pencilArrow(60)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(pencilArrow)]];
                [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[pencilArrow(60)]-150-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(pencilArrow)]];
                [pencilArrow setUpPencilBounceForiPad:CGSizeMake(60, 60) targetX:15 targetY:-9 rotation:5*M_PI_4];
            }
            
            
            CGAffineTransform transform = CGAffineTransformMakeScale(0.9, 0.9);
            [tutorialbackground.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                [tutorialbackground setAlpha:1];
                [tutorialbackground setTransform:transform];
                
            } completion:^(BOOL finished) {
                UILabel *tutorialLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, tutorialbackground.frame.size.width-10, tutorialbackground.frame.size.height-10)];
                [tutorialLabel setFont:[UIFont fontWithName:@"Eraser" size:18]];
                [tutorialLabel setTextColor:[UIColor whiteColor]];
                [tutorialLabel setNumberOfLines:0];
                [tutorialLabel setText:@"Lets learn how to buy something for your students"];
                [tutorialbackground addSubview:tutorialLabel];
            }];

        }
        else if ([self.teacherProgress.openStoreDone boolValue] && [self.teacherProgress.buyStoreDone boolValue]){
            [self hideTutorialArrow:YES hideBlackboard:YES];
        }
    
    }
    else{
        if(![self.studentProgress.studentsBuyDone boolValue]){
            [self hideTutorialArrow:YES hideBlackboard:YES];
            
            UIImageView *tutorialbackground = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"blackboardBorder"]];
            [tutorialbackground setUserInteractionEnabled:YES];
            [tutorialbackground setTag:1000];
            [tutorialbackground setAlpha:0];
            [self.view addSubview:tutorialbackground];
            
            if(IS_IPHONE){
                [tutorialbackground setFrame:CGRectMake(10, 100, 240, 150)];
                
                BouncingPencil *pencilArrow = [[BouncingPencil alloc]initWithFrame:CGRectMake(190, 195, 60, 60)];
                [pencilArrow setTag:2000];
                [pencilArrow setUpPencilBounceFrame:pencilArrow.frame targetX:-15 targetY:-9 rotation:-M_PI_4];
                [self.view addSubview:pencilArrow];
            }
            else if (IS_IPAD){
                tutorialbackground.translatesAutoresizingMaskIntoConstraints=NO;
                [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[tutorialbackground(300)]-150-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tutorialbackground)]];
                [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-400-[tutorialbackground(170)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tutorialbackground)]];
                
                //Set bouncing pencil
                BouncingPencil *pencilArrow = [[BouncingPencil alloc]init];
                [pencilArrow setTag:2000];
                [self.view addSubview:pencilArrow];
                
                pencilArrow.translatesAutoresizingMaskIntoConstraints=NO;
                [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-330-[pencilArrow(60)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(pencilArrow)]];
                [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[pencilArrow(60)]-150-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(pencilArrow)]];
                [pencilArrow setUpPencilBounceForiPad:CGSizeMake(60, 60) targetX:15 targetY:-9 rotation:5*M_PI_4];
            }
            
            CGAffineTransform transform = CGAffineTransformMakeScale(0.9, 0.9);
            [tutorialbackground.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                [tutorialbackground setAlpha:1];
                [tutorialbackground setTransform:transform];
                
            } completion:^(BOOL finished) {
                UILabel *tutorialLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, tutorialbackground.frame.size.width-10, tutorialbackground.frame.size.height-10)];
                [tutorialLabel setFont:[UIFont fontWithName:@"Eraser" size:18]];
                [tutorialLabel setTextColor:[UIColor whiteColor]];
                [tutorialLabel setNumberOfLines:0];
                [tutorialLabel setText:@"Let's buy something from your teacher's store with your coins."];
                [tutorialbackground addSubview:tutorialLabel];
            }];

            
            
        }
    }
}

-(void)hideTutorialArrow:(BOOL)hideArrow hideBlackboard:(BOOL)hideBlack{
    
    if(hideArrow){
        BouncingPencil *addClassArrow = (BouncingPencil*)[self.view viewWithTag:2000];
        if (addClassArrow){
            addClassArrow.pencilImage=nil;
            [addClassArrow setTag:0];
            [addClassArrow removeFromSuperview];
        }
    }
    
    if(hideBlack){
        UIImageView *blackboardBorder = (UIImageView*)[self.view viewWithTag:1000];
        [blackboardBorder setTag:0];
        [blackboardBorder removeFromSuperview];
    }
    
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
    
    if (IS_IPHONE) {
        [tutorialbackground setFrame:CGRectMake(0, 240, 320, 180)];
        
        if ([self.userType isEqualToString:@"Teacher"]) {
            BouncingPencil *pencilArrow = [[BouncingPencil alloc]initWithFrame:CGRectMake(220, 44, 60, 60)];
            [pencilArrow setTag:2000];
            [pencilArrow setUpPencilBounceFrame:pencilArrow.frame targetX:15 targetY:-9 rotation:5*M_PI_4];
            [self.closedBackground addSubview:pencilArrow];
        }
        
        [self.closedBackground setFrame:self.view.frame];
        [directionLabel setFrame:CGRectMake(30, 90, 280,100)];
        
    }
    else if (IS_IPAD){
        
        self.closedBackground.translatesAutoresizingMaskIntoConstraints=NO;
        directionLabel.translatesAutoresizingMaskIntoConstraints=NO;
        tutorialbackground.translatesAutoresizingMaskIntoConstraints=NO;
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_closedBackground]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_closedBackground)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_closedBackground]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_closedBackground)]];
        
        [self.closedBackground addConstraint:[NSLayoutConstraint constraintWithItem:directionLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.closedBackground attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        
        [self.closedBackground addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-90-[directionLabel]-100-[tutorialbackground]" options:NSLayoutFormatAlignAllCenterX metrics:nil views:NSDictionaryOfVariableBindings(directionLabel,tutorialbackground)]];
        
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
    }
    
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

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if ([_userType isEqualToString:@"Teacher"]){
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(segueButtonActions)];
        [self.tabBarController.navigationItem setRightBarButtonItem:rightButton];
        
        [self.demoProgressBar setProgress:[self.teacherProgress getTotalProgress] animated:YES];
    }
    else{
        [self.demoProgressBar setProgress:[self.studentProgress getTotalProgress] animated:YES];

    }
    
    [self startBuyTutorial];

    [self itemsFromParse];
}


-(void)itemsFromParse{

    
    if ([self.userType isEqualToString:@"Teacher"]) {

        NSError*error;
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"DemoStoreObject"];
        request.predicate = request.predicate=[NSPredicate predicateWithFormat:@"userType = %@",@"Teacher"];
        NSArray *storeObjArray = [_demoManagedObjectContext executeFetchRequest:request error:&error];
        [self.storeItemsArray removeAllObjects];

        [self.storeItemsArray addObjectsFromArray:storeObjArray];

        [self.storeTable reloadData];


        if ([self.storeItemsArray count] == 0) {
            
            if (self.closedBackground ==nil) {

                [self emptyStoreView];
            }
        }
        else{
            if (self.closedBackground !=nil) {
                [self.closedBackground removeFromSuperview];
                self.closedBackground=nil;
                
                self.teacherProgress.openStoreDone = [NSNumber numberWithBool:YES];
                [_demoManagedObjectContext save:nil];
                
                [self.demoProgressBar setProgress:[self.teacherProgress getTotalProgress] animated:YES];
                
                [self startBuyTutorial];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CONGRATULATIONS!" message:@"You just opened your store!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                
                
                if ((int)[self.teacherProgress getTotalProgress] == 1) {
                    if (IS_IPHONE) {
                        
                        DemoRateAppView *rateApp = [[DemoRateAppView alloc]initWithFrame:CGRectMake(5,70, 310, 320)];
                        [self.view addSubview:rateApp];
                        [rateApp showRatePopUp];
                    }
                    else if (IS_IPAD){
                        DemoRateAppView *rateApp = [[DemoRateAppView alloc]initWithFrame:CGRectMake(0, 0, 450, 320)];
                        [self.view addSubview:rateApp];
                        
                        rateApp.translatesAutoresizingMaskIntoConstraints=NO;
                        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[rateApp(450)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(rateApp)]];
                        
                        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[rateApp(320)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(rateApp)]];
                        
                        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:rateApp attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
                        
                        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:rateApp attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:-50]];
                        [rateApp showRatePopUp];
                    }
                }
                
            }
            
        }
    }
    else{
        
        NSDictionary *storeItem1 = @{@"objectId": @"student1",
                                     @"item":@"Bathroom Pass",
                                     @"userType":@"Student",
                                     @"cost":@3};
        NSDictionary *storeItem2 = @{@"objectId": @"student2",
                                     @"item":@"Snack",
                                     @"userType":@"Student",
                                     @"cost":@2};
        NSDictionary *storeItem3 = @{@"objectId": @"student3",
                                     @"item":@"iPad Time",
                                     @"userType":@"Student",
                                     @"cost":@8};
        NSDictionary *storeItem4 = @{@"objectId": @"student44",
                                     @"item":@"1 Day Late Homework Pass",
                                     @"userType":@"Student",
                                     @"cost":@10};
        NSArray *storeArray = @[storeItem1,storeItem2,storeItem3,storeItem4];
        
        [self.storeItemsArray removeAllObjects];
        
        for (NSDictionary *storeDict in storeArray) {
            DemoStoreObject *storeObject = [DemoStoreObject createStoreObjectInCoreWithDictionary:storeDict inManagedObjectContext:_demoManagedObjectContext];
            [self.storeItemsArray addObject:storeObject];
            
        }
        [_demoManagedObjectContext save:nil];
        
    }
    
    [self.storeTable reloadData];
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
        
        if (IS_IPAD) {
            buyButton.translatesAutoresizingMaskIntoConstraints=NO;
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-7-[buyButton(30)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(buyButton)]];
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[buyButton(74)]-40-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(buyButton)]];
            
        }
        else if (IS_IPHONE){
            buyButton.frame = CGRectMake(238, 7, 74, 30);
            
        }
        
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    DemoStoreObject *storeItem = [self.storeItemsArray objectAtIndex:indexPath.row];
    
    NSNumber *cost = storeItem.cost;
    NSString *costString = [NSString stringWithFormat:@"%@ Coins",cost];
    
    cell.textLabel.text = storeItem.item;
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
        
        DemoStoreObject *storeObj = [self.storeItemsArray objectAtIndex:indexPath.row];
        
        [_demoManagedObjectContext deleteObject:storeObj];
        
        [self.storeItemsArray removeObjectAtIndex:indexPath.row];
        
        [self.storeTable beginUpdates];
        [self.storeTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.storeTable endUpdates];
        
        [_demoManagedObjectContext save:nil];
        
        if ([self.storeItemsArray count] == 0) {
            [self emptyStoreView];
        }
    }
}

//buying action
-(void)buyButtonAction: (UIButton*)sender{
    
    
        UIButton *btn = (UIButton *)sender;
        UITableViewCell *cell = [self parentCellForView:btn];
        
        //buy action
        
        if (cell != nil) {
        
            self.storeObjectToPass = nil;
            NSIndexPath *indexPath = [_storeTable indexPathForCell:cell];
            
            self.storeObjectToPass = [self.storeItemsArray objectAtIndex:indexPath.row];
            
            //Action when button is pressed
            if ([self.userType isEqualToString:@"Teacher"]) {
                
                [self performSegueWithIdentifier:@"demoTeacherBuySegue" sender:self];
            }
            else{
                NSString *actionTitle = [NSString stringWithFormat:@"Are you sure you want to purchase: %@ for %d",self.storeObjectToPass.item,[self.storeObjectToPass.cost intValue]];
                
                UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:actionTitle delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Buy", nil];
                actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
                [actionSheet showInView:self.view];
            }
            
        }

}

//students buy
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	// The user tapped one of the OK/Cancel buttons.
	if (buttonIndex == 0)
	{
        
        if (![self.studentProgress.studentsBuyDone boolValue]) {
            self.studentProgress.studentsBuyDone = [NSNumber numberWithBool:YES];
            [_demoManagedObjectContext save:nil];
            [self hideTutorialArrow:YES hideBlackboard:YES];
            [self.demoProgressBar setProgress:[self.studentProgress getTotalProgress] animated:YES];
            
            if ((int)[self.studentProgress getTotalProgress] == 1) {
                if (IS_IPHONE) {
                    
                    DemoRateAppView *rateApp = [[DemoRateAppView alloc]initWithFrame:CGRectMake(5,70, 310, 320)];
                    [self.view addSubview:rateApp];
                    [rateApp showRatePopUp];
                }
                else if (IS_IPAD){
                    DemoRateAppView *rateApp = [[DemoRateAppView alloc]initWithFrame:CGRectMake(0, 0, 450, 320)];
                    [self.view addSubview:rateApp];
                    
                    rateApp.translatesAutoresizingMaskIntoConstraints=NO;
                    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[rateApp(450)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(rateApp)]];
                    
                    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[rateApp(320)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(rateApp)]];
                    
                    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:rateApp attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
                    
                    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:rateApp attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:-50]];
                    [rateApp showRatePopUp];
                }
            }

        }
        
        
        
        NSNumber *studentCoins = self.studentObj.coins;
        NSInteger studentCoinsInt = [studentCoins intValue];
        
        if (studentCoinsInt<[self.storeObjectToPass.cost intValue]) {
            self.studentObj.coins = [NSNumber numberWithInt:([self.studentObj.coins intValue]+50)];
            
            [self.demoManagedObjectContext save:nil];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oh no! You do not have enough coins to purchase this item" message:@"That's ok, its a demo. I'll give you 50 coins! :)" delegate:self cancelButtonTitle:@"YAY!" otherButtonTitles:nil];
            [alert show];
        }
        else{
            
            self.studentObj.coins = [NSNumber numberWithInt:([self.studentObj.coins intValue]-([self.storeObjectToPass.cost intValue]))];
            
            [self.demoManagedObjectContext save:nil];
            
            NSString *alertMessage = [NSString stringWithFormat:@"You now have %d coins in your account",[self.studentObj.coins intValue]];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat: @"You've just bought: %@!",self.storeObjectToPass.item] message:alertMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
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


-(void)segueButtonActions{
        [self performSegueWithIdentifier:@"demoAddStoreSegue" sender:self];
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"demoTeacherBuySegue"]) {
        // teachers buy
        
        DemoBuyItemsViewController* pickStudentVC = (DemoBuyItemsViewController*)segue.destinationViewController;
        pickStudentVC.managedObjectContext=self.managedObjectContext;
        pickStudentVC.demoManagedObjectContext = self.demoManagedObjectContext;
        pickStudentVC.className = self.className;
        pickStudentVC.storeObject = self.storeObjectToPass;
    }
    else if ([segue.identifier isEqualToString:@"studentBuyBufferSegue"]) {
        //student buy
        
//        StudentBuyBufferViewController *studentBufferVC = (StudentBuyBufferViewController*)segue.destinationViewController;
//        studentBufferVC.studentObj = _studentObj;
//        studentBufferVC.teacherObj = _teacherObj;
        
    }
    else if([segue.identifier isEqualToString:@"demoAddStoreSegue"]){
        
        DemoAddStoreViewController *demoAddStore = (DemoAddStoreViewController*)segue.destinationViewController;
        demoAddStore.demoManagedObjectContext = self.demoManagedObjectContext;
        demoAddStore.managedObjectContext = self.managedObjectContext;
        demoAddStore.userType=self.userType;
    }
    
    
    
}

@end