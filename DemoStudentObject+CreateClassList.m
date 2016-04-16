//
//  DemoStudentObject+CreateClassList.m
//  Primo
//
//  Created by Jarrett Chen on 8/26/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import "DemoStudentObject+CreateClassList.h"

@implementation DemoStudentObject (CreateClassList)

+(DemoStudentObject*)createStudentObjectInCoreWithDictionary:(NSDictionary*)studentDictionary inManagedObjectContext:(NSManagedObjectContext*)context{
    
    
    DemoStudentObject *student = nil;
    
    NSString *studentObjectId = studentDictionary[@"objectId"];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"DemoStudentObject"];
    request.predicate = [NSPredicate predicateWithFormat:@"objectId = %@",studentObjectId];
    NSError *error;
    NSArray *foundStudent = [context executeFetchRequest:request error:&error];
    if (!foundStudent || error ||([foundStudent count]>1)) {
        NSLog(@"ERROR found:%d",[foundStudent count]);
        NSLog(@"ERROR found:%@",foundStudent);

    }
    else if([foundStudent count]){
        student = [foundStudent firstObject];
    }
    else{
        //if not found, put the studentObject from database to data core
        
        student = [NSEntityDescription insertNewObjectForEntityForName:@"DemoStudentObject" inManagedObjectContext:context];
        NSLog(@"%@",studentDictionary);
        
        NSNumber *stuNum = studentDictionary[@"studentNumber"];
        NSNumber *stuCoin = studentDictionary[@"coins"];
        int stuNumint = [stuNum intValue];
        int stuCoinint = [stuCoin intValue];
        
        
        student.objectId = studentObjectId;
        student.teacher = studentDictionary[@"teacher"];
        student.signedIn = studentDictionary[@"signedIn"];
        student.studentName = studentDictionary[@"studentName"];
        student.studentNumber = [NSNumber numberWithInt:stuNumint];
        student.coins = [NSNumber numberWithInt:stuCoinint];
        student.nameOfclass = studentDictionary[@"nameOfclass"];
        student.taken = studentDictionary[@"taken"];
    }
    
    return student;
}

-(void)addCoinsToStudentObject:(NSNumber*)coinNumber inManagedObjectContext:(NSManagedObjectContext*)context{
    
    int totalCoins = [self.coins intValue];
    totalCoins+=[coinNumber intValue];
    
    self.coins = [NSNumber numberWithInt:totalCoins];
    
    NSDictionary *econDict = @{@"earn": coinNumber,
                               @"spent":@0,
                               @"type":@"Teacher",
                               @"userId":self.objectId};
    
    [DemoEconomy createEconObjectInCoreWithDictionary:econDict inManagedObjectContext:context];
    
    [context save:nil];

    //save into economy and log
    

    
}

-(void)subtractCoinsToStudentObject:(NSNumber*)coinNumber inManagedObjectContext:(NSManagedObjectContext*)context{
    
    int totalCoins = [self.coins intValue];
    
    if (totalCoins!=0) {
        totalCoins-=[coinNumber intValue];
        self.coins = [NSNumber numberWithInt:totalCoins];
        
        [self.managedObjectContext save:nil];
        
        NSDictionary *econDict = @{@"earn": @0,
                                   @"spent":coinNumber,
                                   @"type":@"Teacher",
                                   @"userId":self.objectId};
        
        [DemoEconomy createEconObjectInCoreWithDictionary:econDict inManagedObjectContext:context];
        
        [context save:nil];
    }
    
}

-(void)buyCoinsStudentObject:(NSNumber*)coinNumber inManagedObjectContext:(NSManagedObjectContext*)context{
    int totalCoins = [self.coins intValue];
    
    if (totalCoins!=0) {
        totalCoins-=[coinNumber intValue];
        self.coins = [NSNumber numberWithInt:totalCoins];
        
        [self.managedObjectContext save:nil];
        
        NSDictionary *econDict = @{@"earn": @0,
                                   @"spent":coinNumber,
                                   @"type":@"Store",
                                   @"userId":self.objectId};
        
        [DemoEconomy createEconObjectInCoreWithDictionary:econDict inManagedObjectContext:context];
        
        [context save:nil];
    }
}


@end
