//
//  TeacherObject.h
//  Primo
//
//  Created by Jarrett Chen on 6/1/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TeacherObject : NSManagedObject

@property (nonatomic, retain) NSString * classList;
@property (nonatomic, retain) NSString * objectId;
@property (nonatomic, retain) NSString * teacherId;
@property (nonatomic, retain) NSString * teacherName;

@end
