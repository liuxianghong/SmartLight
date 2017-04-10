//
//  AllScenarioCell.h
//  Intelligentlamp
//
//  Created by L on 16/8/21.
//  Copyright © 2016年 L. All rights reserved.
//所有的场景cell

#import <UIKit/UIKit.h>

@class AllScenarioModel;
typedef void(^GroupSetUpBlock)(NSIndexPath *index);
@interface AllScenarioCell : UITableViewCell

@property (nonatomic ,strong) UIImageView *iconImg;//图片
@property (nonatomic ,strong) UILabel *titleLab;//描述文字
@property (nonatomic ,strong) UILabel *describeLab;//描述文字
@property (nonatomic ,strong) UIButton *setUpBtn;//设置按钮
@property (nonatomic ,strong) AllScenarioModel *model;//数据源
@property (nonatomic ,copy) NSIndexPath *indexPath;//哪一行

@property (nonatomic ,copy) GroupSetUpBlock setUpBlock;

@end
