//
//  DemoAddStudentsViewController.m
//  Primo
//
//  Created by Jarrett Chen on 8/28/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import "DemoAddStudentsViewController.h"

@interface DemoAddStudentsViewController ()

@property (nonatomic) NSInteger i;
@property (nonatomic) NSInteger y;
@property (strong, nonatomic)NSNumber *coins;

@property(nonatomic,strong) NSMutableArray *studentNames;
@property(nonatomic,strong) UIScrollView *scroller;

@property (nonatomic) NSInteger studentNumber;
@property (nonatomic,strong) UIImageView *coinView;
@property (nonatomic,strong) UITextField *editCoinTextField;
@property (nonatomic,strong) UIImageView *previousImageView;
@property (nonatomic,strong) UIButton *studentsCoinButton;

//ipad
@property (nonatomic,strong) NSArray *hiddenCoinViewConstraint;
@property (nonatomic,strong) NSArray *showCoinViewConstraint;

@end

@implementation DemoAddStudentsViewController

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
    
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(checkForDuplicateStringsInTextfield)];
    [self.navigationItem setRightBarButtonItem:doneButton];
    
    
    //addstudent toolbar

    UIImageView *toolbarBackground = [[UIImageView alloc]init];
    [toolbarBackground setImage:[UIImage imageNamed:@"blackboardBar"]];
    toolbarBackground.userInteractionEnabled=YES;
    [self.view addSubview:toolbarBackground];
    
    self.studentNumber = [self getStudentsNumberFromClassName:self.className];
    self.studentNames = [[NSMutableArray alloc]initWithCapacity:0];
    self.coins = [NSNumber numberWithInt:0];
    
    self.scroller = [UIScrollView new];
    self.scroller.scrollEnabled=YES;
    self.scroller.userInteractionEnabled=YES;
    self.scroller.showsVerticalScrollIndicator=YES;
    [self.view addSubview:self.scroller];
    
    UIImageView *headerImageView = [[UIImageView alloc]init];
    headerImageView.userInteractionEnabled=YES;
    [self.scroller addSubview:headerImageView];
    UIImage *headerImage= [UIImage imageNamed:@"headerLinedPaper"];
    [headerImageView setImage:headerImage];
    
    //directions for add students view controller
    UILabel *titleDirection = [[UILabel alloc]init];
    titleDirection.numberOfLines=0;
    titleDirection.text = @"Please enter your student's name below.";
    [titleDirection setFont:[UIFont fontWithName:@"TravelingTypewriter" size:19]];
    [headerImageView addSubview:titleDirection];

    
    //coin views
    self.coinView=[[UIImageView alloc]init];
    [self.coinView setImage:[UIImage imageNamed:@"blackboardBorder"]];
    
    _editCoinTextField = [[UITextField alloc] init];
    _editCoinTextField.borderStyle=UITextBorderStyleRoundedRect;
    [_editCoinTextField setKeyboardType:UIKeyboardTypeNumberPad];
    _editCoinTextField.delegate = self;
    [_editCoinTextField setKeyboardType:UIKeyboardTypeNumberPad];
    
    self.studentsCoinButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.studentsCoinButton setTitle:[NSString stringWithFormat:@"Click here to distribute coins to your students\nCoins Distributed: 0"] forState:UIControlStateNormal];
    [self.studentsCoinButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.studentsCoinButton.titleLabel setNumberOfLines:0];
    [self.studentsCoinButton.titleLabel setFont:[UIFont fontWithName:@"TravelingTypewriter" size:15]];
    [self.studentsCoinButton addTarget:self action:@selector(showCoinView) forControlEvents:UIControlEventTouchUpInside];
    [headerImageView addSubview:self.studentsCoinButton];
    
    if (IS_IPAD) {
        toolbarBackground.translatesAutoresizingMaskIntoConstraints=NO;
        self.scroller.translatesAutoresizingMaskIntoConstraints=NO;
        headerImageView.translatesAutoresizingMaskIntoConstraints=NO;
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[toolbarBackground]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(toolbarBackground)]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_scroller]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_scroller)]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[toolbarBackground(64)]-0-[_scroller]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(toolbarBackground,_scroller)]];
        
        [self.scroller addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[headerImageView(==_scroller)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(headerImageView,_scroller)]];
        [self.scroller addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-1-[headerImageView(200)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(headerImageView)]];
        
        [titleDirection setFrame:CGRectMake(210,25,300, 70)];
        [self.studentsCoinButton setFrame:CGRectMake(230, titleDirection.frame.origin.y+70+20, 200, 60)];
        
        //Textfields
        self.studentNumber++;
        
        _previousImageView = nil;
        //start of textField
        for (_i=0; _i<30; _i++) {
            
            UIImageView *imageView = [UIImageView new];
            imageView.translatesAutoresizingMaskIntoConstraints=NO;
            imageView.userInteractionEnabled=YES;
            [self.scroller addSubview:imageView];
            
            UIImage *linedImage = [UIImage imageNamed:@"linedPaper"];
            [imageView setImage:linedImage];
            
            [self.scroller addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[imageView(==_scroller)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(imageView,_scroller)]];
            
            if (!_previousImageView) { // first one, pin to top
                [self.scroller addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-200-[imageView(40)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(imageView)]];
                
            } else { // all others, pin to previous
                [self.scroller addConstraints:
                 [NSLayoutConstraint
                  constraintsWithVisualFormat:@"V:[_previousImageView]-(0)-[imageView(40)]"
                  options:0 metrics:nil
                  views:NSDictionaryOfVariableBindings(_previousImageView,imageView)]];
            }
            
            UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(200, 13, 250, 30)];
            tf.placeholder=[NSString stringWithFormat:@"Student %d", self.studentNumber];
            tf.tag = self.studentNumber;
            [self.studentNames addObject:tf];
            tf.delegate = self;
            [tf setFont:[UIFont systemFontOfSize:20]];
            [imageView addSubview:tf];
            self.studentNumber++;
            
            _previousImageView = imageView;
        }
        
        //addButton
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.tag=5000;
        button.translatesAutoresizingMaskIntoConstraints=NO;
        [button addTarget:self action:@selector(addStudent:) forControlEvents:UIControlEventTouchDown];
        button.layer.cornerRadius=2;
        button.backgroundColor=[UIColor colorWithRed:0.0705882 green:0.082353 blue:0.243137 alpha:1];
        [button setTitle:@"Add More Students" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.scroller addSubview:button];
        
        [button addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[button(180)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(button)]];
        
        [self.scroller addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.scroller attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        
        [self.scroller addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_previousImageView]-20-[button]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_previousImageView,button)]];
        
    }
    else if (IS_IPHONE){
        _y = 200;
        
        
        [toolbarBackground setFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
        [self.scroller setFrame:CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y+64,self.view.frame.size.width,self.view.frame.size.height-64)];
        self.scroller.contentSize = CGSizeMake(self.view.frame.size.width,self.view.frame.size.height);
        [headerImageView setFrame:CGRectMake(self.scroller.frame.origin.x, self.scroller.frame.origin.y-64,self.scroller.frame.size.width , self.y)];
        
        //set direction
        [titleDirection setFrame:CGRectMake(headerImageView.frame.origin.x+62, headerImageView.frame.origin.y+20, headerImageView.frame.size.width-70, 50)];
        [self.studentsCoinButton setFrame:CGRectMake(90, titleDirection.frame.origin.y+50+50, 200, 60)];

        //specify student number
        
        self.studentNumber++;
        
        //start of textField
        for (_i=0; _i<30; _i++) {
            
            if (self.view.frame.size.height>_y) {
                
                //add first couple of textfields
                [self createStudentTextfieldArray:self.studentNames scrollerToAdd:self.scroller yPosition:_y];
            }
            
            else{
                //add lined paper image
                [self createStudentTextfieldArray:self.studentNames scrollerToAdd:self.scroller yPosition:_y];
                //make scroller bigger
                self.scroller.contentSize = CGSizeMake(320,(self.scroller.contentSize.height)+40);
                
            }
            _y=_y+40;
        }//end of for loop
        
        self.scroller.contentSize = CGSizeMake(320,(self.scroller.contentSize.height)+120);
        [self createAddButtonAtTheEndscrollerToAdd:self.studentNames scrollerToAdd:self.scroller yPosition:self.y];
        
    }
}

-(NSInteger)getStudentsNumberFromClassName:(NSString*)className{
    
    NSError *error;
    NSFetchRequest *studentsRequest = [NSFetchRequest fetchRequestWithEntityName:@"DemoStudentObject"];
    studentsRequest.predicate= [NSPredicate predicateWithFormat:@"(nameOfclass = %@) AND (taken = %@)",[self.className lowercaseString],@"Teacher"];
    NSArray *studentObjArray = [_demoManagedObjectContext executeFetchRequest:studentsRequest error:&error];
    return [studentObjArray count];
    
}

-(void)showCoinView{
    
    if (![self.coinView isDescendantOfView:self.view]) {
        //initialize
        [self.view addSubview:self.coinView];
        [self.coinView setUserInteractionEnabled:YES];
        if (IS_IPHONE){
            [self.coinView setFrame:CGRectMake(10, 100, 300, 300)];
        }
        else if (IS_IPAD){
            
            self.coinView.translatesAutoresizingMaskIntoConstraints=NO;
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.coinView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.coinView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
            
        }
        [self.coinView setAlpha:0];
        
        CGAffineTransform transform = CGAffineTransformMakeScale(0.9, 0.9);
        [self.coinView.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self.coinView setAlpha:1];
            [self.coinView setTransform:transform];
        } completion:^(BOOL finished) {
        
            UILabel *directionsLabel = [[UILabel alloc]init];
            directionsLabel.numberOfLines=0;
            directionsLabel.font = [UIFont fontWithName:@"Eraser" size:19];
            directionsLabel.textColor = [UIColor whiteColor];
            directionsLabel.text=@"Set the amount of coins you wish to start for your student's account.";
            [directionsLabel setFrame:CGRectMake(15, 25, self.coinView.frame.size.width-30, 90)];
            [self.coinView addSubview:directionsLabel];
            
            [self.editCoinTextField setFrame:CGRectMake(self.coinView.frame.size.width/2-30,directionsLabel.frame.origin.y+120, 80, 30)];
            [self.editCoinTextField setPlaceholder:@"Coins:"];
            [self.coinView addSubview:_editCoinTextField];
            
            UIButton *skipButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [skipButton setTag:1000];
            [skipButton setTitle:@"Skip" forState:UIControlStateNormal];
            [skipButton.titleLabel setFont:[UIFont fontWithName:@"Eraser" size:20]];
            [skipButton setTitleColor:[UIColor colorWithRed:0.435294 green:0.90588 blue:0.8588 alpha:1] forState:UIControlStateNormal];
            [skipButton setFrame:CGRectMake(30, self.coinView.frame.size.height - 60, 100, 50)];
            [skipButton addTarget:self action:@selector(coinButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.coinView addSubview:skipButton];
            
            UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [doneButton setTag:2000];
            [doneButton.titleLabel setFont:[UIFont fontWithName:@"Eraser" size:20]];
            [doneButton setTitle:@"Done" forState:UIControlStateNormal];
            [doneButton setTitleColor:[UIColor colorWithRed:0.435294 green:0.90588 blue:0.8588 alpha:1] forState:UIControlStateNormal];
            [doneButton setFrame:CGRectMake(self.coinView.frame.size.width-100, self.coinView.frame.size.height - 60, 100, 50)];
            [doneButton addTarget:self action:@selector(coinButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.coinView addSubview:doneButton];
        }];
    }
}

-(void)coinButtonAction:(UIButton*)sender{
    
    if (sender.tag == 1000) {
        //Skip Button
        self.editCoinTextField.text = @"0";
    }
    
    [self.studentsCoinButton setTitle:[NSString stringWithFormat:@"Click here to distribute coins to your students\n\nCoins Distributed: %d",[self.editCoinTextField.text intValue]] forState:UIControlStateNormal];

    [self hideCoinView];
}

-(void)hideCoinView{
    
    CGAffineTransform transform = CGAffineTransformMakeScale(10/9, 10/9);
    [self.coinView.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.coinView setAlpha:0];
        [self.coinView setTransform:transform];
    } completion:^(BOOL finished) {
        [self.coinView removeFromSuperview];
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self registerForKeyboardNotifications];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [self unRegisterForKeyboardNotifications];
}
-(void)viewDidAppear:(BOOL)animated{
    [self showCoinView];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addStudent: (UIButton*)sender{
    
    if (IS_IPAD) {
        
        
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.translatesAutoresizingMaskIntoConstraints=NO;
        imageView.userInteractionEnabled=YES;
        [self.scroller addSubview:imageView];
        
        UIImage *linedImage = [UIImage imageNamed:@"linedPaper"];
        [imageView setImage:linedImage];
        
        [self.scroller addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[imageView(==_scroller)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(imageView,_scroller)]];
        
        UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(200, 13, 250, 30)];
        tf.placeholder=[NSString stringWithFormat:@"Student %d", self.studentNumber];
        tf.tag = self.studentNumber;
        [self.studentNames addObject:tf];
        tf.delegate = self;
        [tf setFont:[UIFont systemFontOfSize:20]];
        [imageView addSubview:tf];
        self.studentNumber++;
        
        //remove previous button
        UIButton *previousButton = (UIButton*)[self.scroller viewWithTag:5000];
        [previousButton removeFromSuperview];
        
        //addButton
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.tag=5000;
        button.translatesAutoresizingMaskIntoConstraints=NO;
        [button addTarget:self action:@selector(addStudent:) forControlEvents:UIControlEventTouchDown];
        button.layer.cornerRadius=2;
        button.backgroundColor=[UIColor colorWithRed:0.0705882 green:0.082353 blue:0.243137 alpha:1];
        [button setTitle:@"Add More Students" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.scroller addSubview:button];
        
        [button addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[button(180)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(button)]];
        
        [self.scroller addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.scroller attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [self.scroller addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_previousImageView]-(0)-[imageView(40)]-20-[button]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_previousImageView,imageView,button)]];
        
        _previousImageView = imageView;
        
        
        //scroll to the bottom
        CGPoint bottomOffset = CGPointMake(0,self.scroller.contentSize.height-self.view.bounds.size.height+109);
        
        
        [_scroller setContentOffset:bottomOffset animated:YES];
        
    }
    else{
        [self createStudentTextfieldArray:self.studentNames scrollerToAdd:self.scroller yPosition:self.y];
        
        _scroller.contentSize = CGSizeMake(320,(_scroller.contentSize.height)+40);
        
        _y+=40;
        _i++;
        
        [self createAddButtonAtTheEndscrollerToAdd:self.studentNames scrollerToAdd:self.scroller yPosition:self.y];
        //scroll to see the button when it is added
        [_scroller scrollRectToVisible:CGRectMake((self.view.frame.size.width/2)-100, _y, 200, 100) animated:YES];
    }
    
    
}

-(void)enterIntoDatabase{

    NSError *error;
    NSFetchRequest *studentsRequest = [NSFetchRequest fetchRequestWithEntityName:@"DemoStudentObject"];
    studentsRequest.predicate= [NSPredicate predicateWithFormat:@"(taken = %@)",@"Teacher"];

    NSArray *studentObjArray = [_demoManagedObjectContext executeFetchRequest:studentsRequest error:&error];
    
    int lastObjectId = [studentObjArray count];
    BOOL isEmpty = YES;
    
    //Enter things into parse
    int numberStudent = [self getStudentsNumberFromClassName:self.className];

    for (UITextField *texting in _studentNames){
        if( ![texting.text isEqualToString:@""]){
            
            isEmpty =NO;
            
            numberStudent++;
            lastObjectId++;
            
            NSString *studentName = [texting.text capitalizedString];
            studentName = [studentName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            NSDictionary *studentDict = @{@"coins": @([self.editCoinTextField.text intValue]),
                                           @"nameOfclass":[self.className lowercaseString],
                                           @"signedIn":@0,
                                           @"studentName":studentName,
                                           @"studentNumber":@(numberStudent),
                                           @"objectId":[NSString stringWithFormat:@"%d",lastObjectId],
                                           @"taken":@"Teacher"};
            
            [DemoStudentObject createStudentObjectInCoreWithDictionary:studentDict inManagedObjectContext:_demoManagedObjectContext];
            
            
            
            [_demoManagedObjectContext save:nil];
        }
    }
    
    
    if (isEmpty) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Did you forget to add your students?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else{
        //save class into database
        
        if (_teacherObject !=nil) {
            NSError *error;
            NSData *data = [_teacherObject.classList dataUsingEncoding:NSUTF8StringEncoding];
            NSArray *jsonClassListArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            
            NSMutableArray *classListArray = [[NSMutableArray alloc]initWithArray:jsonClassListArray];
            
            [classListArray addObject:self.className];
            
            NSData *jsonDataArray = [NSJSONSerialization dataWithJSONObject:classListArray options:0 error:&error];
            NSString *JSONStringArray = [[NSString alloc] initWithData:jsonDataArray encoding:NSUTF8StringEncoding];
            
            _teacherObject.classList=JSONStringArray;
            [self.demoManagedObjectContext save:nil];

        }

        
        
        DemoTeacher *addClassComplete = [DemoTeacher findTeacherProgress:_demoManagedObjectContext];
        if (![addClassComplete.addClassDone boolValue]) {
            addClassComplete.addClassDone = [NSNumber numberWithBool:YES];
            [_demoManagedObjectContext save:nil];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"GOOD JOB!" message:@"You successfully added a new class!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
            //rate the app
            if ((int)[addClassComplete getTotalProgress] == 1) {
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
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"GOOD JOB!" message:@"You successfully added a new class!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}


-(void)checkForDuplicateStringsInTextfield{
    
    //Bool to check for duplicate
    BOOL duplicateInTextfields = NO;
    BOOL duplicateInDatabase = NO;
    
    
    //Get the names from the database first
    NSError *error;
    NSFetchRequest *studentsRequest = [NSFetchRequest fetchRequestWithEntityName:@"DemoStudentObject"];
    NSArray *studentObjArray = [_demoManagedObjectContext executeFetchRequest:studentsRequest error:&error];
    
    for (UITextField *checkParameter in _studentNames){
        
        //clears everything
        [checkParameter setBackgroundColor:[UIColor clearColor]];
        
        if(![checkParameter.text isEqualToString:@""]){
            
            NSString *checkParameterName = [checkParameter.text capitalizedString];
            checkParameterName = [checkParameterName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            //Use check parameters to check every element in whole textfields
            for (UITextField *arrayCheck in _studentNames){
                
                if( ![arrayCheck.text isEqualToString:@""]){
                    
                    NSString *arrayCheckName = [arrayCheck.text capitalizedString];
                    arrayCheckName = [arrayCheckName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    
                    if (![checkParameter isEqual:arrayCheck] && [checkParameterName isEqualToString:arrayCheckName]) {
                        
                        duplicateInTextfields= YES;
                        
                        [checkParameter setBackgroundColor:[UIColor redColor]];
                        
                    }
                }
            }
            
            //now check the database
            if([studentObjArray count] !=0){
                //Use check parameters to check every element in database
                for (DemoStudentObject *studentObj in studentObjArray) {
                    
                    if ([studentObj.studentName isEqualToString:checkParameterName]) {
                        
                        duplicateInDatabase = YES;
                        
                        [checkParameter setBackgroundColor:[UIColor yellowColor]];
                    }
                }
            }
        }
    }
    
    //Check for duplicates
    if (duplicateInDatabase && !duplicateInTextfields) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Duplicate!" message:@"One of the name is already taken from your class" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else if (!duplicateInDatabase && duplicateInTextfields){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Duplicate!" message:@"There a duplicate in one of the fields" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else if (duplicateInTextfields && duplicateInDatabase){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Duplicate" message:@"Theres a duplicate in your field and your classroom" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else{
        [self enterIntoDatabase];
    }
}

//keyboard stuff
-(void)hideKeyboard{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    UITextField *tf = (UITextField*)[self.view viewWithTag:textField.tag+1];
    [tf becomeFirstResponder];
    
    return YES;
}

- (void)registerForKeyboardNotifications

{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)unRegisterForKeyboardNotifications

{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification

{
    
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    
    _scroller.contentInset = contentInsets;
    
    _scroller.scrollIndicatorInsets = contentInsets;
    
}
//
//- (void)textFieldDidBeginEditing:(UITextField *)textField
//
//{
//    _activeField = textField;
//}
//
//- (void)textFieldDidEndEditing:(UITextField *)textField
//
//{
//    _activeField = nil;
//    
//    
//}


//adjust the frame of the content and scrolling
- (void)keyboardWasShown:(NSNotification*)aNotification

{
    
    
    NSDictionary* info = [aNotification userInfo];
    CGRect kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    
    kbSize = [self.view convertRect:kbSize toView:nil];
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.size.height+2, 0.0);
    
    _scroller.contentInset = contentInsets;
    
    _scroller.scrollIndicatorInsets = contentInsets;
    
    
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    
    // Your app might not need or want this behavior.
    
    CGRect aRect = self.view.frame;
    
    aRect.size.height -= kbSize.size.height;
    
//    if (!CGRectContainsPoint(aRect, _activeField.frame.origin) ) {
//        [_scroller scrollRectToVisible:_activeField.frame animated:YES];
//    }
}

//creating textfield and button
-(void)createStudentTextfieldArray:(NSMutableArray*)itemArray scrollerToAdd:(UIScrollView*)scrollView yPosition:(NSInteger)position{
    
    //image linedpaper
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(scrollView.frame.origin.x, position, scrollView.frame.size.width, 40)];
    imageView.userInteractionEnabled=YES;
    [scrollView addSubview:imageView];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    UIImage *linedImage;
    if (([itemArray count]%10) == 0) {
        linedImage = [UIImage imageNamed:@"linedPaperHole"];
    }
    else{
        linedImage = [UIImage imageNamed:@"linedPaper"];
    }
    [imageView setImage:linedImage];
    
    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(72, 13, 250, 30)];
    tf.placeholder=[NSString stringWithFormat:@"Student %d", self.studentNumber];
    tf.tag = self.studentNumber;
    [self.studentNames addObject:tf];
    tf.delegate = self;
    [tf setFont:[UIFont systemFontOfSize:20]];
    [imageView addSubview:tf];
    self.studentNumber++;
}

-(void)createAddButtonAtTheEndscrollerToAdd:(NSMutableArray*)itemArray scrollerToAdd:(UIScrollView*)scrollView yPosition:(NSInteger)position{
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(scrollView.frame.origin.x, position, scrollView.frame.size.width, 40)];
    imageView.userInteractionEnabled=YES;
    [scrollView addSubview:imageView];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    UIImage *linedImage;
    if (([itemArray count]%10) == 0) {
        linedImage = [UIImage imageNamed:@"linedPaperHole"];
    }
    else{
        linedImage = [UIImage imageNamed:@"linedPaper"];
    }
    [imageView setImage:linedImage];
    
    //addButton
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self action:@selector(addStudent:) forControlEvents:UIControlEventTouchDown];
    button.layer.cornerRadius=2;
    button.backgroundColor=[UIColor colorWithRed:0.0705882 green:0.082353 blue:0.243137 alpha:1];
    [button setTitle:@"Add More Students" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.frame = CGRectMake((scrollView.frame.size.width/2)-80, position+40, 180, 35);
    [scrollView addSubview:button];
    
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    // if the cell selected segue was fired, edit the selected note
//    if ([segue.identifier isEqualToString:@"classtabbarseg"] || [segue.identifier isEqualToString:@"addmoreteach"]) {
//        UITabBarController *tabbarC = (UITabBarController*)segue.destinationViewController;
//        
//        UINavigationController *navVC = [tabbarC.viewControllers objectAtIndex:0];
//        StudentsViewController *studentVC = [navVC.viewControllers objectAtIndex:0];
//        
//        TeacherStoreViewController *storeVC = [tabbarC.viewControllers objectAtIndex:1];
//        
//        UINavigationController *annNavVC = [tabbarC.viewControllers objectAtIndex:2];
//        AnnouncementViewController *annVC = [annNavVC.viewControllers objectAtIndex:0];
//        
//        
//        UINavigationController *moreNavVC = [tabbarC.viewControllers objectAtIndex:3];
//        moreViewController *moreVC = [moreNavVC.viewControllers objectAtIndex:0];
//        
//        annVC.className=self.className;
//        annVC.managedObjectContext = _managedObjectContext;
//        
//        moreVC.classNameInMore = self.className;
//        moreVC.managedObjectContext=_managedObjectContext;
//        
//        storeVC.className=self.className;
//        //        storeVC.signedInStudents = self.signedInStudents;
//        storeVC.managedObjectContext = self.managedObjectContext;
//        
//        studentVC.className=self.className;
//        studentVC.managedObjectContext = self.managedObjectContext;
//        
//    }
//    else if( [segue.identifier isEqualToString:@"editStore"]){
//        EditStoreViewController *editStoreVC = (EditStoreViewController*)segue.destinationViewController;
//        editStoreVC.managedObjectContext=_managedObjectContext;
//    }
}

@end
