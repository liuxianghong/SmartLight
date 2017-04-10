//
//  WXBarButtonItem.m
//  weixin
//
//  Created by L on 16/8/17.
//  Copyright © 2016年 L. All rights reserved.
//

#import "WXBarButtonItem.h"

@implementation WXBarButtonItem

- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image withTitle:(NSString *)title withBtnType:(NavigationButtonType)type withClickBtnActionBlock:(ClickBtnAction)block{
    
    self = [super init];
    if (self) {
        _buttonType = type;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:image forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        if (title != nil && image == nil)
            btn.frame = CGRectMake(0, 0, 30, 40);
        else
            btn.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        [btn setTitleColor:AllLampTitleColor forState:UIControlStateNormal];
        [btn setTitleColor:AllLampTitleColor forState:UIControlStateHighlighted];
        [btn setTitle:title forState:UIControlStateNormal];
        [self setCustomView:btn];
        self.block = block;
    }
    return self;

}

-(void)clickBtnAction:(UIButton *)btn
{
    if (self.block) {
        self.block();
    }
}
@end
