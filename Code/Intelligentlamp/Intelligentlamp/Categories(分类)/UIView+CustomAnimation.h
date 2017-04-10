//
//  UIView+CustomAnimation.h
//  weixin
//
//  Created by L on 16/8/17.
//  Copyright © 2016年 L. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CustomAnimation)
/**
 *  @author 
 *  @brief 提示框弹出效果动画
 */
-(void)showRemindViewAnimation:(CGFloat)duration withAnimationStopBlock:(dispatch_block_t)block;
/**
 *  @author
 *  @brief 隐藏框弹出效果动画
 */
-(void)hideRemindViewAnimation:(CGFloat)duration withAnimationStopBlock:(dispatch_block_t)block;

-(void)startPKAnimation;
-(void)showLargeAnimation:(CGFloat)duration;
-(void)showPrasiseAnimation:(CGFloat)duration;
-(void)showEyeSpriteAnimation:(CGFloat)duration;

@end
