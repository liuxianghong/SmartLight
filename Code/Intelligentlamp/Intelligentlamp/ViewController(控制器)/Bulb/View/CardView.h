//
//  CardView.h
//  ZLSwipeableViewDemo
//
//  Created by Zhixuan Lai on 11/1/14.
//  Copyright (c) 2014 Zhixuan Lai. All rights reserved.
//

#import "AllLampSpeciesModel.h"
#import <UIKit/UIKit.h>

typedef void(^EventBlock)(AllLampSpeciesModel *model);
@interface CardView : UIView

@property (nonatomic ,copy) EventBlock eventBlock;

@property (nonatomic ,strong) AllLampSpeciesModel *model;
- (void)installData:(AllLampSpeciesModel *)element;
@end
