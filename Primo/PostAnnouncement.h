//
//  PostAnnouncement.h
//  Primo
//
//  Created by Jarrett Chen on 5/8/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostAnnouncement : UIView <UITextViewDelegate,UITableViewDataSource,UITableViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

#define IS_IPHONE  ( [[[UIDevice currentDevice] model] rangeOfString:@"iPhone"].location != NSNotFound )
#define IS_IPAD  ( [[[UIDevice currentDevice] model] rangeOfString:@"iPad"].location != NSNotFound )

@property (nonatomic,strong) UITextField *toWhomTextField;
@property (nonatomic,strong) UITextField *whatTypeTextField;
@property (nonatomic,strong) UITextView *textView;
@property (nonatomic,strong) UIPickerView *pickerToWhom;
@property (nonatomic,strong) UIPickerView *pickerType;

-(void)setUpView;
@property (nonatomic,strong) NSArray *tableArray;

//pickerview arrays
@property (nonatomic,strong) NSArray *toWhomPickerArray;
@property (nonatomic,strong) NSArray *whatTypePickerArray;
@property (nonatomic,strong) NSString *className;
@end
