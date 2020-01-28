//
//  DemoRateAppView.m
//  Primo
//
//  Created by Jarrett Chen on 9/10/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import "DemoRateAppView.h"
#define IS_IPHONE  ( [[[UIDevice currentDevice] model] rangeOfString:@"iPhone"].location != NSNotFound )
#define IS_IPAD  ( [[[UIDevice currentDevice] model] rangeOfString:@"iPad"].location != NSNotFound )

@implementation DemoRateAppView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)showRatePopUp{
    
        self.tutorialBackground = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"blackboardBorder"]];
        [self.tutorialBackground setUserInteractionEnabled:YES];
        [self.tutorialBackground setAlpha:0];
        [self.tutorialBackground setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addSubview:self.tutorialBackground];

        UILabel *tutorialLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 15, self.tutorialBackground.frame.size.width-10, 140)];
        [tutorialLabel setFont:[UIFont fontWithName:@"Eraser" size:19]];
        [tutorialLabel setTextColor:[UIColor whiteColor]];
        [tutorialLabel setTextAlignment:NSTextAlignmentCenter];
        [tutorialLabel setNumberOfLines:0];
        [tutorialLabel setText:@"Congratulations!\nYou completed the demo! \n\n\n Would you like to \"Grade\" this app?"];
        [self.tutorialBackground addSubview:tutorialLabel];
        
        NSMutableAttributedString *attributeCongrats = [[NSMutableAttributedString alloc] initWithString:tutorialLabel.text];
        [attributeCongrats addAttribute:NSFontAttributeName
                                     value:[UIFont fontWithName:@"Eraser" size:23]
                                     range:NSMakeRange(0,[@"Congratulations!" length])];
        [tutorialLabel setAttributedText:attributeCongrats];
        
        UIImageView *startImage3 = [[UIImageView alloc]initWithFrame:CGRectMake(self.tutorialBackground.center.x-15, tutorialLabel.frame.size.height+15, 30, 30)];
        [startImage3 setImage:[UIImage imageNamed:@"starImg"]];
        [self.tutorialBackground addSubview:startImage3];
        
        UIImageView *startImage2 = [[UIImageView alloc]initWithFrame:CGRectMake(startImage3.frame.origin.x-30, tutorialLabel.frame.size.height+15, 30, 30)];
        [startImage2 setImage:[UIImage imageNamed:@"starImg"]];
        [self.tutorialBackground addSubview:startImage2];
        
        UIImageView *startImage4 = [[UIImageView alloc]initWithFrame:CGRectMake(startImage3.frame.origin.x+30, tutorialLabel.frame.size.height+15, 30, 30)];
        [startImage4 setImage:[UIImage imageNamed:@"starImg"]];
        [self.tutorialBackground addSubview:startImage4];
        
        UIImageView *startImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(startImage2.frame.origin.x-30, tutorialLabel.frame.size.height+15, 30, 30)];
        [startImage1 setImage:[UIImage imageNamed:@"starImg"]];
        [self.tutorialBackground addSubview:startImage1];

        
        UIImageView *startImage5 = [[UIImageView alloc]initWithFrame:CGRectMake(startImage4.frame.origin.x+30, tutorialLabel.frame.size.height+15, 30, 30)];
        [startImage5 setImage:[UIImage imageNamed:@"starImg"]];
        [self.tutorialBackground addSubview:startImage5];
        
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [cancelButton setTitle:@"Maybe later" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor colorWithRed:0.435294 green:0.90588 blue:0.8588 alpha:1] forState:UIControlStateNormal];
        [cancelButton setFrame:CGRectMake(5, self.tutorialBackground.frame.size.height - 60, (self.tutorialBackground.frame.size.width-25)/2, 40)];
        [cancelButton addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelButton];
        
        UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [doneButton setTitle:@"Rate app!" forState:UIControlStateNormal];
        [doneButton setTitleColor:[UIColor colorWithRed:0.435294 green:0.90588 blue:0.8588 alpha:1] forState:UIControlStateNormal];
        [doneButton setFrame:CGRectMake(20+(self.tutorialBackground.frame.size.width-25)/2, self.tutorialBackground.frame.size.height - 60, (self.tutorialBackground.frame.size.width-25)/2, 40)];
        [doneButton addTarget:self action:@selector(rateTheApp) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:doneButton];
        
        if (IS_IPAD) {
            [cancelButton.titleLabel setFont:[UIFont fontWithName:@"Eraser" size:22]];
            [doneButton.titleLabel setFont:[UIFont fontWithName:@"Eraser" size:22]];
        }
        else if (IS_IPHONE){
            [cancelButton.titleLabel setFont:[UIFont fontWithName:@"Eraser" size:17]];
            [doneButton.titleLabel setFont:[UIFont fontWithName:@"Eraser" size:17]];
        }
        
        
        BouncingPencil *pencilArrow = [[BouncingPencil alloc]initWithFrame:CGRectMake(doneButton.frame.origin.x-30, doneButton.frame.origin.y-50, 60, 60)];
        [pencilArrow setUpPencilBounceFrame:pencilArrow.frame targetX:15 targetY:9 rotation:-M_PI_4];
        [self.tutorialBackground addSubview:pencilArrow];
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            [self.tutorialBackground setAlpha:1];
            
        } completion:nil];
    
}

-(void)cancelButtonAction{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.tutorialBackground setTransform:CGAffineTransformMakeScale(0.5,0.5)];
        [self.tutorialBackground setAlpha:0];
        
        
    } completion:^(BOOL finished) {
        [self.tutorialBackground removeFromSuperview];
        self.tutorialBackground=nil;
        [self removeFromSuperview];
    }];
}

-(void)rateTheApp{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=892544489"]];
}

/*
 
 
 if (IS_IPHONE) {
 
 DemoRateAppView *rateApp = [[DemoRateAppView alloc]initWithFrame:CGRectMake(5,70, 310, 320)];
 [self.view addSubview:rateApp];
 [rateApp showRatePopUp];
 }
 else if (IS_IPAD){
 DemoRateAppView *rateApp = [[DemoRateAppView alloc]initWithFrame:CGRectMake(0, 0, 450, 320)];
 [self.view addSubview:rateApp];
 
 rateApp.translatesAutoresizingMaskIntoConstraints=NO;
 [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[rateApp(450)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(rateApp)]];
 
 [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[rateApp(320)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(rateApp)]];
 
 [self.view addConstraint:[NSLayoutConstraint constraintWithItem:rateApp attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
 
 [self.view addConstraint:[NSLayoutConstraint constraintWithItem:rateApp attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:-50]];
 [rateApp showRatePopUp];
 }
 
 */







/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
