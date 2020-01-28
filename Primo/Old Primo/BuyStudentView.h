//
//  BuyStudentView.h
//  TeacherApp
//
//  Created by Jarrett Chen on 3/14/14.
//  Copyright (c) 2014 Jarrett Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BuyStudentView : UIView <UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) NSMutableArray *items;
@property(nonatomic,strong) NSMutableArray *iCoins;
@property (nonatomic,strong) UITableView *studentTable;

-(void)updateBuyViews;
-(void)obtainFromParse;
@end
