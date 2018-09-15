//
//  PushWebService.m
//  Primo
//
//  Created by Jarrett Chen on 5/21/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import "PushWebService.h"

@implementation PushWebService

-(void)setDeviceTokenToUserID:(NSString*)userId deviceToken:(NSString*)token{
    
    if (token) {

        NSString *post = [NSString stringWithFormat:@"mutator=set&user_id=%@&device_token=%@",userId,token];
        
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:@"https://lcedu-php.herokuapp.com/push_notification/notification.php"]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
        NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
            NSLog(@"start session download task");
            if (error) {
                NSLog(@"Sorry: Check your internet");
            }
            
        }];
        [task resume];
    }
}

-(void)removeTokenFromUserId:(NSString*)userId deviceToken:(NSString*)token{
    if (token) {
        
        NSString *post = [NSString stringWithFormat:@"mutator=delete&user_id=%@&device_token=%@",userId,token];
        
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:@"https://lcedu-php.herokuapp.com/push_notification/notification.php"]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
        NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
            NSLog(@"start session download task");
            if (error) {
                NSLog(@"Sorry: Check your internet");
            }
            
            NSLog(@"end session download task");
            
        }];
        [task resume];
    }
    
}

-(void)sendPushToUserIDS:(NSArray*)toIds pushMessage:(NSString*)message{
    
    NSError* error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:toIds options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString *post = [NSString stringWithFormat:@"mutator=send&to_user_id=%@&message=%@",jsonString,message];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"https://lcedu-php.herokuapp.com/push_notification/notification.php"]];
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

@end
