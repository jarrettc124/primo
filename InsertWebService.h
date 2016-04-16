//
//  InsertWebService.h
//  Primo
//
//  Created by Jarrett Chen on 5/23/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InsertWebService : NSObject

@property(nonatomic,strong) NSString* sql;
@property(nonatomic,strong) NSMutableArray *columnArray;
@property(nonatomic,strong) NSMutableArray *valuesArray;
@property(nonatomic,strong) NSMutableArray *multipleValuesArray;

- (id)initWithTable:(NSString *)tableName;
-(void)insertObjectInColumnWhere:(NSString*)column setObjectValue:(NSString*)value;
-(void)insertMultipleObjectsInColumnsWhere:(NSArray*)columns setObjectsValues:(NSArray*)values;
-(void)saveIntoDatabase;
-(void)saveIntoDatabaseInBackgroundWithBlock:(void(^)(NSError* error))block;
-(void)saveTheUserInDatabase;
-(void)saveTheUserInDatabaseInBackground:(void(^)(NSError* error,id result))block;
@end
