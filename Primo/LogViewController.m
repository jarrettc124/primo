//
//  LogViewController.m
//  TeacherApp
//
//  Created by Jarrett Chen on 3/24/14.
//  Copyright (c) 2014 Jarrett Chen. All rights reserved.
//

#import "LogViewController.h"

@interface LogViewController ()

@end

@implementation LogViewController

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
    
    NSLog(@"monthnumber %d", self.monthNumberInLogVC);
    NSLog(@"CLASS %@",self.selectedStudentObjFromClassTable.nameOfclass);
    
    
    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:self.view.frame];
    [backgroundView setImage:[UIImage imageNamed:@"blackboardBackground"]];
    backgroundView.userInteractionEnabled=YES;
    [self.view addSubview:backgroundView];
}

-(void)viewWillAppear:(BOOL)animated{
    
    UILabel *monthTitle = [[UILabel alloc]init];
    monthTitle.textAlignment=NSTextAlignmentCenter;
    monthTitle.text = self.monthLabelStringInLogVC;
    monthTitle.adjustsFontSizeToFitWidth=YES;
    monthTitle.minimumScaleFactor=0.5;
    monthTitle.textColor = [UIColor whiteColor];
    monthTitle.font = [UIFont fontWithName:@"Eraser" size:45];

    NSString*userType = [[NSUserDefaults standardUserDefaults]objectForKey:@"UserType"];
    
    //loading
    UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-40, 200, 30, 30)];
    [self.view addSubview:loadingView];
    UILabel *loadingLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-10, 200, 100, 30)];
    [loadingLabel setText:@"Loading..."];
    [loadingLabel setFont:[UIFont systemFontOfSize:14]];
    [loadingLabel setTextColor:[UIColor whiteColor]];
    [self.view addSubview:loadingLabel];
    [loadingView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [loadingView hidesWhenStopped];
    [loadingView startAnimating];
    
    UITextView *logView = [[UITextView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, 64, self.view.frame.size.width, self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height-20-self.tabBarController.tabBar.frame.size.height)];
    [logView setEditable:NO];
    [logView setFont:[UIFont systemFontOfSize:14]];
    [logView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:logView];
    
    UIImage *bannerImage = [UIImage imageNamed:@"MonthBanner"];
    UIImageView *bannerView = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width/2)-bannerImage.size.width/2,0, bannerImage.size.width, bannerImage.size.height)];
    [bannerView setImage:bannerImage];
    bannerView.userInteractionEnabled=YES;
    [logView addSubview:bannerView];
    
    monthTitle.frame = CGRectMake((bannerView.frame.size.width/2)-(180/2)-1,18, 180, 44);
    [logView addSubview:monthTitle];
    
    UIImage * dividerImage=[UIImage imageNamed:@"Divider"];
    UIImageView *dividerUnderLabel = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width/2)-dividerImage.size.width/2, monthTitle.frame.origin.y+monthTitle.frame.size.height+20, dividerImage.size.width, dividerImage.size.height)];
    [dividerUnderLabel setImage:dividerImage];
    [logView addSubview:dividerUnderLabel];
    
    if ([self.teachersLogOptionInLog isEqualToString:@"Teacher's Log"]) {
        
        NSString *objId = [[NSUserDefaults standardUserDefaults] objectForKey:@"ObjectId"];
        LogWebService *logService = [[LogWebService alloc]initWithLogType:@"class_logs"];
        
        [logService printLogOutToUI:objId className:self.classNameInLog logMonth:self.monthNumberInLogVC completion:^(BOOL finished, NSError *error, NSString *result) {
            
            if (!error) {
            
                logView.textColor = [UIColor whiteColor];
                logView.text= [NSString stringWithFormat:@"\n\n\n\n\n%@",result];
                [loadingView stopAnimating];
                [loadingLabel removeFromSuperview];
                [loadingView removeFromSuperview];
                
            }
            else{
                
                UILabel *connection = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-125, 200, 250, 30)];
                [connection setText:@"Please check your internet connection"];
                [connection setFont:[UIFont systemFontOfSize:14]];
                [connection setTextColor:[UIColor whiteColor]];
                [self.view addSubview:connection];
                
            }
            
        }];

    }
    else{
        
        if ([self.previousSegue isEqualToString:@"broadcastLog"]) {
            
            self.navigationItem.title=@"Broadcast Log";
            NSLog(@"start ui");
                NSString *objId = [[NSUserDefaults standardUserDefaults] objectForKey:@"ObjectId"];
            
            LogWebService *logService = [[LogWebService alloc]initWithLogType:@"announcement"];
            
            NSString *logIdString = nil;
            if ([userType isEqualToString:@"Teacher"]) {
                logIdString = objId;
            }
            else{
                logIdString = self.selectedStudentObjFromClassTable.objectId;
            }
            
            [logService printLogOutToUI:logIdString className:[self.classNameInLog lowercaseString] logMonth:self.monthNumberInLogVC completion:^(BOOL finished, NSError *error, NSString *result) {
                
                if (!error) {
                    
                    logView.textColor = [UIColor whiteColor];
                    logView.text= [NSString stringWithFormat:@"\n\n\n\n\n%@",result];
                    [loadingView stopAnimating];
                    [loadingLabel removeFromSuperview];
                    [loadingView removeFromSuperview];
                    
                }
                else{
                    
                    UILabel *connection = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-125, 200, 250, 30)];
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
            [logService printLogOutToUI:self.selectedStudentObjFromClassTable.objectId className:self.selectedStudentObjFromClassTable.nameOfclass logMonth:self.monthNumberInLogVC completion:^(BOOL finished, NSError *error, NSString *result) {
                if (!error) {
                    
                    logView.textColor = [UIColor whiteColor];
                    logView.text= [NSString stringWithFormat:@"\n\n\n\n\n%@",result];
                    [loadingView stopAnimating];
                    [loadingLabel removeFromSuperview];
                    [loadingView removeFromSuperview];
                    
                }
                else{
                    
                    UILabel *connection = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-125, 200, 250, 30)];
                    [connection setText:@"Please check your internet connection"];
                    [connection setFont:[UIFont systemFontOfSize:14]];
                    [connection setTextColor:[UIColor whiteColor]];
                    [self.view addSubview:connection];
                    
                }
                
            }];
            
        }
    }
    
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
