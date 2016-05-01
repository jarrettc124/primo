//
//  DemoPieViewController.m
//  Primo
//
//  Created by Jarrett Chen on 8/27/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import "DemoPieViewController.h"

@interface DemoPieViewController ()

@property (nonatomic,strong) NSMutableArray *slices;
@property (nonatomic,strong) NSArray *sliceColors;
@property (nonatomic,strong) XYPieChart *pieChart;
@property (nonatomic,strong) UILabel *sliceLabel;
@property (nonatomic,strong) NSMutableArray *transArray;

@property (nonatomic,strong) UITapGestureRecognizer *gestureRecognizer;

@end

@implementation DemoPieViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //set color for navigation bar

    if([_userType isEqualToString:@"Teacher"]){
        UIBarButtonItem *logButton = [[UIBarButtonItem alloc]initWithTitle:@"Log" style:UIBarButtonItemStylePlain target:self action:@selector(logButtonSegue)];
        [self.navigationItem setRightBarButtonItem:logButton];
        
    }
    
    UIImageView *backgroundView = [UIImageView new];
    [backgroundView setImage:[UIImage imageNamed:@"blackboardBackground"]];
    backgroundView.userInteractionEnabled=YES;
    [self.view addSubview:backgroundView];
    
    UILabel *studentNameLabel = [UILabel new];
    [studentNameLabel setText:[NSString stringWithFormat:@"%@'s Stats",self.selectedStudent.studentName]];
    [studentNameLabel setTextColor:[UIColor whiteColor]];
    [studentNameLabel setNumberOfLines:0];
    [studentNameLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:studentNameLabel];

    self.sliceLabel = [[UILabel alloc]init];
    [self.sliceLabel setTextAlignment:NSTextAlignmentCenter];
    self.sliceLabel.adjustsFontSizeToFitWidth=YES;
    self.sliceLabel.minimumScaleFactor=0.5;
    [self.sliceLabel setTextColor:[UIColor whiteColor]];
    [self.sliceLabel setText:@"Pick a color!"];
    [self.view addSubview:self.sliceLabel];
    
    


    if (IS_IPHONE) {
        [backgroundView setFrame:self.view.frame];
        [studentNameLabel setFont:[UIFont fontWithName:@"Eraser" size:20]];
        [self.sliceLabel setFont:[UIFont fontWithName:@"Eraser" size:19]];


        self.pieChart = [[XYPieChart alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 150, 105,300, 300)];
        [self.view addSubview:self.pieChart];
        [studentNameLabel setFrame:CGRectMake((self.view.frame.size.width - 280)/2, 70, 280, 60)];
        [self.sliceLabel setFrame:CGRectMake(5, self.pieChart.frame.origin.y+300, self.view.frame.size.width-10, 40)];
    }
    else if (IS_IPAD){
        [studentNameLabel setFont:[UIFont fontWithName:@"Eraser" size:26]];
        [self.sliceLabel setFont:[UIFont fontWithName:@"Eraser" size:23]];
        
        self.pieChart = [[XYPieChart alloc]initWithFrame:CGRectMake(0,0,400, 400)];
        [self.view addSubview:self.pieChart];
        
        self.pieChart.translatesAutoresizingMaskIntoConstraints=NO;
        studentNameLabel.translatesAutoresizingMaskIntoConstraints=NO;
        self.sliceLabel.translatesAutoresizingMaskIntoConstraints=NO;
        backgroundView.translatesAutoresizingMaskIntoConstraints=NO;
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[backgroundView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(backgroundView)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[backgroundView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(backgroundView)]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.pieChart attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.pieChart attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[studentNameLabel]-50-[_pieChart(400)]-50-[_sliceLabel]" options:NSLayoutFormatAlignAllCenterX metrics:nil views:NSDictionaryOfVariableBindings(studentNameLabel,_pieChart,_sliceLabel)]];
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
    
    if ([self.userType isEqualToString:@"Teacher"]) {
        NSError *error;
        NSFetchRequest *studentsRequest = [NSFetchRequest fetchRequestWithEntityName:@"DemoEconomy"];
        studentsRequest.predicate= [NSPredicate predicateWithFormat:@"userId = %@",self.selectedStudent.objectId];
        NSArray *studentObjArray = [_demoManagedObjectContext executeFetchRequest:studentsRequest error:&error];
        self.transArray = [[NSMutableArray alloc]initWithArray:studentObjArray];

        int totalEarn = 0;
        int totalTaken = 0;
        int totalSpentInStore =0;
            
            for(DemoEconomy *eachTransaction in self.transArray){
                
                if ([eachTransaction.type isEqualToString:@"Teacher"]) {
                    
                    totalEarn+= [eachTransaction.earn intValue];
                    totalTaken+= [eachTransaction.spent intValue];
                    
                }
                else{
                    
                    totalSpentInStore+=[eachTransaction.spent intValue];
                    
                }
                
                
            }
            
            [self.slices addObject:@(totalEarn)];
            [self.slices addObject:@(totalSpentInStore)];
            [self.slices addObject:@(totalTaken)];
        
    }
    else{
        [self.slices addObject:@12];
        [self.slices addObject:@9];
        [self.slices addObject:@22];
    }
    
}

- (void)viewDidUnload
{
    [self setPieChart:nil];
    [super viewDidUnload];
}

-(void)viewDidAppear:(BOOL)animated{
    
    self.gestureRecognizer =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideDirection)];
    
    UIView *directionStats = [UIView new];
    [directionStats setTag:1000];
    [self.view addSubview:directionStats];
    [directionStats addGestureRecognizer:self.gestureRecognizer];
    
    UIImageView *blackboardDirection = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"blackboardBorder"]];
    [blackboardDirection setTag:2000];
    [blackboardDirection setAlpha:0];
    [blackboardDirection setUserInteractionEnabled:YES];
    [directionStats addSubview:blackboardDirection];
    
    if (IS_IPHONE) {
        [directionStats setFrame:self.view.frame];
        [blackboardDirection setFrame:CGRectMake((self.view.frame.size.width - 320)/2, 105, 320, 250)];
    }
    else if (IS_IPAD){
        directionStats.translatesAutoresizingMaskIntoConstraints=NO;
        blackboardDirection.translatesAutoresizingMaskIntoConstraints=NO;
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[directionStats]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(directionStats)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[directionStats]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(directionStats)]];
        
        [directionStats addConstraint:[NSLayoutConstraint constraintWithItem:blackboardDirection attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:directionStats attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [directionStats addConstraint:[NSLayoutConstraint constraintWithItem:blackboardDirection attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:directionStats attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        
        [blackboardDirection addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[blackboardDirection(300)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(blackboardDirection)]];
        [blackboardDirection addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[blackboardDirection(300)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(blackboardDirection)]];
    }
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [blackboardDirection setAlpha:1];
        [blackboardDirection setTransform:CGAffineTransformMakeScale(0.9, 0.9)];
        
    } completion:^(BOOL finished) {
        
        UILabel *directionLabel = [UILabel new];
        [directionLabel setFont:[UIFont fontWithName:@"Eraser" size:19]];
        [directionLabel setNumberOfLines:0];
        [directionLabel setTextColor:[UIColor whiteColor]];
        [directionLabel setFrame:CGRectMake(10, 15, blackboardDirection.frame.size.width-20, blackboardDirection.frame.size.height-30)];
        [blackboardDirection addSubview:directionLabel];
        
        if ([self.userType isEqualToString:@"Teacher"]) {
            [directionLabel setText:@"This pie chart shows the progress of the selected students.\n\n You may show this to parents to help them visualize how their child is doing in class."];
        }
        else{
            [directionLabel setText:@"This pie chart shows the progress on how you're spending your coins in class. \n Pick a color and have fun!"];
        }
        
    }];
    
}

-(void)hideDirection{
    
    
    UIView *backgroundView = [self.view viewWithTag:1000];
    
    
    UIImageView *blackboardImageView = (UIImageView*)[backgroundView viewWithTag:2000];
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        [blackboardImageView setTransform:CGAffineTransformMakeScale(10/9, 10/9)];
        [blackboardImageView setAlpha:0];
        
    } completion:^(BOOL finished) {
        
        [backgroundView removeFromSuperview];
        
        [self.pieChart reloadData];

    }];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [self hideDirection];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)logButtonSegue{
    if ([self.userType isEqualToString:@"Teacher"]) {
        [self performSegueWithIdentifier:@"demoPieEndSegue" sender:self];
    }
    else{
        [self performSegueWithIdentifier:@"demoPieStuSegue" sender:self];
    }
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"demoPieEndSegue"]||[segue.identifier isEqualToString:@"demoPieStuSegue"]){
        DemoEndViewController *endVC = (DemoEndViewController*)segue.destinationViewController;
        endVC.previousSegue = segue.identifier;
        endVC.demoManagedObjectContext=self.demoManagedObjectContext;
        endVC.managedObjectContext=self.managedObjectContext;
    }
}


@end
