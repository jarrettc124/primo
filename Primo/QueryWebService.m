//
//  QueryWebService.m
//  Primo
//
//  Created by Jarrett Chen on 5/23/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import "QueryWebService.h"

@implementation QueryWebService

- (id)initWithTable:(NSString *)tableName{
    self = [super init];
    
    if (self) {
        self.beginningSql = [NSString stringWithFormat:@"SELECT * FROM %@ ",tableName];
        self.endSql = [NSString stringWithFormat:@"SELECT * FROM %@ ",tableName];
        _tableName=tableName;
    }
    return self;
    
}


-(void)selectColumnWhere:(NSString*)column equalTo:(NSString*)value{

    
    if ([self.endSql isEqualToString:self.beginningSql]) {
        self.endSql = [self.endSql stringByAppendingFormat:@"WHERE %@ = '%@' ",column,value];
    }
    else{
        self.endSql = [self.endSql stringByAppendingFormat:@"AND %@ = '%@' ",column,value];
    }
}

-(void)selectColumnWhere:(NSString*)column equalToNonStringValue:(NSString*)value{
    
    
    if ([self.endSql isEqualToString:self.beginningSql]) {
        self.endSql = [self.endSql stringByAppendingFormat:@"WHERE %@ = %@ ",column,value];
    }
    else{
        self.endSql = [self.endSql stringByAppendingFormat:@"AND %@ = %@ ",column,value];
    }
}

-(void)selectColumnWhere:(NSString*)column containsArray:(NSArray*)values{
    
    NSString *valuesString = [NSString stringWithFormat:@"('%@')",[values componentsJoinedByString:@"', '"]];
    
    if ([self.endSql isEqualToString:self.beginningSql]) {
        self.endSql = [self.endSql stringByAppendingFormat:@"WHERE %@ IN %@ ",column,valuesString];
    }
    else{
        self.endSql = [self.endSql stringByAppendingFormat:@"AND %@ IN %@ ",column,valuesString];
    }
    
}

-(void)orderByDescendingForColumn:(NSString*)column{
    
    self.endSql = [self.endSql stringByAppendingFormat:@"ORDER BY %@ DESC",column];
}

-(void)orderByAscendingForColumn:(NSString*)column{
    
    self.endSql = [self.endSql stringByAppendingFormat:@"ORDER BY %@ ASC",column];
}

-(void)setLimit:(NSInteger)limit whereOffset:(NSInteger)offSet{

    self.endSql = [self.endSql stringByAppendingFormat:@" LIMIT %d OFFSET %d",limit,offSet];
    
}

+(void)emailLogin:(NSString*)email withPassword:(NSString*)password withCompletionHandler:(void(^)(NSError* error,id result))completionHandler{
    
    if (email != nil && password != nil) {
        
        NSString *post = [NSString stringWithFormat:@"login=yes&email=%@&password=%@",email,password];
        
        NSLog(@"POST: %@",post);
        
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:@"https://lcedu-php.herokuapp.com/user_login.php"]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
        NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
            if (!error) {
                
                id result = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:location] options:NSJSONReadingAllowFragments error:&error];
                NSError *error = nil;
                
                NSLog(@"result: %@",result);
                
                if (result != nil) {
                    if (result[@"error"] != nil) {
                        error = [NSError errorWithDomain:@"error.domain" code:[result[@"code"] intValue] userInfo:@{@"errorMessage":result[@"message"]}];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completionHandler(error,nil);
                        });
                    }else{
                        
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completionHandler(nil,result);
                        });
                    }
                }else{
                    error = [NSError errorWithDomain:@"error.domain" code:500 userInfo:nil];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completionHandler(error,nil);
                    });
                }
                
        
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionHandler(error,nil);
                });
            }
            
        }];
        [task resume];
        
    }
    
}

-(void)findAllObjectsInRowWithCompletion:(void(^)(NSError* error,NSArray* rows))block{
    
    if(self.endSql !=nil){
        
        NSString *post = [NSString stringWithFormat:@"sql=%@",self.endSql];
        
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:@"https://lcedu-php.herokuapp.com/query.php"]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
        NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
            
            NSLog(@"%@ %@",error, response);
            
            if (!error) {
                
                NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:location] options:NSJSONReadingAllowFragments error:&error];
                
                
                if ([jsonArray count]==0) {
                    jsonArray=nil;
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(nil,jsonArray);
                });
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(error,nil);
                });
            }

        }];
        [task resume];
    }
}


@end
