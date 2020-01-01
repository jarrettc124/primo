//
//  TeacherObject+CreateTeacher.h
//  Primo
//
//  Created by Jarrett Chen on 5/28/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import "TeacherObject.h"

@interface TeacherObject (CreateTeacher)
+(TeacherObject*)findTeacherObjectInCoreWithDictionary:(NSDictionary*)teacherDictionary inManagedObjectContext:(NSManagedObjectContext*)context;
@end
