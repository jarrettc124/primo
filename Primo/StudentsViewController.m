//
//  StudentsViewController.m
//  tableViewExample
//
//  Created by Jarrett Chen on 2/19/14.
//  Copyright (c) 2014 Jarrett Chen. All rights reserved.
//TEACHER"S View


#import "StudentsViewController.h"

@interface StudentsViewController ()

//new student row arrays
@property(nonatomic,strong) NSMutableArray *studentsArrays;

@property(nonatomic) UIRefreshControl *refreshControl;
@property(readonly,nonatomic) UITapGestureRecognizer *tapCloseRecognizer;
@property(readonly,nonatomic)UISwipeGestureRecognizer *swipeCloseRecognizer;
@property (nonatomic,strong)UIBarButtonItem *deleteButton;
@property (nonatomic,strong)UIBarButtonItem *addCoinsButton;
@property(nonatomic,strong) MenuTable *studentMenu;
@property(nonatomic,strong) manageCoinView *askCoinView;
@property(nonatomic,strong) StudentObject *selectedStudentObjForLog;
@property(nonatomic,strong) NSString *dateString;
@property(nonatomic) NSInteger month;
@property(nonatomic,strong) UIToolbar *manageCoinToolbarSelection;

//connection
@property(nonatomic,strong) UILabel *connection;
@property(nonatomic) NSInteger totalNumberOfStudents;
@property(nonatomic,strong) NSString *sortByString;
@property(nonatomic,strong) NSArray *pickerArray;
@property(nonatomic,strong) UIPickerView *pickerSort;
@property(nonatomic,strong) NSMutableDictionary *sortDictionary;
@property(nonatomic,strong) NSString *nameOfTeacher;
@property(nonatomic,strong) AnnouncementObject *annObject;

@property(nonatomic,strong) NSArray *hiddenTable;
@property(nonatomic,strong) NSArray *showTable;

@property(nonatomic,strong) NSArray *pinStudentTableToTop;
@property(nonatomic,strong) NSArray *pinStudentTableDown;


@end


@implementation StudentsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"MM/dd/yyyy"];
    self.dateString =[dateFormat stringFromDate:today];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSMonthCalendarUnit;
    NSDateComponents* dateComponents = [calendar components:unitFlags fromDate:today];
    self.month = (int)[dateComponents month];
    
    //set tab bar badge
    self.annObject = [[AnnouncementObject alloc]init];
    NSString *objId = [[NSUserDefaults standardUserDefaults] objectForKey:@"ObjectId"];
    [self.annObject getBadgeNumber:objId className:[self.className lowercaseString] completion:^(BOOL finished, NSNumber *badgeNum) {
        if (finished) {
            if ([badgeNum intValue]>0) {
                [[[[[self tabBarController] tabBar] items] objectAtIndex:2] setBadgeValue:[NSString stringWithFormat:@"%d",[badgeNum intValue]]];
            }
        }
    }];

    self.studentSignedUpArray =[[NSMutableArray alloc]initWithCapacity:0];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    
   	// Do any additional setup after loading the view, typically from a nib
    
    
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
    
    //ToolBar
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    UIImageView *toolbarBackground = [[UIImageView alloc]init];
    [toolbarBackground setImage:[UIImage imageNamed:@"blackboardBar"]];
    toolbarBackground.userInteractionEnabled=YES;
    [self.view addSubview:toolbarBackground];
    self.tabBarController.navigationController.navigationBar.topItem.title = @"";

    //Create the Table
    _studentTable = [[UITableView alloc]init];
    _studentTable.delegate =self;
    _studentTable.dataSource =self;
    self.studentTable.allowsMultipleSelectionDuringEditing = YES;
    self.studentTable.allowsSelection = YES;
    [self.view addSubview:_studentTable];
    [self.studentTable addSubview:self.refreshControl];
    
//    if (IS_IPAD) {
        toolbarBackground.translatesAutoresizingMaskIntoConstraints=NO;
        self.studentTable.translatesAutoresizingMaskIntoConstraints=NO;
        
        //Toolbar
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[toolbarBackground(64)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(toolbarBackground)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[toolbarBackground]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(toolbarBackground)]];
        
        //Table classes
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_studentTable]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_studentTable)]];
        
        self.pinStudentTableToTop = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-64-[_studentTable]-56-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_studentTable)];
        [self.view addConstraints:self.pinStudentTableToTop];
        

//    }
//    else if (IS_IPHONE){
//        [toolbarBackground setFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
//        [self.studentTable setFrame:CGRectMake(0.0,64, 320.0, self.view.frame.size.height - self.tabBarController.tabBar.frame.size.height-67)];
//    }
    _classObj = [ClassObject findClassObjectInCoreWithTeacherId:objId className:self.className inManagedObjectContext:_managedObjectContext];
    [self updateTableFromDatabaseIntoCore];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self updateButtonEditing];

    //notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectionMethod) name:@"selectionAction" object:nil];
    
    //manage coins
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addGroupAction) name:@"addAction" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(minusGroupAction) name:@"minusAction" object:nil];
    
    //Did become active
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(didBecomeActiveMethod) name: UIApplicationDidBecomeActiveNotification object: nil];
    
    [self makeTableFromDatabase];

}

-(void)didBecomeActiveMethod{
    
    [self updateTableFromDatabaseIntoCore];
        NSString *objId = [[NSUserDefaults standardUserDefaults] objectForKey:@"ObjectId"];
    [self.annObject getBadgeNumber:objId className:[self.className lowercaseString] completion:^(BOOL finished, NSNumber *badgeNum) {
        if (finished) {
            if ([badgeNum intValue]>0) {
                [[[[[self tabBarController] tabBar] items] objectAtIndex:2] setBadgeValue:[NSString stringWithFormat:@"%d",[badgeNum intValue]]];
            }
        }
    }];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    //deallocate notification
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"selectionAction" object:nil];
    
    //manage coins
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"addAction" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"minusAction" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    
    if (self.studentTable.frame.origin.y>64) {
        [self cancelButtonAction];
    }
    
    [self.studentMenu removeFromSuperview];

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (self.connection !=nil) {
        [self didBecomeActiveMethod];
    }
    
    [self.studentTable reloadData];
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
        
        UILabel* studentNumberLabel = [[UILabel alloc]init];
        [studentNumberLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
        studentNumberLabel.adjustsFontSizeToFitWidth=YES;
        studentNumberLabel.minimumScaleFactor=0.5;
        [studentNumberLabel setTag:5];
        [cell.contentView addSubview:studentNumberLabel];
        
        
        
        [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:27]];
        
        titleLabel.translatesAutoresizingMaskIntoConstraints=NO;
        taken.translatesAutoresizingMaskIntoConstraints=NO;
        takenLabel.translatesAutoresizingMaskIntoConstraints=NO;
        studentNumberLabel.translatesAutoresizingMaskIntoConstraints=NO;
        
        buttonPlus.translatesAutoresizingMaskIntoConstraints=NO;
        buttonSub.translatesAutoresizingMaskIntoConstraints=NO;
        coinLabel.translatesAutoresizingMaskIntoConstraints=NO;
        coinLine.translatesAutoresizingMaskIntoConstraints=NO;
        coinLine2.translatesAutoresizingMaskIntoConstraints=NO;
        coinLine3.translatesAutoresizingMaskIntoConstraints=NO;
        
        if (IS_IPAD) {

            
            //Left part of the table
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-65-[titleLabel(300)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)]];
            
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-75-[taken(12)]-4-[takenLabel]" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(taken,takenLabel)]];
            
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-75-[studentNumberLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(studentNumberLabel)]];
            
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-7-[titleLabel(48)]-0-[studentNumberLabel(12)]-[taken(12)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleLabel,studentNumberLabel,taken)]];
            
            //Right part of the table
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[coinLabel(38)]-0-[coinLine(2)]-3-[buttonSub(33)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(coinLabel,coinLine,buttonSub)]];
            
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[coinLine(138)]-75-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(coinLine)]];
            
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[coinLine3(2)]-0-[coinLabel(136)]-75-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(coinLine3,coinLabel)]];
            
            [coinLine3 addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[coinLine3(38)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(coinLine3)]];
        
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[buttonSub(66)]-1-[coinLine2(2)]-1-[buttonPlus(66)]-68-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(buttonSub,coinLine2,buttonPlus)]];
            [coinLine2 addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[coinLine2(33)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(coinLine2)]];
            
        }
        else if(IS_IPHONE){
            
            
            //Left part of the table
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-7-[titleLabel(143)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)]];
            
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-13-[taken(12)]-4-[takenLabel]" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(taken,takenLabel)]];
            
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-7-[studentNumberLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(studentNumberLabel)]];
            
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-3-[titleLabel(35)]-0-[studentNumberLabel(20)]-[taken(12)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleLabel,studentNumberLabel,taken)]];
            
            //Right part of the table
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[coinLabel(38)]-0-[coinLine(2)]-3-[buttonSub(33)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(coinLabel,coinLine,buttonSub)]];
            
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[coinLine(136)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(coinLine)]];
            
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[coinLine3(2)]-0-[coinLabel(136)]-0-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(coinLine3,coinLabel)]];
            
            [coinLine3 addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[coinLine3(38)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(coinLine3)]];
            
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[buttonSub(66)]-1-[coinLine2(2)]-1-[buttonPlus(66)]-0-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(buttonSub,coinLine2,buttonPlus)]];
            [coinLine2 addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[coinLine2(35)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(coinLine2)]];
            
//            buttonPlus.frame = CGRectMake(222, 52, 66, 33);
//            buttonSub.frame = CGRectMake(152, 52, 66,33);
//            coinLabel.frame = CGRectMake(152, 10, 136, 38);
//            coinLine.frame = CGRectMake(152, 49, 136, 2);
//            coinLine2.frame = CGRectMake(buttonSub.frame.origin.x+buttonSub.frame.size.width+1, 50, 2, 35);
//            coinLine3.frame = CGRectMake(buttonSub.frame.origin.x, 49-coinLabel.frame.size.height, 2, coinLabel.frame.size.height);
//            
//            titleLabel.frame = CGRectMake(7, 3, 145,35);
//            studentNumberLabel.frame =CGRectMake(7,titleLabel.frame.origin.y+35, 100, 20);
//            taken.frame = CGRectMake(13, studentNumberLabel.frame.origin.y+20+3, 12, 12);
//            takenLabel.frame = CGRectMake(29,studentNumberLabel.frame.origin.y+20,100,18);
        }

    }
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    StudentObject *studentsObj = [self.studentsArrays objectAtIndex:indexPath.row];
    
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
    
    [(UILabel *)[cell.contentView viewWithTag:5] setText:[NSString stringWithFormat:@"Student Number: %d",[studentsObj.studentNumber intValue]]];
    
    return cell;
}

-(void)makeTableFromDatabase{
        NSString *objId = [[NSUserDefaults standardUserDefaults] objectForKey:@"ObjectId"];
    NSError *error;
    NSFetchRequest *studentsRequest = [NSFetchRequest fetchRequestWithEntityName:@"StudentObject"];
    studentsRequest.predicate= [NSPredicate predicateWithFormat:@"(teacher = %@) AND (nameOfclass = %@)",objId,[self.className lowercaseString]];
    NSArray *studentObjArray = [_managedObjectContext executeFetchRequest:studentsRequest error:&error];
    
    self.studentsArrays = [self sortArrayFinal:studentObjArray];
    
    [self.studentTable reloadData];
    [self updateButtonEditing];

}


//AddView delegate. Refresh after finish adding students
-(void)refreshAfterDoneAdding:(AddViewController *)viewController{
    
    [self updateTableFromDatabaseIntoCore];
    
}

-(void)updateDatabaseFromCore{
        NSString *objId = [[NSUserDefaults standardUserDefaults] objectForKey:@"ObjectId"];
    NSError *error;
    NSFetchRequest *studentsRequest = [NSFetchRequest fetchRequestWithEntityName:@"StudentObject"];
    studentsRequest.predicate= [NSPredicate predicateWithFormat:@"(teacher = %@) AND (nameOfclass = %@)",objId,[self.className lowercaseString]];
    NSArray *studentObjArray = [_managedObjectContext executeFetchRequest:studentsRequest error:&error];
    
    NSMutableArray *jsonDictionaryArray = [[NSMutableArray alloc]initWithCapacity:0];
    for (StudentObject*studentObj in studentObjArray) {
        NSDictionary *jsonDict = @{@"objectId":studentObj.objectId,@"coins":studentObj.coins};
        [jsonDictionaryArray addObject:jsonDict];
    }
    
    UpdateWebService *updateRows = [[UpdateWebService alloc]initWithTable:@"StudentObject"];
    [updateRows updateMultipleRowsWithDictionaryArray:jsonDictionaryArray columnToUpdate:@"coins" where:@"objectId"];
    
}

-(void)updateTableFromDatabaseIntoCore{
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
        NSString *objId = [[NSUserDefaults standardUserDefaults] objectForKey:@"ObjectId"];
    QueryWebService *query = [[QueryWebService alloc]initWithTable:@"StudentObject"];
    [query selectColumnWhere:@"teacher" equalTo:objId];
    [query selectColumnWhere:@"className" equalTo:[self.className lowercaseString]];
    [query findAllObjectsInRowWithCompletion:^(NSError *error, NSArray *rows) {
        
        if(error) {
            
            if (self.connection ==nil) {
                [loadingView stopAnimating];
                [loadingView removeFromSuperview];
                [loadingLabel removeFromSuperview];
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
                self.connection=nil;
                
            }
            self.tabBarController.navigationItem.title = [NSString stringWithFormat:@"%@ (%d)",self.className,[rows count]];

            
            NSMutableArray *unsortedArray = [[NSMutableArray alloc]initWithCapacity:0];
            
            for (NSDictionary *studentObj in rows){
                
                StudentObject *studentObjInCore = [StudentObject createStudentObjectInCoreWithDictionary:studentObj inManagedObjectContext:_managedObjectContext];
                studentObjInCore.nameOfclass = studentObj[@"className"];
                studentObjInCore.studentName = studentObj[@"studentName"];
                NSNumber *stuNum = studentObj[@"studentNumber"];
                int stuNumInt = [stuNum intValue];
                studentObjInCore.studentNumber=[NSNumber numberWithInt:stuNumInt];
                NSNumber *stuCoin = studentObj[@"coins"];
                int stuCoinint = [stuCoin intValue];
                studentObjInCore.coins = [NSNumber numberWithInt:stuCoinint];
                studentObjInCore.taken = studentObj[@"taken"];
                studentObjInCore.teacherEmail = studentObj[@"teacherEmail"];
                NSNumber *signedInNum =studentObj[@"signedIn"];
                int signedInInt = [signedInNum intValue];
                studentObjInCore.signedIn = [NSNumber numberWithInt:signedInInt];

                [unsortedArray addObject:studentObjInCore];
                
            }
            [self.studentsArrays removeAllObjects];
            
            [self.studentsArrays addObjectsFromArray:[self sortArrayFinal:unsortedArray]];
            
            [self.studentTable reloadData];
            [_managedObjectContext save:nil];
        }
        
        [loadingView stopAnimating];
        [loadingView removeFromSuperview];
        [loadingLabel removeFromSuperview];
    }];
    
    
}

-(void)buttonArithmeticAction: (UIButton*)sender{
    self.studentTable.userInteractionEnabled=NO;
    
    UIButton *btn = (UIButton *)sender;
    UITableViewCell *cell = [self parentCellForView:btn];
    if (cell != nil) {
        NSIndexPath *indexPath = [_studentTable indexPathForCell:cell];
        StudentObject *studentObj = [self.studentsArrays objectAtIndex:indexPath.row];
        if (sender.tag == 100) {
            [studentObj addCoinsToStudentObject:[NSNumber numberWithInt:1]];
            
        }
        else if (sender.tag == 200){
            [studentObj subtractCoinsToStudentObject:[NSNumber numberWithInt:1]];
        }
        
        NSError *error;
        [_managedObjectContext save:&error];
        
        //update cell
        [_studentTable beginUpdates];
        [_studentTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [_studentTable endUpdates];
        
        self.studentTable.userInteractionEnabled=YES;
        
        //[self updateDatabaseFromCore];
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

- (void)refresh:(UIRefreshControl *)refreshControl {
        NSString *objId = [[NSUserDefaults standardUserDefaults] objectForKey:@"ObjectId"];
    QueryWebService *query = [[QueryWebService alloc]initWithTable:@"StudentObject"];
    [query selectColumnWhere:@"teacher" equalTo:objId];
    [query selectColumnWhere:@"className" equalTo:[self.className lowercaseString]];
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
                self.connection=nil;
            }
            
            self.tabBarController.navigationItem.title = [NSString stringWithFormat:@"%@ (%d)",self.className,self.totalNumberOfStudents];
            
            NSMutableArray *unsortedArray = [[NSMutableArray alloc]initWithCapacity:0];
            
            for (NSDictionary *studentObj in rows){

                StudentObject *studentObjInCore = [StudentObject createStudentObjectInCoreWithDictionary:studentObj inManagedObjectContext:_managedObjectContext];
                studentObjInCore.nameOfclass = studentObj[@"className"];
                studentObjInCore.studentName = studentObj[@"studentName"];
                NSNumber *stuNum = studentObj[@"studentNumber"];
                int stuNumInt = [stuNum intValue];
                studentObjInCore.studentNumber=[NSNumber numberWithInt:stuNumInt];
                NSNumber *stuCoin = studentObj[@"coins"];
                int stuCoinint = [stuCoin intValue];
                studentObjInCore.coins = [NSNumber numberWithInt:stuCoinint];
                studentObjInCore.taken = studentObj[@"taken"];
                studentObjInCore.teacherEmail = studentObj[@"teacherEmail"];
                NSNumber *signedInNum =studentObj[@"signedIn"];
                int signedInInt = [signedInNum intValue];
                studentObjInCore.signedIn = [NSNumber numberWithInt:signedInInt];
                
                [unsortedArray addObject:studentObjInCore];
            }
            [self.studentsArrays removeAllObjects];
            
            [self.studentsArrays addObjectsFromArray:[self sortArrayFinal:unsortedArray]];
            
            [self.studentTable reloadData];
            [_managedObjectContext save:nil];
            
            [self.studentTable reloadData];
        }
        [refreshControl endRefreshing];
    }];
    
}

//sidemenu code

-(void)menuViewAction{
    
    if (self.connection!=nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You may not edit your class" message:@"You may not edit until you have a network connection." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else{
        if (IS_IPAD) {
            
            self.studentMenu = [[MenuTable alloc]initWithFrame:CGRectZero];
            self.studentMenu.translatesAutoresizingMaskIntoConstraints=NO;
            [self.studentMenu displayStudentMenu];
            self.studentMenu.sortString = _classObj.sortDescrip;
            [self.tabBarController.navigationController.view addSubview:self.studentMenu];


            [self.tabBarController.navigationController.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_studentMenu]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_studentMenu)]];
            
            self.hiddenTable = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[_studentTable]-[_studentMenu(==_studentTable)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_studentTable,_studentMenu)];
            
            self.showTable = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_studentMenu]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_studentMenu)];

            [self.tabBarController.navigationController.view addConstraints:self.hiddenTable];
            
            [self.tabBarController.navigationController.view layoutIfNeeded];

            [UIView animateWithDuration:0.4 animations:^{
                
                [self.tabBarController.navigationController.view removeConstraints:self.hiddenTable];
                [self.tabBarController.navigationController.view addConstraints:self.showTable];
                
                [self.tabBarController.navigationController.view layoutIfNeeded];
            }];
            
        }
        else if(IS_IPHONE){
            self.studentMenu = [[MenuTable alloc]initWithFrame:CGRectMake(self.view.frame.size.width, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
            self.studentMenu.sortString = _classObj.sortDescrip;
            [self.studentMenu displayStudentMenu];
            [self.navigationController.view addSubview:self.studentMenu];
            
            [UIView animateWithDuration:0.4 animations:^{
                [self.studentMenu setFrame:self.view.frame];
            }];
        }
    }
}


//menu selection

-(void)selectionMethod{
    
    if ([self.studentMenu.menuOption  isEqualToString: @"Add More Students"]) {
        [self.studentMenu menuAnimation];
            NSString *objId = [[NSUserDefaults standardUserDefaults] objectForKey:@"ObjectId"];
        NSError *error;
        NSFetchRequest *studentsRequest = [NSFetchRequest fetchRequestWithEntityName:@"StudentObject"];
        studentsRequest.predicate= [NSPredicate predicateWithFormat:@"(teacher = %@) AND (nameOfclass = %@)",objId,[self.className lowercaseString]];
        NSSortDescriptor *nameSort = [[NSSortDescriptor alloc] initWithKey:@"studentNumber" ascending:YES];
        studentsRequest.sortDescriptors = [NSArray arrayWithObjects:nameSort, nil];
        NSArray *studentObjArray = [_managedObjectContext executeFetchRequest:studentsRequest error:&error];
        StudentObject *lastStudent = [studentObjArray lastObject];
        NSLog(@"name: %@ number: %@",lastStudent.studentName,lastStudent.studentNumber);
        
        self.totalNumberOfStudents = [lastStudent.studentNumber intValue];
        
        [self performSegueWithIdentifier:@"addstudentview" sender:self];
    }
    else if ([self.studentMenu.menuOption  isEqualToString:@"Manage Coins"]){
        [self.studentMenu menuAnimation];
        [self.studentTable setEditing:YES animated:YES];
        [self.refreshControl removeFromSuperview];
        [self updateButtonEditing];
        [self manageCoinsInGroupsActions];
            
    }
    else if ([self.studentMenu.menuOption  isEqualToString:@"Delete Students"]){
        [self.studentMenu menuAnimation];
        [self.studentTable setEditing:YES animated:YES];
        [self.refreshControl removeFromSuperview];
        [self updateButtonEditing];
    }
    else if ([self.studentMenu.menuOption  isEqualToString:@"Group Students"]){
        
        [self performSegueWithIdentifier:@"studentGroupSegue" sender:self];
    }
    else if ([self.studentMenu.menuOption isEqualToString:@"Teacher's Log"]){
        
        [self performSegueWithIdentifier:@"monthseg" sender:self];
        
    }
    else if ([self.studentMenu.menuOption isEqualToString:@"Sort Students By:"]){
        
        self.pickerArray = [[NSArray alloc]initWithObjects:@"Pick One",@"First Name:Ascending",@"First Name:Descending",@"Last Name:Ascending",@"Last Name:Descending",@"Student Number:Ascending",@"Student Number:Descending",@"Coins:Ascending",@"Coins:Descending", nil];
        self.pickerSort = [[UIPickerView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x,self.view.frame.size.height-162, self.view.frame.size.width,162)];
        self.pickerSort.delegate=self;
        self.pickerSort.dataSource=self;
        self.pickerSort.userInteractionEnabled=YES;
        [self.pickerSort setBackgroundColor:[UIColor whiteColor]];
        
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(pickerButtonActions:)];
        [doneButton setTag:500];
        
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(pickerButtonActions:)];
        [cancelButton setTag:600];
        
        UIBarButtonItem *flexibleButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        
        NSArray *toolbarItems = [NSArray arrayWithObjects: doneButton,flexibleButton,cancelButton, nil];
        
        UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(self.view.frame.origin.x,self.pickerSort.frame.origin.y-44,self.view.frame.size.width, 44)];
        [toolBar setBarStyle:UIBarStyleDefault];
        [toolBar setItems:toolbarItems];
        
        UIView *pickerView = [[UIView alloc]initWithFrame:self.view.frame];
        [pickerView setTag:700];
        [pickerView setBackgroundColor:[UIColor clearColor]];
        
        [self.tabBarController.navigationController.view addSubview:pickerView];
        [pickerView addSubview:self.pickerSort];
        [pickerView addSubview:toolBar];

    }
    
}

//picker sort
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (row==0){
        [pickerView selectRow:1 inComponent:component animated:YES];
        self.sortByString = [self.pickerArray objectAtIndex:1];
    }
    else{
        self.sortByString = [self.pickerArray objectAtIndex:row];
    }
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [_pickerArray objectAtIndex:row];
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [_pickerArray count];
}

-(void)pickerButtonActions:(UIBarButtonItem*)sender{
    
    UIView *pv = (UIView*)[self.tabBarController.navigationController.view viewWithTag:700];
    
    if (sender.tag==500) {
        //done button
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
            pv.frame=CGRectMake(self.view.frame.origin.x,self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
            
        } completion:^(BOOL finished) {

            _classObj.sortDescrip = self.sortByString;
            
            [_managedObjectContext save:nil];
            
            //Show data from Database first CAN BE REPLACED WITH RELATIONSHIPS
            NSString *objId = [[NSUserDefaults standardUserDefaults] objectForKey:@"ObjectId"];
            NSError *error;
            NSFetchRequest *studentsRequest = [NSFetchRequest fetchRequestWithEntityName:@"StudentObject"];
            studentsRequest.predicate= [NSPredicate predicateWithFormat:@"teacher = %@ AND nameOfclass = %@",objId,[self.className lowercaseString]];
            NSArray *studentObjArray = [_managedObjectContext executeFetchRequest:studentsRequest error:&error];
            
            [self.studentsArrays removeAllObjects];
            [self.studentsArrays addObjectsFromArray:[self sortArrayFinal:studentObjArray]];
            [self.studentTable reloadData];
            
        }];
        
        [self.studentMenu menuAnimation];
        [pv removeFromSuperview];
        self.pickerSort=nil;
    }
    else if (sender.tag ==600){
        
        //cancel button
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
            pv.frame=CGRectMake(self.view.frame.origin.x,self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
        } completion:^(BOOL finished) {
            [self.studentMenu menuAnimation];
            
        }];
        [pv removeFromSuperview];
        self.pickerSort=nil;

    }
}


-(NSMutableArray*)sortArrayFinal:(NSArray*)arrayToSort{
    
    NSArray *sortDescriptors = [self sortStudentsBy:self.classObj.sortDescrip];
    
    if (sortDescriptors) {
        
        NSMutableArray *sortedArray = [[NSMutableArray alloc]initWithArray:[arrayToSort sortedArrayUsingDescriptors:sortDescriptors]];
    
        return sortedArray;
    }
    else{
        
        if ([self.classObj.sortDescrip isEqualToString:@"Last Name:Descending"]) {

            NSMutableArray *sortedArray = [[NSMutableArray alloc]initWithArray:[arrayToSort sortedArrayUsingComparator:^NSComparisonResult(StudentObject *a, StudentObject *b) {

                NSArray *firstStudent = [a.studentName componentsSeparatedByString:@" "];
                NSArray *secondStudent = [b.studentName componentsSeparatedByString:@" "];
                
                if ([firstStudent count] == 1) {
                    return 1;
                }
                else if ([secondStudent count] == 1){
                    return -1;
                }
                
                NSString *firstStudentLast = [[firstStudent lastObject] lowercaseString];
               
                NSString *secondStudentLast = [[secondStudent lastObject] lowercaseString];
                
                return [secondStudentLast compare:firstStudentLast];
            }]];
                
            return sortedArray;

        }
        else{
            NSMutableArray *sortedArray = [[NSMutableArray alloc]initWithArray:[arrayToSort sortedArrayUsingComparator:^NSComparisonResult(StudentObject *a, StudentObject *b) {
                
                NSArray *firstStudent = [a.studentName componentsSeparatedByString:@" "];
                NSArray *secondStudent = [b.studentName componentsSeparatedByString:@" "];
                
                if ([firstStudent count] == 1) {
                    return 1;
                }
                else if ([secondStudent count] == 1){
                    return -1;
                }
                
                NSString *firstStudentLast = [[firstStudent lastObject] lowercaseString];
                
                NSString *secondStudentLast = [[secondStudent lastObject] lowercaseString];
                
                return [firstStudentLast compare:secondStudentLast];
            }]];
            
            return sortedArray;
        }
    }
}




//sorting the names method
//-(void)sortByInStudentTable:(NSString*)sortBy queryBoundsPassIn:(QueryWebService *)queryMethod{
//    
//    
//    if ([sortBy isEqualToString:@"First Name:Ascending"]) {
//        [queryMethod orderByAscendingForColumn:@"studentName"];
//    }
//    else if ([sortBy isEqualToString:@"First Name:Descending"]){
//        [queryMethod orderByDescendingForColumn:@"studentName"];
//    }
//    else if ([sortBy isEqualToString:@"Student Number:Ascending"]){
//        [queryMethod orderByAscendingForColumn:@"studentNumber"];
//    }
//    else if ([sortBy isEqualToString:@"Student Number:Descending"]){
//        [queryMethod orderByDescendingForColumn:@"studentNumber"];
//    }
//    else if ([sortBy isEqualToString:@"Coins:Ascending"]){
//        [queryMethod orderByAscendingForColumn:@"coins"];
//    }
//    else if ([sortBy isEqualToString:@"Coins:Descending"]){
//        [queryMethod orderByDescendingForColumn:@"coins"];
//    }
//    else{
//        [queryMethod orderByAscendingForColumn:@"studentNumber"];
//    }
//    
//}

-(NSArray*)sortStudentsBy:(NSString*)sortBy{
    
    
    if ([sortBy isEqualToString:@"First Name:Ascending"]) {
        NSSortDescriptor *nameSort = [[NSSortDescriptor alloc] initWithKey:@"studentName" ascending:YES];
         return [NSArray arrayWithObjects:nameSort, nil];
    }
    else if ([sortBy isEqualToString:@"First Name:Descending"]){
        
        NSSortDescriptor *nameSort = [[NSSortDescriptor alloc] initWithKey:@"studentName" ascending:NO];
        return [NSArray arrayWithObjects:nameSort, nil];
        
    }
    else if ([sortBy isEqualToString:@"Student Number:Ascending"]){
        NSSortDescriptor *nameSort = [[NSSortDescriptor alloc] initWithKey:@"studentNumber" ascending:YES];
        return [NSArray arrayWithObjects:nameSort, nil];
    }
    else if ([sortBy isEqualToString:@"Student Number:Descending"]){
        NSSortDescriptor *nameSort = [[NSSortDescriptor alloc] initWithKey:@"studentNumber" ascending:NO];
        return [NSArray arrayWithObjects:nameSort, nil];
    }
    else if ([sortBy isEqualToString:@"Coins:Ascending"]){
        NSSortDescriptor *nameSort = [[NSSortDescriptor alloc] initWithKey:@"coins" ascending:YES];
        return [NSArray arrayWithObjects:nameSort, nil];
    }
    else if ([sortBy isEqualToString:@"Coins:Descending"]){
        NSSortDescriptor *nameSort = [[NSSortDescriptor alloc] initWithKey:@"coins" ascending:NO];
        return [NSArray arrayWithObjects:nameSort, nil];
    }
    else{
        
        return nil;
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
    
//    if (IS_IPAD) {
        self.askCoinView = [[manageCoinView alloc]init];
        self.askCoinView.teacherName=self.nameOfTeacher;
        self.askCoinView.className = self.className;
        [self.view insertSubview:self.askCoinView belowSubview:self.studentTable];
        
        self.askCoinView.translatesAutoresizingMaskIntoConstraints=NO;
        self.manageCoinToolbarSelection.translatesAutoresizingMaskIntoConstraints=NO;
    self.askCoinView.backgroundColor = [UIColor redColor];
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
        
//    }
//    else if (IS_IPHONE){
//        
//        self.askCoinView = [[manageCoinView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, 64, self.view.frame.size.width,80)];
//        self.askCoinView.teacherName=self.nameOfTeacher;
//        self.askCoinView.className = self.className;
//        [self.view insertSubview:self.askCoinView belowSubview:self.studentTable];
//        [self.manageCoinToolbarSelection setFrame:CGRectMake(self.view.frame.origin.x, self.askCoinView.frame.origin.y+self.askCoinView.frame.size.height,self.view.frame.size.width,44)];
//        
//        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//            self.studentTable.frame=CGRectMake(self.studentTable.frame.origin.x,self.studentTable.frame.origin.y+80+44, self.studentTable.frame.size.width,self.studentTable.frame.size.height-80-44);
//        } completion:^(BOOL finished) {
//        }];
//    }

    
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
        

        [self.askCoinView manageCoinsWithSelectedArray:selectedRows studentArray:self.studentsArrays inManagedObjectContext:_managedObjectContext typeOfSign:YES];
        
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
        [self.studentTable addSubview:_refreshControl];
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

        [self.askCoinView manageCoinsWithSelectedArray:selectedRows studentArray:self.studentsArrays inManagedObjectContext:_managedObjectContext typeOfSign:NO];
        
        
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
        [self.studentTable addSubview:_refreshControl];
        [self updateButtonEditing];
        
        //update table
        [self.studentTable reloadData];
    }
}

-(void)updateStudentNumbers{
   
    NSMutableArray *changeNumbersArray = [[NSMutableArray alloc]initWithCapacity:[self.studentsArrays count]];
    [changeNumbersArray addObjectsFromArray:self.studentsArrays];
    
    NSArray *sortDescripter = [self sortStudentsBy:@"Student Number:Ascending"];
    
    NSMutableArray *sortedArray = [[NSMutableArray alloc]initWithArray:[changeNumbersArray sortedArrayUsingDescriptors:sortDescripter]];

    
    
    int i=0;
    NSMutableArray *jsonDictionaryArray = [[NSMutableArray alloc]initWithCapacity:[sortedArray count]];
    for (StudentObject*studentObj in sortedArray) {
        i++;
        NSLog(@"objectIdnumber: %@",studentObj.studentNumber);
        NSDictionary *jsonDict = @{@"objectId":studentObj.objectId,@"studentNumber":@(i)};
        [jsonDictionaryArray addObject:jsonDict];
    }
    
    UpdateWebService *updateRows = [[UpdateWebService alloc]initWithTable:@"StudentObject"];
    [updateRows updateMultipleRowsWithDictionaryArray:jsonDictionaryArray columnToUpdate:@"studentNumber" where:@"objectId"];
    [updateRows saveUpdateInBackgroundWithBlock:^(NSError *error) {
        if (!error) {
            [self updateTableFromDatabaseIntoCore];
        }
    }];
    
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
            
            NSMutableArray *deleteRowsArrayFromDatabase = [[NSMutableArray alloc]initWithCapacity:0];
            
            LogWebService *classLog = [[LogWebService alloc]initWithLogType:@"class_logs"];
            LogWebService *announceLog = [[LogWebService alloc]initWithLogType:@"announcement"];
            
            for (StudentObject* studentObj in studentObjSelectedArray) {
                //delete log
                
                [deleteRowsArrayFromDatabase addObject:studentObj.objectId];
                [_managedObjectContext deleteObject:studentObj];
                
            }
            
            [classLog deleteLogsWithId:deleteRowsArrayFromDatabase];
            [announceLog deleteLogsWithId:deleteRowsArrayFromDatabase];
            
            [_managedObjectContext save:nil];
            
            //Delete from Database
            DeleteWebService *deleteRows = [[DeleteWebService alloc]initWithTable:@"StudentObject"];
            [deleteRows selectRowToDeleteWhere:@"objectId" containsArray:deleteRowsArrayFromDatabase];
            [deleteRows deleteRow];
            
            DeleteWebService *deleteEconomy =[[DeleteWebService alloc]initWithTable:@"Economy"];
            [deleteEconomy selectRowToDeleteWhere:@"ObjectId" containsArray:deleteRowsArrayFromDatabase];
            [deleteEconomy deleteRow];
            
    
            [self.studentsArrays removeObjectsAtIndexes:indicesOfItemsToDelete];
            [self.studentTable deleteRowsAtIndexPaths:selectedRows withRowAnimation:YES];
            
            [self updateStudentNumbers];
        }
        else
        {
            // Delete everything, delete the objects from our data model.
                NSString *objId = [[NSUserDefaults standardUserDefaults] objectForKey:@"ObjectId"];
            NSMutableArray *objectIdLogs = [[NSMutableArray alloc]initWithCapacity:0];
            for (StudentObject* studentObj in self.studentsArrays) {
                
                [objectIdLogs addObject:studentObj.objectId];
                
                [_managedObjectContext deleteObject:studentObj];
            }
            [_managedObjectContext save:nil];
            
            //delete logs
            LogWebService *classLog = [[LogWebService alloc]initWithLogType:@"class_logs"];
            LogWebService *announceLog = [[LogWebService alloc]initWithLogType:@"announcement"];
            [classLog deleteLogsWithId:objectIdLogs];
            [announceLog deleteLogsWithId:objectIdLogs];
            
            //Delete from Database
            DeleteWebService *deleteRows = [[DeleteWebService alloc]initWithTable:@"StudentObject"];
            [deleteRows selectRowToDeleteWhereColumn:@"teacher" equalTo:objId];
            [deleteRows selectRowToDeleteWhereColumn:@"className" equalTo:[self.className lowercaseString]];
            [deleteRows deleteRow];
        }
        
        // Exit editing mode after the deletion.
        
        [self.studentTable setEditing:NO animated:YES];
        [self.studentTable addSubview:_refreshControl];
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

        self.tabBarController.navigationItem.rightBarButtonItem = rightButton;
        self.tabBarController.navigationItem.leftBarButtonItem=nil;

    }
}


-(void)cancelButtonAction{
    [self.studentTable setEditing:NO animated:YES];
    [self.studentTable addSubview:_refreshControl];

    [self updateButtonEditing];

    if ([self.studentMenu.menuOption isEqualToString:@"Manage Coins"]) {
        
        [self.askCoinView.coinsField resignFirstResponder];
//        if (IS_IPAD) {
            [self.view layoutIfNeeded];
            [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.view removeConstraints:_pinStudentTableDown];
                [self.view addConstraints:_pinStudentTableToTop];
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {
            }];
            
            
//        }
//        else if (IS_IPHONE){
//            [self.askCoinView.coinsField resignFirstResponder];
//
//            [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//                
//                self.studentTable.frame=CGRectMake(self.studentTable.frame.origin.x,self.studentTable.frame.origin.y-80-44, self.studentTable.frame.size.width,self.studentTable.frame.size.height+80+44);
//            } completion:^(BOOL finished) {
//                [self.askCoinView removeFromSuperview];
//                self.askCoinView =nil;
//            }];
//            
//        }
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
        StudentObject *selectedStudentObj = nil;
        selectedStudentObj = [self.studentsArrays objectAtIndex:indexPath.row];
        self.selectedStudentObjForLog = selectedStudentObj;
        [self.studentTable deselectRowAtIndexPath:indexPath animated:NO];
        [self performSegueWithIdentifier:@"pieChartSegue" sender:self];
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
    if ([segue.identifier isEqualToString:@"addstudentview"]){
        AddViewController *addVC = (AddViewController*)segue.destinationViewController;
        addVC.className=self.className;
        addVC.teachersName = self.nameOfTeacher;
        addVC.managedObjectContext = self.managedObjectContext;
        addVC.demoManagedObjectContext=self.demoManagedObjectContext;
        addVC.delegate=self;
    }
    else if ([segue.identifier isEqualToString:@"monthseg"]){
        MonthLogViewController *monthVC = (MonthLogViewController*)segue.destinationViewController;
        
        if ([self.studentMenu.menuOption isEqualToString:@"Teacher's Log"]) {
            monthVC.teachersLogOption = self.studentMenu.menuOption;
            monthVC.currentMonth =self.month;
            monthVC.classNameInMonth=self.className;
            self.studentMenu.menuOption=nil;
        }

    }
    else if ([segue.identifier isEqualToString:@"studentGroupSegue"]){
        StudentGroupViewController *groupVC = (StudentGroupViewController*)segue.destinationViewController;
        groupVC.managedObjectContext= _managedObjectContext;
        groupVC.classObject = self.classObj;
        groupVC.demoManagedObjectContext=self.demoManagedObjectContext;
    }
    else if ([segue.identifier isEqualToString:@"pieChartSegue"]){
        PieChartViewController *pieVC = (PieChartViewController*)segue.destinationViewController;
        pieVC.selectedStudent = self.selectedStudentObjForLog;
        pieVC.managedObjectContext = self.managedObjectContext;
        pieVC.demoManagedObjectContext=self.demoManagedObjectContext;
    }
}

@end



