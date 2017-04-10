//
//  UIView+Progress.m
//  weixin
//
//  Created by L on 16/8/17.
//  Copyright © 2016年 L. All rights reserved.
//

#import "UIView+Progress.h"
#import <objc/runtime.h>
static const void *ProgressShape = &ProgressShape;
static const void *ProgressPath = &ProgressPath;

@implementation UIView (Progress)

- (CAShapeLayer *)progressShape {
    return objc_getAssociatedObject(self, ProgressShape);
}

- (void)setProgressShape:(CAShapeLayer *)progressShape{
    objc_setAssociatedObject(self, ProgressShape, progressShape, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CAShapeLayer *)progressPath {
    return objc_getAssociatedObject(self, ProgressPath);
}

- (void)setProgressPath:(CAShapeLayer *)progressPath{
    objc_setAssociatedObject(self, ProgressPath, progressPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//初始化进度UI
-(void)initProgressUI
{
    if (!self.progressShape ) {
        self.progressShape = [[CAShapeLayer alloc] init];
        self.progressShape.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.6].CGColor;
        CGRect rect = self.bounds;
        self.progressShape.frame = rect;
        self.progressShape.fillColor = nil;
        self.progressShape.strokeColor = RGB(138, 138, 138).CGColor;
        self.progressShape.lineWidth = 6;
    }
    [self.layer addSublayer:self.progressShape];
}

//清除进度的UI
-(void)removeProgressUI
{
    [self.progressShape removeFromSuperlayer];
}

//设置进度大小
- (void)setProgress:(CGFloat)progress
{
    self.progressPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2) radius:(self.frame.size.width - 2)/ 2 startAngle:- M_PI_2 endAngle:(M_PI * 2) * progress - M_PI_2 clockwise:YES];
    self.progressShape.path = self.progressPath.CGPath;
}

@end
