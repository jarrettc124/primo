//
//  TeacherObject+CreateTeacher.m
//  Primo
//
//  Created by Jarrett Chen on 5/28/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import "TeacherObject+CreateTeacher.h"

@implementation TeacherObject (CreateTeacher)

+(TeacherObject*)findTeacherObjectInCoreWithDictionary:(NSDictionary*)teacherDictionary inManagedObjectContext:(NSManagedObjectContext*)context{
    
    TeacherObject *teacher = nil;
    
    NSString *teacherObjectId = teacherDictionary[@"ObjectId"];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"TeacherObject"];
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
        teacher = [NSEntityDescription insertNewObjectForEntityForName:@"TeacherObject" inManagedObjectContext:context];
        teacher.objectId = teacherObjectId;
        teacher.classList = teacherDictionary[@"ClassList"];
        teacher.teacherId = teacherDictionary[@"teacherId"];
        teacher.teacherName = teacherDictionary[@"teacherName"];

    }
    
    return teacher;
}


@end
