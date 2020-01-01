//
//  PostAnnouncement.m
//  Primo
//
//  Created by Jarrett Chen on 5/8/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import "PostAnnouncement.h"

@implementation PostAnnouncement

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        self.pickerToWhom = [[UIPickerView alloc]init];
        self.pickerType = [[UIPickerView alloc]init];
    }
    return self;
}

-(void)setUpView{
    
    UIImageView *toolbarBackground = [[UIImageView alloc]init];
    [toolbarBackground setImage:[UIImage imageNamed:@"blackboardBar"]];
    toolbarBackground.userInteractionEnabled=YES;
    [self addSubview:toolbarBackground];
    
    UITableView *infoTable = [[UITableView alloc]init];
    infoTable.cellLayoutMarginsFollowReadableWidth = NO;
    infoTable.delegate=self;
    infoTable.dataSource=self;
    infoTable.scrollEnabled=NO;
    [self addSubview:infoTable];
    
    self.tableArray = @[@"To:",@"Type:"];
    
    self.toWhomTextField = [[UITextField alloc]initWithFrame:CGRectMake(45,5, 320-50, 35)];
    
    self.whatTypeTextField = [[UITextField alloc]initWithFrame:CGRectMake(65,5, 320-70, 35)];
    
    self.textView = [[UITextView alloc]init];
    self.textView.delegate=self;
    self.textView.font = [UIFont systemFontOfSize:16];
    self.textView.text = @"What would you like to say to your students?";
    self.textView.textColor = [UIColor lightGrayColor];
    [self addSubview:self.textView];
    
    [self addPickerViews];
    
    if(IS_IPAD){
        toolbarBackground.translatesAutoresizingMaskIntoConstraints=NO;
        infoTable.translatesAutoresizingMaskIntoConstraints=NO;
        self.textView.translatesAutoresizingMaskIntoConstraints=NO;
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[toolbarBackground(64)]-0-[infoTable(88)]-0-[_textView(200)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(toolbarBackground,infoTable,_textView)]];
        
        //horizontal
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[toolbarBackground]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(toolbarBackground)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[infoTable]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(infoTable)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_textView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_textView)]];
        
    }
    else if (IS_IPHONE){
        [toolbarBackground setFrame:CGRectMake(0, 0, self.frame.size.width, 64)];
        [infoTable setFrame:CGRectMake(self.frame.origin.x, 64, self.frame.size.width,88)];
        [self.textView setFrame:CGRectMake(5,infoTable.frame.origin.y+infoTable.frame.size.height+10, self.frame.size.width-10, 185)];
    }
    
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"What would you like to say to your students?"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"What would you like to announce?";
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
}

//table view delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"studentCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    NSString *cellValue = [_tableArray objectAtIndex:indexPath.row];
    cell.textLabel.text = cellValue;
    cell.textLabel.textColor = [UIColor lightGrayColor];
    
    if (indexPath.row == 0) {
        [cell.contentView addSubview:self.toWhomTextField];
    }
    else if (indexPath.row ==1){
        [cell.contentView addSubview:self.whatTypeTextField];
    }
    return cell;
}

-(void)addPickerViews{
    
    self.toWhomPickerArray = [[NSArray alloc]initWithObjects:@"Pick One",@"Every Class",self.className, nil];
    [self.pickerToWhom setTag:100];
    self.pickerToWhom.dataSource =self;
    self.pickerToWhom.delegate = self;
    
    self.whatTypePickerArray = [[NSArray alloc]initWithObjects:@"Pick One",@"Announcement",@"Homework", nil];
    [self.pickerType setTag:200];
    self.pickerType.delegate=self;
    self.pickerType.dataSource=self;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
    NSArray *toolbarItems = [NSArray arrayWithObjects: doneButton, nil];
    
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, self.frame.size.height-_pickerToWhom.frame.size.height-44, 320, 44)];
    [toolBar setBarStyle:UIBarStyleDefault];
    [toolBar setItems:toolbarItems];
    self.toWhomTextField.inputView = _pickerToWhom;
    self.toWhomTextField.inputAccessoryView = toolBar;
    
    self.whatTypeTextField.inputView = _pickerType;
    self.whatTypeTextField.inputAccessoryView = toolBar;
    
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (row == 0) {
        [pickerView selectRow:1 inComponent:component animated:YES];
        
        if (pickerView.tag == 100) {
            [self.toWhomTextField setText:[self.toWhomPickerArray objectAtIndex:1]];
        }
        else if (pickerView.tag ==200){
            [self.whatTypeTextField setText:[self.whatTypePickerArray objectAtIndex:1]];
        }
    }
    else{
        if (pickerView.tag == 100) {
            [self.toWhomTextField setText:[self.toWhomPickerArray objectAtIndex:row]];
        }
        else if (pickerView.tag ==200){
            [self.whatTypeTextField setText:[self.whatTypePickerArray objectAtIndex:row]];
        }
    }
}



- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if (pickerView.tag == 100) {
        return [self.toWhomPickerArray objectAtIndex:row];
    }
    else if (pickerView.tag ==200){
        return [self.whatTypePickerArray objectAtIndex:row];
    }
    else{
        return 0;
    }
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (pickerView.tag == 100) {
        return [self.toWhomPickerArray count];
    }
    else if (pickerView.tag ==200){
        return [self.whatTypePickerArray count];
    }
    else{
        return 0;
    }
}

-(void)done{
    if ([self.toWhomTextField isFirstResponder]) {
        [self.pickerToWhom removeFromSuperview];
        [self.toWhomTextField resignFirstResponder];
        [self.whatTypeTextField becomeFirstResponder];
    }
    else if([self.whatTypeTextField isFirstResponder]){
        [self.pickerType removeFromSuperview];
        [self.whatTypeTextField resignFirstResponder];
        [self.textView becomeFirstResponder];
    }
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
