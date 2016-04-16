//
//  AddViewController.h
//  Register1
//
//  Created by Jarrett Chen on 2/15/14.
//  Copyright (c) 2014 Jarrett Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InsertWebService.h"
#import "StudentObject+CreateClassList.h"

#define IS_IPHONE  ( [[[UIDevice currentDevice] model] rangeOfString:@"iPhone"].location != NSNotFound )
#define IS_IPAD  ( [[[UIDevice currentDevice] model] rangeOfString:@"iPad"].location != NSNotFound )


@protocol AddViewDelegate;

@class AddViewController;

@protocol AddViewDelegate <NSObject>

@optional
-(void)refreshAfterDoneAdding:(AddViewController*)viewController;
-(void)addNewClassToDatabaseClassName:(NSString*)className;

@end


@interface AddViewController : UIViewController <UITextFieldDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectContext *demoManagedObjectContext;

@property (nonatomic) BOOL isNewClass;

@property (nonatomic) NSInteger i;
@property (nonatomic) NSInteger y;

@property(nonatomic,strong) UIScrollView *scroller;
@property(nonatomic,strong) NSMutableArray *studentNames;

-(void)addStudent: (id)sender;
- (BOOL)textFieldShouldReturn:(UITextField *)textField;

@property (nonatomic) UIImageView *coinView;
@property(nonatomic,strong) NSString *className;

@property (nonatomic,strong) NSString* teachersName;


//example

@property (nonatomic,unsafe_unretained) id<AddViewDelegate> delegate;

@end
