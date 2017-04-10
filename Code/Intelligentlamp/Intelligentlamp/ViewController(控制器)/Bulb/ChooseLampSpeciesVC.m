//
//  ChooseLampSpeciesVC.m
//  Intelligentlamp
//
//  Created by L on 16/8/25.
//  Copyright © 2016年 L. All rights reserved.
//

#import "ChooseLampSpeciesVC.h"
#import "AllLampSpeciesModel.h"
#import "AllLampSpeciesCell.h"
#import "SearchLampViewController.h"
#import "CCDraggableContainer.h"
#import "CustomCardView.h"
#import "ZLSwipeableView.h"
#import "CardView.h"
#import "UIColor+FlatColors.h"

@interface ChooseLampSpeciesVC()<ZLSwipeableViewDelegate,ZLSwipeableViewDataSource>
@property (nonatomic ,strong) NSMutableArray *allDataArr;//列表数据源

@property (assign , nonatomic) int pageno; /*第几页*/
@property (nonatomic, copy) NSString *refreshTime;//最后刷新的时间，下拉刷新时要传

@property (nonatomic) NSUInteger colorIndex;

@end

@implementation ChooseLampSpeciesVC


- (void)viewDidLoad{
    [super viewDidLoad];
    
    _refreshTime = [[NSString alloc]init];
    _pageno = 1;
    self.colorIndex = 0;
    
    [self setTitleViewWithStr:@"选择种类"];
    
    [self leftBarButtonItem:[UIImage imageNamed:@"BackArrow"] withClickBtnAction:^{
        [self.navigationController popViewControllerAnimated:NO];
    }];
    
    [self initDataArr];
    
    [self networkForAllLampSpecies];
    

}
#pragma -mark ViewController 生命周期函数

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     [LXNetworking startMonitoring];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)initDataArr{
    NSArray *nameArr = @[@"灯泡种类",@"灯泡种类",@"灯泡种类",@"灯泡种类"];
    NSArray *imageArr = @[ @"mine_shetuan",@"mine_huodong",@"mine_haoyou",@"mine_shoucang"];
    
    for (NSInteger i = 0; i < 4; i++) {
        AllLampSpeciesModel *model = [[AllLampSpeciesModel alloc]init];
        model.lampTitle = nameArr[i];
        model.lampImg = imageArr[i];
//        [self.allDataArr addObject:model];
    }
}

- (NSMutableArray *)allDataArr{
    if (_allDataArr == nil) {
        _allDataArr = [NSMutableArray array];
    }
    return _allDataArr;
}

- (void)networkForAllLampSpecies{
    
    NSMutableDictionary *dic                = [NSMutableDictionary dictionary];
    [dic setValue:@"1.0.0" forKey:@"version"];
    [dic setValue:getUserId() forKey:@"userId"];
    [dic setValue:_refreshTime forKey:@"refreshTime"];
    [dic setValue:getUserToken() forKey:@"token"];
    [dic setValue:[NSString stringWithFormat:@"%d",_pageno] forKey:@"pageNo"];//页数
    [dic setValue:@"10" forKey:@"pageSize"];//每页多少数据
    
    [self showNetWorkView];
    
    
    [LXNetworking postWithUrl:Brand_GetBrandList params:dic success:^(id response) {
        [self hideNetWorkView];
        
        if ([response[@"brandList"] isEqual:[NSNull null]]) {
            
            [self showRemendWarningView:@"没有更多数据" withBlock:nil];
            return ;
        }
        
        if (response[@"brandList"] != nil ||![response[@"brandList"] isEqual:[NSNull null]]) {
            
            NSArray *arr = response[@"brandList"];
            _refreshTime = response[@"refreshTime"];
            for (int i = 0; i<arr.count; i++) {
                AllLampSpeciesModel *model = [[AllLampSpeciesModel alloc]init];
                model.lampId = arr[i][@"brandId"];
                model.lampImg = arr[i][@"brandLogoURL"];
                model.lampTitle = arr[i][@"brandName"];
                model.lampMsg = arr[i][@"brandWord"];
                
                [self.allDataArr addObject:model];
            }
            
        }

        [self loadUI];

    } fail:^(NSError *error) {
        
        [self hideNetWorkView];

    } showHUD:nil];

    
    
}


- (void)loadUI {
    
    ZLSwipeableView *swipeableView = [[ZLSwipeableView alloc] initWithFrame:CGRectZero];
    self.swipeableView = swipeableView;
    [self.view addSubview:self.swipeableView];
    
    // Required Data Source
    self.swipeableView.dataSource = self;
    
    // Optional Delegate
    self.swipeableView.delegate = self;
    
    self.swipeableView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *metrics = @{};
    
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"|-50-[swipeableView]-50-|"
                               options:0
                               metrics:metrics
                               views:NSDictionaryOfVariableBindings(
                                                                    swipeableView)]];
    
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:|-60-[swipeableView]-100-|"
                               options:0
                               metrics:metrics
                               views:NSDictionaryOfVariableBindings(
                                                                    swipeableView)]];
}

- (void)viewDidLayoutSubviews {
    [self.swipeableView loadViewsIfNeeded];
}


#pragma mark - ZLSwipeableViewDataSource

- (UIView *)nextViewForSwipeableView:(ZLSwipeableView *)swipeableView {
    if (self.colorIndex >= self.allDataArr.count) {
        self.colorIndex = 0;
    }
    
    CardView *view = [[CardView alloc] initWithFrame:swipeableView.bounds];
    [view installData:_allDataArr[self.colorIndex]];
    view.eventBlock = ^(AllLampSpeciesModel *model){
        NSLog(@"%@",model.lampId);
        SearchLampViewController *vc = [[SearchLampViewController alloc]init];
        vc.lampMsg = model.lampMsg;
        vc.brandId = model.lampId;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    };
    self.colorIndex++;
    
    return view;
}

#pragma mark - ZLSwipeableViewDelegate

- (void)swipeableView:(ZLSwipeableView *)swipeableView
         didSwipeView:(UIView *)view
          inDirection:(ZLSwipeableViewDirection)direction {
    NSLog(@"did swipe in direction: %zd", direction);
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView didCancelSwipe:(UIView *)view {
    NSLog(@"did cancel swipe");
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView
  didStartSwipingView:(UIView *)view
           atLocation:(CGPoint)location {
    NSLog(@"did start swiping at location: x %f, y %f", location.x, location.y);
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView
          swipingView:(UIView *)view
           atLocation:(CGPoint)location
          translation:(CGPoint)translation {
    NSLog(@"swiping at location: x %f, y %f, translation: x %f, y %f", location.x, location.y,
          translation.x, translation.y);
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView
    didEndSwipingView:(UIView *)view
           atLocation:(CGPoint)location {
    NSLog(@"did end swiping at location: x %f, y %f", location.x, location.y);
}

@end
