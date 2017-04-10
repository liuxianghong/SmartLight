//
//  LampUpdateHubView.h
//  Intelligentlamp
//
//  Created by L on 16/8/23.
//  Copyright © 2016年 L. All rights reserved.
//检查更新页面的动画

#import <UIKit/UIKit.h>

@interface LampUpdateHubView : UIView

/** 球的颜色 */
@property (nonatomic,strong) UIColor *ballColor;

/** 展示加载动画*/
- (void)showHub;

/**
 *  关闭加载动画
 */
- (void)dismissHub;

@end
