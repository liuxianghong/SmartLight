//
//  WXLoadingView.h
//  weixin
//
//  Created by L on 16/8/17.
//  Copyright © 2016年 L. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXLoadingView : UIView
/**
 *  加载loading的单例
 *
 *  @return
 */
+ (WXLoadingView *)shareInstance;

/**
 *  加载lonading添加到某个控制器
 *
 *  @param addViewController 传一个控制器
 */
- (void)showLoadingViewWithViewController:(UIViewController *)addViewController;
/**
 *  隐藏加载loading
 */
- (void)hideLoadingView;
/**
 *  开启加载loading动画
 */
- (void)startLoadingAnimation;
/**
 *  中止加载loading并隐藏
 */
- (void)stopLoadingAnimationAndHide;

@end
