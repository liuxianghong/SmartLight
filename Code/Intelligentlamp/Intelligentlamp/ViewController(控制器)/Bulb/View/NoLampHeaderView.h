//
//  NoLampHeaderView.h
//  Intelligentlamp
//
//  Created by L on 16/8/25.
//  Copyright © 2016年 L. All rights reserved.
//没有灯泡的时候，显示的提示页面

#import <UIKit/UIKit.h>

@interface NoLampHeaderView : UIView

@property (nonatomic ,strong) UIButton *addLampBtn;//添加灯泡按钮
@property (nonatomic ,strong) UILabel *promptLab;//提示文字

@property (nonatomic ,copy) dispatch_block_t addLampBlock;

- (void)layoutNoLampHeaderView;
@end
