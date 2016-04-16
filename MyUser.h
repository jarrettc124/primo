//
//  MyUser.h
//  Primo
//
//  Created by Jarrett Chen on 2/22/16.
//  Copyright © 2016 Pixel and Processor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyUser : NSObject
+(void)storeDefaults:(NSDictionary*)userDict;
+(BOOL)isLoggedIn;
@end
