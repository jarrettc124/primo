//
//  LogWebService.m
//  Primo
//
//  Created by Jarrett Chen on 5/30/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import "LogWebService.h"

@implementation LogWebService

- (id)initWithLogType:(NSString *)logType{
    self = [super init];
    
    if (self) {
        _logType = logType;
    }
    return self;
}

-(void)updateLogWithUserId:(NSString*)idNum className:(NSString*)nameOfClass updateLogString:(NSString*)logString{
    //need to set everyClassList Before it works
    
    NSDateFormatter *annDateFormatter = [[NSDateFormatter alloc] init];
    annDateFormatter.timeZone = [NSTimeZone localTimeZone];
    annDateFormatter.dateFormat = @"MM/dd/yyyy";
    NSString *dateString = [annDateFormatter stringFromDate:[NSDate date]];
    //writing the text in new file
    
    
    NSString *post = [NSString stringWithFormat:@"log_type=%@&user_id=%@&class_name=%@&current_date=%@&log_string=%@",_logType,idNum,nameOfClass,dateString,logString];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://www.pixelandprocessor.com/stanton/logs/user_log.php"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Check your internet");
        }
        
    }];
    [task resume];
}

-(void)renameClassNameWithTeacherId:(NSString*)teacherId withStudentObjIdArray:(NSArray*)studentObjIdArray oldClassName:(NSString*)oldName newClassName:(NSString*)newName{
    
    //Array of all the log ids
    NSMutableArray *logIdArray = [NSMutableArray arrayWithArray:studentObjIdArray];
    [logIdArray addObject:teacherId];
    
    //Convert logIdArray to JSON string
    NSError *error;
    NSData *JSONData = [NSJSONSerialization dataWithJSONObject:logIdArray options:0 error:&error];
    NSString *JSONString = [[NSString alloc]initWithData:JSONData encoding:NSUTF8StringEncoding];
    
    //POST to PHP Script
    NSString *post = [NSString stringWithFormat:@"logid_list=%@&old_class_name=%@&new_class_name=%@",JSONString,oldName,newName];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://www.pixelandprocessor.com/stanton/logs/rename_class.php"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Check your internet");
        }
        
    }];
    [task resume];
}

-(void)deleteLogsWithId:(NSArray*)idNumArray{
    
    NSError *error;
    NSData *jsonDataArray = [NSJSONSerialization dataWithJSONObject:idNumArray options:0 error:&error];
    NSString *JSONStringArray = [[NSString alloc] initWithData:jsonDataArray encoding:NSUTF8StringEncoding];
    
    NSString *post = [NSString stringWithFormat:@"log_type=%@&user_id_array=%@&delete=delete",_logType,JSONStringArray];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://www.pixelandprocessor.com/stanton/logs/user_log.php"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        NSLog(@"done delete");
        if (error) {
            NSLog(@"Check your internet");
        }
        
    }];
    [task resume];

    
}

-(void)printLogOutToUI:(NSString*)idNum className:(NSString*)nameOfClass logMonth:(NSInteger)month completion:(void(^)(BOOL finished,NSError* error,NSString* result))printBlock{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *rawURL = [NSString stringWithFormat:@"http://www.pixelandprocessor.com/stanton/logs/%@/%@/%@/%d/log.txt",_logType,idNum,[nameOfClass lowercaseString],month];

        NSString *newURL = [rawURL stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];

        
        NSURL *URL = [NSURL URLWithString:newURL];
        
        
        NSError *error;
        NSString *stringFromFileAtURL = [[NSString alloc]initWithContentsOfURL:URL encoding:NSASCIIStringEncoding error:&error];
        
        if (!stringFromFileAtURL) {
            stringFromFileAtURL=@"The log is currently empty";
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            
            if (stringFromFileAtURL ==nil) {
                printBlock(YES,error,stringFromFileAtURL);
            }
            else{
                printBlock(YES,nil,stringFromFileAtURL);
            }
            
            
        });
    });
    
}



@end
