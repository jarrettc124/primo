//
//  ClassObject+CreateClass.h
//  Primo
//
//  Created by Jarrett Chen on 5/28/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import "ClassObject.h"

@interface ClassObject (CreateClass)


+(ClassObject*)findClassObjectInCoreWithTeacherId:(NSString*)teacherId className:(NSString*)nameOfClass inManagedObjectContext:(NSManagedObjectContext*)context;

@end
