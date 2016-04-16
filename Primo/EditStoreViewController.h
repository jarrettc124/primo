//
//  EditStoreViewController.h
//  TeacherApp
//
//  Created by Jarrett Chen on 3/4/14.
//  Copyright (c) 2014 Jarrett Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassTableViewController.h"
#import "AddStoreViewController.h"

@interface EditStoreViewController : UIViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


@property(nonatomic,strong) UIButton *skipButton;
@property(nonatomic,strong) UIButton *setUpButton;
@property(nonatomic,strong) UINavigationBar *toolbar;
@property(nonatomic,strong) UINavigationItem *item;
@end
