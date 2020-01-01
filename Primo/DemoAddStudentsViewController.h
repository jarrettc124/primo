//
//  DemoAddStudentsViewController.h
//  Primo
//
//  Created by Jarrett Chen on 8/28/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DemoStudentObject+CreateClassList.h"
#import "DemoTeacherObject+CreateTeacher.h"
#import "DemoTeacher+CheckProgress.h"
#import "DemoRateAppView.h"

#define IS_IPHONE  ( [[[UIDevice currentDevice] model] rangeOfString:@"iPhone"].location != NSNotFound )
#define IS_IPAD  ( [[[UIDevice currentDevice] model] rangeOfString:@"iPad"].location != NSNotFound )

@interface DemoAddStudentsViewController : UIViewController<UITextFieldDelegate>

@property (nonatomic,strong) NSString *userType;
@property(nonatomic,strong) NSString *className;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectContext *demoManagedObjectContext;
@property (nonatomic,strong) NSMutableArray *studentsArray;

@property (nonatomic,strong) DemoTeacherObject *teacherObject;
@end
