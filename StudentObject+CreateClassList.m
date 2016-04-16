//
//  StudentObject+CreateClassList.m
//  Primo
//
//  Created by Jarrett Chen on 5/28/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import "StudentObject+CreateClassList.h"

@implementation StudentObject (CreateClassList)

+(StudentObject*)createStudentObjectInCoreWithDictionary:(NSDictionary*)studentDictionary inManagedObjectContext:(NSManagedObjectContext*)context{

    
    StudentObject *student = nil;
    
    NSString *studentObjectId = studentDictionary[@"objectId"];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"StudentObject"];
    request.predicate = [NSPredicate predicateWithFormat:@"objectId = %@",studentObjectId];
    NSError *error;
    NSArray *foundStudent = [context executeFetchRequest:request error:&error];
    if (!foundStudent || error ||([foundStudent count]>1)) {
        NSLog(@"ERROR found:%d",[foundStudent count]);
    }
    else if([foundStudent count]){
        student = [foundStudent firstObject];    
    }
    else{
        //if not found, put the studentObject from database to data core

        student = [NSEntityDescription insertNewObjectForEntityForName:@"StudentObject" inManagedObjectContext:context];
        NSLog(@"%@",studentDictionary);
        
        NSNumber *stuNum = studentDictionary[@"studentNumber"];
        NSNumber *stuCoin = studentDictionary[@"coins"];
        int stuNumint = [stuNum intValue];
        int stuCoinint = [stuCoin intValue];
        
        
        student.objectId = studentObjectId;
        student.teacherEmail = studentDictionary[@"teacherEmail"];
        student.studentName = studentDictionary[@"studentName"];
        student.studentNumber = [NSNumber numberWithInt:stuNumint];
        student.coins = [NSNumber numberWithInt:stuCoinint];
        student.nameOfclass = studentDictionary[@"className"];
        student.teacher = studentDictionary[@"teacher"];
        student.taken = studentDictionary[@"taken"];
        NSLog(@"done insert student!");
        NSLog(@"student end");


    }
    
    return student;
}

-(void)addCoinsToStudentObject:(NSNumber*)coinNumber{
    
    int totalCoins = [self.coins intValue];
    totalCoins+=[coinNumber intValue];
    
    self.coins = [NSNumber numberWithInt:totalCoins];
    
    [self.managedObjectContext save:nil];
    
    Economy *economy = [[Economy alloc]initWithClassName:self.nameOfclass withManagedContent:self.managedObjectContext];
    
    [economy studentEconomyAction:@"earn" withAmount:[coinNumber intValue] objectId:self.objectId];
    
}

-(void)subtractCoinsToStudentObject:(NSNumber*)coinNumber{
    
    int totalCoins = [self.coins intValue];
    totalCoins-=[coinNumber intValue];

    if (totalCoins<0) {
        totalCoins=0;
    }
    
    self.coins = [NSNumber numberWithInt:totalCoins];
    
    [self.managedObjectContext save:nil];
    
    Economy *economy = [[Economy alloc]initWithClassName:self.nameOfclass withManagedContent:self.managedObjectContext];
    
    [economy studentEconomyAction:@"taken" withAmount:[coinNumber intValue] objectId:self.objectId];
    
}

-(void)buyCoinsStudentObject:(NSNumber*)coinNumber{
    int totalCoins = [self.coins intValue];
    
    totalCoins-=[coinNumber intValue];
    
    if (totalCoins<0) {
        totalCoins=0;
    }
    
    self.coins = [NSNumber numberWithInt:totalCoins];
    
    [self.managedObjectContext save:nil];
    
    Economy *economy = [[Economy alloc]initWithClassName:self.nameOfclass withManagedContent:self.managedObjectContext];
    
    [economy studentEconomyAction:@"store" withAmount:[coinNumber intValue] objectId:self.objectId];
    
}



@end
