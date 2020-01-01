//
//  ClassObject+CreateClass.m
//  Primo
//
//  Created by Jarrett Chen on 5/28/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import "ClassObject+CreateClass.h"

@implementation ClassObject (CreateClass)

+(ClassObject*)findClassObjectInCoreWithTeacherId:(NSString*)teacherId className:(NSString*)nameOfClass inManagedObjectContext:(NSManagedObjectContext*)context{
    
    ClassObject *classObject = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ClassObject"];
    request.predicate = [NSPredicate predicateWithFormat:@"(teacherId = %@) AND (nameOfClass = %@)",teacherId,nameOfClass];
    NSError *error;
    NSArray *foundClass = [context executeFetchRequest:request error:&error];
    if (!foundClass || error ||([foundClass count]>1)) {
        NSLog(@"ERROR found:%d",[foundClass count]);
    }
    else if([foundClass count]){
        classObject = [foundClass firstObject];
        
    }
    else{
        //if not found, put the classObject from database to data core
        classObject = [NSEntityDescription insertNewObjectForEntityForName:@"ClassObject" inManagedObjectContext:context];
        classObject.teacherId = teacherId;
        classObject.sortDescrip = @"Student Number:Ascending";
        classObject.nameOfClass = nameOfClass;
    }
    
    return classObject;
}

@end
