//
//  AllGroupViewController.m
//  Intelligentlamp
//
//  Created by L on 16/8/28.
//  Copyright © 2016年 L. All rights reserved.
//

#import "AllGroupViewController.h"

#import "AllGroupModel.h"
#import "AllGroupCell.h"
#import "GroupLampViewController.h"
#import "GroupSetUpViewController.h"
#import "GroupFooterView.h"
#import "AddGroupViewController.h"

@interface AllGroupViewController()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) UITableView *tableView;//列表
@property (nonatomic ,strong) NSMutableArray *allDataArr;//列表数据源
@property (nonatomic ,strong) GroupFooterView *footView;//尾部


@property (assign , nonatomic) int pageno; /*第几页*/
@property (nonatomic, copy) NSString *refreshTime;//最后刷新的时间，下拉刷新时要传

@end

@implementation AllGroupViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    _refreshTime = [[NSString alloc]init];
    _pageno = 1;
//    self.navigationItem.rightBarButtonItem = [self rightBarItem];
    
    [self leftBarButtonItem:[UIImage imageNamed:@"BackArrow"] withClickBtnAction:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self setTitleViewWithStr:@"分组"];
    
    [self layoutUI];
    
    [self setTableID];
}
#pragma -mark ViewController 生命周期函数

- (UIBarButtonItem *)rightBarItem{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 40, 30);
    [btn setTitle:@"编辑" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitleColor:AllLampTitleColor forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    return rightBarItem;
}
//按钮对应tableView的编辑模式
-(void)btnPressed:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (self.tableView.editing == YES)
    {
        [btn setTitle:@"编辑" forState:UIControlStateNormal];
        [self.tableView setEditing:NO animated:YES];
    }
    else
    {
        [btn setTitle:@"完成" forState:UIControlStateNormal];
        [self.tableView setEditing:YES animated:YES];
    }
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated 
{
    [super viewWillDisappear:animated];
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
        make.edges.equalTo(self.view);
    }];
    
    //添加_footView
    _footView = [[GroupFooterView alloc]init];
    [_footView layoutFooterView];
    CGFloat height = [_footView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + _footView.frame.origin.y;
    
    CGRect footFrame             = _footView.frame;
    footFrame.size.height        = height;
    _footView.frame          = footFrame;
//    [self.tableView setTableFooterView:_footView];
    
    _footView.addGroupBlock = ^(){
        AddGroupViewController *vc = [[AddGroupViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
        
    };
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _pageno ++;
        // 进入刷新状态后会自动调用这个block
        [weakSelf networkForAllGroup];
    }];
    
    
    _tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [_allDataArr removeAllObjects];
        weakSelf.pageno = 1;
        [weakSelf networkForAllGroup];
        
    }];
    [_tableView.mj_header beginRefreshing];

}

- (void)networkForAllGroup{
    
    NSMutableDictionary *dic                = [NSMutableDictionary dictionary];
    [dic setValue:@"1.0.0" forKey:@"version"];
    [dic setValue:_lampId forKey:@"deviceId"];
    [dic setValue:getUserId() forKey:@"userId"];
    [dic setValue:_refreshTime forKey:@"refreshTime"];
    [dic setValue:getUserToken() forKey:@"token"];
    [dic setValue:[NSString stringWithFormat:@"%d",_pageno] forKey:@"pageNo"];//页数
    [dic setValue:@"10" forKey:@"pageSize"];//每页多少数据
    
    
    [self showNetWorkView];
    
    
    [LXNetworking postWithUrl:Group_GetDeviceGroupList params:dic success:^(id response) {
        [self hideNetWorkView];
        
        if ([response[@"deviceGroupList"] isEqual:[NSNull null]]) {
            
            [self showRemendWarningView:@"没有更多数据" withBlock:nil];
            [_tableView.mj_footer endRefreshing];
            [_tableView.mj_header endRefreshing];
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
    [self.tableView registerClass:[AllGroupCell class] forCellReuseIdentifier:NSStringFromClass([AllGroupCell class])];
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
    AllGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AllGroupCell class]) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.indexPath = indexPath ;
    cell.setUpBtn.hidden = YES;
    cell.model = _allDataArr[indexPath.row];
    
    cell.setUpBlock = ^(NSIndexPath *index){
//        GroupSetUpViewController *vc = [[GroupSetUpViewController alloc]init];
//        vc.model =_allDataArr[index.row];
//        vc.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:vc animated:YES];
    };
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    GroupLampViewController *vc = [[GroupLampViewController alloc]init];
//    vc.hidesBottomBarWhenPushed = YES;
//    AllGroupModel *model = [[AllGroupModel alloc]init];
//    model = _allDataArr[indexPath.row];
//    vc.controllerTitle = model.groupTitle;
//    [self.navigationController pushViewController:vc animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 61;
}

#pragma - mark UITableView的编辑方法

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath

{
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    return UITableViewCellEditingStyleDelete;
    
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath

{
    　　[_allDataArr removeObjectAtIndex:indexPath.row];
    
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

@end
