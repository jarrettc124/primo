//
//  EditStoreViewController.m
//  TeacherApp
//
//  Created by Jarrett Chen on 3/4/14.
//  Copyright (c) 2014 Jarrett Chen. All rights reserved.
//

#import "EditStoreViewController.h"

@interface EditStoreViewController ()


@end

@implementation EditStoreViewController

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
    //initialize the store
    
    
    // toolbar
    self.toolbar = [[UINavigationBar alloc] init];
    self.item = [[UINavigationItem alloc]init];
    self.item.hidesBackButton = YES;
    self.toolbar.barTintColor = [UIColor colorWithRed:0.0705882 green:0.082353 blue:0.243137 alpha:1];
    [self.toolbar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self.toolbar setTintColor:[UIColor whiteColor]];
    [self.toolbar pushNavigationItem:self.item animated:NO];
    [self.view addSubview:self.toolbar];
    
    UIImage *storeEditImage = [UIImage imageNamed:@"storeEdit"];
    UIImageView *storeEditView = [[UIImageView alloc]initWithImage:storeEditImage];
    storeEditView.contentMode=UIViewContentModeScaleAspectFill;
    [self.view addSubview:storeEditView];
    
    UILabel *askStoreLabel = [[UILabel alloc]init];
    askStoreLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
    askStoreLabel.numberOfLines =0;
    [askStoreLabel setText:@"By setting up your store, you allow students to purchase different items with their coins.\n\nWould you like to set up your store?"];
    [askStoreLabel sizeToFit];
    [self.view addSubview:askStoreLabel];
    

    self.setUpButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.setUpButton setTag:200];
    [self.view addSubview:_setUpButton];
    
    self.skipButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.skipButton setTag:100];
    [self.view addSubview:_skipButton];

    self.item.title = @"Store";
    
    if (IS_IPAD) {
        self.toolbar.translatesAutoresizingMaskIntoConstraints=NO;
        storeEditView.translatesAutoresizingMaskIntoConstraints=NO;
        askStoreLabel.translatesAutoresizingMaskIntoConstraints=NO;
        self.setUpButton.translatesAutoresizingMaskIntoConstraints=NO;
        self.skipButton.translatesAutoresizingMaskIntoConstraints=NO;
        
        //set Bigger Fonts
        askStoreLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:21];
        self.setUpButton.titleLabel.font = [UIFont systemFontOfSize:21];
        self.skipButton.titleLabel.font = [UIFont systemFontOfSize:19];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:storeEditView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        
        //Horizontal Constraints
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_toolbar]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_toolbar)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-110-[askStoreLabel]-110-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(askStoreLabel)]];
        [self.setUpButton addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_setUpButton(208)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_setUpButton)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-268-[_skipButton]-133-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_skipButton)]];
        

        
         //Vertical Constraints
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_toolbar(64)]-58-[storeEditView(350)]-20-[askStoreLabel(100)]-20-[_setUpButton(78)]-5-[_skipButton(40)]" options:NSLayoutFormatAlignAllCenterX metrics:nil views:NSDictionaryOfVariableBindings(_toolbar,storeEditView,askStoreLabel,_setUpButton,_skipButton)]];
         
        
    }
    else if (IS_IPHONE){

        self.toolbar.frame = CGRectMake(0, 0, self.view.frame.size.width, 64);
        [storeEditView setFrame:CGRectMake(self.view.frame.size.width/2-(storeEditImage.size.width/2), 73,storeEditImage.size.width,storeEditImage.size.height)];
        [askStoreLabel setFrame:CGRectMake((self.view.frame.size.width/2)-(280/2), 324, 280, 70)];
        self.setUpButton.frame = CGRectMake(self.view.frame.size.width/2 - 100, 434, 200, 60);
        _skipButton.frame = CGRectMake(self.view.frame.size.width/2-85, self.setUpButton.frame.origin.y+self.setUpButton.frame.size.height, 200, 27);
        
        if (self.view.frame.size.height<568) {
            NSLog(@"short");
            [storeEditView setFrame:CGRectMake(storeEditView.frame.origin.x+10, storeEditView.frame.origin.y-8, storeEditView.frame.size.width-20, storeEditView.frame.size.height-20)];
            askStoreLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
            [askStoreLabel setFrame:CGRectMake(askStoreLabel.frame.origin.x+10, askStoreLabel.frame.origin.y-22, askStoreLabel.frame.size.width-20, askStoreLabel.frame.size.height)];
            [self.setUpButton setFrame:CGRectMake(self.setUpButton.frame.origin.x-5, self.setUpButton.frame.origin.y-40, self.setUpButton.frame.size.width-10, self.setUpButton.frame.size.height-10)];
            [self.skipButton setFrame:CGRectMake(self.skipButton.frame.origin.x,self.setUpButton.frame.origin.y+self.setUpButton.frame.size.height, self.skipButton.frame.size.width,self.skipButton.frame.size.height)];
        }

    }
    

}

-(void)viewWillAppear:(BOOL)animated{

    
    [_setUpButton addTarget:self action:@selector(segueButtonActions:) forControlEvents:UIControlEventTouchUpInside];
    [_setUpButton setTitle:@"Set Up!" forState:UIControlStateNormal];
    self.setUpButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.setUpButton setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal ];
    self.setUpButton.backgroundColor = [UIColor colorWithRed:0.0705882 green:0.082353 blue:0.243137 alpha:1];

    
    [_skipButton addTarget:self action:@selector(segueButtonActions:) forControlEvents:UIControlEventTouchUpInside];
    [_skipButton setTitle:@"Skip, set up next time." forState:UIControlStateNormal];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)segueButtonActions:(UIButton*)sender{
    
    if (sender.tag == 100) { //skipbutton
        [self performSegueWithIdentifier:@"stuTable" sender:self];
    }
    else if(sender.tag == 200){ //add store items
        [self performSegueWithIdentifier:@"newAddStoreSegue" sender:self];
    }

}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"stuTable"]) {
        // if the cell selected segue was fired, edit the selected note
        ClassTableViewController *classTableVC = (ClassTableViewController*)segue.destinationViewController;
        classTableVC.managedObjectContext=_managedObjectContext;
    }
    else if ([segue.identifier isEqualToString:@"newAddStoreSegue"]){
        AddStoreViewController *addVC = (AddStoreViewController*)segue.destinationViewController;
        addVC.managedObjectContext=_managedObjectContext;
        addVC.previousSegue=segue.identifier;
    }
    
}

@end
