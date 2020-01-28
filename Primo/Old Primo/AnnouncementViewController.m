//
//  AnnouncementViewController.m
//  Primo
//
//  Created by Jarrett Chen on 5/7/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import "AnnouncementViewController.h"

@interface AnnouncementViewController ()

@property (nonatomic,strong) UILabel *connection;
@property (nonatomic,strong) NSMutableArray *announcementArray;
@property (nonatomic,strong) NSMutableArray *announcementPictureArray;
@property (nonatomic,strong) NSMutableArray *announcementDate;
@property (nonatomic,strong) UIBarButtonItem *rightBarButton;
@property (nonatomic,strong) NSString *userType;

//table information
@property (nonatomic,strong) NSString *announcementString;
@property (nonatomic,strong) UITableView *announceTable;
@property(nonatomic) UIRefreshControl *refreshControl;

//announcement info
@property (nonatomic,strong) PostAnnouncement *announcementPost;
@property (nonatomic,strong) PushWebService *pushService;
@property (nonatomic,strong) AnnouncementObject *annObj;
@property (nonatomic,strong) NSMutableArray *studentsTaken;

@property (nonatomic,strong) UIView *closedView;

@property (nonatomic,strong) NSString *classTitle;

@end

@implementation AnnouncementViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.classTitle = self.tabBarController.navigationItem.title;
    
    self.userType = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserType"];
    
    UIImageView *toolbarBackground = [[UIImageView alloc]init];
    [toolbarBackground setImage:[UIImage imageNamed:@"blackboardBar"]];
    toolbarBackground.userInteractionEnabled=YES;
    [self.view addSubview:toolbarBackground];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    
    self.announcementArray = [NSMutableArray new];
    self.announceTable = [[UITableView alloc]init];
    self.announceTable.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1];
    self.announceTable.delegate =self;
    self.announceTable.dataSource =self;
    [self.announceTable addSubview:self.refreshControl];
    [self.view addSubview:self.announceTable];
    
    if (IS_IPAD) {
        toolbarBackground.translatesAutoresizingMaskIntoConstraints=NO;
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[toolbarBackground(64)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(toolbarBackground)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[toolbarBackground]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(toolbarBackground)]];
        
        self.announceTable.translatesAutoresizingMaskIntoConstraints=NO;
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_announceTable]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_announceTable)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-64-[_announceTable]-56-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_announceTable)]];
        
    }
    else if (IS_IPHONE){
        [toolbarBackground setFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
        [self.announceTable setFrame:CGRectMake(0.0, 64.0, 320.0, self.view.frame.size.height - self.tabBarController.tabBar.frame.size.height-64)];
    }
    
    [[[[[self tabBarController] tabBar] items] objectAtIndex:2] setBadgeValue:nil];
    
    NSString *objId = [[NSUserDefaults standardUserDefaults] objectForKey:@"ObjectId"];
    
    if ([self.userType isEqualToString:@"Teacher"]) {
        
        self.annObj = [[AnnouncementObject alloc]initWithTeacherId:objId];

        [self.annObj restartBadgeInDatabase:objId className:[self.className lowercaseString]];
        
        self.rightBarButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAnnouncement)];
        [self.navigationItem setRightBarButtonItem:self.rightBarButton];
        
        //set up the class list arrays
        NSError *error;
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"TeacherObject"];
        request.predicate = [NSPredicate predicateWithFormat:@"teacherId = %@",objId];
        NSArray *foundTeacher = [_managedObjectContext executeFetchRequest:request error:&error];
        TeacherObject *teacherObj = [foundTeacher firstObject];
        self.classListArrayjsonString = teacherObj.classList;
    }
    
    else{
        
        self.annObj = [[AnnouncementObject alloc]initWithTeacherId:self.teacherIdForStudent];
        [self.annObj restartBadgeInDatabase:objId className:[self.className lowercaseString]];
    }
    

    
    [self makeTable];

    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    
    if ([self.userType isEqualToString:@"Teacher"]) {
        
        
        self.rightBarButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAnnouncement)];
        [self.tabBarController.navigationItem setRightBarButtonItem:self.rightBarButton];
        
    }

    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(didBecomeActive) name: UIApplicationDidBecomeActiveNotification object: nil];
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //Check connection
    if (self.connection!=nil && self.announceTable!=nil) {
        [self.connection removeFromSuperview];
        self.connection=nil;
        [self refreshBroadcast];
    }
    else if(self.connection !=nil && self.announceTable ==nil){
        [self.connection removeFromSuperview];
        self.connection=nil;
        [self makeTable];
    }
}

-(void)didBecomeActive{
    
    if (self.connection!=nil && self.announceTable!=nil) {
        [self.connection removeFromSuperview];
        self.connection=nil;
        [self refreshBroadcast];
    }
    else if(self.connection !=nil && self.announceTable ==nil){
        [self.connection removeFromSuperview];
        self.connection=nil;
        [self makeTable];
    }
    else if(self.connection == nil && self.announceTable !=nil){
        [self refreshBroadcast];
    }
    else if(self.connection == nil && self.announceTable ==nil){
        [self makeTable];
    }
}


-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    
    if (self.announcementPost != nil) {
        [self postAnnouncementCancelButton];
    }
    
}


-(void)emptyBroadcast{
    
    self.closedView = [UIView new];
    [self.closedView setUserInteractionEnabled:YES];
    [self.closedView setBackgroundColor:[UIColor colorWithWhite:0.2 alpha:0.5]];
    [self.view addSubview:self.closedView];
    
    UIImageView *tutorialbackground = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"blackboardBorder"]];
    [tutorialbackground setTag:1000];
    [tutorialbackground setAlpha:0];
    [self.closedView addSubview:tutorialbackground];
    
    if (IS_IPHONE) {
        [self.closedView setFrame:self.view.frame];
        
        [tutorialbackground setFrame:CGRectMake(0, 90, 320, 200)];
        
        if ([self.userType isEqualToString:@"Teacher"]){
            BouncingPencil *pencilArrow = [[BouncingPencil alloc]initWithFrame:CGRectMake(220, 44, 60, 60)];
            [pencilArrow setTag:2000];
            [pencilArrow setUpPencilBounceFrame:pencilArrow.frame targetX:15 targetY:-9 rotation:5*M_PI_4];
            [self.closedView addSubview:pencilArrow];
        }
        
    }
    else if (IS_IPAD){
        self.closedView.translatesAutoresizingMaskIntoConstraints=NO;
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_closedView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_closedView)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_closedView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_closedView)]];
        
        if ([self.userType isEqualToString:@"Teacher"]) {
            
            //Set bouncing Pencil
            BouncingPencil *pencilArrow = [[BouncingPencil alloc]init];
            [pencilArrow setTag:2000];
            [self.closedView addSubview:pencilArrow];
            pencilArrow.translatesAutoresizingMaskIntoConstraints=NO;
            [self.closedView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-45-[pencilArrow(60)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(pencilArrow)]];
            [self.closedView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[pencilArrow(60)]-50-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(pencilArrow)]];
            [pencilArrow setUpPencilBounceForiPad:CGSizeMake(60, 60) targetX:15 targetY:-9 rotation:5*M_PI_4];
            
        }
        
        tutorialbackground.translatesAutoresizingMaskIntoConstraints=NO;
        [self.closedView addConstraint:[NSLayoutConstraint constraintWithItem:tutorialbackground attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.closedView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [self.closedView addConstraint:[NSLayoutConstraint constraintWithItem:tutorialbackground attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.closedView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
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
        if ([self.userType isEqualToString:@"Teacher"]) {
            [tutorialLabel setText:@"Present your first broadcast to your students \n \n All your students who signed up will receive your broadcast."];
        }
        else{
            [tutorialLabel setText:@"There's currently no broadcast from your teacher yet. \n \n Come back and check often. You don't want to miss anything!"];
        }
        [tutorialbackground addSubview:tutorialLabel];
    }];
}

-(void)refreshBroadcast{
    
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
    
    [self.annObj getAnnouncementArrayFor:self.userType className:self.className completion:^(NSArray *objectArray, NSError *error) {
        
        if (!error) {
            
            if (self.connection != nil) {
                [self.connection removeFromSuperview];
                self.connection=nil;
            }
            
            if (!objectArray || [objectArray count] == 0) {
                [self emptyBroadcast];
                
            }
            else{
                
                if (self.closedView !=nil) {
                    [self.closedView removeFromSuperview];
                    self.closedView = nil;
                    
                }
                
                
                [self.announcementArray removeAllObjects];
                [self.announcementArray addObjectsFromArray:objectArray];
                [self.announceTable reloadData];
            }
        }
        else{
            
            if (self.connection ==nil) {
                
                self.connection = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, 64, self.view.frame.size.width,30)];
                [self.connection setBackgroundColor:[UIColor redColor]];
                [self.connection setTextColor:[UIColor whiteColor]];
                self.connection.textAlignment = NSTextAlignmentCenter;
                [self.connection setText:@"No Internet Connection"];
                [self.view addSubview:self.connection];
            }
        }
        [loadingView stopAnimating];
        [loadingView removeFromSuperview];
        [loadingLabel removeFromSuperview];
    }];

    
}

-(void)makeTable{
    //teacher's announcement
    
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
    
    [self.annObj getAnnouncementArrayFor:self.userType className:self.className completion:^(NSArray *objectArray, NSError *error) {
        
        if (!error) {
            
            
            if (self.connection != nil) {
                [self.connection removeFromSuperview];
                self.connection=nil;
            }
            
            
            if (!objectArray || [objectArray count] == 0) {
                if (self.closedView == nil) {
                    [self emptyBroadcast];
                }
            }
            else{
                
                if (self.closedView !=nil) {
                    [self.closedView removeFromSuperview];
                    self.closedView=nil;
                }
                
                [self.announcementArray removeAllObjects];
                [self.announcementArray addObjectsFromArray:objectArray];
                [self.announceTable reloadData];
            }
        }
        else{
            
            if (self.connection ==nil) {
                
                self.connection = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, 64, self.view.frame.size.width,30)];
                [self.connection setBackgroundColor:[UIColor redColor]];
                [self.connection setTextColor:[UIColor whiteColor]];
                self.connection.textAlignment = NSTextAlignmentCenter;
                [self.connection setText:@"No Internet Connection"];
                [self.view addSubview:self.connection];
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

    return [self.announcementArray count];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.annObj.announceDictionary = [self.announcementArray objectAtIndex:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.userType isEqualToString:@"Teacher"]){
        [self performSegueWithIdentifier:@"broadcastSegue" sender:self];
    }
    else{
        [self performSegueWithIdentifier:@"studentBroadcastSegue" sender:self];
    }
    
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat result;
    
    if (IS_IPAD) {
        result = 120;
        return result;
    }
    else if (IS_IPHONE){
        result = 90;
        return result;
    }
    else{
        result = 90;
        return result;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"studentCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"studentCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        UILabel* titleLabel = [[UILabel alloc]init];
        [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
        titleLabel.numberOfLines=0;
        [titleLabel setTag:1];
        [cell.contentView addSubview:titleLabel];
        
        UILabel* dateLabel = [[UILabel alloc]init];
        [dateLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
        dateLabel.numberOfLines=0;
        [dateLabel setTag:2];
        [cell.contentView addSubview:dateLabel];
        
        UIImageView *clockImage = [[UIImageView alloc]init];
        clockImage.contentMode=UIViewContentModeScaleAspectFill;
        [clockImage setImage:[UIImage imageNamed:@"clockImage"]];
        [cell.contentView addSubview:clockImage];

        UIImageView *announcementPicture = [[UIImageView alloc]init];
        [announcementPicture setTag:3];
        [cell.contentView addSubview:announcementPicture];
        
        if (IS_IPAD) {
            
            announcementPicture.translatesAutoresizingMaskIntoConstraints=NO;
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[announcementPicture(100)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(announcementPicture)]];
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[announcementPicture(100)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(announcementPicture)]];
            
            titleLabel.translatesAutoresizingMaskIntoConstraints=NO;
            [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18]];
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[announcementPicture]-80-[titleLabel]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(announcementPicture,titleLabel)]];
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[titleLabel(58)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)]];
            
            clockImage.translatesAutoresizingMaskIntoConstraints=NO;
            dateLabel.translatesAutoresizingMaskIntoConstraints=NO;
            [dateLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[clockImage(20)]-8-[dateLabel]-100-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(clockImage,dateLabel)]];
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[clockImage]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(clockImage)]];
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[dateLabel(34)]-3-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(dateLabel)]];
        }
        else if (IS_IPHONE){
            [titleLabel setFrame:CGRectMake(80, 5,self.view.frame.size.width-85,55)];
            [dateLabel setFrame:CGRectMake(130,5+titleLabel.frame.size.height,self.view.frame.size.width-135,30)];
            [clockImage setFrame:CGRectMake(dateLabel.frame.origin.x-25, dateLabel.frame.origin.y+5, 20, 20)];
            [announcementPicture setFrame:CGRectMake(10, 20, 90-40, 90-40)];
            
        }
        
    }
    
    NSDictionary * announcementObject = [self.announcementArray objectAtIndex:indexPath.row];
    [(UILabel *)[cell.contentView viewWithTag:1] setText:announcementObject[@"AnnouncementBody"]]; //add text
    
    //Get the date from array
    NSDateFormatter *annDateFormatter = [[NSDateFormatter alloc] init];
    annDateFormatter.timeZone = [NSTimeZone localTimeZone];
    annDateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *annDate = [annDateFormatter dateFromString:announcementObject[@"CreatedAt"]];
    
    //Format the date and time
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
    [timeFormatter setDateFormat:@"hh:mm a"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit|NSHourCalendarUnit;
    NSDateComponents *pickerDate = [calendar components:unitFlags fromDate:annDate toDate:[NSDate date] options:0];
    int year = (int)[pickerDate year];
    int month = (int)[pickerDate month];
    int day = (int)[pickerDate day];
    int hour = (int)[pickerDate hour];
    
    //Print out the date using dateString
    NSString *dateString;
    if (year ==0 && month==0 && day==0 && hour<12) {
        dateString = [NSString stringWithFormat:@"Today at : %@",[timeFormatter stringFromDate:annDate]];
    }
    else if (year == 0 && month==0 && ((day==0 && hour>12) || (day==1 && hour<12)) ){
        dateString = [NSString stringWithFormat:@"Yesterday at : %@",[timeFormatter stringFromDate:annDate]];
    }
    else{
        dateString = [NSString stringWithFormat:@"%@ at : %@",[dateFormatter stringFromDate:annDate],[timeFormatter stringFromDate:annDate]];
    }
    [(UILabel *)[cell.contentView viewWithTag:2] setText:dateString];
    
    //Create icon picture for the announcement
    if ([announcementObject[@"AnnouncementType"] isEqualToString:@"Announcement"]) {
        [(UIImageView *)[cell.contentView viewWithTag:3] setImage:[UIImage imageNamed:@"megaphoneImage50x"]];
    }
    else if([announcementObject[@"AnnouncementType"] isEqualToString:@"Homework"]){
        [(UIImageView *)[cell.contentView viewWithTag:3] setImage:[UIImage imageNamed:@"homeworkIcon50x"]];
    }
    else if([announcementObject[@"AnnouncementType"] isEqualToString:@"Store"]){
        [(UIImageView *)[cell.contentView viewWithTag:3] setImage:[UIImage imageNamed:@"storeIcon50x"]];
    }
    else{
        [(UIImageView *)[cell.contentView viewWithTag:3] setImage:[UIImage imageNamed:@"megaphoneImage50x"]];
    }
    return cell;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    //How far away it is from the origin
    NSInteger currentOffset = scrollView.contentOffset.y;
    NSInteger maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    if ((maximumOffset - currentOffset <= -10) && (scrollView.contentSize.height > self.announceTable.frame.size.height)) {
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            [scrollView setContentSize:CGSizeMake(scrollView.contentSize.width,scrollView.contentSize.height+40) ];
        } completion:^(BOOL finished) {
            
            UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-60, scrollView.contentSize.height-35, 30, 30)];
            [scrollView addSubview:loadingView];
            UILabel *loadingLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-30,scrollView.contentSize.height-35, 130, 30)];
            [loadingLabel setText:@"Loading more..."];
            [loadingLabel setFont:[UIFont systemFontOfSize:14]];
            [loadingLabel setTextColor:[UIColor darkGrayColor]];
            [scrollView addSubview:loadingLabel];
            [loadingView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
            [loadingView hidesWhenStopped];
            [loadingView startAnimating];
            
            self.annObj.broadcastOffset=+ [self.announcementArray count];
            [self.annObj getAnnouncementArrayFor:self.userType className:self.className completion:^(NSArray *objectArray, NSError *error) {
                
                [loadingLabel removeFromSuperview];
                [loadingView removeFromSuperview];
                
                if ([objectArray count]>0) {
                    [self.announcementArray addObjectsFromArray:objectArray];
                    [self.announceTable reloadData];
                }
                else{
                    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                        [scrollView setContentSize:CGSizeMake(scrollView.contentSize.width,scrollView.contentSize.height-40) ];
                    } completion:nil];
                }

            }];

        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addAnnouncement{
    if (self.connection !=nil) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Check your connection" message:@"You may not post a broadcast until you have network connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else{
        
        UIBarButtonItem *announcementPostRightBarButton = [[UIBarButtonItem alloc]initWithTitle:@"Post" style:UIBarButtonItemStylePlain target:self action:@selector(postAnnouncementDoneAction)];
        
        UIBarButtonItem *announcementPostLeftBarButton = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(postAnnouncementCancelButton)];
        
        self.tabBarController.navigationItem.title = @"Post Announcement";
        self.tabBarController.navigationItem.rightBarButtonItem = announcementPostRightBarButton;
        self.tabBarController.navigationItem.leftBarButtonItem = announcementPostLeftBarButton;
        
        //set frame
        if (IS_IPAD) {
            self.announcementPost = [[PostAnnouncement alloc]initWithFrame:CGRectZero];
            [self.view addSubview:self.announcementPost];
            self.announcementPost.className = self.className;
            [self.announcementPost setUpView];

            self.announcementPost.translatesAutoresizingMaskIntoConstraints=NO;
            NSArray *hidePostConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-hideSpacing-[_announcementPost(hideSpacing)]" options:0 metrics:@{@"hideSpacing": @((int)self.view.bounds.size.height)} views:NSDictionaryOfVariableBindings(_announcementPost)];

            [self.view addConstraints:hidePostConstraint];
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_announcementPost]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_announcementPost)]];
            
            [self.view layoutIfNeeded];
            [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                
                [self.view removeConstraints:hidePostConstraint];
                [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_announcementPost]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_announcementPost)]];
                
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                self.tabBarController.navigationItem.title = @"Post Announcement";
                self.tabBarController.navigationItem.rightBarButtonItem = announcementPostRightBarButton;
                self.tabBarController.navigationItem.leftBarButtonItem = announcementPostLeftBarButton;
            }];
            
        }
        else if (IS_IPHONE){
            self.announcementPost = [[PostAnnouncement alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
            self.announcementPost.className = self.className;
            [self.announcementPost setUpView];
            [self.view addSubview:self.announcementPost];
            
            [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                
                self.announcementPost.frame = self.view.frame;
                
            } completion:^(BOOL finished) {
            }];
        }
        NSString *objId = [[NSUserDefaults standardUserDefaults] objectForKey:@"ObjectId"];
        
        //update the taken
        QueryWebService *query = [[QueryWebService alloc]initWithTable:@"StudentObject"];
        [query selectColumnWhere:@"teacher" equalTo:objId];
        [query findAllObjectsInRowWithCompletion:^(NSError *error, NSArray *rows) {
            if (!error) {
                self.studentsTaken = [[NSMutableArray alloc]initWithCapacity:0];
                
                for (NSDictionary *studentObject in rows){
                    
                    StudentObject*studentObjInCore = [StudentObject createStudentObjectInCoreWithDictionary:studentObject inManagedObjectContext:_managedObjectContext];
                    studentObjInCore.taken = studentObject[@"taken"];
                    
                    if (![studentObjInCore.taken isEqualToString:@""]) {
                        [self.studentsTaken addObject:studentObjInCore];
                    }
                }
                [_managedObjectContext save:nil];
            }
        }];
        
    }
    
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    //reset offset
    self.annObj.broadcastOffset = 0;
    [self.annObj getAnnouncementArrayFor:self.userType className:self.className completion:^(NSArray *objectArray, NSError *error) {
        
        if (!error) {
            
            if (self.connection !=nil) {
                [self.connection removeFromSuperview];
                self.connection=nil;
            }
            
            if (![objectArray isEqualToArray:self.announcementArray]) {

                [self.announcementArray removeAllObjects];
                [self.announcementArray addObjectsFromArray:objectArray];
                [self.announceTable reloadData];
                
            }

        }
        else{
            if (self.connection ==nil) {
                
                self.connection = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, 64, self.view.frame.size.width,30)];
                [self.connection setBackgroundColor:[UIColor redColor]];
                [self.connection setTextColor:[UIColor whiteColor]];
                self.connection.textAlignment = NSTextAlignmentCenter;
                [self.connection setText:@"No Internet Connection"];
                [self.view addSubview:self.connection];
            }        }
        
        [refreshControl endRefreshing];

    }];
    
}

     
-(void)postAnnouncementCancelButton{
    
    self.tabBarController.navigationItem.title=self.classTitle;
    self.tabBarController.navigationItem.rightBarButtonItem = self.rightBarButton;
    self.tabBarController.navigationItem.leftBarButtonItem = nil;
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{

        self.announcementPost.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
        
    } completion:^(BOOL finished) {

        [self.announcementPost.pickerToWhom removeFromSuperview];
        [self.announcementPost.pickerType removeFromSuperview];
        [self.announcementPost removeFromSuperview];
        self.announcementPost=nil;
    }];
}


-(void)postAnnouncementDoneAction{

    if ([self.announcementPost.whatTypeTextField.text isEqualToString:@""]&&[self.announcementPost.toWhomTextField.text isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops, did you forget something?" message:@"You must fill in all of fields before you can post" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else{
        if ([self.announcementPost.toWhomTextField.text isEqualToString:@""]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uh Oh, you forgot to tell me who this is for" message:@"Please complete To: field" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else if ([self.announcementPost.whatTypeTextField.text isEqualToString:@""]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You forgot to tell me what type of broadcast this is" message:@"Please complete Type: field" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else if ([self.announcementPost.textView.text isEqualToString:@""]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You have an empty broadcast" message:@"Please complete the body of your broadcast" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else{
            
            if (self.connection != nil) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please check your wireless connection" message:@"You cannot post anything until you have an internet connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            else{
                UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Are you sure you want to post your broadcast?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Post!", nil];
                actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
                [actionSheet showInView:self.view];
            }
        }
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *objId = [[NSUserDefaults standardUserDefaults] objectForKey:@"ObjectId"];
    
	// The user tapped one of the OK/Cancel buttons.
	if (buttonIndex == 0)
	{
        //post in database
        
        [self.annObj postAnnouncementTo:self.announcementPost.toWhomTextField.text announcementType:self.announcementPost.whatTypeTextField.text personType:@"Student" announcementBody:self.announcementPost.textView.text];
        
        
        NSString *logString = [NSString stringWithFormat:@"%@: %@",self.announcementPost.whatTypeTextField.text,self.announcementPost.textView.text];
        
     
        //update log
        if ([self.announcementPost.toWhomTextField.text isEqualToString:@"Every Class"]) {
            
            LogWebService *teacherAnnouncementLog = [[LogWebService alloc]initWithLogType:@"announcement"];
            [teacherAnnouncementLog updateLogWithUserId:objId className:self.classListArrayjsonString updateLogString:logString];
            
            //get id from core data
            NSError* error;
            NSFetchRequest *studentsRequest = [NSFetchRequest fetchRequestWithEntityName:@"StudentObject"];
            studentsRequest.predicate= [NSPredicate predicateWithFormat:@"teacher = %@",objId];
            NSArray *studentObjArray = [_managedObjectContext executeFetchRequest:studentsRequest error:&error];
            
            for (StudentObject *studentObject in studentObjArray){
                
                LogWebService *studentAnnouncementLog = [[LogWebService alloc]initWithLogType:@"announcement"];
                [studentAnnouncementLog updateLogWithUserId:studentObject.objectId className:studentObject.nameOfclass updateLogString:logString];
                
            }
            
        }
        else{
            
            LogWebService *teacherAnnouncementLog = [[LogWebService alloc]initWithLogType:@"announcement"];
            [teacherAnnouncementLog updateLogWithUserId:objId className:self.classListArrayjsonString updateLogString:logString];
            
            
            NSError* error;
            NSFetchRequest *studentsRequest = [NSFetchRequest fetchRequestWithEntityName:@"StudentObject"];
            studentsRequest.predicate= [NSPredicate predicateWithFormat:@"(teacher = %@) AND (nameOfclass = %@)",objId,[self.className lowercaseString]];
            NSArray *studentObjArray = [_managedObjectContext executeFetchRequest:studentsRequest error:&error];
            for (StudentObject *studentObject in studentObjArray){
                
                LogWebService *studentAnnouncementLog = [[LogWebService alloc]initWithLogType:@"announcement"];
                [studentAnnouncementLog updateLogWithUserId:studentObject.objectId className:studentObject.nameOfclass updateLogString:logString];
                
            }

        }

        //send notification to students
        self.pushService = [[PushWebService alloc]init];
        NSMutableArray *studentsIDs = [[NSMutableArray alloc]initWithCapacity:0];
        for (StudentObject *studentObjects in self.studentsTaken) {
            
            if([self.announcementPost.toWhomTextField.text isEqualToString:self.className] && [[studentObjects.nameOfclass capitalizedString] isEqualToString:self.className]){
                
                [studentsIDs addObject:studentObjects.taken];
                [self.annObj updateBadgeToDatabaseWithId:studentObjects.taken className:self.className];
            }
            else{
                [studentsIDs addObject:studentObjects.taken];
                [self.annObj updateBadgeToDatabaseWithId:studentObjects.taken className:nil];
            }
        }
        [self.pushService sendPushToUserIDS:studentsIDs pushMessage:logString];

        //post in UI
        NSDateFormatter *annDateFormatter = [[NSDateFormatter alloc] init];
        annDateFormatter.timeZone = [NSTimeZone localTimeZone];
        annDateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSString *dateString = [annDateFormatter stringFromDate:[NSDate date]];
        
        NSDictionary *newAnnouncement = @{@"AnnouncementBody": self.announcementPost.textView.text,
                                          @"AnnouncementType":self.announcementPost.whatTypeTextField.text,
                                          @"Recipient":self.announcementPost.toWhomTextField.text,
                                          @"CreatedAt":dateString,
                                          @"PersonType":@"Student",
                                          @"TeacherId":objId};
        
       

        [self.announcementArray insertObject:newAnnouncement atIndex:0];
        [self.announceTable reloadData];
        [self postAnnouncementCancelButton];

        if (self.closedView !=nil) {
            [self.closedView removeFromSuperview];
            self.closedView=nil;
        }
        
    }
}

//Deleting a row
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
    NSString *objId = [[NSUserDefaults standardUserDefaults] objectForKey:@"ObjectId"];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSString *logString = [NSString stringWithFormat:@"DELETED BROADCAST - %@: %@",self.announcementArray[indexPath.row][@"AnnouncementType"],self.announcementArray[indexPath.row][@"AnnouncementBody"]];
        NSString *className = self.announcementArray[indexPath.row][@"Recipient"];
        
        [self.annObj deleteRowInBroadcast:self.announcementArray[indexPath.row]];
        
        [self.announcementArray removeObjectAtIndex:indexPath.row];
        
        [self.announceTable beginUpdates];
        [self.announceTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.announceTable endUpdates];
        
        if ([self.announcementArray count] == 0) {
            [self emptyBroadcast];
        }
        
        //update log
        if ([className isEqualToString:@"Every Class"]) {
            
            LogWebService *teacherAnnouncementLog = [[LogWebService alloc]initWithLogType:@"announcement"];
            [teacherAnnouncementLog updateLogWithUserId:objId className:self.classListArrayjsonString updateLogString:logString];
            
            //get id from core data
            NSError *error;
            NSFetchRequest *studentsRequest = [NSFetchRequest fetchRequestWithEntityName:@"StudentObject"];
            studentsRequest.predicate= [NSPredicate predicateWithFormat:@"teacher = %@",objId];
            NSArray *studentObjArray = [_managedObjectContext executeFetchRequest:studentsRequest error:&error];
            
            for (StudentObject *studentObject in studentObjArray){
                
                LogWebService *studentAnnouncementLog = [[LogWebService alloc]initWithLogType:@"announcement"];
                [studentAnnouncementLog updateLogWithUserId:studentObject.objectId className:studentObject.nameOfclass updateLogString:logString];
                
            }
            
        }
        else{
            NSError* error;
            NSFetchRequest *studentsRequest = [NSFetchRequest fetchRequestWithEntityName:@"StudentObject"];
            studentsRequest.predicate= [NSPredicate predicateWithFormat:@"(teacher = %@) AND (nameOfclass = %@)",objId,[self.className lowercaseString]];
            NSArray *studentObjArray = [_managedObjectContext executeFetchRequest:studentsRequest error:&error];
            for (StudentObject *studentObject in studentObjArray){
                
                LogWebService *studentAnnouncementLog = [[LogWebService alloc]initWithLogType:@"announcement"];
                [studentAnnouncementLog updateLogWithUserId:studentObject.objectId className:studentObject.nameOfclass updateLogString:logString];
                
            }
            
        }

    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"broadcastSegue"] || [segue.identifier isEqualToString:@"studentBroadcastSegue"]){
        
        BroadcastMoreViewController *broadMoreVC = (BroadcastMoreViewController*)segue.destinationViewController;
        broadMoreVC.announcementObj = self.annObj.announceDictionary;
        broadMoreVC.className = self.className;
        broadMoreVC.studentObj = self.currentStudentObj;
        broadMoreVC.demoManagedObjectContext=self.demoManagedObjectContext;
    }

}


@end
