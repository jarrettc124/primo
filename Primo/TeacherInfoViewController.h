//
//  TeacherInfoViewController.h
//  TeacherApp
//
//  Created by Jarrett Chen on 4/2/14.
//  Copyright (c) 2014 Jarrett Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QueryWebService.h"
#import <MessageUI/MessageUI.h>
#import "TeacherObject+CreateTeacher.h"
#import "StudentObject+CreateClassList.h"

#define IS_IPHONE  ( [[[UIDevice currentDevice] model] rangeOfString:@"iPhone"].location != NSNotFound )
#define IS_IPAD  ( [[[UIDevice currentDevice] model] rangeOfString:@"iPad"].location != NSNotFound )

@interface TeacherInfoViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate>

@property (nonatomic,strong) TeacherObject *teacherObj;
@property (nonatomic,strong) StudentObject *studentObj;
@property (strong, nonatomic) NSManagedObjectContext *demoManagedObjectContext;


@end
