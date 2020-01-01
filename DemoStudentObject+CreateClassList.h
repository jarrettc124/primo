//
//  DemoStudentObject+CreateClassList.h
//  Primo
//
//  Created by Jarrett Chen on 8/26/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import "DemoStudentObject.h"
#import "DemoEconomy+CreateEconomy.h"

@interface DemoStudentObject (CreateClassList)
+(DemoStudentObject*)createStudentObjectInCoreWithDictionary:(NSDictionary*)studentDictionary inManagedObjectContext:(NSManagedObjectContext*)context;
-(void)addCoinsToStudentObject:(NSNumber*)coinNumber inManagedObjectContext:(NSManagedObjectContext*)context;
-(void)subtractCoinsToStudentObject:(NSNumber*)coinNumber inManagedObjectContext:(NSManagedObjectContext*)context;
-(void)buyCoinsStudentObject:(NSNumber*)coinNumber inManagedObjectContext:(NSManagedObjectContext*)context;
@end
