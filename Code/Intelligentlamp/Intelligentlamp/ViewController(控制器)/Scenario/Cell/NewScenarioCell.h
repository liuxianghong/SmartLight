//
//  NewScenarioCell.h
//  Intelligentlamp
//
//  Created by L on 16/9/26.
//  Copyright © 2016年 L. All rights reserved.
//

#import "SideCell.h"
@class AllScenarioModel;
typedef void(^GroupSetUpBlock)(NSIndexPath *index);
@interface NewScenarioCell : SideCell

@property (nonatomic ,strong) UIView *bgView;
@property (nonatomic ,strong) UIImageView *bgImgView;
@property (nonatomic ,strong) UILabel *titleLabel;
@property (nonatomic ,strong) UIButton *setUpBtn;
@property (nonatomic ,copy) NSIndexPath *indexPath;//哪一行

@property (nonatomic ,strong) AllScenarioModel *model;
@property (nonatomic ,copy) GroupSetUpBlock setUpBlock;

@end
