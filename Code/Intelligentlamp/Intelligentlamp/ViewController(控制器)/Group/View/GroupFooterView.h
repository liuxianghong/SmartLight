//
//  GroupFooterView.h
//  Intelligentlamp
//
//  Created by L on 16/8/20.
//  Copyright © 2016年 L. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupFooterView : UIView

@property (nonatomic ,strong) UIButton *addGroupBtn;//添加分组按钮

@property (nonatomic ,copy) dispatch_block_t addGroupBlock;

- (void)layoutFooterView;
@end
