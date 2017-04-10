//
//  ScenarioFooterView.h
//  Intelligentlamp
//
//  Created by L on 16/8/21.
//  Copyright © 2016年 L. All rights reserved.
//添加按钮

#import <UIKit/UIKit.h>

@interface ScenarioFooterView : UIView

@property (nonatomic ,strong) UIButton *addGroupBtn;//添加分组按钮

@property (nonatomic ,copy) dispatch_block_t addGroupBlock;

- (void)layoutFooterView;
@end
