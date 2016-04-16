//
//  DemoStoreObject+CreateStore.h
//  Primo
//
//  Created by Jarrett Chen on 8/27/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import "DemoStoreObject.h"

@interface DemoStoreObject (CreateStore)

+(DemoStoreObject*)createStoreObjectInCoreWithDictionary:(NSDictionary*)storeDictionary inManagedObjectContext:(NSManagedObjectContext*)context;

@end
