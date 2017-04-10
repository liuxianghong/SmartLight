//
//  AddBulbCell.h
//  Intelligentlamp
//
//  Created by L on 16/8/19.
//  Copyright © 2016年 L. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddBulbCell : UITableViewCell

@property (nonatomic ,strong) UIButton *addBulbBtn;//添加灯泡按钮

@property (nonatomic ,copy) dispatch_block_t addBulbBlock;
@end
