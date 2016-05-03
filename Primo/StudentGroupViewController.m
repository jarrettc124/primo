//
//  StudentGroupViewController.m
//  Primo
//
//  Created by Jarrett Chen on 6/25/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import "StudentGroupViewController.h"

@interface StudentGroupViewController ()

@property (nonatomic,strong) UITableView *studentGroupTable;
@property (nonatomic,strong) UILabel *connection;

@property (nonatomic,strong) NSMutableArray *groupTableArray;
@property (nonatomic,strong) NSDictionary *rowToPass;

@property (nonatomic,strong) NSString *userType;

@property (nonatomic) BOOL isEmpty;

@end

@implementation StudentGroupViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.userType = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserType"];
    _isEmpty = NO;
    
    UIImageView *backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"groupBackground"]];
    [backgroundView setUserInteractionEnabled:YES];
    [self.view addSubview:backgroundView];
    
    UIImageView *toolbarBackground = [[UIImageView alloc]init];
    [toolbarBackground setImage:[UIImage imageNamed:@"blackboardBar"]];
    toolbarBackground.userInteractionEnabled=YES;
    [toolbarBackground setAlpha:0.7];
    [self.view addSubview:toolbarBackground];
    
    UIImageView *groupImage = [[UIImageView alloc]init];
    [groupImage setImage:[UIImage imageNamed:@"groupImage"]];
    groupImage.userInteractionEnabled=YES;
    [toolbarBackground setAlpha:0.9];
    [self.view addSubview:groupImage];
    
    UILabel *directionLabel =[UILabel new];
    NSString *attributeString = nil;
    [directionLabel setNumberOfLines:0];
    if ([self.userType isEqualToString:@"Teacher"]) {
        [directionLabel setText:@"Group your students together for a project!\n\nYour students will see their groups in their own accounts"];
        attributeString =@"Group your students together for a project!";
    }
    else{
        [directionLabel setText:@"Did your teacher assign you in groups?\n\nCheck below to see what groups you're in"];
        attributeString =@"Did your teacher assign you in groups?";
    }

    [self.view addSubview:directionLabel];
    
    self.groupTableArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    self.studentGroupTable = [[UITableView alloc]init];
    self.studentGroupTable.cellLayoutMarginsFollowReadableWidth = NO;
    self.studentGroupTable.delegate = self;
    self.studentGroupTable.dataSource = self;
    self.studentGroupTable.allowsMultipleSelectionDuringEditing = NO;
    self.studentGroupTable.allowsSelection = YES;
    self.studentGroupTable.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.4];
    [self.view addSubview:self.studentGroupTable];
    
    if (IS_IPAD) {
        backgroundView.translatesAutoresizingMaskIntoConstraints=NO;
        toolbarBackground.translatesAutoresizingMaskIntoConstraints=NO;
        groupImage.translatesAutoresizingMaskIntoConstraints=NO;
        _studentGroupTable.translatesAutoresizingMaskIntoConstraints=NO;
        directionLabel.translatesAutoresizingMaskIntoConstraints=NO;
        
        [directionLabel setFont:[UIFont fontWithName:@"Eraser" size:24]];
        NSMutableAttributedString *titleAttribute = [[NSMutableAttributedString alloc]initWithString:directionLabel.text];
        [titleAttribute addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Eraser" size:30] range:NSMakeRange(0, [attributeString length])];
        [directionLabel setAttributedText:titleAttribute];
        

        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[toolbarBackground(64)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(toolbarBackground)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[toolbarBackground]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(toolbarBackground)]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[backgroundView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(backgroundView)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[backgroundView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(backgroundView)]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:groupImage attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
//        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:groupImage attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:-200]];
        
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_studentGroupTable]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_studentGroupTable)]];
        [directionLabel addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[directionLabel(400)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(directionLabel)]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-150-[groupImage(109)]-[directionLabel]-20-[_studentGroupTable]-0-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:NSDictionaryOfVariableBindings(directionLabel,groupImage,_studentGroupTable)]];
        
        
    }
    else if (IS_IPHONE){
        [directionLabel setFont:[UIFont fontWithName:@"Eraser" size:19]];

        [backgroundView setFrame:self.view.frame];
        [toolbarBackground setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width,64)];
        
        [groupImage setFrame:CGRectMake(self.view.center.x-45, 66, 90, 90)];
        
        [directionLabel setFrame:CGRectMake(20, groupImage.frame.origin.y+100, 280, 180)];
        
        [self.studentGroupTable setFrame:CGRectMake(self.view.frame.origin.x,directionLabel.frame.origin.y+directionLabel.frame.size.height, self.view.frame.size.width,self.view.frame.size.height-305-self.tabBarController.tabBar.frame.size.height)];
        
    }
    
    if ([self.userType isEqualToString:@"Teacher"]) {
        UIBarButtonItem *addGroup = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewGroup)];
        [self.navigationItem setTitle:@"Group"];
        [self.navigationItem setRightBarButtonItem:addGroup];
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self updateGroupTable];
    
}

-(void)emptyGroupViews{
    _isEmpty=YES;

    UIImageView *tutorialbackground = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"blackboardBorder"]];
    [tutorialbackground setTag:1000];
    [tutorialbackground setAlpha:0];
    [self.view addSubview:tutorialbackground];
    
    if(IS_IPHONE){
        [tutorialbackground setFrame:CGRectMake(10, 90, 300, 300)];
        if ([self.userType isEqualToString:@"Teacher"]) {
            BouncingPencil *pencilArrow = [[BouncingPencil alloc]initWithFrame:CGRectMake(220, 44, 60, 60)];
            [pencilArrow setTag:2000];
            [pencilArrow setUpPencilBounceFrame:pencilArrow.frame targetX:15 targetY:-9 rotation:5*M_PI_4];
            [self.view addSubview:pencilArrow];
        }

    }
    else if(IS_IPAD){
        tutorialbackground.translatesAutoresizingMaskIntoConstraints=NO;
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[tutorialbackground(350)]-100-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tutorialbackground)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-100-[tutorialbackground(250)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tutorialbackground)]];
        
        if ([self.userType isEqualToString:@"Teacher"]) {
            //Set bouncing pencil
            BouncingPencil *pencilArrow = [[BouncingPencil alloc]init];
            [pencilArrow setTag:2000];
            [self.view addSubview:pencilArrow];
            
            pencilArrow.translatesAutoresizingMaskIntoConstraints=NO;
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-45-[pencilArrow(60)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(pencilArrow)]];
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[pencilArrow(60)]-50-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(pencilArrow)]];
            [pencilArrow setUpPencilBounceForiPad:CGSizeMake(60, 60) targetX:15 targetY:-9 rotation:5*M_PI_4];
        }
    }
    
    CGAffineTransform transform = CGAffineTransformMakeScale(0.9, 0.9);
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        [tutorialbackground setAlpha:1];
        [tutorialbackground setTransform:transform];
        
    } completion:^(BOOL finished) {
        UILabel *tutorialLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, tutorialbackground.frame.size.width-40, tutorialbackground.frame.size.height-10)];
        [tutorialLabel setFont:[UIFont fontWithName:@"Eraser" size:18]];
        [tutorialLabel setTextColor:[UIColor whiteColor]];
        [tutorialLabel setNumberOfLines:0];
        if ([self.userType isEqualToString:@"Teacher"]) {
            [tutorialLabel setText:@"Do you need to group your students for a project?\nWe can do that for you!\n\nClick on the plus button on your top right corner."];
        }
        else{
            [tutorialLabel setText:@"You're teacher didn't put you in a group yet. \n\n Check again soon!"];
        }
        [tutorialbackground addSubview:tutorialLabel];
        
    }];
    
    
}


-(void)updateGroupTable{
    
    UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc]init];
    [loadingView setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:0.5]];
    [self.view addSubview:loadingView];
    UILabel *loadingLabel = [[UILabel alloc]init];
    [loadingLabel setText:@"Loading Table..."];
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
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[loadingView(30)]-0-[_studentGroupTable]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(loadingView,_studentGroupTable)]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:loadingLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:loadingView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[loadingLabel(30)]-0-[_studentGroupTable]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(loadingLabel,_studentGroupTable)]];
    }
    else if (IS_IPHONE){
        [loadingView setFrame:CGRectMake(self.view.frame.size.width/2-50,self.studentGroupTable.frame.origin.y-30, 30, 30)];
        [loadingLabel setFrame:CGRectMake(self.view.frame.size.width/2-20,self.studentGroupTable.frame.origin.y-30, 70, 30)];
    }
    
    NSString *teacherId = nil;
    NSString *className = nil;
    if ([self.userType isEqualToString:@"Teacher"]) {
        teacherId = self.classObject.teacherId;
        className = [self.classObject.nameOfClass lowercaseString];
        NSLog(@"t:%@ c:%@",teacherId,className);

    }
    else{
        teacherId = self.studentObject.teacher;
        className = [self.studentObject.nameOfclass lowercaseString];
        NSLog(@"t:%@ c:%@",teacherId,className);
    }
    
    
    QueryWebService *query = [[QueryWebService alloc]initWithTable:@"ClassObject"];
    [query selectColumnWhere:@"Teacher" equalTo:teacherId];
    [query selectColumnWhere:@"ClassName" equalTo:className];
    [query findAllObjectsInRowWithCompletion:^(NSError *error, NSArray *rows) {
        
        if(error) {
            
            if (self.connection ==nil) {
                
                [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    [loadingView setAlpha:0];
                    [loadingLabel setAlpha:0];
                } completion:^(BOOL finished) {
                    [loadingView stopAnimating];
                    [loadingView removeFromSuperview];
                    [loadingLabel removeFromSuperview];
                }];

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
    
            if ([rows count]==0) {
                [self emptyGroupViews];
                
            }
            else{
                
                if (_isEmpty) {
                    _isEmpty=NO;
                    UIImageView *blackboardBorder = (UIImageView*)[self.view viewWithTag:1000];
                    BouncingPencil *bouncePencil = (BouncingPencil*)[self.view viewWithTag:2000];
                    
                    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        [blackboardBorder setAlpha:0];
                        [blackboardBorder setTransform:CGAffineTransformMakeScale(10/9, 10/9)];
                    } completion:^(BOOL finished) {
                        [bouncePencil setTag:0];
                        [blackboardBorder setTag:0];
                        [bouncePencil removeFromSuperview];
                        [blackboardBorder removeFromSuperview];
                    }];
                }
                
                [self.groupTableArray removeAllObjects];
                [self.groupTableArray addObjectsFromArray:rows];
                [self.studentGroupTable reloadData];
            }
            
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                [loadingView setAlpha:0];
                [loadingLabel setAlpha:0];
            } completion:^(BOOL finished) {
                [loadingView stopAnimating];
                [loadingView removeFromSuperview];
                [loadingLabel removeFromSuperview];
            }];

        }
        
        
    }];
    
    
}



-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {

    return YES;

}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        DeleteWebService *deleteStore = [[DeleteWebService alloc]initWithTable:@"ClassObject"];
        [deleteStore selectRowToDeleteWhereColumn:@"ClassId" equalTo:[self.groupTableArray objectAtIndex:indexPath.row][@"ClassId"]];
        [deleteStore deleteRow];
        
        [self.groupTableArray removeObjectAtIndex:indexPath.row];
        
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView endUpdates];
        
        
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"studentCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"studentCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
    }
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    NSDictionary *eachRow = [self.groupTableArray objectAtIndex:indexPath.row];

    if (eachRow !=nil) {
        
        NSError *error;
        NSString *jsonStringArray = eachRow[@"Groups"];
        NSData *data = [jsonStringArray dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        
    
        [cell.textLabel setFont:[UIFont fontWithName:@"Eraser" size:20]];
        [cell.textLabel setTextColor:[UIColor whiteColor]];
        cell.textLabel.text = [jsonDictionary allKeys][0];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d Groups",[[jsonDictionary objectForKey:cell.textLabel.text] count]];
        [cell.detailTextLabel setTextColor:[UIColor whiteColor]];
        
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.groupTableArray count];
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.rowToPass = nil;
    self.rowToPass = [self.groupTableArray objectAtIndex:indexPath.row];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self performSegueWithIdentifier:@"groupMoreSegue" sender:self];
    
}

-(void)addNewGroup{
    
    if (_isEmpty) {
        UIImageView *blackboardBorder = (UIImageView*)[self.view viewWithTag:1000];
        BouncingPencil *bouncePencil = (BouncingPencil*)[self.view viewWithTag:2000];
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [blackboardBorder setAlpha:0];
            [blackboardBorder setTransform:CGAffineTransformMakeScale(10/9, 10/9)];
        } completion:^(BOOL finished) {
            [bouncePencil setTag:0];
            [blackboardBorder setTag:0];
            [bouncePencil removeFromSuperview];
            [blackboardBorder removeFromSuperview];
        }];
    }
    
    [self performSegueWithIdentifier:@"addNewGroupSegue" sender:self];
    
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"addNewGroupSegue"]) {
        AddGroupViewController *addGroupVC = (AddGroupViewController*)segue.destinationViewController;
        addGroupVC.managedObjectContext= _managedObjectContext;
        addGroupVC.classObject = self.classObject;
        addGroupVC.projectNamesForDuplicates = self.groupTableArray;
        addGroupVC.demoManagedObjectContext=self.demoManagedObjectContext;
    }
    else if ([segue.identifier isEqualToString:@"groupMoreSegue"]){
        GroupMoreViewController *groupMoreVC = (GroupMoreViewController*)segue.destinationViewController;
        groupMoreVC.managedObjectContext = self.managedObjectContext;
        groupMoreVC.rowToPass = self.rowToPass;
        groupMoreVC.studentObj = self.studentObject;
        groupMoreVC.demoManagedObjectContext=self.demoManagedObjectContext;
    }
}



@end
