//
//  UpdateWebService.m
//  Primo
//
//  Created by Jarrett Chen on 5/29/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import "UpdateWebService.h"

@implementation UpdateWebService


- (id)initWithTable:(NSString *)tableName{
    self = [super init];
    
    if (self) {
        self.beginningSql = [NSString stringWithFormat:@"UPDATE %@ ",tableName];
        self.endSql = [NSString stringWithFormat:@"UPDATE %@ ",tableName];
        _tableName=tableName;
    }
    return self;
}

-(void)setRowToUpdateWhereColumn:(NSString*)column equalTo:(NSString*)value{
    
    if ([self.endSql isEqualToString:self.beginningSql]) {
        self.endSql = [self.endSql stringByAppendingFormat:@"SET %@ = '%@' ",column,value];
    }
    else{
        self.endSql = [self.endSql stringByAppendingFormat:@", %@ = '%@' ",column,value];
    }
}

-(void)setRowToUpdateWhereColumn:(NSString*)column equalToNonString:(NSString*)value{
    
    if ([self.endSql isEqualToString:self.beginningSql]) {
        self.endSql = [self.endSql stringByAppendingFormat:@"SET %@ = %@ ",column,value];
    }
    else{
        self.endSql = [self.endSql stringByAppendingFormat:@", %@ = %@ ",column,value];
    }
}

-(void)selectRowToUpdateWhereColumn:(NSString*)column equalTo:(NSString*)value{
    
    if (!self.whereSql) {
        self.whereSql = [NSString stringWithFormat:@"WHERE %@ = '%@' ",column,value];
    }
    else{
        self.whereSql = [self.whereSql stringByAppendingFormat:@"AND %@ = '%@' ",column,value];
    }
}


-(void)updateMultipleRowsWithDictionaryArray:(NSArray*)jsonDictionaryArray columnToUpdate:(NSString*)column where:(NSString*)rowMatches{
    
    NSError*error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionaryArray options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *post = [NSString stringWithFormat:@"rows_array=%@&set_column=%@&where_rows=%@&table=%@",jsonString,column,rowMatches,_tableName];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://www.pixelandprocessor.com/primo/insertordelete.php"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        
        if (error) {
            NSLog(@"Sorry: Check your internet");
        }
        
    }];
    [task resume];

}

-(void)saveUpdate{
    
    NSString *post = [NSString stringWithFormat:@"sql=%@%@",self.endSql,self.whereSql];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://www.pixelandprocessor.com/primo/insertordelete.php"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Sorry: Check your internet");
        }
        
        
    }];
    [task resume];
    
}
-(void)saveUpdateInBackgroundWithBlock:(void(^)(NSError* error))block{
    
    NSString *post = [NSString stringWithFormat:@"sql=%@%@",self.endSql,self.whereSql];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://www.pixelandprocessor.com/primo/insertordelete.php"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            block(error);
        });
    }];
    [task resume];
    
}

@end
