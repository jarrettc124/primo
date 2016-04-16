//
//  LogWebService.h
//  Primo
//
//  Created by Jarrett Chen on 5/30/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LogWebService : NSObject

@property(nonatomic,strong) NSString* logType;

- (id)initWithLogType:(NSString *)logType;

-(void)updateLogWithUserId:(NSString*)idNum className:(NSString*)nameOfClass updateLogString:(NSString*)logString;
-(void)printLogOutToUI:(NSString*)idNum className:(NSString*)nameOfClass logMonth:(NSInteger)month completion:(void(^)(BOOL finished,NSError* error,NSString* result))printBlock;
-(void)deleteLogsWithId:(NSArray*)idNumArray;
-(void)renameClassNameWithTeacherId:(NSString*)teacherId withStudentObjIdArray:(NSArray*)studentObjIdArray oldClassName:(NSString*)oldName newClassName:(NSString*)newName;
@end
