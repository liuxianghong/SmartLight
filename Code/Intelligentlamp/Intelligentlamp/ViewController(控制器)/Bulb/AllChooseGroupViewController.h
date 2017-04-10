//
//  AllChooseGroupViewController.h
//  Intelligentlamp
//
//  Created by L on 16/9/18.
//  Copyright © 2016年 L. All rights reserved.
//所有的选择分组的页面

#import "RootViewController.h"

@interface AllChooseGroupViewController : RootViewController


@property (nonatomic ,strong) NSArray *dataArr;
@property (nonatomic ,copy) dispatch_block_t refreshBlock;
@end
