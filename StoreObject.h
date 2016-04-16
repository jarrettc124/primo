//
//  StoreObject.h
//  Primo
//
//  Created by Jarrett Chen on 5/23/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InsertWebService.h"

@interface StoreObject : NSObject

@property (nonatomic,strong) NSString *item;
@property (nonatomic,strong) NSNumber *cost;


- (id)initWithItem:(NSString *)storeItem atCost:(NSNumber*)storeCost;

@end
