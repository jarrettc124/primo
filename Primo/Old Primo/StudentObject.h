//
//  StudentObject.h
//  Primo
//
//  Created by Jarrett Chen on 6/10/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface StudentObject : NSManagedObject

@property (nonatomic, retain) NSNumber * coins;
@property (nonatomic, retain) NSString * nameOfclass;
@property (nonatomic, retain) NSString * objectId;
@property (nonatomic, retain) NSString * studentName;
@property (nonatomic, retain) NSNumber * studentNumber;
@property (nonatomic, retain) NSString * taken;
@property (nonatomic, retain) NSString * teacher;
@property (nonatomic, retain) NSString * teacherEmail;
@property (nonatomic, retain) NSNumber * signedIn;

@end
