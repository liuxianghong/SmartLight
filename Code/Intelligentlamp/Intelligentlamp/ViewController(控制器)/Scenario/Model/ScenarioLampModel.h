//
//  ScenarioLampModel.h
//  Intelligentlamp
//
//  Created by L on 16/8/21.
//  Copyright © 2016年 L. All rights reserved.
//场景列表对应的灯泡

#import <Foundation/Foundation.h>

@interface ScenarioLampModel : NSObject

@property (nonatomic ,copy) NSString *lampId;//灯泡图id
@property (nonatomic ,copy) NSString *lampImg;//灯泡图片
@property (nonatomic ,copy) NSString *lampName;//灯泡名字
@property (nonatomic ,copy) NSString *lampMacAddress;//灯泡地址
@property (nonatomic ,copy) NSString *lampBrandId;//灯泡品牌id
@property (nonatomic ,copy) NSString *lampDescription;//灯泡描述

@property (nonatomic ,copy) NSString *lampUserId;//灯泡用户id
@property (nonatomic ,assign) int lampTimingOn;//灯泡定时开关状态
@property (nonatomic ,copy) NSString *lampTimingOpenTime;//灯泡开灯时间
@property (nonatomic ,copy) NSString *lampTimingCloseTime;//灯泡关灯时间
@property (nonatomic ,assign)int lamPrandomOn;//灯泡随机开关状态
@property (nonatomic ,assign)int lamDelayOn;//灯泡延时开关
@property (nonatomic ,assign)int lamDelayTime;//灯泡延时时间

@property (nonatomic ,assign) int lampPower;//灯泡功率
@property (nonatomic ,assign) int lampBrightness;//灯泡亮度
@property (nonatomic ,assign) int lampTonal;//灯泡色调
@property (nonatomic ,assign) int lampShow;//灯泡显指
@property (nonatomic ,assign) int lampColorTemperature;//灯泡色温
@property (nonatomic ,assign) int lampSaturation;//灯泡饱和度
@property (nonatomic ,assign) int lampPoweron;//灯泡开关按钮


@property (nonatomic ,assign) BOOL isSelected;//是否是选中状态
@property (nonatomic ,assign) BOOL isNeedSetUp;//是否要显示设置按钮
@end
