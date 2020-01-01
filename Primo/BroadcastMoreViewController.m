//
//  BroadcastMoreViewController.m
//  Primo
//
//  Created by Jarrett Chen on 5/19/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import "BroadcastMoreViewController.h"

@interface BroadcastMoreViewController ()

@property (nonatomic,strong) UILabel *classLabel;
@property (nonatomic,strong) UILabel *typeLabel;
@property (nonatomic,strong) UILabel *dateLabel;
@property (nonatomic,strong) UIImageView *typeImage;

@property (nonatomic,strong) UITableView *infoTable;
@property (nonatomic) NSInteger month;
@end

@implementation BroadcastMoreViewController

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
    
    UITableView *infoTable = [[UITableView alloc]init];
    infoTable.cellLayoutMarginsFollowReadableWidth = NO;

    infoTable.delegate=self;
    infoTable.dataSource=self;
    infoTable.scrollEnabled=NO;
    [self.view addSubview:infoTable];
    
    
    self.tableArray = @[@"Class:",@"Type:",@"Date:"];
    
    self.classLabel = [[UILabel alloc]initWithFrame:CGRectMake(70,5, self.view.frame.size.width-75, 35)];
    
    NSString *recipient = [self.announcementObj[@"Recipient"] capitalizedString];
    NSString *userType = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserType"];
    
    if (![userType isEqualToString:@"Teacher"]) {
        if ((![recipient isEqualToString:@"Every Class"]) && (![recipient isEqualToString:[self.studentObj.nameOfclass capitalizedString]])) {
            self.classLabel.text = @"Student";
        }
        else{
            self.classLabel.text = recipient;
        }
    }
    else{
        if ((![recipient isEqualToString:@"Every Class"]) && (![recipient isEqualToString:[self.className capitalizedString]])) {
            self.classLabel.text = @"Student";
        }
        else{
            self.classLabel.text = recipient;
        }
    }
    

    
    self.typeImage = [[UIImageView alloc]initWithFrame:CGRectMake(65, 5, 35, 35)];
    if ([self.announcementObj[@"AnnouncementType"] isEqualToString:@"Announcement"]) {
        [self.typeImage setImage:[UIImage imageNamed:@"megaphoneImage50x"]];
    }
    else if([self.announcementObj[@"AnnouncementType"] isEqualToString:@"Store"]){
        [self.typeImage setImage:[UIImage imageNamed:@"storeIcon50x"]];
    }
    else{
        [self.typeImage setImage:[UIImage imageNamed:@"homeworkIcon50x"]];
    }
    self.typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(105, 5, self.view.frame.size.width-110, 35)];
    self.typeLabel.text = self.announcementObj[@"AnnouncementType"];
    
    //get annDate
    NSDateFormatter *annDateFormatter = [[NSDateFormatter alloc] init];
    annDateFormatter.timeZone = [NSTimeZone localTimeZone];
    annDateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *annDate = [annDateFormatter dateFromString:self.announcementObj[@"CreatedAt"]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
    [timeFormatter setDateFormat:@"hh:mm a"];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSMonthCalendarUnit;
    NSDateComponents *pickerDate = [calendar components:unitFlags fromDate:[NSDate date]];
    self.month = (int)[pickerDate month];


    self.dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(65,5, self.view.frame.size.width-70, 35)];
    self.dateLabel.text = [NSString stringWithFormat:@"%@ at %@",[dateFormatter stringFromDate:annDate],[timeFormatter stringFromDate:annDate]];

    UITextView *bodyView = [[UITextView alloc]init];
    bodyView.editable=NO;
    bodyView.font = [UIFont systemFontOfSize:17];
    bodyView.text = self.announcementObj[@"AnnouncementBody"];
    [self.view addSubview:bodyView];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithTitle:@"Log" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonAction)];
    [self.navigationItem setRightBarButtonItem:rightBarButton];
    
    if (IS_IPAD) {
        toolbarBackground.translatesAutoresizingMaskIntoConstraints=NO;
        infoTable.translatesAutoresizingMaskIntoConstraints=NO;
        bodyView.translatesAutoresizingMaskIntoConstraints=NO;
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[toolbarBackground(64)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(toolbarBackground)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[toolbarBackground]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(toolbarBackground)]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[toolbarBackground]-0-[infoTable(132)]-[bodyView]-56-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(toolbarBackground,infoTable,bodyView)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[bodyView]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(bodyView)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[infoTable]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(infoTable)]];
        
        
        
    }
    else if (IS_IPHONE){
        [toolbarBackground setFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
        [infoTable setFrame:CGRectMake(self.view.frame.origin.x, 64, self.view.frame.size.width,132)];
        [bodyView setFrame:CGRectMake(5,infoTable.frame.origin.y+infoTable.frame.size.height,self.view.frame.size.width-10, self.view.frame.size.height-self.tabBarController.tabBar.frame.size.height-infoTable.frame.size.height-70)];
    }
    // Do any additional setup after loading the view.
}

-(void)rightBarButtonAction{
    [self performSegueWithIdentifier:@"broadcastMonth" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"studentCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    NSString *cellValue = [_tableArray objectAtIndex:indexPath.row];
    cell.textLabel.text = cellValue;
    cell.textLabel.textColor = [UIColor lightGrayColor];
    
    
    if (indexPath.row == 0) {
        [cell.contentView addSubview:self.classLabel];
    }
    else if (indexPath.row ==1){
        [cell.contentView addSubview:self.typeImage];
        [cell.contentView addSubview:self.typeLabel];

    }
    else if (indexPath.row ==2){
        [cell.contentView addSubview:self.dateLabel];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"broadcastMonth"]){
        MonthLogViewController *monthVC = (MonthLogViewController*)segue.destinationViewController;
        monthVC.previousSegue=segue.identifier;
        monthVC.currentMonth = self.month;
        monthVC.classNameInMonth = self.className;
        monthVC.teacherID = self.announcementObj[@"TeacherId"];
        monthVC.selectedStudentObjFromClassTable = _studentObj;
        monthVC.demoManagedObjectContext=self.demoManagedObjectContext;
    }
    
}


@end
