//
//  GroupLampViewController.h
//  Intelligentlamp
//
//  Created by L on 16/8/20.
//  Copyright © 2016年 L. All rights reserved.
//某个分组所有灯的列表

#import "RootViewController.h"

@interface GroupLampViewController : RootViewController

@property (nonatomic ,copy) NSString *controllerTitle;//分组标题
@property (nonatomic ,copy) NSString *groupId;//分组ID
@end
