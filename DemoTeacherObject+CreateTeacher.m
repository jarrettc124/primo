//
//  DemoTeacherObject+CreateTeacher.m
//  Primo
//
//  Created by Jarrett Chen on 8/26/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import "DemoTeacherObject+CreateTeacher.h"

@implementation DemoTeacherObject (CreateTeacher)

+(DemoTeacherObject*)findTeacherObjectInCoreWithDictionary:(NSDictionary*)teacherDictionary inManagedObjectContext:(NSManagedObjectContext*)context{
    
    DemoTeacherObject *teacher = nil;
    
    NSString *teacherObjectId = teacherDictionary[@"objectId"];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"DemoTeacherObject"];
    request.predicate = [NSPredicate predicateWithFormat:@"objectId = %@",teacherObjectId];
    NSError *error;
    NSArray *foundTeacher = [context executeFetchRequest:request error:&error];
    if (!foundTeacher || error ||([foundTeacher count]>1)) {
        NSLog(@"ERROR found:%@",foundTeacher);
    }
    else if([foundTeacher count]){
        teacher = [foundTeacher firstObject];
        
    }
    else{
        //if not found, put the studentObject from database to data core
        teacher = [NSEntityDescription insertNewObjectForEntityForName:@"DemoTeacherObject" inManagedObjectContext:context];
        teacher.objectId = teacherObjectId;
        teacher.classList = teacherDictionary[@"classList"];
    }
    
    return teacher;
}

@end
