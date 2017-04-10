//
//  ChooseLampSpeciesVC.h
//  Intelligentlamp
//
//  Created by L on 16/8/25.
//  Copyright © 2016年 L. All rights reserved.
//选择灯泡种类页面

#import "RootViewController.h"
@class ZLSwipeableView;
@interface ChooseLampSpeciesVC : RootViewController


@property (nonatomic, strong) ZLSwipeableView *swipeableView;

- (UIView *)nextViewForSwipeableView:(ZLSwipeableView *)swipeableView;
@end
