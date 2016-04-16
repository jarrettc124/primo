//
//  DemoClassViewController.m
//  Primo
//
//  Created by Jarrett Chen on 8/26/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import "DemoClassViewController.h"


@interface DemoClassViewController ()

@property (nonatomic,strong) UITextField *changeNameField;
@property (nonatomic,strong) NSString *selectedClassNameForChangedName;
@property (nonatomic,strong) UIImageView *backgroundView;
@property (nonatomic,strong) NSString *typeOfDay;
@property (nonatomic,strong) UIView *line1;
@property (nonatomic,strong) UIView *line2;

//announcementViewController

//student's parameter
@property (nonatomic,strong) NSMutableArray *classesTableArray;
@property (nonatomic,strong) NSMutableArray *classesTableArrayTeacherObject;
@property (nonatomic,strong) NSMutableArray *classesTableArrayStudentObject;
@property (nonatomic,strong) NSIndexPath *selectedStudentObjectIndexPath;
@property (nonatomic) BOOL isEmpty;

//Teacher's parameters
@property (nonatomic) CGFloat teacherTextPosition;
@property (nonatomic,strong) NSLayoutConstraint* hiddenLabelState;

//renameView

@property (nonatomic,strong) UILabel *directionRename;

@property (nonatomic,strong) DemoTeacher *teachersProgress;
@property (nonatomic,strong) DemoStudent *studentsProgress;

@property (nonatomic,strong) UIButton *checkTutorial;

@property (nonatomic,strong) UIProgressView *demoProgressBar;

@end

@implementation DemoClassViewController

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
    
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //Set background image
    self.backgroundView = [[UIImageView alloc] init];
    self.backgroundView.userInteractionEnabled=YES;
    [self.view addSubview:self.backgroundView];


    CGFloat tHeight = 310;
    
    self.classesTable = [[UITableView alloc]init];
    self.classesTable.allowsMultipleSelectionDuringEditing = NO;
    self.classesTable.allowsSelection=YES;
    self.classesTable.delegate=self;
    self.classesTable.dataSource =self;
    self.classesTable.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.4];
    [self.view addSubview:self.classesTable];
    
    UIView *banner = [[UIView alloc]init];
    [banner setBackgroundColor:[UIColor colorWithRed:0.317647 green:0.647059 blue:0.72941 alpha:1]];
    [self.view addSubview:banner];
    
    //Labels in the UI
    if ([self.userType isEqualToString:@"Teacher"]) {
        
        UIImage *image = [UIImage imageNamed:@"menuIcon"];
        CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
        UIButton* button = [[UIButton alloc] initWithFrame:frame];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        
        //set the button to handle clicks
        [button addTarget:self action:@selector(menuBarAction) forControlEvents:UIControlEventTouchUpInside];
        
        //finally, create your UIBarButtonItem using that button
        self.menuButton = [[UIBarButtonItem alloc] initWithCustomView:button];

        //set button after everything is set
        self.navigationItem.rightBarButtonItem=self.menuButton;
        
        
        //add the lines
        self.line1 = [[UIView alloc]init];
        [self.backgroundView addSubview:_line1];
        
        self.line2 = [[UIView alloc]init];
        [self.backgroundView addSubview:_line2];
        
        //labels
        self.totalCoinsLabel = [[UILabel alloc] init];
        self.totalCoinsLabel.backgroundColor = [UIColor clearColor];
        self.totalCoinsLabel.numberOfLines=0;
        self.totalCoinsLabel.text = [NSString stringWithFormat:@"Total\nCoins"];
        self.totalCoinsLabel.textAlignment = NSTextAlignmentCenter;
        [self.backgroundView addSubview:self.totalCoinsLabel];
        
        self.totalStudentsLabel = [[UILabel alloc] init];
        self.totalStudentsLabel.backgroundColor = [UIColor clearColor];
        self.totalStudentsLabel.numberOfLines=0;
        self.totalStudentsLabel.text = [NSString stringWithFormat:@"Total\nStudents"];
        self.totalStudentsLabel.textAlignment = NSTextAlignmentCenter;
        [self.backgroundView addSubview:self.totalStudentsLabel];
        
        self.totalSignedUp = [[UILabel alloc] init];
        self.totalSignedUp.backgroundColor = [UIColor clearColor];
        self.totalSignedUp.numberOfLines=0;
        self.totalSignedUp.text = [NSString stringWithFormat:@"Students\nSigned Up"];
        self.totalSignedUp.textAlignment = NSTextAlignmentCenter;
        [self.backgroundView addSubview:self.totalSignedUp];
        
        //Student's info animate
        self.totalCoins = [[UILabel alloc]init];
        self.totalCoins.backgroundColor=[UIColor clearColor];
        self.totalCoins.alpha=0;
        self.totalCoins.minimumScaleFactor=0.5;
        self.totalCoins.adjustsFontSizeToFitWidth=YES;
        self.totalCoins.textAlignment = NSTextAlignmentCenter;
        [self.backgroundView addSubview:self.totalCoins];
        
        self.totalStudents = [[UILabel alloc]init];
        self.totalStudents.backgroundColor=[UIColor clearColor];
        self.totalStudents.alpha=0;
        self.totalStudents.minimumScaleFactor=0.5;
        self.totalStudents.adjustsFontSizeToFitWidth=YES;
        self.totalStudents.textAlignment = NSTextAlignmentCenter;
        [self.backgroundView addSubview:self.totalStudents];
        
        self.totalSigned = [[UILabel alloc]init];
        self.totalSigned.backgroundColor=[UIColor clearColor];
        self.totalSigned.alpha=0;
        self.totalSigned.minimumScaleFactor=0.5;
        self.totalSigned.adjustsFontSizeToFitWidth=YES;
        self.totalSigned.textAlignment = NSTextAlignmentCenter;
        [self.backgroundView addSubview:self.totalSigned];
        
        [self displayBackground];
        
    }
    else{
        
        //student view
        self.studentAddClassButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addMoreClass)];
        
        //Get info from core data for student
        self.totalStudentCoins = [[UILabel alloc]init];
        self.totalStudentCoins.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:95];
        self.totalStudentCoins.alpha=0;
        self.totalStudentCoins.minimumScaleFactor=0.5;
        self.totalStudentCoins.adjustsFontSizeToFitWidth=YES;
        self.totalStudentCoins.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:self.totalStudentCoins];
        
        self.totalStudentCoinsLabel = [[UILabel alloc] init];
        self.totalStudentCoinsLabel.backgroundColor = [UIColor clearColor];
        self.totalStudentCoinsLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:19];
        self.totalStudentCoinsLabel.numberOfLines=0;
        self.totalStudentCoinsLabel.text = [NSString stringWithFormat:@"Total\nCoins"];
        self.totalStudentCoinsLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:self.totalStudentCoinsLabel];
        
        
        [self displayBackground];
        
    }
    
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.backgroundView addGestureRecognizer:gestureRecognizer];
    
    
    //Add frames
    if (IS_IPAD) {
        self.backgroundView.translatesAutoresizingMaskIntoConstraints=NO;
        self.classesTable.translatesAutoresizingMaskIntoConstraints=NO;
        banner.translatesAutoresizingMaskIntoConstraints=NO;
        
        //horizontal
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_backgroundView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_backgroundView)]];

        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_classesTable]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_classesTable)]];
        
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[banner]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(banner)]];
        
        
        //vertical
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_backgroundView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_backgroundView)]];

        
        
        
        //information labels
        if ([self.userType isEqualToString:@"Teacher"]) {
            
            self.totalCoins.translatesAutoresizingMaskIntoConstraints=NO;
            self.totalStudents.translatesAutoresizingMaskIntoConstraints=NO;
            self.totalSigned.translatesAutoresizingMaskIntoConstraints=NO;
            
            self.totalCoinsLabel.translatesAutoresizingMaskIntoConstraints=NO;
            self.totalStudentsLabel.translatesAutoresizingMaskIntoConstraints=NO;
            self.totalSignedUp.translatesAutoresizingMaskIntoConstraints=NO;
            
            self.line1.translatesAutoresizingMaskIntoConstraints=NO;
            self.line2.translatesAutoresizingMaskIntoConstraints=NO;
            
            //Horizontal

            
            //Numbers labels
            self.hiddenLabelState =[NSLayoutConstraint constraintWithItem:_totalCoins attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_totalCoinsLabel attribute:NSLayoutAttributeTop multiplier:1 constant:-20];
            
            [self.view addConstraint:self.hiddenLabelState];
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_totalCoins(==_totalStudents)]-2-[_totalStudents(==_totalSigned)]-2-[_totalSigned]-0-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(_totalCoins,_totalStudents,_totalSigned)]];
            
            //Text Lables
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_totalCoinsLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:-10]];
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_totalCoinsLabel(==_totalStudentsLabel)]-2-[_totalStudentsLabel(==_totalSignedUp)]-2-[_totalSignedUp]-0-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(_totalCoinsLabel,_totalStudentsLabel,_totalSignedUp)]];
            
            //lines
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_totalCoinsLabel]-0-[_line1(2)]-0-[_totalStudentsLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_totalCoinsLabel,_line1,_totalStudentsLabel)]];
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_line1(50)]-90-[banner]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_line1,banner)]];
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_totalStudentsLabel]-0-[_line2(2)]-0-[_totalSignedUp]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_totalStudentsLabel,_line2,_totalSignedUp)]];
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_line2(50)]-90-[banner]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_line2,banner)]];
            
            //Vertical

            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_totalStudentsLabel]-50-[banner(6)]-0-[_classesTable]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_totalStudentsLabel,banner,_classesTable)]];
            
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_line1(50)]-90-[banner]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_line1,banner)]];
            
            
            //fonts
            self.totalCoinsLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:25];
            [self.totalCoins setAlpha:1];
            self.totalStudentsLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:25];
            self.totalSignedUp.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:25];
            self.totalCoins.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:88];
            self.totalStudents.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:88];
            self.totalSigned.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:88];
            
        }
        else {
            //student ipad
            UIImage *bannerImage = [UIImage imageNamed:@"MonthBanner"];
            UIImageView *bannerView = [[UIImageView alloc]init];
            [bannerView setTag:100];
            [bannerView setImage:bannerImage];
            bannerView.contentMode=UIViewContentModeScaleAspectFill;
            bannerView.userInteractionEnabled=YES;
            [self.view addSubview:bannerView];
            bannerView.translatesAutoresizingMaskIntoConstraints=NO;
            
            _isEmpty=NO;
            
            self.totalStudentCoins.translatesAutoresizingMaskIntoConstraints=NO;
            self.totalStudentCoinsLabel.translatesAutoresizingMaskIntoConstraints=NO;
            
            self.hiddenLabelState = [NSLayoutConstraint constraintWithItem:_totalStudentCoins attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:bannerView attribute:NSLayoutAttributeTop multiplier:1 constant:-20];
            
            [self.view addConstraint:self.hiddenLabelState];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_totalStudentCoins attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-100-[_totalStudentCoins]-100-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_totalStudentCoins)]];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:bannerView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
            
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_totalStudentCoinsLabel(83)]-108-[banner(6)]" options:NSLayoutFormatAlignAllCenterX metrics:nil views:NSDictionaryOfVariableBindings(_totalStudentCoinsLabel,banner)]];
            
            
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-300-[bannerView(108)]-96-[banner(6)]-0-[_classesTable]-0-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:NSDictionaryOfVariableBindings(bannerView,banner,_classesTable)]];
            
            
            //font
            self.totalStudentCoins.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:140];
            
        }
    }
    else if (IS_IPHONE){
        
        [self.backgroundView setFrame:self.view.frame];
        
        [self.classesTable setFrame:CGRectMake(self.view.frame.origin.x, tHeight, self.view.frame.size.width, self.view.frame.size.height-tHeight)];
        [banner setFrame:CGRectMake(self.view.frame.origin.x,tHeight-4, self.view.frame.size.width, 4)];
        
        //Set frame for loading views

        if ([_userType isEqualToString:@"Teacher"]) {
            
            //labels right here
            self.teacherTextPosition=280;
            [self.line1 setFrame:CGRectMake((self.backgroundView.frame.size.width/3)-0.5, self.teacherTextPosition-70, 1, 25)];
            [self.line2 setFrame:CGRectMake((self.backgroundView.frame.size.width*2/3)-0.5, self.teacherTextPosition-70, 1, 25)];
            
            [self.totalCoinsLabel setFrame:CGRectMake((self.backgroundView.frame.size.width/6)-(self.backgroundView.frame.size.width/6),self.teacherTextPosition-50,(self.backgroundView.frame.size.width/3), 40)];
            [self.totalStudentsLabel setFrame:CGRectMake((self.backgroundView.frame.size.width/2)-(self.backgroundView.frame.size.width/3)/2,self.teacherTextPosition-50 ,(self.backgroundView.frame.size.width/3), 40)];
            [self.totalSignedUp setFrame:CGRectMake((self.backgroundView.frame.size.width*2/3),self.teacherTextPosition-50,(self.backgroundView.frame.size.width/3), 40)];
            
            [self.totalCoins setFrame:CGRectMake((self.backgroundView.frame.size.width/6)-(self.backgroundView.frame.size.width/6)+10,self.totalCoinsLabel.frame.origin.y-75,(self.backgroundView.frame.size.width/3)-20, 55)];
            [self.totalStudents setFrame:CGRectMake((self.backgroundView.frame.size.width/2)-(self.backgroundView.frame.size.width/3)/2+10,self.totalCoinsLabel.frame.origin.y-75,(self.backgroundView.frame.size.width/3)-20, 55)];
            [self.totalSigned setFrame:CGRectMake((self.backgroundView.frame.size.width*2/3)+10,self.totalCoinsLabel.frame.origin.y-75,(self.backgroundView.frame.size.width/3)-20, 55)];
            
            self.totalCoinsLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
            self.totalStudentsLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
            self.totalSignedUp.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
            self.totalCoins.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:53];
            self.totalStudents.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:53];
            self.totalSigned.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:53];
            
        }
        else {
            //students iphone
            
            [self.totalStudentCoins setFrame:CGRectMake((self.view.frame.size.width/2)-80,65, 160, 80)];
            [self.totalStudentCoinsLabel setFrame:CGRectMake((self.view.frame.size.width/2)-75,self.totalStudentCoins.frame.origin.y+self.totalStudentCoins.frame.size.height+24, 150,60)];
            
            UIImage *bannerImage = [UIImage imageNamed:@"MonthBanner"];
            UIImageView *bannerView = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width/2)-bannerImage.size.width/2,self.totalStudentCoinsLabel.frame.origin.y-8, bannerImage.size.width, bannerImage.size.height)];
            [bannerView setTag:100];
            [bannerView setImage:bannerImage];
            bannerView.userInteractionEnabled=YES;
            [self.view addSubview:bannerView];
            
        }
        
    }
    
    
    //Tutorial
    self.demoProgressBar= [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    [self.view addSubview:self.demoProgressBar];
    self.demoProgressBar.translatesAutoresizingMaskIntoConstraints=NO;
    
    self.checkTutorial = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.checkTutorial setTitle:[NSString stringWithFormat:@"Click Here! Demo: %0.2f%%",([self.teachersProgress getTotalProgress]*100)] forState:UIControlStateNormal];
    [self.checkTutorial.titleLabel setTextColor:[UIColor whiteColor]];
    [self.checkTutorial setShowsTouchWhenHighlighted:YES];
    [self.checkTutorial addTarget:self action:@selector(showDemoChart) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.checkTutorial];

    if(IS_IPHONE){
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_demoProgressBar]-20-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_demoProgressBar)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-273-[_demoProgressBar(25)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_demoProgressBar)]];
        [self.checkTutorial setFrame:CGRectMake(0, tHeight-50, self.view.frame.size.width, 50)];
        

    }
    else if (IS_IPAD) {
        _demoProgressBar.translatesAutoresizingMaskIntoConstraints=NO;
        _checkTutorial.translatesAutoresizingMaskIntoConstraints=NO;
        _classesTable.translatesAutoresizingMaskIntoConstraints=NO;
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_demoProgressBar attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_checkTutorial attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        
        [_demoProgressBar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_demoProgressBar(350)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_demoProgressBar)]];
        [_checkTutorial addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_checkTutorial(350)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_checkTutorial)]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_demoProgressBar(25)]-15-[_classesTable]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_demoProgressBar,_classesTable)]];
        
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_checkTutorial(25)]-15-[_classesTable]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_checkTutorial,_classesTable)]];
        
        
    }
    
    [self createDemoClass];
    
}

//demo Method
-(void)showDemoChart{
    UIImage *image = [UIImage imageNamed:@"cancelIcon"];
    CGRect frame = CGRectMake(0, 0, image.size.width-10, image.size.height-10);
    UIButton* button = [[UIButton alloc] initWithFrame:frame];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(hideDemoChart) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* demoCancel = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    [self.navigationItem setRightBarButtonItem:demoCancel];
    
    CGRect listFrame;
        listFrame = CGRectMake(20,self.view.frame.size.height,280,350);
    
    
    UIImageView *progressChart = nil;
    if([self.userType isEqualToString:@"Teacher"]){

        progressChart = [self.teachersProgress demoProgressTotalFrame:listFrame];
    }
    else{
        progressChart = [self.studentsProgress demoProgressTotalFrame:listFrame];
    }
    
    
    //get clear button
    UIButton *clearDemoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [clearDemoButton setFrame:CGRectMake(10, 20+progressChart.frame.size.height-80+8, progressChart.frame.size.width-20, 35)];
    [clearDemoButton setTitle:@"Click here to start demo over" forState:UIControlStateNormal];
    [clearDemoButton setTitleColor:[UIColor colorWithRed:0.435294 green:0.90588 blue:0.8588 alpha:1] forState:UIControlStateNormal];
    [clearDemoButton addTarget:self action:@selector(clearDemoAction) forControlEvents:UIControlEventTouchUpInside];
    [clearDemoButton.titleLabel setNumberOfLines:0];
    [clearDemoButton.titleLabel setFont:[UIFont fontWithName:@"Eraser" size:18]];
    [progressChart addSubview:clearDemoButton];
    
    [progressChart setUserInteractionEnabled:YES];
    [progressChart setTag:5000];
    [self.view addSubview:progressChart];
    
    if (IS_IPAD) {
        progressChart.translatesAutoresizingMaskIntoConstraints=NO;
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:progressChart attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:progressChart attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[progressChart(280)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(progressChart)]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[progressChart(350)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(progressChart)]];
        
        progressChart.alpha=0;
        [UIView animateWithDuration:0.3 delay:0 options:0 animations:^{
            progressChart.alpha=1;
            progressChart.transform = CGAffineTransformMakeScale(0.9, 0.9);
        } completion:nil];
    }
    else{
        [UIView animateWithDuration:0.3 delay:0 options:0 animations:^{
            progressChart.center = self.view.center;
        } completion:nil];
    }
}

//clear demo Action
-(void)clearDemoAction{

    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Are you sure you want to clear your demo?" message:@"You'll have to start over!" delegate:self cancelButtonTitle:@"No, Go back!" otherButtonTitles:@"Yes, Start Over", nil];
    [alert show];

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //0 is cancel
    //1 is clear
    if (buttonIndex == 1) {
        
            //delete broadcast
            NSError*error;
            NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"DemoBroadcast"];
            NSArray *broadcastObjArray = [_demoManagedObjectContext executeFetchRequest:request error:&error];
            for (DemoBroadcast *broadcast in broadcastObjArray) {
                [_demoManagedObjectContext deleteObject:broadcast];
            }
            
            NSFetchRequest *econRequest = [NSFetchRequest fetchRequestWithEntityName:@"DemoEconomy"];
            NSArray *econObjArray = [_demoManagedObjectContext executeFetchRequest:econRequest error:&error];
            for (DemoEconomy *econ in econObjArray) {
                [_demoManagedObjectContext deleteObject:econ];
            }
        
            NSFetchRequest *storeRequest = [NSFetchRequest fetchRequestWithEntityName:@"DemoStoreObject"];
            NSArray *storeObjArray = [_demoManagedObjectContext executeFetchRequest:storeRequest error:&error];
            for (DemoStoreObject *store in storeObjArray) {
                [_demoManagedObjectContext deleteObject:store];
            }
        
        NSFetchRequest *studentRequest = [NSFetchRequest fetchRequestWithEntityName:@"DemoStudentObject"];
        NSArray *studentObjArray = [_demoManagedObjectContext executeFetchRequest:studentRequest error:&error];
        for (DemoStudentObject *studentObj in studentObjArray) {
            [_demoManagedObjectContext deleteObject:studentObj];
        }
        
        NSFetchRequest *teacherRequest = [NSFetchRequest fetchRequestWithEntityName:@"DemoTeacherObject"];
        NSArray *teacherObjArray = [_demoManagedObjectContext executeFetchRequest:teacherRequest error:&error];
        for (DemoStudentObject *teacherObj in teacherObjArray) {
            [_demoManagedObjectContext deleteObject:teacherObj];
        }
        
        NSFetchRequest *teacherDemoRequest = [NSFetchRequest fetchRequestWithEntityName:@"DemoTeacher"];
        NSArray *teacherDemoArray = [_demoManagedObjectContext executeFetchRequest:teacherDemoRequest error:&error];
        for (DemoTeacher *teacherDemo in teacherDemoArray) {
            [_demoManagedObjectContext deleteObject:teacherDemo];
        }
        NSFetchRequest *studentDemoRequest = [NSFetchRequest fetchRequestWithEntityName:@"DemoStudent"];
        NSArray *studentDemoArray = [_demoManagedObjectContext executeFetchRequest:studentDemoRequest error:&error];
        for (DemoStudent *studentDemo in studentDemoArray) {
            [_demoManagedObjectContext deleteObject:studentDemo];
        }

        [_demoManagedObjectContext save:nil];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}


-(void)hideDemoChart{
    
    if([self.userType isEqualToString:@"Teacher"]){
        [self.navigationItem setRightBarButtonItem:self.menuButton];
    }
    else{
        [self.navigationItem setRightBarButtonItem:self.studentAddClassButton];
    }
    UIImageView *progressChart = (UIImageView*)[self.view viewWithTag:5000];
    [UIView animateWithDuration:0.2 delay:0 options:0 animations:^{
        [progressChart setAlpha:0];
        [progressChart setTransform:CGAffineTransformMakeScale(0.8, 0.8)];

    } completion:^(BOOL finished) {
        [progressChart removeFromSuperview];
    }];
}

-(void)createDemoClass{
    if ([self.userType isEqualToString:@"Teacher"]){
        
        //create demo students
        NSDictionary *bobbyForeman = @{@"coins": @5,
                                       @"nameOfclass":@"tutorial",
                                       @"signedIn":@1,
                                       @"studentName":@"Bobby Foreman",
                                       @"studentNumber":@1,
                                       @"objectId":@"1",
                                       @"taken":@"Teacher"};
        
        //create demo students
        NSDictionary *meowMixSmith = @{@"coins": @5,
                                       @"nameOfclass":@"tutorial",
                                       @"signedIn":@0,
                                       @"studentName":@"Meow Mix Smith",
                                       @"studentNumber":@1,
                                       @"objectId":@"2",
                                       @"taken":@"Teacher"};
        //create demo students
        NSDictionary *joshua = @{@"coins": @5,
                                       @"nameOfclass":@"tutorial",
                                       @"signedIn":@0,
                                       @"studentName":@"Joshua",
                                       @"studentNumber":@1,
                                       @"objectId":@"3",
                                       @"taken":@"Teacher"};
        //create demo students
        NSDictionary *homerS = @{@"coins": @5,
                                       @"nameOfclass":@"tutorial",
                                       @"signedIn":@1,
                                       @"studentName":@"Homer S",
                                       @"studentNumber":@1,
                                       @"objectId":@"4",
                                       @"taken":@"Teacher"};
        //create demo students
        NSDictionary *serena = @{@"coins": @5,
                                       @"nameOfclass":@"tutorial",
                                       @"signedIn":@1,
                                       @"studentName":@"Serena",
                                       @"studentNumber":@1,
                                       @"objectId":@"5",
                                       @"taken":@"Teacher"};
        //create demo students
        NSDictionary *arnoldTran = @{@"coins": @5,
                                       @"nameOfclass":@"tutorial",
                                       @"signedIn":@0,
                                       @"studentName":@"Arnold Tran",
                                       @"studentNumber":@1,
                                       @"objectId":@"6",
                                       @"taken":@"Teacher"};
        //create demo students
        NSDictionary *scooby = @{@"coins": @5,
                                       @"nameOfclass":@"tutorial",
                                       @"signedIn":@0,
                                       @"studentName":@"Scooby",
                                       @"studentNumber":@1,
                                       @"objectId":@"7",
                                       @"taken":@"Teacher"};
        //create demo students
        NSDictionary *barney = @{@"coins": @5,
                                       @"nameOfclass":@"tutorial",
                                       @"signedIn":@0,
                                       @"studentName":@"Barney",
                                       @"studentNumber":@1,
                                       @"objectId":@"8",
                                       @"taken":@"Teacher"};
        
        
        
        NSMutableArray *studentArray = [[NSMutableArray alloc]initWithObjects:bobbyForeman,meowMixSmith,joshua,homerS,serena,arnoldTran,scooby,barney, nil];
        
        for (NSDictionary *demoStudentObj in studentArray) {
            
        
                    [DemoStudentObject createStudentObjectInCoreWithDictionary:demoStudentObj inManagedObjectContext:_demoManagedObjectContext];

                    [_demoManagedObjectContext save:nil];
        }
        
        NSError *error;
        NSData *jsonDataArray = [NSJSONSerialization dataWithJSONObject:@[@"Tutorial"] options:0 error:&error];
        NSString *JSONStringArray = [[NSString alloc] initWithData:jsonDataArray encoding:NSUTF8StringEncoding];
        
        //create demo teacher
        NSDictionary *teacherDict = @{@"classList":JSONStringArray,
                                       @"objectId":@"1"};
        
        [DemoTeacherObject findTeacherObjectInCoreWithDictionary:teacherDict inManagedObjectContext:_demoManagedObjectContext];
        
        
        
        
        [_demoManagedObjectContext save:nil];

    }
    else{ //if student
        
        NSDictionary *jack = @{@"coins": @50,
                                 @"nameOfclass":@"tutorial",
                                 @"signedIn":@0,
                                 @"studentName":@"Jack",
                                 @"studentNumber":@"1",
                                 @"objectId":@"demostudent1",
                                 @"taken":@"Student",
                                 @"teacher":@"Mr. Simpson"};
        
        
        [DemoStudentObject createStudentObjectInCoreWithDictionary:jack inManagedObjectContext:_demoManagedObjectContext];
        //Show data from Database first
        
        [_demoManagedObjectContext save:nil];

    }
    
    [self studentInfo];
    [self startTutorialDemo];
}


-(void)hideKeyboard{
    [self.view endEditing:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //Notification
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuSelection) name:@"menuButtonAction" object:nil];
    
    if ([self.userType isEqualToString:@"Teacher"]) {
        
        //Show data from Database first
        NSError *error;
        NSFetchRequest *studentsRequest = [NSFetchRequest fetchRequestWithEntityName:@"DemoStudentObject"];
        studentsRequest.predicate = [NSPredicate predicateWithFormat:@"taken = %@",@"Teacher"];
        
        NSArray *studentObjArray = [_demoManagedObjectContext executeFetchRequest:studentsRequest error:&error];
        
        if (!error) {
            int totalIntCoins=0;
            int totalIntStudents = (int)[studentObjArray count];
            for (DemoStudentObject *studentObject in studentObjArray){
                
                totalIntCoins+=[studentObject.coins intValue];
                
            }
            
            self.totalCoins.text = [NSString stringWithFormat:@"%d",totalIntCoins];
            self.totalStudents.text = [NSString stringWithFormat:@"%d",totalIntStudents];
            self.totalSigned.text = [NSString stringWithFormat:@"%d",3];
            
            [self classesListFromParse];
            [self.classesTable reloadData];
        }
    }
    else{
            //Show data from Database first
            NSError *error;
            NSFetchRequest *studentsRequest = [NSFetchRequest fetchRequestWithEntityName:@"DemoStudentObject"];
            studentsRequest.predicate= [NSPredicate predicateWithFormat:@"taken = %@",@"Student"];
            NSArray *studentObjArray = [_demoManagedObjectContext executeFetchRequest:studentsRequest error:&error];
            
            NSLog(@"%d",[studentObjArray count]);
            
            if (!error) {
                
                int totalIntCoins = 0;
                
                for (DemoStudentObject *studentObj in studentObjArray){
                    
                    totalIntCoins+=[studentObj.coins intValue];
                    
                    
                }
                
                self.totalStudentCoins.text = [NSString stringWithFormat:@"%d",totalIntCoins];

            }
        self.navigationItem.rightBarButtonItem= self.studentAddClassButton;
        [self classesListFromParse];
        [self.classesTable reloadData];
    }
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if ([self.teachersProgress.addClassDone boolValue]) {
        [self removeBouncingPencil];
        UIImageView *tutorialBlackboard = (UIImageView*)[self.view viewWithTag:1000];
        [tutorialBlackboard removeFromSuperview];
    }
    
    if([self.userType isEqualToString:@"Teacher"]){
        [self.demoProgressBar setProgress:[self.teachersProgress getTotalProgress] animated:YES];
        [self.checkTutorial setTitle:[NSString stringWithFormat:@"Click Here! Demo: %0.2f%%",([self.teachersProgress getTotalProgress]*100)] forState:UIControlStateNormal];
    }
    else{
        [self.demoProgressBar setProgress:[self.studentsProgress getTotalProgress] animated:YES];
        [self.checkTutorial setTitle:[NSString stringWithFormat:@"Click Here! Demo: %0.2f%%",([self.studentsProgress getTotalProgress]*100)] forState:UIControlStateNormal];
    }
}


-(void)startTutorialDemo{

    if ([self.userType isEqualToString:@"Teacher"]) {
        self.teachersProgress = [DemoTeacher findTeacherProgress:_demoManagedObjectContext];

        [self.demoProgressBar setProgress:[self.teachersProgress getTotalProgress] animated:YES];
        
        
        if (![self.teachersProgress.addClassDone boolValue]) {
        
            
            UIImageView *tutorialbackground = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"blackboardBorder"]];
            [tutorialbackground setTag:1000];
            [tutorialbackground setAlpha:0];
            [self.view addSubview:tutorialbackground];

            if(IS_IPHONE){
                [tutorialbackground setFrame:CGRectMake(40, 90, 280, 170)];
                BouncingPencil *pencilArrow = [[BouncingPencil alloc]initWithFrame:CGRectMake(self.view.frame.size.width-100, 44, 60, 60)];
                [pencilArrow setTag:2000];
                [pencilArrow setUpPencilBounceFrame:pencilArrow.frame targetX:15 targetY:-9 rotation:5*M_PI_4];
                [self.view addSubview:pencilArrow];
            }
            else if (IS_IPAD){
                tutorialbackground.translatesAutoresizingMaskIntoConstraints=NO;
                [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[tutorialbackground(280)]-100-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tutorialbackground)]];
                [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-100-[tutorialbackground(170)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tutorialbackground)]];
                
                //Set bouncing pencil
                BouncingPencil *pencilArrow = [[BouncingPencil alloc]init];
                [pencilArrow setTag:2000];
                [self.view addSubview:pencilArrow];
                
                pencilArrow.translatesAutoresizingMaskIntoConstraints=NO;
                [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-45-[pencilArrow(60)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(pencilArrow)]];
                [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[pencilArrow(60)]-50-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(pencilArrow)]];
                [pencilArrow setUpPencilBounceForiPad:CGSizeMake(60, 60) targetX:15 targetY:-9 rotation:5*M_PI_4];
            }

            
            CGAffineTransform transform = CGAffineTransformMakeScale(0.9, 0.9);
            [tutorialbackground.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                [tutorialbackground setAlpha:1];
                [tutorialbackground setTransform:transform];
                
            } completion:^(BOOL finished) {

                UILabel *tutorialLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, tutorialbackground.frame.size.width-40, tutorialbackground.frame.size.height-10)];
                [tutorialLabel setFont:[UIFont fontWithName:@"Eraser" size:18]];
                [tutorialLabel setTextColor:[UIColor whiteColor]];
                [tutorialLabel setNumberOfLines:0];
                [tutorialLabel setText:@"Let's begin by adding a new class.\n\nClick on your menu!"];
                [tutorialbackground addSubview:tutorialLabel];
            
            }];
        }
    }
    else{
        self.studentsProgress = [DemoStudent findStudentProgress:_demoManagedObjectContext];
        
        [self.demoProgressBar setProgress:[self.studentsProgress getTotalProgress] animated:YES];
        
        if (![self.studentsProgress.addClassDone boolValue]) {
            
            UIImageView *tutorialbackground = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"blackboardBorder"]];
            [tutorialbackground setTag:1000];
            [tutorialbackground setAlpha:0];
            [self.view addSubview:tutorialbackground];
            
            if(IS_IPHONE){
                [tutorialbackground setFrame:CGRectMake(40, 90, 280, 170)];
                BouncingPencil *pencilArrow = [[BouncingPencil alloc]initWithFrame:CGRectMake(220, 44, 60, 60)];
                [pencilArrow setTag:2000];
                [pencilArrow setUpPencilBounceFrame:pencilArrow.frame targetX:15 targetY:-9 rotation:5*M_PI_4];
                [self.view addSubview:pencilArrow];
            }
            else if(IS_IPAD){
                tutorialbackground.translatesAutoresizingMaskIntoConstraints=NO;
                [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[tutorialbackground(280)]-100-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tutorialbackground)]];
                [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-100-[tutorialbackground(170)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tutorialbackground)]];
                
                
                //Set bouncing pencil
                BouncingPencil *pencilArrow = [[BouncingPencil alloc]init];
                [pencilArrow setTag:2000];
                [self.view addSubview:pencilArrow];
                
                pencilArrow.translatesAutoresizingMaskIntoConstraints=NO;
                [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-45-[pencilArrow(60)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(pencilArrow)]];
                [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[pencilArrow(60)]-50-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(pencilArrow)]];
                [pencilArrow setUpPencilBounceForiPad:CGSizeMake(60, 60) targetX:15 targetY:-9 rotation:5*M_PI_4];
                
            }
            
            
            CGAffineTransform transform = CGAffineTransformMakeScale(0.9, 0.9);
            [tutorialbackground.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                [tutorialbackground setAlpha:1];
                [tutorialbackground setTransform:transform];
                
            } completion:^(BOOL finished) {
                UILabel *tutorialLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, tutorialbackground.frame.size.width-40, tutorialbackground.frame.size.height-10)];
                [tutorialLabel setFont:[UIFont fontWithName:@"Eraser" size:18]];
                [tutorialLabel setTextColor:[UIColor whiteColor]];
                [tutorialLabel setNumberOfLines:0];
                [tutorialLabel setText:@"Let's begin by joining your teacher's class!"];
                [tutorialbackground addSubview:tutorialLabel];
                
            }];
        }
        
    }
}

-(void)removeBouncingPencil{
    BouncingPencil *addClassArrow = (BouncingPencil*)[self.view viewWithTag:2000];
    if (addClassArrow){
        addClassArrow.pencilImage=nil;
        [addClassArrow setTag:0];
        [addClassArrow removeFromSuperview];
    }
}


-(void)displayBackground{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSHourCalendarUnit;
    NSDateComponents* dateComponents = [calendar components:unitFlags fromDate:[NSDate date]];
    int hour = (int)[dateComponents hour];
    
    if ([self.userType isEqualToString:@"Teacher"]) {
        if ((hour>=0 && hour<=6) || (hour>=18 && hour<=24)) {
            [self.backgroundView setImage:[UIImage imageNamed:@"nightBackground"]];
            self.typeOfDay = @"Evening";
            
            self.totalStudentsLabel.textColor = [UIColor whiteColor];
            self.totalCoinsLabel.textColor = [UIColor whiteColor];
            self.totalSignedUp.textColor = [UIColor whiteColor];
            
            [self.line1 setBackgroundColor:[UIColor whiteColor]];
            [self.line2 setBackgroundColor:[UIColor whiteColor]];
            
            self.totalCoins.textColor = [UIColor whiteColor];
            self.totalStudents.textColor = [UIColor whiteColor];
            self.totalSigned.textColor = [UIColor whiteColor];
            
        }
        else if (hour>=7 && hour<=11){
            //morning
            
            [self.backgroundView setImage:[UIImage imageNamed:@"blackboardBackground"]];
            self.typeOfDay = @"Morning";
            self.totalStudentsLabel.textColor = [UIColor whiteColor];
            self.totalCoinsLabel.textColor = [UIColor whiteColor];
            self.totalSignedUp.textColor = [UIColor whiteColor];
            
            [self.line1 setBackgroundColor:[UIColor whiteColor]];
            [self.line2 setBackgroundColor:[UIColor whiteColor]];
            
            self.totalCoins.textColor = [UIColor whiteColor];
            self.totalStudents.textColor = [UIColor whiteColor];
            self.totalSigned.textColor = [UIColor whiteColor];
        }
        else if (hour>=12 && hour<=17){
            //daytime
            [self.backgroundView setImage:[UIImage imageNamed:@"dayBackground"]];
            self.typeOfDay = @"Afternoon";
            self.totalStudentsLabel.textColor = [UIColor blackColor];
            self.totalCoinsLabel.textColor = [UIColor blackColor];
            self.totalSignedUp.textColor = [UIColor blackColor];
            [self.line1 setBackgroundColor:[UIColor blackColor]];
            [self.line2 setBackgroundColor:[UIColor blackColor]];
            
            self.totalCoins.textColor = [UIColor blackColor];
            self.totalStudents.textColor = [UIColor blackColor];
            self.totalSigned.textColor = [UIColor blackColor];
        }
        else{
            //error
            NSLog(@"Background Error");
        }
    }
    
    else{
        
        if ((hour>=0 && hour<=6) || (hour>=18 && hour<=24)) {
            [self.backgroundView setImage:[UIImage imageNamed:@"nightBackground"]];
            self.typeOfDay = @"Evening";
            self.totalStudentCoinsLabel.textColor = [UIColor whiteColor];
            self.totalStudentCoins.textColor = [UIColor whiteColor];
        }
        else if (hour>=7 && hour<=11){
            //morning
            [self.backgroundView setImage:[UIImage imageNamed:@"blackboardBackground"]];
            self.typeOfDay = @"Morning";
            self.totalStudentCoinsLabel.textColor = [UIColor whiteColor];
            self.totalStudentCoins.textColor = [UIColor whiteColor];
        }
        else if (hour>=12 && hour<=17){
            //daytime
            [self.backgroundView setImage:[UIImage imageNamed:@"dayBackground"]];
            self.typeOfDay = @"Afternoon";
            self.totalStudentCoinsLabel.textColor = [UIColor blackColor];
            self.totalStudentCoins.textColor = [UIColor blackColor];
        }
        else{
            //error
            NSLog(@"Background Error");
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"menuButtonAction" object:nil];

}



//table code
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.classesTableArray count];
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //selectedCell is nill first
    NSString *selectedCell = nil;
    selectedCell = [self.classesTableArray objectAtIndex:indexPath.row];
    
    if ([self.changeNameField isDescendantOfView:self.menuClassView]) { //change name
        
        if ([self.selectedClassNameForChangedName isEqualToString:selectedCell]) {
            [self.classesTable deselectRowAtIndexPath:indexPath animated:YES];
            self.selectedClassNameForChangedName =nil;
            self.changeNameField.text = @"";
            [self.directionRename setText:@"Which class would you like to rename? \n Select one from the table below"];
            [self.changeNameField setAlpha:0];
        }
        else{
            self.selectedClassNameForChangedName = selectedCell;
  
            [self.directionRename setText:@"Awesome!\nWhat would you like to rename your class?"];

            [self.changeNameField setAlpha:1];
        }
        
    }
    else{
        
        if ([self.userType isEqualToString:@"Teacher"]) {
            self.selectedClass = selectedCell;
            
            [self performSegueWithIdentifier:@"demoTabSegue" sender:self];
        }
        else{
            
            self.selectedStudentObjectIndexPath = indexPath;
            
            [self performSegueWithIdentifier:@"demoStudentAccSegue" sender:self];
        }
        [self.classesTable deselectRowAtIndexPath:indexPath animated:YES];
        
    }
    
}

-(BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    
    NSString *stringToMove = [self.classesTableArray objectAtIndex:sourceIndexPath.row];
    [self.classesTableArray removeObjectAtIndex:sourceIndexPath.row];
    [self.classesTableArray insertObject:stringToMove atIndex:destinationIndexPath.row];
}

-(void)classesListFromParse{
    
    if ([self.userType isEqualToString:@"Teacher"]) {
        
        //Get classesListArray for table
        NSError*error;
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"DemoTeacherObject"];
        NSArray *teacherObjArray = [_demoManagedObjectContext executeFetchRequest:request error:&error];
        
        if ([teacherObjArray count]) {
            
            _teacherObject = [teacherObjArray firstObject];
            
            NSData *data = [_teacherObject.classList dataUsingEncoding:NSUTF8StringEncoding];
            NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            
            self.classesTableArray = [NSMutableArray arrayWithArray:jsonArray];
            
        }
        else{
            NSLog(@"There none in database");
            self.classesTableArray = [[NSMutableArray alloc]initWithCapacity:0];
        }
        
        //Update class List information
        
    }
    else{
        
        //Student's class Table
        //from core data first
        
        NSError*error;
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"DemoStudentObject"];
        request.predicate=[NSPredicate predicateWithFormat:@"taken = %@",@"Student"];
        NSArray *studentObjArrayInCore = [_demoManagedObjectContext executeFetchRequest:request error:&error];
        
        self.classesTableArray = [[NSMutableArray alloc]initWithCapacity:[studentObjArrayInCore count]];
        self.classesTableArrayTeacherObject = [[NSMutableArray alloc]initWithCapacity:[studentObjArrayInCore count]];
        self.classesTableArrayStudentObject = [[NSMutableArray alloc]initWithCapacity:[studentObjArrayInCore count]];
        
        if ([studentObjArrayInCore count]) {
            //Iterate through every student in core
            for (DemoStudentObject* studentObj in studentObjArrayInCore) {
                
                [self.classesTableArrayTeacherObject addObject:studentObj.teacher];
                [self.classesTableArray addObject:[studentObj.nameOfclass capitalizedString]];
                [self.classesTableArrayStudentObject addObject:studentObj];
            }
            
        }
        [self.classesTable reloadData];
    }
}

-(void)studentInfo{
    
    if ([self.userType isEqualToString:@"Teacher"]) {
        
        //Show data from Database first
        NSError *error;
        NSFetchRequest *studentsRequest = [NSFetchRequest fetchRequestWithEntityName:@"DemoStudentObject"];
        studentsRequest.predicate = [NSPredicate predicateWithFormat:@"taken = %@",@"Teacher"];

        NSArray *studentObjArray = [_demoManagedObjectContext executeFetchRequest:studentsRequest error:&error];
        
        if (!error) {
            int totalIntCoins=0;
            int totalIntStudents = (int)[studentObjArray count];
            for (DemoStudentObject *studentObject in studentObjArray){
                
                totalIntCoins+=[studentObject.coins intValue];

            }
            
            self.totalCoins.text = [NSString stringWithFormat:@"%d",totalIntCoins];
            self.totalStudents.text = [NSString stringWithFormat:@"%d",totalIntStudents];
            self.totalSigned.text = [NSString stringWithFormat:@"%d",3];
            
            [self.view layoutIfNeeded];
            [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                
                if (IS_IPAD) {
                    self.hiddenLabelState.constant=0;
                    
                    [self.totalCoins setAlpha:1];
                    [self.totalSigned setAlpha:1];
                    [self.totalStudents setAlpha:1];
                    
                    [self.view layoutIfNeeded];
                    
                }
                else if (IS_IPHONE){
                    self.totalCoins.frame = CGRectMake((self.backgroundView.frame.size.width/6)-(self.backgroundView.frame.size.width/6)+10,self.totalCoinsLabel.frame.origin.y-55,(self.backgroundView.frame.size.width/3)-20, 55);
                    [self.totalCoins setAlpha:1];
                    
                    self.totalStudents.frame = CGRectMake((self.backgroundView.frame.size.width/2)-(self.backgroundView.frame.size.width/3)/2+10,self.totalCoinsLabel.frame.origin.y-55,(self.backgroundView.frame.size.width/3)-20, 55);
                    [self.totalStudents setAlpha:1];
                    
                    self.totalSigned.frame = CGRectMake((self.backgroundView.frame.size.width*2/3)+10,self.totalCoinsLabel.frame.origin.y-55,(self.backgroundView.frame.size.width/3)-20, 55);
                    [self.totalSigned setAlpha:1];
                }
                
            } completion:^(BOOL finished) {

                //we can use this to fetch from database to update
                [self classesListFromParse];
                [self.classesTable reloadData];
            }];
        }
        
    }
    else{
        
        //Show data from Database first
        NSError *error;
        NSFetchRequest *studentsRequest = [NSFetchRequest fetchRequestWithEntityName:@"DemoStudentObject"];
        studentsRequest.predicate= [NSPredicate predicateWithFormat:@"taken = %@",@"Student"];
        NSArray *studentObjArray = [_demoManagedObjectContext executeFetchRequest:studentsRequest error:&error];
        
        NSLog(@"%d",[studentObjArray count]);
        
        if (!error) {
            
            int totalIntCoins = 0;
            
            for (DemoStudentObject *studentObj in studentObjArray){
                
                totalIntCoins+=[studentObj.coins intValue];
                
                
            }
            
            self.totalStudentCoins.text = [NSString stringWithFormat:@"%d",totalIntCoins];
            
            //animate views
            [self.view layoutIfNeeded];
            [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                
                if (IS_IPAD) {
                    self.hiddenLabelState.constant=0;
                    [self.totalStudentCoins setAlpha:1];
                    [self.view layoutIfNeeded];
                }
                else{
                    self.totalStudentCoins.frame = CGRectMake((self.view.frame.size.width/2)-80,self.totalStudentCoins.frame.origin.y+20, 160, 80);
                    [self.totalStudentCoins setAlpha:1];
                }
                
                
                
            } completion:^(BOOL finished) {
                //get the classes of student and parents
                
                self.navigationItem.rightBarButtonItem= self.studentAddClassButton;
                [self classesListFromParse];
                [self.classesTable reloadData];
                
            }];
        }
        
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *CellIdentifier = @"studentCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
    }
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    NSString *cellValue = [self.classesTableArray objectAtIndex:indexPath.row];
    cell.textLabel.text = cellValue;
    cell.textLabel.textColor = [UIColor whiteColor];
    
    cell.detailTextLabel.text = [self.classesTableArrayTeacherObject objectAtIndex:indexPath.row];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    
    cell.backgroundColor=[UIColor clearColor];
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//menu bar code
-(void)menuBarAction{
    
    UIImageView *tutorialBlackboard = (UIImageView*)[self.view viewWithTag:1000];
    [tutorialBlackboard removeFromSuperview];
    
    [self removeBouncingPencil];
    
    //button
    UIImage *image = [UIImage imageNamed:@"cancelIcon"];
    CGRect frame = CGRectMake(0, 0, image.size.width-10, image.size.height-10);
    UIButton* button = [[UIButton alloc] initWithFrame:frame];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* classLeftButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem=classLeftButton;
    self.navigationItem.rightBarButtonItem=nil;
    
    if (IS_IPAD) {
        self.menuClassView = [[ClassMenuView alloc]initWithFrame:CGRectZero];
        [self.view addSubview:self.menuClassView];
        
        //empty out background
        if ([self.userType isEqualToString:@"Teacher"]) {
            [self.line1 setAlpha:0];
            [self.line2 setAlpha:0];
            [self.totalCoins setAlpha:0];
            [self.totalCoinsLabel setAlpha:0];
            [self.totalStudents setAlpha:0];
            [self.totalStudentsLabel setAlpha:0];
            [self.totalSigned setAlpha:0];
            [self.totalSignedUp setAlpha:0];
        }
        else{
            
            [self.totalStudentCoinsLabel setAlpha:0];
            [self.totalStudentCoins setAlpha:0];
        }
        
        
        self.menuClassView.translatesAutoresizingMaskIntoConstraints=NO;
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_menuClassView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_menuClassView)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-64-[_menuClassView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_menuClassView)]];
        
        [self.menuClassView layoutIfNeeded];
        //animate buttons evenly
        [UIView animateWithDuration:0.2 delay:0.0 options: UIViewAnimationOptionCurveEaseOut animations:^{
            
            
            [self.backgroundView setImage:[self.backgroundView.image applyDarkEffect]];
            
            
            self.menuClassView.hiddenState.constant= 100;
            
            [self.menuClassView.addNewClass setAlpha:1];
            [self.menuClassView.changeNameClass setAlpha:1];
            [self.menuClassView.moveClass setAlpha:1];
            
            
            [self.menuClassView.addNewClassLabel setAlpha:1];
            [self.menuClassView.moveClassLabel setAlpha:1];
            [self.menuClassView.changeNameClassLabel setAlpha:1];
            
            [self.menuClassView layoutIfNeeded];
        }
                         completion:nil];
        
        
        if (![self.teachersProgress.addClassDone boolValue]) {

            BouncingPencil *pencilArrow = [[BouncingPencil alloc]init];
            [pencilArrow setTag:2000];
            [self.view addSubview:pencilArrow];
            
            pencilArrow.translatesAutoresizingMaskIntoConstraints=NO;
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-200-[pencilArrow(60)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(pencilArrow)]];
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:pencilArrow attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:-110]];
            [pencilArrow setUpPencilBounceForiPad:CGSizeMake(60, 60) targetX:-15 targetY:-9 rotation:3*M_PI_4];

        }
        
    }
    else if(IS_IPHONE){
        self.menuClassView = [[ClassMenuView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+64, self.view.frame.size.width,self.backgroundView.frame.size.height-self.tabBarController.tabBar.frame.size.height-64)];
        
        [self.view addSubview:self.menuClassView];
        //empty out background
        if ([self.userType isEqualToString:@"Teacher"]) {
            [self.totalCoins removeFromSuperview];
            [self.totalCoinsLabel removeFromSuperview];
            [self.totalStudents removeFromSuperview];
            [self.totalStudentsLabel removeFromSuperview];
            [self.totalSigned removeFromSuperview];
            [self.totalSignedUp removeFromSuperview];
            [self.line1 setAlpha:0];
            [self.line2 setAlpha:0];

        }
        else{
            
            [self.totalStudentCoinsLabel removeFromSuperview];
            [self.totalStudentCoins removeFromSuperview];
        }
        
        //animate buttons evenly
        [UIView animateWithDuration:0.2 delay:0.0 options: UIViewAnimationOptionCurveEaseOut animations:^{
            
            [self.backgroundView setImage:[self.backgroundView.image applyDarkEffect]];
            
            self.menuClassView.addNewClass.frame = CGRectMake((self.view.frame.size.width/6)-35,10, 70, 70);
            [self.menuClassView.addNewClass setAlpha:1];
            [self.menuClassView.addNewClassLabel setAlpha:1];
        }
                         completion:nil];
        [UIView animateWithDuration:0.2 delay:0.1 options: UIViewAnimationOptionTransitionCurlDown animations:^{
            self.menuClassView.moveClass.frame = CGRectMake(self.view.frame.size.width*0.5-35,10, 70, 70);
            [self.menuClassView.moveClass setAlpha:1];
            [self.menuClassView.moveClassLabel setAlpha:1];
        }
                         completion:nil];
        
        
        [UIView animateWithDuration:0.2 delay:0.2 options: UIViewAnimationOptionTransitionCurlDown animations:^{
            self.menuClassView.changeNameClass.frame = CGRectMake((self.view.frame.size.width*5/6)-35, 10, 70, 70);
            [self.menuClassView.changeNameClass setAlpha:1];
            [self.menuClassView.changeNameClassLabel setAlpha:1];
        }
                         completion:nil];
        
        if (![self.teachersProgress.addClassDone boolValue]) {
            BouncingPencil*addClass = [[BouncingPencil alloc]initWithFrame:CGRectMake(75, 220, 60, 60)];
            [addClass setTag:2000];
            [addClass setUpPencilBounceFrame:addClass.frame targetX:-10 targetY:-15 rotation:(3*M_PI_4)];
            [self.view addSubview:addClass];
        }

        
        
    }
    
}

-(void)hideMenuViewAction{
    self.navigationItem.leftBarButtonItem=nil;

    if (IS_IPAD) {
        [self.menuClassView layoutIfNeeded];
        [UIView animateWithDuration:0.2 delay:0.0 options: UIViewAnimationOptionTransitionCurlDown animations:^{
            
            self.menuClassView.hiddenState.constant=80;
            
            [self.menuClassView.addNewClass setAlpha:0];
            [self.menuClassView.changeNameClass setAlpha:0];
            [self.menuClassView.moveClass setAlpha:0];
            
            
            [self.menuClassView.addNewClassLabel setAlpha:0];
            [self.menuClassView.moveClassLabel setAlpha:0];
            [self.menuClassView.changeNameClassLabel setAlpha:0];
            
            [self.menuClassView layoutIfNeeded];
            
        }
                         completion:^(BOOL finished){
                             if ([self.typeOfDay isEqualToString:@"Morning"]) {
                                 [self.backgroundView setImage:[UIImage imageNamed:@"blackboardBackground"]];
                                 
                             }
                             else if ([self.typeOfDay isEqualToString:@"Afternoon"]){
                                 [self.backgroundView setImage:[UIImage imageNamed:@"dayBackground"]];
                                 
                             }
                             else if ([self.typeOfDay isEqualToString:@"Evening"]){
                                 [self.backgroundView setImage:[UIImage imageNamed:@"nightBackground"]];
                                 
                             }
                             
                             [self.menuClassView.addNewClass removeFromSuperview];
                             [self.menuClassView.moveClass removeFromSuperview];
                             [self.menuClassView.changeNameClass removeFromSuperview];
                             
                             [self.menuClassView.addNewClassLabel removeFromSuperview];
                             [self.menuClassView.moveClassLabel removeFromSuperview];
                             [self.menuClassView.changeNameClassLabel removeFromSuperview];
                             
                             [self.menuClassView removeFromSuperview];
                         }];
        
    }
    else if (IS_IPHONE){
        //animate buttons evenly
        [UIView animateWithDuration:0.2 delay:0.0 options: UIViewAnimationOptionCurveEaseOut animations:^{
            self.menuClassView.addNewClass.frame = CGRectMake((self.view.frame.size.width/6)-35,64-70, 70, 70);
            [self.menuClassView.addNewClass setAlpha:0];
            
            [self.menuClassView.addNewClassLabel setAlpha:0];
            
            
        }
                         completion:^(BOOL finished){
                         }];
        
        if ([self.userType isEqualToString:@"Teacher"]) {
            [UIView animateWithDuration:0.2 delay:0.1 options: UIViewAnimationOptionTransitionCurlDown animations:^{
                self.menuClassView.moveClass.frame = CGRectMake(self.view.frame.size.width*0.5-35,64-64, 70, 70);
                [self.menuClassView.moveClass setAlpha:0];

                [self.menuClassView.moveClassLabel setAlpha:0];
            }
                             completion:^(BOOL finished){
                             }];
            
            [UIView animateWithDuration:0.2 delay:0.2 options: UIViewAnimationOptionTransitionCurlDown animations:^{
                
                self.menuClassView.changeNameClass.frame = CGRectMake((self.view.frame.size.width*5/6)-35, 64-70, 70, 70);
                [self.menuClassView.changeNameClass setAlpha:0];
                

                [self.menuClassView.changeNameClassLabel setAlpha:0];
                
            }
                             completion:^(BOOL finished){
                                 if ([self.typeOfDay isEqualToString:@"Morning"]) {
                                     [self.backgroundView setImage:[UIImage imageNamed:@"blackboardBackground"]];
                                     
                                 }
                                 else if ([self.typeOfDay isEqualToString:@"Afternoon"]){
                                     [self.backgroundView setImage:[UIImage imageNamed:@"dayBackground"]];
                                     
                                 }
                                 else if ([self.typeOfDay isEqualToString:@"Evening"]){
                                     [self.backgroundView setImage:[UIImage imageNamed:@"nightBackground"]];
                                     
                                 }
                                 
                                 [self.menuClassView.addNewClass removeFromSuperview];
                                 [self.menuClassView.moveClass removeFromSuperview];
                                 [self.menuClassView.changeNameClass removeFromSuperview];
                                 
                                 [self.menuClassView.addNewClassLabel removeFromSuperview];
                                 [self.menuClassView.moveClassLabel removeFromSuperview];
                                 [self.menuClassView.changeNameClassLabel removeFromSuperview];
                                 
                                 [self.menuClassView removeFromSuperview];
                             }];
        }
        else{
            [UIView animateWithDuration:0.2 delay:0.1 options: UIViewAnimationOptionTransitionCurlDown animations:^{
                self.menuClassView.moveClass.frame = CGRectMake(self.view.frame.size.width*0.5-35,64-64, 70, 70);
                [self.menuClassView.moveClass setAlpha:0];
                
                self.menuClassView.moveClassLabel.frame = CGRectMake(self.view.frame.size.width*0.5-35,60, 70, 30);
                [self.menuClassView.moveClassLabel setAlpha:0];
            }
                             completion:^(BOOL finished){
                                 [self.menuClassView.addNewClass removeFromSuperview];
                                 [self.menuClassView.moveClass removeFromSuperview];
                                 
                                 [self.menuClassView.addNewClassLabel removeFromSuperview];
                                 [self.menuClassView.moveClassLabel removeFromSuperview];
                                 
                                 [self.menuClassView removeFromSuperview];
                             }];
        }
    }
}

-(void)addBackgroundInfo{
    
    //add backgroundview again
    [self studentInfo];
    
    if ([self.userType isEqualToString:@"Teacher"]) {
        [self.backgroundView addSubview:self.totalStudentsLabel];
        [self.backgroundView addSubview:self.totalCoinsLabel];
        [self.backgroundView addSubview:self.totalSignedUp];
    }
    else{
        [self.backgroundView addSubview:self.totalStudentCoinsLabel];
    }
}

//cancel button for menu
-(void)cancelButtonAction{
    if ([self.userType isEqualToString:@"Teacher"]) {
        
        if (![self.teachersProgress.addClassDone boolValue]) {
            [self removeBouncingPencil];

        }
    }
    else{
        if (![self.studentsProgress.addClassDone boolValue]) {
            UIImageView *tutorialBlackboard = (UIImageView*)[self.view viewWithTag:1000];
            [tutorialBlackboard setTag:0];
            [tutorialBlackboard removeFromSuperview];
        }
    }
    
    [self hideMenuViewAction];
    
    
    //add all the background lables after all the animations are done
    [self performSelector:@selector(cancelButtonAddBackground) withObject:nil afterDelay:0.5];
    
}

-(void)cancelButtonAddBackground{
    
    if (IS_IPAD) {
        
        if ([self.userType isEqualToString:@"Teacher"]) {
            
            self.hiddenLabelState.constant=-20;
            
            //Add labels back in
            [self.totalCoinsLabel setAlpha:1];
            [self.totalStudentsLabel setAlpha:1];
            [self.totalSignedUp setAlpha:1];
            [self.line1 setAlpha:1];
            [self.line2 setAlpha:1];
            
            [self.view layoutIfNeeded];
            [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                
                if ([self.typeOfDay isEqualToString:@"Morning"]) {
                    [self.backgroundView setImage:[UIImage imageNamed:@"blackboardBackground"]];
                    
                }
                else if ([self.typeOfDay isEqualToString:@"Afternoon"]){
                    [self.backgroundView setImage:[UIImage imageNamed:@"dayBackground"]];
                    
                }
                else if ([self.typeOfDay isEqualToString:@"Evening"]){
                    [self.backgroundView setImage:[UIImage imageNamed:@"nightBackground"]];
                    
                }
                
                self.hiddenLabelState.constant=0;
                
                [self.totalCoins setAlpha:1];
                [self.totalStudents setAlpha:1];
                [self.totalSigned setAlpha:1];
                
                [self.view layoutIfNeeded];
                
            } completion:^(BOOL finished) {
                
                //set button after everything is set
                self.navigationItem.rightBarButtonItem=self.menuButton;

                
            }];
        }
        else{
            [self.totalStudentCoinsLabel setAlpha:1];
            
            self.hiddenLabelState.constant=-20;
            [self.view layoutIfNeeded];
            //animate views
            [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                
                self.hiddenLabelState.constant=0;
                
                [self.totalStudentCoins setAlpha:1];
                [self.view layoutIfNeeded];
                
            } completion:^(BOOL finished) {
                //set button after everything is set
                self.navigationItem.rightBarButtonItem=self.studentAddClassButton;
                

            }];
            
        }
        
    }
    else if(IS_IPHONE){
        
        if ([self.userType isEqualToString:@"Teacher"]) {
            
            [self.line1 setAlpha:1];
            [self.line2 setAlpha:1];
            
            [self.totalCoins setFrame:CGRectMake((self.backgroundView.frame.size.width/6)-(self.backgroundView.frame.size.width/6)+10,self.totalCoinsLabel.frame.origin.y-75,(self.backgroundView.frame.size.width/3)-20, 55)];
            self.totalCoins.alpha=0;
            [self.backgroundView addSubview:self.totalCoins];
            
            [self.totalStudents setFrame:CGRectMake((self.backgroundView.frame.size.width/2)-(self.backgroundView.frame.size.width/3)/2+10,self.totalCoinsLabel.frame.origin.y-75,(self.backgroundView.frame.size.width/3)-20, 55)];
            self.totalStudents.alpha=0;
            [self.backgroundView addSubview:self.totalStudents];
            
            [self.totalSigned setFrame:CGRectMake((self.backgroundView.frame.size.width*2/3)+10,self.totalCoinsLabel.frame.origin.y-75,(self.backgroundView.frame.size.width/3)-20, 55)];
            self.totalSigned.alpha=0;
            [self.backgroundView addSubview:self.totalSigned];
            
            //labels
            [self.view addSubview:self.totalCoinsLabel];
            [self.view addSubview:self.totalStudentsLabel];
            [self.view addSubview:self.totalSignedUp];
            
            [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                
                if ([self.typeOfDay isEqualToString:@"Morning"]) {
                    [self.backgroundView setImage:[UIImage imageNamed:@"blackboardBackground"]];
                    
                }
                else if ([self.typeOfDay isEqualToString:@"Afternoon"]){
                    [self.backgroundView setImage:[UIImage imageNamed:@"dayBackground"]];
                    
                }
                else if ([self.typeOfDay isEqualToString:@"Evening"]){
                    [self.backgroundView setImage:[UIImage imageNamed:@"nightBackground"]];
                    
                }
                
                self.totalCoins.frame = CGRectMake((self.backgroundView.frame.size.width/6)-(self.backgroundView.frame.size.width/6)+10,self.totalCoinsLabel.frame.origin.y-55,(self.backgroundView.frame.size.width/3)-20, 55);
                [self.totalCoins setAlpha:1];
                
                self.totalStudents.frame = CGRectMake((self.backgroundView.frame.size.width/2)-(self.backgroundView.frame.size.width/3)/2+10,self.totalCoinsLabel.frame.origin.y-55,(self.backgroundView.frame.size.width/3)-20, 55);
                [self.totalStudents setAlpha:1];
                
                self.totalSigned.frame = CGRectMake((self.backgroundView.frame.size.width*2/3)+10,self.totalCoinsLabel.frame.origin.y-55,(self.backgroundView.frame.size.width/3)-20, 55);
                [self.totalSigned setAlpha:1];
                
                
            } completion:^(BOOL finished) {
                
                //set button after everything is set
                self.navigationItem.rightBarButtonItem=self.menuButton;

                
            }];
        }
        else{
            
            [self.totalStudentCoins setFrame:CGRectMake(self.totalStudentCoins.frame.origin.x,self.totalStudentCoins.frame.origin.y-20,self.totalStudentCoins.frame.size.width,self.totalStudentCoins.frame.size.height)];
            self.totalStudentCoins.alpha=0;
            [self.backgroundView addSubview:self.totalStudentCoins];
            [self.backgroundView addSubview:self.totalStudentCoinsLabel];
            
            //animate views
            [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                
                self.totalStudentCoins.frame = CGRectMake(self.totalStudentCoins.frame.origin.x,self.totalStudentCoins.frame.origin.y+20, 160, 80);
                [self.totalStudentCoins setAlpha:1];
                
            } completion:^(BOOL finished) {
                //set button after everything is set
                self.navigationItem.rightBarButtonItem=self.studentAddClassButton;

            }];
            
        }
    }
    [self startTutorialDemo];
}


//menu selection code
-(void)menuSelection{
    
    [self removeBouncingPencil];
    
    if([self.menuClassView.menuOption isEqualToString:@"addNew"]){
        [self.menuClassView removeFromSuperview];
        [self addMoreClass];
    }
    else if ([self.menuClassView.menuOption isEqualToString:@"moveClass"]){
        [self.classesTable setEditing:YES animated:YES];
        
        //bar buttons
        UIBarButtonItem *doneMove = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneMoveAction)];
        self.navigationItem.rightBarButtonItem=doneMove;
        self.navigationItem.leftBarButtonItem =nil;
        
        [self.menuClassView removeFromSuperview];
        
        //direction
        self.moveDirection = [[UILabel alloc] initWithFrame:CGRectMake(self.backgroundView.frame.origin.x+44,self.backgroundView.frame.origin.y+80,self.backgroundView.frame.size.width-45, 50)];
        self.moveDirection.backgroundColor = [UIColor clearColor];
        self.moveDirection.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
        self.moveDirection.textColor = [UIColor whiteColor];
        self.moveDirection.numberOfLines=0;
        self.moveDirection.minimumScaleFactor=0.5;
        self.moveDirection.text = @"Use the cursor on the right to move your classes";
        [self.backgroundView addSubview:self.moveDirection];
        
        UIImage *arrowImage = [UIImage imageNamed:@"arrowIcon"];
        UIImageView *arrowImageView = [[UIImageView alloc]init];
        [arrowImageView setTag:200];
        [arrowImageView setImage:arrowImage];
        [self.view addSubview:arrowImageView];
        
        if (IS_IPAD) {
            arrowImageView.translatesAutoresizingMaskIntoConstraints=NO;
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[arrowImageView(180)]-20-[_classesTable]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(arrowImageView,_classesTable)]];
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[arrowImageView(40)]-4-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(arrowImageView,_classesTable)]];
        }
        else if (IS_IPHONE){
            [arrowImageView setFrame:CGRectMake(285, self.moveDirection.frame.origin.y+self.moveDirection.frame.size.height+50, arrowImage.size.width, arrowImage.size.height)];
            
        }
        
        CGPoint origin = arrowImageView.center;
        CGPoint target = CGPointMake(arrowImageView.center.x, arrowImageView.center.y+35);
        CABasicAnimation *bounce = [CABasicAnimation animationWithKeyPath:@"position.y"];
        bounce.duration = 0.5;
        bounce.fromValue = [NSNumber numberWithInt:origin.y];
        bounce.toValue = [NSNumber numberWithInt:target.y];
        bounce.autoreverses = YES;
        bounce.repeatDuration= 100;
        [bounce setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];

        [arrowImageView.layer addAnimation:bounce forKey:@"position"];
        
        
    }
    else if ([self.menuClassView.menuOption isEqualToString:@"changeNameClass"]){
        //leftbarbutton
        UIImage *image = [UIImage imageNamed:@"cancelIcon"];
        CGRect frame = CGRectMake(0, 0, image.size.width-10, image.size.height-10);
        UIButton* button = [[UIButton alloc] initWithFrame:frame];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button addTarget:self action:@selector(hideChangeNameView) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem* classLeftButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        
        //rightbarbutton
        UIBarButtonItem *classRightButton = [[UIBarButtonItem alloc]initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(nextChangedName)];
        
        //remove the menu buttons
        [self.menuClassView removeAllButtonsInMenu];
        
        //Rename View
        self.directionRename = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.origin.x+30,5, self.view.frame.size.width-30, 90)];
        self.directionRename.text=@"Which class would you like to rename? \n\n Select one from the table below";
        self.directionRename.numberOfLines=0;
        self.directionRename.textColor = [UIColor whiteColor];
        self.directionRename.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
        [self.menuClassView addSubview:self.directionRename];
        
        //input new class textfield
        self.changeNameField = [[UITextField alloc]initWithFrame:CGRectMake((self.view.frame.size.width/2)-40,self.directionRename.frame.origin.y+80,195 ,30)];
        self.changeNameField.alpha=0;
        self.changeNameField.placeholder = @"Enter New Class Name";
        self.changeNameField.borderStyle = UITextBorderStyleRoundedRect;
        [self.menuClassView addSubview:self.changeNameField];
        
        UIImage *smallCursorImage = [UIImage imageNamed:@"smallCursor"];
        UIImageView *smallCursorView=[[UIImageView alloc]initWithFrame:CGRectMake(self.changeNameField.frame.origin.x-70, self.directionRename.frame.origin.y+80, 30,30)];
        [smallCursorView setImage:smallCursorImage];
        smallCursorView.alpha=0;
        [self.menuClassView addSubview:smallCursorView];
        
        CGRect newClassNameFrame = self.menuClassView.frame;
        newClassNameFrame.size.height = self.menuClassView.frame.size.height*0.25;
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self.menuClassView setFrame:newClassNameFrame];
            smallCursorView.alpha = 1;
        } completion:^(BOOL finished) {
            
            self.navigationItem.leftBarButtonItem=classLeftButton;
            self.navigationItem.rightBarButtonItem=classRightButton;
        }];
    }
    else{
        NSLog(@"no selection error");
    }
}

//menu selection: add code
-(void)addMoreClass{
    
    
    //tutorial
    if ([self.userType isEqualToString:@"Teacher"]) {
        if (![self.teachersProgress.addClassDone boolValue]) {
            [self removeBouncingPencil];

        }
    }
    else{
        if (![self.studentsProgress.addClassDone boolValue]) {
            UIImageView *tutorialBlackboard = (UIImageView*)[self.view viewWithTag:1000];
            [tutorialBlackboard setTag:0];
            [tutorialBlackboard removeFromSuperview];
            
            [self removeBouncingPencil];
            
            UIImageView *tutorialbackground = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"blackboardBorder"]];
            [tutorialbackground setTag:1000];
            [tutorialbackground setAlpha:0];
            [self.view addSubview:tutorialbackground];
            
            if(IS_IPHONE){
                [tutorialbackground setFrame:CGRectMake(0, 270, 320, 100)];
            }
            else if(IS_IPAD){
                
                tutorialbackground.translatesAutoresizingMaskIntoConstraints=NO;
                
                [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tutorialbackground attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
                [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-290-[tutorialbackground(150)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tutorialbackground)]];
                
    
                [tutorialbackground addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[tutorialbackground(300)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tutorialbackground)]];
            }
            
            
            CGAffineTransform transform = CGAffineTransformMakeScale(0.9, 0.9);
            [tutorialbackground.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                [tutorialbackground setAlpha:1];
                [tutorialbackground setTransform:transform];
                
            } completion:^(BOOL finished) {
                UILabel *tutorialLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, tutorialbackground.frame.size.width-40, tutorialbackground.frame.size.height-10)];
                [tutorialLabel setFont:[UIFont fontWithName:@"Eraser" size:18]];
                [tutorialLabel setTextColor:[UIColor whiteColor]];
                [tutorialLabel setNumberOfLines:0];
                [tutorialLabel setText:[NSString stringWithFormat:@"Since this is a demo, \n You may input anything you like!"]];
                [tutorialbackground addSubview:tutorialLabel];
                
            }];

        }
        
    }

    
    self.enterClassName = [[ClassNameView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, 64, self.view.frame.size.width,self.view.frame.size.height-64-self.classesTable.frame.size.height) userType:self.userType];

    [self.view addSubview:self.enterClassName];
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if ([self.userType isEqualToString:@"Teacher"]) {
            
            self.enterClassName.bookView.alpha=1;
            self.enterClassName.classField.alpha=1;
        }
        else{ //student special add code
            
            UIImageView *bannerView = (UIImageView*)[self.view viewWithTag:100];
            bannerView.alpha=0;
            
            
            if (IS_IPAD) {
                [self.totalStudentCoinsLabel setAlpha:0];
                [self.totalStudentCoins setAlpha:0];
                
                if (_isEmpty) {
//                    self.emptyAddButtonDirection.alpha =0;
//                    self.emptyLogoutButtonDirection.alpha=0;
//                    self.emptyDeleteButtonDirection.alpha=0;
                }
                
            }
            else if (IS_IPHONE){
                
//                if (bannerView.frame.origin.x != (self.view.frame.size.width/2 - bannerView.image.size.width/2)) {
//                    self.emptyAddButtonDirection.alpha =0;
//                    self.emptyLogoutButtonDirection.alpha=0;
//                    self.emptyDeleteButtonDirection.alpha=0;
//                }
                [self.totalStudentCoinsLabel removeFromSuperview];
                [self.totalStudentCoins removeFromSuperview];
            }
            [self.backgroundView setImage:[self.backgroundView.image applyDarkEffect]];
            
            self.enterClassName.usernameField.alpha=1;
            self.enterClassName.teachEmailField.alpha=1;
            self.enterClassName.classField.alpha=1;
        }
    } completion:nil];
    
    //add toolbar actions
    
    [self.enterClassName.rightBarButton setAction:@selector(nextAction)];
    [self.enterClassName.button addTarget:self action:@selector(hideClassViewAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = self.enterClassName.rightBarButton;
    self.navigationItem.leftBarButtonItem = self.enterClassName.leftBarButton;
    
}
//add new class toolbar buttons code
-(void)nextAction{
    
    if ([self.userType isEqualToString:@"Teacher"]) {
        
        //save the classname and move to the next vc which is the add student
        if ([self.enterClassName.classField.text isEqualToString:@""]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oh No! Your textfield is empty" message:@"Make sure you enter the name of your new class in the textfield" delegate:self cancelButtonTitle:@"Try Again" otherButtonTitles:nil];
            [alert show];
        }
        else{
            NSError *error;
            NSData *data = [_teacherObject.classList dataUsingEncoding:NSUTF8StringEncoding];
            NSArray *jsonClassListArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            
            NSMutableArray *classListArray = [[NSMutableArray alloc]initWithArray:jsonClassListArray];
            
            NSString *newClassName = [self.enterClassName.classField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            BOOL classNameDuplicate = NO;
            //check for duplicates
            for (NSString* className in classListArray) {
                if ([[className lowercaseString] isEqualToString:[newClassName lowercaseString]]) {
                    classNameDuplicate =YES;
                    break;
                }
            }
            
            if (classNameDuplicate) {
                NSString *alertDuplicateString = [NSString stringWithFormat:@"You already have a class named %@",newClassName];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Try Again!" message:alertDuplicateString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            else{
                self.selectedClass = newClassName;
                
                
                [self hideClassViewAction];
                [self performSegueWithIdentifier:@"demoAddClassSegue" sender:self];
            }
        }
    }
    else{
        
        if (![self.studentsProgress.addClassDone boolValue]) {
            self.studentsProgress.addClassDone = [NSNumber numberWithBool:YES];
            [_demoManagedObjectContext save:nil];
            UIImageView *tutorialBlackboard = (UIImageView*)[self.view viewWithTag:1000];
            [tutorialBlackboard setTag:0];
            [tutorialBlackboard removeFromSuperview];
            
            [self.demoProgressBar setProgress:[self.studentsProgress getTotalProgress] animated:YES];
            [self.checkTutorial setTitle:[NSString stringWithFormat:@"Click Here! Demo: %0.2f%%",([self.studentsProgress getTotalProgress]*100)] forState:UIControlStateNormal];
            
            if ((int)[self.studentsProgress getTotalProgress] == 1) {
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
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Nice!" message:@"Good job! You just join a class." delegate:self cancelButtonTitle:@"Next" otherButtonTitles:nil];
        [alert show];
        
        NSString *lowerClassName = [self.enterClassName.classField.text lowercaseString];
        
        //fix
        NSString *capUsername = [self.enterClassName.usernameField.text capitalizedString];
        
        //trim white spaces
        lowerClassName = [lowerClassName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        capUsername = [capUsername stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        NSInteger arrayCount =[self.classesTableArray count]+1;
        
        NSDictionary *studentDict = @{@"coins": @5,
                               @"nameOfclass":lowerClassName,
                               @"signedIn":@0,
                               @"studentName":capUsername,
                               @"studentNumber":@(arrayCount),
                               @"objectId":[NSString stringWithFormat:@"demostudent%d",arrayCount],
                               @"taken":@"Student",
                               @"teacher":@"Ms. Brookes"};
        
        DemoStudentObject *newStudent = [DemoStudentObject createStudentObjectInCoreWithDictionary:studentDict inManagedObjectContext:_demoManagedObjectContext];
        [_demoManagedObjectContext save:nil];
        
        [self.classesTableArrayTeacherObject addObject:newStudent.teacher];
        [self.classesTableArray addObject:[newStudent.nameOfclass capitalizedString]];
        [self.classesTableArrayStudentObject addObject:newStudent];
        
        [self.classesTable reloadData];
        [self hideClassViewAction];
        
        

    }
}

-(void)hideClassViewAction{
    [self cancelButtonAction];
    
    if ([self.userType isEqualToString:@"Teacher"]) {
        
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.enterClassName.bookView.alpha=0;
            self.enterClassName.classField.alpha=0;
            
        } completion:^(BOOL finished) {
            [self.enterClassName removeFromSuperview];
            self.enterClassName=nil;
        }];
        
    }
    else{
        
        //hide right button RIGHT after cancel button is pressed
        self.navigationItem.rightBarButtonItem = nil;
        UIImageView *bannerView = (UIImageView*)[self.view viewWithTag:100];
        
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.enterClassName.usernameField.alpha=0;
            self.enterClassName.teachEmailField.alpha=0;
            self.enterClassName.classField.alpha=0;
            
            if ([self.typeOfDay isEqualToString:@"Morning"]) {
                [self.backgroundView setImage:[UIImage imageNamed:@"blackboardBackground"]];
                
            }
            else if ([self.typeOfDay isEqualToString:@"Afternoon"]){
                [self.backgroundView setImage:[UIImage imageNamed:@"dayBackground"]];
                
            }
            else if ([self.typeOfDay isEqualToString:@"Evening"]){
                [self.backgroundView setImage:[UIImage imageNamed:@"nightBackground"]];
                
            }
            [self.enterClassName removeFromSuperview];
            
            bannerView.alpha=1;
            
            if (IS_IPHONE) {
                if (bannerView.frame.origin.x != (self.view.frame.size.width/2 - bannerView.image.size.width/2)) {
//                    self.emptyAddButtonDirection.alpha=1;
//                    self.emptyDeleteButtonDirection.alpha=1;
//                    self.emptyLogoutButtonDirection.alpha=1;
                }
            }
            else if (IS_IPAD){
                if (_isEmpty) {
//                    self.emptyAddButtonDirection.alpha =1;
//                    self.emptyLogoutButtonDirection.alpha=1;
//                    self.emptyDeleteButtonDirection.alpha=1;
                }
            }
            
        } completion:^(BOOL finished) {
            self.enterClassName=nil;
        }];
        
    }
    
}

//menu selection: move code
-(void)doneMoveAction{
    
    [self.classesTable setEditing:NO animated:YES];
    [self.moveDirection removeFromSuperview];
    UIImageView *arrowIm = (UIImageView*)[self.view viewWithTag:200];
    [arrowIm removeFromSuperview];
    
    NSError *error;
    NSData *jsonDataArray = [NSJSONSerialization dataWithJSONObject:self.classesTableArray options:0 error:&error];
    NSString *JSONStringArray = [[NSString alloc] initWithData:jsonDataArray encoding:NSUTF8StringEncoding];
    
    _teacherObject.classList = JSONStringArray;
    [_demoManagedObjectContext save:nil];

    self.navigationItem.rightBarButtonItem=self.menuButton;
    [self cancelButtonAddBackground];
    
}

//rename code
-(void)hideChangeNameView{
    [self.changeNameField removeFromSuperview];
    [self cancelButtonAction];
    
    //Helps deselect any rows that is selected
    [self.classesTable reloadData];
    
    self.navigationItem.leftBarButtonItem=nil;
    self.navigationItem.rightBarButtonItem=self.menuButton;
}

-(void)nextChangedName{
    NSUInteger index = [self.classesTableArray indexOfObject:self.selectedClassNameForChangedName];
    
    //check to see if user selected a class
    if(index==NSNotFound){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Select a class!" message:@"Make sure you selected a name on the table." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else if (index!=NSNotFound && [self.changeNameField.text isEqualToString:@""]){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Empty Field!" message:@"Make sure you enter a new name in the textfield." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
    else{
        
        
        BOOL classNameDuplicate=NO;
        
        //check for duplicates
        for (NSString* className in self.classesTableArray) {
            
            if ([[className lowercaseString] isEqualToString:
                 [self.changeNameField.text lowercaseString]]&&![self.classesTableArray[index] isEqualToString:className]){
                
                classNameDuplicate =YES;
                break;
            }
        }
        
        if (classNameDuplicate) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Try Again!" message:@"The name you have entered is already taken." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else{
            //change the class name in user
            
            NSString *newClassName = [self.changeNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            [self.classesTableArray replaceObjectAtIndex:index withObject:newClassName];
            
            NSError *error;
            NSData *jsonDataArray = [NSJSONSerialization dataWithJSONObject:self.classesTableArray options:0 error:&error];
            NSString *JSONStringArray = [[NSString alloc] initWithData:jsonDataArray encoding:NSUTF8StringEncoding];
            
            _teacherObject.classList = JSONStringArray;
            
            //change classnames for student objects:
            //In Core
            NSFetchRequest *studentsRequest = [NSFetchRequest fetchRequestWithEntityName:@"DemoStudentObject"];
            studentsRequest.predicate= [NSPredicate predicateWithFormat:@"nameOfclass = %@",[self.selectedClassNameForChangedName lowercaseString]];
            NSArray *studentObjArray = [_demoManagedObjectContext executeFetchRequest:studentsRequest error:&error];
            
            //Array for updating class in student logs
            for (DemoStudentObject*studentObj in studentObjArray) {
                studentObj.nameOfclass=[newClassName lowercaseString];
            }
            [_demoManagedObjectContext save:nil];
            
            [self.classesTable reloadData];
            [self hideChangeNameView];
        }
    }
}



#pragma mark - Navigation
- (NSUInteger) supportedInterfaceOrientations {
    
    if(IS_IPAD){
        return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
    }
    else{
        return UIInterfaceOrientationMaskPortrait;
    }
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    if (IS_IPAD) {
        return YES;
    }
    else{
        // Return YES for supported orientations.
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    }
    
}

-(BOOL)shouldAutorotate{
    
    if (IS_IPAD) {
        return YES;
    }
    else{
        return NO;
    }
    
}
// In a storyboard-based application, you will often want to do a little preparation before navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    if ([segue.identifier isEqualToString:@"tabbarseg"]) {
//        // if the cell selected segue was fired, edit the selected note
//        UITabBarController *tabbarC = (UITabBarController*)segue.destinationViewController;
//        
//        UINavigationController *navVC = [tabbarC.viewControllers objectAtIndex:0];
//        DemoStudentsViewController *studentVC = [navVC.viewControllers objectAtIndex:0];
//        
//        TeacherStoreViewController *storeVC = [tabbarC.viewControllers objectAtIndex:1];
//        
//        UINavigationController *annNavVC = [tabbarC.viewControllers objectAtIndex:2];
//        AnnouncementViewController *annVC = [annNavVC.viewControllers objectAtIndex:0];
//        
//        
//        UINavigationController *moreNavVC = [tabbarC.viewControllers objectAtIndex:3];
//        moreViewController *moreVC = [moreNavVC.viewControllers objectAtIndex:0];
//        
//        annVC.className=self.selectedClass;
//        annVC.managedObjectContext = _managedObjectContext;
//        
//        moreVC.classNameInMore = self.selectedClass;
//        moreVC.managedObjectContext=_managedObjectContext;
//        
//        storeVC.className=self.selectedClass;
//        storeVC.managedObjectContext = self.managedObjectContext;
//        
//        studentVC.className=self.selectedClass;
//        studentVC.managedObjectContext = self.managedObjectContext;
//    }
//    else if ([segue.identifier isEqualToString:@"studentclassseg"]){
//        AddViewController *addVC = (AddViewController*)segue.destinationViewController;
//        
//        addVC.className=[self.enterClassName.classField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//        addVC.managedObjectContext = _managedObjectContext;
//        addVC.previousSegue = segue.identifier;
//        
//    }


    if ([segue.identifier isEqualToString:@"demoTabSegue"]) {
        // if the cell selected segue was fired, edit the selected note
        UITabBarController *tabbarC = (UITabBarController*)segue.destinationViewController;

//        UINavigationController *navVC = [tabbarC.viewControllers objectAtIndex:0];
        
        DemoStudentViewController *studentVC = [tabbarC.viewControllers objectAtIndex:0];

        DemoStoreViewController *storeVC = [tabbarC.viewControllers objectAtIndex:1];

        DemoAnnounceViewController *annVC = [tabbarC.viewControllers objectAtIndex:2];
//        DemoMoreViewController *moreVC = [tabbarC.viewControllers objectAtIndex:3];

        annVC.userType = self.userType;
        annVC.className=self.selectedClass;
        annVC.managedObjectContext = _managedObjectContext;
        annVC.demoManagedObjectContext = _demoManagedObjectContext;
//
//        moreVC.classNameInMore = self.selectedClass;
//        moreVC.managedObjectContext=_managedObjectContext;
//
        storeVC.className=self.selectedClass;
        storeVC.userType = self.userType;
        storeVC.managedObjectContext = self.managedObjectContext;
        storeVC.demoManagedObjectContext = self.demoManagedObjectContext;

        studentVC.className=self.selectedClass;
        studentVC.managedObjectContext = self.managedObjectContext;
        studentVC.userType = self.userType;
        studentVC.demoManagedObjectContext = self.demoManagedObjectContext;
    }
    else if ([segue.identifier isEqualToString:@"demoAddClassSegue"]){
        DemoAddStudentsViewController *addVC = (DemoAddStudentsViewController*)segue.destinationViewController;

        addVC.teacherObject = self.teacherObject;
        addVC.userType = self.userType;
        addVC.className=[self.enterClassName.classField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        addVC.managedObjectContext = _managedObjectContext;
        addVC.demoManagedObjectContext = _demoManagedObjectContext;
        
    }
    else if ([segue.identifier isEqualToString:@"demoStudentAccSegue"]){
        //students segue
        
        UITabBarController *tabbarC = (UITabBarController*)segue.destinationViewController;
        
        DemoAccountViewController *studentAccountVC = [tabbarC.viewControllers objectAtIndex:0];
        studentAccountVC.studentObj = [self.classesTableArrayStudentObject objectAtIndex:self.selectedStudentObjectIndexPath.row];
        studentAccountVC.userType = self.userType;
        studentAccountVC.demoManagedObjectContext = self.demoManagedObjectContext;
        studentAccountVC.managedObjectContext = self.managedObjectContext;
        
    
        DemoStoreViewController *storeVC = [tabbarC.viewControllers objectAtIndex:1];
        storeVC.studentObj = [self.classesTableArrayStudentObject objectAtIndex:self.selectedStudentObjectIndexPath.row];
        storeVC.userType = self.userType;
        storeVC.demoManagedObjectContext = self.demoManagedObjectContext;
        storeVC.managedObjectContext = self.managedObjectContext;

        
        DemoAnnounceViewController *annVC = [tabbarC.viewControllers objectAtIndex:2];
        annVC.studentObj = [self.classesTableArrayStudentObject objectAtIndex:self.selectedStudentObjectIndexPath.row];
        annVC.userType = self.userType;
        annVC.demoManagedObjectContext=self.demoManagedObjectContext;
        annVC.managedObjectContext = self.managedObjectContext;
    }
}

@end
