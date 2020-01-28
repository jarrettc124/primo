//
//  BouncingPencil.m
//  Primo
//
//  Created by Jarrett Chen on 9/3/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import "BouncingPencil.h"

@implementation BouncingPencil

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        self.pencilImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed: @"pencilImage"]];
        [self.pencilImage setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:self.pencilImage];
        
    }
    return self;
}

-(void)setUpPencilBounceFrame:(CGRect)frame targetX:(CGFloat)xC targetY:(CGFloat)yC rotation:(CGFloat)angle{

    CGPoint origin = self.pencilImage.center;
    CGPoint target = CGPointMake(self.pencilImage.center.x+xC, self.pencilImage.center.y+yC);
    CABasicAnimation *bounce = [CABasicAnimation animationWithKeyPath:@"position"];
    bounce.duration = 0.5;
    bounce.fromValue = [NSValue valueWithCGPoint:origin];
    bounce.toValue = [NSValue valueWithCGPoint:target];
    bounce.autoreverses = YES;
    bounce.repeatDuration= 100000;
    [bounce setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];

    
    self.pencilImage.transform = CGAffineTransformMakeRotation(angle);

    [self.pencilImage.layer addAnimation:bounce forKey:@"position"];
}

-(void)setUpPencilBounceForiPad:(CGSize)size targetX:(CGFloat)xC targetY:(CGFloat)yC rotation:(CGFloat)angle{
    
    self.pencilImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed: @"pencilImage"]];
    [self.pencilImage setFrame:CGRectMake(0, 0,size.width,size.height)];
    [self addSubview:self.pencilImage];
    
    CGPoint origin = self.pencilImage.center;
    CGPoint target = CGPointMake(self.pencilImage.center.x+xC, self.pencilImage.center.y+yC);
    CABasicAnimation *bounce = [CABasicAnimation animationWithKeyPath:@"position"];
    bounce.duration = 0.5;
    bounce.fromValue = [NSValue valueWithCGPoint:origin];
    bounce.toValue = [NSValue valueWithCGPoint:target];
    bounce.autoreverses = YES;
    bounce.repeatDuration= 100000;
    [bounce setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    
    self.pencilImage.transform = CGAffineTransformMakeRotation(angle);
    
    [self.pencilImage.layer addAnimation:bounce forKey:@"position"];

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
