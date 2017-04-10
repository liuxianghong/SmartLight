//
//  AllChooseGroupCell.h
//  Intelligentlamp
//
//  Created by L on 16/9/18.
//  Copyright © 2016年 L. All rights reserved.
//添加到分组cell
#import "AllScenarioModel.h"
#import "AllGroupModel.h"

#import <UIKit/UIKit.h>

@interface AllChooseGroupCell : UICollectionViewCell

@property (nonatomic ,strong) UIView *bgView;//头像背景图
@property (nonatomic ,strong) UIImageView *iconImg;//图片
@property (nonatomic ,strong) UILabel *titleLab;//标题文字

@property (nonatomic ,strong) UIButton *selectBtn;//选择按钮


@property (nonatomic ,strong)AllGroupModel *model;
@property (nonatomic ,strong)AllScenarioModel *scenario;
@end
