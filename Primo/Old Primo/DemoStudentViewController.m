//
//  DemoStudentViewController.m
//  Primo
//
//  Created by Jarrett Chen on 8/27/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import "DemoStudentViewController.h"

@interface DemoStudentViewController ()


//new student row arrays
@property(nonatomic,strong) NSMutableArray *studentsArrays;

@property(readonly,nonatomic) UITapGestureRecognizer *tapCloseRecognizer;
@property(readonly,nonatomic)UISwipeGestureRecognizer *swipeCloseRecognizer;
@property (nonatomic,strong)UIBarButtonItem *deleteButton;
@property (nonatomic,strong)UIBarButtonItem *addCoinsButton;
@property(nonatomic,strong) MenuTable *studentMenu;
@property(nonatomic,strong) manageCoinView *askCoinView;
@property(nonatomic,strong) DemoStudentObject *selectedStudentObjForLog;
@property(nonatomic,strong) NSString *dateString;
@property(nonatomic) NSInteger month;
@property(nonatomic,strong) UIToolbar *manageCoinToolbarSelection;

//connection
@property(nonatomic,strong) NSString *sortByString;
@property(nonatomic,strong) NSArray *pickerArray;
@property(nonatomic,strong) UIPickerView *pickerSort;
@property(nonatomic,strong) NSMutableDictionary *sortDictionary;
@property(nonatomic,strong) NSString *nameOfTeacher;

@property(nonatomic,strong) NSArray *hiddenTable;
@property(nonatomic,strong) NSArray *showTable;

@property(nonatomic,strong) NSArray *pinStudentTableToTop;
@property(nonatomic,strong) NSArray *pinStudentTableDown;

@property (nonatomic,strong) UITableView *studentTable;
@property(nonatomic,strong) NSMutableArray *studentSignedUpArray;

@property (nonatomic,strong) UIProgressView *demoProgressBar;
@property (nonatomic,strong) DemoTeacher *checkProgress;

@end

@implementation DemoStudentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tabBarController.navigationController.navigationBar.topItem.title = @"";
    
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"MM/dd/yyyy"];
    self.dateString =[dateFormat stringFromDate:today];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSMonthCalendarUnit;
    NSDateComponents* dateComponents = [calendar components:unitFlags fromDate:today];
    self.month = (int)[dateComponents month];
    

    self.studentSignedUpArray =[[NSMutableArray alloc]initWithCapacity:0];
    
    //ToolBar
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    UIImageView *toolbarBackground = [[UIImageView alloc]init];
    [toolbarBackground setImage:[UIImage imageNamed:@"blackboardBar"]];
    toolbarBackground.userInteractionEnabled=YES;
    [self.view addSubview:toolbarBackground];
    
    
    //Create the Table
    _studentTable = [[UITableView alloc]init];
    _studentTable.delegate =self;
    _studentTable.dataSource =self;
    self.studentTable.allowsMultipleSelectionDuringEditing = YES;
    self.studentTable.allowsSelection = YES;
    [self.view addSubview:_studentTable];
    
    if (IS_IPAD) {
        toolbarBackground.translatesAutoresizingMaskIntoConstraints=NO;
        self.studentTable.translatesAutoresizingMaskIntoConstraints=NO;
        
        //Toolbar
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[toolbarBackground(64)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(toolbarBackground)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[toolbarBackground]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(toolbarBackground)]];
        
        //Table classes
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_studentTable]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_studentTable)]];
        
        self.pinStudentTableToTop = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-64-[_studentTable]-99-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_studentTable)];
        [self.view addConstraints:self.pinStudentTableToTop];
        
        
    }
    else if (IS_IPHONE){
        [toolbarBackground setFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
        [self.studentTable setFrame:CGRectMake(0.0, 64.0, 320.0, self.view.frame.size.height - self.tabBarController.tabBar.frame.size.height-64-35)];
    }
    
    self.demoProgressBar= [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    [self.view addSubview:self.demoProgressBar];
    self.demoProgressBar.translatesAutoresizingMaskIntoConstraints=NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_demoProgressBar]-20-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_demoProgressBar)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_demoProgressBar(12)]-60-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_demoProgressBar)]];
    
    self.checkProgress = [DemoTeacher findTeacherProgress:_demoManagedObjectContext];

}

-(void)viewDidAppear:(BOOL)animated{
    [self.demoProgressBar setProgress:[self.checkProgress getTotalProgress] animated:YES];
    [self startTutorial];
}

-(void)startTutorial{
    
    [self hideTutorialArrow:YES hideBlackboard:YES];
    
    if (![self.checkProgress.addCoinsDone boolValue]) {
        
        UIImageView *tutorialbackground = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"blackboardBorder"]];
        [tutorialbackground setUserInteractionEnabled:YES];
        [tutorialbackground setTag:1000];
        [tutorialbackground setAlpha:0];
        [self.view addSubview:tutorialbackground];
        
        if(IS_IPHONE){
            [tutorialbackground setFrame:CGRectMake(10, 200, 300, 170)];
            
            BouncingPencil *pencilArrow = [[BouncingPencil alloc]initWithFrame:CGRectMake(95, 139, 60, 60)];
            [pencilArrow setTag:2000];
            [pencilArrow setUpPencilBounceFrame:pencilArrow.frame targetX:15 targetY:-9 rotation:5*M_PI_4];
            [self.view addSubview:pencilArrow];
        }
        else if (IS_IPAD){
            tutorialbackground.translatesAutoresizingMaskIntoConstraints=NO;
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[tutorialbackground(300)]-240-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tutorialbackground)]];
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-170-[tutorialbackground(170)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tutorialbackground)]];
            
            //Set bouncing pencil
            BouncingPencil *pencilArrow = [[BouncingPencil alloc]init];
            [pencilArrow setTag:2000];
            [self.view addSubview:pencilArrow];
            
            pencilArrow.translatesAutoresizingMaskIntoConstraints=NO;
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-150-[pencilArrow(60)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(pencilArrow)]];
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[pencilArrow(60)]-245-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(pencilArrow)]];
            [pencilArrow setUpPencilBounceForiPad:CGSizeMake(60, 60) targetX:15 targetY:-9 rotation:5*M_PI_4];

        }
        
        
        CGAffineTransform transform = CGAffineTransformMakeScale(0.9, 0.9);
        [tutorialbackground.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            [tutorialbackground setAlpha:1];
            [tutorialbackground setTransform:transform];
            
        } completion:^(BOOL finished) {
            
            UILabel *tutorialLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, tutorialbackground.frame.size.width-40, tutorialbackground.frame.size.height-10)];
            [tutorialLabel setFont:[UIFont fontWithName:@"Eraser" size:19]];
            [tutorialLabel setTextColor:[UIColor whiteColor]];
            [tutorialLabel setNumberOfLines:0];
            [tutorialLabel setText:@"Click on the + and - buttons to add or subtract coins from your students"];
            [tutorialbackground addSubview:tutorialLabel];
            
        }];
    }
    else if ([self.checkProgress.addCoinsDone boolValue] && ![self.checkProgress.manageCoinsDone boolValue]){
        
        UIImageView *tutorialbackground = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"blackboardBorder"]];
        [tutorialbackground setUserInteractionEnabled:YES];
        [tutorialbackground setTag:1000];
        [tutorialbackground setAlpha:0];
        [self.view addSubview:tutorialbackground];
        
        if(IS_IPHONE){
            [tutorialbackground setFrame:CGRectMake(10, 70, 300, 180)];
        }
        else if (IS_IPAD){
            tutorialbackground.translatesAutoresizingMaskIntoConstraints=NO;
            [tutorialbackground addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[tutorialbackground(350)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tutorialbackground)]];
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-200-[tutorialbackground(200)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tutorialbackground)]];
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tutorialbackground attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
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
            [tutorialLabel setText:@"Adding large amounts of coins (20 coins) may take forever. \n But theres a better way"];
            [tutorialbackground addSubview:tutorialLabel];
           
            UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [nextButton setTitle:@"Show me how! >" forState:UIControlStateNormal];
            [nextButton setFrame:CGRectMake(75, 140, 200, 30)];
            [nextButton.titleLabel setFont:[UIFont fontWithName:@"Eraser" size:17]];
            [nextButton setTitleColor:[UIColor colorWithRed:0.435294 green:0.90588 blue:0.8588 alpha:1] forState:UIControlStateNormal];
            [nextButton addTarget:self action:@selector(tutorialDemoNext:) forControlEvents:UIControlEventTouchUpInside];
            [tutorialbackground addSubview:nextButton];
        }];
    }
    else if ([self.checkProgress.addCoinsDone boolValue] && [self.checkProgress.manageCoinsDone boolValue] && [self.checkProgress.buyStoreDone boolValue] && ![self.checkProgress.checkStats boolValue]){
        
        UIImageView *tutorialbackground = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"blackboardBorder"]];
        [tutorialbackground setUserInteractionEnabled:YES];
        [tutorialbackground setTag:1000];
        [tutorialbackground setAlpha:0];
        [self.view addSubview:tutorialbackground];
        
        if(IS_IPHONE){
            [tutorialbackground setFrame:CGRectMake(10, 200, 300, 100)];
            
            BouncingPencil *pencilArrow = [[BouncingPencil alloc]initWithFrame:CGRectMake(100, 120, 60, 60)];
            [pencilArrow setTag:2000];
            [pencilArrow setUpPencilBounceFrame:pencilArrow.frame targetX:-15 targetY:-9 rotation:3*M_PI_4];
            [self.view addSubview:pencilArrow];
        }
        else if (IS_IPAD){
            tutorialbackground.translatesAutoresizingMaskIntoConstraints=NO;
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-100-[tutorialbackground(300)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tutorialbackground)]];
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-200-[tutorialbackground(170)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tutorialbackground)]];
            
            //Set bouncing pencil
            BouncingPencil *pencilArrow = [[BouncingPencil alloc]init];
            [pencilArrow setTag:2000];
            [self.view addSubview:pencilArrow];
            
            pencilArrow.translatesAutoresizingMaskIntoConstraints=NO;
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-150-[pencilArrow(60)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(pencilArrow)]];
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-200-[pencilArrow(60)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(pencilArrow)]];
            [pencilArrow setUpPencilBounceForiPad:CGSizeMake(60, 60) targetX:-15 targetY:-9 rotation:3*M_PI_4];

        }
        
        
        CGAffineTransform transform = CGAffineTransformMakeScale(0.9, 0.9);
        [tutorialbackground.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            [tutorialbackground setAlpha:1];
            [tutorialbackground setTransform:transform];
            
        } completion:^(BOOL finished) {
            
            UILabel *tutorialLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, tutorialbackground.frame.size.width-20, tutorialbackground.frame.size.height-10)];
            [tutorialLabel setFont:[UIFont fontWithName:@"Eraser" size:18]];
            [tutorialLabel setTextColor:[UIColor whiteColor]];
            [tutorialLabel setNumberOfLines:0];
            [tutorialLabel setText:@"Click on your students to see how they're doing in class"];
            [tutorialbackground addSubview:tutorialLabel];
            
        }];
        
    }
    else{
        [self hideTutorialArrow:YES hideBlackboard:YES];
    }
    
}

-(void)tutorialDemoNext:(UIButton*)sender{
    //For tutorial next in manage coins
    
    [self hideTutorialArrow:NO hideBlackboard:YES];
    
    UIImageView *tutorialbackground = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"blackboardBorder"]];
    [tutorialbackground setUserInteractionEnabled:YES];
    [tutorialbackground setTag:1000];
    [tutorialbackground setAlpha:0];
    [self.view addSubview:tutorialbackground];
    
    if(IS_IPHONE){
        [tutorialbackground setFrame:CGRectMake(30, 70, 240, 100)];
        
        BouncingPencil *pencilArrow = [[BouncingPencil alloc]initWithFrame:CGRectMake(220, 44, 60, 60)];
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
        UILabel *tutorialLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, tutorialbackground.frame.size.width-10, tutorialbackground.frame.size.height-10)];
        [tutorialLabel setFont:[UIFont fontWithName:@"Eraser" size:18]];
        [tutorialLabel setTextColor:[UIColor whiteColor]];
        [tutorialLabel setNumberOfLines:0];
        [tutorialLabel setText:@"Click on your menu"];
        [tutorialbackground addSubview:tutorialLabel];
    }];

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


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self makeTableFromDatabase];

    [self updateButtonEditing];

    //notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectionMethod) name:@"selectionAction" object:nil];
    
    //manage coins
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addGroupAction) name:@"addAction" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(minusGroupAction) name:@"minusAction" object:nil];
    
    
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    //deallocate notification
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"selectionAction" object:nil];
    
    //manage coins
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"addAction" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"minusAction" object:nil];
    
    if (self.studentTable.frame.origin.y>64) {
        [self cancelButtonAction];
    }
    
    [self.studentMenu removeFromSuperview];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

//student table code
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.studentsArrays count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat result;
    result = 90;
    return result;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"studentCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"studentCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        //Right side
        UIButton *buttonPlus = [UIButton buttonWithType:UIButtonTypeCustom];
        [buttonPlus setBackgroundImage:[UIImage imageNamed:@"PlusImage"] forState:UIControlStateNormal];
        [buttonPlus addTarget:self action:@selector(buttonArithmeticAction:) forControlEvents:UIControlEventTouchUpInside];
        [buttonPlus setTag:100];
        [cell.contentView addSubview:buttonPlus];
        
        UIButton *buttonSub = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [buttonSub setBackgroundImage:[UIImage imageNamed:@"MinusImage"] forState:UIControlStateNormal];
        [buttonSub addTarget:self action:@selector(buttonArithmeticAction:) forControlEvents:UIControlEventTouchUpInside];//
        [buttonSub setTag:200];//
        [cell.contentView addSubview:buttonSub];
        
        UILabel *coinLabel = [[UILabel alloc]init];
        coinLabel.adjustsFontSizeToFitWidth=YES;
        coinLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:28];
        coinLabel.textAlignment = NSTextAlignmentCenter;
        [coinLabel setTag:2];
        [cell.contentView addSubview:coinLabel];
        
        UIColor *lineColors = [UIColor colorWithRed:0.317647 green:0.647059 blue:0.72941 alpha:1];
        
        UIView *coinLine = [[UIView alloc]init];
        [coinLine setBackgroundColor:lineColors];
        [cell.contentView addSubview:coinLine];
        
        UIView *coinLine2 = [[UIView alloc]init];
        [coinLine2 setBackgroundColor:lineColors];
        [cell.contentView addSubview:coinLine2];
        
        UIView *coinLine3 = [[UIView alloc]init];
        [coinLine3 setBackgroundColor:lineColors];
        [cell.contentView addSubview:coinLine3];
        
        //Name of student
        UILabel* titleLabel = [[UILabel alloc]init];
        [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:23]];
        titleLabel.adjustsFontSizeToFitWidth=YES;
        titleLabel.minimumScaleFactor=0.5;
        [titleLabel setTag:1];
        [cell.contentView addSubview:titleLabel];
        
        UIView *taken = [[UIView alloc]init];
        taken.layer.masksToBounds=YES;
        taken.layer.cornerRadius=6;
        [taken setTag:3];
        [cell.contentView addSubview:taken];
        
        UILabel* takenLabel = [[UILabel alloc]init];
        [takenLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
        takenLabel.adjustsFontSizeToFitWidth=YES;
        takenLabel.minimumScaleFactor=0.5;
        [takenLabel setTag:4];
        [cell.contentView addSubview:takenLabel];
        
        if (IS_IPAD) {
            [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:27]];
            
            
            titleLabel.translatesAutoresizingMaskIntoConstraints=NO;
            taken.translatesAutoresizingMaskIntoConstraints=NO;
            takenLabel.translatesAutoresizingMaskIntoConstraints=NO;
            
            buttonPlus.translatesAutoresizingMaskIntoConstraints=NO;
            buttonSub.translatesAutoresizingMaskIntoConstraints=NO;
            coinLabel.translatesAutoresizingMaskIntoConstraints=NO;
            coinLine.translatesAutoresizingMaskIntoConstraints=NO;
            coinLine2.translatesAutoresizingMaskIntoConstraints=NO;
            coinLine3.translatesAutoresizingMaskIntoConstraints=NO;
            
            //Left part of the table
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-65-[titleLabel(300)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)]];
            
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-75-[taken(12)]-4-[takenLabel]" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(taken,takenLabel)]];
            
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-7-[titleLabel(48)]-0-[taken(12)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleLabel,taken)]];
            
            
            //Right part of the table
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[coinLabel(38)]-0-[coinLine(2)]-3-[buttonSub(33)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(coinLabel,coinLine,buttonSub)]];
            
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[coinLine(138)]-75-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(coinLine)]];
            
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[coinLine3(2)]-0-[coinLabel(136)]-75-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(coinLine3,coinLabel)]];
            
            [coinLine3 addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[coinLine3(38)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(coinLine3)]];
            
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[buttonSub(66)]-1-[coinLine2(2)]-1-[buttonPlus(66)]-68-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(buttonSub,coinLine2,buttonPlus)]];
            [coinLine2 addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[coinLine2(33)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(coinLine2)]];
            
        }
        else if(IS_IPHONE){
            buttonPlus.frame = CGRectMake(222, 52, 66, 33);
            buttonSub.frame = CGRectMake(152, 52, 66,33);
            coinLabel.frame = CGRectMake(152, 10, 136, 38);
            coinLine.frame = CGRectMake(152, 49, 136, 2);
            coinLine2.frame = CGRectMake(buttonSub.frame.origin.x+buttonSub.frame.size.width+1, 50, 2, 35);
            coinLine3.frame = CGRectMake(buttonSub.frame.origin.x, 49-coinLabel.frame.size.height, 2, coinLabel.frame.size.height);
            titleLabel.frame = CGRectMake(7, 3, 145,35);
            taken.frame = CGRectMake(13, 39, 12, 12);
            takenLabel.frame = CGRectMake(29, 35,100,20);
            
        }
        
    }
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    DemoStudentObject *studentsObj = [self.studentsArrays objectAtIndex:indexPath.row];
    
    if (![studentsObj.taken isEqualToString:@""] && ![studentsObj.signedIn boolValue]) {
        
        //Student is offline
        [(UIView *)[cell.contentView viewWithTag:3] setBackgroundColor:[UIColor lightGrayColor]];
        [(UILabel *)[cell.contentView viewWithTag:4] setTextColor:[UIColor lightGrayColor]];
        [(UILabel *)[cell.contentView viewWithTag:4] setText:@"Offline"];
        
    }
    else if(![studentsObj.taken isEqualToString:@""] && [studentsObj.signedIn boolValue]){
        
        //Student is online
        [(UIView *)[cell.contentView viewWithTag:3] setBackgroundColor:[UIColor greenColor]];
        [(UILabel *)[cell.contentView viewWithTag:4] setTextColor:[UIColor grayColor]];
        [(UILabel *)[cell.contentView viewWithTag:4] setText:@"Online"];
        
    }
    else{
        
        //student is not signed up
        [(UIView *)[cell.contentView viewWithTag:3] setBackgroundColor:[UIColor clearColor]];
        [(UILabel *)[cell.contentView viewWithTag:4] setTextColor:[UIColor lightGrayColor]];
        [(UILabel *)[cell.contentView viewWithTag:4] setText:@"Not Signed Up"];
        
    }
    
    [(UILabel *)[cell.contentView viewWithTag:1] setText:studentsObj.studentName]; //add text
    
    NSString *totalCoins = [NSString stringWithFormat:@"%@ Coins",studentsObj.coins];
    
    [(UILabel *)[cell.contentView viewWithTag:2] setText:totalCoins];
    
    return cell;
}

-(void)makeTableFromDatabase{
    
    NSError *error;
    NSFetchRequest *studentsRequest = [NSFetchRequest fetchRequestWithEntityName:@"DemoStudentObject"];
    studentsRequest.predicate= [NSPredicate predicateWithFormat:@"(nameOfclass = %@) AND (taken = %@)",[self.className lowercaseString],@"Teacher"];
    NSArray *studentObjArray = [_demoManagedObjectContext executeFetchRequest:studentsRequest error:&error];
    self.studentsArrays = [[NSMutableArray alloc]initWithArray:studentObjArray];
    
    [self.studentTable reloadData];
    [self updateButtonEditing];
    
}



-(void)buttonArithmeticAction: (UIButton*)sender{
    
    //tutorial
    if (![self.checkProgress.addCoinsDone boolValue]) {
        
        //Hide the tutorial
        [self hideTutorialArrow:YES hideBlackboard:YES];
        self.checkProgress.addCoinsDone=[NSNumber numberWithBool:YES];
        [_demoManagedObjectContext save:nil];
        
        [self startTutorial];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Good Job!" message:@"Now you know how to add and subtract coins from your students. On to the next lesson!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        if ((int)[self.checkProgress getTotalProgress] == 1) {
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
    
    UIButton *btn = (UIButton *)sender;
    UITableViewCell *cell = [self parentCellForView:btn];
    if (cell != nil) {
        NSIndexPath *indexPath = [_studentTable indexPathForCell:cell];
        DemoStudentObject *studentObj = [self.studentsArrays objectAtIndex:indexPath.row];
        if (sender.tag == 100) {
            [studentObj addCoinsToStudentObject:@1 inManagedObjectContext:_demoManagedObjectContext];
            
        }
        else if (sender.tag == 200){
            [studentObj subtractCoinsToStudentObject:@1 inManagedObjectContext:_demoManagedObjectContext];
        }
        
        NSError *error;
        [_demoManagedObjectContext save:&error];
        
        //update cell
        [_studentTable beginUpdates];
        [_studentTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [_studentTable endUpdates];
    }
}

-(UITableViewCell *)parentCellForView:(id)theView
{
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

//sidemenu code

-(void)menuViewAction{
    
    //Tutorial
    if ([self.checkProgress.addCoinsDone boolValue] && ![self.checkProgress.manageCoinsDone boolValue]) {
        //Hide the tutorial
        [self hideTutorialArrow:YES hideBlackboard:YES];
    }
    
    if (IS_IPAD) {
        
        self.studentMenu = [[MenuTable alloc]initWithFrame:CGRectZero];
        self.studentMenu.translatesAutoresizingMaskIntoConstraints=NO;
        [self.studentMenu displayStudentMenu];
        [self.navigationController.view addSubview:self.studentMenu];
        
        
        [self.navigationController.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_studentMenu]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_studentMenu)]];
        
        self.hiddenTable = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[_studentTable]-[_studentMenu(==_studentTable)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_studentTable,_studentMenu)];
        
        self.showTable = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_studentMenu]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_studentMenu)];
        
        [self.navigationController.view addConstraints:self.hiddenTable];
        
        [self.navigationController.view layoutIfNeeded];
        
        [UIView animateWithDuration:0.4 animations:^{
            
            [self.navigationController.view removeConstraints:self.hiddenTable];
            [self.navigationController.view addConstraints:self.showTable];
            
            [self.navigationController.view layoutIfNeeded];
        }];
        
    }
    else if(IS_IPHONE){

        if (!self.studentMenu || self.studentMenu.frame.origin.x == 320) {
            //show
            self.studentMenu = [[MenuTable alloc]initWithFrame:CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height)];
            [self.studentMenu displayStudentMenu];
        
            [self.view addSubview:self.studentMenu];
            
            [UIView animateWithDuration:0.4 animations:^{
                [self.studentMenu setFrame:self.view.frame];
            }];
        }

    }
    UIImageView *tutorialbackground = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"blackboardBorder"]];
    [tutorialbackground setAlpha:0];
    [self.studentMenu addSubview:tutorialbackground];

    if (IS_IPHONE) {
        [tutorialbackground setFrame:CGRectMake(0, 340, 320, 180)];
    }
    else if (IS_IPAD){
        tutorialbackground.translatesAutoresizingMaskIntoConstraints=NO;
        [self.studentMenu addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[tutorialbackground(280)]-140-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tutorialbackground)]];
        [self.studentMenu addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-370-[tutorialbackground(170)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tutorialbackground)]];
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
        [tutorialLabel setText:@"This is your menu.\n\n All the features you need will be in here. Try them out!"];
        [tutorialbackground addSubview:tutorialLabel];
        
    }];
    //tutorial
    if([self.checkProgress.addCoinsDone boolValue] && ![self.checkProgress.manageCoinsDone boolValue]){
    
        
        if(IS_IPHONE){
            BouncingPencil *pencilArrow = [[BouncingPencil alloc]initWithFrame:CGRectMake(8, 150, 60, 60)];
            [pencilArrow setTag:2000];
            [pencilArrow setUpPencilBounceFrame:pencilArrow.frame targetX:15 targetY:-9 rotation:5*M_PI_4];
            [self.studentMenu addSubview:pencilArrow];
        }
        else if (IS_IPAD){
            //Set bouncing pencil
            BouncingPencil *pencilArrow = [[BouncingPencil alloc]init];
            [pencilArrow setTag:2000];
            [self.studentMenu addSubview:pencilArrow];
            
            pencilArrow.translatesAutoresizingMaskIntoConstraints=NO;
            [self.studentMenu addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-150-[pencilArrow(60)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(pencilArrow)]];
            [self.studentMenu addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[pencilArrow(60)]-400-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(pencilArrow)]];
            [pencilArrow setUpPencilBounceForiPad:CGSizeMake(60, 60) targetX:15 targetY:-9 rotation:5*M_PI_4];
        }
        

    }
    
}


//menu selection

-(void)selectionMethod{
    
    //tutorial
    if (![self.checkProgress.manageCoinsDone boolValue]) {
        BouncingPencil *bouncePen = (BouncingPencil*)[self.studentMenu viewWithTag:2000];
        bouncePen.pencilImage=nil;
        [bouncePen setTag:0];
        [bouncePen removeFromSuperview];
    }
    
    if ([self.studentMenu.menuOption  isEqualToString: @"Add More Students"]) {
        [self.studentMenu menuAnimation];
        
        [self performSegueWithIdentifier:@"demoAddStudentSegue" sender:self];
    }
    else if ([self.studentMenu.menuOption  isEqualToString:@"Manage Coins"]){
        [self.studentMenu menuAnimation];
        [self.studentTable setEditing:YES animated:YES];
        [self updateButtonEditing];
        [self manageCoinsInGroupsActions];
        
    }
    else if ([self.studentMenu.menuOption  isEqualToString:@"Delete Students"]){
        [self.studentMenu menuAnimation];
        [self.studentTable setEditing:YES animated:YES];
        [self updateButtonEditing];
    }
    else if ([self.studentMenu.menuOption  isEqualToString:@"Group Students"]||[self.studentMenu.menuOption isEqualToString:@"Teacher's Log"]||[self.studentMenu.menuOption isEqualToString:@"Sort Students By:"]){
        [self.studentMenu menuAnimation];

        [self performSegueWithIdentifier:@"demoStudentViewSegue" sender:self];
    }
}


//manage coin code
-(void)manageCoinsInGroupsActions{
    
    //add toolbar for selection
    self.manageCoinToolbarSelection = [[UIToolbar alloc]init];
    
    UIBarButtonItem *flexibleButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *selectAllButton = [[UIBarButtonItem alloc]initWithTitle:@"Select All" style:UIBarButtonItemStylePlain target:self action:@selector(selectingOrDeselecting:)];
    [selectAllButton setTag:100];
    
    UIBarButtonItem *deselectButton = [[UIBarButtonItem alloc]initWithTitle:@"Deselect All" style:UIBarButtonItemStylePlain target:self action:@selector(selectingOrDeselecting:)];
    [deselectButton setTag:200];
    
    NSArray *barButtonArray = [NSArray arrayWithObjects:flexibleButton,selectAllButton,flexibleButton,deselectButton,flexibleButton, nil];
    [self.manageCoinToolbarSelection setItems:barButtonArray animated:NO];
    [self.view insertSubview:self.manageCoinToolbarSelection belowSubview:self.studentTable];
    
    if (IS_IPAD) {
        self.askCoinView = [[manageCoinView alloc]init];
        self.askCoinView.teacherName=self.nameOfTeacher;
        self.askCoinView.className = self.className;
        [self.view insertSubview:self.askCoinView belowSubview:self.studentTable];
        
        self.askCoinView.translatesAutoresizingMaskIntoConstraints=NO;
        self.manageCoinToolbarSelection.translatesAutoresizingMaskIntoConstraints=NO;
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-64-[_askCoinView(80)]-0-[_manageCoinToolbarSelection(44)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_askCoinView,_manageCoinToolbarSelection)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_askCoinView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_askCoinView)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_manageCoinToolbarSelection]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_manageCoinToolbarSelection)]];
        
        self.pinStudentTableDown = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_manageCoinToolbarSelection]-0-[_studentTable]-56-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_manageCoinToolbarSelection,_studentMenu,_studentTable)];
        
        [self.view layoutIfNeeded];
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self.view removeConstraints:self.pinStudentTableToTop];
            [self.view addConstraints:self.pinStudentTableDown];
            [self.view layoutIfNeeded];
            
        } completion:^(BOOL finished) {
        }];
        
    }
    else if (IS_IPHONE){
        
        self.askCoinView = [[manageCoinView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, 64, self.view.frame.size.width,80)];
        self.askCoinView.teacherName=self.nameOfTeacher;
        self.askCoinView.className = self.className;
        [self.view insertSubview:self.askCoinView belowSubview:self.studentTable];
        [self.manageCoinToolbarSelection setFrame:CGRectMake(self.view.frame.origin.x, self.askCoinView.frame.origin.y+self.askCoinView.frame.size.height,self.view.frame.size.width,44)];
        
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.studentTable.frame=CGRectMake(self.studentTable.frame.origin.x,self.studentTable.frame.origin.y+80+44, self.studentTable.frame.size.width,self.studentTable.frame.size.height-80-44);
        } completion:^(BOOL finished) {
        }];
    }
}

//managecointoolbar
-(void)selectingOrDeselecting:(UIBarButtonItem*)sender{
    
    if(sender.tag == 100){
        for (int i=0; i<[self.studentsArrays count];i++) {
            [self.studentTable selectRowAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
        
        [self.askCoinView.directLabel setText:@"How many coins would you like to add or subtract?"];
        [self.askCoinView.coinsField setAlpha:1];
        [self.askCoinView.addButtonGroupButton setAlpha:1];
        [self.askCoinView.minusButtonGroupButton setAlpha:1];
        [self.askCoinView.coinsField resignFirstResponder];
        
    }
    else if(sender.tag == 200){
        for (int i=0; i<[self.studentsArrays count];i++) {
            [self.studentTable deselectRowAtIndexPath:[NSIndexPath indexPathForItem:i inSection:NO] animated:NO];
        }
        
        [self.askCoinView.directLabel setText:@"First, pick your students below."];
        [self.askCoinView.addButtonGroupButton setAlpha:0];
        [self.askCoinView.minusButtonGroupButton setAlpha:0];
        [self.askCoinView.coinsField setAlpha:0];
        [self.askCoinView.coinsField resignFirstResponder];
        
    }
    else{
        NSLog(@"Error in manageCoinSelection");
    }
}


-(void)addGroupAction{
    NSArray *selectedRows = [self.studentTable indexPathsForSelectedRows];
    if (selectedRows == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Did you forget to select your students?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }
    else{
        
        
        BOOL addSpecificRows = selectedRows.count > 0;
        
        if (addSpecificRows)
        {
            // Build an NSIndexSet
            NSMutableIndexSet *indicesOfItemsToAdd = [NSMutableIndexSet new];
            for (NSIndexPath *selectionIndex in selectedRows)
            {
                [indicesOfItemsToAdd addIndex:selectionIndex.row];
                
            }
            
            //Update the selected objects
            NSArray *studentObjArray = [self.studentsArrays objectsAtIndexes:indicesOfItemsToAdd];
            
            if(![self.checkProgress.manageCoinsDone boolValue]){
                self.checkProgress.manageCoinsDone=[NSNumber numberWithBool:YES];
                [_demoManagedObjectContext save:nil];
                
                [self hideTutorialArrow:YES hideBlackboard:YES];
                [self startTutorial];
                
                NSString *alertString = @"You successfully added coins to your student. You're doing well in this demo so far!";
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Good Job" message:alertString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                
                [self.demoProgressBar setProgress:[self.checkProgress getTotalProgress] animated:YES];
                
                if ((int)[self.checkProgress getTotalProgress] == 1) {
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
            else{
                NSString *alertString = [NSString stringWithFormat:@"Done! %@ coins are added to your selected students",self.askCoinView.coinsField.text];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Done" message:alertString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }

            
            for (DemoStudentObject* studentObj in studentObjArray) {
                
                [studentObj addCoinsToStudentObject:@([self.askCoinView.coinsField.text intValue]) inManagedObjectContext:_demoManagedObjectContext];
            }
            
            [_demoManagedObjectContext save:nil];

        }

        if (IS_IPAD) {
            [self.view layoutIfNeeded];
            [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.view removeConstraints:_pinStudentTableDown];
                [self.view addConstraints:_pinStudentTableToTop];
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {
            }];
        }
        else if (IS_IPHONE){
            [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.studentTable.frame=CGRectMake(self.studentTable.frame.origin.x,self.studentTable.frame.origin.y-80-44, self.studentTable.frame.size.width,self.studentTable.frame.size.height+80+44);
            } completion:^(BOOL finished) {
            }];
            
        }
        
        
        [self.manageCoinToolbarSelection removeFromSuperview];
        [self.askCoinView.coinsField resignFirstResponder];
        [self.studentTable setEditing:NO animated:YES];
        [self updateButtonEditing];
        
        //update the database
        [self.studentTable reloadData];
        
    }
}

-(void)minusGroupAction{
    NSArray *selectedRows = [self.studentTable indexPathsForSelectedRows];
    if (selectedRows == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Did you forget to select your students?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }
    else{
        
        
        
        BOOL addSpecificRows = selectedRows.count > 0;
        
        if (addSpecificRows)
        {
            // Build an NSIndexSet
            NSMutableIndexSet *indicesOfItemsToAdd = [NSMutableIndexSet new];
            for (NSIndexPath *selectionIndex in selectedRows)
            {
                [indicesOfItemsToAdd addIndex:selectionIndex.row];
                
            }
            
            //Update the selected objects
            NSArray *studentObjArray = [self.studentsArrays objectsAtIndexes:indicesOfItemsToAdd];
            
            NSString *alertString = [NSString stringWithFormat:@"Done! %@ coins are subtracted from your selected students",self.askCoinView.coinsField.text];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Done" message:alertString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
            for (DemoStudentObject* studentObj in studentObjArray) {
                
                [studentObj subtractCoinsToStudentObject:@([self.askCoinView.coinsField.text intValue]) inManagedObjectContext:_demoManagedObjectContext];
            }
            
            [_demoManagedObjectContext save:nil];
            
        }

        if (IS_IPAD) {
            [self.view layoutIfNeeded];
            [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.view removeConstraints:_pinStudentTableDown];
                [self.view addConstraints:_pinStudentTableToTop];
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {
            }];
            
            
        }
        else if (IS_IPHONE){
            [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.studentTable.frame=CGRectMake(self.studentTable.frame.origin.x,self.studentTable.frame.origin.y-80-44, self.studentTable.frame.size.width,self.studentTable.frame.size.height+80+44);
            } completion:^(BOOL finished) {
            }];
            
        }
        [self.manageCoinToolbarSelection removeFromSuperview];
        [self.askCoinView.coinsField resignFirstResponder];
        [self.studentTable setEditing:NO animated:YES];
        [self updateButtonEditing];
        
        //update table
        [self.studentTable reloadData];
    }
}

-(void)deleteButtonAction{
    NSString *actionTitle;
    if ([[self.studentTable indexPathsForSelectedRows] count] == 1) {
        actionTitle = @"Are you sure you want to remove this student";
    }
    else{
        actionTitle = @"Are you sure you want to remove these students?";
    }
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:actionTitle delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete" otherButtonTitles:nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	// The user tapped one of the OK/Cancel buttons.
	if (buttonIndex == 0)
	{
		// Delete what the user selected.
        NSArray *selectedRows = [self.studentTable indexPathsForSelectedRows];
        NSString *alertMessage;
        if (selectedRows.count>1) {
            alertMessage = @"Your student is delete from your table";
        }
        else{
            alertMessage = @"Your students are deleted from your table";
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Done" message:alertMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        BOOL deleteSpecificRows = selectedRows.count > 0;
        if (deleteSpecificRows)
        {
            // Build an NSIndexSet of all the objects to delete, so they can all be removed at once.
            NSMutableIndexSet *indicesOfItemsToDelete = [NSMutableIndexSet new];
            for (NSIndexPath *selectionIndex in selectedRows)
            {
                [indicesOfItemsToDelete addIndex:selectionIndex.row];
            }
            
            // Delete the objects from our core data
            NSArray *studentObjSelectedArray = [self.studentsArrays objectsAtIndexes:indicesOfItemsToDelete];
            
            for (DemoStudentObject* studentObj in studentObjSelectedArray) {
                //delete log
                
                [_demoManagedObjectContext deleteObject:studentObj];
                
            }
            
            [_demoManagedObjectContext save:nil];
            
            [self.studentsArrays removeObjectsAtIndexes:indicesOfItemsToDelete];
            [self.studentTable deleteRowsAtIndexPaths:selectedRows withRowAnimation:YES];
            
        }
        else
        {
            // Delete everything, delete the objects from our data model.
            
            for (DemoStudentObject* studentObj in self.studentsArrays) {
                
                [_demoManagedObjectContext deleteObject:studentObj];
            }
            [_demoManagedObjectContext save:nil];
            
        }
        
        // Exit editing mode after the deletion.
        
        [self.studentTable setEditing:NO animated:YES];
        [self updateButtonEditing];
        
    }
}

-(void)updateButtonEditing{
    
    if (self.studentTable.editing) {
        
        NSArray *selectedRows = [self.studentTable indexPathsForSelectedRows];
        
        if ([self.studentMenu.menuOption isEqualToString:@"Delete Students"]) {
            
            self.deleteButton = [[UIBarButtonItem alloc]initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:@selector(deleteButtonAction)];
            BOOL allItemsAreSelected = selectedRows.count == self.studentsArrays.count;
            BOOL noItemsAreSelected = selectedRows.count == 0;
            
            if (allItemsAreSelected || noItemsAreSelected)
            {
                self.deleteButton.title = NSLocalizedString(@"Delete All", @"");
            }
            else
            {
                NSString *titleFormatString =
                NSLocalizedString(@"Delete (%d)", @"Title for delete button with placeholder for number");
                self.deleteButton.title = [NSString stringWithFormat:titleFormatString, selectedRows.count];
            }
            self.tabBarController.navigationItem.leftBarButtonItem = self.deleteButton;
        }
        else{ //managecoin
            self.tabBarController.navigationItem.leftBarButtonItem = nil;
        }
        
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonAction)];
        self.tabBarController.navigationItem.rightBarButtonItem = cancelButton;
        
    }
    else{
        
        UIImage *image = [UIImage imageNamed:@"menuIcon"];
        CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
        UIButton* button = [[UIButton alloc] initWithFrame:frame];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        
        //set the button to handle clicks
        [button addTarget:self action:@selector(menuViewAction) forControlEvents:UIControlEventTouchUpInside];

        
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithCustomView:button];
//        UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithTitle:@"Class" style:UIBarButtonItemStylePlain target:self action:@selector(classListAction)];
        [self.tabBarController.navigationItem setLeftBarButtonItem:nil];
        [self.tabBarController.navigationItem setRightBarButtonItem:rightButton];
//        self.navigationItem.leftBarButtonItem=leftButton;
        
    }
}

//-(void)classListAction{
//    [self performSegueWithIdentifier:@"backToClassSegue" sender:self];
//}


-(void)cancelButtonAction{
    [self.studentTable setEditing:NO animated:YES];
    
    [self updateButtonEditing];
    
    if ([self.studentMenu.menuOption isEqualToString:@"Manage Coins"]) {
        
        [self.askCoinView.coinsField resignFirstResponder];
        if (IS_IPAD) {
            [self.view layoutIfNeeded];
            [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.view removeConstraints:_pinStudentTableDown];
                [self.view addConstraints:_pinStudentTableToTop];
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {
            }];
            
            
        }
        else if (IS_IPHONE){
            [self.askCoinView.coinsField resignFirstResponder];
            
            [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                
                self.studentTable.frame=CGRectMake(self.studentTable.frame.origin.x,self.studentTable.frame.origin.y-80-44, self.studentTable.frame.size.width,self.studentTable.frame.size.height+80+44);
            } completion:^(BOOL finished) {
                [self.askCoinView removeFromSuperview];
                self.askCoinView =nil;
            }];
            
        }
        [self.manageCoinToolbarSelection removeFromSuperview];
    }
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Update the delete button's title based on how many items are selected.
    NSArray *selectedRows = [self.studentTable indexPathsForSelectedRows];
    if ([selectedRows count] == 0) {
        [self.askCoinView.directLabel setText:@"First, pick your students below."];
        [self.askCoinView.addButtonGroupButton setAlpha:0];
        [self.askCoinView.minusButtonGroupButton setAlpha:0];
        [self.askCoinView.coinsField setAlpha:0];
    }
    [self.askCoinView.coinsField resignFirstResponder];
    [self updateButtonEditing];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.studentTable.editing) {
        
        if ([self.checkProgress.addCoinsDone boolValue] && [self.checkProgress.manageCoinsDone boolValue] && [self.checkProgress.buyStoreDone boolValue] && ![self.checkProgress.checkStats boolValue]){
            
            self.checkProgress.checkStats = [NSNumber numberWithBool:YES];
            [_demoManagedObjectContext save:nil];
            [self startTutorial];
            [self.demoProgressBar setProgress:[self.checkProgress getTotalProgress] animated:YES];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You're doing great!" message:@"The demo is going well so far!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
            
            if ((int)[self.checkProgress getTotalProgress] == 1) {
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
        
        DemoStudentObject *selectedStudentObj = nil;
        selectedStudentObj = [self.studentsArrays objectAtIndex:indexPath.row];
        self.selectedStudentObjForLog = selectedStudentObj;
        [self.studentTable deselectRowAtIndexPath:indexPath animated:NO];
        [self performSegueWithIdentifier:@"demoPieSegue" sender:self];
    }
    else{
        // Update the delete button's title based on how many items are selected.
        if (self.askCoinView !=nil) {
            [self.askCoinView.directLabel setText:@"How many coins would you like to add or subtract?"];
            [self.askCoinView.coinsField setAlpha:1];
            [self.askCoinView.addButtonGroupButton setAlpha:1];
            [self.askCoinView.minusButtonGroupButton setAlpha:1];
            [self.askCoinView.coinsField resignFirstResponder];

        }
        [self updateButtonEditing];
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"demoAddStudentSegue"]){
        DemoAddStudentsViewController *addVC = (DemoAddStudentsViewController*)segue.destinationViewController;
        addVC.className=self.className;
        addVC.demoManagedObjectContext = _demoManagedObjectContext;
        addVC.managedObjectContext = self.managedObjectContext;
        addVC.studentsArray = self.studentsArrays;
    }
    else if([segue.identifier isEqualToString:@"demoStudentViewSegue"]){
        
        DemoEndViewController *endVC = (DemoEndViewController*)segue.destinationViewController;
        endVC.previousSegue = segue.identifier;
        endVC.studentsViewOptions = self.studentMenu.menuOption;
        endVC.demoManagedObjectContext=self.demoManagedObjectContext;
        endVC.managedObjectContext=self.managedObjectContext;
    }
    else if ([segue.identifier isEqualToString:@"demoPieSegue"]){
        DemoPieViewController *pieVC = (DemoPieViewController*)segue.destinationViewController;
        pieVC.userType = self.userType;
        pieVC.selectedStudent = self.selectedStudentObjForLog;
        pieVC.demoManagedObjectContext = self.demoManagedObjectContext;
        pieVC.managedObjectContext = self.managedObjectContext;
    }
}

@end

