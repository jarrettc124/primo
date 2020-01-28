//
//  ClassNameView.m
//  TeacherApp
//
//  Created by Jarrett Chen on 3/18/14.
//  Copyright (c) 2014 Jarrett Chen. All rights reserved.
//

#import "ClassNameView.h"

@implementation ClassNameView

- (id)initWithFrame:(CGRect)frame userType:(NSString*)typeOfuser
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userType = typeOfuser;
        // Initialization code
        [self setupClassViews];
    }
    return self;
}

-(void)setupClassViews{
    [self setBackgroundColor:[UIColor clearColor]];
    
    //initialize the toolbarbuttons
    //right bar button
    self.rightBarButton = [[UIBarButtonItem alloc]init];
    [self.rightBarButton setTitle:@"Next"];
    [self.rightBarButton setStyle:UIBarButtonItemStylePlain];
    //left bar button
    UIImage *image = [UIImage imageNamed:@"cancelIcon"];
    CGRect frame = CGRectMake(0, 0, image.size.width-10, image.size.height-10);
    self.button = [[UIButton alloc] initWithFrame:frame];
    [self.button setBackgroundImage:image forState:UIControlStateNormal];
    [self.button addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    self.leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:self.button];
    
    
    if ([self.userType isEqualToString:@"Teacher"]) {
        UILabel *direction = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.origin.x+30,5, self.frame.size.width-30, 60)];
        direction.text=@"Please enter the name of the class you want to add";
        direction.numberOfLines=0;
        direction.textColor = [UIColor whiteColor];
        direction.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
        [self addSubview:direction];
        
        self.classField = [[UITextField alloc]initWithFrame:CGRectMake((self.frame.size.width/2)-40,direction.frame.origin.y+60,195 ,30)];
        [self.classField setAlpha:0];
        self.classField.placeholder = @"Class";
        self.classField.borderStyle = UITextBorderStyleRoundedRect;
        [self addSubview:self.classField];
        
        UIImage *bookImage = [UIImage imageNamed:@"bookIcon"];
        self.bookView=[[UIImageView alloc]initWithFrame:CGRectMake(self.classField.frame.origin.x-bookImage.size.width-40, direction.frame.origin.y+60, bookImage.size.width, bookImage.size.height)];
        self.bookView.contentMode = UIViewContentModeScaleAspectFit;
        [self.bookView setImage:bookImage];
        self.bookView.alpha=0;
        [self addSubview:self.bookView];
        
        
    }
    else{
        [self setBackgroundColor:[UIColor clearColor]];
        
        
        //direction label
        UILabel *createDirection = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width/2 -(294/2),10, 294, 68)];
        createDirection.numberOfLines=0;
        createDirection.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
        createDirection.textColor = [UIColor whiteColor];
        createDirection.text = @"To join a class, please enter the name and the class your teacher gave you.";
        [self addSubview:createDirection];
        
        self.usernameField = [[UITextField alloc]initWithFrame:CGRectMake(20,createDirection.frame.origin.y+createDirection.frame.size.height,self.frame.size.width-40, 35)];
        self.usernameField.placeholder = @"What's your name?";
        self.usernameField.borderStyle = UITextBorderStyleRoundedRect;
        [self.usernameField addTarget:self action:@selector(enableOrDisableDoneButton) forControlEvents:UIControlEventEditingChanged];
        self.usernameField.delegate = self;
        self.usernameField.alpha=0;
        [self addSubview:self.usernameField];
        
        self.teachEmailField = [[UITextField alloc] initWithFrame:CGRectMake(20, self.usernameField.frame.origin.y+self.usernameField.frame.size.height+5,self.usernameField.frame.size.width, 35)];
        self.teachEmailField.placeholder = @"What's your teacher's email?";
        self.teachEmailField.keyboardType = UIKeyboardTypeEmailAddress;
        self.teachEmailField.borderStyle = UITextBorderStyleRoundedRect;
        [self.teachEmailField addTarget:self action:@selector(enableOrDisableDoneButton) forControlEvents:UIControlEventEditingChanged];
        self.teachEmailField.delegate = self;
        self.teachEmailField.alpha=0;
        [self addSubview:self.teachEmailField];
        
        self.classField = [[UITextField alloc] initWithFrame:CGRectMake(20, self.teachEmailField.frame.origin.y+self.teachEmailField.frame.size.height+5,self.usernameField.frame.size.width, 35)];
        self.classField.placeholder = @"Name of your class";
        self.classField.borderStyle = UITextBorderStyleRoundedRect;
        [self.classField addTarget:self action:@selector(enableOrDisableDoneButton) forControlEvents:UIControlEventEditingChanged];
        self.classField.delegate = self;
        self.classField.alpha =0;
        [self addSubview:self.classField];
        
        [self enableOrDisableDoneButton];
    }
    
}

-(void)enableOrDisableDoneButton{
    if ([_usernameField.text isEqualToString:@"" ] || [_teachEmailField.text isEqualToString:@""] || [_classField.text isEqualToString:@""]) {
        self.rightBarButton.enabled = NO;
    }
    else{
        self.rightBarButton.enabled=YES;
    }
}

//keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if([_usernameField isFirstResponder]){
        [_teachEmailField becomeFirstResponder];
        return YES;
    }
    else if([_teachEmailField isFirstResponder]){
        [_classField becomeFirstResponder];
        return YES;
    }
    else{
        return YES;
    }
}



@end
