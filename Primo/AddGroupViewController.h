//
//  AddGroupViewController.h
//  Primo
//
//  Created by Jarrett Chen on 8/12/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudentObject+CreateClassList.h"
#import "ClassObject+CreateClass.h"
#import "QueryWebService.h"
#import "InsertWebService.h"
#import "BouncingPencil.h"

#define IS_IPHONE  ( [[[UIDevice currentDevice] model] rangeOfString:@"iPhone"].location != NSNotFound )
#define IS_IPAD  ( [[[UIDevice currentDevice] model] rangeOfString:@"iPad"].location != NSNotFound )

@interface AddGroupViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>


@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) ClassObject *classObject;

@property (nonatomic,strong) NSMutableArray *projectNamesForDuplicates;
@property (strong, nonatomic) NSManagedObjectContext *demoManagedObjectContext;


@end
