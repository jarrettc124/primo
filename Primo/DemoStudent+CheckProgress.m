
//
//  DemoStudent+CheckProgress.m
//  Primo
//
//  Created by Jarrett Chen on 9/4/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import "DemoStudent+CheckProgress.h"

@implementation DemoStudent (CheckProgress)


+(DemoStudent*)findStudentProgress:(NSManagedObjectContext*)context{
    
    
    DemoStudent *studentProgress = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"DemoStudent"];
    NSError *error;
    NSArray *foundStudentProg = [context executeFetchRequest:request error:&error];
    if (!foundStudentProg || error ||([foundStudentProg count]>1)) {
        NSLog(@"ERROR found:%d",[foundStudentProg count]);
        
    }
    else if([foundStudentProg count]){
        studentProgress = [foundStudentProg firstObject];
    }
    else{
        //if not found, put the studentObject from database to data core
        
        studentProgress = [NSEntityDescription insertNewObjectForEntityForName:@"DemoStudent" inManagedObjectContext:context];
        
        studentProgress.addClassDone= [NSNumber numberWithBool:NO];
        studentProgress.checkStatsDone=[NSNumber numberWithBool:NO];
        studentProgress.studentsBuyDone = [NSNumber numberWithBool:NO];
        
        [context save:nil];
    }
    
    return studentProgress;
}


-(CGFloat)getTotalProgress{
    
    int totalProgress =  [self.addClassDone intValue]+[self.checkStatsDone intValue]+[self.studentsBuyDone intValue];
    
    return (CGFloat)totalProgress/3;
}

-(UIImageView*)demoProgressTotalFrame:(CGRect)frame{
    
    UIImageView *progressChart = [[UIImageView alloc]initWithFrame:frame];
    [progressChart setImage:[UIImage imageNamed:@"blackboardBorder"]];
    
    UITableView *tableProgress = [[UITableView alloc]initWithFrame:CGRectMake(10, 20, progressChart.frame.size.width-20, progressChart.frame.size.height-80)];
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
    
    return 3;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray* dataSource = @[@"Join a Class",@"Check your stats",@"Buy an item"];
    NSArray* isDoneArray = @[self.addClassDone,self.checkStatsDone,self.studentsBuyDone];
    
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
