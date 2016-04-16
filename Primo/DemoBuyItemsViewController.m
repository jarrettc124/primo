//
//  DemoBuyItemsViewController.m
//  Primo
//
//  Created by Jarrett Chen on 8/27/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import "DemoBuyItemsViewController.h"

@interface DemoBuyItemsViewController ()

@end

@implementation DemoBuyItemsViewController
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
    
    if (IS_IPAD) {
        toolbarBackground.translatesAutoresizingMaskIntoConstraints=NO;
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[toolbarBackground]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(toolbarBackground)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[toolbarBackground(64)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(toolbarBackground)]];
    }
    else if (IS_IPHONE){
        [toolbarBackground setFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    }
    [self makeTable];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    
}

-(void)buyAction{
    NSString *actionTitle = [NSString stringWithFormat:@"Are you sure you want to purchase: %@",self.storeObject.item];
    
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
    return [_studentsArray count];
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
    
    
    StudentObject* studentObj = [self.studentsArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = studentObj.studentName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Coins: %d",[studentObj.coins intValue]];
    
    if ([self.storeObject.cost intValue]>[studentObj.coins intValue]) {
        cell.userInteractionEnabled=NO;
        cell.textLabel.textColor = [UIColor grayColor];
        cell.detailTextLabel.textColor = [UIColor grayColor];
    }
    
    return cell;
    
}

-(void)makeTable{
    
    NSError *error;
    NSFetchRequest *studentsRequest = [NSFetchRequest fetchRequestWithEntityName:@"DemoStudentObject"];
    studentsRequest.predicate= [NSPredicate predicateWithFormat:@"(nameOfclass = %@) AND (taken = %@)",[self.className lowercaseString],@"Teacher"];
    NSArray *studentObjArray = [_demoManagedObjectContext executeFetchRequest:studentsRequest error:&error];
    self.studentsArray = [[NSMutableArray alloc]initWithArray:studentObjArray];

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
        [self.studentTable setFrame:CGRectMake(0.0, 64.0, 320.0, self.view.frame.size.height - self.tabBarController.tabBar.frame.size.height-67)];
    }
    
}

-(void)cancelButtonAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)buyItemsForStudentinParse:(NSArray*)indexesOfSelectedArrays{
    
    
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
        NSArray *selectedStudentArray = [self.studentsArray objectsAtIndexes:indicesOfItemsToAdd]; //array of names to be found
        
        
        for (DemoStudentObject *studentObj in selectedStudentArray) {
            
            [studentObj buyCoinsStudentObject:self.storeObject.cost inManagedObjectContext:_demoManagedObjectContext];
            
        }
        
        DemoTeacher *teacherProgress = [DemoTeacher findTeacherProgress:_demoManagedObjectContext];
        
        if (![teacherProgress.buyStoreDone boolValue]) {
            teacherProgress.buyStoreDone = [NSNumber numberWithBool:YES];
            [_demoManagedObjectContext save:nil];
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!!" message:[NSString stringWithFormat:@"You bought %@ for your selected students!",self.storeObject.item] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        if ((int)[teacherProgress getTotalProgress] == 1) {
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

        
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    else{

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uh oh, did you forget to select your students?" message:@"Please try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }
}


#pragma mark - Navigation


@end