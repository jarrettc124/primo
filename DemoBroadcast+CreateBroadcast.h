//
//  DemoBroadcast+CreateBroadcast.h
//  Primo
//
//  Created by Jarrett Chen on 8/27/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import "DemoBroadcast.h"

@interface DemoBroadcast (CreateBroadcast)
+(DemoBroadcast*)createBroadcastObjectInCoreWithDictionary:(NSDictionary*)broadcastDictionary inManagedObjectContext:(NSManagedObjectContext*)context;
@end
