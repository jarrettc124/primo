//
//  BuyItemsViewController.m
//  TeacherApp
//
//  Created by Jarrett Chen on 3/16/14.
//  Copyright (c) 2014 Jarrett Chen. All rights reserved.
//


#import "BuyItemsViewController.h"

@interface BuyItemsViewController ()
//ui stuff
@property (nonatomic,strong) UITableView *studentTable;

@property (nonatomic,strong) ClassObject *classObj;
@property(nonatomic,strong) NSString *nameOfTeacher;
@property(nonatomic) NSInteger month;
@property(nonatomic,strong) NSString *dateString;

@property (nonatomic,strong)NSMutableArray *studentArray;
@end

@implementation BuyItemsViewController

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

    UIImageView *toolbarBackground = [[UIImageView alloc]init];
    [toolbarBackground setImage:[UIImage imageNamed:@"blackboardBar"]];
    toolbarBackground.userInteractionEnabled=YES;
    [self.view addSubview:toolbarBackground];
    
    UIBarButtonItem *buyButton = [[UIBarButtonItem alloc]initWithTitle:@"Buy" style:UIBarButtonItemStylePlain target:self action:@selector(buyAction)];
    self.navigationItem.rightBarButtonItem=buyButton;
    
    self.navigationItem.title = @"Pick Your Students";
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
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
    
    if(IS_IPAD){
        toolbarBackground.translatesAutoresizingMaskIntoConstraints=NO;
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[toolbarBackground]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(toolbarBackground)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[toolbarBackground(64)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(toolbarBackground)]];
        
    }
    else if (IS_IPHONE){
        toolbarBackground.frame = CGRectMake(0, 0, self.view.frame.size.width, 64);
    }
    [self makeTable];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

-(void)buyAction{
    NSString *actionTitle = [NSString stringWithFormat:@"Are you sure you want to purchase: %@",self.storeItem.item];

    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:actionTitle delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Yes, please!" otherButtonTitles:nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	// The user tapped one of the OK/Cancel buttons.
	if (buttonIndex == 0)
	{
        NSArray *selectedRows = [self.studentTable indexPathsForSelectedRows];
        [self buyItemsForStudentinParse:selectedRows];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_studentArray count];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   // NSLog(@"Start cellForRow");
    static NSString *CellIdentifier = @"studentCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"studentCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
    }

    
    StudentObject* studentObj = [self.studentArray objectAtIndex:indexPath.row];

    cell.textLabel.text = studentObj.studentName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Coins: %d",[studentObj.coins intValue]];

    if ([self.storeItem.cost intValue]>[studentObj.coins intValue]) {
        cell.userInteractionEnabled=NO;
        cell.textLabel.textColor = [UIColor grayColor];
        cell.detailTextLabel.textColor = [UIColor grayColor];
    }
    
    return cell;
    
}

-(void)makeTable{
    NSString *objId = [[NSUserDefaults standardUserDefaults] objectForKey:@"ObjectId"];
    
    self.classObj = [ClassObject findClassObjectInCoreWithTeacherId:objId className:self.className inManagedObjectContext:_managedObjectContext];
    
    //Show data from Database first CAN BE REPLACED WITH RELATIONSHIPS
    NSError *error;
    NSFetchRequest *studentsRequest = [NSFetchRequest fetchRequestWithEntityName:@"StudentObject"];
    studentsRequest.predicate= [NSPredicate predicateWithFormat:@"(teacher = %@) AND (nameOfclass = %@)",objId,[self.className lowercaseString]];
    NSArray *studentObjArray = [_managedObjectContext executeFetchRequest:studentsRequest error:&error];
    
    self.studentArray = [self sortArrayFinal:studentObjArray];
    
    _studentTable = [[UITableView alloc]init];
    _studentTable.delegate =self;
    _studentTable.dataSource =self;
    self.studentTable.allowsMultipleSelectionDuringEditing = YES;
    self.studentTable.allowsSelection = NO;
    [self.studentTable setEditing:YES];
    [self.view addSubview:self.studentTable];
    
    if (IS_IPAD) {
        self.studentTable.translatesAutoresizingMaskIntoConstraints=NO;
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-64-[_studentTable]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_studentTable)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_studentTable]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_studentTable)]];
    }
    else if (IS_IPHONE){
        [self.studentTable setFrame:CGRectMake(0.0, 64.0, self.view.frame.size.width, self.view.frame.size.height - self.tabBarController.tabBar.frame.size.height-67)];
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

-(void)buyItemsForStudentinParse:(NSArray*)indexesOfSelectedArrays{
    NSString *objId = [[NSUserDefaults standardUserDefaults] objectForKey:@"ObjectId"];
    
    //Loading View
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.navigationItem.hidesBackButton=YES;

    UIView *loadingView = [[UIView alloc]initWithFrame:self.view.frame];
    loadingView.backgroundColor = [UIColor blackColor];
    loadingView.alpha=0.5;
    [self.view addSubview:loadingView];
    
    UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-25, (self.view.frame.size.height)/2, 50, 50)];
    [self.view addSubview:loading];
    [loading setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [loading hidesWhenStopped];
    [loading startAnimating];

    int itemValueInt = [self.storeItem.cost intValue];
    
    BOOL addSpecificRows = indexesOfSelectedArrays.count > 0;
    if (addSpecificRows)
    {
        // Build an NSIndexSet
        NSMutableIndexSet *indicesOfItemsToAdd = [NSMutableIndexSet new];
        for (NSIndexPath *selectionIndex in indexesOfSelectedArrays)
        {
            [indicesOfItemsToAdd addIndex:selectionIndex.row];
            
        }

        //Update the selected objects
        NSArray *selectedStudentArray = [self.studentArray objectsAtIndexes:indicesOfItemsToAdd]; //array of names to be found
        NSMutableArray *pushNotifications = [[NSMutableArray alloc]initWithCapacity:0]; //array for push notifications
        
 
        NSString *announcementBody = [NSString stringWithFormat:@"%@ has just bought %@ for you for %@ coins",self.nameOfTeacher,self.storeItem.item,self.storeItem.cost];
        
        LogWebService *studentLogService = [[LogWebService alloc]initWithLogType:@"class_logs"];
        LogWebService *announcementLogService = [[LogWebService alloc]initWithLogType:@"announcement"];
        
        NSMutableArray *dictionaryToUpdateArray = [[NSMutableArray alloc]initWithCapacity:0];
        
        for (StudentObject *studentObj in selectedStudentArray) {
            
            [studentObj buyCoinsStudentObject:[NSNumber numberWithInt:itemValueInt]];

            //To update the database
            NSDictionary *jsonDict = @{@"objectId":studentObj.objectId,@"coins":studentObj.coins};
            [dictionaryToUpdateArray addObject:jsonDict];

            //update log
            //student's log
            NSString *studentLogText = [NSString stringWithFormat:@"%@ has just bought %@ for you for %@ coins",self.nameOfTeacher,self.storeItem.item,self.storeItem.cost];
            [studentLogService updateLogWithUserId:studentObj.objectId className:self.className updateLogString:studentLogText];
            
            //Update Teacher's log
            NSString *teacherLogText =[NSString stringWithFormat:@"You bought %@ for %@ with %@ coins",self.storeItem.item,studentObj.studentName,self.storeItem.cost];
            [studentLogService updateLogWithUserId:objId className:self.className updateLogString:teacherLogText];
            
            
            if (![studentObj.taken isEqualToString:@""]) {
                //set announcements
                
                //set notification
                AnnouncementObject *annObj = [[AnnouncementObject alloc]initWithTeacherId:objId];
                
                [annObj postAnnouncementTo:studentObj.taken announcementType:@"Store" personType:@"Student" announcementBody:announcementBody];
                
                [annObj updateBadgeToDatabaseWithId:studentObj.taken className:[self.className lowercaseString]];
                
                //update announcement log
                [announcementLogService updateLogWithUserId:studentObj.objectId className:[self.className lowercaseString] updateLogString:announcementBody];
                
                [pushNotifications addObject:studentObj.taken];
                
            }
                
        }
        
        //Push to students
        PushWebService *pushWeb = [[PushWebService alloc]init];
        [pushWeb sendPushToUserIDS:pushNotifications pushMessage:announcementBody];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!" message:[NSString stringWithFormat:@"You purchased %@ for your students",self.storeItem.item] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
//        [self.delegate buyingComplete:self];
        self.navigationItem.rightBarButtonItem.enabled = YES;
        self.navigationItem.hidesBackButton=NO;
        [loadingView removeFromSuperview];
        [loading stopAnimating];
        [loading removeFromSuperview];
 
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    else{
        self.navigationItem.rightBarButtonItem.enabled = YES;
        self.navigationItem.hidesBackButton=NO;
        [loadingView removeFromSuperview];
        [loading stopAnimating];
        [loading removeFromSuperview];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uh oh, did you forget to select your students?" message:@"Please try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if ([segue.identifier isEqualToString:@"donebuysegue"]) {
//
//        UITabBarController *tabbarC = (UITabBarController*)segue.destinationViewController;
//        
//        StudentsViewController *studentVC = [tabbarC.viewControllers objectAtIndex:0];
//        
//        TeacherStoreViewController *storeVC = [tabbarC.viewControllers objectAtIndex:1];
//        
//        AnnouncementViewController *annVC = [tabbarC.viewControllers objectAtIndex:2];
//        
//        
//        moreViewController *moreVC = [tabbarC.viewControllers objectAtIndex:3];
//
//        
//        
//        annVC.className=_className;
//        annVC.managedObjectContext = _managedObjectContext;
//        annVC.demoManagedObjectContext=self.demoManagedObjectContext;
//
//        moreVC.classNameInMore = _className;
//        moreVC.managedObjectContext=_managedObjectContext;
//        moreVC.demoManagedObjectContext=self.demoManagedObjectContext;
//        
//        storeVC.className=_className;
//        storeVC.managedObjectContext = _managedObjectContext;
//        storeVC.demoManagedObjectContext=self.demoManagedObjectContext;
//        
//        studentVC.className=_className;
//        studentVC.managedObjectContext=self.managedObjectContext;
//        studentVC.demoManagedObjectContext = self.demoManagedObjectContext;
////        self.delegate = studentVC;
//    }
//}


@end
