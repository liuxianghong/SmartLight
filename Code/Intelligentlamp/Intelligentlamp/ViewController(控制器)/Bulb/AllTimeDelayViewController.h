//
//  AllTimeDelayViewController.h
//  Intelligentlamp
//
//  Created by L on 16/9/19.
//  Copyright © 2016年 L. All rights reserved.
//延时开关页面

#import "RootViewController.h"

@class AllBulbModel;
typedef void(^LampSetUpDelyBlock)(AllBulbModel *allModel);
@interface AllTimeDelayViewController : RootViewController

@property (nonatomic,assign)NSInteger discount;

@property (nonatomic ,strong) AllBulbModel *model;//model
@property (nonatomic ,copy) LampSetUpDelyBlock lampSetUpDelyBlock;
@end
