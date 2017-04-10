//
//  LampNodataView.h
//  Intelligentlamp
//
//  Created by L on 16/8/29.
//  Copyright © 2016年 L. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RootViewController;

@interface LampNodataView : UIView

@property (nonatomic , strong) UIButton *promptImageView;
@property (nonatomic , strong) UILabel *promptLabel;

+(LampNodataView *)shareInstance;
- (void)initInSuperView:(UIView *)superView
         withPictureUrl:(NSString *)pictureUrl
              withTitle:(NSString *)title;

-(void)hideSupview;

- (void)initInSuperVC:(RootViewController *)superVC
       withPictureUrl:(NSString *)pictureUrl
            withTitle:(NSString *)title;
@end
