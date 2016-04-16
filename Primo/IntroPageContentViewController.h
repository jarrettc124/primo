//
//  IntroPageContentViewController.h
//  Primo
//
//  Created by Jarrett Chen on 5/13/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TutorialViewController.h"

#define IS_IPHONE  ( [[[UIDevice currentDevice] model] rangeOfString:@"iPhone"].location != NSNotFound )
#define IS_IPAD  ( [[[UIDevice currentDevice] model] rangeOfString:@"iPad"].location != NSNotFound )


@interface IntroPageContentViewController : UIViewController 

@property (nonatomic,strong) UIImageView *backgroundImage;

@property (nonatomic,strong) UILabel *tutorialLabel;

@property NSUInteger pageIndex;
@property NSString *tutorialText;
@property NSString *pictureText;

@end
