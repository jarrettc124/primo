//
//  AddGroupViewController.m
//  Primo
//
//  Created by Jarrett Chen on 8/12/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import "AddGroupViewController.h"

@interface AddGroupViewController ()

@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UITableView *groupTable;
@property (nonatomic) int groupNumber;
@property (nonatomic,strong) UILabel *groupNumberLabel;
@property (nonatomic,strong) NSArray *pickerArray;
@property (nonatomic,strong) UIPickerView *pickerSort;
@property (nonatomic,strong) UITextField *sortTextfield;
@property (nonatomic,strong) NSString *sortString;
@property (nonatomic,strong) UIView *moveBackground;
@property (nonatomic,strong) NSMutableArray *studentObjArray;
@property (nonatomic,strong) UILabel *connection;

//Save properties
@property (nonatomic,strong) UIView *saveBackground;
@property (nonatomic,strong) UITextField *groupNameTextfield;

//loading label
@property (nonatomic,strong) UIView *loadingView;
@property (nonatomic,strong) UIActivityIndicatorView *loading;

@end

@implementation AddGroupViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *toolbarBackground = [[UIImageView alloc]init];
    [toolbarBackground setImage:[UIImage imageNamed:@"blackboardBar"]];
    toolbarBackground.userInteractionEnabled=YES;
    [self.view addSubview:toolbarBackground];
    
    UIView *bottomToolbarView = [[UIView alloc]init];
    bottomToolbarView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    [self.view addSubview:bottomToolbarView];
    
    self.groupNumberLabel = [[UILabel alloc]init];
    [self.groupNumberLabel setTextAlignment:NSTextAlignmentCenter];
    self.groupNumber = 5;
    if (IS_IPHONE) {
        self.groupNumberLabel.text = [NSString stringWithFormat:@"%d", self.groupNumber];
    }
    else if (IS_IPAD){
        self.groupNumberLabel.text = [NSString stringWithFormat:@"%d Per Group", self.groupNumber];
    }
    self.pickerArray = [[NSArray alloc]initWithObjects:@"Pick One",@"Random",@"First Name:Ascending",@"First Name:Descending",@"Last Name:Ascending",@"Last Name:Descending",@"Student Number:Ascending",@"Student Number:Descending",@"Coins:Ascending",@"Coins:Descending", nil];
    self.pickerSort = [[UIPickerView alloc]init];
    self.pickerSort.delegate=self;
    self.pickerSort.dataSource=self;
    self.pickerSort.userInteractionEnabled=YES;
    [self.pickerSort setBackgroundColor:[UIColor whiteColor]];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(pickerButtonActions)];
    
    NSArray *toolbarItems = [NSArray arrayWithObjects: doneButton, nil];
    
    UIToolbar *toolBar = [[UIToolbar alloc]init];
    [toolBar setFrame:CGRectMake(self.view.frame.origin.x,self.pickerSort.frame.origin.y-44,self.view.frame.size.width, 44)];
    [toolBar setBarStyle:UIBarStyleDefault];
    [toolBar setItems:toolbarItems];
    
    self.sortTextfield = [[UITextField alloc]init];
    [self.sortTextfield setTextAlignment:NSTextAlignmentCenter];
    [self.sortTextfield setText:@"Sort Students By:"];
    self.sortTextfield.inputView = self.pickerSort;
    self.sortTextfield.inputAccessoryView = toolBar;
    [self.sortTextfield setTextColor:[UIColor colorWithRed:0 green:0.478431 blue:1 alpha:1]];
    
    self.sortString = self.classObject.sortDescrip;
    
    UIButton *moveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [moveButton setTitle:@"Move" forState:UIControlStateNormal];
    [moveButton addTarget:self action:@selector(moveDirectionMethod) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *addButtonGroupButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [addButtonGroupButton setTag:100];
    [addButtonGroupButton setTitle:@"+" forState:UIControlStateNormal];
    addButtonGroupButton.titleLabel.font = [UIFont boldSystemFontOfSize:23];
    [addButtonGroupButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addButtonGroupButton.layer.cornerRadius = 3;
    [addButtonGroupButton setBackgroundColor: [UIColor greenColor]];
    [addButtonGroupButton addTarget:self action:@selector(groupSizeMethod:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *minusButtonGroupButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [minusButtonGroupButton setTag:200];
    [minusButtonGroupButton setTitle:@"-" forState:UIControlStateNormal];
    minusButtonGroupButton.titleLabel.font = [UIFont boldSystemFontOfSize:23];
    [minusButtonGroupButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [minusButtonGroupButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    minusButtonGroupButton.layer.cornerRadius = 3;
    [minusButtonGroupButton setBackgroundColor: [UIColor redColor]];
    [minusButtonGroupButton addTarget:self action:@selector(groupSizeMethod:) forControlEvents:UIControlEventTouchUpInside];
    
    self.dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.studentObjArray = [[NSMutableArray alloc]initWithCapacity:0];
    _groupTable = [[UITableView alloc]initWithFrame:CGRectMake(0.0, 64, 320.0, self.view.frame.size.height - self.tabBarController.tabBar.frame.size.height-64-84) style:UITableViewStyleGrouped];
    self.groupTable.cellLayoutMarginsFollowReadableWidth = NO;

    _groupTable.delegate =self;
    _groupTable.dataSource =self;
    [self.view addSubview:_groupTable];
    
    [bottomToolbarView addSubview:self.groupNumberLabel];
    [bottomToolbarView addSubview:addButtonGroupButton];
    [bottomToolbarView addSubview:minusButtonGroupButton];
    [bottomToolbarView addSubview:self.sortTextfield];
    [bottomToolbarView addSubview:moveButton];
    
    if (IS_IPHONE) {
        [toolbarBackground setFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
        [bottomToolbarView setFrame:CGRectMake(0,self.view.frame.size.height-self.tabBarController.tabBar.frame.size.height-84, self.view.frame.size.width,84)];

        self.sortTextfield.frame = CGRectMake(0, 0,bottomToolbarView.frame.size.width, 30);
        
        
        minusButtonGroupButton.frame = CGRectMake(40, self.sortTextfield.frame.size.height+5, 40, 30);
        
        self.groupNumberLabel.frame = CGRectMake(minusButtonGroupButton.frame.origin.x+minusButtonGroupButton.frame.size.width+2, self.sortTextfield.frame.size.height+5, 40, 30);
        
        addButtonGroupButton.frame = CGRectMake(self.groupNumberLabel.frame.origin.x+self.groupNumberLabel.frame.size.width+2,  self.sortTextfield.frame.size.height+5, 50, 30);
        
        moveButton.frame = CGRectMake(addButtonGroupButton.frame.origin.x+addButtonGroupButton.frame.size.width+30,self.sortTextfield.frame.size.height+5, 40, 30);
    }
    else if (IS_IPAD){
        toolbarBackground.translatesAutoresizingMaskIntoConstraints=NO;
        bottomToolbarView.translatesAutoresizingMaskIntoConstraints=NO;
        _groupTable.translatesAutoresizingMaskIntoConstraints=NO;
        
        toolBar.translatesAutoresizingMaskIntoConstraints=NO;
        
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[toolbarBackground]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(toolbarBackground)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[bottomToolbarView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(bottomToolbarView)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[toolbarBackground(64)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(toolbarBackground)]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_groupTable]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_groupTable)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-64-[_groupTable]-0-[bottomToolbarView(44)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_groupTable,bottomToolbarView)]];
        
        //Bottom toolbar
        _groupNumberLabel.translatesAutoresizingMaskIntoConstraints=NO;
        [bottomToolbarView addConstraint:[NSLayoutConstraint constraintWithItem:_groupNumberLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:bottomToolbarView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [bottomToolbarView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[_groupNumberLabel(30)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_groupNumberLabel)]];
        
        _sortTextfield.translatesAutoresizingMaskIntoConstraints=NO;
        minusButtonGroupButton.translatesAutoresizingMaskIntoConstraints=NO;
        addButtonGroupButton.translatesAutoresizingMaskIntoConstraints=NO;
        moveButton.translatesAutoresizingMaskIntoConstraints=NO;
        [bottomToolbarView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_sortTextfield]-40-[minusButtonGroupButton(50)]-20-[_groupNumberLabel]-20-[addButtonGroupButton(50)]-40-[moveButton]" options:NSLayoutFormatAlignAllBaseline metrics:nil views:NSDictionaryOfVariableBindings(_sortTextfield,minusButtonGroupButton,addButtonGroupButton,_groupNumberLabel,moveButton)]];
        
    }
    
    //bottom toolbar buttons

    [self getStudentList];
    [self splitTheList];
    [self.groupTable reloadData];
    
    [self.groupTable setEditing:YES animated:YES];
    
    
    [self.navigationItem setTitle:@"Add New Group"];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveGroupDataView)];
    [self.navigationItem setRightBarButtonItem:saveButton];
    
}
-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    StudentObject *studentObjectToMove = [[[_dataArray objectAtIndex:sourceIndexPath.section] objectForKey:@"data"] objectAtIndex:sourceIndexPath.row];
    
    NSMutableArray *eachSectionSource = [[_dataArray objectAtIndex:sourceIndexPath.section] objectForKey:@"data"];
    [eachSectionSource removeObjectAtIndex:sourceIndexPath.row];
    
    NSMutableArray *eachSectionDest = [[_dataArray objectAtIndex:destinationIndexPath.section] objectForKey:@"data"];
    [eachSectionDest insertObject:studentObjectToMove atIndex:destinationIndexPath.row];
    
    [self tableView:self.groupTable titleForHeaderInSection:destinationIndexPath.section];
    
    [self.groupTable reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSMutableArray*)createArrayForJSON{
    
    NSMutableArray *dataArrayObjectId = [[NSMutableArray alloc]initWithCapacity:0];
    
    for (int i=0; i<[self.groupTable numberOfSections]; i++) {
        
        NSArray *studentSectionArray = [[self.dataArray objectAtIndex:i] objectForKey:@"data"];
        
        NSMutableArray *eachSection = [[NSMutableArray alloc]initWithCapacity:0];
        
        for (StudentObject *studentObj in studentSectionArray) {
            
            [eachSection addObject:studentObj.objectId];
            
        }
        
        [dataArrayObjectId addObject:eachSection];
    }
    
    return dataArrayObjectId;
}


-(void)splitTheList{
    
    NSMutableArray *eachGroup = [[NSMutableArray alloc]initWithCapacity:self.groupNumber];
    
    
    for (int i=0; i<[self.studentObjArray count]; i++) {
        
        //convert back to dictionary because we cannot JSON nsmanagedObject
        
        [eachGroup addObject:self.studentObjArray[i]];
        
        if ((i+1)%self.groupNumber == 0) {
            
            //This is for deep copy
            NSMutableArray *eachGroupDeep = [[NSMutableArray alloc]initWithArray:eachGroup];
            
            [self.dataArray addObject:[NSDictionary dictionaryWithObject:eachGroupDeep forKey:@"data"]];
            
            [eachGroup removeAllObjects];
        }
    }
    
    //check for extras
    if ([eachGroup count]) {
        
        //This is for deep copy
        NSMutableArray *eachGroupDeep = [[NSMutableArray alloc]initWithArray:eachGroup];
        
        [self.dataArray addObject:[NSDictionary dictionaryWithObject:eachGroupDeep forKey:@"data"]];
    }
    
    [self.groupTable reloadData];
    
}


-(void)saveGroupDataView{
    
    //Disable save button
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    
    self.saveBackground = [[UIView alloc]init];
    self.saveBackground.userInteractionEnabled=YES;
    [self.view addSubview:self.saveBackground];
    
    UIImageView *tutorialbackground = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"blackboardBorder"]];
    tutorialbackground.userInteractionEnabled=YES;
    [tutorialbackground setTag:1000];
    [tutorialbackground setAlpha:0];
    [self.saveBackground addSubview:tutorialbackground];
    
    if (IS_IPHONE) {
        [self.saveBackground setFrame:self.view.frame];
        [tutorialbackground setFrame:CGRectMake(0, 90, 320, 200)];
        
    }
    else if (IS_IPAD){
        self.saveBackground.translatesAutoresizingMaskIntoConstraints=NO;
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_saveBackground]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_saveBackground)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_saveBackground]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_saveBackground)]];
        
        tutorialbackground.translatesAutoresizingMaskIntoConstraints=NO;
        [self.saveBackground addConstraint:[NSLayoutConstraint constraintWithItem:tutorialbackground attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.saveBackground attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [self.saveBackground addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-100-[tutorialbackground]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tutorialbackground)]];
    }
    
    CGAffineTransform transform = CGAffineTransformMakeScale(0.9, 0.9);
    [tutorialbackground.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        [tutorialbackground setAlpha:1];
        [tutorialbackground setTransform:transform];
        
    } completion:^(BOOL finished) {
        
        //Inside Save view
        self.groupNameTextfield = [[UITextField alloc]initWithFrame:CGRectMake(tutorialbackground.frame.size.width/2-(tutorialbackground.frame.size.width-100)/2+20, 80,tutorialbackground.frame.size.width-100, 30)];
        self.groupNameTextfield.borderStyle = UITextBorderStyleRoundedRect;
        [self.groupNameTextfield setBackgroundColor:[UIColor whiteColor]];
        [self.groupNameTextfield setPlaceholder:@"New Group Project"];
        [self.groupNameTextfield becomeFirstResponder];
        [tutorialbackground addSubview:self.groupNameTextfield];
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelButton setFrame:CGRectMake(30, tutorialbackground.frame.size.height - 60, 100, 50)];
        [cancelButton setTitleColor:[UIColor colorWithRed:0.435294 green:0.90588 blue:0.8588 alpha:1] forState:UIControlStateNormal];
        [cancelButton setTag:500];
        [cancelButton.titleLabel setFont:[UIFont fontWithName:@"Eraser" size:19]];
        [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(hideSaveView) forControlEvents:UIControlEventTouchUpInside];
        [tutorialbackground addSubview:cancelButton];
        
        UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [saveButton setFrame:CGRectMake(tutorialbackground.frame.size.width-100, tutorialbackground.frame.size.height - 60, 100, 50)];
        [saveButton setTitleColor:[UIColor colorWithRed:0.435294 green:0.90588 blue:0.8588 alpha:1] forState:UIControlStateNormal];
        [saveButton setTag:600];
        [saveButton.titleLabel setFont:[UIFont fontWithName:@"Eraser" size:19]];
        [saveButton setTitle:@"Save" forState:UIControlStateNormal];
        [saveButton addTarget:self action:@selector(checkForDuplicateNames) forControlEvents:UIControlEventTouchUpInside];
        [tutorialbackground addSubview:saveButton];
    }];

}

//save View Buttons
-(void)saveGroupData{
    
        NSString *objId = [[NSUserDefaults standardUserDefaults] objectForKey:@"ObjectId"];
        NSString *lowerGroupName = [self.groupNameTextfield.text lowercaseString];
        lowerGroupName = [lowerGroupName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        NSString *teacherUserId = objId;
    
        //convert the data into objectId
        NSDictionary *groupData = @{lowerGroupName: [self createArrayForJSON]};
        
        NSError *error;
        NSData *jsonDataArray = [NSJSONSerialization dataWithJSONObject:groupData options:0 error:&error];
        NSString *JSONStringArray = [[NSString alloc] initWithData:jsonDataArray encoding:NSUTF8StringEncoding];
        
        
        InsertWebService *insertGroup = [[InsertWebService alloc]initWithTable:@"ClassObject"];
        [insertGroup insertObjectInColumnWhere:@"Groups" setObjectValue:JSONStringArray];
        [insertGroup insertObjectInColumnWhere:@"Teacher" setObjectValue:teacherUserId];
        [insertGroup insertObjectInColumnWhere:@"ClassName" setObjectValue:[self.classObject.nameOfClass lowercaseString]];
        [insertGroup saveIntoDatabaseInBackgroundWithBlock:^(NSError *error) {
           
            if (!error) {
                
                //Enable all buttona again
                self.navigationItem.rightBarButtonItem.enabled=YES;
                self.navigationItem.hidesBackButton=NO;
                
                [self.loadingView removeFromSuperview];
                [self.loading stopAnimating];
                [self.loading removeFromSuperview];
                
                [self hideSaveView];
                
            }
        
            
        }];
        
    
    
}

-(void)hideSaveView{
    
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
    
    [self.groupNameTextfield resignFirstResponder];

    UIImageView *blackboard = (UIImageView*)[self.saveBackground viewWithTag:1000];
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [blackboard setAlpha:0];

        [blackboard setTransform:CGAffineTransformMakeScale(0.5, 0.5)];
        
    } completion:^(BOOL finished) {
        
        [self.saveBackground removeFromSuperview];
        self.saveBackground=nil;
        
    }];
}

-(void)checkForDuplicateNames{
    
    self.navigationItem.rightBarButtonItem.enabled=NO;
    self.navigationItem.hidesBackButton=YES;
    self.loadingView = [[UIView alloc]initWithFrame:self.view.frame];
    self.loadingView.backgroundColor = [UIColor blackColor];
    self.loadingView.alpha=0.5;
    [self.view addSubview:self.loadingView];
    
    self.loading = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-25, (self.view.frame.size.height)/2, 50, 50)];
    [self.view addSubview:self.loading];
    [self.loading setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.loading hidesWhenStopped];
    [self.loading startAnimating];
    
    
    if([self.projectNamesForDuplicates count] ==0){
        
        QueryWebService *query = [[QueryWebService alloc]initWithTable:@"ClassObject"];
        [query selectColumnWhere:@"Teacher" equalTo:[[NSUserDefaults standardUserDefaults] objectForKey:@"UserId"]];
        [query selectColumnWhere:@"ClassName" equalTo:[self.classObject.nameOfClass lowercaseString]];
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
                
                if ([rows count] == 0) {
                    [self saveGroupData];
                }
                else{
                    
                    BOOL isDuplicate = 0;
                    
                    for (NSDictionary *eachRow in rows) {
                        
                        NSError *error;
                        NSString *jsonStringArray = eachRow[@"Groups"];
                        NSData *data = [jsonStringArray dataUsingEncoding:NSUTF8StringEncoding];
                        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                        
                        NSString *nameOfGroupInRow =[jsonDictionary allKeys][0];
                        
                        NSString *lowerGroupNameInput = [self.groupNameTextfield.text lowercaseString];
                        lowerGroupNameInput = [lowerGroupNameInput stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

                        
                        
                        if([[nameOfGroupInRow lowercaseString] isEqualToString:lowerGroupNameInput]){
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Name already taken!" message:@"Try Again!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                            [alert show];
                            isDuplicate =1;
                        
                            //Enable all buttona again
                            self.navigationItem.rightBarButtonItem.enabled=YES;
                            self.navigationItem.hidesBackButton=NO;
                            
                            [self.loadingView removeFromSuperview];
                            [self.loading stopAnimating];
                            [self.loading removeFromSuperview];

                            
                            break;
                        }
                    }
                    
                    if (!isDuplicate) {
                        [self saveGroupData];
                    }
                }
                
            }
        
        }];
    }
    else{
        BOOL isDuplicate = 0;
        
        for (NSDictionary *eachRow in self.projectNamesForDuplicates) {
            
            NSError *error;
            NSString *jsonStringArray = eachRow[@"Groups"];
            NSData *data = [jsonStringArray dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            
            NSString *nameOfGroupInRow =[jsonDictionary allKeys][0];
            
            NSString *lowerGroupNameInput = [self.groupNameTextfield.text lowercaseString];
            lowerGroupNameInput = [lowerGroupNameInput stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            if([[nameOfGroupInRow lowercaseString] isEqualToString:lowerGroupNameInput]){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Name already taken!" message:@"Try Again!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
                isDuplicate =1;
                
                //Enable all buttona again
                self.navigationItem.rightBarButtonItem.enabled=YES;
                self.navigationItem.hidesBackButton=NO;
                
                [self.loadingView removeFromSuperview];
                [self.loading stopAnimating];
                [self.loading removeFromSuperview];

                break;
            }
        }
        
        if (!isDuplicate) {
            [self saveGroupData];
        }
    }
    
}

-(void)getStudentList{
    NSString *objId = [[NSUserDefaults standardUserDefaults] objectForKey:@"ObjectId"];
    
    NSError *error;
    NSFetchRequest *studentsRequest = [NSFetchRequest fetchRequestWithEntityName:@"StudentObject"];
    studentsRequest.predicate= [NSPredicate predicateWithFormat:@"(teacher = %@) AND (nameOfclass = %@)",objId,[self.classObject.nameOfClass lowercaseString]];
    NSArray *studentArrays = [_managedObjectContext executeFetchRequest:studentsRequest error:&error];
    
    [self.studentObjArray removeAllObjects];
    [self.studentObjArray addObjectsFromArray:[self sortArrayFinal:studentArrays]];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_dataArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary *dictionary = [_dataArray objectAtIndex:section];
    NSArray *array = [dictionary objectForKey:@"data"];
    return [array count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"studentCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"studentCell"];
    //The code simply loops through our ‘dataArray’ and gets the text object for each row and then adds it to the cell
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    NSDictionary *dictionary = [_dataArray objectAtIndex:indexPath.section]; //get dictionary
    NSArray *array = [dictionary objectForKey:@"data"]; //get array
    StudentObject *cellValue = [array objectAtIndex:indexPath.row];
    cell.textLabel.text = cellValue.studentName;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSMutableArray *groupSection = [[self.dataArray objectAtIndex:section] objectForKey: @"data"];
    
    NSString *groupTitle = [NSString stringWithFormat:@"Group %d Size: %d",(int)section+1,(int)[groupSection count]];
    
    return groupTitle;
}
-(BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}

-(void)groupSizeMethod:(UIButton*)sender{
    
    //Clear table first
    [self.dataArray removeAllObjects];
    
    if (sender.tag == 100) {
        self.groupNumber++;
        
    }
    else{
        if (self.groupNumber!=0) {
            self.groupNumber--;
        }
    }
    
    
    [self splitTheList];
    if (IS_IPHONE) {
        self.groupNumberLabel.text = [NSString stringWithFormat:@"%d", self.groupNumber];
    }
    else if (IS_IPAD){
        self.groupNumberLabel.text = [NSString stringWithFormat:@"%d Per Group", self.groupNumber];
    }
    [self.groupTable reloadData];
    
}

//picker sort
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (row==0){
        [pickerView selectRow:1 inComponent:component animated:YES];
        
        self.sortString = [self.pickerArray objectAtIndex:1];
    }
    else{
        self.sortString = [self.pickerArray objectAtIndex:row];
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

-(void)pickerButtonActions{
    
    UIView *pv = (UIView*)[self.view viewWithTag:700];
    
    //done button
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
        pv.frame=CGRectMake(self.view.frame.origin.x,self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
        
    } completion:^(BOOL finished) {
        
        //Clear table first
        [self.dataArray removeAllObjects];
        
        if ([self.sortString isEqualToString:@"Random"]) {
            NSLog(@"RANDOM");
            
            NSUInteger count = [self.studentObjArray count];
            
            for (NSUInteger i = 0; i < count; ++i) {
                NSInteger remainingCount = count - i;
                NSInteger exchangeIndex = i + arc4random_uniform(remainingCount);
                [self.studentObjArray exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
            }
            
            [self splitTheList];
            [self.groupTable reloadData];
            
        }
        
        else{
            [self.sortTextfield setText:self.sortString];
            [self getStudentList];
            [self splitTheList];
            [self.groupTable reloadData];
            
        }
        [self.pickerSort removeFromSuperview];
        [self.sortTextfield resignFirstResponder];
    }];
    
}

-(void)moveDirectionMethod{
    
    UITapGestureRecognizer *tapCloseRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    tapCloseRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapCloseRecognizer];
    
    self.moveBackground = [[UIView alloc]init];
    self.moveBackground.userInteractionEnabled=YES;
    [self.view addSubview:self.moveBackground];
    
    UIImageView *tutorialbackground = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"blackboardBorder"]];
    [tutorialbackground setTag:1000];
    [tutorialbackground setAlpha:0];
    [self.moveBackground addSubview:tutorialbackground];
    
    if (IS_IPHONE) {
        [self.moveBackground setFrame:self.view.frame];
        [tutorialbackground setFrame:CGRectMake(0, 90, 320, 200)];
        
        BouncingPencil *pencilArrow = [[BouncingPencil alloc]initWithFrame:CGRectMake(213, 138, 60, 60)];
        [pencilArrow setTag:2000];
        [pencilArrow setUpPencilBounceFrame:pencilArrow.frame targetX:15 targetY:-9 rotation:5*M_PI_4];
        [self.moveBackground addSubview:pencilArrow];
    }
    else if (IS_IPAD){
        self.moveBackground.translatesAutoresizingMaskIntoConstraints=NO;
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_moveBackground]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_moveBackground)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_moveBackground]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_moveBackground)]];
        
        //Set bouncing Pencil
        BouncingPencil *pencilArrow = [[BouncingPencil alloc]init];
        [pencilArrow setTag:2000];
        [self.moveBackground addSubview:pencilArrow];
        pencilArrow.translatesAutoresizingMaskIntoConstraints=NO;
        [self.moveBackground addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-138-[pencilArrow(60)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(pencilArrow)]];
        [self.moveBackground addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[pencilArrow(60)]-53-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(pencilArrow)]];
        [pencilArrow setUpPencilBounceForiPad:CGSizeMake(60, 60) targetX:15 targetY:-9 rotation:5*M_PI_4];
        
        tutorialbackground.translatesAutoresizingMaskIntoConstraints=NO;
        [self.moveBackground addConstraint:[NSLayoutConstraint constraintWithItem:tutorialbackground attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.moveBackground attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [self.moveBackground addConstraint:[NSLayoutConstraint constraintWithItem:tutorialbackground attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.moveBackground attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
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
        [tutorialLabel setText:@"Reorder your students between groups by using the cursor on the right. \n\nFollow the pencil!"];
        [tutorialbackground addSubview:tutorialLabel];
    }];

}

- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer {
    if (self.moveBackground!=nil) {
        
        UIImageView *blackboard = (UIImageView*)[self.moveBackground viewWithTag:1000];
        
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [blackboard setAlpha:0];
            [blackboard setTransform:CGAffineTransformMakeScale(0.5, 0.5)];
            
        } completion:^(BOOL finished) {
            [self.moveBackground removeFromSuperview];
            self.moveBackground=nil;
        }];
    }

    
}

//Sort code methods
-(NSMutableArray*)sortArrayFinal:(NSArray*)arrayToSort{
    
    NSArray *sortDescriptors = [self sortStudentsBy:self.sortString];
    
    if (sortDescriptors) {
        
        NSMutableArray *sortedArray = [[NSMutableArray alloc]initWithArray:[arrayToSort sortedArrayUsingDescriptors:sortDescriptors]];
        
        return sortedArray;
    }
    else{
        
        if ([self.classObject.sortDescrip isEqualToString:@"Last Name:Descending"]) {
            
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
