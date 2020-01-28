//
//  AnnouncementViewController.h
//  Primo
//
//  Created by Jarrett Chen on 5/7/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PushWebService.h"
#import "PostAnnouncement.h"
#import "AnnouncementObject.h"
#import "BroadcastMoreViewController.h"
#import "StudentObject+CreateClassList.h"
#import "LogWebService.h"
#import "TeacherObject+CreateTeacher.h"
#import "BouncingPencil.h"


#define IS_IPHONE  ( [[[UIDevice currentDevice] model] rangeOfString:@"iPhone"].location != NSNotFound )
#define IS_IPAD  ( [[[UIDevice currentDevice] model] rangeOfString:@"iPad"].location != NSNotFound )
@interface AnnouncementViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,strong) NSManagedObjectContext *demoManagedObjectContext;

@property (nonatomic,strong) NSString *className;

//must be passed in user=student
@property (nonatomic,strong) NSString *teacherIdForStudent;
@property (nonatomic,strong) StudentObject *currentStudentObj;

//passed in user=teacher
@property (nonatomic,strong) NSString *classListArrayjsonString;


@end
