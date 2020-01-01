//
//  StoreObject.m
//  Primo
//
//  Created by Jarrett Chen on 5/23/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import "StoreObject.h"

@implementation StoreObject

- (id)initWithItem:(NSString *)storeItem atCost:(NSNumber*)storeCost{
    self = [super init];
    
    if (self) {
        _item = storeItem;
        _cost = storeCost;
    }
    return self;
    
}






@end
