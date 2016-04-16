//
//  DemoStoreObject+CreateStore.m
//  Primo
//
//  Created by Jarrett Chen on 8/27/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import "DemoStoreObject+CreateStore.h"

@implementation DemoStoreObject (CreateStore)

+(DemoStoreObject*)createStoreObjectInCoreWithDictionary:(NSDictionary*)storeDictionary inManagedObjectContext:(NSManagedObjectContext*)context{
    
    
    DemoStoreObject *store = nil;
    
    NSString *storeObjectId = storeDictionary[@"objectId"];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"DemoStoreObject"];
    request.predicate = [NSPredicate predicateWithFormat:@"objectId = %@",storeObjectId];
    NSError *error;
    NSArray *foundstore = [context executeFetchRequest:request error:&error];
    if (!foundstore || error ||([foundstore count]>1)) {
        NSLog(@"ERROR found:%d",[foundstore count]);
        NSLog(@"ERROR found:%@",foundstore);
        
    }
    else if([foundstore count]){
        store = [foundstore firstObject];
    }
    else{
        //if not found, put the storeObject from database to data core
        
        store = [NSEntityDescription insertNewObjectForEntityForName:@"DemoStoreObject" inManagedObjectContext:context];
        
        NSNumber *costNum = storeDictionary[@"cost"];
        int costInt = [costNum intValue];
        
        
        store.objectId = storeObjectId;
        store.cost = [NSNumber numberWithInt:costInt];
        store.userType = storeDictionary[@"userType"];
        store.item = storeDictionary[@"item"];
    }
    
    return store;
}



@end
