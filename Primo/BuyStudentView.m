//
//  BuyStudentView.m
//  TeacherApp
//
//  Created by Jarrett Chen on 3/14/14.
//  Copyright (c) 2014 Jarrett Chen. All rights reserved.
//

#import "BuyStudentView.h"

@implementation BuyStudentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor redColor]];

    }
    
    return self;
}


//-(void)obtainFromParse{
//    NSString *objId = [[NSUserDefaults standardUserDefaults] objectForKey:@"ObjectId"];
//    self.items = [[NSMutableArray alloc] initWithCapacity:0];
//    self.iCoins = [[NSMutableArray alloc] initWithCapacity:0];
//    [self.studentTable reloadData];
//    NSString *teacherID = objId;
//    
//    NSMutableDictionary *studentDict = [[NSMutableDictionary alloc]initWithCapacity:0];
//    PFQuery *query = [PFQuery queryWithClassName:@"Classroom"];
//    [query whereKey:@"Teacher" equalTo:teacherID];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        NSMutableArray *sortedArray = [[NSMutableArray alloc]initWithCapacity:0];
//        
//        for (PFObject *studentObject in objects){
//            NSString *sName = [studentObject objectForKey:@"Student"];
//            [sortedArray addObject:sName];
//            NSNumber *sCoin = [studentObject objectForKey:@"Coins"];
//            [studentDict setValue:sCoin forKey:sName];
//        }//end of for loop
//        
//        [sortedArray sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
//        // NSString *key;
//        for (int i =0; i< sortedArray.count;i++){
//            //key = [sortedArray objectAtIndex:i]; //key is the name
//            [_iCoins addObject:[studentDict objectForKey:[sortedArray objectAtIndex:i]]];
//            [_items addObject:[sortedArray objectAtIndex:i]];
//        }
//        
//        _studentTable = [[UITableView alloc]initWithFrame:CGRectMake(0.0, 0.0, 320.0, self.frame.size.height) style:UITableViewStylePlain];
//        self.studentTable.allowsSelectionDuringEditing=YES;
//        _studentTable.delegate =self;
//        _studentTable.dataSource =self;
//        self.studentTable.allowsMultipleSelectionDuringEditing = YES;
//
//        [self addSubview:_studentTable];
//        [self.studentTable setEditing:YES animated:NO];
//        NSLog(@"SELECT");
//    }];
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_items count];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Update the delete button's title based on how many items are selected.
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Update the delete button's title based on how many items are selected.
    NSLog(@"Select");
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"studentCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"studentCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        UILabel* titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 3, 60,30)];
        [titleLabel setTag:90];
        [cell.contentView addSubview:titleLabel];
    }
    
    [(UILabel *)[cell.contentView viewWithTag:90] setText:[_items objectAtIndex:indexPath.row]]; //add text
    
    return cell;
}

//-(void)updateBuyViews{
//
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDelegate:self];
//    [UIView setAnimationDuration:2];
//
//    if(self.frame.size.width <= self.frame.origin.x){
//        //show the view
//        NSLog(@"SHOW VIEW %f is origin %f is width",self.frame.origin.x,self.frame.size.width);
//        self.frame = CGRectMake(0,64, self.frame.size.width, self.frame.size.height);
//        [UIView commitAnimations];
//        [self obtainFromParse];
//    }
//    else{
//        NSLog(@"CANCEL method starts here");
//        self.frame = CGRectMake(self.frame.size.width,64,self.frame.size.width,self.frame.size.height );
//        [UIView commitAnimations];
//    }
//}



@end
