//
//  AllLampSpeciesCell.h
//  Intelligentlamp
//
//  Created by L on 16/8/25.
//  Copyright © 2016年 L. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AllLampSpeciesModel;
@interface AllLampSpeciesCell : UITableViewCell

@property (nonatomic ,strong) UIImageView *iconImg;//图片
@property (nonatomic ,strong) UILabel *titleLab;//标题文字
@property (nonatomic ,strong) AllLampSpeciesModel *model;//数据源
@end
