//
//  GroupSetUpViewController.h
//  Intelligentlamp
//
//  Created by L on 16/8/20.
//  Copyright © 2016年 L. All rights reserved.
//设置分组

#import "RootViewController.h"

@class AllGroupModel;
@interface GroupSetUpViewController : RootViewController

@property (nonatomic ,strong) AllGroupModel *model;
@property (nonatomic ,copy) dispatch_block_t deleteBlock;
@end
