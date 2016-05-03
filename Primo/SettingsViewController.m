//
//  SettingsViewController.m
//  TeacherApp
//
//  Created by Jarrett Chen on 3/3/14.
//  Copyright (c) 2014 Jarrett Chen. All rights reserved.
//

#import "SettingsViewController.h"
@interface SettingsViewController ()

@end

@implementation SettingsViewController

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

    self.navigationItem.title = @"Settings";
    
    _userType = [[NSUserDefaults standardUserDefaults]objectForKey:@"UserType"];
            _settingsArray = [[NSArray alloc]initWithObjects:@"Change Email",@"Change Password",@"Delete Current Class",@"Delete Account",nil];
    
    //Initialize the mananged object context because its not passed in student's view
    
    if (![_userType isEqualToString:@"Teacher"]) {
        _managedObjectContext = self.studentObj.managedObjectContext;
    }

    //set up uiview
    UIImageView *settingBackground = [[UIImageView alloc]init];
    [settingBackground setImage:[UIImage imageNamed:@"gearsImage"]];
    [self.view addSubview:settingBackground];
    
    
    //set up frames
    if (IS_IPAD) {
        settingBackground.contentMode =UIViewContentModeScaleAspectFill;

        _settingsTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _settingsTable.cellLayoutMarginsFollowReadableWidth = NO;
        [self.view addSubview:_settingsTable];
        
        //set Constraints
        settingBackground.translatesAutoresizingMaskIntoConstraints=NO;
        self.settingsTable.translatesAutoresizingMaskIntoConstraints=NO;
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[settingBackground(300)]-0-[_settingsTable]-56-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(settingBackground,_settingsTable)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[settingBackground]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(settingBackground)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_settingsTable]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_settingsTable)]];
        

    }
    else if (IS_IPHONE){
        [settingBackground setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, 240)];
        settingBackground.contentMode =UIViewContentModeScaleAspectFill;
        
        _settingsTable = [[UITableView alloc]initWithFrame:CGRectMake(0.0,settingBackground.frame.origin.y+settingBackground.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.tabBarController.tabBar.frame.size.height-settingBackground.frame.origin.y+settingBackground.frame.size.height) style:UITableViewStyleGrouped];
        _settingsTable.cellLayoutMarginsFollowReadableWidth = NO;
        [self.view addSubview:_settingsTable];
        
        if (self.view.frame.size.height<568) {
            NSLog(@"short");
            [settingBackground setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, 180)];
            [self.settingsTable setFrame:CGRectMake(self.settingsTable.frame.origin.x, self.settingsTable.frame.origin.y-60, self.settingsTable.frame.size.width, self.settingsTable.frame.size.height-60)];
            
        }
    }
    
    _settingsTable.delegate =self;
    _settingsTable.dataSource =self;
    _settingsTable.scrollEnabled =NO;
    
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
    return [_settingsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"studentCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    NSString *cellValue = [_settingsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = cellValue;
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //selectedCell is nill first
    NSString *selectedCell = nil;
    selectedCell = [_settingsArray objectAtIndex:indexPath.row];
    
    if ([selectedCell isEqualToString:@"Delete Account"]){
        self.selectedSection=selectedCell;
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Are you sure you want to delete your account?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete Account" otherButtonTitles:nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
        [actionSheet showInView:self.view];
        
    }
    else if ([selectedCell isEqualToString:@"Delete Current Class"]){
        self.selectedSection=selectedCell;
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Are you sure you want to delete your class?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete Class" otherButtonTitles:nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
        [actionSheet showInView:self.view];
    }
    else{
        self.selectedSection=selectedCell;
        [self performSegueWithIdentifier:@"settingsMoreSegue" sender:self];
    }
    
    [_settingsTable deselectRowAtIndexPath:indexPath animated:YES];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
        return @"Account Info";
}

/*

-(void)deleteMethodForStudent{
    if ([self.selectedSection isEqualToString:@"Delete Account"]) {
        //Loading
        
        self.tabBarController.tabBar.userInteractionEnabled=NO;
        
        UIView *loadingView = [[UIView alloc]initWithFrame:self.view.frame];
        loadingView.backgroundColor = [UIColor blackColor];
        loadingView.alpha=0.5;
        [self.view addSubview:loadingView];
        
        UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-25, (self.view.frame.size.height)/2, 50, 50)];
        [self.view addSubview:loading];
        [loading setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [loading hidesWhenStopped];
        [loading startAnimating];
        
        NSString *objId = [[NSUserDefaults standardUserDefaults] objectForKey:@"ObjectId"];
        //Delete Account
        UpdateWebService *updateStudent = [[UpdateWebService alloc]initWithTable:@"StudentObject"];
        [updateStudent setRowToUpdateWhereColumn:@"taken" equalTo:@""];
        [updateStudent setRowToUpdateWhereColumn:@"signedIn" equalTo:@"0"];
        [updateStudent selectRowToUpdateWhereColumn:@"taken" equalTo:objId];
        [updateStudent saveUpdateInBackgroundWithBlock:^(NSError *error) {
            if(error){
                self.tabBarController.tabBar.userInteractionEnabled=YES;
                [loading stopAnimating];
                [loading removeFromSuperview];
                [loadingView removeFromSuperview];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete failed." message:@"You must have a network connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            else{
                DeleteWebService *deleteBroadcastBadge = [[DeleteWebService alloc]initWithTable:@"BroadcastBadge"];
                [deleteBroadcastBadge selectRowToDeleteWhereColumn:@"id" equalTo:[[NSUserDefaults standardUserDefaults] objectForKey:@"UserId"]];
                [deleteBroadcastBadge deleteRowInBackgroundWithBlock:^(NSError *error) {
                    
                    if (error) {
                        
                        self.tabBarController.tabBar.userInteractionEnabled=YES;
                        [loading stopAnimating];
                        [loading removeFromSuperview];
                        [loadingView removeFromSuperview];
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed." message:@"You must have a network connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alert show];
                    }
                    else{
                    
                        DeleteWebService *deletePushNotification  = [[DeleteWebService alloc]initWithTable:@"PushNotifications"];
                        [deletePushNotification selectRowToDeleteWhereColumn:@"UserId" equalTo:[[NSUserDefaults standardUserDefaults] objectForKey:@"UserId"]];
                        [deletePushNotification deleteRowInBackgroundWithBlock:^(NSError *error) {
                            DeleteWebService *deleteUser = [[DeleteWebService alloc]initWithTable:@"User"];
                            [deleteUser selectRowToDeleteWhereColumn:@"UserId" equalTo:[[NSUserDefaults standardUserDefaults] objectForKey:@"UserId"]];
                            [deleteUser deleteRowInBackgroundWithBlock:^(NSError *error) {
                                
                                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                                [userDefault removeObjectForKey:@"UserType"];
                                [userDefault removeObjectForKey:@"Email"];
                                [userDefault removeObjectForKey:@"UserId"];
                                [userDefault removeObjectForKey:@"FirstName"];
                                [userDefault removeObjectForKey:@"LastName"];
                                [userDefault removeObjectForKey:@"Gender"];
                                [userDefault synchronize];
                                
                                NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"StudentObject"];
                                request.predicate=[NSPredicate predicateWithFormat:@"taken = %@",objId];
                                NSArray *studentObjArrayInCore = [_managedObjectContext executeFetchRequest:request error:&error];
                                for (StudentObject* studentObj in studentObjArrayInCore) {
                                    
                                    LogWebService *logService = [[LogWebService alloc]initWithLogType:@"class_logs"];
                                    [logService updateLogWithUserId:self.studentObj.objectId className:self.studentObj.nameOfclass updateLogString:[NSString stringWithFormat:@"%@ has deleted the account",self.studentObj.studentName]];
                                    
                                    NSError*error;
                                    NSFetchRequest *teacherRequest = [NSFetchRequest fetchRequestWithEntityName:@"TeacherObject"];
                                    teacherRequest.predicate=[NSPredicate predicateWithFormat:@"teacherId = %@",studentObj.teacher];
                                    NSArray *teacherObjArray = [_managedObjectContext executeFetchRequest:teacherRequest error:&error];
                                    if ([teacherObjArray count]==1) {
                                        TeacherObject *teacherObj = [teacherObjArray firstObject];
                                        [_managedObjectContext deleteObject:teacherObj];
                                    }
                                    
                                    [_managedObjectContext deleteObject:studentObj];
                                    
                                }
                                [_managedObjectContext save:nil];
                                
                                [[PFUser currentUser] deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                    [self performSegueWithIdentifier:@"deleteUserSegue" sender:self];
                                }];
     
                                
                            }];
                        }];
                    }
                }];
            }
        }];
        
    }
    else if ([self.selectedSection isEqualToString:@"Delete Current Class"]){
        self.tabBarController.tabBar.userInteractionEnabled=NO;
        UIView *loadingView = [[UIView alloc]initWithFrame:self.view.frame];
        loadingView.backgroundColor = [UIColor blackColor];
        loadingView.alpha=0.5;
        [self.view addSubview:loadingView];
        
        UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-25, (self.view.frame.size.height)/2, 50, 50)];
        [self.view addSubview:loading];
        [loading setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [loading hidesWhenStopped];
        [loading startAnimating];
        
        //Delete taken for the object
        UpdateWebService *updateStudent = [[UpdateWebService alloc]initWithTable:@"StudentObject"];
        [updateStudent setRowToUpdateWhereColumn:@"taken" equalTo:@""];
        [updateStudent setRowToUpdateWhereColumn:@"signedIn" equalTo:@"0"];
        [updateStudent selectRowToUpdateWhereColumn:@"className" equalTo:self.studentObj.nameOfclass];
        [updateStudent selectRowToUpdateWhereColumn:@"teacher" equalTo:self.studentObj.teacher];
        [updateStudent selectRowToUpdateWhereColumn:@"taken" equalTo:objId];
        [updateStudent saveUpdateInBackgroundWithBlock:^(NSError *error) {
            if (error) {
                self.tabBarController.tabBar.userInteractionEnabled=YES;
                [loading stopAnimating];
                [loading removeFromSuperview];
                [loadingView removeFromSuperview];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete failed." message:@"You must have a network connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            else{
                DeleteWebService *deleteBroadcastBadge = [[DeleteWebService alloc]initWithTable:@"BroadcastBadge"];
                [deleteBroadcastBadge selectRowToDeleteWhereColumn:@"id" equalTo:[[NSUserDefaults standardUserDefaults] objectForKey:@"UserId"]];
                [deleteBroadcastBadge deleteRowInBackgroundWithBlock:^(NSError *error) {
                    
                    if (error) {
                        
                        self.tabBarController.tabBar.userInteractionEnabled=YES;
                        [loading stopAnimating];
                        [loading removeFromSuperview];
                        [loadingView removeFromSuperview];
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed." message:@"You must have a network connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alert show];
                    }
                    else{
                        
                        DeleteWebService *deletePushNotification  = [[DeleteWebService alloc]initWithTable:@"PushNotifications"];
                        [deletePushNotification selectRowToDeleteWhereColumn:@"UserId" equalTo:[[NSUserDefaults standardUserDefaults] objectForKey:@"UserId"]];
                        [deletePushNotification deleteRowInBackgroundWithBlock:^(NSError *error) {
                            DeleteWebService *deleteUser = [[DeleteWebService alloc]initWithTable:@"User"];
                            [deleteUser selectRowToDeleteWhereColumn:@"UserId" equalTo:[[NSUserDefaults standardUserDefaults] objectForKey:@"UserId"]];
                            [deleteUser deleteRowInBackgroundWithBlock:^(NSError *error) {
                
                
                                LogWebService *logService = [[LogWebService alloc]initWithLogType:@"class_logs"];
                                [logService updateLogWithUserId:self.studentObj.objectId className:self.studentObj.nameOfclass updateLogString:[NSString stringWithFormat:@"%@ has deleted the account",self.studentObj.studentName]];
                                
                                [_managedObjectContext deleteObject:self.studentObj];
                                [_managedObjectContext deleteObject:self.teacherObj];
                                
                                [_managedObjectContext save:nil];
                                [self performSegueWithIdentifier:@"deleteUserSegue" sender:self];
                            }];
                        }];
                    }
                }];
            }
        }];
        
    }
    
}

-(void)deleteMethodForTeacher{
    
    if ([self.selectedSection isEqualToString:@"Delete Account"]) {
        self.tabBarController.tabBar.userInteractionEnabled=NO;
        UIView *loadingView = [[UIView alloc]initWithFrame:self.view.frame];
        loadingView.backgroundColor = [UIColor blackColor];
        loadingView.alpha=0.5;
        [self.view addSubview:loadingView];
        
        UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-25, (self.view.frame.size.height)/2, 50, 50)];
        [self.view addSubview:loading];
        [loading setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [loading hidesWhenStopped];
        [loading startAnimating];
        
        //Delete from Database
        DeleteWebService *deleteStudents = [[DeleteWebService alloc]initWithTable:@"StudentObject"];
        [deleteStudents selectRowToDeleteWhereColumn:@"teacher" equalTo:objId];
        [deleteStudents deleteRowInBackgroundWithBlock:^(NSError *error) {
            
            if (!error) {
                DeleteWebService *deleteTeacher = [[DeleteWebService alloc]initWithTable:@"TeacherObject"];
                [deleteTeacher selectRowToDeleteWhereColumn:@"teacherId" equalTo:objId];
                [deleteTeacher deleteRowInBackgroundWithBlock:^(NSError *error) {
                    DeleteWebService *deleteStore = [[DeleteWebService alloc]initWithTable:@"Store"];
                    [deleteStore selectRowToDeleteWhereColumn:@"Teacher" equalTo:objId];
                    [deleteStore deleteRowInBackgroundWithBlock:^(NSError *error) {
                        DeleteWebService *deletePush = [[DeleteWebService alloc]initWithTable:@"PushNotifications"];
                        [deletePush selectRowToDeleteWhereColumn:@"UserId" equalTo:objId];
                        [deletePush deleteRowInBackgroundWithBlock:^(NSError *error) {
                            DeleteWebService *deleteBadge = [[DeleteWebService alloc]initWithTable:@"BroadcastBadge"];
                            [deleteBadge selectRowToDeleteWhereColumn:@"id" equalTo:objId];
                            [deleteBadge deleteRowInBackgroundWithBlock:^(NSError *error) {
                                DeleteWebService *deleteBroadcast = [[DeleteWebService alloc]initWithTable:@"Broadcast"];
                                [deleteBroadcast selectRowToDeleteWhereColumn:@"TeacherId" equalTo:objId];
                                [deleteBroadcast deleteRowInBackgroundWithBlock:^(NSError *error) {
                                    DeleteWebService *deleteUser = [[DeleteWebService alloc]initWithTable:@"User"];
                                    [deleteUser selectRowToDeleteWhereColumn:@"UserId" equalTo:[[NSUserDefaults standardUserDefaults] objectForKey:@"UserId"]];
                                    [deleteUser deleteRowInBackgroundWithBlock:^(NSError *error) {
                                        DeleteWebService *deleteClassGroup = [[DeleteWebService alloc]initWithTable:@"ClassObject"];
                                        [deleteClassGroup selectRowToDeleteWhereColumn:@"Teacher" equalTo:[[NSUserDefaults standardUserDefaults] objectForKey:@"UserId"]];
                                        [deleteClassGroup deleteRowInBackgroundWithBlock:^(NSError *error) {
                                            
                                            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                                            [userDefault removeObjectForKey:@"UserType"];
                                            [userDefault removeObjectForKey:@"Email"];
                                            [userDefault removeObjectForKey:@"UserId"];
                                            [userDefault removeObjectForKey:@"FirstName"];
                                            [userDefault removeObjectForKey:@"LastName"];
                                            [userDefault removeObjectForKey:@"Gender"];
                                            [userDefault synchronize];
                                            
                                            //Delete from DataCore
                                            //Delete Log Service
                                            
                                            //Array of logs to delete
                                            NSMutableArray *logObjectId = [[NSMutableArray alloc]initWithCapacity:0];
                                            
                                            LogWebService *classLog = [[LogWebService alloc]initWithLogType:@"class_logs"];
                                            LogWebService *announcementLog = [[LogWebService alloc]initWithLogType:@"announcement"];
                                            
                                            NSFetchRequest *studentRequest = [NSFetchRequest fetchRequestWithEntityName:@"StudentObject"];
                                            studentRequest.predicate=[NSPredicate predicateWithFormat:@"teacher = %@",objId];
                                            NSArray *studentObjArray = [_managedObjectContext executeFetchRequest:studentRequest error:&error];
                                            for (StudentObject *studentObj in studentObjArray){
                                                NSLog(@" start delete for %@",studentObj.objectId);
                                                
                                                [logObjectId addObject:studentObj.objectId];
                                                
    //                                            [classLog deleteLogsWithId:studentObj.objectId];
    //                                            [announcementLog deleteLogsWithId:studentObj.objectId];
                                                [_managedObjectContext deleteObject:studentObj];
                                            }
                                            
                                            //delete economy
                                            DeleteWebService *deleteEconomy =[[DeleteWebService alloc]initWithTable:@"Economy"];
                                            [deleteEconomy selectRowToDeleteWhere:@"ObjectId" containsArray:logObjectId];
                                            [deleteEconomy deleteRow];
                                            
                                            NSFetchRequest *classRequest = [NSFetchRequest fetchRequestWithEntityName:@"ClassObject"];
                                            classRequest.predicate=[NSPredicate predicateWithFormat:@"teacherId = %@",objId];
                                            NSArray *classObjArray = [_managedObjectContext executeFetchRequest:classRequest error:&error];
                                            for (ClassObject* classObj in classObjArray) {
                                                [_managedObjectContext deleteObject:classObj];
                                            }
                                            
                                            NSFetchRequest *teacherRequest = [NSFetchRequest fetchRequestWithEntityName:@"TeacherObject"];
                                            teacherRequest.predicate=[NSPredicate predicateWithFormat:@"teacherId = %@",objId];
                                            NSArray *teacherObjArray = [_managedObjectContext executeFetchRequest:teacherRequest error:&error];
                                            TeacherObject *teacherObj = [teacherObjArray firstObject];
                                            [_managedObjectContext deleteObject:teacherObj];
                                            
                                            [logObjectId addObject:objId];
                                            
                                            [classLog deleteLogsWithId:logObjectId];
                                            [announcementLog deleteLogsWithId:logObjectId];
                                            
                                            [[PFUser currentUser] deleteInBackground];
                                            [_managedObjectContext save:nil];
                                            
                                            [self performSegueWithIdentifier:@"deleteUserSegue" sender:self];
                                        }];
                                    }];
                                }];
                            }];
                        }];
                    }];
                }];
            }
            else{
                self.tabBarController.tabBar.userInteractionEnabled=YES;
                [loading stopAnimating];
                [loading removeFromSuperview];
                [loadingView removeFromSuperview];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete failed." message:@"You must have a network connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }];
    }
    else if ([self.selectedSection isEqualToString:@"Delete Current Class"]){
        
        self.tabBarController.tabBar.userInteractionEnabled=NO;
        UIView *loadingView = [[UIView alloc]initWithFrame:self.view.frame];
        loadingView.backgroundColor = [UIColor blackColor];
        loadingView.alpha=0.5;
        [self.view addSubview:loadingView];
        
        UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-25, (self.view.frame.size.height)/2, 50, 50)];
        [self.view addSubview:loading];
        [loading setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [loading hidesWhenStopped];
        [loading startAnimating];
        

        DeleteWebService *deleteStudents = [[DeleteWebService alloc]initWithTable:@"StudentObject"];
        [deleteStudents selectRowToDeleteWhereColumn:@"teacher" equalTo:objId];
        [deleteStudents selectRowToDeleteWhereColumn:@"className" equalTo:[self.className lowercaseString]];
        [deleteStudents deleteRowInBackgroundWithBlock:^(NSError *error) {
            if (!error) {
                
                DeleteWebService *deleteBroadcast = [[DeleteWebService alloc]initWithTable:@"Broadcast"];
                [deleteBroadcast selectRowToDeleteWhereColumn:@"TeacherId" equalTo:objId];
                [deleteBroadcast selectRowToDeleteWhereColumn:@"Recipient" equalTo:self.className];
                [deleteBroadcast deleteRowInBackgroundWithBlock:^(NSError *error) {
                    DeleteWebService *deleteBadge = [[DeleteWebService alloc]initWithTable:@"BroadcastBadge"];
                    [deleteBadge selectRowToDeleteWhereColumn:@"id" equalTo:objId];
                    [deleteBadge selectRowToDeleteWhereColumn:@"ClassName" equalTo:self.className];
                    [deleteBadge deleteRowInBackgroundWithBlock:^(NSError *error) {
                        DeleteWebService *deleteClassGroup = [[DeleteWebService alloc]initWithTable:@"ClassObject"];
                        [deleteClassGroup selectRowToDeleteWhereColumn:@"ClassName" equalTo:[self.className lowercaseString]];
                        [deleteClassGroup deleteRowInBackgroundWithBlock:^(NSError *error) {
                            
                            //delete the logs
                            LogWebService *classLog = [[LogWebService alloc]initWithLogType:@"class_logs"];
                            LogWebService *announcementLog = [[LogWebService alloc]initWithLogType:@"announcement"];
                            
                            NSFetchRequest *studentRequest = [NSFetchRequest fetchRequestWithEntityName:@"StudentObject"];
                            studentRequest.predicate=[NSPredicate predicateWithFormat:@"(teacher = %@) AND (nameOfclass = %@)",objId,[self.className lowercaseString]];
                            NSArray *studentObjArray = [_managedObjectContext executeFetchRequest:studentRequest error:&error];
                            
                            NSMutableArray *deleteBadgeIdArray = [[NSMutableArray alloc]initWithCapacity:0];
                            if([studentObjArray count]){
                                
                                NSMutableArray *objectIdLog = [[NSMutableArray alloc]initWithCapacity:0];
                                
                                for (StudentObject *studentObj in studentObjArray){
                                    
                                    [objectIdLog addObject:studentObj.objectId];
                                    
                                    
                                    if (![studentObj.taken isEqualToString:@""]) {
                                        [deleteBadgeIdArray addObject:studentObj.taken];
                                    }
                                    
                                    [_managedObjectContext deleteObject:studentObj];
                                }
                                
                                //delete economy
                                DeleteWebService *deleteEconomy =[[DeleteWebService alloc]initWithTable:@"Economy"];
                                [deleteEconomy selectRowToDeleteWhere:@"ObjectId" containsArray:objectIdLog];
                                [deleteEconomy deleteRow];
                                
                                [classLog deleteLogsWithId:objectIdLog];
                                [announcementLog deleteLogsWithId:objectIdLog];
                            }
                            if ([deleteBadgeIdArray count]) {
                                DeleteWebService *deleteStudentBadge = [[DeleteWebService alloc]initWithTable:@"BroadcastBadge"];
                                [deleteStudentBadge selectRowToDeleteWhereColumn:@"ClassName" equalTo:self.className];
                                [deleteStudentBadge selectRowToDeleteWhere:@"id" containsArray:deleteBadgeIdArray];
                                [deleteStudentBadge deleteRow];
                            }
                            
                            
                            //Remove the class from Core
                            ClassObject *classObj = [ClassObject findClassObjectInCoreWithTeacherId:objId className:self.className inManagedObjectContext:_managedObjectContext];
                            [_managedObjectContext deleteObject:classObj];
                            
                            
                            //Find classlist from core
                            NSFetchRequest *teacherRequest = [NSFetchRequest fetchRequestWithEntityName:@"TeacherObject"];
                            teacherRequest.predicate=[NSPredicate predicateWithFormat:@"teacherId = %@",objId];
                            NSArray *teacherObjArray = [_managedObjectContext executeFetchRequest:teacherRequest error:&error];
                            TeacherObject *teacherObj = [teacherObjArray firstObject];
                            NSData *data = [teacherObj.classList dataUsingEncoding:NSUTF8StringEncoding];
                            NSMutableArray *classListArray = [[NSMutableArray alloc]initWithArray:[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error]];
                            
                            //Remove class element from list
                            [classListArray removeObject:self.className];
                            
                            NSData *jsonDataArray = [NSJSONSerialization dataWithJSONObject:classListArray options:0 error:&error];
                            NSString *JSONStringArray = [[NSString alloc] initWithData:jsonDataArray encoding:NSUTF8StringEncoding];

                            UpdateWebService *updateService = [[UpdateWebService alloc]initWithTable:@"TeacherObject"];
                            [updateService setRowToUpdateWhereColumn:@"ClassList" equalTo:JSONStringArray];
                            [updateService selectRowToUpdateWhereColumn:@"teacherId" equalTo:objId];
                            [updateService saveUpdateInBackgroundWithBlock:^(NSError *error) {
                                
                                
                                [self performSegueWithIdentifier:@"deleteUserSegue" sender:self];
                            }];
                        }];
                    }];
                    
                    
                }];
            }
            else{
                self.tabBarController.tabBar.userInteractionEnabled=YES;
                [loading stopAnimating];
                [loading removeFromSuperview];
                [loadingView removeFromSuperview];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete failed." message:@"You must have a network connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }];
    }
}
*/

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"settingsMoreSegue"]) {
        
        SettingsMoreViewController *settingsMoreVC = (SettingsMoreViewController*)segue.destinationViewController;
        settingsMoreVC.selectedSection=_selectedSection;
        settingsMoreVC.managedObjectContext=_managedObjectContext;
        settingsMoreVC.demoManagedObjectContext=self.demoManagedObjectContext;
    }
    else if ([segue.identifier isEqualToString:@"deleteUserSegue"]) {
        UINavigationController *navigationController = (UINavigationController *)segue.destinationViewController;
        LaunchViewController *controller = [navigationController.viewControllers objectAtIndex:0];
        controller.managedObjectContext = self.managedObjectContext;
        controller.demoManagedObjectContext=self.demoManagedObjectContext;
    }
    
    
}


@end
