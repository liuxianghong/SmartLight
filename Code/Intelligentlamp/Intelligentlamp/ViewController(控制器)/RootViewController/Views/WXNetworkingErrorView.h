//
//  WXNetworkingErrorView.h
//  weixin
//
//  Created by L on 16/8/17.
//  Copyright © 2016年 L. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXNetworkingErrorView : UIView

@property (nonatomic ,strong) UIImageView *reminderImg;//网络错误提示图片
@property (nonatomic ,strong) UILabel *reminderLab;//网络错误提示文字

/**
 *  网络错误提示单利
 *
 *  @return
 */
+ (WXNetworkingErrorView *)shareInstance;
/**
 *  添加网络错误提示的方法
 *
 *  @param viewController 添加到某个控制器
 *  @param str            提示文字
 */
- (void)showNetErrorView:(UIViewController *)viewController withRemind:(NSString *)str;
/**
 *  隐藏网络错误提示
 */
- (void)hideNetErrorView;

@end
