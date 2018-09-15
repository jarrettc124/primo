//
//  ClassTableViewController.m
//  TeacherApp
//
//  Created by Jarrett Chen on 3/18/14.
//  Copyright (c) 2014 Jarrett Chen. All rights reserved.
//


//tags are for classes and coins

//finish menu selection for students

#import "ClassTableViewController.h"

@interface ClassTableViewController ()

//Empty Views
@property (nonatomic,strong) UIButton *logoutButton;
@property (nonatomic,strong) UILabel *emptyLogoutButtonDirection;
@property (nonatomic,strong) NSString *emptySelectedActionSheet;

@property (nonatomic,strong) UITextField *changeNameField;
@property (nonatomic,strong) NSString *selectedClassNameForChangedName;
@property (nonatomic,strong) UIImageView *backgroundView;
@property (nonatomic,strong) NSString *typeOfDay;
@property (nonatomic,strong) UILabel *reachabilityLabel;
@property (nonatomic,strong) NSString *userType;
@property (nonatomic,strong) UIView *line1;
@property (nonatomic,strong) UIView *line2;
@property (nonatomic,strong) UIActivityIndicatorView *loadingView;
@property (nonatomic,strong) UILabel *loadingLabel;

//announcementViewController
@property (nonatomic,strong) NSMutableArray *signedInStudents;

//student's parameter
@property (nonatomic,strong) NSMutableArray *classesTableArray;
@property (nonatomic,strong) NSMutableArray *classesTableArrayTeacherObject;
@property (nonatomic,strong) NSMutableArray *classesTableArrayStudentObject;
@property (nonatomic,strong) NSIndexPath *selectedStudentObjectIndexPath;
@property (nonatomic) BOOL isEmpty;

//Teacher's parameters
@property (nonatomic) CGFloat teacherTextPosition;
@property (nonatomic,strong) NSLayoutConstraint* hiddenLabelState;

//Rename labels
@property (nonatomic,strong) UILabel *directionRename;


@end

@implementation ClassTableViewController

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
    
    self.navigationController.navigationBarHidden=NO;

    //set color for navigation bar

    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    [self.navigationItem setHidesBackButton:YES];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //set empty
    _isEmpty=NO;
    
    //Set background image
    self.backgroundView = [[UIImageView alloc] init];
    self.backgroundView.userInteractionEnabled=YES;
    [self.view addSubview:self.backgroundView];

    
    
    self.userType = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserType"];

    
    //loading Views
    self.loadingView = [[UIActivityIndicatorView alloc]init];
    self.loadingLabel = [[UILabel alloc]init];
    [self.loadingView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [_loadingLabel setFont:[UIFont systemFontOfSize:14]];
    [self.loadingView setAlpha:0];
    [self.loadingLabel setAlpha:0];
    [self.view addSubview:self.loadingView];
    [self.view addSubview:self.loadingLabel];
    
    
    CGFloat tHeight = 310;
    
    self.classesTable = [[UITableView alloc]init];
    self.classesTable.cellLayoutMarginsFollowReadableWidth = NO;

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
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        //Teacher's Name
        NSString *lastName = [userDefaults objectForKey:@"LastName"];
        if ([[userDefaults objectForKey:@"Gender"] isEqualToString:@"Male"]) {
            self.nameOfTeacher =[NSString stringWithFormat:@"Mr. %@",lastName];
        }
        else if ([[userDefaults objectForKey:@"Gender"] isEqualToString:@"Female"]){
            self.nameOfTeacher =[NSString stringWithFormat:@"Ms. %@",lastName];
        }
        else{
            self.nameOfTeacher = @"";
        }
        
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.nameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:40];
        self.nameLabel.numberOfLines=0;
        self.nameLabel.minimumScaleFactor=0.5;
        self.nameLabel.adjustsFontSizeToFitWidth=YES;
        [self.backgroundView addSubview:self.nameLabel];
        
        
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
        
        self.signedInStudents = [[NSMutableArray alloc]initWithCapacity:0];

        
        [self displayBackground];

        self.nameLabel.text = [NSString stringWithFormat:@"Good %@\n%@",self.typeOfDay, _nameOfTeacher];
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
        
        //Set frames for loading views
        self.loadingView.translatesAutoresizingMaskIntoConstraints=NO;
        self.loadingLabel.translatesAutoresizingMaskIntoConstraints=NO;
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.loadingView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:-50]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_loadingView(30)]-[_classesTable]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_loadingView,_classesTable)]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.loadingLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.loadingView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_loadingLabel(30)]-[_classesTable]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_loadingLabel,_classesTable)]];
        
        //horizontal
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_backgroundView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_backgroundView)]];

        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_classesTable]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_classesTable)]];
        
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[banner]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(banner)]];
        
        
        //vertical
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_backgroundView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_backgroundView)]];
        
        
        
        //information labels
        if ([self.userType isEqualToString:@"Teacher"]) {
            
            self.nameLabel.translatesAutoresizingMaskIntoConstraints=NO;
            
            self.totalCoins.translatesAutoresizingMaskIntoConstraints=NO;
            self.totalStudents.translatesAutoresizingMaskIntoConstraints=NO;
            self.totalSigned.translatesAutoresizingMaskIntoConstraints=NO;
            
            self.totalCoinsLabel.translatesAutoresizingMaskIntoConstraints=NO;
            self.totalStudentsLabel.translatesAutoresizingMaskIntoConstraints=NO;
            self.totalSignedUp.translatesAutoresizingMaskIntoConstraints=NO;
            
            self.line1.translatesAutoresizingMaskIntoConstraints=NO;
            self.line2.translatesAutoresizingMaskIntoConstraints=NO;
            
            //Horizontal
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-96-[_nameLabel]" options:NSLayoutFormatAlignAllLeft metrics:nil views:NSDictionaryOfVariableBindings(_nameLabel)]];
            
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
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-108-[_nameLabel(80)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_nameLabel)]];
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_totalStudentsLabel]-50-[banner(6)]-0-[_classesTable]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_totalStudentsLabel,banner,_classesTable)]];
            
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_line1(50)]-90-[banner]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_line1,banner)]];
            
            
            //fonts
            self.nameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:43];
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
        [self.loadingView setFrame:CGRectMake(self.view.frame.size.width/2-75, 270, 30, 30)];
        [self.loadingLabel setFrame:CGRectMake(self.view.frame.size.width/2-40,270, 150, 30)];
        
        if ([_userType isEqualToString:@"Teacher"]) {
            
            [self.nameLabel setFrame:CGRectMake(self.backgroundView.frame.origin.x+44,self.backgroundView.frame.origin.y+70,self.backgroundView.frame.size.width-45, 50)];
            
            //labels right here
            self.teacherTextPosition=280;
            [self.line1 setFrame:CGRectMake((self.backgroundView.frame.size.width/3)-0.5, self.teacherTextPosition-70, 1, 25)];
            [self.line2 setFrame:CGRectMake((self.backgroundView.frame.size.width*2/3)-0.5, self.teacherTextPosition-70, 1, 25)];
            
            [self.totalCoinsLabel setFrame:CGRectMake((self.backgroundView.frame.size.width/6)-(self.backgroundView.frame.size.width/6),self.teacherTextPosition-50,(self.backgroundView.frame.size.width/3), 40)];
            [self.totalStudentsLabel setFrame:CGRectMake((self.backgroundView.frame.size.width/2)-(self.backgroundView.frame.size.width/3)/2,self.teacherTextPosition-50 ,(self.backgroundView.frame.size.width/3), 40)];
            [self.totalSignedUp setFrame:CGRectMake((self.backgroundView.frame.size.width*2/3),self.teacherTextPosition-50,(self.backgroundView.frame.size.width/3), 40)];
            
            
            self.totalCoins.frame = CGRectMake((self.backgroundView.frame.size.width/6)-(self.backgroundView.frame.size.width/6)+10,self.totalCoinsLabel.frame.origin.y-55,(self.backgroundView.frame.size.width/3)-20, 55);
            
            self.totalStudents.frame = CGRectMake((self.backgroundView.frame.size.width/2)-(self.backgroundView.frame.size.width/3)/2+10,self.totalCoinsLabel.frame.origin.y-55,(self.backgroundView.frame.size.width/3)-20, 55);
            
            self.totalSigned.frame = CGRectMake((self.backgroundView.frame.size.width*2/3)+10,self.totalCoinsLabel.frame.origin.y-55,(self.backgroundView.frame.size.width/3)-20, 55);
            
            
            self.nameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
            self.totalCoinsLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
            self.totalStudentsLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
            self.totalSignedUp.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
            self.totalCoins.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:53];
            self.totalStudents.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:53];
            self.totalSigned.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:53];

        }
        else {
            //students iphone
            
            [self.totalStudentCoins setFrame:CGRectMake((self.view.frame.size.width/2)-80,85, 160, 80)];
            [self.totalStudentCoinsLabel setFrame:CGRectMake((self.view.frame.size.width/2)-75,self.totalStudentCoins.frame.origin.y+self.totalStudentCoins.frame.size.height+14, 150,60)];
            
            UIImage *bannerImage = [UIImage imageNamed:@"MonthBanner"];
            UIImageView *bannerView = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width/2)-bannerImage.size.width/2,self.totalStudentCoinsLabel.frame.origin.y-8, bannerImage.size.width, bannerImage.size.height)];
            [bannerView setTag:100];
            [bannerView setImage:bannerImage];
            bannerView.userInteractionEnabled=YES;
            [self.view addSubview:bannerView];
            
        }

    }

}


-(void)hideKeyboard{
    [self.view endEditing:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //Notification
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuSelection) name:@"menuButtonAction" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(refreshTheInfoMethod) name: UIApplicationDidBecomeActiveNotification object: nil];
    
    
    [self.totalCoins setAlpha:0];
    [self.totalSigned setAlpha:0];
    [self.totalStudents setAlpha:0];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self studentInfo];
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
            
            self.nameLabel.textColor = [UIColor whiteColor];
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
            self.nameLabel.textColor = [UIColor whiteColor];
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
            self.nameLabel.textColor = [UIColor blackColor];
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
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

-(void)emptyClassView{
    
    if (_isEmpty) {
        UIImageView *blackboardBorder = (UIImageView*)[self.view viewWithTag:1000];
        BouncingPencil *bouncePencil = (BouncingPencil*)[self.view viewWithTag:2000];
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [blackboardBorder setAlpha:0];
            [blackboardBorder setTransform:CGAffineTransformMakeScale(10/9, 10/9)];
        } completion:^(BOOL finished) {
            [bouncePencil setTag:0];
            [blackboardBorder setTag:0];
            [bouncePencil removeFromSuperview];
            [blackboardBorder removeFromSuperview];
        }];
    }
    else{
        _isEmpty=YES;
    }
    
    UIImageView *tutorialbackground = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"blackboardBorder"]];
    [tutorialbackground setTag:1000];
    [tutorialbackground setAlpha:0];
    [self.view addSubview:tutorialbackground];

    tutorialbackground.translatesAutoresizingMaskIntoConstraints=NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[tutorialbackground(280)]-20-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tutorialbackground)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-100-[tutorialbackground(170)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tutorialbackground)]];
        
        
        //Set bouncing pencil
        BouncingPencil *pencilArrow = [[BouncingPencil alloc]init];
        [pencilArrow setTag:2000];
        [self.view addSubview:pencilArrow];
        
        pencilArrow.translatesAutoresizingMaskIntoConstraints=NO;
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-45-[pencilArrow(60)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(pencilArrow)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[pencilArrow(60)]-50-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(pencilArrow)]];
        [pencilArrow setUpPencilBounceForiPad:CGSizeMake(60, 60) targetX:15 targetY:-9 rotation:5*M_PI_4];
        
//    }

    CGAffineTransform transform = CGAffineTransformMakeScale(0.9, 0.9);
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        [tutorialbackground setAlpha:1];
        [tutorialbackground setTransform:transform];
        
    } completion:^(BOOL finished) {
        UILabel *tutorialLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, tutorialbackground.frame.size.width-40, tutorialbackground.frame.size.height-10)];
        [tutorialLabel setFont:[UIFont fontWithName:@"Eraser" size:18]];
        [tutorialLabel setTextColor:[UIColor whiteColor]];
        [tutorialLabel setNumberOfLines:0];
        if ([self.userType isEqualToString:@"Teacher"]) {
            [tutorialLabel setText:@"Let's begin by adding a new class.\n\nClick on your menu!"];
        }
        else{
            [tutorialLabel setText:@"Let's begin by joining your teacher's class!"];
        }
        [tutorialbackground addSubview:tutorialLabel];
        
    }];
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

            [self performSegueWithIdentifier:@"tabbarseg" sender:self];
        }
        else{
            
            self.selectedStudentObjectIndexPath = indexPath;
            
            [self performSegueWithIdentifier:@"studentTabBarSegue" sender:self];
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

-(void)refreshTheInfoMethod{
    
            NSString *objId = [[NSUserDefaults standardUserDefaults] objectForKey:@"ObjectId"];
    
    //refresh the background
    [self displayBackground];
    
    if ([_userType isEqualToString:@"Teacher"]) {
        
        //Update the info database
        NSError *error;
        NSFetchRequest *studentsRequest = [NSFetchRequest fetchRequestWithEntityName:@"StudentObject"];
        studentsRequest.predicate= [NSPredicate predicateWithFormat:@"teacher = %@",objId];
        NSArray *studentObjArray = [_managedObjectContext executeFetchRequest:studentsRequest error:&error];
        NSLog(@"Amount of students in database: %d",[studentObjArray count]);
        [self updateDatabaseInformation:studentObjArray];
        
    }
    else{
        NSLog(@"ddddd");
        [self updateDatabaseInformation:nil];
    }
    
}

//student Info starts here
-(void)classesListFromParse{
    NSString *objId = [[NSUserDefaults standardUserDefaults] objectForKey:@"ObjectId"];
    if ([self.userType isEqualToString:@"Teacher"]) {
        
        //Get classesListArray for table
        NSError*error;
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"TeacherObject"];
        request.predicate=[NSPredicate predicateWithFormat:@"teacherId = %@",objId];
        NSArray *teacherObjArray = [_managedObjectContext executeFetchRequest:request error:&error];
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
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"StudentObject"];
        request.predicate=[NSPredicate predicateWithFormat:@"taken = %@",objId];
        NSSortDescriptor *nameSort = [[NSSortDescriptor alloc] initWithKey:@"objectId" ascending:YES];
        request.sortDescriptors = [NSArray arrayWithObjects:nameSort, nil];
        NSArray *studentObjArrayInCore = [_managedObjectContext executeFetchRequest:request error:&error];
        
        self.classesTableArray = [[NSMutableArray alloc]initWithCapacity:[studentObjArrayInCore count]];
        self.classesTableArrayTeacherObject = [[NSMutableArray alloc]initWithCapacity:[studentObjArrayInCore count]];
        self.classesTableArrayStudentObject = [[NSMutableArray alloc]initWithCapacity:[studentObjArrayInCore count]];
        
        if ([studentObjArrayInCore count]) {
            //Iterate through every student in core
            for (StudentObject* studentObj in studentObjArrayInCore) {
                NSLog(@"Student in Core: %@", studentObj.studentName);
                
                //Find teacher object with teacherId
                NSError*error;
                NSFetchRequest *teacherRequest = [NSFetchRequest fetchRequestWithEntityName:@"TeacherObject"];
                teacherRequest.predicate=[NSPredicate predicateWithFormat:@"teacherId = %@",studentObj.teacher];
                NSArray *teacherObjArray = [_managedObjectContext executeFetchRequest:teacherRequest error:&error];
                
                if ([teacherObjArray count]==1) {
                    TeacherObject *teacherObj = [teacherObjArray firstObject];
                    NSLog(@"teacher %@",teacherObj.teacherName);
                    [self.classesTableArrayTeacherObject addObject:teacherObj];
                    [self.classesTableArray addObject:[studentObj.nameOfclass capitalizedString]];

                }
                
                [self.classesTableArrayStudentObject addObject:studentObj];
            }
            
        }
    }
}

-(void)updateClassTable{
            NSString *objId = [[NSUserDefaults standardUserDefaults] objectForKey:@"ObjectId"];
    
    [self.loadingLabel setText:@"Updating Class..."];
    
    if (![self.typeOfDay isEqualToString:@"Afternoon"]) {
        [self.loadingLabel setTextColor:[UIColor colorWithWhite:0.7 alpha:1]];
    }
    
    if ([self.userType isEqualToString:@"Teacher"]) {
        
        //Query it from the Database
        QueryWebService *query = [[QueryWebService alloc]initWithTable:@"TeacherObject"];
        [query selectColumnWhere:@"teacherId" equalTo:objId];
        [query findAllObjectsInRowWithCompletion:^(NSError *error, NSArray *rows) {
            
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [_loadingView stopAnimating];
                [_loadingView setAlpha:0];
                [_loadingLabel setAlpha:0];
            } completion:nil];
        
            
            if (error){
                
                if (self.reachabilityLabel ==nil) {
                    
                    self.reachabilityLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, 290, self.view.frame.size.width,20)];
                    [self.reachabilityLabel setBackgroundColor:[UIColor redColor]];
                    [self.reachabilityLabel setTextColor:[UIColor whiteColor]];
                    [self.reachabilityLabel setText:@"No Internet Connection"];
                    [self.view addSubview:self.reachabilityLabel];
                }

            }
            else{
                
                //Remove the label if it's showing
                if (self.reachabilityLabel !=nil) {
                    [self.reachabilityLabel removeFromSuperview];
                    self.reachabilityLabel=nil;
                }
                if ([rows count]==0){
                    
                    if (_teacherObject !=nil) {
                        [_managedObjectContext deleteObject:_teacherObject];
                    }
                    
                    [self.classesTableArray removeAllObjects];
                    [self.classesTable reloadData];

                    [self emptyClassView];
                    
                }
                else{
                    
                    //Dictionary of teacher
                    NSDictionary *teacherObj = [rows firstObject];
                    
                    _teacherObject = [TeacherObject findTeacherObjectInCoreWithDictionary:teacherObj inManagedObjectContext:_managedObjectContext];
                    _teacherObject.classList = teacherObj[@"ClassList"];
                    _teacherObject.teacherName = teacherObj[@"teacherName"];
                    [_managedObjectContext save:nil];
                    
                    
                    NSString *jsonStringArray = _teacherObject.classList;
                    NSData *data = [jsonStringArray dataUsingEncoding:NSUTF8StringEncoding];
                    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                    
                    //if class list is empty
                    if ([jsonArray count] == 0) {
                        [self.classesTableArray removeAllObjects];
                        [self.classesTable reloadData];
                        
                        [self emptyClassView];
                    }
                    else{
                        [self.classesTableArray removeAllObjects];
                        [self.classesTableArray addObjectsFromArray:jsonArray];
                        [self.classesTable reloadData];
                    }
                }

            }

        }];
    }
    else{
        
        //Query and input it from the Database. Combine Tables
        QueryWebService *query = [[QueryWebService alloc]initWithTable:@"StudentObject, TeacherObject"];
        [query selectColumnWhere:@"StudentObject.taken" equalTo:objId];
        [query selectColumnWhere:@"StudentObject.teacher" equalToNonStringValue:@"TeacherObject.teacherId"];
        [query orderByAscendingForColumn:@"StudentObject.objectId"];
        [query findAllObjectsInRowWithCompletion:^(NSError *error, NSArray *rows) {

            if (!error) {
                
                //If reachability label is showing, remove it
                if (self.reachabilityLabel !=nil) {
                    [self.reachabilityLabel removeFromSuperview];
                    self.reachabilityLabel=nil;
                }
                
                [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    [_loadingView stopAnimating];
                    [_loadingView setAlpha:0];
                    [_loadingLabel setAlpha:0];
                } completion:nil];
                
                //Check to see if the teacher deleted the class object. delete the teacher object and student object from core data
                if ([rows count] < [self.classesTableArrayStudentObject count]) {
                    
                    for (StudentObject *studentObj in self.classesTableArrayStudentObject) {
                        NSArray *filteredarray = [rows filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(objectId = %@)",studentObj.objectId]];
                        
                        if ([filteredarray count]==0) {
                            //Can't find the objectId, so delete the teacher and student object id
                            
                            //Find teacher object with teacherId
                            NSError*error;
                            NSFetchRequest *teacherRequest = [NSFetchRequest fetchRequestWithEntityName:@"TeacherObject"];
                            teacherRequest.predicate=[NSPredicate predicateWithFormat:@"teacherId = %@",studentObj.teacher];
                            NSArray *teacherObjArray = [_managedObjectContext executeFetchRequest:teacherRequest error:&error];
                            if ([teacherObjArray count]==1) {
                                TeacherObject *teacherObj = [teacherObjArray firstObject];
                                NSLog(@"DELETE Teacherobject %@",teacherObj.teacherId);
                                [_managedObjectContext deleteObject:teacherObj];
                            }
                            NSLog(@"DELETE Studentobject %@",studentObj.objectId);
                            [_managedObjectContext deleteObject:studentObj];
                        }
                    }
                    
                    [_managedObjectContext save:nil];
                }

                //Clear all the table arrays first
                [self.classesTableArray removeAllObjects];
                [self.classesTableArrayTeacherObject removeAllObjects];
                [self.classesTableArrayStudentObject removeAllObjects];
                
                //iterate to obtain the names
                for (NSDictionary* studentAndTeacherDict in rows) {
                    
                    NSDictionary * teacherDict = @{@"ObjectId": studentAndTeacherDict[@"ObjectId"],
                                                   @"ClassList": studentAndTeacherDict[@"ClassList"],
                                                   @"teacherId": studentAndTeacherDict[@"teacherId"],
                                                   @"teacherName": studentAndTeacherDict[@"teacherName"]};
                    TeacherObject *teacherObj = [TeacherObject findTeacherObjectInCoreWithDictionary:teacherDict inManagedObjectContext:_managedObjectContext];
                    teacherObj.teacherName = studentAndTeacherDict[@"teacherName"];
                    teacherObj.classList = studentAndTeacherDict[@"ClassList"];
                    teacherObj.teacherName = studentAndTeacherDict[@"teacherName"];
                    teacherObj.teacherId = studentAndTeacherDict[@"teacherId"];
                    
                    NSDictionary *studentDict = @{@"objectId": studentAndTeacherDict[@"objectId"],
                                                  @"studentName": studentAndTeacherDict[@"studentName"], @"studentNumber":studentAndTeacherDict[@"studentNumber"],
                                                  @"coins": studentAndTeacherDict[@"coins"],
                                                  @"className":studentAndTeacherDict[@"className"],
                                                  @"teacher":studentAndTeacherDict[@"teacher"],
                                                  @"taken":studentAndTeacherDict[@"taken"],
                                                  @"teacherEmail":studentAndTeacherDict[@"teacherEmail"]};
                    StudentObject *studentObj = [StudentObject createStudentObjectInCoreWithDictionary:studentDict inManagedObjectContext:_managedObjectContext];
                    studentObj.nameOfclass=studentAndTeacherDict[@"className"];
                    studentObj.studentName = studentAndTeacherDict[@"studentName"];
                    studentObj.teacher =studentAndTeacherDict[@"teacher"];
                    NSNumber *studentNum = studentAndTeacherDict[@"coins"];
                    int studentInt = [studentNum intValue];
                    studentObj.studentNumber = [NSNumber numberWithInt:studentInt];
                    NSNumber *studentCoinNum = studentAndTeacherDict[@"coins"];
                    int studentCoinInt = [studentCoinNum intValue];
                    studentObj.coins = [NSNumber numberWithInt:studentCoinInt];
                    studentObj.taken = studentAndTeacherDict[@"taken"];
                    studentObj.teacherEmail = studentAndTeacherDict[@"teacherEmail"];
                    
                    [self.classesTableArray addObject:[studentAndTeacherDict[@"className"] capitalizedString]];
                    [self.classesTableArrayTeacherObject addObject:teacherObj];
                    [self.classesTableArrayStudentObject addObject:studentObj];
                }
                [_managedObjectContext save:nil];
                [self.classesTable reloadData];
                
                //if its empty clear it
                if ([rows count] == 0) {
                    [self emptyClassView];
                }

            }
            else{
                
                if (self.reachabilityLabel ==nil) {
                    
                    self.reachabilityLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, 290, self.view.frame.size.width,20)];
                    [self.reachabilityLabel setBackgroundColor:[UIColor redColor]];
                    [self.reachabilityLabel setTextColor:[UIColor whiteColor]];
                    [self.reachabilityLabel setText:@"No Internet Connection"];
                    [self.view addSubview:self.reachabilityLabel];
                }
            }
        }];

    }
    
}

-(void)studentInfo{
    
    NSString *objId = [[NSUserDefaults standardUserDefaults] objectForKey:@"ObjectId"];
    
    if ([self.userType isEqualToString:@"Teacher"]) {
        
        [self.signedInStudents removeAllObjects];
        //Show data from Database first
        NSError *error;
        NSFetchRequest *studentsRequest = [NSFetchRequest fetchRequestWithEntityName:@"StudentObject"];
        studentsRequest.predicate= [NSPredicate predicateWithFormat:@"teacher = %@",objId];
        NSArray *studentObjArray = [_managedObjectContext executeFetchRequest:studentsRequest error:&error];
        
        if (!error) {
            int totalIntCoins=0;
            int totalIntStudents = (int)[studentObjArray count];
            for (StudentObject *studentObject in studentObjArray){
                
                totalIntCoins+=[studentObject.coins intValue];
                
                if (![studentObject.taken isEqualToString:@""]) {
                    [self.signedInStudents addObject:studentObject];

                }
            }
            
            self.totalCoins.text = [NSString stringWithFormat:@"%d",totalIntCoins];
            self.totalStudents.text = [NSString stringWithFormat:@"%d",totalIntStudents];
            self.totalSigned.text = [NSString stringWithFormat:@"%d",[self.signedInStudents count]];
            

            [self.totalCoins setCenter:CGPointMake(self.totalCoins.center.x, self.totalCoins.center.y-20)];
            [self.totalStudents setCenter:CGPointMake(self.totalStudents.center.x, self.totalStudents.center.y-20)];
            [self.totalSigned setCenter:CGPointMake(self.totalSigned.center.x, self.totalSigned.center.y-20)];
            
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
                    [self.totalCoins setCenter:CGPointMake(self.totalCoins.center.x, self.totalCoins.center.y+20)];
                    [self.totalStudents setCenter:CGPointMake(self.totalStudents.center.x, self.totalStudents.center.y+20)];
                    [self.totalSigned setCenter:CGPointMake(self.totalSigned.center.x, self.totalSigned.center.y+20)];
                    [self.totalCoins setAlpha:1];
                    [self.totalStudents setAlpha:1];
                    [self.totalSigned setAlpha:1];
                }
                
            } completion:^(BOOL finished) {
                
                
                
                
                //set button after everything is set
                self.navigationItem.rightBarButtonItem=self.menuButton;
                
                //we can use this to fetch from database to update
                [self classesListFromParse];
                [self.classesTable reloadData];
                NSLog(@"asdfadsfa");
                [self updateDatabaseInformation:studentObjArray];
                
            }];
        }
        
    }
    else{
        
        //Show data from Database first
        NSError *error;
        NSFetchRequest *studentsRequest = [NSFetchRequest fetchRequestWithEntityName:@"StudentObject"];
        studentsRequest.predicate= [NSPredicate predicateWithFormat:@"taken = %@",objId];
        NSArray *studentObjArray = [_managedObjectContext executeFetchRequest:studentsRequest error:&error];
        
        if (!error) {
            
            int totalIntCoins = 0;
            
            for (StudentObject *studentObj in studentObjArray){
                
                totalIntCoins+=[studentObj.coins intValue];
                
            }
            
            self.totalStudentCoins.text = [NSString stringWithFormat:@"%d",totalIntCoins];
            
            
            [self.totalStudentCoins setCenter:CGPointMake(self.totalStudentCoins.center.x, self.totalStudentCoins.center.y-20)];
            
            //animate views
            [self.view layoutIfNeeded];
            [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                
                if (IS_IPAD) {
                    self.hiddenLabelState.constant=0;
                    [self.totalStudentCoins setAlpha:1];
                    [self.view layoutIfNeeded];
                }
                else{

                    [self.totalStudentCoins setCenter:CGPointMake(self.totalStudentCoins.center.x, self.totalStudentCoins.center.y+20)];
                    
                    [self.totalStudentCoins setAlpha:1];

                }
                
                
            } completion:^(BOOL finished) {
                //get the classes of student and parents
                self.navigationItem.rightBarButtonItem= self.studentAddClassButton;
                [self classesListFromParse];
                [self.classesTable reloadData];
                //set button after everything is set
                [self updateDatabaseInformation:studentObjArray];
                
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
    

    TeacherObject *teacherObj = [self.classesTableArrayTeacherObject objectAtIndex:indexPath.row];
    
    cell.detailTextLabel.text = teacherObj.teacherName;
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
    
    if (_isEmpty) {
        UIImageView *blackboardBorder = (UIImageView*)[self.view viewWithTag:1000];
        BouncingPencil *bouncePencil = (BouncingPencil*)[self.view viewWithTag:2000];
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [blackboardBorder setAlpha:0];
            [blackboardBorder setTransform:CGAffineTransformMakeScale(10/9, 10/9)];
        } completion:^(BOOL finished) {
            [bouncePencil setTag:0];
            [blackboardBorder setTag:0];
            [bouncePencil removeFromSuperview];
            [blackboardBorder removeFromSuperview];
        }];
     }
    
    
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
            [self.totalCoins setAlpha:0];
            [self.totalCoinsLabel setAlpha:0];
            [self.totalStudents setAlpha:0];
            [self.totalStudentsLabel setAlpha:0];
            [self.totalSigned setAlpha:0];
            [self.totalSignedUp setAlpha:0];
            [self.nameLabel setAlpha:0];
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
        
        if (_isEmpty) {
            

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
            [self.nameLabel removeFromSuperview];
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
        
        if (_isEmpty) {
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
        [self.backgroundView addSubview:self.nameLabel];
    }
    else{
        [self.backgroundView addSubview:self.totalStudentCoinsLabel];
    }
}

//cancel button for menu
-(void)cancelButtonAction{
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
            [self.nameLabel setAlpha:1];
            
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
                
                if (self.reachabilityLabel !=nil) {
                    self.navigationItem.rightBarButtonItem.enabled=NO;
                }
                
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
                
                if (self.reachabilityLabel !=nil) {
                    self.navigationItem.rightBarButtonItem.enabled=NO;
                }
            }];
            
        }
        
    }
    else if(IS_IPHONE){
        
        if ([self.userType isEqualToString:@"Teacher"]) {
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
            [self.view addSubview:self.nameLabel];
            
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
                
                if (self.reachabilityLabel !=nil) {
                    self.navigationItem.rightBarButtonItem.enabled=NO;
                }
                
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
                
                if (self.reachabilityLabel !=nil) {
                    self.navigationItem.rightBarButtonItem.enabled=NO;
                }
            }];
            
        }
    }
    
    //add Backgrounds again
    if (_isEmpty) {
        BouncingPencil *bouncePencil = (BouncingPencil*)[self.view viewWithTag:2000];
        [bouncePencil setTag:0];
        [bouncePencil removeFromSuperview];
        
        [self emptyClassView];
    }
}


//menu selection code
-(void)menuSelection{
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

    if (_isEmpty) {
        BouncingPencil *bouncePencil = (BouncingPencil*)[self.view viewWithTag:2000];
        [bouncePencil setTag:0];
        [bouncePencil removeFromSuperview];
        
        if (![self.userType isEqualToString:@"Teacher"]) {
            UIImageView *blackboard = (UIImageView*)[self.view viewWithTag:1000];
            
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                [blackboard setAlpha:0];
                [blackboard setTransform:CGAffineTransformMakeScale(10/9, 10/9)];
                
            } completion:^(BOOL finished) {
                [blackboard setTag:0];
                [blackboard removeFromSuperview];
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
                
//                if (_isEmpty) {
//                    self.emptyAddButtonDirection.alpha =0;
//                    self.emptyLogoutButtonDirection.alpha=0;
//                    self.emptyDeleteButtonDirection.alpha=0;
//                }
                
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
    NSString *objId = [[NSUserDefaults standardUserDefaults] objectForKey:@"ObjectId"];

    if ([self.userType isEqualToString:@"Teacher"]) {
        //save the classname and move to the next vc which is the add student
        if ([self.enterClassName.classField.text isEqualToString:@""]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Oh No! Your textfield is empty" message:@"Make sure you enter the name of your new class in the textfield" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:alertAction];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        }
        else{

            NSError *error;
            NSData *data = [_teacherObject.classList dataUsingEncoding:NSUTF8StringEncoding];
            if (data) {
                
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
                    return;
                }
            

            }
            [self hideClassViewAction];
            
            
            [self performSegueWithIdentifier:@"studentclassseg" sender:self];
            
        }
    }
    else{
        [self.view endEditing:YES];
        
        self.navigationItem.rightBarButtonItem.enabled=NO;
        UIView *loadingView = [[UIView alloc]initWithFrame:self.view.frame];
        loadingView.backgroundColor = [UIColor blackColor];
        loadingView.alpha=0.5;
        [self.view addSubview:loadingView];
        
        UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-50, (self.view.frame.size.height-64)/2, 30, 30)];
        [self.view addSubview:loading];
        [loading setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [loading hidesWhenStopped];
        [loading startAnimating];
        
        
        UILabel *loadingLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-20,(self.view.frame.size.height-64)/2, 70, 30)];
        [loadingLabel setText:@"Searching for you..."];
        [loadingLabel setFont:[UIFont systemFontOfSize:14]];
        [loadingLabel setTextColor:[UIColor lightGrayColor]];
        [self.view addSubview:loadingLabel];

        
        NSString *lowerEmail = [self.enterClassName.teachEmailField.text lowercaseString];
        NSString *lowerClassName = [self.enterClassName.classField.text lowercaseString];
    
        //fix
        NSString *capUsername = [self.enterClassName.usernameField.text capitalizedString];
        
        //trim white spaces
        lowerEmail = [lowerEmail stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        lowerClassName = [lowerClassName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        capUsername = [capUsername stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        
        QueryWebService *query = [[QueryWebService alloc]initWithTable:@"StudentObject, TeacherObject"];
        [query selectColumnWhere:@"StudentObject.teacherEmail" equalTo:lowerEmail];
        [query selectColumnWhere:@"StudentObject.className" equalTo:lowerClassName];
        [query selectColumnWhere:@"StudentObject.studentName" equalTo:capUsername];
        [query selectColumnWhere:@"StudentObject.teacher" equalToNonStringValue:@"TeacherObject.teacherId"];
        [query findAllObjectsInRowWithCompletion:^(NSError *error, NSArray *rows) {
            
            if (!error) {
                
                if (self.reachabilityLabel !=nil) {
                    [self.reachabilityLabel removeFromSuperview];
                    self.reachabilityLabel=nil;
                }
            
            
                if (!rows || [rows count]!=1) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Can't find you in the class" message:@"Make sure your information is correct" delegate:self cancelButtonTitle:@"Try Again" otherButtonTitles:nil];
                    [alert show];
                    
                    [loading removeFromSuperview];
                    [loadingLabel removeFromSuperview];
                    [loadingView removeFromSuperview];
                    self.navigationItem.rightBarButtonItem.enabled=YES;
                }
                else{
                    NSDictionary *studentAndTeacherDict = [rows firstObject];
                    
                    NSLog(@"students taken: %@",studentAndTeacherDict[@"taken"]);
                                                 
                    if ([studentAndTeacherDict[@"taken"] isEqualToString:@""]) {
                        NSLog(@"students taken inside: %@",studentAndTeacherDict[@"taken"]);

                        UpdateWebService *updateTaken = [[UpdateWebService alloc]initWithTable:@"StudentObject"];
                        [updateTaken setRowToUpdateWhereColumn:@"taken" equalTo:objId];
                        [updateTaken setRowToUpdateWhereColumn:@"signedIn" equalTo:@"1"];
                        [updateTaken selectRowToUpdateWhereColumn:@"objectId" equalTo:studentAndTeacherDict[@"objectId"]];
                        [updateTaken saveUpdate];
                        
                        LogWebService *logService = [[LogWebService alloc]initWithLogType:@"class_logs"];
                        [logService updateLogWithUserId:studentAndTeacherDict[@"objectId"] className:lowerClassName updateLogString:[NSString stringWithFormat:@"%@ has signed up for %@",studentAndTeacherDict[@"studentName"],[lowerClassName capitalizedString]]];
                        
                        [logService updateLogWithUserId:studentAndTeacherDict[@"teacher"] className:lowerClassName updateLogString:[NSString stringWithFormat:@"%@ has signed up for %@",studentAndTeacherDict[@"studentName"],[lowerClassName capitalizedString]]];
                        
                        PushWebService *pushToTeacher = [[PushWebService alloc]init];
                        [pushToTeacher sendPushToUserIDS:@[studentAndTeacherDict[@"teacher"]] pushMessage:[NSString stringWithFormat:@"%@ has signed up for %@",studentAndTeacherDict[@"studentName"],[lowerClassName capitalizedString]]];

                        //Create Core data objects
                        NSDictionary * teacherDict = @{@"ObjectId": studentAndTeacherDict[@"ObjectId"],
                                                       @"ClassList": studentAndTeacherDict[@"ClassList"],
                                                       @"teacherId": studentAndTeacherDict[@"teacherId"],
                                                       @"teacherName": studentAndTeacherDict[@"teacherName"]};
                        
                        [TeacherObject findTeacherObjectInCoreWithDictionary:teacherDict inManagedObjectContext:_managedObjectContext];
                        
                        NSDictionary *studentDict = @{@"objectId": studentAndTeacherDict[@"objectId"],
                                                      @"studentName": studentAndTeacherDict[@"studentName"], @"studentNumber":studentAndTeacherDict[@"studentNumber"],
                                                      @"coins": studentAndTeacherDict[@"coins"],
                                                      @"className":studentAndTeacherDict[@"className"],
                                                      @"teacher":studentAndTeacherDict[@"teacher"],
                                                      @"taken":objId,
                                                      @"teacherEmail":studentAndTeacherDict[@"teacherEmail"]};
                        
                        StudentObject *studentObj = [StudentObject createStudentObjectInCoreWithDictionary:studentDict inManagedObjectContext:_managedObjectContext];
                        studentObj.taken =objId;
                        
                        [_managedObjectContext save:nil];

                        
                        //Find Students from datacore in order to sort
                        NSError *error;
                        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"StudentObject"];
                        request.predicate=[NSPredicate predicateWithFormat:@"taken = %@",objId];
                        NSSortDescriptor *nameSort = [[NSSortDescriptor alloc] initWithKey:@"objectId" ascending:YES];
                        request.sortDescriptors = [NSArray arrayWithObjects:nameSort, nil];
                        NSArray *studentObjArrayInCore = [_managedObjectContext executeFetchRequest:request error:&error];
                        
                        
                        [self.classesTableArray removeAllObjects];
                        [self.classesTableArrayTeacherObject removeAllObjects];
                        [self.classesTableArrayStudentObject removeAllObjects];
                        
                        if ([studentObjArrayInCore count]) {
                            //Iterate through every student in core
                            for (StudentObject* studentObj in studentObjArrayInCore) {
                                //Find teacher object with teacherId
                                NSError*error;
                                NSFetchRequest *teacherRequest = [NSFetchRequest fetchRequestWithEntityName:@"TeacherObject"];
                                teacherRequest.predicate=[NSPredicate predicateWithFormat:@"teacherId = %@",studentObj.teacher];
                                NSArray *teacherObjArray = [_managedObjectContext executeFetchRequest:teacherRequest error:&error];
                                if ([teacherObjArray count]==1) {
                                    TeacherObject *teacherObj = [teacherObjArray firstObject];
                                    [self.classesTableArrayTeacherObject addObject:teacherObj];
                                }
                                
                                [self.classesTableArrayStudentObject addObject:studentObj];
                                [self.classesTableArray addObject:[studentObj.nameOfclass capitalizedString]];
                            }
                            
                            [self.classesTable reloadData];
                            
                            //Update the student's table
                            int totalIntCoins = [self.totalStudentCoins.text intValue];
                            totalIntCoins+=[studentObj.coins intValue];
                            self.totalStudentCoins.text = [NSString stringWithFormat:@"%d",totalIntCoins];
                        
                            [self hideClassViewAction];
                            
                            if (_isEmpty) {
                                
                                _isEmpty=NO;
                                
                                [self.navigationItem setLeftBarButtonItem:nil];
                                
                                
                                UIImageView *blackboard = (UIImageView*)[self.view viewWithTag:1000];
                                
                                [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                                    
                                    [blackboard setAlpha:0];
                                    [blackboard setTransform:CGAffineTransformMakeScale(10/9, 10/9)];
                                    
                                } completion:^(BOOL finished) {
                                    [blackboard setTag:0];
                                    [blackboard removeFromSuperview];
                                    
                                    BouncingPencil *bouncePencil = (BouncingPencil*)[self.view viewWithTag:2000];
                                    [bouncePencil setTag:0];
                                    [bouncePencil removeFromSuperview];
                                }];
                            }
                        }
                    }
                    else{
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uh Oh!" message:@"That name has already been taken by another classmate. Did you enter the information correctly?" delegate:self cancelButtonTitle:@"Try Again" otherButtonTitles:nil];
                        [alert show];
                        
                        [loading removeFromSuperview];
                        [loadingLabel removeFromSuperview];
                        [loadingView removeFromSuperview];
                        self.navigationItem.rightBarButtonItem.enabled=YES;
   
                    }
                }
            }
            else{
                
                if (self.reachabilityLabel ==nil) {
                    
                    self.reachabilityLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, 290, self.view.frame.size.width,20)];
                    [self.reachabilityLabel setBackgroundColor:[UIColor redColor]];
                    [self.reachabilityLabel setTextColor:[UIColor whiteColor]];
                    [self.reachabilityLabel setText:@"No Internet Connection"];
                    [self.view addSubview:self.reachabilityLabel];
                }
            }
            
            //remove loading view
            [loading removeFromSuperview];
            [loadingLabel removeFromSuperview];
            [loadingView removeFromSuperview];
            self.navigationItem.rightBarButtonItem.enabled=YES;
        }];
    }
}
-(void)addNewClassToDatabaseClassName:(NSString *)className{
    NSString *objId = [[NSUserDefaults standardUserDefaults] objectForKey:@"ObjectId"];

    [self.classesTableArray addObject:className];
    
    NSError *error;
    NSData *jsonDataArray = [NSJSONSerialization dataWithJSONObject:_classesTableArray options:0 error:&error];
    NSString *JSONStringArray = [[NSString alloc] initWithData:jsonDataArray encoding:NSUTF8StringEncoding];
    
    UpdateWebService *updateService = [[UpdateWebService alloc]initWithTable:@"TeacherObject"];
    [updateService setRowToUpdateWhereColumn:@"ClassList" equalTo:JSONStringArray];
    [updateService selectRowToUpdateWhereColumn:@"teacherId" equalTo:objId];
    [updateService saveUpdate];
    
    LogWebService *logService = [[LogWebService alloc]initWithLogType:@"class_logs"];
    [logService updateLogWithUserId:objId className:className updateLogString:[NSString stringWithFormat:@"%@ class is created",className]];
    
    if (_isEmpty) {
        
        _isEmpty=NO;
        
        [self.navigationItem setLeftBarButtonItem:nil];
        
        
        UIImageView *blackboard = (UIImageView*)[self.view viewWithTag:1000];
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            [blackboard setAlpha:0];
            [blackboard setTransform:CGAffineTransformMakeScale(10/9, 10/9)];
            
        } completion:^(BOOL finished) {
            [blackboard setTag:0];
            [blackboard removeFromSuperview];
            
            BouncingPencil *bouncePencil = (BouncingPencil*)[self.view viewWithTag:2000];
            [bouncePencil setTag:0];
            [bouncePencil removeFromSuperview];
        }];
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
    [_managedObjectContext save:nil];
    
    UpdateWebService *updateService = [[UpdateWebService alloc]initWithTable:@"TeacherObject"];
    [updateService setRowToUpdateWhereColumn:@"ClassList" equalTo:JSONStringArray];
    [updateService selectRowToUpdateWhereColumn:@"ObjectId" equalTo:_teacherObject.objectId];
    [updateService saveUpdate];

    
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
    NSString *objId = [[NSUserDefaults standardUserDefaults] objectForKey:@"ObjectId"];

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
            
            UpdateWebService *updateService = [[UpdateWebService alloc]initWithTable:@"TeacherObject"];
            [updateService setRowToUpdateWhereColumn:@"ClassList" equalTo:JSONStringArray];
            [updateService selectRowToUpdateWhereColumn:@"ObjectId" equalTo:_teacherObject.objectId];
            [updateService saveUpdate];

            //Update the class name in core data
            ClassObject *classNameChangeCore = [ClassObject findClassObjectInCoreWithTeacherId:objId className:self.selectedClassNameForChangedName inManagedObjectContext:_managedObjectContext];
            classNameChangeCore.nameOfClass=newClassName;
            
            //change classnames for student objects:
            //In Core
            NSFetchRequest *studentsRequest = [NSFetchRequest fetchRequestWithEntityName:@"StudentObject"];
            studentsRequest.predicate= [NSPredicate predicateWithFormat:@"teacher = %@ AND nameOfclass = %@",objId,[self.selectedClassNameForChangedName lowercaseString]];
            NSArray *studentObjArray = [_managedObjectContext executeFetchRequest:studentsRequest error:&error];
            
            //Array for updating class in student objects in database
            NSMutableArray *jsonDictionaryArray = [[NSMutableArray alloc]initWithCapacity:0];
            //Array for updating class in student logs
            NSMutableArray *logIdsArray = [[NSMutableArray alloc]initWithCapacity:0];
            for (StudentObject*studentObj in studentObjArray) {
                studentObj.nameOfclass=[newClassName lowercaseString];
                NSDictionary *jsonDict = @{@"objectId":studentObj.objectId,@"className":[newClassName lowercaseString]};
                [jsonDictionaryArray addObject:jsonDict];
                [logIdsArray addObject:studentObj.objectId];
            }
            [_managedObjectContext save:nil];
            
            //In Database
            UpdateWebService *updateStudentObject = [[UpdateWebService alloc]initWithTable:@"StudentObject"];
            [updateStudentObject updateMultipleRowsWithDictionaryArray:jsonDictionaryArray columnToUpdate:@"className" where:@"objectId"];
            
            //Update all the other attributes
            UpdateWebService *updateBroadcastName = [[UpdateWebService alloc]initWithTable:@"Broadcast"];
            [updateBroadcastName setRowToUpdateWhereColumn:@"Recipient" equalTo:newClassName];
            [updateBroadcastName selectRowToUpdateWhereColumn:@"TeacherId" equalTo:objId];
            [updateBroadcastName selectRowToUpdateWhereColumn:@"Recipient" equalTo:self.selectedClassNameForChangedName];
            [updateBroadcastName saveUpdate];
            
            //Update all the classes in the logs
            LogWebService *renameLogs = [[LogWebService alloc]init];
            NSLog(@"%@",logIdsArray);
            [renameLogs renameClassNameWithTeacherId:objId withStudentObjIdArray:logIdsArray oldClassName:[self.selectedClassNameForChangedName lowercaseString] newClassName:[newClassName lowercaseString]];
            
            UpdateWebService *updateBadge = [[UpdateWebService alloc]initWithTable:@"BroadcastBadge"];
            [updateBadge setRowToUpdateWhereColumn:@"ClassName" equalTo:[newClassName lowercaseString]];
            [updateBadge selectRowToUpdateWhereColumn:@"id" equalTo:objId];
            [updateBadge selectRowToUpdateWhereColumn:@"ClassName" equalTo:self.selectedClassNameForChangedName];
            [updateBadge saveUpdate];
            
            [self.classesTable reloadData];
            [self hideChangeNameView];
        }
    }
}



-(void)updateDatabaseInformation:(NSArray*)studentFromDatabase{
    
    
    
    
    NSString *objId = [[NSUserDefaults standardUserDefaults] objectForKey:@"ObjectId"];

    [_loadingLabel setText:@"Updating Students..."];
    
    if (![self.typeOfDay isEqualToString:@"Afternoon"]) {
        [self.loadingLabel setTextColor:[UIColor colorWithWhite:0.7 alpha:1]];
    }
    
    [_loadingView startAnimating];
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [_loadingView setAlpha:1];
        [_loadingLabel setAlpha:1];
    } completion:nil];
    
    if ([self.userType isEqualToString:@"Teacher"]){
        
        QueryWebService *query = [[QueryWebService alloc]initWithTable:@"StudentObject"];
        [query selectColumnWhere:@"teacher" equalTo:objId];
        [query findAllObjectsInRowWithCompletion:^(NSError *error, NSArray *rows) {

            if (!error) {
                
                if (self.reachabilityLabel !=nil) {
                    self.navigationItem.rightBarButtonItem.enabled=YES;
                    [self.reachabilityLabel removeFromSuperview];
                    self.reachabilityLabel=nil;
                }
                
                NSMutableArray *studentsSignedUp = [[NSMutableArray alloc]initWithCapacity:0];
                
                int totalIntCoins=0;
                int totalIntStudents = (int)[rows count];
                int totalIntSigned =0;
                
                for (NSDictionary *studentObject in rows){
                    
                    StudentObject*studentObjInCore = [StudentObject createStudentObjectInCoreWithDictionary:studentObject inManagedObjectContext:_managedObjectContext];
                    
                    NSNumber *stuCoin = studentObject[@"coins"];
                    int stuCoinint = [stuCoin intValue];
                    studentObjInCore.coins = [NSNumber numberWithInt:stuCoinint];
                    studentObjInCore.taken = studentObject[@"taken"];
                    studentObjInCore.teacherEmail = studentObject[@"teacherEmail"];
                    NSNumber *signedInNum =studentObject[@"signedIn"];
                    int signedInInt = [signedInNum intValue];
                    studentObjInCore.signedIn = [NSNumber numberWithInt:signedInInt];

                    NSNumber *num = studentObjInCore.coins;
                    totalIntCoins+=[num intValue];
                    
                    if (![studentObjInCore.taken isEqualToString:@""]) {
                        
                        totalIntSigned++;
                        [studentsSignedUp addObject:studentObject];
                    }

                    [_managedObjectContext save:&error];
                }
                
                NSLog(@"DELETE CHECK %d, %d",[studentFromDatabase count],[rows count]);
                //If database and core are different number of students (deleted from database)
                if ([studentFromDatabase count] != [rows count]) {
                    NSPredicate *predicate = [[NSPredicate alloc]init];
                    for (StudentObject*studentObj in studentFromDatabase) {
                        
                        predicate = [NSPredicate predicateWithFormat:@"objectId = %@",studentObj.objectId];
                        NSLog(@"array: %@",[rows filteredArrayUsingPredicate:predicate]);
                        if ([[rows filteredArrayUsingPredicate:predicate] count] == 0) {
                            NSLog(@"delete: %@",[rows filteredArrayUsingPredicate:predicate]);
                            [_managedObjectContext deleteObject:studentObj];
                        }
                    }
                    [_managedObjectContext save:nil];
                }
                
                if (![self.signedInStudents isEqualToArray:studentsSignedUp]) {
                    [self.signedInStudents removeAllObjects];
                    self.signedInStudents=nil;
                    self.signedInStudents = [NSMutableArray arrayWithArray:studentsSignedUp];
                }
                
                
                self.totalCoins.text = [NSString stringWithFormat:@"%d",totalIntCoins];
                self.totalStudents.text = [NSString stringWithFormat:@"%d",totalIntStudents];
                self.totalSigned.text = [NSString stringWithFormat:@"%d",totalIntSigned];
                [self updateClassTable];
            }
            else{
                
                if (self.reachabilityLabel ==nil) {
                    
                    self.reachabilityLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, 290, self.view.frame.size.width,20)];
                    [self.reachabilityLabel setBackgroundColor:[UIColor redColor]];
                    [self.reachabilityLabel setTextColor:[UIColor whiteColor]];
                    [self.reachabilityLabel setText:@"No Internet Connection"];
                    self.navigationItem.rightBarButtonItem.enabled=NO;

                    if (self.menuClassView !=nil) {
                        [self cancelButtonAction];
                    }

                    [self.view addSubview:self.reachabilityLabel];
                }

            }


        }];
    }
    else{ //if student
        
        //Query it from the Database
        QueryWebService *query = [[QueryWebService alloc]initWithTable:@"StudentObject"];
        [query selectColumnWhere:@"taken" equalTo:objId];
        [query findAllObjectsInRowWithCompletion:^(NSError *error, NSArray *rows) {
            
            if (!error) {
            
                if (self.reachabilityLabel !=nil) {
                    self.navigationItem.rightBarButtonItem.enabled=YES;
                    [self.reachabilityLabel removeFromSuperview];
                    self.reachabilityLabel=nil;
                }
                
                int totalIntCoins = 0;
                for (NSDictionary *studentDict in rows) {
                    
                    StudentObject *studentObj = [StudentObject createStudentObjectInCoreWithDictionary:studentDict inManagedObjectContext:_managedObjectContext];
                    
                    NSNumber *stuCoin = studentDict[@"coins"];
                    int stuCoinint = [stuCoin intValue];
                    studentObj.coins = [NSNumber numberWithInt:stuCoinint];
                    studentObj.teacher = studentDict[@"teacher"];
                    studentObj.teacherEmail = studentDict[@"teacherEmail"];
                    totalIntCoins+=[studentObj.coins intValue];

                }
                
                [_managedObjectContext save:nil];
                self.totalStudentCoins.text = [NSString stringWithFormat:@"%d",totalIntCoins];
                [self updateClassTable];

            
            }
            else{
                
                if (self.reachabilityLabel ==nil) {
                    
                    self.reachabilityLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, 290, self.view.frame.size.width,20)];
                    [self.reachabilityLabel setBackgroundColor:[UIColor redColor]];
                    [self.reachabilityLabel setTextColor:[UIColor whiteColor]];
                    [self.reachabilityLabel setText:@"No Internet Connection"];
                    
                    self.navigationItem.rightBarButtonItem.enabled=NO;
                    
                    if (self.menuClassView !=nil) {
                        [self cancelButtonAction];
                    }

                    
                    [self.view addSubview:self.reachabilityLabel];
                }

            }
            

        }];

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
    if ([segue.identifier isEqualToString:@"tabbarseg"]) {
        // if the cell selected segue was fired, edit the selected note
        UITabBarController *tabbarC = (UITabBarController*)segue.destinationViewController;
        
        StudentsViewController *studentVC = [tabbarC.viewControllers objectAtIndex:0];
        
        TeacherStoreViewController *storeVC = [tabbarC.viewControllers objectAtIndex:1];
        
        AnnouncementViewController *annVC = [tabbarC.viewControllers objectAtIndex:2];
        
        moreViewController *moreVC = [tabbarC.viewControllers objectAtIndex:3];
        
        annVC.className=self.selectedClass;
        annVC.managedObjectContext = _managedObjectContext;
        annVC.demoManagedObjectContext = _demoManagedObjectContext;
        
        moreVC.classNameInMore = self.selectedClass;
        moreVC.managedObjectContext=_managedObjectContext;
        moreVC.demoManagedObjectContext=_demoManagedObjectContext;
        
        storeVC.className=self.selectedClass;
        storeVC.managedObjectContext = self.managedObjectContext;
        storeVC.demoManagedObjectContext = storeVC.demoManagedObjectContext;
        
        studentVC.className=self.selectedClass;
        studentVC.managedObjectContext = self.managedObjectContext;
        studentVC.demoManagedObjectContext =self.managedObjectContext;
    }
    else if ([segue.identifier isEqualToString:@"studentclassseg"]){
        AddViewController *addVC = (AddViewController*)segue.destinationViewController;
        
        addVC.className=[self.enterClassName.classField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        addVC.demoManagedObjectContext=self.demoManagedObjectContext;
        addVC.managedObjectContext = _managedObjectContext;
        addVC.isNewClass=YES;
        addVC.delegate=self;
    }
    else if ([segue.identifier isEqualToString:@"studentTabBarSegue"]){
        
        //students segue
        UITabBarController *tabbarC = (UITabBarController*)segue.destinationViewController;

        AccountViewController *studentAccountVC = [tabbarC.viewControllers objectAtIndex:0];
        studentAccountVC.studentObj = [self.classesTableArrayStudentObject objectAtIndex:self.selectedStudentObjectIndexPath.row];
        studentAccountVC.teacherObj = [self.classesTableArrayTeacherObject objectAtIndex:self.selectedStudentObjectIndexPath.row];
        studentAccountVC.demoManagedObjectContext = _demoManagedObjectContext;
        
        TeacherStoreViewController *storeVC = [tabbarC.viewControllers objectAtIndex:1];
        storeVC.studentObj = [self.classesTableArrayStudentObject objectAtIndex:self.selectedStudentObjectIndexPath.row];
        storeVC.teacherObj = [self.classesTableArrayTeacherObject objectAtIndex:self.selectedStudentObjectIndexPath.row];
        storeVC.demoManagedObjectContext = self.demoManagedObjectContext;
        
        StudentObject *studentObjToPass = [self.classesTableArrayStudentObject objectAtIndex:self.selectedStudentObjectIndexPath.row];
        
        AnnouncementViewController *annVC = [tabbarC.viewControllers objectAtIndex:2];
        annVC.currentStudentObj = [self.classesTableArrayStudentObject objectAtIndex:self.selectedStudentObjectIndexPath.row];
        annVC.className = studentObjToPass.nameOfclass;
        annVC.teacherIdForStudent = studentObjToPass.teacher;
        annVC.demoManagedObjectContext=self.demoManagedObjectContext;
        
        moreViewController *studentMoreVC = [tabbarC.viewControllers objectAtIndex:3];
        studentMoreVC.studentObj = [self.classesTableArrayStudentObject objectAtIndex:self.selectedStudentObjectIndexPath.row];
        studentMoreVC.teacherObj = [self.classesTableArrayTeacherObject objectAtIndex:self.selectedStudentObjectIndexPath.row];
        studentMoreVC.demoManagedObjectContext=self.demoManagedObjectContext;
    }
}

@end
