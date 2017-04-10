//
//  GroupSetUpTimeViewController.h
//  Intelligentlamp
//
//  Created by L on 16/8/23.
//  Copyright © 2016年 L. All rights reserved.
//设置时间

#import "RootViewController.h"

@class AllScenarioModel;
typedef void(^ScenarioSetUpBlock)(AllScenarioModel *allModel);
@interface GroupSetUpTimeViewController : RootViewController

@property (nonatomic ,copy) ScenarioSetUpBlock scenarioSetUpBlock;
@property (nonatomic ,strong) AllScenarioModel *model;//场景model
@property (nonatomic ,strong) NSMutableArray *selectDataArr;//选中的日期数组
@property (nonatomic ,strong) NSString *opneTime;//开始时间
@property (nonatomic ,strong) NSString *closeTime;//结束时间

@property (nonatomic ,assign) BOOL isOpen;//是否打开定时
@property (nonatomic ,assign) int timingOn;//是否打开定时开关
@property (nonatomic ,assign) int randomOn;//是否打开随机开关
@end
