//
//  DemoBroadcast+CreateBroadcast.m
//  Primo
//
//  Created by Jarrett Chen on 8/27/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import "DemoBroadcast+CreateBroadcast.h"

@implementation DemoBroadcast (CreateBroadcast)

+(DemoBroadcast*)createBroadcastObjectInCoreWithDictionary:(NSDictionary*)broadcastDictionary inManagedObjectContext:(NSManagedObjectContext*)context{
    
    
    DemoBroadcast *broadcast = nil;
    
    NSString *broadcastObjectId = broadcastDictionary[@"objectId"];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"DemoBroadcast"];
    request.predicate = [NSPredicate predicateWithFormat:@"objectId = %@",broadcastObjectId];
    NSError *error;
    NSArray *foundBroadcast = [context executeFetchRequest:request error:&error];
    if (!foundBroadcast || error ||([foundBroadcast count]>1)) {
        NSLog(@"ERROR found:%d",[foundBroadcast count]);
        NSLog(@"ERROR found:%@",foundBroadcast);
        
    }
    else if([foundBroadcast count]){
        broadcast = [foundBroadcast firstObject];
    }
    else{
        //if not found, put the BroadcastObject from database to data core
        
        broadcast = [NSEntityDescription insertNewObjectForEntityForName:@"DemoBroadcast" inManagedObjectContext:context];
        
        broadcast.broadcast = broadcastDictionary[@"broadcast"];
        broadcast.personType = broadcastDictionary[@"personType"];
        broadcast.announcementType = broadcastDictionary[@"announcementType"];
        broadcast.createdAt = broadcastDictionary[@"createdAt"];
        broadcast.objectId = broadcastDictionary[@"objectId"];
        broadcast.recipient = broadcastDictionary[@"recipient"];
    }
    
    return broadcast;
}


@end
