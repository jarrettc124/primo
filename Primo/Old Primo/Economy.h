//
//  Economy.h
//  Primo
//
//  Created by Jarrett Chen on 8/23/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StudentObject+CreateClassList.h"


@interface Economy : NSObject

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,strong) NSString *className;

-(id)initWithClassName:(NSString*)className withManagedContent:(NSManagedObjectContext*)managedContext;


-(void)studentEconomyAction:(NSString*)action_event withAmount:(int)amount objectId:(NSString*)studentObjectId;

@end
