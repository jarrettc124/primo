//
//  DemoClassObject.h
//  Primo
//
//  Created by Jarrett Chen on 8/26/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DemoClassObject : NSManagedObject

@property (nonatomic, retain) NSString * nameOfClass;
@property (nonatomic, retain) NSString * objectId;
@property (nonatomic, retain) NSString * sortDescript;
@property (nonatomic, retain) NSString * teacherId;

@end
