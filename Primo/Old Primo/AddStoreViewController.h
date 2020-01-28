//
//  AddStoreViewController.h
//  Primo
//
//  Created by Jarrett Chen on 6/13/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import <UIKit/UIKit.h>
//protocol
@protocol AddStoreViewDelegate;
@class AddStoreViewController;

@protocol AddStoreViewDelegate <NSObject>

-(void)refreshStoreAfterDoneAddStoreVC:(AddStoreViewController*)viewController;

@end

//imports
#import "StoreObject.h"
#import "ClassTableViewController.h"


@interface AddStoreViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (nonatomic,strong) NSString *previousSegue;

@property (nonatomic, weak) id<AddStoreViewDelegate> delegate;

@end


