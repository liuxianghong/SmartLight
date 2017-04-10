//
//  AllLightSetUpViewController.h
//  Intelligentlamp
//
//  Created by L on 16/8/28.
//  Copyright © 2016年 L. All rights reserved.
//所有的灯光高级设置页面

#import "RootViewController.h"
@class AllBulbModel;
@interface AllLightSetUpViewController : RootViewController

@property (nonatomic ,strong) AllBulbModel *bulbModel;
@property (nonatomic ,strong) UIColor *lampColor;
@end
