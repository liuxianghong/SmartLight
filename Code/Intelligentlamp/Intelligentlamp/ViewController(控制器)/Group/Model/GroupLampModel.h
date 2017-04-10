//
//  GroupLampModel.h
//  Intelligentlamp
//
//  Created by L on 16/8/20.
//  Copyright © 2016年 L. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupLampModel : NSObject

@property (nonatomic ,copy) NSString *lampId;//灯泡id
@property (nonatomic ,copy) NSString *lampImg;//灯泡图片
@property (nonatomic ,copy) NSString *lampName;//灯泡名字

@property (nonatomic ,assign) BOOL isSelected;
@property (nonatomic ,assign) BOOL isNeedSetUp;

@end
