//
//  DeleteWebService.h
//  Primo
//
//  Created by Jarrett Chen on 5/25/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeleteWebService : NSObject

@property(nonatomic,strong) NSString *tableName;

@property(nonatomic,strong) NSString* beginningSql;

@property(nonatomic,strong) NSString* endSql;

- (id)initWithTable:(NSString *)tableName;
-(void)selectRowToDeleteWhereColumn:(NSString*)column equalTo:(NSString*)value;
-(void)deleteRow;
-(void)selectRowToDeleteWhere:(NSString*)column containsArray:(NSArray*)values;
-(void)deleteRowInBackgroundWithBlock:(void(^)(NSError* error))block;
@end
