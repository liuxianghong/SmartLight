//
//  UIView+CustomAnimation.m
//  weixin
//
//  Created by L on 16/8/17.
//  Copyright © 2016年 L. All rights reserved.
//

#import "UIView+CustomAnimation.h"
#import <objc/runtime.h>

static NSString *animationStopKey        = @"animationStopKey";

@implementation UIView (CustomAnimation)


-(void)showRemindViewAnimation:(CGFloat)duration withAnimationStopBlock:(dispatch_block_t)block
{
    CAKeyframeAnimation *remindViewAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    remindViewAnimation.delegate             = self;
    remindViewAnimation.duration             = duration;
    remindViewAnimation.removedOnCompletion  = NO;
    remindViewAnimation.fillMode             = kCAFillModeForwards;
    NSMutableArray *values                   = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    remindViewAnimation.values               = values;
    remindViewAnimation.timingFunction       = [CAMediaTimingFunction functionWithName: @"easeInEaseOut"];
    [self.layer addAnimation:remindViewAnimation forKey:nil];
    
    //动态增加属性
    objc_setAssociatedObject(self, &animationStopKey, block, OBJC_ASSOCIATION_COPY);
}


-(void)hideRemindViewAnimation:(CGFloat)duration withAnimationStopBlock:(dispatch_block_t)block{
    CAKeyframeAnimation *remindViewAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    remindViewAnimation.duration             = duration;
    remindViewAnimation.delegate             = self;
    remindViewAnimation.removedOnCompletion  = NO;
    remindViewAnimation.fillMode             = kCAFillModeForwards;
    NSMutableArray *values                   = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0, 0.0, 0.0)]];
    remindViewAnimation.values               = values;
    remindViewAnimation.timingFunction       = [CAMediaTimingFunction functionWithName: @"easeInEaseOut"];
    [self.layer addAnimation:remindViewAnimation forKey:nil];
    
    //动态增加属性
    objc_setAssociatedObject(self, &animationStopKey, block, OBJC_ASSOCIATION_COPY);
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    dispatch_block_t block                   = objc_getAssociatedObject(self, &animationStopKey);
    if (block) {
        block();
    }
}

-(void)startPKAnimation
{
    CAKeyframeAnimation *pkAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    pkAnimation.duration             = 0.1;
    NSMutableArray *values                   = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.2)]];
    pkAnimation.values               = values;
    pkAnimation.timingFunction       = [CAMediaTimingFunction functionWithName: @"easeInEaseOut"];
    pkAnimation.autoreverses = YES;
    pkAnimation.repeatCount = 5;
    [self.layer addAnimation:pkAnimation forKey:nil];
}


-(void)showLargeAnimation:(CGFloat)duration
{
    CAKeyframeAnimation *remindViewAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    remindViewAnimation.delegate             = self;
    remindViewAnimation.duration             = duration;
    NSMutableArray *values                   = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 0.1)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    remindViewAnimation.values               = values;
    remindViewAnimation.timingFunction       = [CAMediaTimingFunction functionWithName: @"easeInEaseOut"];
    [self.layer addAnimation:remindViewAnimation forKey:nil];
}

-(void)showPrasiseAnimation:(CGFloat)duration
{
    CAKeyframeAnimation *remindViewAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    remindViewAnimation.delegate             = self;
    remindViewAnimation.duration             = duration;
    NSMutableArray *values                   = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.2)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    remindViewAnimation.values               = values;
    remindViewAnimation.timingFunction       = [CAMediaTimingFunction functionWithName: @"easeInEaseOut"];
    [self.layer addAnimation:remindViewAnimation forKey:nil];
}

-(void)showEyeSpriteAnimation:(CGFloat)duration
{
    CAKeyframeAnimation *remindViewAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    remindViewAnimation.delegate             = self;
    remindViewAnimation.duration             = duration;
    remindViewAnimation.repeatCount          = 10000;
    NSMutableArray *values                   = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.1)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    remindViewAnimation.values               = values;
    remindViewAnimation.timingFunction       = [CAMediaTimingFunction functionWithName: @"easeInEaseOut"];
    [self.layer addAnimation:remindViewAnimation forKey:nil];
}
@end
