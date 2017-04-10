//
//  AllSimpleLightSetUpViewController.h
//  Intelligentlamp
//
//  Created by L on 16/8/29.
//  Copyright © 2016年 L. All rights reserved.
//所有的灯光控制页面

#import "RootViewController.h"

@interface AllSimpleLightSetUpViewController : RootViewController

@property (nonatomic ,assign) BOOL isSceneId;
@property (nonatomic ,copy)NSString *lampId;
@property (nonatomic ,copy)NSString *sceneId;
@end
