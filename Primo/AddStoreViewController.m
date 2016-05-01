//
//  AddStoreViewController.m
//  Primo
//
//  Created by Jarrett Chen on 6/13/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import "AddStoreViewController.h"

@interface AddStoreViewController ()

@property (nonatomic,strong) UIScrollView *scroller;
@property (nonatomic) NSInteger y;
@property (nonatomic) NSInteger i;

@property (nonatomic,strong) NSMutableArray *storeItemArray;
@property (nonatomic,strong) NSMutableArray *storeCostArray;

//keyboard
@property (nonatomic) UITextField *activeField;

@property (nonatomic,strong) UIImageView *previousImageView;

@end

@implementation AddStoreViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *toolbarBackground = [[UIImageView alloc]init];
    [toolbarBackground setImage:[UIImage imageNamed:@"blackboardBar"]];
    toolbarBackground.userInteractionEnabled=YES;
    [self.view addSubview:toolbarBackground];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Done"style:UIBarButtonItemStyleDone target:self action:@selector(addToParseAction)];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
    
    _storeItemArray = [[NSMutableArray alloc]initWithCapacity:0];
    _storeCostArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    self.scroller = [[UIScrollView alloc] init];
    self.scroller.scrollEnabled=YES;
    self.scroller.userInteractionEnabled=YES;
    self.scroller.showsVerticalScrollIndicator=YES;
    self.scroller.contentSize = CGSizeMake(self.view.frame.size.width,self.view.frame.size.height);
    [self.view addSubview:self.scroller];
    
    UIImageView *headerImageView = [[UIImageView alloc]init];
    headerImageView.userInteractionEnabled=YES;
    [self.scroller addSubview:headerImageView];
    headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    UIImage *headerImage= [UIImage imageNamed:@"headerLinedPaper"];
    [headerImageView setImage:headerImage];
    
    //directions for add students view controller
    UILabel *titleDirection = [[UILabel alloc]init];
    titleDirection.numberOfLines=0;
    titleDirection.text = @"Enter your items for your store";
    titleDirection.textColor = [UIColor darkGrayColor];
    [titleDirection setFont:[UIFont fontWithName:@"TravelingTypewriter" size:19]];
    [headerImageView addSubview:titleDirection];
    
    UIButton *presetStoreItemButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [presetStoreItemButton setTitle:[NSString stringWithFormat:@"Click here if you'd like to preset a store for you. \n You made edit it anyway you like!"] forState:UIControlStateNormal];
    
    [presetStoreItemButton.titleLabel setNumberOfLines:0];
    [presetStoreItemButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [presetStoreItemButton.titleLabel setFont:[UIFont fontWithName:@"TravelingTypewriter" size:15]];
    [presetStoreItemButton addTarget:self action:@selector(presetStoreAction) forControlEvents:UIControlEventTouchUpInside];
    [headerImageView addSubview:presetStoreItemButton];
    
    
    if (IS_IPAD) {
        self.scroller.translatesAutoresizingMaskIntoConstraints=NO;
        headerImageView.translatesAutoresizingMaskIntoConstraints=NO;
        toolbarBackground.translatesAutoresizingMaskIntoConstraints=NO;
        
        //horizontal
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[toolbarBackground]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(toolbarBackground)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[toolbarBackground(64)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(toolbarBackground)]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_scroller]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_scroller)]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-64-[_scroller]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_scroller)]];
        [self.scroller addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[headerImageView(==_scroller)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(headerImageView,_scroller)]];
        [self.scroller addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[headerImageView(200)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(headerImageView)]];
        
        //title directions
        titleDirection.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:25];
        [titleDirection setFrame:CGRectMake(200, 64, 380, 50)];
        titleDirection.text = @"Enter your items for your store";
        [presetStoreItemButton setFrame:CGRectMake(200, 120, 380, 90)];
        
        _previousImageView =nil;
        for (_i=0; _i<30;_i++ ) {
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
            
            //textfield itemname
            UITextField *storeItem = [[UITextField alloc] initWithFrame:CGRectMake(210, 13, 120, 30)]; //change
            storeItem.placeholder=[NSString stringWithFormat:@"Item %ld", (long)_i+1];
            storeItem.delegate = self;
            storeItem.tag = _i +1;
            [self.storeItemArray addObject:storeItem];
            
        
            
            [imageView addSubview:storeItem];
            
            //add coinpicture
            UIImageView *coinImage = [[UIImageView alloc]initWithFrame:CGRectMake(462, 10, 30, 30)];
            [coinImage setImage:[UIImage imageNamed:@"goldCoin"]];
            [imageView addSubview:coinImage];
            
            //textfield itemcost
            UITextField *storeCost = [[UITextField alloc] initWithFrame:CGRectMake(494, 12, 65, 30)]; //change
            storeCost.placeholder=@"Cost";
            storeCost.keyboardType=UIKeyboardTypeNumberPad;
            storeCost.tag = _i+1;
            [self.storeCostArray addObject:storeCost];
            storeCost.delegate = self;
            [imageView addSubview:storeCost];

            _previousImageView = imageView;
        }
        
        //addButton at the end
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.translatesAutoresizingMaskIntoConstraints=NO;
        [button setTag:5000];
        [button addTarget:self action:@selector(addStoreItem:) forControlEvents:UIControlEventTouchDown];
        button.layer.cornerRadius=2;
        button.backgroundColor=[UIColor colorWithRed:0.0705882 green:0.082353 blue:0.243137 alpha:1];
        [button setTitle:@"Add an item" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.scroller addSubview:button];
        [button addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[button(180)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(button)]];
        [self.scroller addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.scroller attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        
        [self.scroller addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_previousImageView]-20-[button(50)]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_previousImageView,button)]];

    }
    else if (IS_IPHONE){
        [toolbarBackground setFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
        [self.scroller setFrame:CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y+64,self.view.frame.size.width,self.view.frame.size.height-64)];

        _y = 200;

        [headerImageView setFrame:CGRectMake(self.scroller.frame.origin.x, self.scroller.frame.origin.y-64,self.scroller.frame.size.width , self.y)];

        [titleDirection setFrame:CGRectMake(headerImageView.frame.origin.x+70, headerImageView.frame.origin.y+30, headerImageView.frame.size.width-70, 60)];
        
        [presetStoreItemButton setFrame:CGRectMake(70, 90, headerImageView.frame.size.width-70, 70)];
        
        for (_i=0; _i<10; _i++) {
            
            if (self.view.frame.size.height>_y) {
                
                //first couple of textfields
                [self createStoreItemArray:self.storeItemArray createStoreCostArray:self.storeCostArray scrollerToAdd:self.scroller yPosition:self.y count:_i];
            }
            
            else{
                //if textsFields are larger than the frame.
                [self createStoreItemArray:self.storeItemArray createStoreCostArray:self.storeCostArray scrollerToAdd:self.scroller yPosition:self.y count:_i];
                
                //make scroller bigger
                self.scroller.contentSize = CGSizeMake(self.view.frame.size.width,(_scroller.contentSize.height+40));
                
            }
            _y+=40;
            //for missing one more textfield
        }//end of for loop
        
        //for the add button
        _scroller.contentSize = CGSizeMake(self.view.frame.size.width,(_scroller.contentSize.height)+120);
        //addButton
        [self createAddButtonAtTheEndscrollerToAdd:self.storeItemArray scrollerToAdd:self.scroller yPosition:self.y];
    }
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self registerForKeyboardNotifications];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self removeKeyboardNotification];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createStoreItemArray:(NSMutableArray*)itemArray createStoreCostArray:(NSMutableArray*)costArray scrollerToAdd:(UIScrollView*)scrollView yPosition:(NSInteger)position count:(NSInteger)count{
    
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
    
    
    //textfield itemcost
    UITextField *storeCost = [[UITextField alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 73, 12, 65, 30)];
    storeCost.placeholder=@"Cost";
    storeCost.keyboardType=UIKeyboardTypeNumberPad;
    storeCost.tag = count+1;
    [costArray addObject:storeCost];
    storeCost.delegate = self;
    [imageView addSubview:storeCost];
    
    //add coinpicture
    UIImageView *coinImage = [[UIImageView alloc]initWithFrame:CGRectMake(storeCost.frame.origin.x-30, 10, 30, 30)];
    [coinImage setImage:[UIImage imageNamed:@"goldCoin"]];
    [imageView addSubview:coinImage];
    
    //textfield itemname
    UITextField *storeItem = [[UITextField alloc] initWithFrame:CGRectMake(73, 13, coinImage.frame.origin.x - 79, 30)]; //change
    storeItem.placeholder=[NSString stringWithFormat:@"Item %ld", (long)count+1];
    storeItem.delegate = self;
    storeItem.tag = count +1;
    [itemArray addObject:storeItem];
    
    [imageView addSubview:storeItem];

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
    [button addTarget:self action:@selector(addStoreItem:) forControlEvents:UIControlEventTouchDown];
    button.layer.cornerRadius=2;
    button.backgroundColor=[UIColor colorWithRed:0.0705882 green:0.082353 blue:0.243137 alpha:1];
    [button setTitle:@"Add an item" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.frame = CGRectMake((scrollView.frame.size.width/2)-80, position+40, 180, 35);
    [scrollView addSubview:button];
}

-(void)addStoreItem:(UIButton*)sender{
    
    if (IS_IPAD) {
        UIImageView *imageView = [UIImageView new];
        imageView.translatesAutoresizingMaskIntoConstraints=NO;
        imageView.userInteractionEnabled=YES;
        [self.scroller addSubview:imageView];
        
        UIImage *linedImage = [UIImage imageNamed:@"linedPaper"];
        [imageView setImage:linedImage];
        
        [self.scroller addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[imageView(==_scroller)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(imageView,_scroller)]];

        //textfield itemname
        UITextField *storeItem = [[UITextField alloc] initWithFrame:CGRectMake(210, 13, 120, 30)]; //change
        storeItem.placeholder=[NSString stringWithFormat:@"Item %ld", (long)_i+1];
        storeItem.delegate = self;
        storeItem.tag = _i +1;
        [self.storeItemArray addObject:storeItem];
        
        [imageView addSubview:storeItem];
        
        //add coinpicture
        UIImageView *coinImage = [[UIImageView alloc]initWithFrame:CGRectMake(462, 10, 30, 30)];
        [coinImage setImage:[UIImage imageNamed:@"goldCoin"]];
        [imageView addSubview:coinImage];
        
        //textfield itemcost
        UITextField *storeCost = [[UITextField alloc] initWithFrame:CGRectMake(494, 12, 65, 30)]; //change
        storeCost.placeholder=@"Cost";
        storeCost.keyboardType=UIKeyboardTypeNumberPad;
        storeCost.tag = _i+1;
        [self.storeCostArray addObject:storeCost];
        storeCost.delegate = self;
        [imageView addSubview:storeCost];
        
        _i++;

        //remove previous button
        UIButton *previousButton = (UIButton*)[self.scroller viewWithTag:5000];
        [previousButton removeFromSuperview];
        
        //addButton
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.tag=5000;
        button.translatesAutoresizingMaskIntoConstraints=NO;
        [button addTarget:self action:@selector(addStoreItem:) forControlEvents:UIControlEventTouchDown];
        button.layer.cornerRadius=2;
        button.backgroundColor=[UIColor colorWithRed:0.0705882 green:0.082353 blue:0.243137 alpha:1];
        [button setTitle:@"Add an item" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.scroller addSubview:button];

        [button addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[button(180)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(button)]];
        [self.scroller addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.scroller attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [self.scroller addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_previousImageView]-(0)-[imageView(40)]-20-[button(50)]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_previousImageView,imageView,button)]];
        
        _previousImageView = imageView;
        
        CGPoint bottomOffset = CGPointMake(0,self.scroller.contentSize.height-self.view.bounds.size.height+109);
        
        [_scroller setContentOffset:bottomOffset animated:YES];
    }
    else if (IS_IPHONE){
    
        [self createStoreItemArray:self.storeItemArray createStoreCostArray:self.storeCostArray scrollerToAdd:self.scroller yPosition:self.y count:self.i];

        _scroller.contentSize = CGSizeMake(320,(_scroller.contentSize.height)+40);

        _y+=40;
        _i++;

        [self createAddButtonAtTheEndscrollerToAdd:self.storeItemArray scrollerToAdd:self.scroller yPosition:self.y];

        //scroll to see the button when it is added
        [self.scroller scrollRectToVisible:CGRectMake((self.view.frame.size.width/2)-100, _y, 200, 100) animated:YES];
    
    }
}

//keyboard code

-(void)hideKeyboard{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    UITextField *tf = [_storeCostArray objectAtIndex:_activeField.tag-1];
    [tf becomeFirstResponder];
    return YES;
    
}


- (void)registerForKeyboardNotifications

{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
}

-(void)removeKeyboardNotification{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification

{
    
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    
    _scroller.contentInset = contentInsets;
    
    _scroller.scrollIndicatorInsets = contentInsets;
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField

{
    _activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField

{
    _activeField = nil;
}


//adjust the frame of the content and scrolling
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGRect kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    
    kbSize = [self.view convertRect:kbSize toView:nil];

    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.size.height, 0.0);
    
    _scroller.contentInset = contentInsets;
    
    _scroller.scrollIndicatorInsets = contentInsets;
    
    
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    
    // Your app might not need or want this behavior.
    
    CGRect aRect = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-64, self.view.frame.size.width, self.view.frame.size.height);
    
    aRect.size.height -= kbSize.size.height;
    
    if (!CGRectContainsPoint(aRect, _activeField.frame.origin) ) {
        [_scroller scrollRectToVisible:_activeField.frame animated:YES];
    }
}


-(void)addToParseAction{
    
    //text
    //Loading View
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.navigationItem.hidesBackButton=YES;
    
    UIView *loadingView = [[UIView alloc]initWithFrame:self.view.frame];
    loadingView.backgroundColor = [UIColor blackColor];
    loadingView.alpha=0.5;
    [self.view addSubview:loadingView];
    
    UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-25, (self.view.frame.size.height)/2, 50, 50)];
    [self.view addSubview:loading];
    [loading setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [loading hidesWhenStopped];
    [loading startAnimating];
    
    [self.view endEditing:YES];
    
    NSMutableArray *totalItemsValue = [[NSMutableArray alloc]initWithCapacity:0];
    
    for (int j = 0; j<_i; j++) {
        
        UITextField *sItem = [_storeItemArray objectAtIndex:j];
        UITextField *sCost = [_storeCostArray objectAtIndex:j];
        
        if ( ![sItem.text isEqualToString:@""] && ![sCost.text isEqualToString:@""] ) {
            
            int costInt = [sCost.text intValue];
            NSNumber *costNum = [NSNumber numberWithInt:costInt];
            
            //delete trailing white spaces
            NSString *storeItemName = [sItem.text capitalizedString];
            storeItemName = [storeItemName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            NSString *objId = [[NSUserDefaults standardUserDefaults] objectForKey:@"ObjectId"];
            
            NSArray *itemArray = @[storeItemName,[costNum stringValue],objId];
            [totalItemsValue addObject:itemArray];

        }
    }
    
    if ([totalItemsValue count]!=0) {
        
        InsertWebService *ins = [[InsertWebService alloc]initWithTable:@"Store"];
        [ins insertMultipleObjectsInColumnsWhere:@[@"Item",@"Cost",@"Teacher"] setObjectsValues:totalItemsValue];
        [ins saveIntoDatabaseInBackgroundWithBlock:^(NSError *error) {
            if (!error) {

                self.navigationItem.rightBarButtonItem.enabled = NO;
                self.navigationItem.hidesBackButton=YES;
                [loadingView removeFromSuperview];
                [loading stopAnimating];
                [loading removeFromSuperview];
                [self.delegate refreshStoreAfterDoneAddStoreVC:self];
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }
            else{
                self.navigationItem.rightBarButtonItem.enabled = NO;
                self.navigationItem.hidesBackButton=YES;
                [loadingView removeFromSuperview];
                [loading stopAnimating];
                [loading removeFromSuperview];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add Failed" message:@"Check your network connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }];
    }
    else{
        
        self.navigationItem.rightBarButtonItem.enabled = NO;
        self.navigationItem.hidesBackButton=YES;
        [loadingView removeFromSuperview];
        [loading stopAnimating];
        [loading removeFromSuperview];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You have an empty field" message:@"Make sure you have entered an item" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }

}

-(void)checkConditions{
    
    for (int j = 0; j<_i; j++) {
        
        UITextField *sItem = [_storeItemArray objectAtIndex:j];
        UITextField *sCost = [_storeCostArray objectAtIndex:j];
        [sCost setBackgroundColor:[UIColor clearColor]];
        if (![sItem.text isEqualToString:@""] && [sCost.text isEqualToString:@""] ) {
            [sCost setBackgroundColor:[UIColor redColor]];
        }
    }
}

-(void)presetStoreAction{
    
    for (int j = 0; j<_i; j++) {
        
        UITextField *sItem = [_storeItemArray objectAtIndex:j];
        UITextField *sCost = [_storeCostArray objectAtIndex:j];
        
        sItem.text=@"";
        sCost.text=@"";
    }
    
    UITextField *pencilItem = [_storeItemArray objectAtIndex:0];
    pencilItem.text = @"Pencil";
    UITextField *pencilCost = [_storeCostArray objectAtIndex:0];
    pencilCost.text = @"5";
    
    UITextField *restroomItem = [_storeItemArray objectAtIndex:1];
    restroomItem.text = @"Restroom Pass";
    UITextField *restroomCost = [_storeCostArray objectAtIndex:1];
    restroomCost.text = @"1";
    
    UITextField *homeworkItem = [_storeItemArray objectAtIndex:2];
    homeworkItem.text = @"Late Homework Pass";
    UITextField *homeworkCost = [_storeCostArray objectAtIndex:2];
    homeworkCost.text = @"10";
    
    UITextField *snackItem = [_storeItemArray objectAtIndex:3];
    snackItem.text=@"Snack";
    UITextField *snackCost = [_storeCostArray objectAtIndex:3];
    snackCost.text = @"8";
    
    UITextField *ecItem = [_storeItemArray objectAtIndex:4];
    ecItem.text=@"1 Extra Credit Point";
    UITextField *ecCost = [_storeCostArray objectAtIndex:4];
    ecCost.text = @"10";
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"classesTableSegue"]) {
        // if the cell selected segue was fired, edit the selected note
        ClassTableViewController *classTableVC = (ClassTableViewController*)segue.destinationViewController;
        classTableVC.managedObjectContext=_managedObjectContext;
    }


}


@end
