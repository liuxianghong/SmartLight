//
//  WXReminderView.h
//  weixin
//
//  Created by L on 16/8/17.
//  Copyright © 2016年 L. All rights reserved.
//错误信息提示页面

#import <UIKit/UIKit.h>

@interface WXReminderView : UIView

@property (nonatomic ,copy) dispatch_block_t remindBlock;

/**
 *  提示页面单例
 *
 *  @return
 */
+ (WXReminderView *)shareInstance;

/**
 *  错误提示页面加载方法
 *
 *  @param addController 加载在某个控制器
 *  @param str           错误内容
 *  @param block         回调block
 */
- (void)addWarnmingRemind:(UIViewController *)addController warningString:(NSString *)str remindBlock:(dispatch_block_t)block;

/**
 *  成功提示页面加载方法
 *
 *  @param addController 加载在某个控制器
 *  @param str           成功提示内容
 *  @param block         回调block
 */

- (void)addSucessRemind:(UIViewController *)addController sucessString:(NSString *)str remindBlock:(dispatch_block_t)block;

/**
 *  移除提示页面
 */
- (void)hideReminderView;

- (void)addWarningRemindWithView:(UIView *)addView warningString:(NSString *)str remindBlock:(dispatch_block_t)block;
- (void)addSuccessRemindWithView:(UIView *)addView remindString:(NSString *)str remindBlock:(dispatch_block_t)block;
@end
