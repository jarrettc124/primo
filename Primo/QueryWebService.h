//
//  QueryWebService.h
//  Primo
//
//  Created by Jarrett Chen on 5/23/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QueryWebService : NSObject


@property(nonatomic,strong) NSString *tableName;

@property(nonatomic,strong) NSString* beginningSql;

@property(nonatomic,strong) NSString* endSql;

- (id)initWithTable:(NSString *)tableName;
-(void)selectColumnWhere:(NSString*)column equalTo:(NSString*)value;
-(void)selectColumnWhere:(NSString*)column containsArray:(NSArray*)values;
-(void)orderByAscendingForColumn:(NSString*)column;
-(void)orderByDescendingForColumn:(NSString*)column;
-(void)setLimit:(NSInteger)limit whereOffset:(NSInteger)offSet;
-(void)findAllObjectsInRowWithCompletion:(void(^)(NSError* error,NSArray* rows))block;

-(void)selectColumnWhere:(NSString*)column equalToNonStringValue:(NSString*)value;

+(void)emailLogin:(NSString*)email withPassword:(NSString*)password withCompletionHandler:(void(^)(NSError* error,id result))completionHandler;
@end
