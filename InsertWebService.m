//
//  InsertWebService.m
//  Primo
//
//  Created by Jarrett Chen on 5/23/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import "InsertWebService.h"

@implementation InsertWebService

- (id)initWithTable:(NSString *)tableName{
    self = [super init];
    
    if (self) {
        self.columnArray = [[NSMutableArray alloc]initWithCapacity:0];
        self.valuesArray = [[NSMutableArray alloc]initWithCapacity:0];
        self.multipleValuesArray = [[NSMutableArray alloc]initWithCapacity:0];
        self.sql = [NSString stringWithFormat:@"INSERT INTO %@ ",tableName];
    }
    return self;
    
}

-(void)insertObjectInColumnWhere:(NSString*)column setObjectValue:(NSString*)value{
    [self.columnArray addObject:column];
    [self.valuesArray addObject:value];
}

-(void)insertMultipleObjectsInColumnsWhere:(NSArray*)columns setObjectsValues:(NSArray*)values{
    
    [self.columnArray removeAllObjects];
    [self.columnArray addObjectsFromArray:columns];
    
    [self.multipleValuesArray addObjectsFromArray:values];
    
}

-(void)saveTheUserInDatabase{
    
    if (self.sql !=nil && [self.columnArray count]>0) {
        
        NSString *columnString = [NSString stringWithFormat:@"(%@)",[self.columnArray componentsJoinedByString:@", "]];
        
        if ([self.valuesArray count] !=0) {
            NSString *valuesString = [NSString stringWithFormat:@"('%@')",[self.valuesArray componentsJoinedByString:@"', '"]];
            NSString *totalString = [NSString stringWithFormat:@"%@ VALUES %@",columnString,valuesString];
            self.sql = [self.sql stringByAppendingString:totalString];
        }
        else if ([self.multipleValuesArray count] != 0){
            
            NSString *totalValuesString = [NSString stringWithFormat:@"%@ VALUES ",columnString];
            
            for (int i =0;i<[self.multipleValuesArray count];i++) {
                
                NSMutableArray *itemObjectArray = [NSMutableArray arrayWithArray:[self.multipleValuesArray objectAtIndex:i]];
                
                if (i == [self.multipleValuesArray count]-1) {
                    
                    
                    NSString *valuesString = [NSString stringWithFormat:@"('%@')",[itemObjectArray componentsJoinedByString:@"', '"]];
                    totalValuesString = [totalValuesString stringByAppendingString:valuesString];
                    
                }
                else{
                    
                    NSString *valuesString = [NSString stringWithFormat:@"('%@'),",[itemObjectArray componentsJoinedByString:@"', '"]];
                    totalValuesString = [totalValuesString stringByAppendingString:valuesString];
                }
                
            }
            
            self.sql = [self.sql stringByAppendingString:totalValuesString];
        }
        
        
        NSString *post = [NSString stringWithFormat:@"sql=%@",self.sql];
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:@"http://www.pixelandprocessor.com/stanton/user_login.php"]];
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

    
}

-(void)saveTheUserInDatabaseInBackground:(void(^)(NSError* error,id result))block{
    
    if (self.sql !=nil && [self.columnArray count]>0) {
        
        NSString *columnString = [NSString stringWithFormat:@"(%@)",[self.columnArray componentsJoinedByString:@", "]];
        
        if ([self.valuesArray count] !=0) {
            NSString *valuesString = [NSString stringWithFormat:@"('%@')",[self.valuesArray componentsJoinedByString:@"', '"]];
            NSString *totalString = [NSString stringWithFormat:@"%@ VALUES %@",columnString,valuesString];
            self.sql = [self.sql stringByAppendingString:totalString];
        }
        else if ([self.multipleValuesArray count] != 0){
            
            NSString *totalValuesString = [NSString stringWithFormat:@"%@ VALUES ",columnString];
            
            for (int i =0;i<[self.multipleValuesArray count];i++) {
                
                NSMutableArray *itemObjectArray = [NSMutableArray arrayWithArray:[self.multipleValuesArray objectAtIndex:i]];
                
                if (i == [self.multipleValuesArray count]-1) {
                    
                    
                    NSString *valuesString = [NSString stringWithFormat:@"('%@')",[itemObjectArray componentsJoinedByString:@"', '"]];
                    totalValuesString = [totalValuesString stringByAppendingString:valuesString];
                    
                }
                else{
                    
                    NSString *valuesString = [NSString stringWithFormat:@"('%@'),",[itemObjectArray componentsJoinedByString:@"', '"]];
                    totalValuesString = [totalValuesString stringByAppendingString:valuesString];
                }
                
            }
            
            self.sql = [self.sql stringByAppendingString:totalValuesString];
        }
        
        
        NSString *post = [NSString stringWithFormat:@"sql=%@",self.sql];
        NSLog(@"POST: %@",post);
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:@"http://www.pixelandprocessor.com/stanton/user_login.php"]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
        NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
            
            
            id json = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:location] options:NSJSONReadingAllowFragments error:&error];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                block(error,json);
                
            });
            
        }];
        [task resume];
        
    }
    
    
}

-(void)saveIntoDatabase{
    
    if (self.sql !=nil && [self.columnArray count]>0) {
        
        NSString *columnString = [NSString stringWithFormat:@"(%@)",[self.columnArray componentsJoinedByString:@", "]];
        
        if ([self.valuesArray count] !=0) {
            NSString *valuesString = [NSString stringWithFormat:@"('%@')",[self.valuesArray componentsJoinedByString:@"', '"]];
            NSString *totalString = [NSString stringWithFormat:@"%@ VALUES %@",columnString,valuesString];
            self.sql = [self.sql stringByAppendingString:totalString];
        }
        else if ([self.multipleValuesArray count] != 0){
            
            NSString *totalValuesString = [NSString stringWithFormat:@"%@ VALUES ",columnString];
            
            for (int i =0;i<[self.multipleValuesArray count];i++) {
                
                NSMutableArray *itemObjectArray = [NSMutableArray arrayWithArray:[self.multipleValuesArray objectAtIndex:i]];
                
                if (i == [self.multipleValuesArray count]-1) {

                    
                    NSString *valuesString = [NSString stringWithFormat:@"('%@')",[itemObjectArray componentsJoinedByString:@"', '"]];
                   totalValuesString = [totalValuesString stringByAppendingString:valuesString];
                    
                }
                else{

                    NSString *valuesString = [NSString stringWithFormat:@"('%@'),",[itemObjectArray componentsJoinedByString:@"', '"]];
                    totalValuesString = [totalValuesString stringByAppendingString:valuesString];
                }
                
            }
            
            self.sql = [self.sql stringByAppendingString:totalValuesString];
        }
        
        
        NSString *post = [NSString stringWithFormat:@"sql=%@",self.sql];
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:@"http://www.pixelandprocessor.com/stanton/insertordelete.php"]];
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
    
}

-(void)saveIntoDatabaseInBackgroundWithBlock:(void(^)(NSError* error))block{
    if (self.sql !=nil && [self.columnArray count]>0) {
        
        
        NSString *columnString = [NSString stringWithFormat:@"(%@)",[self.columnArray componentsJoinedByString:@", "]];
        
        if ([self.valuesArray count] !=0) {
            
            NSString *valuesString = [NSString stringWithFormat:@"('%@')",[self.valuesArray componentsJoinedByString:@"', '"]];
            NSString *totalString = [NSString stringWithFormat:@"%@ VALUES %@",columnString,valuesString];
            self.sql = [self.sql stringByAppendingString:totalString];
        }
        else if ([self.multipleValuesArray count] != 0){
            
            NSString *totalValuesString = [NSString stringWithFormat:@"%@ VALUES ",columnString];
            
            for (int i =0;i<[self.multipleValuesArray count];i++) {
                
                if (i == [self.multipleValuesArray count]-1) {
                    NSString *valuesString = [NSString stringWithFormat:@"('%@')",[self.multipleValuesArray[i] componentsJoinedByString:@"', '"]];
                    totalValuesString = [totalValuesString stringByAppendingString:valuesString];
                }
                else{
                    NSString *valuesString = [NSString stringWithFormat:@"('%@'),",[self.multipleValuesArray[i] componentsJoinedByString:@"', '"]];
                    totalValuesString = [totalValuesString stringByAppendingString:valuesString];
                }
                
            }
            
            self.sql = [self.sql stringByAppendingString:totalValuesString];
        }
        
        
        NSString *post = [NSString stringWithFormat:@"sql=%@",self.sql];
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:@"http://www.pixelandprocessor.com/stanton/insertordelete.php"]];
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
}

@end
