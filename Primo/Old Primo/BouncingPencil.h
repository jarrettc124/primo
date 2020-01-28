//
//  BouncingPencil.h
//  Primo
//
//  Created by Jarrett Chen on 9/3/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BouncingPencil : UIView

@property (nonatomic,strong) UIImageView *pencilImage;

-(void)setUpPencilBounceFrame:(CGRect)frame targetX:(CGFloat)xC targetY:(CGFloat)yC rotation:(CGFloat)angle;

-(void)setUpPencilBounceForiPad:(CGSize)size targetX:(CGFloat)xC targetY:(CGFloat)yC rotation:(CGFloat)angle;
@end
