//
//  StudentObject+CreateClassList.h
//  Primo
//
//  Created by Jarrett Chen on 5/28/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import "StudentObject.h"
#import "Economy.h"

@interface StudentObject (CreateClassList)

+(StudentObject*)createStudentObjectInCoreWithDictionary:(NSDictionary*)studentDictionary inManagedObjectContext:(NSManagedObjectContext*)context;

-(void)addCoinsToStudentObject:(NSNumber*)coinNumber;

-(void)subtractCoinsToStudentObject:(NSNumber*)coinNumber;

-(void)buyCoinsStudentObject:(NSNumber*)coinNumber;
@end
