//
//  PieChartViewController.m
//  Primo
//
//  Created by Jarrett Chen on 8/23/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import "PieChartViewController.h"

@interface PieChartViewController ()

@property (nonatomic,strong) NSMutableArray *slices;
@property (nonatomic,strong) NSArray *sliceColors;
@property (nonatomic,strong) XYPieChart *pieChart;
@property (nonatomic,strong) UILabel *sliceLabel;
@property (nonatomic,strong) UIButton *pieTime;
@property (nonatomic,strong) NSArray *pickerArray;
@property (nonatomic) int monthNumber;
@property (nonatomic,strong) UIPickerView *pickerMonthView;
@property (nonatomic,strong) NSMutableArray *transArray;
@property (nonatomic,strong) UIToolbar *pickerToolBar;

@end

@implementation PieChartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    

    NSString *userType = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserType"];
    
    
    if([userType isEqualToString:@"Teacher"]){
        UIBarButtonItem *logButton = [[UIBarButtonItem alloc]initWithTitle:@"Log" style:UIBarButtonItemStylePlain target:self action:@selector(logButtonSegue)];
        [self.navigationItem setRightBarButtonItem:logButton];
    }
    
    UIImageView *backgroundView = [UIImageView new];
    [backgroundView setImage:[UIImage imageNamed:@"blackboardBackground"]];
    backgroundView.userInteractionEnabled=YES;
    [self.view addSubview:backgroundView];
    
    self.pieTime = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.pieTime setTitle:[NSString stringWithFormat:@"Current Month: Lifetime\nClick here to choose your month"] forState:UIControlStateNormal];
    [self.pieTime.titleLabel setTextAlignment:NSTextAlignmentCenter];
    self.pieTime.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.pieTime setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.pieTime addTarget:self action:@selector(chooseMonthAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.pieTime];
    
    self.sliceLabel = [[UILabel alloc]init];
    [self.sliceLabel setTextAlignment:NSTextAlignmentCenter];
    self.sliceLabel.adjustsFontSizeToFitWidth=YES;
    self.sliceLabel.minimumScaleFactor=0.5;
    [self.sliceLabel setFont:[UIFont fontWithName:@"Eraser" size:19]];
    [self.sliceLabel setTextColor:[UIColor whiteColor]];
    [self.sliceLabel setText:@"Loading..."];
    [self.view addSubview:self.sliceLabel];
    
    if (IS_IPHONE) {
        
        [self.navigationItem setTitle:[NSString stringWithFormat:@"%@'s Analysis",self.selectedStudent.studentName]];
        
        [backgroundView setFrame:self.view.frame];
        
        [self.pieTime setFrame:CGRectMake(0, 64, self.view.frame.size.width, 60)];
        self.pieChart = [[XYPieChart alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 150, self.pieTime.frame.origin.y+self.pieTime.frame.size.height,300, 300)];
        [self.view addSubview:self.pieChart];
        [self.sliceLabel setFrame:CGRectMake(5, self.pieChart.frame.origin.y+300, self.view.frame.size.width-10, 40)];
    }
    else if (IS_IPAD){
        //have the student Name in there only for ipad
        UILabel *studentNameLabel = [UILabel new];
        [studentNameLabel setText:[NSString stringWithFormat:@"%@'s Stats",self.selectedStudent.studentName]];
        [studentNameLabel setTextColor:[UIColor whiteColor]];
        [studentNameLabel setNumberOfLines:0];
        [studentNameLabel setTextAlignment:NSTextAlignmentCenter];
        [self.view addSubview:studentNameLabel];
        
        self.pieChart = [[XYPieChart alloc]initWithFrame:CGRectMake(0,0,400, 400)];
        [self.view addSubview:self.pieChart];
        
        backgroundView.translatesAutoresizingMaskIntoConstraints=NO;
        self.pieChart.translatesAutoresizingMaskIntoConstraints=NO;
        studentNameLabel.translatesAutoresizingMaskIntoConstraints=NO;
        self.sliceLabel.translatesAutoresizingMaskIntoConstraints=NO;
        self.pieTime.translatesAutoresizingMaskIntoConstraints=NO;
        
        [studentNameLabel setFont:[UIFont fontWithName:@"Eraser" size:29]];
        [self.sliceLabel setFont:[UIFont fontWithName:@"Eraser" size:23]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[backgroundView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(backgroundView)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[backgroundView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(backgroundView)]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.pieChart attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.pieChart attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        
       [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[studentNameLabel]-40-[_pieTime(60)]-[_pieChart(400)]-50-[_sliceLabel]" options:NSLayoutFormatAlignAllCenterX metrics:nil views:NSDictionaryOfVariableBindings(studentNameLabel,_pieChart,_sliceLabel,_pieTime)]];
        [self.pieChart addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_pieChart(400)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_pieChart)]];
        
    }
    
    [self.pieChart setDelegate:self];
    [self.pieChart setDataSource:self];
    [self.pieChart setStartPieAngle:M_PI_2];
    [self.pieChart setAnimationSpeed:1.0];
    [self.pieChart setLabelRadius:105];
    [self.pieChart setLabelFont:[UIFont fontWithName:@"HelveticaNeue" size:24]];
    [self.pieChart setPieBackgroundColor:[UIColor colorWithWhite:0.4 alpha:0.3]];
    [self.pieChart setLabelShadowColor:[UIColor blackColor]];
    
    self.sliceColors =[NSArray arrayWithObjects:[UIColor greenColor],[UIColor yellowColor],[UIColor redColor],nil];
    self.slices = [[NSMutableArray alloc]initWithCapacity:0];

    QueryWebService *queryInfo = [[QueryWebService alloc]initWithTable:@"Economy"];
    [queryInfo selectColumnWhere:@"ObjectId" equalTo:self.selectedStudent.objectId];
    [queryInfo findAllObjectsInRowWithCompletion:^(NSError *error, NSArray *rows) {
        
        self.transArray = [[NSMutableArray alloc]initWithArray:rows];
        
        int totalEarn = 0;
        int totalTaken = 0;
        int totalSpentInStore =0;
        
        for(NSDictionary *eachTransaction in rows){
            
            if ([eachTransaction[@"Type"] isEqualToString:@"Teacher"]) {
                
                totalEarn+= [eachTransaction[@"Earn"] intValue];
                totalTaken+= [eachTransaction[@"Spent"] intValue];
                
            }
            else{
                
                totalSpentInStore+=[eachTransaction[@"Spent"] intValue];
                
            }
            
            
        }
        
        [self.slices addObject:@(totalEarn)];
        [self.slices addObject:@(totalSpentInStore)];
        [self.slices addObject:@(totalTaken)];
        [self.sliceLabel setText:@"Pick a color!"];
        [self.pieChart reloadData];

        
    }];
    
}

- (void)viewDidUnload
{
    [self setPieChart:nil];
    [super viewDidUnload];
}

-(void)viewDidAppear:(BOOL)animated{
    [self.pieChart reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)logButtonSegue{
    
    [self performSegueWithIdentifier:@"studentLogSegue" sender:self];
}

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    return [self.slices count];
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    return [[self.slices objectAtIndex:index] intValue];
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
//    if(pieChart == self.pieChart) return nil;
    return [self.sliceColors objectAtIndex:(index % self.sliceColors.count)];
}

#pragma mark - XYPieChart Delegate
- (void)pieChart:(XYPieChart *)pieChart willSelectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"will select slice at index %d",index);
    
    switch (index) {
        case 0:
            [self.sliceLabel setText:[NSString stringWithFormat:@"%@ Total Coins Earned",[self.slices objectAtIndex:index]]];
            break;
        case 1:
            [self.sliceLabel setText:[NSString stringWithFormat:@"%@ Total Coins Spent in Store",[self.slices objectAtIndex:index]]];
            break;
        case 2:
            [self.sliceLabel setText:[NSString stringWithFormat:@"%@ Total Coins Taken Away",[self.slices objectAtIndex:index]]];
        default:
            break;
    }

    
}
- (void)pieChart:(XYPieChart *)pieChart willDeselectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"will deselect slice at index %d",index);
    
    [self.sliceLabel setText:@"Pick a color!"];
    
}
- (void)pieChart:(XYPieChart *)pieChart didDeselectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"did deselect slice at index %d",index);
}
- (void)pieChart:(XYPieChart *)pieChart didSelectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"did select slice at index %d",index);
}

//picker sort
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (row==0){
        [pickerView selectRow:1 inComponent:component animated:YES];
        self.monthNumber =0;
    }
    else if (row==1){
        self.monthNumber =0;
    }
    else{
        self.monthNumber = row-1;
    }
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if (row==0 || row==1) {
        return [_pickerArray objectAtIndex:row];
    }
    else{
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        NSString *monthName = [[df monthSymbols] objectAtIndex:(row-2)];
        return monthName;
    }
    
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [_pickerArray count]+12;
}


-(void)chooseMonthAction{
    
    if(self.pickerMonthView ==nil){
        
        self.pickerArray = [[NSArray alloc]initWithObjects:@"Pick One",@"Lifetime", nil];
        self.pickerMonthView = [[UIPickerView alloc]init];
        self.pickerMonthView.delegate=self;
        self.pickerMonthView.dataSource=self;
        self.pickerMonthView.userInteractionEnabled=YES;
        [self.pickerMonthView setBackgroundColor:[UIColor whiteColor]];
        
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(pickerButtonAction)];
        [doneButton setTag:500];
        
        NSArray *toolbarItems = [NSArray arrayWithObjects: doneButton, nil];
        
        self.pickerToolBar = [[UIToolbar alloc]init];
        [self.pickerToolBar setTag:200];
        [self.pickerToolBar setBarStyle:UIBarStyleDefault];
        [self.pickerToolBar setItems:toolbarItems];
        
        [self.view addSubview:self.pickerMonthView];
        [self.view addSubview:self.pickerToolBar];
        
        
        if (IS_IPHONE) {
            [self.pickerMonthView setFrame:CGRectMake(self.view.frame.origin.x,self.view.frame.size.height-162, self.view.frame.size.width,162)];
            [self.pickerToolBar setFrame:CGRectMake(self.view.frame.origin.x,self.view.frame.size.height-self.pickerMonthView.frame.size.height-44,self.view.frame.size.width, 44)];
        }
        else if (IS_IPAD){
            self.pickerToolBar.translatesAutoresizingMaskIntoConstraints=NO;
            self.pickerMonthView.translatesAutoresizingMaskIntoConstraints=NO;
            
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_pickerToolBar]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_pickerToolBar)]];
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_pickerMonthView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_pickerMonthView)]];
            
        
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_pickerToolBar(44)]-0-[_pickerMonthView(170)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_pickerMonthView,_pickerToolBar)]];
            
        }
        
    }
}

-(void)pickerButtonAction{
    
    
    if (self.monthNumber == 0) {

        [self.pieTime setTitle:[NSString stringWithFormat:@"Current Month: Lifetime\nClick here to choose your month"] forState:UIControlStateNormal];
      
    }
    else{
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        NSString *monthName = [[df monthSymbols] objectAtIndex:(self.monthNumber-1)];
        
        [self.pieTime setTitle:[NSString stringWithFormat:@"Current Month: %@\nClick here to choose your month",monthName] forState:UIControlStateNormal];
    }



        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
            
            
            self.pickerMonthView.frame=CGRectMake(self.pickerMonthView.frame.origin.x,self.view.frame.size.height, self.pickerMonthView.frame.size.width, self.pickerMonthView.frame.size.height);
            [self.pickerToolBar setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 44)];
            
        } completion:^(BOOL finished) {
            
            int totalEarn = 0;
            int totalTaken = 0;
            int totalSpentInStore =0;
            
            for(NSDictionary *eachTransaction in self.transArray){
                

                if ([eachTransaction[@"Month"] intValue] == self.monthNumber) {
                    
                    if ([eachTransaction[@"Type"] isEqualToString:@"Teacher"]) {

                        totalEarn+= [eachTransaction[@"Earn"] intValue];
                        totalTaken+= [eachTransaction[@"Spent"] intValue];
                    }
                    else{
                        totalSpentInStore+= [eachTransaction[@"Spent"] intValue];
                    }
                    
                }
                else if(self.monthNumber == 0){
                    if ([eachTransaction[@"Type"] isEqualToString:@"Teacher"]) {
                        
                        totalEarn+= [eachTransaction[@"Earn"] intValue];
                        totalTaken+= [eachTransaction[@"Spent"] intValue];
                    }
                    else{
                        totalSpentInStore+= [eachTransaction[@"Spent"] intValue];
                    }
                }
                
            }
            
            [self.slices removeAllObjects];
            [self.slices addObject:@(totalEarn)];
            [self.slices addObject:@(totalSpentInStore)];
            [self.slices addObject:@(totalTaken)];
            
            [self.pieChart reloadData];
            
            [self.pickerToolBar removeFromSuperview];
            self.pickerToolBar=nil;
            [self.pickerMonthView removeFromSuperview];
            self.pickerMonthView=nil;
        }];
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"studentLogSegue"]){
        MonthLogViewController *monthVC = (MonthLogViewController*)segue.destinationViewController;
        monthVC.selectedStudentObjFromClassTable = self.selectedStudent;
        monthVC.previousSegue = segue.identifier;
        monthVC.demoManagedObjectContext=self.demoManagedObjectContext;
    }
}


@end
