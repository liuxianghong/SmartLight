//
//  AllAddLampViewController.h
//  Intelligentlamp
//
//  Created by L on 16/9/21.
//  Copyright © 2016年 L. All rights reserved.
//

#import "RootViewController.h"

@interface AllAddLampViewController : RootViewController

@property (nonatomic ,strong) NSString *groupId;
@property (nonatomic ,strong) NSString *sceneId;
@property (nonatomic ,assign) BOOL isGroup;


@property (nonatomic ,copy) dispatch_block_t refreshBlock;
@end
