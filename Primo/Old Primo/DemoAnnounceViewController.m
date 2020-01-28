//
//  DemoAnnounceViewController.m
//  Primo
//
//  Created by Jarrett Chen on 8/27/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import "DemoAnnounceViewController.h"

@interface DemoAnnounceViewController ()

@property (nonatomic,strong) NSMutableArray *announcementArray;
@property (nonatomic,strong) NSMutableArray *announcementPictureArray;
@property (nonatomic,strong) NSMutableArray *announcementDate;
@property (nonatomic,strong) UIBarButtonItem *rightBarButton;

//table information
@property (nonatomic,strong) NSString *announcementString;
@property (nonatomic,strong) UITableView *announceTable;
@property (nonatomic) NSInteger numberOfTableRows;

@property (nonatomic,strong) UIView *closedView;

//announcement info
@property (nonatomic,strong) PostAnnouncement *announcementPost;

@property (nonatomic,strong) NSMutableArray *studentsTaken;

@property DemoBroadcast *broadcastToPass;

//Tutorial
@property (nonatomic,strong) DemoTeacher *teacherProgress;
@property (nonatomic,strong) DemoStudent *studentProgress;
@property (nonatomic,strong) UIProgressView *demoProgressBar;
@property (nonatomic,strong) UIView *beginningTutorialView;

@end

@implementation DemoAnnounceViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    UIImageView *toolbarBackground = [[UIImageView alloc]init];
    [toolbarBackground setImage:[UIImage imageNamed:@"blackboardBar"]];
    toolbarBackground.userInteractionEnabled=YES;
    [self.view addSubview:toolbarBackground];
    
    self.announcementArray = [[NSMutableArray alloc]initWithCapacity:0];
    self.announceTable = [[UITableView alloc]init];
    self.announceTable.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1];
    self.announceTable.delegate =self;
    self.announceTable.dataSource =self;
    [self.view addSubview:self.announceTable];
    
    if (IS_IPAD) {
        toolbarBackground.translatesAutoresizingMaskIntoConstraints=NO;
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[toolbarBackground(64)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(toolbarBackground)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[toolbarBackground]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(toolbarBackground)]];
        
        self.announceTable.translatesAutoresizingMaskIntoConstraints=NO;
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_announceTable]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_announceTable)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-64-[_announceTable]-99-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_announceTable)]];
    }
    else if(IS_IPHONE){
        [toolbarBackground setFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];

        [self.announceTable setFrame:CGRectMake(0.0, 64.0, 320.0, self.view.frame.size.height - self.tabBarController.tabBar.frame.size.height-64-35)];
    }

    //Tutorial
    self.demoProgressBar= [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    [self.view addSubview:self.demoProgressBar];
    self.demoProgressBar.translatesAutoresizingMaskIntoConstraints=NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_demoProgressBar]-20-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_demoProgressBar)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_demoProgressBar(12)]-60-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_demoProgressBar)]];
    
    //Tutorial
    if([self.userType isEqualToString:@"Teacher"]){
        self.teacherProgress = [DemoTeacher findTeacherProgress:_demoManagedObjectContext];
    }
    else{
        self.studentProgress = [DemoStudent findStudentProgress:_demoManagedObjectContext];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    
    if ([self.userType isEqualToString:@"Teacher"]) {
        
        
        self.rightBarButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAnnouncement)];
        [self.tabBarController.navigationItem setRightBarButtonItem:self.rightBarButton];
        
    }
    
    [self makeTable];
}

-(void)viewDidAppear:(BOOL)animated{
    
    if([self.userType isEqualToString:@"Teacher"]){
        [self.demoProgressBar setProgress:[self.teacherProgress getTotalProgress] animated:YES];
    }
    else{
        [self tutorialBeginning];
        
        [self.demoProgressBar setProgress:[self.studentProgress getTotalProgress] animated:YES];
    }
}

-(void)viewWillDisappear:(BOOL)animated{

    if (self.announcementPost != nil) {
        [self postAnnouncementCancelButton];
    }
    
    if (![self.userType isEqualToString:@"Teacher"]) {
        [self handleTap];
    }
}

-(void)tutorialBeginning{
    if(![self.userType isEqualToString:@"Teacher"]){
        UITapGestureRecognizer *closeGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap)];
        
        self.beginningTutorialView = [UIView new];
        [self.beginningTutorialView setUserInteractionEnabled:YES];
        [self.beginningTutorialView setBackgroundColor:[UIColor colorWithWhite:0.1 alpha:0.8]];
        [self.beginningTutorialView addGestureRecognizer:closeGesture];
        [self.view addSubview:self.beginningTutorialView];
        
        UIImageView *tutorialbackground = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"blackboardBorder"]];
        [tutorialbackground setTag:1000];
        [tutorialbackground setAlpha:0];
        [self.beginningTutorialView addSubview:tutorialbackground];
        
        if(IS_IPHONE){
            [self.beginningTutorialView setFrame:self.view.frame];
            [tutorialbackground setFrame:CGRectMake(0, 200, 320, 180)];
        }
        else if (IS_IPAD){
            self.beginningTutorialView.translatesAutoresizingMaskIntoConstraints=NO;
            tutorialbackground.translatesAutoresizingMaskIntoConstraints=NO;
            
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_beginningTutorialView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_beginningTutorialView)]];
            
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_beginningTutorialView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_beginningTutorialView)]];
            
            [self.beginningTutorialView addConstraint:[NSLayoutConstraint constraintWithItem:tutorialbackground attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.beginningTutorialView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
            [self.beginningTutorialView addConstraint:[NSLayoutConstraint constraintWithItem:tutorialbackground attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.beginningTutorialView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
            
        }
        
        CGAffineTransform transform = CGAffineTransformMakeScale(0.9, 0.9);
        [tutorialbackground.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            [tutorialbackground setAlpha:1];
            [tutorialbackground setTransform:transform];
            
        } completion:^(BOOL finished) {
            
            UILabel *closedLabel = [UILabel new];
            [closedLabel setFrame:CGRectMake(20,5,tutorialbackground.frame.size.width-40,tutorialbackground.frame.size.height-10)];
            [closedLabel setText:[NSString stringWithFormat:@"This is your classroom Broadcast \n\n Everything that your teacher broadcasts will be on this tab so stay updated!"]];
            [closedLabel setNumberOfLines:0];
            [closedLabel setFont:[UIFont fontWithName:@"Eraser" size:18]];
            [closedLabel setTextColor:[UIColor whiteColor]];
            [closedLabel setTextAlignment:NSTextAlignmentCenter];
            [tutorialbackground addSubview:closedLabel];
            
        }];
    }
    
}

-(void)handleTap{
    
    UIImageView *tutorialBackground = (UIImageView*)[self.beginningTutorialView viewWithTag:1000];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [tutorialBackground setAlpha:0];
        [tutorialBackground setTransform:CGAffineTransformMakeScale(10/9, 10/9)];
    } completion:^(BOOL finished) {
        [tutorialBackground removeFromSuperview];
        [self.beginningTutorialView removeFromSuperview];
        self.beginningTutorialView=nil;
        
    }];
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

-(void)makeTable{

    if ([self.userType isEqualToString:@"Teacher"]) {
    
        //Get classesListArray for table
        NSError*error;
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"DemoBroadcast"];
        request.predicate =[NSPredicate predicateWithFormat:@"personType = %@",@"Teacher"];
        NSSortDescriptor *broadcastSort = [[NSSortDescriptor alloc] initWithKey:@"objectId" ascending:NO];
        request.sortDescriptors = [NSArray arrayWithObjects:broadcastSort, nil];
        NSArray *teacherObjArray = [_demoManagedObjectContext executeFetchRequest:request error:&error];

        [self.announcementArray removeAllObjects];
        [self.announcementArray addObjectsFromArray:teacherObjArray];
        [self.announceTable reloadData];

        if ([self.announcementArray count] == 0) {
            
            if (self.closedView ==nil) {
                [self emptyBroadcast];
            }
        }
        else{
            if (self.closedView !=nil) {
                [self.closedView removeFromSuperview];
                self.closedView=nil;
            }
            
        }
    }
    else{
        NSDateFormatter *annDateFormatter = [[NSDateFormatter alloc] init];
        annDateFormatter.timeZone = [NSTimeZone localTimeZone];
        annDateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSString *dateString = [annDateFormatter stringFromDate:[NSDate date]];
        
        NSDictionary *broad1 = @{@"broadcast": @"Don't forget to study for the test tomorrow!",
                                 @"personType":@"Student",
                                 @"announcementType":@"Announcement",
                                 @"createdAt":dateString,
                                 @"objectId":@"stu1",
                                 @"recipient":@"Every Class"};
        NSDictionary *broad2 = @{@"broadcast": @"Homework assignment is postponed until Monday",
                                 @"personType":@"Student",
                                 @"announcementType":@"Homework",
                                 @"createdAt":dateString,
                                 @"objectId":@"stu2",
                                 @"recipient":@"Every Class"};
        NSDictionary *broad3 = @{@"broadcast": @"We will start social studies on Monday",
                                 @"personType":@"Student",
                                 @"announcementType":@"Homework",
                                 @"createdAt":dateString,
                                 @"objectId":@"stu3",
                                 @"recipient":@"Every Class"};
        NSDictionary *broad4 = @{@"broadcast": @"Back To School Night is tonight at 6:00PM!",
                                 @"personType":@"Student",
                                 @"announcementType":@"Announcement",
                                 @"createdAt":dateString,
                                 @"objectId":@"stu4",
                                 @"recipient":@"Every Class"};
        NSDictionary *broad5 = @{@"broadcast": @"There will be a substitute on Thursday",
                                 @"personType":@"Student",
                                 @"announcementType":@"Announcement",
                                 @"createdAt":dateString,
                                 @"objectId":@"stu5",
                                 @"recipient":@"Every Class"};
        NSDictionary *broad6 = @{@"broadcast": @"No School on Friday! Have a great 3 day weekend!!!",
                                 @"personType":@"Student",
                                 @"announcementType":@"Announcement",
                                 @"createdAt":dateString,
                                 @"objectId":@"stu6",
                                 @"recipient":@"Every Class"};
        NSDictionary *broad7 = @{@"broadcast": @"Don't forget to have your permission slip signed!!",
                                 @"personType":@"Student",
                                 @"announcementType":@"Homework",
                                 @"createdAt":dateString,
                                 @"objectId":@"stu7",
                                 @"recipient":@"Every Class"};
        
        NSArray *broadcastDict = @[broad1,broad2,broad3,broad4,broad5,broad6,broad7];
        
        [self.announcementArray removeAllObjects];
        
        for (NSDictionary *broadDict in broadcastDict) {
            DemoBroadcast *broadcastItem = [DemoBroadcast createBroadcastObjectInCoreWithDictionary:broadDict inManagedObjectContext:_demoManagedObjectContext];
            [self.announcementArray addObject:broadcastItem];
            [_demoManagedObjectContext save:nil];
        }
        [self.announceTable reloadData];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.announcementArray count];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.broadcastToPass = [self.announcementArray objectAtIndex:indexPath.row];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.userType isEqualToString:@"Teacher"]){
        [self performSegueWithIdentifier:@"demoMoreBroadSegue" sender:self];
    }
    else{
        [self performSegueWithIdentifier:@"demoStuBroadMore" sender:self];
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
    
    DemoBroadcast *broadcastItem = [self.announcementArray objectAtIndex:indexPath.row];
    [(UILabel *)[cell.contentView viewWithTag:1] setText:broadcastItem.broadcast]; //add text
    
    //Get the date from array
    NSDateFormatter *annDateFormatter = [[NSDateFormatter alloc] init];
    annDateFormatter.timeZone = [NSTimeZone localTimeZone];
    annDateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *annDate = [annDateFormatter dateFromString:broadcastItem.createdAt];
    
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
    if ([broadcastItem.broadcast isEqualToString:@"Announcement"]) {
        [(UIImageView *)[cell.contentView viewWithTag:3] setImage:[UIImage imageNamed:@"megaphoneImage50x"]];
    }
    else if([broadcastItem.announcementType isEqualToString:@"Homework"]){
        [(UIImageView *)[cell.contentView viewWithTag:3] setImage:[UIImage imageNamed:@"homeworkIcon50x"]];
    }
    else if([broadcastItem.announcementType isEqualToString:@"Store"]){
        [(UIImageView *)[cell.contentView viewWithTag:3] setImage:[UIImage imageNamed:@"storeIcon50x"]];
    }
    else{
        [(UIImageView *)[cell.contentView viewWithTag:3] setImage:[UIImage imageNamed:@"megaphoneImage50x"]];
    }
    return cell;
}

-(void)addAnnouncement{

        UIBarButtonItem *announcementPostRightBarButton = [[UIBarButtonItem alloc]initWithTitle:@"Post" style:UIBarButtonItemStylePlain target:self action:@selector(postAnnouncementDoneAction)];
        
        UIBarButtonItem *announcementPostLeftBarButton = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(postAnnouncementCancelButton)];
        
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
                self.tabBarController.navigationItem.title = @"Post Announcement";
                self.tabBarController.navigationItem.rightBarButtonItem = announcementPostRightBarButton;
                self.tabBarController.navigationItem.leftBarButtonItem = announcementPostLeftBarButton;
            }];
        }
}



-(void)postAnnouncementCancelButton{
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.announcementPost.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
        
    } completion:^(BOOL finished) {
        self.tabBarController.navigationItem.title = @"Broadcast";
        self.tabBarController.navigationItem.rightBarButtonItem = self.rightBarButton;
        self.tabBarController.navigationItem.leftBarButtonItem = nil;
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
            
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Are you sure you want to post your broadcast?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Post!", nil];
            actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
            [actionSheet showInView:self.view];
        
        }
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	// The user tapped one of the OK/Cancel buttons.
	if (buttonIndex == 0)
	{
        //post in database
        
        DemoBroadcast *lastBroadcast = [self.announcementArray lastObject];
        int lastNumber =[lastBroadcast.objectId intValue];
        lastNumber++;
        
        //post in UI
        NSDateFormatter *annDateFormatter = [[NSDateFormatter alloc] init];
        annDateFormatter.timeZone = [NSTimeZone localTimeZone];
        annDateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSString *dateString = [annDateFormatter stringFromDate:[NSDate date]];
        
        NSDictionary *broadcastDict = @{@"broadcast": self.announcementPost.textView.text,
                                        @"personType":@"Teacher",
                                        @"announcementType":self.announcementPost.whatTypeTextField.text,
                                        @"recipient":self.announcementPost.toWhomTextField.text,
                                        @"createdAt":dateString,
                                        @"objectId":[NSString stringWithFormat:@"%d",lastNumber]};

        DemoBroadcast *broadcastItem = [DemoBroadcast createBroadcastObjectInCoreWithDictionary:broadcastDict inManagedObjectContext:_demoManagedObjectContext];
        
        [_demoManagedObjectContext save:nil];
        
        [self.announcementArray insertObject:broadcastItem atIndex:0];
        [self.announceTable reloadData];

        if (self.closedView !=nil) {
            [self.closedView removeFromSuperview];
            self.closedView=nil;
            
            self.teacherProgress.addBroadcastDone = [NSNumber numberWithBool:YES];
            [_demoManagedObjectContext save:nil];
            [self.demoProgressBar setProgress:[self.teacherProgress getTotalProgress] animated:YES];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Awesome!" message:@"You successfully entered a broadcast" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
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
        [self postAnnouncementCancelButton];
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
    if (editingStyle == UITableViewCellEditingStyleDelete) {
    
        
        DemoBroadcast *broadcastDelete = [self.announcementArray objectAtIndex:indexPath.row];
        [_demoManagedObjectContext deleteObject:broadcastDelete];
        [_demoManagedObjectContext save:nil];
        
        
        [self.announcementArray removeObjectAtIndex:indexPath.row];
        
        [self.announceTable beginUpdates];
        [self.announceTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.announceTable endUpdates];
        
        
        if ([self.announcementArray count] == 0) {
            [self emptyBroadcast];
        }
        
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
//
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"demoMoreBroadSegue"] || [segue.identifier isEqualToString:@"demoStuBroadMore"]){
        
        DemoMoreBroadViewController *broadMoreVC = (DemoMoreBroadViewController*)segue.destinationViewController;
        broadMoreVC.managedObjectContext = self.managedObjectContext;
        broadMoreVC.className = self.className;
        broadMoreVC.demoManagedObjectContext = self.demoManagedObjectContext;
        broadMoreVC.broadcastItem = self.broadcastToPass;
        broadMoreVC.userType = self.userType;
    }
    
}

@end
