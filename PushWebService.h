//
//  PushWebService.h
//  Primo
//
//  Created by Jarrett Chen on 5/21/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PushWebService : NSObject

@property (nonatomic,strong) NSString *currentDeviceToken;

-(void)setDeviceTokenToUserID:(NSString*)userId deviceToken:(NSString*)token;
-(void)removeTokenFromUserId:(NSString*)userId deviceToken:(NSString*)token;
-(void)sendPushToUserIDS:(NSArray*)toIds pushMessage:(NSString*)message;
@end
