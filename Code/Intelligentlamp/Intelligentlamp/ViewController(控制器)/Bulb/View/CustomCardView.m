//
//  CustomCardView.m
//  CCDraggableCard-Master
//
//  Created by jzzx on 16/7/9.
//  Copyright © 2016年 Zechen Liu. All rights reserved.
//

#import "CustomCardView.h"

@interface CustomCardView ()

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel     *titleLabel;

@end

@implementation CustomCardView

- (instancetype)init {
    if (self = [super init]) {
        [self loadComponent];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self loadComponent];
    }
    return self;
}

- (void)loadComponent {
    self.imageView = [[UIImageView alloc] init];
    self.titleLabel = [[UILabel alloc] init];
    
//    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.imageView.layer setMasksToBounds:YES];
    self.imageView.layer.cornerRadius = 50;
    self.layer.masksToBounds = YES;
    self.imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.imageView.layer.borderWidth = 2;
    self.titleLabel.textColor = AllLampTitleColor;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.imageView];
    [self addSubview:self.titleLabel];
    
//    self.backgroundColor = [UIColor colorWithRed:0.951 green:0.951 blue:0.951 alpha:1.00];
    self.backgroundColor = AllBgColor;
}

- (void)cc_layoutSubviews {
    
    self.imageView.frame   = CGRectMake((self.frame.size.width - 100)/2, (self.frame.size.height - 100)/2, 100, 100);
    self.titleLabel.frame = CGRectMake(0, (CGRectGetMaxY(self.imageView.frame)), self.frame.size.width, 64);
}

- (void)installData:(NSDictionary *)element {
    [self.imageView sd_setImageWithURL:element[@"image"]];
    self.titleLabel.text = element[@"title"];
}

@end
