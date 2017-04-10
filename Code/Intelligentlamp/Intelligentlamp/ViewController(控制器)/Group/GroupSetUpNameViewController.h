//
//  GroupSetUpNameViewController.h
//  Intelligentlamp
//
//  Created by L on 16/8/20.
//  Copyright © 2016年 L. All rights reserved.
//设置分组名字和描述

#import "RootViewController.h"

typedef void(^ChangeContentBlock)(NSString *str);
@interface GroupSetUpNameViewController : RootViewController

@property (nonatomic ,copy) NSString *titleStr;//标题
@property (nonatomic ,copy) NSString *content;//修改的内容

@property (nonatomic ,copy) ChangeContentBlock changeContentBlock;
@end
