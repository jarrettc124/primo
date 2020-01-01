//
//  GroupMoreViewController.m
//  Primo
//
//  Created by Jarrett Chen on 8/19/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import "GroupMoreViewController.h"

@interface GroupMoreViewController ()

@property (nonatomic, strong) UITableView *studentGroupTable;
@property (nonatomic,strong) NSMutableArray *studentsGroupArray;
@property (nonatomic,strong) NSString *groupProjectName;

@property (nonatomic,strong) NSString *userType;

//for students view
//@property (nonatomic,strong) NSNumber *studentObjectId;

@end

@implementation GroupMoreViewController

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
    
    self.userType = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserType"];
    
//    if (![self.userType isEqualToString:@"Teacher"]) {
//        
//        NSError *error;
//        NSFetchRequest *studentsRequest = [NSFetchRequest fetchRequestWithEntityName:@"StudentObject"];
//        studentsRequest.predicate= [NSPredicate predicateWithFormat:@"taken = %@ AND nameOfclass",objId,[self.studentObj.nameOfclass lowercaseString]];
//        NSArray *studentObjArray = [_managedObjectContext executeFetchRequest:studentsRequest error:&error];
//        StudentObject *studentObj =[studentObjArray firstObject];
//        
//        self.studentObjectId = studentObj.studentNumber;
//        NSLog(@"studentNumber = %@",self.studentObjectId);
//    }
    
    NSError *error;
    NSString *jsonStringArray = self.rowToPass[@"Groups"];
    NSData *data = [jsonStringArray dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
    self.groupProjectName =[jsonDictionary allKeys][0];
    
    self.studentsGroupArray = [[NSMutableArray alloc]initWithArray:[jsonDictionary objectForKey:self.groupProjectName] copyItems:YES];

    
    if(IS_IPAD){
        self.studentGroupTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        self.studentGroupTable.cellLayoutMarginsFollowReadableWidth = NO;

        [self.view addSubview:self.studentGroupTable];

        toolbarBackground.translatesAutoresizingMaskIntoConstraints=NO;
        self.studentGroupTable.translatesAutoresizingMaskIntoConstraints=NO;
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[toolbarBackground(64)]-[_studentGroupTable]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(toolbarBackground,_studentGroupTable)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[toolbarBackground]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(toolbarBackground)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_studentGroupTable]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_studentGroupTable)]];
        
    }
    else{
        [toolbarBackground setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width,64)];
        self.studentGroupTable = [[UITableView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, 64, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStyleGrouped];
        self.studentGroupTable.cellLayoutMarginsFollowReadableWidth = NO;
        [self.view addSubview:self.studentGroupTable];
    }

    if ([self.userType isEqualToString:@"Teacher"]) {
        
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editGroup)];
        [self.navigationItem setRightBarButtonItem:rightBarButton];
    }
    self.studentGroupTable.dataSource = self;
    self.studentGroupTable.delegate = self;
    self.studentGroupTable.allowsMultipleSelectionDuringEditing = NO;
    self.studentGroupTable.allowsSelection = YES;
    
    [self.navigationItem setTitle:self.groupProjectName];
}

-(void)editGroup{
    
    [self.studentGroupTable setEditing:YES animated:YES];
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveNewGroup)];
    [self.navigationItem setRightBarButtonItem:saveButton];
}


-(void)saveNewGroup{
    
    [self.studentGroupTable setEditing:NO animated:YES];
    
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editGroup)];
    [self.navigationItem setRightBarButtonItem:rightBarButton];
    
    [self saveToDatabase];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    NSString *studentIDToMove = [[self.studentsGroupArray objectAtIndex:sourceIndexPath.section] objectAtIndex:sourceIndexPath.row];
    NSMutableArray *sectionGroupSource = [[NSMutableArray alloc]initWithArray:[self.studentsGroupArray objectAtIndex:sourceIndexPath.section]];
    [sectionGroupSource removeObjectAtIndex:sourceIndexPath.row];
    
    //replace the sectionGroupSource
    [self.studentsGroupArray replaceObjectAtIndex:sourceIndexPath.section withObject:sectionGroupSource];
    
    
    NSMutableArray *sectionGroupDestination = [[NSMutableArray alloc]initWithArray:[self.studentsGroupArray objectAtIndex:destinationIndexPath.section]];
    [sectionGroupDestination insertObject:studentIDToMove atIndex:destinationIndexPath.row];
    
    [self.studentsGroupArray replaceObjectAtIndex:destinationIndexPath.section withObject:sectionGroupDestination];

    
    [self tableView:self.studentGroupTable titleForHeaderInSection:destinationIndexPath.section];
    
    [self.studentGroupTable reloadData];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"studentCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"studentCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    

    
    if ([self.userType isEqualToString:@"Teacher"]) {
        NSString *studentId = [[self.studentsGroupArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];

        NSError* error;
        NSFetchRequest *studentsRequest = [NSFetchRequest fetchRequestWithEntityName:@"StudentObject"];
        studentsRequest.predicate= [NSPredicate predicateWithFormat:@"(objectId = %@)",studentId];
        NSArray *studentArrays = [_managedObjectContext executeFetchRequest:studentsRequest error:&error];
        
        //if a student is deleted
        if ([studentArrays count] == 0) {
            
            NSMutableArray *sectionGroup = [[NSMutableArray alloc]initWithArray:[self.studentsGroupArray objectAtIndex:indexPath.section]];
            [sectionGroup removeObjectAtIndex:indexPath.row];
            [self.studentsGroupArray replaceObjectAtIndex:indexPath.section withObject:sectionGroup];
         
            [self saveToDatabase];
        }
        
        StudentObject *studentObj = [studentArrays firstObject];
        
        cell.textLabel.text = studentObj.studentName;
    }
    else{
        //students cell. Only one has to be shown so we are not using indexpath. instead we loop through the whole array. Since its only one time, we can afford to put this here.
        NSInteger groupNumber = 0;
        for (NSArray *group in self.studentsGroupArray) {
            groupNumber++;
            for (NSString *studentObjNum in group) {
                if ([studentObjNum isEqualToString:self.studentObj.objectId]) {
                    cell.textLabel.text = [NSString stringWithFormat:@"Group Number: %d",groupNumber];
                }
            }

        }

    }
    
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([self.userType isEqualToString:@"Teacher"]) {
        return [self.studentsGroupArray count];
    }
    else{
        return 1;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.userType isEqualToString:@"Teacher"]) {
        return [[self.studentsGroupArray objectAtIndex:section] count];
    }
    else{
        return 1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString *groupTitle;
    if ([self.userType isEqualToString:@"Teacher"]) {
        groupTitle = [NSString stringWithFormat:@"Group %d Size: %d",section+1,[[self.studentsGroupArray objectAtIndex:section] count]];
    }
    else{
        groupTitle = @"You're in Group:";
    }
    
    return groupTitle;
}


-(void)saveToDatabase{
    
    NSDictionary *groupDict = @{self.groupProjectName:self.studentsGroupArray};
    
    NSError *error;
    NSData *jsonDataArray = [NSJSONSerialization dataWithJSONObject:groupDict options:0 error:&error];
    NSString *JSONStringArray = [[NSString alloc] initWithData:jsonDataArray encoding:NSUTF8StringEncoding];
    
    UpdateWebService *updateGroup = [[UpdateWebService alloc]initWithTable:@"ClassObject"];
    [updateGroup setRowToUpdateWhereColumn:@"Groups" equalTo:JSONStringArray];
    [updateGroup selectRowToUpdateWhereColumn:@"ClassId" equalTo:self.rowToPass[@"ClassId"]];
    [updateGroup saveUpdate];
    
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
