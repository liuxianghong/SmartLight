//
//  GroupSetUpVCHeaderView.h
//  Intelligentlamp
//
//  Created by L on 16/8/20.
//  Copyright © 2016年 L. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupSetUpVCHeaderView : UIView

@property (nonatomic ,strong) UIImageView *iconImg;//头像
@property (nonatomic ,copy) NSString *icon;

@property (nonatomic ,copy) dispatch_block_t changeIconBlock;

- (void)layoutHeaderView;
@end
