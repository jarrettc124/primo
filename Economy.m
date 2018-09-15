//
//  Economy.m
//  Primo
//
//  Created by Jarrett Chen on 8/23/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import "Economy.h"

@implementation Economy

-(id)initWithClassName:(NSString*)className withManagedContent:(NSManagedObjectContext*)managedContext{
    
    self = [super init];
    
    if (self) {
        
        self.className = className;
        self.managedObjectContext = managedContext;
    }
    return self;
    
}


-(void)studentEconomyAction:(NSString*)action_event withAmount:(int)amount objectId:(NSString*)studentObjectId{
        NSString *objId = [[NSUserDefaults standardUserDefaults] objectForKey:@"ObjectId"];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *pickerDate = [calendar components:unitFlags fromDate:[NSDate date]];
    
    
    NSError *error;
    NSFetchRequest *studentsRequest = [NSFetchRequest fetchRequestWithEntityName:@"StudentObject"];
    studentsRequest.predicate= [NSPredicate predicateWithFormat:@"(teacher = %@) AND (nameOfclass = %@)",objId,[self.className lowercaseString]];
    NSArray *studentObjArray = [_managedObjectContext executeFetchRequest:studentsRequest error:&error];
    
    NSMutableArray *jsonDictionaryArray = [[NSMutableArray alloc]initWithCapacity:0];
    for (StudentObject*studentObj in studentObjArray) {
        NSDictionary *jsonDict = @{@"objectId":studentObj.objectId,@"coins":studentObj.coins};
        [jsonDictionaryArray addObject:jsonDict];
    }
    
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionaryArray options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString *post = [NSString stringWithFormat:@"action_event=%@&month=%d&day=%d&year=%d&object_id=%@&rows_array=%@&amount=%d",action_event,[pickerDate month],[pickerDate day],[pickerDate year],studentObjectId,jsonString,amount];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"https://lcedu-php.herokuapp.com/economy/economy.php"]];
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
