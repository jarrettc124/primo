//
//  DemoStudent.h
//  Primo
//
//  Created by Jarrett Chen on 9/4/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DemoStudent : NSManagedObject

@property (nonatomic, retain) NSNumber * addClassDone;
@property (nonatomic, retain) NSNumber * checkStatsDone;
@property (nonatomic, retain) NSNumber * studentsBuyDone;

@end
