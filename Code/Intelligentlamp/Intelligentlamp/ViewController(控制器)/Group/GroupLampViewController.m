//
//  GroupLampViewController.m
//  Intelligentlamp
//
//  Created by L on 16/8/20.
//  Copyright © 2016年 L. All rights reserved.
//
#define AllBulbTitleColor HEXCOLOR(0x8c8c8e)
#import "GroupLampViewController.h"
#import "GroupLampModel.h"
#import "GrouplampCell.h"
#import "AddLampFooterView.h"
#import "LampSetUpViewController.h"
#import "MJRefresh.h"
#import "AllAddLampViewController.h"

@interface GroupLampViewController()<UITableViewDelegate,UITableViewDataSource>{
    UIButton *btn;
}
@property (nonatomic ,strong) UITableView *tableView;//列表
@property (nonatomic ,strong) NSMutableArray *allDataArr;//列表数据源
@property (nonatomic ,strong) NSMutableArray *selectArr;//选中要删除的数据
@property (nonatomic ,strong) AddLampFooterView *footerView;

@property (assign , nonatomic) int pageno; /*第几页*/
@property (nonatomic ,copy) NSString *refreshTime;

@end

@implementation GroupLampViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    _refreshTime                            = [[NSString alloc]init];
    _pageno                                 = 1;

    _selectArr                              = [NSMutableArray array];
    [self setTitleViewWithStr:self.controllerTitle];


    [self layoutUI];

    [self setTableID];

    [self leftBarButtonItem:[UIImage imageNamed:@"BackArrow"] withClickBtnAction:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];

    self.navigationItem.rightBarButtonItem  = [self rightBarItem];


}
#pragma -mark ViewController 生命周期函数

- (UIBarButtonItem *)rightBarItem{

    btn                                     = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame                               = CGRectMake(0, 0, 40, 30);
    [btn setTitle:@"删除" forState:UIControlStateNormal];
    btn.titleLabel.font                     = [UIFont systemFontOfSize:14];
    [btn setTitleColor:AllBulbTitleColor forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItem           = [[UIBarButtonItem alloc]initWithCustomView:btn];
    return rightBarItem;
}

//按钮对应tableView的编辑模式
-(void)btnPressed:(id)sender
{
    UIButton *btn2                          = (UIButton *)sender;
    if (self.tableView.editing == YES)
    {
        [btn2 setTitle:@"删除" forState:UIControlStateNormal];
        [self.tableView setEditing:NO animated:YES];
        for (GroupLampModel *model in _allDataArr) {
    model.isNeedSetUp                       = NO;
            if (model.isSelected == YES) {
                [_selectArr addObject:model];
            }

        }

        [self deleteLamp:_selectArr];

    }
    else
    {
        for (GroupLampModel *model in _allDataArr) {
    model.isNeedSetUp                       = NO;
        }
        [_tableView reloadData];

        [btn2 setTitle:@"删除" forState:UIControlStateNormal];
        [self.tableView setEditing:YES animated:YES];
    }
}

/**
 *  删除灯泡
 *
 *  @param lampArr 删除的灯泡数组
 */
- (void)deleteLamp:(NSArray *)lampArr{

    if (lampArr.count<=0) {
        [_tableView reloadData];
        return;
    }

    NSMutableArray *arr                     = [NSMutableArray array];
    for (GroupLampModel * model in lampArr) {
    NSMutableDictionary * dic2              = [[NSMutableDictionary alloc]init];
        [dic2 setValue:model.lampId forKey:@"deviceId"];
        [arr addObject:model.lampId];
    }

    NSMutableDictionary *dic                = [NSMutableDictionary dictionary];
    [dic setValue:@"1.0.0" forKey:@"version"];
    [dic setValue:getUserId() forKey:@"userId"];
    [dic setValue:getUserToken() forKey:@"token"];
    [dic setValue:_groupId forKey:@"groupId"];
    [dic setValue:arr forKey:@"deviceList"];

    [self showNetWorkView];


    [LXNetworking postWithUrl:Group_DeleteDeviceFromGroup params:dic success:^(id response) {
        [self hideNetWorkView];

        [self showRemendSuccessView:@"删除成功" withBlock:nil];

        [_allDataArr removeObjectsInArray:_selectArr];
        [_tableView reloadData];

    } fail:^(NSError *error) {
        [self hideNetWorkView];

        for (GroupLampModel *model in _allDataArr) {
    model.isNeedSetUp                       = NO;
    model.isSelected                        = NO;

        }

        [btn setTitle:@"编辑" forState:UIControlStateNormal];
        [self.tableView setEditing:NO animated:YES];
        [_selectArr removeAllObjects];
        [_tableView reloadData];

        [self showRemendWarningView:@"删除失败" withBlock:nil];
    } showHUD:nil];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [LXNetworking startMonitoring];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

/**
 *  获取所有的灯泡
 */
- (void)networkForAllLamp{

    NSMutableDictionary *dic                = [NSMutableDictionary dictionary];
    [dic setValue:@"1.0.0" forKey:@"version"];
    [dic setValue:getUserId() forKey:@"userId"];
    [dic setValue:getUserToken() forKey:@"token"];
    [dic setValue:_refreshTime forKey:@"refreshTime"];
    [dic setValue:[NSString stringWithFormat:@"%d",_pageno] forKey:@"pageNo"];//页数
    [dic setValue:@"10" forKey:@"pageSize"];//每页多少数据
    [dic setValue:_groupId forKey:@"groupId"];


        if ([LXNetworking sharedLXNetworking].networkStats == StatusNotReachable) {
            [self showRemendWarningView:@"没有网络" withBlock:nil];

        }else{

    [self showNetWorkView];


    [LXNetworking postWithUrl:Group_GetGroupDeviceList params:dic success:^(id response) {
        [self hideNetWorkView];

        if ([response[@"deviceList"] isEqual:[NSNull null]]||response[@"deviceList"] == nil) {
            [_tableView.mj_footer endRefreshing];
            [_tableView.mj_header endRefreshing];
            return ;
        }

    NSArray *arr                            = response[@"deviceList"];
    _refreshTime                            = response[@"refreshTime"];
    for (int i                              = 0; i<arr.count; i++) {
    GroupLampModel *model                   = [[GroupLampModel alloc]init];
    model.lampId                            = arr[i][@"deviceId"];
    model.lampImg                           = arr[i][@"deviceLogoURL"];
    model.lampName                          = arr[i][@"deviceName"];
    model.isNeedSetUp                       = NO;
    model.isSelected                        = NO;
            [self.allDataArr addObject:model];
        }

        [_tableView reloadData];
        [_tableView.mj_footer endRefreshing];
        [_tableView.mj_header endRefreshing];
    } fail:^(NSError *error) {
        [self hideNetWorkView];

        [_tableView.mj_footer endRefreshing];
        [_tableView.mj_header endRefreshing];
    } showHUD:nil];

        }


}
- (NSMutableArray *)allDataArr{
    if (_allDataArr == nil) {
    _allDataArr                             = [NSMutableArray array];
    }
    return _allDataArr;
}

- (void)layoutUI{
    WEAKSELF

    _tableView                              = [[UITableView alloc]init];
    _tableView.backgroundColor              = [UIColor clearColor];
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    //添加_footView
    _footerView                             = [[AddLampFooterView alloc]init];
    _tableView.tableFooterView              = _footerView;
    [_footerView layoutFooterView];
    CGFloat height                          = [_footerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + _footerView.frame.origin.y;

    CGRect footFrame                        = _footerView.frame;
    footFrame.size.height                   = height;
    _footerView.frame                       = footFrame;
    [self.tableView setTableFooterView:_footerView];

    _footerView.addLampBlock                = ^(){

    AllAddLampViewController *vc            = [[AllAddLampViewController alloc]init];
    vc.refreshBlock                         = ^(){
        [weakSelf.allDataArr removeAllObjects];
            [weakSelf networkForAllLamp];
        };
    vc.isGroup                              = YES;
    vc.groupId                              = weakSelf.groupId;
    vc.hidesBottomBarWhenPushed             = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };


    self.tableView.delegate                 = self;
    self.tableView.dataSource               = self;
    self.tableView.separatorStyle           = UITableViewCellSeparatorStyleNone;

    _tableView.mj_footer                    = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _pageno ++;
        // 进入刷新状态后会自动调用这个block
        [weakSelf networkForAllLamp];
    }];

    _tableView.mj_header                    = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [_allDataArr removeAllObjects];
    weakSelf.pageno                         = 1;
        [weakSelf networkForAllLamp];

    }];
    [_tableView.mj_header beginRefreshing];
}

- (void)setTableID{
    [self.tableView registerClass:[GrouplampCell class] forCellReuseIdentifier:NSStringFromClass([GrouplampCell class])];
}

#pragma - mark UITableViewDelegate and DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _allDataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WEAKSELF
    GrouplampCell *cell                     = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GrouplampCell class]) forIndexPath:indexPath];
    cell.selectionStyle                     = UITableViewCellSelectionStyleNone;
    cell.indexPath                          = indexPath ;
    cell.model                              = _allDataArr[indexPath.row];


    cell.setUpBlock                         = ^(NSIndexPath *index){
        NSLog(@"%ld",(long)index.row);
    LampSetUpViewController *vc             = [[LampSetUpViewController alloc]init];
    GroupLampModel *m                       = _allDataArr[index.row];
    vc.lampId                               = m.lampId;
    vc.hidesBottomBarWhenPushed             = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };

    cell.deleteBlock                        = ^(NSIndexPath *index){

    };

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 61;
}

#pragma - mark UITableView的编辑方法

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath

{
    return NO;
}

@end

