//
//  AnnouncementObject.h
//  Primo
//
//  Created by Jarrett Chen on 5/12/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InsertWebService.h"
#import "DeleteWebService.h"
#import "QueryWebService.h"
#import "UpdateWebService.h"

@interface AnnouncementObject : NSObject

@property (nonatomic) NSInteger badgeNumber;
typedef void(^myCompletion)(BOOL finished, NSNumber *badgeNum);

- (id)initWithTeacherId:(NSString *)teacherid;

-(void)postAnnouncementTo:(NSString*)recipient announcementType:(NSString*)aType personType:(NSString*)typeOfPerson announcementBody:(NSString*)aBody;

-(void)getAnnouncementArrayFor:(NSString*)personType className:(NSString*)nameOfClass completion:(void(^)(NSArray* objectArray, NSError *error))compBlock;

-(void)deleteRowInBroadcast:(id)row;
//badges
-(void)updateBadgeToDatabaseWithId:(NSString*)idNum className:(NSString*)nameOfClass;

-(void)restartBadgeInDatabase:(NSString*)idNum className:(NSString*)nameOfClass;

-(void)getBadgeNumber:(NSString*)idNum className:(NSString*)nameOfClass completion:(myCompletion)compBlock;

//-(void)printLogOutToUI:(NSString*)idNum className:(NSString*)nameOfClass logMonth:(NSInteger)month completion:(void(^)(BOOL finished,NSError *error,NSString* result))printBlock;

@property (nonatomic,strong) NSString* logString;
@property (nonatomic,strong) NSDictionary *announceDictionary;
@property (nonatomic,strong) NSString *teacherId;
@property (nonatomic) NSInteger broadcastOffset;

//announcement object
@end
