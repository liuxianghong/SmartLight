//
//  MineFootView.h
//  weixin
//
//  Created by L on 16/8/17.
//  Copyright © 2016年 L. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineFootView : UIView

@property (nonatomic ,strong) UIButton *exitBtn;//退出按钮
@property (nonatomic ,copy) dispatch_block_t exitClickBlock;

- (void)layoutMineFootView;

@end
