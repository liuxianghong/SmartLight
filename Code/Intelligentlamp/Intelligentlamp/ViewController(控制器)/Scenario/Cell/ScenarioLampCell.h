//
//  ScenarioLampCell.h
//  Intelligentlamp
//
//  Created by L on 16/8/21.
//  Copyright © 2016年 L. All rights reserved.
//场景列表里面所有的灯泡cell

#import <UIKit/UIKit.h>
typedef void(^DeleteBlock)(NSIndexPath *index);
typedef void(^SetUpBlock)(NSIndexPath *index);
@class ScenarioLampModel;
@interface ScenarioLampCell : UITableViewCell

@property (nonatomic ,strong) UIImageView *iconImg;//图片
@property (nonatomic ,strong) UILabel *titleLab;//描述文字
@property (nonatomic ,strong) UIButton *setUpBtn;//设置按钮
@property (nonatomic ,strong) UIButton *deleteBtn;//删除按钮
@property (nonatomic ,strong) ScenarioLampModel *model;//数据源
@property (nonatomic ,copy) NSIndexPath *indexPath;//哪一行

@property (nonatomic ,copy) SetUpBlock setUpBlock;
@property (nonatomic ,copy) DeleteBlock deleteBlock;
@end
