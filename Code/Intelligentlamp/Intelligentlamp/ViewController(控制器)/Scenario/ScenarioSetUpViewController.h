//
//  ScenarioSetUpViewController.h
//  Intelligentlamp
//
//  Created by L on 16/8/25.
//  Copyright © 2016年 L. All rights reserved.
//设置场景

#import "RootViewController.h"
@class AllScenarioModel;

@interface ScenarioSetUpViewController : RootViewController

@property (nonatomic ,strong) AllScenarioModel *model;

@property (nonatomic ,copy) dispatch_block_t deleteBlock;

@end
