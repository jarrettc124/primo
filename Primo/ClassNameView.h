//
//  ClassNameView.h
//  TeacherApp
//
//  Created by Jarrett Chen on 3/18/14.
//  Copyright (c) 2014 Jarrett Chen. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface ClassNameView : UIView <UITextFieldDelegate>

@property (nonatomic,strong) UITextField *classField;
@property (nonatomic,strong) UIImageView *bookView;
@property (nonatomic,strong) UIBarButtonItem *rightBarButton;
@property (nonatomic,strong) UIBarButtonItem *leftBarButton;

@property(nonatomic,strong) UIButton *button;

//student textfields and labels
@property (nonatomic,strong) UITextField *usernameField;
@property (nonatomic,strong) UITextField *teachEmailField;

@property (nonatomic,strong) NSString *userType;

- (id)initWithFrame:(CGRect)frame userType:(NSString*)typeOfuser;
@end
