//
//  UIView+Progress.h
//  weixin
//
//  Created by L on 16/8/17.
//  Copyright © 2016年 L. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Progress)

@property (nonatomic , strong) CAShapeLayer     *progressShape;
@property (nonatomic , strong) UIBezierPath     *progressPath;
//初始化进度UI
-(void)initProgressUI;
//清除进度的UI
-(void)removeProgressUI;
//设置进度大小
- (void)setProgress:(CGFloat)progress;
@end
