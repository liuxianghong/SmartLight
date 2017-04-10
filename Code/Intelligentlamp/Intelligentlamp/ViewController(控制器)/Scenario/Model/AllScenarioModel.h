//
//  AllScenarioModel.h
//  Intelligentlamp
//
//  Created by L on 16/8/21.
//  Copyright © 2016年 L. All rights reserved.
//场景列表


#import <Foundation/Foundation.h>

@interface AllScenarioModel : NSObject

@property (nonatomic ,copy) NSString *ScenarioId;//场景Id
@property (nonatomic ,copy) NSString *ScenarioCreateTime;//场景创建时间
@property (nonatomic ,copy) NSString *ScenarioImg;//场景图片
@property (nonatomic ,copy) NSString *ScenarioTitle;//场景标题
@property (nonatomic ,copy) NSString *ScenarioDescribe;//场景描述

@property (nonatomic ,copy) NSString *ScenarioOpenTime;//定时开灯时间
@property (nonatomic ,copy) NSString *ScenarioCloseTime;//定时关灯时间
@property (nonatomic ,copy) NSMutableArray *ScenariolistArr;//灯泡列表

@property (nonatomic ,assign) int  ScenarioTimingOn;//是否开启定时开关
@property (nonatomic ,assign) int  ScenarioRandomOn;//是否开启随机定时开关


@end
