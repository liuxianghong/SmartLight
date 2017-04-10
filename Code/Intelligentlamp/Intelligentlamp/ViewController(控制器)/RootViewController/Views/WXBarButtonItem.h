//
//  WXBarButtonItem.h
//  weixin
//
//  Created by L on 16/8/17.
//  Copyright © 2016年 L. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 按钮类型枚举
 */
typedef enum {
    ButtonLeft =0,
    ButtonRight,
    
} NavigationButtonType;

/**
 *  按钮点击回调block
 */
typedef void(^ClickBtnAction)(void);

@interface WXBarButtonItem : UIBarButtonItem

@property (nonatomic ,assign) NavigationButtonType buttonType;//按钮类型
@property (nonatomic ,copy) ClickBtnAction block;//回调block

/**
 *  创建一个指定类型的，点击有回调的ButtonItem
 *
 *  @param image 按钮图片
 *  @param title 按钮文字
 *  @param type  按钮类型
 *  @param block 按钮回调的block
 *
 *  @return
 */
- (instancetype)initWithImage:(UIImage *)image withTitle:(NSString *)title withBtnType:(NavigationButtonType)type withClickBtnActionBlock:(ClickBtnAction)block;

@end
