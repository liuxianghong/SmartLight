//
//  UIImage+CircleCrop.h
//  weixin
//
//  Created by L on 16/8/17.
//  Copyright © 2016年 L. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CircleCrop)
//按形状切割图像
- (UIImage*)cutImageWithRadius:(int)radius;

@end
