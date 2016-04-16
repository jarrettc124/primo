//
//  StudentGroupViewController.h
//  Primo
//
//  Created by Jarrett Chen on 6/25/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddGroupViewController.h"
#import "StudentObject+CreateClassList.h"
#import "StudentsViewController.h"
#import "ClassObject+CreateClass.h"
#import "QueryWebService.h"
#import "GroupMoreViewController.h"
#import "BouncingPencil.h"

#define IS_IPHONE  ( [[[UIDevice currentDevice] model] rangeOfString:@"iPhone"].location != NSNotFound )
#define IS_IPAD  ( [[[UIDevice currentDevice] model] rangeOfString:@"iPad"].location != NSNotFound )


@interface StudentGroupViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectContext *demoManagedObjectContext;


//for Teachers
@property (strong, nonatomic) ClassObject *classObject;

//for students
@property (nonatomic,strong) StudentObject *studentObject;


@end
