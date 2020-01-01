//
//  GroupMoreViewController.h
//  Primo
//
//  Created by Jarrett Chen on 8/19/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassObject+CreateClass.h"
#import "StudentObject+CreateClassList.h"
#import "UpdateWebService.h"

#define IS_IPHONE  ( [[[UIDevice currentDevice] model] rangeOfString:@"iPhone"].location != NSNotFound )
#define IS_IPAD  ( [[[UIDevice currentDevice] model] rangeOfString:@"iPad"].location != NSNotFound )


@interface GroupMoreViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) NSManagedObjectContext *demoManagedObjectContext;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,strong) NSDictionary *rowToPass;
@property (nonatomic,strong) StudentObject *studentObj;
@end
