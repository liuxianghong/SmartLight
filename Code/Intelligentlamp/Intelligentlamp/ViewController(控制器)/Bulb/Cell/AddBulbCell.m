//
//  AddBulbCell.m
//  Intelligentlamp
//
//  Created by L on 16/8/19.
//  Copyright © 2016年 L. All rights reserved.
//

#import "AddBulbCell.h"

@implementation AddBulbCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initWithCell];
        
    }
    return self;
}

- (void)initWithCell{
    self.addBulbBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addBulbBtn addTarget:self action:@selector(addBuleClick) forControlEvents:UIControlEventTouchUpInside];
//    self.addBulbBtn.titleEdgeInsets
    [self.contentView addSubview:self.addBulbBtn];
    [self.addBulbBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(35);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
}

- (void)addBuleClick{
    if (self.addBulbBlock) {
        self.addBulbBlock();
    }
}
@end
