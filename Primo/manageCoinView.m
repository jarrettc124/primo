//
//  manageCoinView.m
//  TeacherApp
//
//  Created by Jarrett Chen on 3/12/14.
//  Copyright (c) 2014 Jarrett Chen. All rights reserved.
//

#import "manageCoinView.h"

@implementation manageCoinView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
        [self addGestureRecognizer:gestureRecognizer];
        
        //set background image
        self.linedPaperBackground = [[UIImageView alloc]init];
        [self.linedPaperBackground setImage:[UIImage imageNamed:@"linedPaper"]];
        [self addSubview:self.linedPaperBackground];
        
        self.holesLinedPaperBackground = [[UIImageView alloc]init];
        self.holesLinedPaperBackground.userInteractionEnabled=YES;
        [self addSubview:self.holesLinedPaperBackground];

        _directLabel = [[UILabel alloc]init];
        _directLabel.text = @"First, pick your students below.";
        _directLabel.numberOfLines=0;
        _directLabel.font = [UIFont fontWithName:@"TravelingTypewriter" size:15];
        [self.linedPaperBackground addSubview:_directLabel];
        
//        if (IS_IPAD) {
            [self.holesLinedPaperBackground setImage:[UIImage imageNamed:@"linedPaperHole"]];
        self.holesLinedPaperBackground.contentMode = UIViewContentModeScaleAspectFill;
        self.holesLinedPaperBackground.clipsToBounds = YES;
        
            self.linedPaperBackground.translatesAutoresizingMaskIntoConstraints=NO;
            self.holesLinedPaperBackground.translatesAutoresizingMaskIntoConstraints=NO;
        self.directLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_linedPaperBackground(40)]-0-[_holesLinedPaperBackground(40)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_linedPaperBackground,_holesLinedPaperBackground)]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_linedPaperBackground]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_linedPaperBackground)]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_holesLinedPaperBackground]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_holesLinedPaperBackground)]];
        
        
        [self.linedPaperBackground addConstraint:[NSLayoutConstraint constraintWithItem:self.directLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.linedPaperBackground attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [self.linedPaperBackground addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_directLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_directLabel)]];
        


        
//        }
//        else if (IS_IPHONE){
//            [self.linedPaperBackground setFrame:CGRectMake(frame.origin.x, frame.origin.y-64, frame.size.width, frame.size.height/2)];
//            [self.holesLinedPaperBackground setImage:[UIImage imageNamed:@"linedPaperHole"]];
//            [self.holesLinedPaperBackground setFrame:CGRectMake(frame.origin.x, frame.origin.y+self.linedPaperBackground.frame.size.height-64, frame.size.width, frame.size.height/2)];
//            [_directLabel setFrame:CGRectMake(self.linedPaperBackground.frame.origin.x+66,2, 220, 40)];
//        }
        
        [self setupCoinViews];
    }
    return self;
}

-(void)hideKeyboard{
    [self endEditing:YES];
}

-(void)setupCoinViews{
    
    self.addButtonGroupButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.addButtonGroupButton setTag:100];
    [self.addButtonGroupButton setTitle:@"+" forState:UIControlStateNormal];
    self.addButtonGroupButton.titleLabel.font = [UIFont boldSystemFontOfSize:21];
    [self.addButtonGroupButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.addButtonGroupButton.layer.cornerRadius = 3;
    [self.addButtonGroupButton setBackgroundColor: [UIColor greenColor]];
    [self.addButtonGroupButton addTarget:self action:@selector(groupButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.addButtonGroupButton.alpha=0;
    
    self.coinsField = [[UITextField alloc]init];
    self.coinsField.placeholder = @"Coins";
    self.coinsField.borderStyle = UITextBorderStyleNone;
    self.coinsField.font = [UIFont fontWithName:@"TravelingTypewriter" size:20];
    self.coinsField.alpha = 0;
    [self.coinsField setKeyboardType:UIKeyboardTypeNumberPad];
    //coin image
    
    self.minusButtonGroupButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.minusButtonGroupButton setTag:200];
    [self.minusButtonGroupButton setTitle:@"-" forState:UIControlStateNormal];
    self.minusButtonGroupButton.titleLabel.font = [UIFont boldSystemFontOfSize:21];
    [self.minusButtonGroupButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.minusButtonGroupButton.layer.cornerRadius = 3;
    [self.minusButtonGroupButton setBackgroundColor: [UIColor redColor]];
    [self.minusButtonGroupButton addTarget:self action:@selector(groupButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.minusButtonGroupButton.alpha = 0;
    [self.holesLinedPaperBackground addSubview:self.coinsField];
    [self.holesLinedPaperBackground addSubview:self.addButtonGroupButton];
    [self.holesLinedPaperBackground addSubview:self.minusButtonGroupButton];
    
    if(IS_IPAD){
        self.addButtonGroupButton.frame = CGRectMake(400, 6, 40, 30);
        [self.coinsField setFrame:CGRectMake(self.addButtonGroupButton.frame.origin.x-95,6,60 ,30)];
        self.minusButtonGroupButton.frame = CGRectMake(self.coinsField.frame.origin.x-105, 6, 40, 30);

    }
    else if (IS_IPHONE){
        self.addButtonGroupButton.frame = CGRectMake(320-50, 6, 40, 30);
        [self.coinsField setFrame:CGRectMake(self.addButtonGroupButton.frame.origin.x-95,6,60 ,30)];
        self.minusButtonGroupButton.frame = CGRectMake(self.coinsField.frame.origin.x-105, 6, 40, 30);

    }
    
    UIImageView *coinImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.coinsField.frame.origin.x-30,6,30 ,30)];
    [coinImage setImage:[UIImage imageNamed:@"goldCoin"]];
    [self.holesLinedPaperBackground addSubview:coinImage];

}

//type of sign YES is plus NO is minus
-(void)manageCoinsWithSelectedArray:(NSArray*)nameOfSelectedArrays studentArray:(NSArray*)studentOfArray inManagedObjectContext:(NSManagedObjectContext*)context typeOfSign:(BOOL)sign{
        NSString *objId = [[NSUserDefaults standardUserDefaults] objectForKey:@"ObjectId"];
    //Update Log
    LogWebService *logService = [[LogWebService alloc]initWithLogType:@"class_logs"];
    int coinValue = [self.coinsField.text intValue];
    
    BOOL addSpecificRows = nameOfSelectedArrays.count > 0;
    
    if (addSpecificRows)
    {
        // Build an NSIndexSet
        NSMutableIndexSet *indicesOfItemsToAdd = [NSMutableIndexSet new];
        for (NSIndexPath *selectionIndex in nameOfSelectedArrays)
        {
            [indicesOfItemsToAdd addIndex:selectionIndex.row];
            
        }
        
        //Update the selected objects
        NSArray *studentObjArray = [studentOfArray objectsAtIndexes:indicesOfItemsToAdd];
        if (sign){
            
            NSString *alertString = [NSString stringWithFormat:@"%@ coins are added to your selected students",self.coinsField.text];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Done" message:alertString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
            for (StudentObject* studentObj in studentObjArray) {
                
                [studentObj addCoinsToStudentObject:[NSNumber numberWithInt:coinValue]];
                
                NSString *studentLogString = [NSString stringWithFormat:@"%@ added %@ coins to your account: %@%@",self.teacherName,self.coinsField.text,@"%2B",self.coinsField.text];
                NSString *teacherLogString = [NSString stringWithFormat:@"You added %@ coins to %@'s account: %@%@",self.coinsField.text,studentObj.studentName,@"%2B",self.coinsField.text];
                [logService updateLogWithUserId:studentObj.objectId className:_className updateLogString:studentLogString];
                [logService updateLogWithUserId:objId className:_className updateLogString:teacherLogString];
            }
            
            [context save:nil];
        }
        else{
            NSString *alertString = [NSString stringWithFormat:@"%@ coins are subtracted from your selected students",self.coinsField.text];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Done" message:alertString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
            for (StudentObject* studentObj in studentObjArray) {
                
                [studentObj subtractCoinsToStudentObject:[NSNumber numberWithInt:coinValue]];
                
                NSString *studentLogString = [NSString stringWithFormat:@"%@ subtracted %@ coins to your account: %@%@",self.teacherName,self.coinsField.text,@"%2D",self.coinsField.text];
                NSString *teacherLogString = [NSString stringWithFormat:@"You subtracted %@ coins to %@'s account: %@%@",self.coinsField.text,studentObj.studentName,@"%2D",self.coinsField.text];
                [logService updateLogWithUserId:studentObj.objectId className:_className updateLogString:studentLogString];
                [logService updateLogWithUserId:objId className:_className updateLogString:teacherLogString];
            }
            [context save:nil];
        }
    }
    

}

-(void)animateCoinViewUpAndDown:(UITableView*)table{
    
    if (_className==nil || _teacherName==nil) {
        NSLog(@"You forgot to add teacherName and className parameters");
        abort();
    }
    
    if (IS_IPHONE) {
    
        if(table.frame.origin.y>64){ //view is showing, hide it

            [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                table.frame=CGRectMake(table.frame.origin.x,table.frame.origin.y-80-44, table.frame.size.width,table.frame.size.height+80+44);
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
            
        }
        else{ //view is not showing, show it
            [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                table.frame=CGRectMake(table.frame.origin.x,table.frame.origin.y+80+44, table.frame.size.width,table.frame.size.height-80-44);
            } completion:^(BOOL finished) {
            }];

        }
    }
    else if (IS_IPAD){
        
        if(self.isOpen){ //view is showing, hide it
            
            [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                
                
                
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
            
        }
        else{ //view is not showing, show it
            
            [self layoutIfNeeded];
            [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                
                
                table.frame=CGRectMake(table.frame.origin.x,table.frame.origin.y+80+44, table.frame.size.width,table.frame.size.height-80-44);
            } completion:^(BOOL finished) {
            }];
            
        }

    }
}

-(void)groupButtonAction:(UIButton*)sender{
    if (sender.tag == 100) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"addAction" object:nil];

    }
    else if(sender.tag == 200){
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"minusAction" object:nil];
    }
}


@end
