//
//  AllChooseScenarioViewController.m
//  Intelligentlamp
//
//  Created by L on 16/9/18.
//  Copyright © 2016年 L. All rights reserved.
//

#import "AllChooseScenarioViewController.h"
#import "AllChooseGroupCell.h"
#import "MJRefresh.h"
#import "AllScenarioModel.h"
#import "AllBulbModel.h"

@interface AllChooseScenarioViewController() <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic ,strong) UICollectionView *collectionView;

@property (assign , nonatomic) int pageno; /*第几页*/
@property (nonatomic, copy) NSString *refreshTime;//最后刷新的时间，下拉刷新时要传
@property (nonatomic ,strong) NSMutableArray *allDataArr;//列表数据源

@end
@implementation AllChooseScenarioViewController

 
- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = AllBgColor;
    _refreshTime = [[NSString alloc]init];
    _pageno = 1;
    _allDataArr = [NSMutableArray array];
    
    [self setTitleViewWithStr:@"添加到场景"];
    [self leftBarButtonItem:[UIImage imageNamed:@"BackArrow"] withClickBtnAction:^{
        [self.navigationController popViewControllerAnimated:NO];
        
        if (self.refreshBlock) {
            self.refreshBlock();
        }
    }];
    
    
    [self layoutUI];
    
//    [self networkForAllGroup];
 
}

- (void)layoutUI{
    WEAKSELF
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) collectionViewLayout:flowLayout];
    flowLayout.headerReferenceSize          = CGSizeMake(ScreenWidth, 0);
    
    [_collectionView registerClass:[AllChooseGroupCell class] forCellWithReuseIdentifier:@"AllChooseGroupCell"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.allowsSelection      = YES;
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.backgroundColor = AllBgColor;
    [self.view addSubview:_collectionView];
    
    _collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _pageno ++;
        // 进入刷新状态后会自动调用这个block
        [weakSelf networkForAllGroup];
    }];
    
    
    _collectionView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [_allDataArr removeAllObjects];
        weakSelf.pageno = 1;
        [weakSelf networkForAllGroup];
        
    }];
    [_collectionView.mj_header beginRefreshing];
    
}

- (void)networkForAllGroup{
    
    NSMutableDictionary *dic                = [NSMutableDictionary dictionary];
    [dic setValue:@"1.0.0" forKey:@"version"];
    [dic setValue:getUserId() forKey:@"userId"];
    [dic setValue:getUserToken() forKey:@"token"];
    [dic setValue:@"0" forKey:@"deviceId"];
    [dic setValue:[NSString stringWithFormat:@"%d",_pageno] forKey:@"pageNo"];//页数
    [dic setValue:@"10" forKey:@"pageSize"];//每页多少数据
    
    //        if ([LXNetworking sharedLXNetworking].networkStats == StatusNotReachable) {
    //            [self showRemendWarningView:@"没有网络" withBlock:nil];
    //
    //        }else{
    
    [self showNetWorkView];
    
    
    [LXNetworking postWithUrl:Group_GetSceneList params:dic success:^(id response) {
        [self hideNetWorkView];
        
        if ([response[@"sceneList"] isEqual:[NSNull null]]) {
            
            [self showRemendWarningView:@"没有更多数据" withBlock:nil];
            [_collectionView.mj_footer endRefreshing];
            [_collectionView.mj_header endRefreshing];
            return ;
        }
        
        if (response[@"deviceGroupList"] != nil ||![response[@"deviceGroupList"] isEqual:[NSNull null]]) {
            
            NSArray *arr = response[@"sceneList"];
            _refreshTime = response[@"refreshTime"];
            for (int i = 0; i<arr.count; i++) {
                AllScenarioModel *model = [[AllScenarioModel alloc]init];
                model.ScenarioId = arr[i][@"sceneId"];
                model.ScenarioImg = arr[i][@"sceneLogoURL"];
                model.ScenarioTitle = arr[i][@"sceneName"];
                model.ScenarioDescribe = arr[i][@"description"];
                model.ScenarioOpenTime = arr[i][@"timingOpenTime"];
                model.ScenarioCloseTime = arr[i][@"timingCloseTime"];
                model.ScenarioCreateTime = arr[i][@"createTime"];
                
                [self.allDataArr addObject:model];
            }
            
        }
        
        [_collectionView reloadData];
        [_collectionView.mj_footer endRefreshing];
        [_collectionView.mj_header endRefreshing];
        
        
        [_collectionView.mj_footer endRefreshing];
    } fail:^(NSError *error) {
        [self hideNetWorkView];
        [_collectionView.mj_footer endRefreshing];
        [_collectionView.mj_header endRefreshing];
    } showHUD:nil];
    
    //        }
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
//设置段数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//设置单元格个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _allDataArr.count;
}
//UICollectionViewCell
//只能用注册自定义cell的方式
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    AllChooseGroupCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AllChooseGroupCell" forIndexPath:indexPath];
    cell.scenario = _allDataArr[indexPath.row];
    return cell;
}

//设置item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(66, 100);
}

//设置水平间隙  ： 默认10
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return (ScreenWidth - 66*4)/5;
}
//设置竖直间隙  ： 默认10
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 30;
}
//设置边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    //上左下右
    return UIEdgeInsetsMake(10 ,10, 10, 10);
}
//点击方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //
    NSLog(@"%ld====%ld",(long)indexPath.section,(long)indexPath.item);
    AllScenarioModel *model = _allDataArr[indexPath.row];
    [self addLampToScenario:model];
}

- (void)addLampToScenario:(AllScenarioModel *)scenarioModel{
    
    NSMutableArray *arr = [NSMutableArray array];
    for (AllBulbModel * model in _dataArr) {
        NSMutableDictionary * dic2 = [[NSMutableDictionary alloc]init];
        [dic2 setValue:model.lampId forKey:@"deviceId"];
        [dic2 setValue:model.lampName forKey:@"deviceName"];
        [dic2 setValue:model.lampImg forKey:@"deviceLogoURL"];
        [dic2 setValue:model.lampMacAddress forKey:@"macAddress"];
        [dic2 setValue:model.lampBrandId forKey:@"brandId"];
        [dic2 setValue:model.lampDescription forKey:@"description"];
        [arr addObject:dic2];
    }
    
    NSMutableDictionary *dic                = [NSMutableDictionary dictionary];
    [dic setValue:@"1.0.0" forKey:@"version"];
    [dic setValue:getUserId() forKey:@"userId"];
    [dic setValue:getUserToken() forKey:@"token"];
    [dic setValue:scenarioModel.ScenarioId forKey:@"sceneId"];
    [dic setValue:arr forKey:@"deviceList"];
    
    
    [self showNetWorkView];
    
    
    [LXNetworking postWithUrl:Group_AddDeviceToScene params:dic success:^(id response) {
        [self hideNetWorkView];
        
        [self showRemendSuccessView:@"添加成功" withBlock:^{
            [self.navigationController popViewControllerAnimated:NO];
            if (self.refreshBlock) {
                self.refreshBlock();
            }
        }];
        
    } fail:^(NSError *error) {
        [self hideNetWorkView];
        
        [self showRemendWarningView:@"添加失败" withBlock:nil];
    } showHUD:nil];

}

@end
