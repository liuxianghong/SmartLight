//
//  AllAddLampViewController.m
//  Intelligentlamp
//
//  Created by L on 16/9/21.
//  Copyright © 2016年 L. All rights reserved.
//

#import "AllAddLampViewController.h"
#import "AllBulbCell.h"
#import "AddBulbCell.h"
#import "AllBulbModel.h"
#import "NoLampHeaderView.h"
#import "ChooseLampSpeciesVC.h"
#import "CommonUtility.h"
#import "LampNodataView.h"
#import "LoginViewController.h"
#import "LampSetUpViewController.h"
#import "AddLampFooterView.h"
#import "AllChooseGroupViewController.h"
#import "AllChooseScenarioViewController.h"

@interface AllAddLampViewController()<UITableViewDelegate,UITableViewDataSource>{
    UIButton *btn;
}
@property (nonatomic ,strong) UITableView *tableView;//列表
@property (nonatomic ,strong) NSMutableArray *allDataArr;//列表数据源

@property (nonatomic ,strong) NSMutableArray *selectArr;//选中要删除的数据
@property (assign , nonatomic) int pageno; /*第几页*/
@property (nonatomic, copy) NSString *refreshTime;//最后刷新的时间，下拉刷新时要传

@end

@implementation AllAddLampViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    _refreshTime = [[NSString alloc]init];
    _pageno = 1;
    
    [self setTitleViewWithStr:@"添加灯泡"];
    _selectArr = [NSMutableArray array];
    
    [self allDataArr];
    
    [self layoutUI];
    
    [self setTableID];
    
    [self leftBarButtonItem:[UIImage imageNamed:@"BackArrow"] withClickBtnAction:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    
}
#pragma -mark ViewController 生命周期函数

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    if (isUserLogin() == NO) {
        
        LoginViewController *vc = [[LoginViewController alloc]init];
        UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:vc];
        vc.hidesBottomBarWhenPushed = YES;
        [self presentViewController:nv animated:YES completion:nil];
    }
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}


- (UIBarButtonItem *)rightBarItem{
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 40, 30);
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitleColor:AllLampTitleColor forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    return rightBarItem;
}

//按钮对应tableView的编辑模式
-(void)btnPressed:(id)sender
{
    
    for (AllBulbModel *model in _allDataArr) {
        model.isNeedSetUp = NO;
        if (model.isSelected == YES) {
            [_selectArr addObject:model];
        }
        
    }
    [self addLamp:_selectArr];
    
//    UIButton *button = (UIButton *)sender;
//    if (self.tableView.editing == YES)
//    {
//        [button setTitle:@"选择" forState:UIControlStateNormal];
//        [self.tableView setEditing:NO animated:YES];
//        for (AllBulbModel *model in _allDataArr) {
//            model.isNeedSetUp = NO;
//            if (model.isSelected == YES) {
//                [_selectArr addObject:model];
//            }
//            
//        }
//        [self addLamp:_selectArr];
//    }
//    else
//    {
//        for (AllBulbModel *model in _allDataArr) {
//            model.isNeedSetUp = NO;
//            
//        }
//        [_tableView reloadData];
//        
//        [button setTitle:@"确定" forState:UIControlStateNormal];
//        [self.tableView setEditing:YES animated:YES];
//    }
}
- (void)addLamp:(NSArray *)lampArr{
    
    if (lampArr.count<=0) {
        [_tableView reloadData];
        return;
    }
    
    NSMutableArray *arr = [NSMutableArray array];
    for (AllBulbModel * model in lampArr) {
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
    
    NSString *url = [[NSString alloc]init];
    if (_isGroup == YES) {
     [dic setValue:_groupId forKey:@"groupId"];
        url = Group_AddDeviceToGroup;
    }else{
    [dic setValue:_sceneId forKey:@"sceneId"];
        url = Group_AddDeviceToScene;
    }
    
    [dic setValue:arr forKey:@"deviceList"];
    
    [self showNetWorkView];
    
    
    
    [LXNetworking postWithUrl:url params:dic success:^(id response) {
        [self hideNetWorkView];
        
        if (self.refreshBlock) {
            self.refreshBlock();
        }
        [self showRemendSuccessView:@"添加成功" withBlock:^{
            for (AllBulbModel *model in _allDataArr) {
                model.isNeedSetUp = NO;
                model.isSelected = NO;
                
            }
            [_selectArr removeAllObjects];
            [_tableView reloadData];
            
            [self.navigationController popViewControllerAnimated:YES];
        }];

        
    } fail:^(NSError *error) {
        [self hideNetWorkView];
        
        [self showRemendSuccessView:@"添加失败" withBlock:^{
            for (AllBulbModel *model in _allDataArr) {
                model.isNeedSetUp = NO;
                model.isSelected = NO;
                
            }
            [_selectArr removeAllObjects];
            [_tableView reloadData];
        }];
        
        
    } showHUD:nil];
    
}

- (NSMutableArray *)allDataArr{
    if (_allDataArr == nil) {
        _allDataArr = [NSMutableArray array];
    }
    return _allDataArr;
}

- (void)layoutUI{
    WEAKSELF
    _tableView = [[UITableView alloc]init];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.equalTo(self.view);
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-65);
    }];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _pageno ++;
        // 进入刷新状态后会自动调用这个block
        [weakSelf networkForMyAllLamp];
    }];
    
    
    _tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [_allDataArr removeAllObjects];
        weakSelf.pageno = 1;
        [weakSelf networkForMyAllLamp];
        
    }];
    [_tableView.mj_header beginRefreshing];
}


- (void)networkForMyAllLamp{
    
    NSMutableDictionary *dic                = [NSMutableDictionary dictionary];
    [dic setValue:@"1.0.0" forKey:@"version"];
    [dic setValue:getUserId() forKey:@"userId"];
    [dic setValue:_refreshTime forKey:@"refreshTime"];
    [dic setValue:getUserToken() forKey:@"token"];
    [dic setValue:@"1" forKey:@"deviceType"];
    [dic setValue:[NSString stringWithFormat:@"%d",_pageno] forKey:@"pageNo"];//页数
    [dic setValue:@"10" forKey:@"pageSize"];//每页多少数据
    
    
    [self showNetWorkView];
    
    
    [LXNetworking postWithUrl:Brand_getMyDeviceList params:dic success:^(id response) {
        [self hideNetWorkView];
        
        if ([response[@"deviceList"] isEqual:[NSNull null]]) {
            
            [self showRemendWarningView:@"没有更多数据" withBlock:nil];
            [_tableView.mj_footer endRefreshing];
            [_tableView.mj_header endRefreshing];
            return ;
        }
        
        if (response[@"deviceList"] != nil ||![response[@"deviceList"] isEqual:[NSNull null]]) {
            
            NSArray *arr = response[@"deviceList"];
            _refreshTime = response[@"refreshTime"];
            for (int i = 0; i<arr.count; i++) {
                AllBulbModel *model = [[AllBulbModel alloc]init];
                model.lampId = arr[i][@"deviceId"];
                model.lampImg = arr[i][@"deviceLogoURL"];
                model.lampName = arr[i][@"deviceName"];
                model.lampBrandId = arr[i][@"brandId"];
                model.lampMacAddress = arr[i][@"macAddress"];
                model.lampDescription = arr[i][@"description"];
                model.isNeedSetUp = NO;
                
                [self.allDataArr addObject:model];
            }
            
        }
        
        if (_allDataArr.count >0) {
            
            self.navigationItem.rightBarButtonItem = [self rightBarItem];

        }else{
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]init];
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

- (void)setTableID{
    [self.tableView registerClass:[AllBulbCell class] forCellReuseIdentifier:NSStringFromClass([AllBulbCell class])];
    [self.tableView registerClass:[AddBulbCell class] forCellReuseIdentifier:NSStringFromClass([AddBulbCell class])];
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
    
    AllBulbCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AllBulbCell class]) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.indexPath = indexPath ;
    cell.model = _allDataArr[indexPath.row];
    
    
    cell.setUpBlock = ^(NSIndexPath *index){
        
//        AllLampSetUpViewController *vc = [[AllLampSetUpViewController alloc]init];
//        AllBulbModel *model = _allDataArr[indexPath.row];
//        vc.lampId = model.lampId;
//        vc.needOpen = @"1";
//        vc.hidesBottomBarWhenPushed = YES;
//        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    cell.deleteBlock = ^(NSIndexPath *index){
        
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


