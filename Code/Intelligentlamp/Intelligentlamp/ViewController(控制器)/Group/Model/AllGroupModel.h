//
//  AllGroupModel.h
//  Intelligentlamp
//
//  Created by L on 16/8/20.
//  Copyright © 2016年 L. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AllGroupModel : NSObject

@property (nonatomic ,copy) NSString *groupId;//分组Id
@property (nonatomic ,copy) NSString *groupImg;//分组图片
@property (nonatomic ,copy) NSString *groupTitle;//分组标题
@property (nonatomic ,copy) NSString *groupDescribe;//分组描述
@property (nonatomic ,copy) NSString *createTime;//分组创建时间

@property (nonatomic ,copy) NSString *groupOpenTime;//定时开灯时间
@property (nonatomic ,copy) NSString *groupCloseTime;//定时关灯时间
@property (nonatomic ,copy) NSMutableArray *listArr;//灯泡列表

@property (nonatomic ,assign) int  groupTimingOn;//是否开启定时开关
@property (nonatomic ,assign) int  groupRandomOn;//是否开启随机定时开关
@end
