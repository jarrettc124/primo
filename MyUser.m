//
//  MyUser.m
//  Primo
//
//  Created by Jarrett Chen on 2/22/16.
//  Copyright © 2016 Pixel and Processor. All rights reserved.
//

#import "MyUser.h"
#import "UpdateWebService.h"
#import "PushWebService.h"

static MyUser* sharedUser = nil;
@implementation MyUser

+(void)storeDefaults:(NSDictionary*)userDict{
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:userDict[@"ObjectId"] forKey:@"ObjectId"];
    
    if([userDict[@"UserType"] intValue] == 0){
        [defaults setObject:@"Teacher" forKey:@"UserType"];
    }else{
        [defaults setObject:@"Student" forKey:@"UserType"];
    }
    
    [defaults setObject:userDict[@"Email"] forKey:@"Email"];
    [defaults setObject:userDict[@"UserId"] forKey:@"UserId"];
    [defaults setObject:userDict[@"FirstName"] forKey:@"FirstName"];
    [defaults setObject:userDict[@"LastName"] forKey:@"LastName"];
    [defaults setObject:userDict[@"Gender"] forKey:@"Gender"];
    [defaults setObject:userDict[@"UniversalToken"] forKey:@"UniversalToken"];
    [defaults synchronize];
    
    if ([userDict[@"UserType"] intValue] == 1){
        
        //Tell the teacher that you have logged in
        UpdateWebService *updateService = [[UpdateWebService alloc]initWithTable:@"StudentObject"];
        [updateService setRowToUpdateWhereColumn:@"signedIn" equalTo:@"1"];
        [updateService selectRowToUpdateWhereColumn:@"taken" equalTo:userDict[@"ObjectId"]];
        [updateService saveUpdate];
        
    }
    
    NSString *devicetoken = [defaults objectForKey:@"DeviceToken"];
    PushWebService *pushService = [[PushWebService alloc]init];
    [pushService setDeviceTokenToUserID:userDict[@"ObjectId"] deviceToken:devicetoken];
    
}

+(void)removeDefaults{
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"ObjectId"];
    [defaults removeObjectForKey:@"UserType"];
    [defaults removeObjectForKey:@"Email"];
    [defaults removeObjectForKey:@"UserId"];
    [defaults removeObjectForKey:@"FirstName"];
    [defaults removeObjectForKey:@"LastName"];
    [defaults removeObjectForKey:@"Gender"];
    [defaults removeObjectForKey:@"UniversalToken"];
    [defaults synchronize];
    

}

+ (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

+(BOOL)isLoggedIn {
    NSString *universalToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"UniversalToken"];
    
    if (universalToken) {
        // User is logged in, do work such as go to next view controller.
        return YES;
    }
    else{
        return NO;
    }
}


@end
