//
//  DemoTeacherObject+CreateTeacher.h
//  Primo
//
//  Created by Jarrett Chen on 8/26/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import "DemoTeacherObject.h"


@interface DemoTeacherObject (CreateTeacher)

+(DemoTeacherObject*)findTeacherObjectInCoreWithDictionary:(NSDictionary*)teacherDictionary inManagedObjectContext:(NSManagedObjectContext*)context;

@end
