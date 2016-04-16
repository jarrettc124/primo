//
//  DemoBroadcast.h
//  Primo
//
//  Created by Jarrett Chen on 8/27/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DemoBroadcast : NSManagedObject

@property (nonatomic, retain) NSString * broadcast;
@property (nonatomic, retain) NSString * personType;
@property (nonatomic, retain) NSString * announcementType;
@property (nonatomic, retain) NSString * createdAt;
@property (nonatomic, retain) NSString * objectId;
@property (nonatomic, retain) NSString * recipient;

@end
