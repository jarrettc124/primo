//
//  AnnouncementObject.m
//  Primo
//
//  Created by Jarrett Chen on 5/12/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import "AnnouncementObject.h"

@implementation AnnouncementObject

- (id)initWithTeacherId:(NSString *)teacherid{
    self = [super init];
    
    if (self) {
        _teacherId = teacherid;
        _broadcastOffset = 0;
    }
    return self;
    
}

-(void)postAnnouncementTo:(NSString*)recipient announcementType:(NSString*)aType personType:(NSString*)typeOfPerson announcementBody:(NSString*)aBody{
    
    //Set Date
    NSDateFormatter *annDateFormatter = [[NSDateFormatter alloc] init];
    annDateFormatter.timeZone = [NSTimeZone localTimeZone];
    annDateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *dateString = [annDateFormatter stringFromDate:[NSDate date]];
    
    if (_teacherId !=nil) {
        InsertWebService *insert = [[InsertWebService alloc]initWithTable:@"Broadcast"];
        [insert insertObjectInColumnWhere:@"TeacherId" setObjectValue:_teacherId];
        [insert insertObjectInColumnWhere:@"Recipient" setObjectValue:recipient];
        [insert insertObjectInColumnWhere:@"PersonType" setObjectValue:typeOfPerson];
        [insert insertObjectInColumnWhere:@"AnnouncementType" setObjectValue:aType];
        [insert insertObjectInColumnWhere:@"AnnouncementBody" setObjectValue:aBody];
        [insert insertObjectInColumnWhere:@"CreatedAt" setObjectValue:dateString];
        [insert saveIntoDatabaseInBackgroundWithBlock:^(NSError *error) {
            if (error) {
                
//                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Post failed" message:@"You must have a network connection to post a broadcast" preferredStyle:UIAlertControllerStyleAlert];
                
            }
        }];
        
    }
    else{
        NSLog(@"Error: Forgot to input teacherID");
    }
    
}


-(void)getAnnouncementArrayFor:(NSString*)personType className:(NSString*)nameOfClass completion:(void(^)(NSArray* objectArray, NSError *error))compBlock{
    
    if ([personType isEqualToString:@"Teacher"]) {
        
        QueryWebService *query = [[QueryWebService alloc]initWithTable:@"Broadcast"];
        [query selectColumnWhere:@"TeacherId" equalTo:_teacherId];
        [query selectColumnWhere:@"Recipient" containsArray:@[@"Every Class",nameOfClass]];
        [query selectColumnWhere:@"PersonType" containsArray:@[@"Student",@"Teacher"]];
        [query orderByDescendingForColumn:@"CreatedAt"];
        [query setLimit:10 whereOffset:_broadcastOffset];
        [query findAllObjectsInRowWithCompletion:^(NSError *error, NSArray *rows) {
            compBlock(rows,error);
        }];
        
    }
    else{
        NSString *objId = [[NSUserDefaults standardUserDefaults] objectForKey:@"ObjectId"];
        
        QueryWebService *query = [[QueryWebService alloc]initWithTable:@"Broadcast"];
        [query selectColumnWhere:@"TeacherId" equalTo:_teacherId];
        [query selectColumnWhere:@"Recipient" containsArray:@[@"Every Class",nameOfClass,objId]];
        [query selectColumnWhere:@"PersonType" equalTo:@"Student"];
        [query orderByDescendingForColumn:@"CreatedAt"];
        [query setLimit:10 whereOffset:_broadcastOffset];
        [query findAllObjectsInRowWithCompletion:^(NSError *error, NSArray *rows) {
            compBlock(rows,error);
        }];

    }
}

-(void)deleteRowInBroadcast:(id)row{
    DeleteWebService *deleteRow = [[DeleteWebService alloc]initWithTable:@"Broadcast"];
    [deleteRow selectRowToDeleteWhereColumn:@"PostId" equalTo:row[@"PostId"]];
    [deleteRow deleteRow];
    
}

//badges
-(void)updateBadgeToDatabaseWithId:(NSString*)idNum className:(NSString*)nameOfClass{
    //will create an object in database if not there.
    
    QueryWebService *query = [[QueryWebService alloc]initWithTable:@"BroadcastBadge"];
    [query selectColumnWhere:@"id" equalTo:idNum];
    if (nameOfClass !=nil) {
        [query selectColumnWhere:@"ClassName" equalTo:nameOfClass];
    }
    [query findAllObjectsInRowWithCompletion:^(NSError *error, NSArray *rows) {
        
        if ([rows count]==0) {
            
            InsertWebService *insertNew = [[InsertWebService alloc]initWithTable:@"BroadcastBadge"];
            [insertNew insertObjectInColumnWhere:@"id" setObjectValue:idNum];
            if (nameOfClass !=nil) {
                [insertNew insertObjectInColumnWhere:@"ClassName" setObjectValue:nameOfClass];
            }
            [insertNew insertObjectInColumnWhere:@"Badge" setObjectValue:@"1"];
            [insertNew saveIntoDatabase];
        }
        
        else{
            NSDictionary *badgeDict = [rows firstObject];
            NSNumber *badgeNum = badgeDict[@"Badge"];
            int badgeInt = [badgeNum intValue];
            badgeInt++;
            badgeNum = [NSNumber numberWithInt:badgeInt];
            UpdateWebService *update = [[UpdateWebService alloc]initWithTable:@"BroadcastBadge"];
            [update setRowToUpdateWhereColumn:@"Badge" equalTo:[badgeNum stringValue]];
            [update selectRowToUpdateWhereColumn:@"id" equalTo:idNum];
            if (nameOfClass !=nil) {
                [query selectColumnWhere:@"ClassName" equalTo:nameOfClass];
            }
            [update saveUpdate];
            
        }
        
        
    }];
    
}


-(void)restartBadgeInDatabase:(NSString*)idNum className:(NSString*)nameOfClass{
    
    QueryWebService *query = [[QueryWebService alloc]initWithTable:@"BroadcastBadge"];
    [query selectColumnWhere:@"id" equalTo:idNum];
    [query selectColumnWhere:@"ClassName" equalTo:nameOfClass];
    [query findAllObjectsInRowWithCompletion:^(NSError *error, NSArray *rows) {
        if ([rows count]==0) {
            InsertWebService *insertNew = [[InsertWebService alloc]initWithTable:@"BroadcastBadge"];
            [insertNew insertObjectInColumnWhere:@"id" setObjectValue:idNum];
            [insertNew insertObjectInColumnWhere:@"ClassName" setObjectValue:nameOfClass];
            [insertNew insertObjectInColumnWhere:@"Badge" setObjectValue:@"0"];
            [insertNew saveIntoDatabase];
        }
        
        else{
            UpdateWebService *update = [[UpdateWebService alloc]initWithTable:@"BroadcastBadge"];
            [update setRowToUpdateWhereColumn:@"Badge" equalTo:@"0"];
            [update selectRowToUpdateWhereColumn:@"id" equalTo:idNum];
            [update selectRowToUpdateWhereColumn:@"ClassName" equalTo:nameOfClass];
            [update saveUpdate];
            
        }
        
    }];


}

-(void)getBadgeNumber:(NSString*)idNum className:(NSString*)nameOfClass completion:(myCompletion)compBlock{
    
    QueryWebService *query = [[QueryWebService alloc]initWithTable:@"BroadcastBadge"];
    [query selectColumnWhere:@"id" equalTo:idNum];
    [query selectColumnWhere:@"ClassName" equalTo:nameOfClass];
    [query findAllObjectsInRowWithCompletion:^(NSError *error, NSArray *rows) {
        
        if ([rows count]==0) {
        }
        
        else{
            
            NSDictionary *badgeDict = [rows firstObject];
            NSNumber *badgeNum = badgeDict[@"Badge"];
            int badgeInt = [badgeNum intValue];
            compBlock(YES,[NSNumber numberWithInt:badgeInt]);
        
        }
        
    }];
    
}
@end
