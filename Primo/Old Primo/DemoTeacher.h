//
//  DemoTeacher.h
//  Primo
//
//  Created by Jarrett Chen on 9/2/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

@interface DemoTeacher : NSManagedObject

@property (nonatomic, retain) NSNumber * addClassDone;
@property (nonatomic, retain) NSNumber * addCoinsDone;
@property (nonatomic, retain) NSNumber * manageCoinsDone;
@property (nonatomic, retain) NSNumber * openStoreDone;
@property (nonatomic, retain) NSNumber * buyStoreDone;
@property (nonatomic, retain) NSNumber * addBroadcastDone;
@property (nonatomic, retain) NSNumber * checkStats;

@end
