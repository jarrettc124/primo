//
//  ClassMenuView.m
//  TeacherApp
//
//  Created by Jarrett Chen on 3/21/14.
//  Copyright (c) 2014 Jarrett Chen. All rights reserved.
//

#import "ClassMenuView.h"

@implementation ClassMenuView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        // Initialization code
        [self menuButtons];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)menuButtons{
    [self setBackgroundColor:[UIColor clearColor]];
    
    self.addNewClass = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addNewClass setImage:[UIImage imageNamed:@"AddImage"] forState:UIControlStateNormal];
    self.addNewClass.backgroundColor = [UIColor clearColor];
    [self.addNewClass setTag:500];
    [self.addNewClass setAlpha:1];
    [self.addNewClass addTarget:self action:@selector(menuButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.addNewClass];
    
    self.addNewClassLabel = [[UILabel alloc] init];
    [self.addNewClassLabel setAlpha:0];
    [self.addNewClassLabel setNumberOfLines:0];
    [self.addNewClassLabel setText:[NSString stringWithFormat:@"Add\nCreate a new class here"]];
    self.addNewClassLabel.textColor = [UIColor whiteColor];
    self.addNewClassLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
    self.addNewClassLabel.textAlignment = NSTextAlignmentCenter;
    NSMutableAttributedString *attributeTouchString = [[NSMutableAttributedString alloc] initWithString:self.addNewClassLabel.text];
    [attributeTouchString addAttribute:NSFontAttributeName
                                 value:[UIFont fontWithName:@"Eraser" size:19]
                                 range:NSMakeRange(0,3)];
    [self.addNewClassLabel setAttributedText:attributeTouchString];
    
    [self addSubview:self.addNewClassLabel];
    
    
    
    self.moveClass = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.moveClass setAlpha:0];
    [self.moveClass setTag:700];
    [self.moveClass setImage:[UIImage imageNamed:@"moveIcon"] forState:UIControlStateNormal];
    [self.moveClass addTarget:self action:@selector(menuButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.moveClass];
    
    self.moveClassLabel = [[UILabel alloc] init];
    [self.moveClassLabel setAlpha:0];
    [self.moveClassLabel setNumberOfLines:0];
    [self.moveClassLabel setText:[NSString stringWithFormat:@"Move\nReorder your classes"]];
    self.moveClassLabel.textColor = [UIColor whiteColor];
    self.moveClassLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
    self.moveClassLabel.textAlignment = NSTextAlignmentCenter;
    NSMutableAttributedString *moveAttribute = [[NSMutableAttributedString alloc] initWithString:self.moveClassLabel.text];
    [moveAttribute addAttribute:NSFontAttributeName
                                 value:[UIFont fontWithName:@"Eraser" size:19]
                                 range:NSMakeRange(0,4)];
    [self.moveClassLabel setAttributedText:moveAttribute];
    [self addSubview:self.moveClassLabel];

    self.changeNameClass = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.changeNameClass setAlpha:0];
    [self.changeNameClass setTag:800];
    [self.changeNameClass setImage:[UIImage imageNamed:@"TextCursor"] forState:UIControlStateNormal];
    [self.changeNameClass addTarget:self action:@selector(menuButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.changeNameClass];

    //button labels
    self.changeNameClassLabel = [[UILabel alloc] init];
    [self.changeNameClassLabel setAlpha:0];
    [self.changeNameClassLabel setNumberOfLines:0];
    [self.changeNameClassLabel setText:[NSString stringWithFormat:@"Rename\nChange your class name here"]];
    self.changeNameClassLabel.textColor = [UIColor whiteColor];
    self.changeNameClassLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
    self.changeNameClassLabel.textAlignment = NSTextAlignmentCenter;
    NSMutableAttributedString *nameAttribute = [[NSMutableAttributedString alloc] initWithString:self.changeNameClassLabel.text];
    [nameAttribute addAttribute:NSFontAttributeName
                          value:[UIFont fontWithName:@"Eraser" size:19]
                          range:NSMakeRange(0,6)];
    [self.changeNameClassLabel setAttributedText:nameAttribute];
    [self addSubview:self.changeNameClassLabel];
    
    if(IS_IPAD){
        
        self.addNewClass.translatesAutoresizingMaskIntoConstraints=NO;
        self.moveClass.translatesAutoresizingMaskIntoConstraints=NO;
        self.changeNameClass.translatesAutoresizingMaskIntoConstraints=NO;
        
        self.addNewClassLabel.translatesAutoresizingMaskIntoConstraints=NO;
        self.moveClassLabel.translatesAutoresizingMaskIntoConstraints=NO;
        self.changeNameClassLabel.translatesAutoresizingMaskIntoConstraints=NO;
        
        //Set buttons V and H
        self.hiddenState = [NSLayoutConstraint constraintWithItem:self.addNewClass attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:80];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.moveClass attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        
        [self addConstraint:self.hiddenState];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_addNewClass(70)]-90-[_moveClass(70)]-90-[_changeNameClass(70)]" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(_addNewClass,_moveClass,_changeNameClass)]];
        
        //Set Labels V and H
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.addNewClassLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.addNewClass attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.moveClassLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_addNewClassLabel(110)]-50-[_moveClassLabel(110)]-50-[_changeNameClassLabel(110)]" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(_addNewClassLabel,_moveClassLabel,_changeNameClassLabel)]];
        
    }
    else if(IS_IPHONE){
        self.addNewClass.frame = CGRectMake((self.frame.size.width/6)-35, self.frame.origin.y-64, 70, 70);
        self.moveClass.frame = CGRectMake(self.frame.size.width*0.5-35,self.frame.origin.y-64, 70, 70);
        self.changeNameClass.frame = CGRectMake((self.frame.size.width*5/6)-35,self.frame.origin.y-64, 70, 70);

        [self.addNewClassLabel setFrame:CGRectMake(0,0, 106, 80)];
        [self.moveClassLabel setFrame:CGRectMake(0,0, 106, 80)];
        [self.changeNameClassLabel setFrame:CGRectMake(0 ,0, 106, 80)];
        
        [self.addNewClassLabel setCenter:CGPointMake(self.addNewClass.center.x, self.addNewClass.center.y+75)];
        [self.moveClassLabel setCenter:CGPointMake(self.moveClass.center.x, self.addNewClass.center.y+75)];
        [self.changeNameClassLabel setCenter:CGPointMake(self.changeNameClass.center.x, self.addNewClass.center.y+75)];
    }
    
}

-(void)menuButtonAction:(UIButton*)sender{
    if (sender.tag ==500) { //addnewclass
        self.menuOption = @"addNew";
    }
    else if (sender.tag == 700){ //move class
        self.menuOption = @"moveClass";
    }
    else{ //changenameclass
        self.menuOption = @"changeNameClass";
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"menuButtonAction" object:nil];

}

-(void)removeAllButtonsInMenu{
    [self.addNewClass removeFromSuperview];
    [self.addNewClassLabel removeFromSuperview];
    [self.changeNameClass removeFromSuperview];
    [self.changeNameClassLabel removeFromSuperview];
    [self.moveClass removeFromSuperview];
    [self.moveClassLabel removeFromSuperview];
    
    
}


@end
