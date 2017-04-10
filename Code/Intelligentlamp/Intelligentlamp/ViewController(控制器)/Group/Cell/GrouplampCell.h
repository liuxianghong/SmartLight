//
//  GrouplampCell.h
//  Intelligentlamp
//
//  Created by L on 16/8/20.
//  Copyright © 2016年 L. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GroupLampModel;
typedef void(^SetUpBlock)(NSIndexPath *index);
typedef void(^DeleteBlock)(NSIndexPath *index);
@interface GrouplampCell : UITableViewCell

@property (nonatomic ,strong) UIImageView *iconImg;//图片
@property (nonatomic ,strong) UILabel *titleLab;//描述文字
@property (nonatomic ,strong) UIButton *setUpBtn;//设置按钮
@property (nonatomic ,strong) UIButton *deleteBtn;//删除按钮
@property (nonatomic ,strong) GroupLampModel *model;//数据源
@property (nonatomic ,copy) NSIndexPath *indexPath;//哪一行

@property (nonatomic ,copy) SetUpBlock setUpBlock;
@property (nonatomic ,copy) DeleteBlock deleteBlock;
@end
