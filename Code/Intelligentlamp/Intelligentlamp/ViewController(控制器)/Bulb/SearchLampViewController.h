//
//  SearchLampViewController.h
//  Intelligentlamp
//
//  Created by L on 16/8/25.
//  Copyright © 2016年 L. All rights reserved.
//

#import "RootViewController.h"

@interface SearchLampViewController : RootViewController<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic ,strong) NSString *brandId;

@property (nonatomic ,strong) NSString *lampMsg;//灯泡品牌的关键字
@end
