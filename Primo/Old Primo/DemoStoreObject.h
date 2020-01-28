//
//  DemoStoreObject.h
//  Primo
//
//  Created by Jarrett Chen on 8/29/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DemoStoreObject : NSManagedObject

@property (nonatomic, retain) NSNumber * cost;
@property (nonatomic, retain) NSString * item;
@property (nonatomic, retain) NSString * objectId;
@property (nonatomic, retain) NSString * userType;

@end
