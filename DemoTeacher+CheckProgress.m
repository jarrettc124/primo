//
//  DemoTeacher+CheckProgress.m
//  Primo
//
//  Created by Jarrett Chen on 9/2/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import "DemoTeacher+CheckProgress.h"

@implementation DemoTeacher (CheckProgress)

+(DemoTeacher*)findTeacherProgress:(NSManagedObjectContext*)context{
    
    
    DemoTeacher *teacherProgress = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"DemoTeacher"];
    NSError *error;
    NSArray *foundTeacherProg = [context executeFetchRequest:request error:&error];
    if (!foundTeacherProg || error ||([foundTeacherProg count]>1)) {
        NSLog(@"ERROR found:%d",[foundTeacherProg count]);
        NSLog(@"ERROR found:%@",foundTeacherProg);
        
    }
    else if([foundTeacherProg count]){
        teacherProgress = [foundTeacherProg firstObject];
    }
    else{
        //if not found, put the studentObject from database to data core
        
        teacherProgress = [NSEntityDescription insertNewObjectForEntityForName:@"DemoTeacher" inManagedObjectContext:context];
        
        teacherProgress.addClassDone= [NSNumber numberWithBool:NO];
        teacherProgress.addCoinsDone=[NSNumber numberWithBool:NO];
        teacherProgress.manageCoinsDone=[NSNumber numberWithBool:NO];
        teacherProgress.openStoreDone=[NSNumber numberWithBool:NO];
        teacherProgress.buyStoreDone=[NSNumber numberWithBool:NO];
        teacherProgress.addBroadcastDone=[NSNumber numberWithBool:NO];
        teacherProgress.checkStats=[NSNumber numberWithBool:NO];
        
        [context save:nil];
    }
    
    return teacherProgress;
}


-(CGFloat)getTotalProgress{
    
    int totalProgress =  [self.addClassDone intValue]+[self.addCoinsDone intValue]+[self.manageCoinsDone intValue]+[self.openStoreDone intValue]+[self.buyStoreDone intValue]+[self.addBroadcastDone intValue]+[self.checkStats intValue];
    
    return (CGFloat)totalProgress/7;
}

-(UIImageView*)demoProgressTotalFrame:(CGRect)frame{

    UIImageView *progressChart = [[UIImageView alloc]initWithFrame:frame];
    [progressChart setImage:[UIImage imageNamed:@"blackboardBorder"]];
    
    UITableView *tableProgress = [[UITableView alloc]initWithFrame:CGRectMake(10, 20, progressChart.frame.size.width-20, progressChart.frame.size.height-80)];
    tableProgress.cellLayoutMarginsFollowReadableWidth = NO;
    tableProgress.delegate = self;
    tableProgress.dataSource=self;
    tableProgress.allowsSelection=NO;
    [tableProgress setBackgroundColor:[UIColor clearColor]];
    [progressChart addSubview:tableProgress];
    
    UILabel *label = [UILabel new];

    label.text = [NSString stringWithFormat:@"Demo List\nComplete %d%%",(int)([self getTotalProgress]*100)];
    
    NSMutableAttributedString *attributeTouchString = [[NSMutableAttributedString alloc] initWithString:label.text];
    [attributeTouchString addAttribute:NSFontAttributeName
                                 value:[UIFont fontWithName:@"Eraser" size:20]
                                 range:NSMakeRange(0,[label.text length]-1)];
    
    [label setAttributedText:attributeTouchString];
    
    [label setNumberOfLines:0];
    tableProgress.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,tableProgress.frame.size.width, 70)];
    //headerView
    label.textColor = [UIColor whiteColor];
    [label setFrame: CGRectMake(10,0,tableProgress.frame.size.width, 70)];
    [tableProgress.tableHeaderView addSubview:label];

    
    return progressChart;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 7;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray* dataSource = @[@"Add New Class",@"Add Coins For Students",@"Manage Coins",@"Open Store",@"Buy Items for Students",@"Add New Broadcast",@"Check Stats"];
    NSArray* isDoneArray = @[self.addClassDone,self.addCoinsDone,self.manageCoinsDone,self.openStoreDone,self.buyStoreDone,self.addBroadcastDone,self.checkStats];
    
    static NSString *CellIdentifier = @"studentCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"studentCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.backgroundColor=[UIColor clearColor];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    [cell.textLabel setFont:[UIFont fontWithName:@"Eraser" size:15]];
    cell.textLabel.text = [dataSource objectAtIndex:indexPath.row];
    
    if([[isDoneArray objectAtIndex:indexPath.row] boolValue]){
        NSMutableAttributedString *doneAttribute = [[NSMutableAttributedString alloc] initWithString:cell.textLabel.text];
        [doneAttribute addAttribute:NSStrikethroughStyleAttributeName
                              value:[NSNumber numberWithInteger:NSUnderlineStyleSingle]
                                     range:NSMakeRange(0,[cell.textLabel.text length])];
        
        [cell.textLabel setAttributedText:doneAttribute];
    }
    
    return cell;
}


@end
