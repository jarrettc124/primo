//
//  MenuTable.m
//  TeacherApp
//
//  Created by Jarrett Chen on 3/10/14.
//  Copyright (c) 2014 Jarrett Chen. All rights reserved.
//

#import "MenuTable.h"

@implementation MenuTable

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)displayStudentMenu{
    
    
    _tapCloseRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    _tapCloseRecognizer.cancelsTouchesInView = NO;
    //_swipeCloseRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleGesture:)];
    //_swipeCloseRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self addGestureRecognizer:_tapCloseRecognizer];
    //[self addGestureRecognizer:_swipeCloseRecognizer];
    
    self.menuArray = [[NSArray alloc]initWithObjects:@"Add More Students",@"Manage Coins",@"Delete Students",@"Teacher's Log",@"Group Students",@"Sort Students By:", nil];
    self.menuArrayImages =[[NSArray alloc]initWithObjects:[UIImage imageNamed:@"AddImageButton"],[UIImage imageNamed:@"goldCoin"],[UIImage imageNamed:@"trashcanImage"],[UIImage imageNamed:@"bookIcon"],[UIImage imageNamed:@"groupIcon"],[UIImage imageNamed:@"SortImage"], nil];
    
    UILabel *label = [[UILabel alloc]init];

    if (IS_IPAD) {
        _menuViewTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        UIImageView *background = [[UIImageView alloc]initWithFrame:self.menuViewTable.frame];
        [background setImage:[UIImage imageNamed:@"blackboardBackground"]];
        [self.menuViewTable setBackgroundView:background];
        [self addSubview:_menuViewTable];
        _menuViewTable.translatesAutoresizingMaskIntoConstraints=NO;
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_menuViewTable attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
        
        [_menuViewTable addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_menuViewTable(400)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_menuViewTable)]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_menuViewTable]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_menuViewTable)]];
        
        _menuViewTable.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 400, 70)];
        //headerView
        label.text = @"Teacher Menu";
        label.font = [UIFont fontWithName:@"Eraser" size:23];
        label.textColor = [UIColor whiteColor];
        [label setFrame: CGRectMake(10,40,400, 30)];
        [_menuViewTable.tableHeaderView addSubview:label];

    }
    else if (IS_IPHONE){
        _menuViewTable = [[UITableView alloc]initWithFrame:CGRectMake(51, self.frame.origin.y, self.frame.size.width-51, self.frame.size.height) style:UITableViewStyleGrouped];
        UIImageView *background = [[UIImageView alloc]initWithFrame:self.menuViewTable.frame];
        [background setImage:[UIImage imageNamed:@"blackboardBackground"]];
        [self.menuViewTable setBackgroundView:background];
        background.contentMode = UIViewContentModeRight;
        [self addSubview:_menuViewTable];
        _menuViewTable.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.menuViewTable.frame.size.width, 70)];
        label.text = @"Teacher Menu";
        label.font = [UIFont fontWithName:@"Eraser" size:23];
        label.textColor = [UIColor whiteColor];
        [label setFrame: CGRectMake(10,40,self.menuViewTable.frame.size.width, 30)];
        [_menuViewTable.tableHeaderView addSubview:label];
    }
    

    self.menuViewTable.scrollEnabled=NO;
    _menuViewTable.delegate=self;
    _menuViewTable.dataSource =self;
    _menuViewTable.separatorStyle=UITableViewCellSeparatorStyleNone;


}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_menuArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"studentCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    NSString *cellValue = [self.menuArray objectAtIndex:indexPath.row];
    cell.imageView.image = [self.menuArrayImages objectAtIndex:indexPath.row];
    cell.textLabel.text = cellValue;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];

    if (indexPath.row == 5) {
        cell.detailTextLabel.text = self.sortString;
    }

    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //selectedCell is nill first
    NSString *selectedCell = nil;
    selectedCell = [_menuArray objectAtIndex:indexPath.row];
    self.menuOption = selectedCell;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"selectionAction" object:nil];

    //[self menuAnimation];
    [_menuViewTable deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)menuAnimation{
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
        self.frame = CGRectMake(self.frame.size.width, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint p = [gestureRecognizer locationInView:self];
    if (IS_IPAD) {
        if (!CGRectContainsPoint(CGRectMake(self.bounds.size.width-400, 0, 400, self.bounds.size.height), p)) {
            [self menuAnimation];
        }
    }
    else if (IS_IPHONE){
        if (CGRectContainsPoint(CGRectMake(0, 0, 51, 568), p)) {
            [self menuAnimation];
        }

    }
}



@end
