//
//  SearchLampFooter.h
//  Intelligentlamp
//
//  Created by L on 16/9/9.
//  Copyright © 2016年 L. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchLampFooter : UIView

@property (nonatomic ,strong) UIButton *addLampBtn;//添加灯泡按钮

@property (nonatomic ,copy) dispatch_block_t addLampBlock;

- (void)layoutFooterView;
@end
