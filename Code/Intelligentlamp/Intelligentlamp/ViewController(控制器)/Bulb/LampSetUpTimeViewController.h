//
//  LampSetUpTimeViewController.h
//  Intelligentlamp
//
//  Created by L on 16/9/22.
//  Copyright © 2016年 L. All rights reserved.
//我的所有灯泡时间设置页面

#import "RootViewController.h"

@class AllBulbModel;
typedef void(^LampSetUpTimeBlock)(AllBulbModel *allModel);
@interface LampSetUpTimeViewController : RootViewController


@property (nonatomic ,copy) LampSetUpTimeBlock lampSetUpTimeBlock;
@property (nonatomic ,strong) AllBulbModel *model;//model

@property (nonatomic ,strong) NSMutableArray *selectDataArr;//选中的日期数组
@end
