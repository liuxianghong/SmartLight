//
//  MineListTableviewCell.h
//  weixin
//
//  Created by L on 16/8/17.
//  Copyright © 2016年 L. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineListTableviewCell : UITableViewCell

@property (nonatomic ,strong) UIImageView *iconImg;//图片
@property (nonatomic ,strong) UILabel *titleLab;//描述文字
@property (nonatomic ,strong) UIImageView *arrowImg;//箭头→

@property (nonatomic ,copy) NSDictionary *dataDic;//数据
@property (nonatomic ,copy) NSIndexPath *indexPath;//哪一行


@end
