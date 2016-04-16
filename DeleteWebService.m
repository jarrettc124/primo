//
//  DeleteWebService.m
//  Primo
//
//  Created by Jarrett Chen on 5/25/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import "DeleteWebService.h"

@implementation DeleteWebService

- (id)initWithTable:(NSString *)tableName{
    self = [super init];
    
    if (self) {
        self.beginningSql = [NSString stringWithFormat:@"DELETE FROM %@ ",tableName];
        self.endSql = [NSString stringWithFormat:@"DELETE FROM %@ ",tableName];
        _tableName=tableName;
    }
    return self;
    
}

-(void)selectRowToDeleteWhereColumn:(NSString*)column equalTo:(NSString*)value{
    
    if ([self.endSql isEqualToString:self.beginningSql]) {
        self.endSql = [self.endSql stringByAppendingFormat:@"WHERE %@ = '%@' ",column,value];
    }
    else{
        self.endSql = [self.endSql stringByAppendingFormat:@"AND %@ = '%@' ",column,value];
    }

}

-(void)selectRowToDeleteWhere:(NSString*)column containsArray:(NSArray*)values{
    
    NSString *valuesString = [NSString stringWithFormat:@"('%@')",[values componentsJoinedByString:@"', '"]];
    
    if ([self.endSql isEqualToString:self.beginningSql]) {
        self.endSql = [self.endSql stringByAppendingFormat:@"WHERE %@ IN %@ ",column,valuesString];
    }
    else{
        self.endSql = [self.endSql stringByAppendingFormat:@"AND %@ IN %@ ",column,valuesString];
    }
    
}

-(void)deleteRow{
    
    NSString *post = [NSString stringWithFormat:@"sql=%@",self.endSql];
    
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

-(void)deleteRowInBackgroundWithBlock:(void(^)(NSError* error))block{
    NSString *post = [NSString stringWithFormat:@"sql=%@",self.endSql];
    
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
