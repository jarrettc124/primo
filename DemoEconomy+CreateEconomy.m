//
//  DemoEconomy+CreateEconomy.m
//  Primo
//
//  Created by Jarrett Chen on 8/26/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import "DemoEconomy+CreateEconomy.h"

@implementation DemoEconomy (CreateEconomy)

+(BOOL)createEconObjectInCoreWithDictionary:(NSDictionary*)econDictionary inManagedObjectContext:(NSManagedObjectContext*)context{
    
    
    DemoEconomy *econ = nil;
    
    
    econ = [NSEntityDescription insertNewObjectForEntityForName:@"DemoEconomy" inManagedObjectContext:context];
    
    NSNumber *econEarn= econDictionary[@"earn"];
    NSNumber *econSpent= econDictionary[@"spent"];


    int econSpentInt = [econSpent intValue];
    int econEarnInt = [econEarn intValue];
    
    econ.userId = econDictionary[@"userId"];
    econ.type = econDictionary[@"type"];
    econ.earn = [NSNumber numberWithInt:econEarnInt];
    econ.spent = [NSNumber numberWithInt:econSpentInt];

    return YES;
}


@end
