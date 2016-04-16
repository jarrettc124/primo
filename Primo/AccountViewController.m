//
//  AccountViewController.m
//  TeacherApp
//
//  Created by Jarrett Chen on 2/28/14.
//  Copyright (c) 2014 Jarrett Chen. All rights reserved.
//

#import "AccountViewController.h"

@interface AccountViewController ()

@property(nonatomic,strong) UIButton *studentLogButton;
@property(nonatomic,strong) UIButton *teacherInfoButton;
@property(nonatomic,strong) UIButton *analyticsButton;
@property(nonatomic,strong) UIButton *groupsButton;

@property (nonatomic,strong) UILabel *studentLogButtonLabel;
@property (nonatomic,strong) UILabel *teacherInfoButtonLabel;
@property (nonatomic,strong) UILabel *analyticsButtonLabel;
@property (nonatomic,strong) UILabel *groupsButtonLabel;

@property(nonatomic,strong) UIImageView *backgroundView;
@property(nonatomic,strong) UIImageView *bannerView;
@property(nonatomic) NSInteger month;
@property(nonatomic) CGFloat menuHeight;
@property(nonatomic,strong) UILabel *connection;

//Background Labels
@property (nonatomic,strong) UIView *line1;
@property (nonatomic,strong) UIView *line2;
@property (nonatomic,strong) UILabel *studentNameLabel;
@property (nonatomic,strong) UILabel *classNameLabel;
@property (nonatomic,strong) UILabel *nameOfTeacherLabel;


//Bottom label
@property (nonatomic,strong) UILabel *studentName;
@property (nonatomic,strong) UILabel *nameOfClass;
@property (nonatomic,strong) UILabel *nameOfTeacher;

//ipad

@end

@implementation AccountViewController

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
    
    
    if (self.view.frame.size.height<568) {
        self.menuHeight=270;
    }
    else{
        self.menuHeight=360;
    }

    self.tabBarController.navigationController.navigationBar.topItem.title = @"";
    self.tabBarController.navigationController.title=[NSString stringWithFormat:@"%@: %@",self.studentObj.studentName,self.studentObj.nameOfclass];
    
    
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSHourCalendarUnit | NSMonthCalendarUnit;
    NSDateComponents* dateComponents = [calendar components:unitFlags fromDate:today];
    _month = (int)[dateComponents month];
    
    self.backgroundView = [[UIImageView alloc] init];
    self.backgroundView.userInteractionEnabled=YES;
    [self.view addSubview:self.backgroundView];
    
    UIView *bottomImage = [[UIView alloc]init];
    bottomImage.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    [self.view addSubview:bottomImage];
    
    self.line1 = [[UIView alloc]init];
    [self.view addSubview:self.line1];
    
    self.line2 = [[UIView alloc]init];
    [self.view addSubview:self.line2];
    
    UIView *banner = [[UIView alloc]init];
    [banner setBackgroundColor:[UIColor colorWithRed:0.317647 green:0.647059 blue:0.72941 alpha:1]];
    [self.backgroundView addSubview:banner];
    
    //Bottom Labels here
    self.studentNameLabel = [[UILabel alloc] init];
    self.studentNameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
    self.studentNameLabel.text = [NSString stringWithFormat:@"Student"];
    self.studentNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.studentNameLabel];
    
    self.studentName = [[UILabel alloc] init];
    self.studentName.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:25];
    self.studentName.text = self.studentObj.studentName;
    self.studentName.adjustsFontSizeToFitWidth = YES;
    self.studentName.minimumScaleFactor = 0.5;
    self.studentName.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.studentName];
    
    self.classNameLabel = [[UILabel alloc] init];
    self.classNameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
    self.classNameLabel.text = [NSString stringWithFormat:@"Class"];
    self.classNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.classNameLabel];
    
    self.nameOfClass = [[UILabel alloc] init];
    self.nameOfClass.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:25];
    self.nameOfClass.text = [self.studentObj.nameOfclass capitalizedString];
    self.nameOfClass.adjustsFontSizeToFitWidth=YES;
    self.nameOfClass.minimumScaleFactor = 0.5;
    self.nameOfClass.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.nameOfClass];
    
    self.nameOfTeacherLabel = [[UILabel alloc] init];
    self.nameOfTeacherLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
    self.nameOfTeacherLabel.text = [NSString stringWithFormat:@"Teacher"];
    self.nameOfTeacherLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.nameOfTeacherLabel];

    self.nameOfTeacher = [[UILabel alloc] init];
    self.nameOfTeacher.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:25];
    self.nameOfTeacher.text = self.teacherObj.teacherName;
    self.nameOfTeacher.adjustsFontSizeToFitWidth=YES;
    self.nameOfTeacher.minimumScaleFactor=0.5;
    self.nameOfTeacher.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.nameOfTeacher];
    
    //Coins
    self.coinLabel = [[UILabel alloc] init];
    [self.coinLabel setAlpha:0];
    self.coinLabel.adjustsFontSizeToFitWidth = YES;
    self.coinLabel.minimumScaleFactor=0.5;
    self.coinLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:95];
    self.coinLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.coinLabel];
    
    self.coinText = [[UILabel alloc] init];
    [self.coinText setAlpha:0];
    self.coinText.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:28];
    self.coinText.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.coinText];
    
    UIImage *bannerImage = [UIImage imageNamed:@"MonthBanner"];
    self.bannerView = [[UIImageView alloc]init];
    self.bannerView.contentMode=UIViewContentModeScaleAspectFill;
    self.bannerView.alpha=0;
    [self.bannerView setImage:bannerImage];
    [self.view addSubview:self.bannerView];
    
    //show the buttons
    self.studentLogButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.studentLogButton setImage:[UIImage imageNamed:@"LogImage"] forState:UIControlStateNormal];
    [self.studentLogButton addTarget:self action:@selector(showLogFileAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.studentLogButton setAlpha:0];
    
    self.teacherInfoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.teacherInfoButton setImage:[UIImage imageNamed:@"teacherImage"] forState:UIControlStateNormal];
    [self.teacherInfoButton addTarget:self action:@selector(teacherInfoAction) forControlEvents:UIControlEventTouchUpInside];
    [self.teacherInfoButton setAlpha:0];

    
    self.analyticsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.analyticsButton setImage:[UIImage imageNamed:@"pieIcon"] forState:UIControlStateNormal];
    [self.analyticsButton addTarget:self action:@selector(showAnalytics) forControlEvents:UIControlEventTouchUpInside];
    [self.analyticsButton setAlpha:0];

    
    self.groupsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.groupsButton setImage:[UIImage imageNamed:@"studentGroupIcon"] forState:UIControlStateNormal];
    [self.groupsButton addTarget:self action:@selector(showGroups) forControlEvents:UIControlEventTouchUpInside];
    [self.groupsButton setAlpha:0];

    
    //show label
    self.studentLogButtonLabel = [[UILabel alloc] init];
    [self.studentLogButtonLabel setAlpha:0];
    [self.studentLogButtonLabel setText:@"Log"];
    self.studentLogButtonLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    self.studentLogButtonLabel.textAlignment = NSTextAlignmentCenter;
 
    
    self.teacherInfoButtonLabel = [[UILabel alloc] init];
    [self.teacherInfoButtonLabel setAlpha:0];
    self.teacherInfoButtonLabel.numberOfLines=0;
    [self.teacherInfoButtonLabel setText:@"Teacher\nInfo"];
    self.teacherInfoButtonLabel.backgroundColor = [UIColor clearColor];
    self.teacherInfoButtonLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    self.teacherInfoButtonLabel.textAlignment = NSTextAlignmentCenter;

    
    self.analyticsButtonLabel = [[UILabel alloc] init];
    [self.analyticsButtonLabel setAlpha:0];
    self.analyticsButtonLabel.numberOfLines=0;
    [self.analyticsButtonLabel setText:@"Stats"];
    self.analyticsButtonLabel.backgroundColor = [UIColor clearColor];
    self.analyticsButtonLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    self.analyticsButtonLabel.textAlignment = NSTextAlignmentCenter;

    
    self.groupsButtonLabel = [[UILabel alloc] init];
    [self.groupsButtonLabel setAlpha:0];
    [self.groupsButtonLabel setText:@"Groups"];
    self.groupsButtonLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    self.groupsButtonLabel.textAlignment = NSTextAlignmentCenter;
    
    
    //set frames
    if (IS_IPAD) {
        [self.view addSubview:self.groupsButtonLabel];
        [self.view addSubview:self.analyticsButtonLabel];
        [self.view addSubview:self.teacherInfoButtonLabel];
        [self.view addSubview:self.studentLogButtonLabel];
        [self.view addSubview:self.groupsButton];
        [self.view addSubview:self.analyticsButton];
        [self.view addSubview:self.studentLogButton];
        [self.view addSubview:self.teacherInfoButton];
        
        self.backgroundView.translatesAutoresizingMaskIntoConstraints=NO;
        self.studentName.translatesAutoresizingMaskIntoConstraints=NO;
        self.studentNameLabel.translatesAutoresizingMaskIntoConstraints=NO;
        self.nameOfClass.translatesAutoresizingMaskIntoConstraints=NO;
        self.classNameLabel.translatesAutoresizingMaskIntoConstraints=NO;
        self.nameOfTeacher.translatesAutoresizingMaskIntoConstraints=NO;
        self.nameOfTeacherLabel.translatesAutoresizingMaskIntoConstraints=NO;
        
        bottomImage.translatesAutoresizingMaskIntoConstraints=NO;
        banner.translatesAutoresizingMaskIntoConstraints=NO;
        
        //bottom menu
        self.teacherInfoButton.translatesAutoresizingMaskIntoConstraints=NO;
        self.teacherInfoButtonLabel.translatesAutoresizingMaskIntoConstraints=NO;
        self.studentLogButton.translatesAutoresizingMaskIntoConstraints=NO;
        self.studentLogButtonLabel.translatesAutoresizingMaskIntoConstraints=NO;
        self.analyticsButton.translatesAutoresizingMaskIntoConstraints=NO;
        self.analyticsButtonLabel.translatesAutoresizingMaskIntoConstraints=NO;
        self.groupsButton.translatesAutoresizingMaskIntoConstraints=NO;
        self.groupsButtonLabel.translatesAutoresizingMaskIntoConstraints=NO;
        
        //Logo
        self.bannerView.translatesAutoresizingMaskIntoConstraints=NO;
        self.coinText.translatesAutoresizingMaskIntoConstraints=NO;
        self.coinLabel.translatesAutoresizingMaskIntoConstraints=NO;
        
        //fonts
        self.studentNameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:25];
        self.studentName.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:35];
        self.classNameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:25];
        self.nameOfClass.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:35];
        self.nameOfTeacherLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:25];
        self.nameOfTeacher.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:35];
        
        self.coinLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:140];
        self.coinText.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:34];

        //lines
        self.line1.translatesAutoresizingMaskIntoConstraints=NO;
        self.line2.translatesAutoresizingMaskIntoConstraints=NO;
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_backgroundView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_backgroundView)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_backgroundView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_backgroundView)]];
        
        //Logo position
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.coinLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:0.5 constant:-40]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.coinLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_coinLabel(140)]-0-[_bannerView(108)]" options:NSLayoutFormatAlignAllCenterX metrics:nil views:NSDictionaryOfVariableBindings(_coinLabel,_bannerView)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_coinLabel]-30-[_coinText(40)]" options:NSLayoutFormatAlignAllCenterX metrics:nil views:NSDictionaryOfVariableBindings(_coinLabel,_coinText)]];
        
        //Student Info Position
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.studentName attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:30]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_studentName(==_nameOfClass)]-2-[_nameOfClass(==_nameOfTeacher)]-2-[_nameOfTeacher]-0-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(_studentName,_nameOfClass,_nameOfTeacher)]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_studentNameLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_studentName attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_studentNameLabel(==_classNameLabel)]-2-[_classNameLabel(==_nameOfTeacherLabel)]-2-[_nameOfTeacherLabel]-0-|" options:NSLayoutFormatAlignAllCenterY metrics:0 views:NSDictionaryOfVariableBindings(_studentNameLabel,_classNameLabel,_nameOfTeacherLabel)]];
        
        //Set Lines
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_studentName]-0-[_line1(2)]-0-[_nameOfClass]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_studentName,_line1,_nameOfClass)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_line1(60)]-80-[banner]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_line1,banner)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_nameOfClass]-0-[_line2(2)]-0-[_nameOfTeacher]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_nameOfClass,_line2,_nameOfTeacher)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_line2(60)]-80-[banner]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_line2,banner)]];
        
        
        //bottom menu
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_classNameLabel]-75-[banner(6)]-0-[bottomImage]-56-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_classNameLabel,banner,bottomImage)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[bottomImage]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(bottomImage)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[banner]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(banner)]];

        //buttons
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[banner]-40-[_teacherInfoButton(70)]-0-[_teacherInfoButtonLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(banner,_teacherInfoButton,_teacherInfoButtonLabel)]];

        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_teacherInfoButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:-95]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_teacherInfoButtonLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:-95]];

        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_studentLogButton(70)]-100-[_teacherInfoButton(70)]-100-[_analyticsButton(70)]-100-[_groupsButton(70)]" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(_studentLogButton,_teacherInfoButton,_analyticsButton,_groupsButton)]];

        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_studentLogButtonLabel(90)]-80-[_teacherInfoButtonLabel(90)]-80-[_analyticsButtonLabel(90)]-80-[_groupsButtonLabel(90)]" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(_studentLogButtonLabel,_teacherInfoButtonLabel,_analyticsButtonLabel,_groupsButtonLabel)]];

    }
    else if (IS_IPHONE){
        [self.backgroundView setFrame:self.view.frame];
        [bottomImage setFrame:CGRectMake(self.view.frame.origin.x, self.menuHeight, self.view.frame.size.width, self.view.frame.size.height-self.menuHeight)];
        [self.line1 setFrame:CGRectMake((self.backgroundView.frame.size.width/3)-0.5, self.menuHeight-47, 1, 25)];
        [self.line2 setFrame:CGRectMake((self.backgroundView.frame.size.width*2/3)-0.5,self.menuHeight-47, 1, 25)];
        [banner setFrame:CGRectMake(self.view.frame.origin.x, self.menuHeight-4, self.view.frame.size.width, 4)];
        
        
        //Logo position for Iphones
        [self.coinLabel setFrame:CGRectMake((self.view.frame.size.width/2)-80,70 , 160, 80)];
        [self.coinText setFrame:CGRectMake((self.view.frame.size.width/2)-75,self.coinLabel.frame.origin.y+self.coinLabel.frame.size.height+16, 150, 40)];
        [self.bannerView setFrame:CGRectMake((self.view.frame.size.width/2)-bannerImage.size.width/2,self.coinText.frame.origin.y-18, bannerImage.size.width, bannerImage.size.height)];
        
        
        
        //student name
        [self.studentNameLabel setFrame:CGRectMake((self.view.frame.size.width/6)-(self.view.frame.size.width/6),self.menuHeight-42,(self.view.frame.size.width/3), 28)];
        [self.studentName setFrame:CGRectMake((self.view.frame.size.width/6)-(self.view.frame.size.width/6)+8,self.studentNameLabel.frame.origin.y-self.studentNameLabel.frame.size.height,(self.view.frame.size.width/3)-16, 35)];
        //class name
        [self.classNameLabel setFrame:CGRectMake((self.view.frame.size.width/2)-(self.view.frame.size.width/3)/2,self.menuHeight-42 ,(self.view.frame.size.width/3), 28)];
        [self.nameOfClass setFrame:CGRectMake((self.view.frame.size.width/2)-(self.view.frame.size.width/3)/2 +8,self.classNameLabel.frame.origin.y-self.classNameLabel.frame.size.height ,(self.view.frame.size.width/3)-16, 35)];
        //teacher name
        [self.nameOfTeacherLabel setFrame:CGRectMake((self.view.frame.size.width*2/3),self.menuHeight-42,(self.view.frame.size.width/3), 28)];
        [self.nameOfTeacher setFrame:CGRectMake((self.view.frame.size.width*2/3)+8,self.nameOfTeacherLabel.frame.origin.y-self.nameOfTeacherLabel.frame.size.height,(self.view.frame.size.width/3)-16, 35)];
        
        
        UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:bottomImage.frame];
        scrollView.scrollEnabled =YES;
        scrollView.indicatorStyle=UIScrollViewIndicatorStyleBlack;
        scrollView.contentSize=CGSizeMake(400, bottomImage.frame.size.height);
        [self.view addSubview:scrollView];
        
        //labels for buttons
        [self.studentLogButtonLabel setFrame:CGRectMake(0, 30+70,100, 30)];
        [self.teacherInfoButtonLabel setFrame:CGRectMake(100, 30+70, 100, 50)];
        [self.analyticsButtonLabel setFrame:CGRectMake(200,30+70, 100, 30)];
        [self.groupsButtonLabel setFrame:CGRectMake(300,30+70, 100, 30)];
        
        //buttons
        self.studentLogButton.frame = CGRectMake(self.studentLogButtonLabel.center.x-35, self.studentLogButtonLabel.frame.origin.y-70 ,70, 70);
        self.teacherInfoButton.frame = CGRectMake(self.teacherInfoButtonLabel.center.x-35, self.teacherInfoButtonLabel.frame.origin.y-70 ,70, 70);
        self.analyticsButton.frame = CGRectMake(self.analyticsButtonLabel.center.x-35, self.analyticsButtonLabel.frame.origin.y-70 ,70, 70);
        self.groupsButton.frame = CGRectMake(self.groupsButtonLabel.center.x-35, self.groupsButtonLabel.frame.origin.y-70, 70, 70);

        
        [scrollView addSubview:self.groupsButtonLabel];
        [scrollView addSubview:self.analyticsButtonLabel];
        [scrollView addSubview:self.teacherInfoButtonLabel];
        [scrollView addSubview:self.studentLogButtonLabel];
        [scrollView addSubview:self.groupsButton];
        [scrollView addSubview:self.analyticsButton];
        [scrollView addSubview:self.studentLogButton];
        [scrollView addSubview:self.teacherInfoButton];
        
        
        if (self.view.frame.size.height<568) {
            NSLog(@"short");

            //Logo position for Iphones
            [self.coinLabel setFrame:CGRectMake(self.coinLabel.frame.origin.x,self.coinLabel.frame.origin.y-45 , 160, 80)];
            [self.coinText setFrame:CGRectMake((self.view.frame.size.width/2)-75,self.coinLabel.frame.origin.y+self.coinLabel.frame.size.height+16, 150, 40)];
            [self.bannerView setFrame:CGRectMake((self.view.frame.size.width/2)-bannerImage.size.width/2,self.coinText.frame.origin.y-18, bannerImage.size.width, bannerImage.size.height)];
        }
    }
    
    [self displayBackground];
    
    [self showCoinsAccount];
    
    
    [self animateButtonsInAccount];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSString *coin = [self.studentObj.coins stringValue];
    if ([self.studentObj.coins intValue] == 1) {
        [self.coinText setText:@"Coin"];
    }
    else{
        [self.coinText setText:@"Coins"];
    }
    
    [self.coinLabel setText:coin];
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(refreshStudentAccount) name: UIApplicationDidBecomeActiveNotification object: nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];

}

-(void)viewDidAppear:(BOOL)animated{
    
    if (self.connection !=nil) {
        [self refreshStudentAccount];
    }
    
}

-(void)refreshStudentAccount{
    [self displayBackground];
    
    [self updateStudentObjectFromDatabaseInBackground];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)displayBackground{
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSHourCalendarUnit | NSMonthCalendarUnit;
    NSDateComponents* dateComponents = [calendar components:unitFlags fromDate:today];
    int hour = (int)[dateComponents hour];
    
    if ((hour>=0 && hour<=6) || (hour>=18 && hour<=24)) {
        //night
        [self.backgroundView setImage:[UIImage imageNamed:@"nightBackground"]];
        self.coinLabel.textColor = [UIColor whiteColor];
        self.coinText.textColor = [UIColor whiteColor];
        self.line1.backgroundColor = [UIColor whiteColor];
        self.line2.backgroundColor = [UIColor whiteColor];
        self.studentNameLabel.textColor = [UIColor whiteColor];
        self.classNameLabel.textColor = [UIColor whiteColor];
        self.nameOfTeacherLabel.textColor = [UIColor whiteColor];
        
        self.studentName.textColor = [UIColor whiteColor];
        self.nameOfClass.textColor = [UIColor whiteColor];
        self.nameOfTeacher.textColor = [UIColor whiteColor];
        
    }
    else if (hour>=7 && hour<=11){
        //morning
        [self.backgroundView setImage:[UIImage imageNamed:@"blackboardBackground"]];
        self.coinLabel.textColor = [UIColor whiteColor];
        self.coinText.textColor = [UIColor whiteColor];
        self.line1.backgroundColor = [UIColor whiteColor];
        self.line2.backgroundColor = [UIColor whiteColor];
        self.studentNameLabel.textColor = [UIColor whiteColor];
        self.classNameLabel.textColor = [UIColor whiteColor];
        self.nameOfTeacherLabel.textColor = [UIColor whiteColor];
        
        self.studentName.textColor = [UIColor whiteColor];
        self.nameOfClass.textColor = [UIColor whiteColor];
        self.nameOfTeacher.textColor = [UIColor whiteColor];
    }
    else if (hour>=12 && hour<=17){
        //daytime
        [self.backgroundView setImage:[UIImage imageNamed:@"dayBackground"]];
        [self.coinLabel setTextColor:[UIColor blackColor]];
        [self.coinText setTextColor:[UIColor blackColor]];
        self.line1.backgroundColor = [UIColor blackColor];
        self.line2.backgroundColor = [UIColor blackColor];
        self.studentNameLabel.textColor = [UIColor blackColor];
        self.classNameLabel.textColor = [UIColor blackColor];
        self.nameOfTeacherLabel.textColor = [UIColor blackColor];
        
        self.studentName.textColor = [UIColor blackColor];
        self.nameOfClass.textColor = [UIColor blackColor];
        self.nameOfTeacher.textColor = [UIColor blackColor];
    }
    else{
        //error
        NSLog(@"Background Error");
        [self.backgroundView setImage:[UIImage imageNamed:@"dayBackground"]];
    }
}

-(void)showCoinsAccount{
    
    NSString *coin = [self.studentObj.coins stringValue];
    if ([self.studentObj.coins intValue] == 1) {
        [self.coinText setText:@"Coin"];
    }
    else{
        [self.coinText setText:@"Coins"];
    }

    [self.coinLabel setText:coin];
    
    [self updateStudentObjectFromDatabaseInBackground];
    
    //animate the coinlabels
    [UIView animateWithDuration:1 delay:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
        if (IS_IPAD) {
            [self.coinLabel setAlpha:1];
            [self.coinText setAlpha:1];
            [self.bannerView setAlpha:1];

        }
        else if (IS_IPHONE){
            self.coinLabel.frame = CGRectMake((self.view.frame.size.width/2)-80,self.coinLabel.frame.origin.y+20, 160, 80);
            [self.coinLabel setAlpha:1];
            self.coinText.frame = CGRectMake((self.view.frame.size.width/2)-75,self.coinText.frame.origin.y+20, 150, 40);
            [self.coinText setAlpha:1];
            self.bannerView.frame = CGRectMake(self.bannerView.frame.origin.x, self.bannerView.frame.origin.y+20, self.bannerView.frame.size.width, self.bannerView.frame.size.height);
            [self.bannerView setAlpha:1];
        }
    } completion:nil];
    
}

-(void)updateStudentObjectFromDatabaseInBackground{
    
    UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc]init];
    [loadingView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:loadingView];
    [loadingView hidesWhenStopped];
    [loadingView startAnimating];
    
    if(IS_IPAD){
        loadingView.translatesAutoresizingMaskIntoConstraints=NO;
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_classNameLabel]-20-[loadingView(30)]" options:NSLayoutFormatAlignAllCenterX metrics:nil views:NSDictionaryOfVariableBindings(loadingView,_classNameLabel)]];
    }
    else if (IS_IPHONE){
        [loadingView setFrame:CGRectMake(self.view.frame.size.width/2-15, 242, 30, 30)];
        if (self.view.frame.size.height<568) {
            //short 3.5
            [loadingView setFrame:CGRectMake(self.view.frame.size.width/2-15, 272, 30, 30)];
        }
    }
    NSString *objId = [[NSUserDefaults standardUserDefaults] objectForKey:@"ObjectId"];
    AnnouncementObject *annObject = [[AnnouncementObject alloc]init];
    [annObject getBadgeNumber:objId className:[self.studentObj.nameOfclass lowercaseString] completion:^(BOOL finished, NSNumber *badgeNum) {
        if (finished) {
            if ([badgeNum intValue]>0) {
                [[[[[self tabBarController] tabBar] items] objectAtIndex:2] setBadgeValue:[NSString stringWithFormat:@"%d",[badgeNum intValue]]];
            }
        }
    }];

    
    QueryWebService *query = [[QueryWebService alloc]initWithTable:@"StudentObject"];
    [query selectColumnWhere:@"objectId" equalTo:self.studentObj.objectId];
    [query findAllObjectsInRowWithCompletion:^(NSError *error, NSArray *rows) {
        
        [loadingView stopAnimating];
        [loadingView removeFromSuperview];
        
        if (error){
            if (self.connection ==nil) {
                
                self.connection = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, self.menuHeight-30, self.view.frame.size.width,30)];
                [self.connection setBackgroundColor:[UIColor redColor]];
                [self.connection setTextColor:[UIColor whiteColor]];
                self.connection.textAlignment = NSTextAlignmentCenter;
                [self.connection setText:@"No Internet Connection"];
                [self.view addSubview:self.connection];
            }
        }
        else if ([rows count]!=1) {
            NSLog(@"Can't find the dictionary");
            
        }
        else{
            if (self.connection !=nil) {
                [self.connection removeFromSuperview];
                self.connection=nil;
            }
            
            NSDictionary *studentDict = [rows firstObject];
            NSNumber *studentCoinNum = studentDict[@"coins"];
            int studentCoinInt = [studentCoinNum intValue];
            _studentObj.coins = [NSNumber numberWithInt:studentCoinInt];
            _studentObj.nameOfclass = studentDict[@"className"];
            _studentObj.teacherEmail = studentDict[@"teacherEmail"];
            [self.studentObj.managedObjectContext save:nil];
            
            //Set the label
            [self.coinLabel setText:[self.studentObj.coins stringValue]];
            [self.nameOfClass setText:[self.studentObj.nameOfclass capitalizedString]];
        }

    }];
    
}

//button actions
-(void)showLogFileAction:(id)sender{
    [self performSegueWithIdentifier:@"studentmonthview" sender:self];
}

-(void)teacherInfoAction{
    [self performSegueWithIdentifier:@"teacherinfoseg" sender:self];
}

-(void)showAnalytics{

    [self performSegueWithIdentifier:@"analyticsStudentsSegue" sender:self];
}
-(void)showGroups{
    [self performSegueWithIdentifier:@"groupSegue" sender:self];
}

-(void)animateButtonsInAccount{
    self.studentLogButton.center = CGPointMake(self.studentLogButton.center.x, self.studentLogButton.center.y-20);
    self.studentLogButtonLabel.center = CGPointMake(self.studentLogButtonLabel.center.x, self.studentLogButtonLabel.center.y-20);
    self.teacherInfoButton.center = CGPointMake(self.teacherInfoButton.center.x, self.teacherInfoButton.center.y-20);
    self.teacherInfoButtonLabel.center = CGPointMake(self.teacherInfoButtonLabel.center.x, self.teacherInfoButtonLabel.center.y-20);
    self.analyticsButton.center = CGPointMake(self.analyticsButton.center.x, self.analyticsButton.center.y-20);
    self.analyticsButtonLabel.center = CGPointMake(self.analyticsButtonLabel.center.x, self.analyticsButtonLabel.center.y-20);
    self.groupsButton.center = CGPointMake(self.groupsButton.center.x, self.groupsButton.center.y-20);
    self.groupsButtonLabel.center = CGPointMake(self.groupsButtonLabel.center.x, self.groupsButtonLabel.center.y-20);
    
    [self.studentLogButton setAlpha:0];
    [self.studentLogButtonLabel setAlpha:0];
    [self.teacherInfoButton setAlpha:0];
    [self.teacherInfoButtonLabel setAlpha:0];
    [self.analyticsButton setAlpha:0];
    [self.analyticsButtonLabel setAlpha:0];
    [self.groupsButton setAlpha:0];
    [self.groupsButtonLabel setAlpha:0];
    
    [UIView animateWithDuration:0.4 delay:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        if (IS_IPHONE) {
            self.studentLogButton.center = CGPointMake(self.studentLogButton.center.x, self.studentLogButton.center.y+20);
            self.studentLogButtonLabel.center = CGPointMake(self.studentLogButtonLabel.center.x, self.studentLogButtonLabel.center.y+20);
        }
        
        [self.studentLogButton setAlpha:1];
        [self.studentLogButtonLabel setAlpha:1];
    
    } completion:^(BOOL finished) {
        
    }];
    
    [UIView animateWithDuration:0.4 delay:0.4 options:UIViewAnimationOptionCurveEaseOut animations:^{
        if (IS_IPHONE) {
            self.teacherInfoButton.center = CGPointMake(self.teacherInfoButton.center.x, self.teacherInfoButton.center.y+20);
            self.teacherInfoButtonLabel.center = CGPointMake(self.teacherInfoButtonLabel.center.x, self.teacherInfoButtonLabel.center.y+20);
        }
        [self.teacherInfoButton setAlpha:1];
        [self.teacherInfoButtonLabel setAlpha:1];
        
    } completion:^(BOOL finished) {
        
    }];
    
    [UIView animateWithDuration:0.4 delay:0.6 options:UIViewAnimationOptionCurveEaseOut animations:^{
        if (IS_IPHONE) {
            self.analyticsButton.center = CGPointMake(self.analyticsButton.center.x, self.analyticsButton.center.y+20);
            self.analyticsButtonLabel.center = CGPointMake(self.analyticsButtonLabel.center.x, self.analyticsButtonLabel.center.y+20);
        }

        [self.analyticsButton setAlpha:1];

        [self.analyticsButtonLabel setAlpha:1];
    } completion:^(BOOL finished) {
        
        
    }];
    
    [UIView animateWithDuration:0.4 delay:0.6 options:UIViewAnimationOptionCurveEaseOut animations:^{
        if (IS_IPHONE) {
            self.groupsButton.center = CGPointMake(self.groupsButton.center.x, self.groupsButton.center.y+20);
            self.groupsButtonLabel.center = CGPointMake(self.groupsButtonLabel.center.x, self.groupsButtonLabel.center.y+20);
        }
        
        [self.groupsButton setAlpha:1];
        
        [self.groupsButtonLabel setAlpha:1];
    } completion:^(BOOL finished) {
        
        
    }];
}

-(void)classListAction{
    [self performSegueWithIdentifier:@"studentBackToClassSegue" sender:self];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"studentmonthview"]){
        MonthLogViewController *monthVC = (MonthLogViewController*)segue.destinationViewController;
        
        monthVC.selectedStudentObjFromClassTable=self.studentObj;
        monthVC.classNameInMonth = self.studentObj.nameOfclass;
        monthVC.currentMonth =_month;
        monthVC.teacherID = self.teacherObj.teacherId;
        monthVC.demoManagedObjectContext=self.demoManagedObjectContext;
    }
    else if ([segue.identifier isEqualToString:@"analyticsStudentsSegue"]) {
        PieChartViewController *pieVC = (PieChartViewController*)segue.destinationViewController;
        pieVC.selectedStudent = self.studentObj;
        pieVC.demoManagedObjectContext=self.demoManagedObjectContext;
        
    }
    else if ([segue.identifier isEqualToString:@"teacherinfoseg"]){
        TeacherInfoViewController *teachVC = (TeacherInfoViewController*)segue.destinationViewController;
        teachVC.studentObj = self.studentObj;
        teachVC.teacherObj = self.teacherObj;
        teachVC.demoManagedObjectContext=self.demoManagedObjectContext;
        
    }
    else if ([segue.identifier isEqualToString:@"studentBackToClassSegue"]){
        ClassTableViewController *classTableVC = (ClassTableViewController*)segue.destinationViewController;
        classTableVC.managedObjectContext = self.teacherObj.managedObjectContext;
        classTableVC.demoManagedObjectContext=self.demoManagedObjectContext;
    }
    else if ([segue.identifier isEqualToString:@"groupSegue"]){
        StudentGroupViewController *studentGroupVC = (StudentGroupViewController*)segue.destinationViewController;
        studentGroupVC.managedObjectContext=self.studentObj.managedObjectContext;
        studentGroupVC.studentObject = self.studentObj;
    }
}


@end
