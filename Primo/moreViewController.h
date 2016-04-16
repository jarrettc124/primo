//
//  moreViewController.h
//  TeacherApp
//
//  Created by Jarrett Chen on 2/25/14.
//  Copyright (c) 2014 Jarrett Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "DeleteWebService.h"
#import "RestartCoinsViewController.h"
#import "SettingsViewController.h"
#import "LaunchViewController.h"
#import "StartViewController.h"

@interface moreViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,MFMailComposeViewControllerDelegate>
@property (nonatomic,strong) NSString *classNameInMore;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectContext *demoManagedObjectContext;

//student's parameters
@property (nonatomic,strong) StudentObject *studentObj;
@property (nonatomic,strong) TeacherObject *teacherObj;
@end
