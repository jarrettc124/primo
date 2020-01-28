//
//  DemoEconomy.h
//  Primo
//
//  Created by Jarrett Chen on 8/27/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DemoEconomy : NSManagedObject

@property (nonatomic, retain) NSNumber * earn;
@property (nonatomic, retain) NSNumber * spent;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * userId;

@end
