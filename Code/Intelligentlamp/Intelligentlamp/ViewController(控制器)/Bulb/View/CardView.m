//
//  CardView.m
//  ZLSwipeableViewDemo
//
//  Created by Zhixuan Lai on 11/1/14.
//  Copyright (c) 2014 Zhixuan Lai. All rights reserved.
//

#define LampTitleColor HEXCOLOR(0x90c154)
#import "CardView.h"
#import "AllLampSpeciesModel.h"

@interface CardView()

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel     *titleLabel;

@property (strong, nonatomic) UIImageView *leftImageView;
@property (strong, nonatomic) UILabel     *leftTitleLabel;

@property (strong, nonatomic) UIImageView *rightImageView;
@property (strong, nonatomic) UILabel     *rightTitleLabel;
@end
@implementation CardView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
        [self loadComponent];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
        [self loadComponent];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
        [self loadComponent];
    }
    return self;
}

- (void)setup {
    // Shadow
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.33;
    self.layer.shadowOffset = CGSizeMake(0, 1.5);
    self.layer.shadowRadius = 4.0;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;

    // Corner Radius
    self.layer.cornerRadius = 10.0;
    self.userInteractionEnabled = YES;
     UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(event)];
    [self addGestureRecognizer:tapGesture];
}

- (void)event{
    WEAKSELF
    if (self.eventBlock) {
        self.eventBlock(weakSelf.model);
    }
}
- (void)loadComponent {
    self.imageView = [[UIImageView alloc] init];
    self.titleLabel = [[UILabel alloc] init];

    [self.imageView.layer setMasksToBounds:YES];
    self.imageView.layer.cornerRadius = 50;
    self.layer.masksToBounds = YES;
    self.imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.imageView.layer.borderWidth = 2;
    self.titleLabel.textColor = AllLampTitleColor;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.imageView];
    [self addSubview:self.titleLabel];

    
    self.leftImageView = [[UIImageView alloc] init];
    self.leftTitleLabel = [[UILabel alloc] init];
    
    [self.leftImageView.layer setMasksToBounds:YES];
    self.leftImageView.layer.cornerRadius = 11;
    self.layer.masksToBounds = YES;
    self.leftImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.leftImageView.layer.borderWidth = 1;
    self.leftTitleLabel.textColor = LampTitleColor;
    self.leftTitleLabel.font = [UIFont systemFontOfSize:18];
    self.leftTitleLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.leftImageView];
    [self addSubview:self.leftTitleLabel];
    
    
    
    self.rightImageView = [[UIImageView alloc] init];
    self.rightTitleLabel = [[UILabel alloc] init];
    
    [self.rightImageView.layer setMasksToBounds:YES];
    self.rightImageView.layer.cornerRadius = 11;
    self.layer.masksToBounds = YES;
    self.rightImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.rightImageView.layer.borderWidth = 1;
    self.rightTitleLabel.textColor = LampTitleColor;
    self.rightTitleLabel.font = [UIFont systemFontOfSize:18];
    self.rightTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.rightImageView];
    [self addSubview:self.rightTitleLabel];
    
    [self.rightTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-11);
        make.width.mas_greaterThanOrEqualTo(50);
        make.height.mas_equalTo(30);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-10);
    }];
    
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.rightTitleLabel.mas_left).offset(-6);
        make.width.mas_equalTo(22);
        make.height.mas_equalTo(22);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-15);
    }];
    
    
    
    
    
    self.backgroundColor = AllTitleColor;
    [self cc_layoutSubviews];
}

- (void)cc_layoutSubviews {
    
    self.imageView.frame   = CGRectMake((self.frame.size.width - 100)/2, (self.frame.size.width - 50)/2, 100, 100);
    self.titleLabel.frame = CGRectMake(0, (CGRectGetMaxY(self.imageView.frame)), self.frame.size.width, 64);
    
    self.leftImageView.frame = CGRectMake(11, 11, 22, 22);
    self.leftTitleLabel.frame = CGRectMake(40, 5, 200, 30);
}

- (void)installData:(AllLampSpeciesModel *)element {
    _model = element;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:element.lampImg]];
    self.titleLabel.text = element.lampTitle;
    
    [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:element.lampImg]];
    self.leftTitleLabel.text = element.lampTitle;
    
    [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:element.lampImg]];
    self.rightTitleLabel.text = element.lampTitle;
}
@end
