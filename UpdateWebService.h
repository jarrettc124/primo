//
//  UpdateWebService.h
//  Primo
//
//  Created by Jarrett Chen on 5/29/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UpdateWebService : NSObject

@property(nonatomic,strong) NSString *tableName;

@property(nonatomic,strong) NSString* beginningSql;

@property(nonatomic,strong) NSString* endSql;

@property(nonatomic,strong) NSString* whereSql;

- (id)initWithTable:(NSString *)tableName;

-(void)setRowToUpdateWhereColumn:(NSString*)column equalTo:(NSString*)value;
-(void)setRowToUpdateWhereColumn:(NSString*)column equalToNonString:(NSString*)value;

-(void)selectRowToUpdateWhereColumn:(NSString*)column equalTo:(NSString*)value;
-(void)saveUpdate;

-(void)updateMultipleRowsWithDictionaryArray:(NSArray*)jsonDictionaryArray columnToUpdate:(NSString*)column where:(NSString*)rowMatches;

-(void)saveUpdateInBackgroundWithBlock:(void(^)(NSError* error))block;
@end
