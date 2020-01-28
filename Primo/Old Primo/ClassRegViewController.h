//
//  ClassRegViewController.h
//  TeacherApp
//
//  Created by Jarrett Chen on 3/18/14.
//  Copyright (c) 2014 Jarrett Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InsertWebService.h"
#import "ClassTableViewController.h"
#import "BouncingPencil.h"

@interface ClassRegViewController : UIViewController<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,strong) NSString *userType;

@property (nonatomic,strong) UITextField *firstNameField;
@property (nonatomic,strong) UITextField* lastNameField;
@property (nonatomic,strong) UITextField *genderField;

@end
