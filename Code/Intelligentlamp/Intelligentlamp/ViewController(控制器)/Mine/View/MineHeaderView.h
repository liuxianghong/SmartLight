//
//  MineHeaderView.h
//  weixin
//
//  Created by L on 16/8/17.
//  Copyright © 2016年 L. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserModel;
@interface MineHeaderView : UIView

@property (nonatomic ,strong) UIView *bgView;//背景View
@property (nonatomic ,strong) UIImageView *iconImg;//头像
@property (nonatomic ,strong) UILabel *name;// 用户名

@property (nonatomic ,strong) UserModel *model;

@property (nonatomic ,copy) dispatch_block_t changeIconBlock;
@property (nonatomic ,copy) dispatch_block_t changeNameBlock;

- (void)layoutHeaderView;

@end
