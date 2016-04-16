//
//  DemoEconomy+CreateEconomy.h
//  Primo
//
//  Created by Jarrett Chen on 8/26/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import "DemoEconomy.h"

@interface DemoEconomy (CreateEconomy)
+(BOOL)createEconObjectInCoreWithDictionary:(NSDictionary*)econDictionary inManagedObjectContext:(NSManagedObjectContext*)context;
@end
