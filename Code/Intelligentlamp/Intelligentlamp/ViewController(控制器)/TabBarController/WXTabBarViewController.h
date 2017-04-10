//
//  WXTabBarViewController.h
//  weixin
//
//  Created by L on 16/8/17.
//  Copyright © 2016年 L. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXTabBarViewController : UITabBarController


@property (nonatomic ,assign) int  currentSelectedIndex;  //当前选中哪个控制器
@property (nonatomic ,retain) NSMutableArray *buttons;      //选项按钮数值
@property (nonatomic ,strong) NSArray *titleArr;        //标题数值
@property (nonatomic ,strong) NSArray *iconsArr;        //图标数值
@property (nonatomic ,strong) NSArray *iconsSelectArr;  //图标选中状态数值
@property (nonatomic ,strong) UIImage *tabbarBg;        //tabbar背景图片


/**
 *
 *  自定义Tabbar的初始化
 *  @param titleLabelArr 传入标题数值
 *  @param iconArr       传入图标数组
 *  @param selArr        传入选中图标数组
 *  @param img           传入背景图片
 *
 *  @return
 */
- (id)initWithTitle:(NSArray *)titleLabelArr imgArr:(NSArray *)iconArr selectArr:(NSArray *)selArr bgImage:(UIImage *)img;

/**
 *  隐藏真实的Tabbar
 */
- (void)hideRealTabBar;

/**
 *  自定义TabBar
 */
- (void)customTabBar;

/**
 *  默认选中那个TabBar
 *
 *  @param button 传入对应的按钮
 */
- (void)selectTab:(UIButton *)button;

@end
