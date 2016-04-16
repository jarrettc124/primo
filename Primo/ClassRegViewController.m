//
//  ClassRegViewController.m
//  TeacherApp
//
//  Created by Jarrett Chen on 3/18/14.
//  Copyright (c) 2014 Jarrett Chen. All rights reserved.
//

//fix cancel button, navbar will be gone

#import "ClassRegViewController.h"
#import "MyUser.h"

@interface ClassRegViewController ()
@property (nonatomic,strong) NSArray *pickerArray;
@property (nonatomic,strong) BouncingPencil *pencilImage;
@property (nonatomic,strong) NSString *teachersName;
@property (nonatomic,strong) UIPickerView *pickerGender;

@end

@implementation ClassRegViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.hidesBackButton=YES;
    
    //pickerview
    self.pickerArray = [[NSArray alloc]initWithObjects:@"Male",@"Female", nil];
    self.pickerGender = [[UIPickerView alloc]init];
    self.pickerGender.delegate=self;
    self.pickerGender.dataSource=self;
    
      // Do any additional setup after loading the view.
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blackboardBackground"]];
    backgroundView.userInteractionEnabled=YES;
    [self.view addSubview:backgroundView];
    
    UIImageView *textfieldThree = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"textfieldThree"]];
    textfieldThree.userInteractionEnabled=YES;
    [self.view addSubview:textfieldThree];
    
    UILabel *loginDirection = [UILabel new];
    [loginDirection setNumberOfLines:0];
    [loginDirection setMinimumScaleFactor:0.5];
    [loginDirection setAdjustsFontSizeToFitWidth:YES];
    loginDirection.textColor = [UIColor whiteColor];
    loginDirection.font = [UIFont fontWithName:@"Eraser" size:27];
    loginDirection.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:loginDirection];
    
    UILabel *disclaimerLabel = [UILabel new];
    [disclaimerLabel setNumberOfLines:0];
    [disclaimerLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14]];
    [disclaimerLabel setTextColor:[UIColor lightGrayColor]];
    [disclaimerLabel setText:@"Don't worry, we will never share this information with anybody. Your information is safe with us!"];
    [self.view addSubview:disclaimerLabel];
    
    if ([self.userType isEqualToString:@"Teacher"]) {
        loginDirection.text = @"Tell us about yourself!\nLet your students know who you are";
    }
    else{
        loginDirection.text = @"Tell us about yourself!\nLet your teachers and classmates know who you are";
    }
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(createProfile)];
    self.navigationItem.rightBarButtonItem=rightBarButton;
    
    self.firstNameField = [[UITextField alloc]initWithFrame:CGRectMake(5,4, 275, 30)];
    self.firstNameField.placeholder = @"First Name";
    self.firstNameField.borderStyle = UITextBorderStyleNone;
    self.firstNameField.delegate = self;
    [self.firstNameField addTarget:self action:@selector(checkFields) forControlEvents:UIControlEventEditingChanged];
    [textfieldThree addSubview:_firstNameField];
    
    self.lastNameField = [[UITextField alloc]initWithFrame:CGRectMake(5,39, 275, 30)];
    self.lastNameField.placeholder = @"Last Name";
    self.lastNameField.borderStyle = UITextBorderStyleNone;
    self.lastNameField.delegate=self;
    [self.lastNameField addTarget:self action:@selector(checkFields) forControlEvents:UIControlEventEditingChanged];
    [textfieldThree addSubview:_lastNameField];
    
    self.genderField = [[UITextField alloc]initWithFrame:CGRectMake(5,72, 275, 30)];
    self.genderField.placeholder = @"Gender";
    self.genderField.borderStyle = UITextBorderStyleNone;
    self.genderField.delegate=self;
    [self.genderField addTarget:self action:@selector(checkFields) forControlEvents:UIControlEventEditingChanged];
    [textfieldThree addSubview:_genderField];
    
    [self genderPicker];
    [self checkFields];

//    if (IS_IPHONE) {
//        [backgroundView setFrame:self.view.frame];
//        [loginDirection setFrame:CGRectMake((self.view.frame.size.width/2)-(300/2),64,300, 70)];
//        
//        [textfieldThree setFrame:CGRectMake(20,loginDirection.frame.origin.y+loginDirection.frame.size.height, 280, 104)];
//        [disclaimerLabel setFrame:CGRectMake(20, textfieldThree.frame.origin.y+textfieldThree.frame.size.height, 280,60)];
//        
//        self.pencilImage = [[BouncingPencil alloc]initWithFrame:CGRectMake(220, 44, 60, 60)];
//        self.pencilImage.hidden=YES;
//        [self.pencilImage setUpPencilBounceFrame:self.pencilImage.frame targetX:15 targetY:-9 rotation:5*M_PI_4];
//        [self.view addSubview:self.pencilImage];
//
//        
//    }
//    else{


        backgroundView.translatesAutoresizingMaskIntoConstraints=NO;
        loginDirection.translatesAutoresizingMaskIntoConstraints=NO;
        textfieldThree.translatesAutoresizingMaskIntoConstraints=NO;
        disclaimerLabel.translatesAutoresizingMaskIntoConstraints=NO;
        
        //bouncing pencil constraints
        self.pencilImage = [[BouncingPencil alloc]init];
        self.pencilImage.hidden=YES;
        [self.view addSubview:self.pencilImage];


        _pencilImage.translatesAutoresizingMaskIntoConstraints=NO;
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-45-[_pencilImage(60)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_pencilImage)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_pencilImage(60)]-50-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_pencilImage)]];
        [_pencilImage setUpPencilBounceForiPad:CGSizeMake(60, 60) targetX:15 targetY:-9 rotation:5*M_PI_4];

        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[backgroundView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(backgroundView)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[backgroundView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(backgroundView)]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-30-[loginDirection]-30-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(loginDirection)]];

        
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-64-[loginDirection(90)]-40-[textfieldThree(104)]-5-[disclaimerLabel(65)]" options:NSLayoutFormatAlignAllCenterX metrics:nil views:NSDictionaryOfVariableBindings(textfieldThree,loginDirection,disclaimerLabel)]];
        [textfieldThree addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[textfieldThree(300)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(textfieldThree)]];
        [disclaimerLabel addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[disclaimerLabel(300)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(disclaimerLabel)]];
        

//    }

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.firstNameField becomeFirstResponder];
}



-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];

}

-(void)checkFields{
    
    if ([self.firstNameField.text isEqualToString:@""]||[self.lastNameField.text isEqualToString:@""]||[self.genderField.text isEqualToString:@""]) {
        self.navigationItem.rightBarButtonItem.enabled= NO;
        self.pencilImage.hidden=YES;

    }
    else{
        self.navigationItem.rightBarButtonItem.enabled=YES;
        self.pencilImage.hidden=NO;


    }
}

-(void)createProfile{
    
    //add object to classlist
    NSString *firstNameCap = [self.firstNameField.text capitalizedString];
    NSString *lastNameCap = [self.lastNameField.text capitalizedString];
    
    //make sure trailing white spaces are gone
    firstNameCap = [firstNameCap stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    lastNameCap = [lastNameCap stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    int userNumType = 0;

    if([self.userType isEqualToString:@"Teacher"]){
        userNumType=0;
    }else{
        userNumType=1;
    }

    InsertWebService *insertUser = [[InsertWebService alloc]initWithTable:@"User"];
    [insertUser insertObjectInColumnWhere:@"Email" setObjectValue:self.createParam[@"Email"]];
    [insertUser insertObjectInColumnWhere:@"Password" setObjectValue:self.createParam[@"Password"]];
    [insertUser insertObjectInColumnWhere:@"UserType" setObjectValue:[NSString stringWithFormat:@"%d",userNumType]];
    [insertUser insertObjectInColumnWhere:@"FirstName" setObjectValue:firstNameCap];
    [insertUser insertObjectInColumnWhere:@"LastName" setObjectValue:lastNameCap];
    [insertUser insertObjectInColumnWhere:@"Gender" setObjectValue:self.genderField.text];
    [insertUser insertObjectInColumnWhere:@"UniversalToken" setObjectValue:[[NSProcessInfo processInfo] globallyUniqueString]];
    [insertUser saveTheUserInDatabaseInBackground:^(NSError *error, id result) {
        if (error) {
            if (error.code == 400) {
                NSLog(@"DUPLICATE!");
            }
        }else{
            
            if ([self.userType isEqualToString:@"Teacher"]) {
                
                if ([self.genderField.text isEqualToString:@"Male"]) {
                    self.teachersName =[NSString stringWithFormat:@"Mr. %@",lastNameCap];
                }
                else if ([self.genderField.text isEqualToString:@"Female"]){
                    self.teachersName =[NSString stringWithFormat:@"Ms. %@",lastNameCap];
                }
                else{
                    self.teachersName = @"ERROR";
                }
                
                InsertWebService *insertTeacherObject = [[InsertWebService alloc]initWithTable:@"TeacherObject"];
                [insertTeacherObject insertObjectInColumnWhere:@"teacherId" setObjectValue:result[@"ObjectId"]];
                [insertTeacherObject insertObjectInColumnWhere:@"teacherName" setObjectValue:self.teachersName];
                [insertTeacherObject insertObjectInColumnWhere:@"ClassList" setObjectValue:@"[]"];
                [insertTeacherObject saveIntoDatabase];
                
            }

            // Store the data
            
            [MyUser storeDefaults:result];
            
            self.navigationItem.hidesBackButton=NO;
            [self performSegueWithIdentifier:@"signUpEndSegue" sender:self];
        }

    }];
    
}

-(void)genderPicker{
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(donePicker)];
    NSArray *toolbarItems = [NSArray arrayWithObjects: doneButton, nil];
    
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-self.pickerGender.frame.size.height-44, 320, 44)];
    [toolBar setBarStyle:UIBarStyleDefault];
    [toolBar setItems:toolbarItems];
    self.genderField.inputView = self.pickerGender;
    self.genderField.inputAccessoryView = toolBar;
}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    [self.genderField setText:[self.pickerArray objectAtIndex:row]];
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

-(void)donePicker{
    [_pickerGender removeFromSuperview];
    self.pickerGender =nil;
    [_genderField resignFirstResponder];
    [self checkFields];

}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"signUpEndSegue"]) {
        ClassTableViewController *classTableVC = (ClassTableViewController*)segue.destinationViewController;
        classTableVC.demoManagedObjectContext=self.demoManagedObjectContext;
        classTableVC.managedObjectContext=self.managedObjectContext;
        classTableVC.isNewUser=YES;
    }

}


@end
