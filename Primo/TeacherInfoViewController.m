//
//
//  TeacherInfoViewController.m
//  TeacherApp
//
//  Created by Jarrett Chen on 4/2/14.
//  Copyright (c) 2014 Jarrett Chen. All rights reserved.
//

#import "TeacherInfoViewController.h"

@interface TeacherInfoViewController ()

//table arrays
@property (nonatomic,strong) NSArray *tableArray;
@property (nonatomic,strong) NSArray *tableInfo;

@end

@implementation TeacherInfoViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //background image
    
    UIImageView *backgroundView = [[UIImageView alloc] init];
    [backgroundView setImage:[UIImage imageNamed:@"blackboardBackground"]];
    backgroundView.userInteractionEnabled=YES;
    [self.view addSubview:backgroundView];
    
    
    UILabel *teacherName = [[UILabel alloc]initWithFrame:CGRectMake(50,40, self.view.frame.size.width-55, 30)];
    teacherName.textColor = [UIColor whiteColor];
    teacherName.text = self.teacherObj.teacherName;
    
    UILabel *totalClasses = [[UILabel alloc]initWithFrame:CGRectMake(50, 40, self.view.frame.size.width-55, 30)];
    totalClasses.textColor =[UIColor whiteColor];
    NSError *error;
    NSData *data = [_teacherObj.classList dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    totalClasses.text = [jsonArray componentsJoinedByString:@", "];
    
    UILabel *totalStudents = [[UILabel alloc]initWithFrame:CGRectMake(50,40, self.view.frame.size.width-55, 30)];
    totalStudents.textColor = [UIColor whiteColor];
    
    
    UILabel *emailButton = [UILabel new];
    [emailButton setTextColor:[UIColor whiteColor]];
    [emailButton setText:@"Click here to Email your teacher!"];
    emailButton.frame= CGRectMake(20,35, 280, 60);
    
    self.tableArray = @[@"Teacher:",@"Classes:",@"Total Students",@"Email Teacher:"];
    
    self.tableInfo = @[teacherName,totalClasses,totalStudents,emailButton];
    
    UITableView *infoTable = [[UITableView alloc]init];
    infoTable.cellLayoutMarginsFollowReadableWidth = NO;
    infoTable.backgroundColor = [UIColor clearColor];
    infoTable.delegate=self;
    infoTable.dataSource=self;
    [self.view addSubview:infoTable];
    
    if (IS_IPAD) {
        backgroundView.translatesAutoresizingMaskIntoConstraints=NO;
        infoTable.translatesAutoresizingMaskIntoConstraints=NO;
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[backgroundView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(backgroundView)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[backgroundView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(backgroundView)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-64-[infoTable]-56-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(infoTable)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[infoTable]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(infoTable)]];
        
    }
    else if (IS_IPHONE){
        [backgroundView setFrame:self.view.frame];
        [infoTable setFrame:CGRectMake(self.view.frame.origin.x,105, self.view.frame.size.width,self.view.frame.size.height-self.tabBarController.tabBar.frame.size.height-140)];
    }
    
    QueryWebService *totalStudentsQuery = [[QueryWebService alloc]initWithTable:@"StudentObject"];
    [totalStudentsQuery selectColumnWhere:@"teacher" equalTo:self.studentObj.teacher];
    [totalStudentsQuery findAllObjectsInRowWithCompletion:^(NSError *error, NSArray *rows) {
        if (!error) {
            totalStudents.text = [NSString stringWithFormat:@"%d Students",[rows count]];
            [infoTable reloadData];
        }
    }];
    
}

//table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3) {
        
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        [mc setToRecipients:@[self.studentObj.teacherEmail]];
        // Present mail view controller on screen
        [self presentViewController:mc animated:YES completion:NULL];
    }

}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 3) {
        return YES;
    }
    else{
        return NO;
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.tableArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"studentCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        UILabel* titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(7, 3, 245,35)];
        [titleLabel setFont:[UIFont fontWithName:@"Eraser" size:22]];
        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setTag:1];
        [cell.contentView addSubview:titleLabel];
        
        [cell.contentView addSubview:[self.tableInfo objectAtIndex:indexPath.row]];
        
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.backgroundColor = [UIColor clearColor];


    [(UILabel *)[cell.contentView viewWithTag:1] setText:[_tableArray objectAtIndex:indexPath.row]]; //add text


    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat result;
    result = 90;
    return result;
}
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}


/*
#pragma mark - Navigation
 
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
 {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization
 }
 return self;
 
 }
 
 - (void)didReceiveMemoryWarning
 {
 [super didReceiveMemoryWarning];
 // Dispose of any resources that can be recreated.
 }
 
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
