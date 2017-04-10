//
//  AllChooseGroupViewController.m
//  Intelligentlamp
//
//  Created by L on 16/9/18.
//  Copyright © 2016年 L. All rights reserved.
//

#import "AllChooseGroupViewController.h"
#import "AllChooseGroupCell.h"
#import "MJRefresh.h"
#import "AllGroupModel.h"
#import "AllBulbModel.h"

@interface AllChooseGroupViewController() <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic ,strong) UICollectionView *collectionView;

@property (assign , nonatomic) int pageno; /*第几页*/
@property (nonatomic, copy) NSString *refreshTime;//最后刷新的时间，下拉刷新时要传
@property (nonatomic ,strong) NSMutableArray *allDataArr;//列表数据源


@end

@implementation AllChooseGroupViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = AllBgColor;
    
    _refreshTime = [[NSString alloc]init];
    _pageno = 1;
    _allDataArr = [NSMutableArray array];
    
    [self setTitleViewWithStr:@"添加到分组"];
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
    [dic setValue:_refreshTime forKey:@"refreshTime"];
    [dic setValue:getUserToken() forKey:@"token"];
    [dic setValue:@"0" forKey:@"deviceId"];
    [dic setValue:[NSString stringWithFormat:@"%d",_pageno] forKey:@"pageNo"];//页数
    [dic setValue:@"10" forKey:@"pageSize"];//每页多少数据
    
    //    if ([LXNetworking sharedLXNetworking].networkStats == StatusNotReachable) {
    //        [self showRemendWarningView:@"没有网络" withBlock:nil];
    //
    //    }else{
    
    [self showNetWorkView];
    
    
    [LXNetworking postWithUrl:Group_GetDeviceGroupList params:dic success:^(id response) {
        [self hideNetWorkView];
        
        if ([response[@"deviceGroupList"] isEqual:[NSNull null]]) {
            
            [self showRemendWarningView:@"没有更多数据" withBlock:nil];
            [_collectionView.mj_footer endRefreshing];
            [_collectionView.mj_header endRefreshing];
            return ;
        }
        
        if (response[@"deviceGroupList"] != nil ||![response[@"deviceGroupList"] isEqual:[NSNull null]]) {
            
            NSArray *arr = response[@"deviceGroupList"];
            _refreshTime = response[@"refreshTime"];
            for (int i = 0; i<arr.count; i++) {
                AllGroupModel *model = [[AllGroupModel alloc]init];
                model.groupId = arr[i][@"groupId"];
                model.groupImg = arr[i][@"groupLogoURL"];
                model.groupTitle = arr[i][@"groupName"];
                model.groupDescribe = arr[i][@"description"];
                model.groupOpenTime = arr[i][@"timingOpenTime"];
                model.groupCloseTime = arr[i][@"timingCloseTime"];
                model.createTime = arr[i][@"createTime"];
                
                [self.allDataArr addObject:model];
            }
            
        }
        
        [_collectionView reloadData];
        [_collectionView.mj_footer endRefreshing];
        [_collectionView.mj_header endRefreshing];
    } fail:^(NSError *error) {
        [self hideNetWorkView];
        [_collectionView.mj_footer endRefreshing];
        [_collectionView.mj_header endRefreshing];
    } showHUD:nil];
    
    //    }
    
    
}

- (void)addLampToGroup:(NSString *)groupId{
    
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
    [dic setValue:groupId forKey:@"groupId"];
    [dic setValue:arr forKey:@"deviceList"];

        [self showNetWorkView];
        
        
        [LXNetworking postWithUrl:Group_AddDeviceToGroup params:dic success:^(id response) {
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
    cell.model = _allDataArr[indexPath.row];

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
    AllGroupModel *m = _allDataArr[indexPath.row];
    [self addLampToGroup:m.groupId];
    
}

@end
