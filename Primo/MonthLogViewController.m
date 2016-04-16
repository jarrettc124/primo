//
//  MonthLogViewController.m
//  TeacherApp
//
//  Created by Jarrett Chen on 3/24/14.
//  Copyright (c) 2014 Jarrett Chen. All rights reserved.
//

#import "MonthLogViewController.h"

@interface MonthLogViewController ()
@property (nonatomic) NSInteger monthNumberInMonthVC;
@property (nonatomic,strong) NSString *userType;

//ipad
@property (nonatomic,strong) UITextView *logView;
@property (nonatomic,strong) UIImageView *calendarCircleView;
@property (nonatomic,strong) UILabel *monthNameLabelLog;

@end

@implementation MonthLogViewController

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
    
    UIImageView *backgroundView = [[UIImageView alloc] init];
    [backgroundView setImage:[UIImage imageNamed:@"blackboardBackground"]];
    backgroundView.userInteractionEnabled=YES;
    [self.view addSubview:backgroundView];

    if (IS_IPAD) {
        backgroundView.translatesAutoresizingMaskIntoConstraints=NO;
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[backgroundView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(backgroundView)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[backgroundView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(backgroundView)]];
    }
    else if (IS_IPHONE){
        [backgroundView setFrame:self.view.frame];
    }
    
    self.months=[[NSMutableArray alloc]initWithCapacity:0];
    self.userType = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserType"];
    
    NSLog(@"user = %@",self.userType);
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    UIImage *bannerImage = [UIImage imageNamed:@"MonthBanner"];
    UIImageView *bannerView = [[UIImageView alloc]init];
    [bannerView setImage:bannerImage];
    bannerView.userInteractionEnabled=YES;
    [self.view addSubview:bannerView];
 
    UIImage *calendarImage = [UIImage imageNamed:@"calendarImage"];
    UIImageView *calendarView = [[UIImageView alloc]init];
    [calendarView setImage:calendarImage];
    calendarView.userInteractionEnabled=YES;
    [self.view addSubview:calendarView];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSMonthCalendarUnit;
    NSDateComponents* dateComponents = [calendar components:unitFlags fromDate:[NSDate date]];
    self.currentMonth = (int)[dateComponents month];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    self.monthLabelStringInMonthVC = [[df monthSymbols] objectAtIndex:(self.currentMonth-1)];
    
    if (IS_IPAD) {
        bannerView.translatesAutoresizingMaskIntoConstraints=NO;
        calendarView.translatesAutoresizingMaskIntoConstraints=NO;
        
        UIView *dividerVC = [UIView new];
        dividerVC.backgroundColor = [UIColor lightGrayColor];
        dividerVC.translatesAutoresizingMaskIntoConstraints=NO;
        [self.view addSubview:dividerVC];
        
        UIView *logSectionSide = [UIView new];
        logSectionSide.translatesAutoresizingMaskIntoConstraints=NO;
        [self.view addSubview:logSectionSide];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[bannerView(320)]-[dividerVC(4)]-[logSectionSide]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(bannerView,dividerVC,logSectionSide)]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-64-[dividerVC]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(dividerVC)]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-64-[logSectionSide]-56-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(logSectionSide)]];
        

        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[calendarView(320)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(calendarView)]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-100-[bannerView(86)]-10-[calendarView(375)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(bannerView,calendarView)]];
        
        //divided right side
        UIImageView *bannerViewLog = [[UIImageView alloc]init];
        [bannerViewLog setImage:bannerImage];
        bannerViewLog.userInteractionEnabled=YES;
        bannerViewLog.translatesAutoresizingMaskIntoConstraints=NO;
        [logSectionSide addSubview:bannerViewLog];
        
        self.logView = [[UITextView alloc]init];
        [self.logView setEditable:NO];
        [self.logView setFont:[UIFont systemFontOfSize:14]];
        [self.logView setBackgroundColor:[UIColor clearColor]];
        [logSectionSide addSubview:self.logView];
        
        self.logView.translatesAutoresizingMaskIntoConstraints=NO;
        
        UIImage * dividerImage=[UIImage imageNamed:@"Divider"];
        UIImageView *dividerUnderLabel = [UIImageView new];
        [dividerUnderLabel setImage:dividerImage];
        [logSectionSide addSubview:dividerUnderLabel];
        dividerUnderLabel.translatesAutoresizingMaskIntoConstraints=NO;
        
        [logSectionSide addConstraint:[NSLayoutConstraint constraintWithItem:bannerViewLog attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:logSectionSide attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        
        [logSectionSide addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-36-[bannerViewLog(86)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(bannerViewLog)]];
         
        [dividerUnderLabel addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[dividerUnderLabel(320)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(dividerUnderLabel)]];
        
        [logSectionSide addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-2-[_logView]-2-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(dividerVC,_logView)]];
        
        [logSectionSide addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[bannerViewLog]-[dividerUnderLabel(8)]-30-[_logView]|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:NSDictionaryOfVariableBindings(bannerViewLog,dividerUnderLabel,_logView)]];
        
        self.monthNameLabelLog = [[UILabel alloc] initWithFrame:CGRectMake((bannerImage.size.width/2)-(180/2)-1,18, 180, 44)];
        self.monthNameLabelLog.text=self.monthLabelStringInMonthVC;
        self.monthNameLabelLog.textColor = [UIColor whiteColor];
        self.monthNameLabelLog.adjustsFontSizeToFitWidth=YES;
        self.monthNameLabelLog.minimumScaleFactor=0.5;
        self.monthNameLabelLog.font = [UIFont fontWithName:@"Eraser" size:46];
        self.monthNameLabelLog.textAlignment = NSTextAlignmentCenter;
        [bannerViewLog addSubview:self.monthNameLabelLog];
        
    }
    else if (IS_IPHONE){
        [bannerView setFrame:CGRectMake((self.view.frame.size.width/2)-bannerImage.size.width/2,60, bannerImage.size.width, bannerImage.size.height)];
        [calendarView setFrame:CGRectMake((self.view.frame.size.width/2)-calendarImage.size.width/2,bannerView.frame.origin.y+bannerView.frame.size.height-10, calendarImage.size.width, calendarImage.size.height)];
    }
    UILabel *monthNameLabel = [[UILabel alloc] initWithFrame:CGRectMake((bannerImage.size.width/2)-(180/2)-1,18, 180, 44)];
    monthNameLabel.text=self.monthLabelStringInMonthVC;
    monthNameLabel.textColor = [UIColor whiteColor];
    monthNameLabel.adjustsFontSizeToFitWidth=YES;
    monthNameLabel.minimumScaleFactor=0.5;
    monthNameLabel.font = [UIFont fontWithName:@"Eraser" size:46];
    monthNameLabel.textAlignment = NSTextAlignmentCenter;
    [bannerView addSubview:monthNameLabel];
    
    CGFloat yPosition = 22;

    if ((self.view.frame.size.height<568) && IS_IPHONE) {
        //Short device 3.5 device
        [monthNameLabel setFrame:CGRectMake(monthNameLabel.frame.origin.x-10, monthNameLabel.frame.origin.y-10, monthNameLabel.frame.size.width-30, monthNameLabel.frame.size.height-30)];
        monthNameLabel.font = [UIFont fontWithName:@"Eraser" size:15];
        
        [bannerView setFrame:CGRectMake(bannerView.frame.origin.x+25, bannerView.frame.origin.y-17, bannerView.frame.size.width-50, bannerView.frame.size.height-50)];

        
        [calendarView setFrame:CGRectMake(calendarView.frame.origin.x, calendarView.frame.origin.y-70, calendarView.frame.size.width, calendarView.frame.size.height)];
        
    }
    
    for (int row =0; row<4; row++) {
        CGFloat xPosition= (calendarImage.size.width/6-(73/2)+22);
        for (int col = 0; col<3; col++) {
            
            if ((3*row)+(col+1) == self.currentMonth) {
                
                self.calendarCircleView = [[UIImageView alloc]initWithFrame:CGRectMake(xPosition-20, yPosition-22, 117, 117)];
                [self.calendarCircleView setImage:[UIImage imageNamed:@"calendarCircle"]];
                self.calendarCircleView.userInteractionEnabled=YES;
                [calendarView addSubview:self.calendarCircleView];
                
            }

            UIButton *monthButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [monthButton setTag:(3*row)+(col+1)];
            [monthButton addTarget:self action:@selector(logFile:) forControlEvents:UIControlEventTouchUpInside];
            monthButton.frame = CGRectMake(xPosition, yPosition, 73, 73);
            [self.months addObject:monthButton];
            [calendarView addSubview:monthButton];
            xPosition+=monthButton.frame.size.width+10;
        }
        yPosition+=73+13;
    }
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    if (IS_IPAD) {
        self.monthNumberInMonthVC = self.currentMonth;
        
        [self findLogForIPAD];
    }
    
}


-(void)findLogForIPAD{
    
    //loading
    UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(self.logView.bounds.size.width/2-40, 200, 30, 30)];
    [self.logView addSubview:loadingView];
    UILabel *loadingLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.logView.bounds.size.width/2-10, 200, 100, 30)];
    [loadingLabel setText:@"Loading..."];
    [loadingLabel setFont:[UIFont systemFontOfSize:14]];
    [loadingLabel setTextColor:[UIColor whiteColor]];
    [self.logView addSubview:loadingLabel];
    [loadingView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [loadingView hidesWhenStopped];
    [loadingView startAnimating];
    
    
    if ([self.teachersLogOption isEqualToString:@"Teacher's Log"]) {
            NSString *objId = [[NSUserDefaults standardUserDefaults] objectForKey:@"ObjectId"];
        LogWebService *logService = [[LogWebService alloc]initWithLogType:@"class_logs"];
        
        [logService printLogOutToUI:objId className:self.classNameInMonth logMonth:self.monthNumberInMonthVC completion:^(BOOL finished, NSError *error, NSString *result) {
            
            if (!error) {
                
                self.logView.textColor = [UIColor whiteColor];
                self.logView.text= [NSString stringWithFormat:@"%@",result];
                [loadingView stopAnimating];
                [loadingLabel removeFromSuperview];
                [loadingView removeFromSuperview];
                
            }
            else{
                
                UILabel *connection = [[UILabel alloc]initWithFrame:CGRectMake(self.logView.bounds.size.width/2-125, 200, 250, 30)];
                [connection setText:@"Please check your internet connection"];
                [connection setFont:[UIFont systemFontOfSize:14]];
                [connection setTextColor:[UIColor whiteColor]];
                [self.view addSubview:connection];
                
            }
            
        }];
        
    }
    else{
        
        if ([self.previousSegue isEqualToString:@"broadcastMonth"]) {
            
            self.navigationItem.title=@"Broadcast Log";
                NSString *objId = [[NSUserDefaults standardUserDefaults] objectForKey:@"ObjectId"];
            LogWebService *logService = [[LogWebService alloc]initWithLogType:@"announcement"];
            
            NSString *logIdString = nil;
            if ([_userType isEqualToString:@"Teacher"]) {
                logIdString = objId;
            }
            else{
                logIdString = self.selectedStudentObjFromClassTable.objectId;
            }
            
            [logService printLogOutToUI:logIdString className:[self.classNameInMonth lowercaseString] logMonth:self.monthNumberInMonthVC completion:^(BOOL finished, NSError *error, NSString *result) {
                
                if (!error) {
                    
                    self.logView.textColor = [UIColor whiteColor];
                    self.logView.text= [NSString stringWithFormat:@"%@",result];
                    [loadingView stopAnimating];
                    [loadingLabel removeFromSuperview];
                    [loadingView removeFromSuperview];
                    
                }
                else{
                    
                    UILabel *connection = [[UILabel alloc]initWithFrame:CGRectMake(self.logView.bounds.size.width/2-125, 200, 250, 30)];
                    [connection setText:@"Please check your internet connection"];
                    [connection setFont:[UIFont systemFontOfSize:14]];
                    [connection setTextColor:[UIColor whiteColor]];
                    [self.view addSubview:connection];
                    
                }
            }];
            
            
        }
        else{
            //Student's log
            self.navigationItem.title=[NSString stringWithFormat:@"%@'s Log",self.selectedStudentObjFromClassTable.studentName];
            
            LogWebService *logService = [[LogWebService alloc]initWithLogType:@"class_logs"];
            [logService printLogOutToUI:self.selectedStudentObjFromClassTable.objectId className:self.selectedStudentObjFromClassTable.nameOfclass logMonth:self.monthNumberInMonthVC completion:^(BOOL finished, NSError *error, NSString *result) {
                if (!error) {
                    
                    self.logView.textColor = [UIColor whiteColor];
                    self.logView.text= [NSString stringWithFormat:@"%@",result];
                    [loadingView stopAnimating];
                    [loadingLabel removeFromSuperview];
                    [loadingView removeFromSuperview];
                    
                }
                else{
                    
                    UILabel *connection = [[UILabel alloc]initWithFrame:CGRectMake(self.logView.bounds.size.width/2-125, 200, 250, 30)];
                    [connection setText:@"Please check your internet connection"];
                    [connection setFont:[UIFont systemFontOfSize:14]];
                    [connection setTextColor:[UIColor whiteColor]];
                    [self.view addSubview:connection];
                    
                }
                
            }];
            
        }
    }
    
}


-(void)logFile:(UIButton*)sender{
    self.monthNumberInMonthVC =sender.tag;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    self.monthLabelStringInMonthVC = [[df monthSymbols] objectAtIndex:sender.tag-1];

    
    if (IS_IPAD) {
        
        [self.calendarCircleView setFrame:CGRectMake(sender.frame.origin.x-20, sender.frame.origin.y-22, 117, 117)];
        self.monthNameLabelLog.text=self.monthLabelStringInMonthVC;

        [self findLogForIPAD];
        
    }
    else{
        if ([self.userType isEqualToString:@"Teacher"]) {
            
            if ([self.previousSegue isEqualToString:@"broadcastMonth"]) {
                [self performSegueWithIdentifier:@"broadcastLog" sender:self];
            }
            else{
                [self performSegueWithIdentifier:@"studentlog" sender:self];
            }
        }
        else{
            if ([self.previousSegue isEqualToString:@"broadcastMonth"]) {
                [self performSegueWithIdentifier:@"broadcastLog" sender:self];
            }
            else{
                [self performSegueWithIdentifier:@"studentviewlog" sender:self];
            }
        }
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"studentlog"] || [segue.identifier isEqualToString:@"studentviewlog"]){
        LogViewController *logVC = (LogViewController*)segue.destinationViewController;
        
        if ([self.teachersLogOption isEqualToString:@"Teacher's Log"]) {
            logVC.teachersLogOptionInLog=self.teachersLogOption;
            logVC.monthNumberInLogVC = self.monthNumberInMonthVC;
            logVC.monthLabelStringInLogVC = self.monthLabelStringInMonthVC;
            logVC.classNameInLog=self.classNameInMonth;
            logVC.demoManagedObjectContext=self.demoManagedObjectContext;
        }
        else{
            logVC.monthNumberInLogVC = self.monthNumberInMonthVC;
            logVC.selectedStudentObjFromClassTable = self.selectedStudentObjFromClassTable;
            logVC.monthLabelStringInLogVC = self.monthLabelStringInMonthVC;
            logVC.demoManagedObjectContext=self.demoManagedObjectContext;
        }
    }
    else if([segue.identifier isEqualToString:@"broadcastLog"]){
        LogViewController *logVC = (LogViewController*)segue.destinationViewController;
        logVC.monthNumberInLogVC=self.monthNumberInMonthVC;
        logVC.monthLabelStringInLogVC = self.monthLabelStringInMonthVC;
        logVC.classNameInLog = self.classNameInMonth;
        logVC.previousSegue = segue.identifier;
        logVC.selectedStudentObjFromClassTable=_selectedStudentObjFromClassTable;
        logVC.demoManagedObjectContext=self.demoManagedObjectContext;
    }
    
}

@end
