//
//  AddGroupViewController.m
//  Intelligentlamp
//
//  Created by L on 16/8/20.
//  Copyright © 2016年 L. All rights reserved.
//

#define AllBulbDescribeColor HEXCOLOR(0x8c8c8e)
#define AllBulbLineColor HEXCOLOR(0x19181b)
#import "AddGroupViewController.h"
#import "GroupSetUpVCHeaderView.h"
#import "ImageSelector.h"
#import "UIView+Progress.h"
#import "GroupNameSetUpCell.h"
#import "GroupSetUpNameViewController.h"
#import "GroupLampModel.h"
#import "SelectLampCell.h"
#import "GroupSetUpTimeViewController.h"
#import "AllGroupModel.h"


@interface AddGroupViewController()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) UITableView *tableView;//列表
@property (nonatomic ,strong) NSMutableArray *allDataArr;//列表数据源
@property (nonatomic ,strong) GroupSetUpVCHeaderView *headerView;//头部
@property (nonatomic ,strong) NSMutableArray *selectLampArr;//选中的灯泡数组

@property (nonatomic ,strong) AllGroupModel *model;


@end

@implementation AddGroupViewController


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


- (void)viewDidLoad{
    [super viewDidLoad];
 WEAKSELF
    _model = [[AllGroupModel alloc]init];
    _selectLampArr = [NSMutableArray array];
    
    [self setTitleViewWithStr:@"创建分组"];
    
    [self initDataArr];
    
    [self layoutUI];
    
    [self setTableID];
    
    [self leftBarButtonItem:[UIImage imageNamed:@"BackArrow"] withClickBtnAction:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    
    [self rightBarButtonItemWithTitle:@"确定" withClickBtnAction:^{
        [weakSelf addNewGroup];
        
    }];
}

- (void)addNewGroup{
    
    NSArray *arr = @[];
    NSMutableDictionary *dic                = [NSMutableDictionary dictionary];
    [dic setValue:@"1.0.0" forKey:@"version"];
    [dic setValue:getUserId() forKey:@"userId"];
    [dic setValue:getUserToken() forKey:@"token"];
    [dic setValue:_model.groupImg forKey:@"groupLogoURL"];
    [dic setValue:_model.groupTitle forKey:@"groupName"];
    [dic setValue:_model.groupDescribe forKey:@"description"];
    [dic setValue:_model.groupOpenTime forKey:@"timingOpenTime"];
    [dic setValue:_model.groupCloseTime forKey:@"timingCloseTime"];
    [dic setValue:@"0" forKey:@"timingOn"];
    [dic setValue:arr forKey:@"deviceList"];
    
    
        if ([LXNetworking sharedLXNetworking].networkStats == StatusNotReachable) {
            [self showRemendWarningView:@"没有网络" withBlock:nil];
    
        }else{
    
    [self showNetWorkView];
    
    
    [LXNetworking postWithUrl:Group_CreateDeviceGroup params:dic success:^(id response) {
        [self hideNetWorkView];
        
        [self showRemendSuccessView:@"创建成功" withBlock:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];

    } fail:^(NSError *error) {
        [self hideNetWorkView];
        
        [self showRemendWarningView:@"创建失败" withBlock:nil];
    } showHUD:nil];
    
        }
}

- (void)layoutUI{
    _tableView = [[UITableView alloc]init];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    //添加头部
    _headerView = [[GroupSetUpVCHeaderView alloc]init];
    _tableView.tableHeaderView = _headerView;
    [_headerView layoutHeaderView];
    CGFloat height2 = [_headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + _headerView.frame.origin.y;
    
    CGRect headerFrame             = _headerView.frame;
    headerFrame.size.height        = height2;
    _headerView.frame          = headerFrame;
    _headerView.iconImg.image = [UIImage imageNamed:@"group_avatar"];
    [self.tableView setTableHeaderView:_headerView];
    
    
    WEAKSELF
    _headerView.changeIconBlock = ^(){
        //更换头像
        [[ImageSelector selector] selectorAvatarAtControlloer:weakSelf afterSelect:^(NSArray *images) {
            [weakSelf.headerView.iconImg setImage:images[0]];
            
            
            NSMutableDictionary *dic                = [NSMutableDictionary dictionary];
            [dic setValue:@"1.0.0" forKey:@"version"];
            [dic setValue:getUserId() forKey:@"userId"];
            [dic setValue:getUserToken() forKey:@"token"];
            [dic setValue:@"" forKey:@"deviceGroupId"];//分组ID，创建分组时传空
            
            
            if ([LXNetworking sharedLXNetworking].networkStats == StatusNotReachable) {
                [weakSelf showRemendWarningView:@"没有网络" withBlock:nil];
                
                //                [SVProgressHUD showErrorWithStatus:@"没有网络"];
                
            }else{
                
                [weakSelf showNetWorkView];
                
                [LXNetworking uploadWithImage:images[0] url:Group_UploadDeviceGroupHeadImg filename:@"Group.png" name:@"headImgFile" params:dic progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
                    
                    
                } success:^(id response) {
                    [weakSelf hideNetWorkView];
                    [weakSelf showRemendSuccessView:@"上传成功" withBlock:nil];
                    
                    weakSelf.model.groupImg = response[@"headImgFileURL"];
                    
                } fail:^(NSError *error) {
                    [weakSelf hideNetWorkView];
                    [weakSelf showRemendWarningView:@"上传失败" withBlock:nil];
                    
                } showHUD:nil];
                
            }
        }];
        
        
    };
    
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)setTableID{
    [self.tableView registerClass:[GroupNameSetUpCell class] forCellReuseIdentifier:NSStringFromClass([GroupNameSetUpCell class])];
      [self.tableView registerClass:[SelectLampCell class] forCellReuseIdentifier:NSStringFromClass([SelectLampCell class])];
}

#pragma - mark UITableViewDelegate and DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        GroupNameSetUpCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GroupNameSetUpCell class]) forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        switch (indexPath.row) {
            case 0:
                cell.title = @"分组名称";
                break;
                
            case 1:
                cell.title = @"分组描述";
                break;
                
            case 2:
                cell.title = @"定时开关";
                break;
                
            default:
                break;
        }
        return cell;
        
    }
    return nil;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 61;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 40;
    }
    return 0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    return nil;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WEAKSELF
    GroupSetUpNameViewController *vc = [[GroupSetUpNameViewController alloc]init];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:{
                vc.titleStr = @"分组名称";
                vc.content = _model.groupTitle;
                vc.changeContentBlock = ^(NSString *str){
                    GroupNameSetUpCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GroupNameSetUpCell class]) forIndexPath:indexPath];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.title = str;
                    weakSelf.model.groupTitle = str;
                };
                
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
                
            case 1:{
                vc.titleStr = @"分组描述";
                vc.content = _model.groupDescribe;
                
                vc.changeContentBlock = ^(NSString *str){
                    GroupNameSetUpCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GroupNameSetUpCell class]) forIndexPath:indexPath];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.title = str;
                    weakSelf.model.groupDescribe = str;
                };
                
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }

                break;
            case 2:
            {
                
                GroupSetUpTimeViewController *vc = [[GroupSetUpTimeViewController alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
                
            default:
                break;
        }
        
    }

}

- (void)initDataArr{
    NSArray *nameArr = @[@"灯泡名称",@"灯泡名称",@"灯泡名称",@"灯泡名称",@"灯泡名称",@"灯泡名称",@"灯泡名称",@"灯泡名称",@"灯泡名称",@"灯泡名称",@"灯泡名称",@"灯泡名称"];
    NSArray *imageArr = @[ @"mine_shetuan",@"mine_huodong",@"mine_haoyou",@"mine_shoucang",@"mine_huodong",@"mine_huodong",@"mine_huodong",@"mine_huodong",@"mine_huodong",@"mine_huodong",@"mine_huodong",@"mine_huodong"];
    
    for (NSInteger i = 0; i < nameArr.count; i++) {
        GroupLampModel *model = [[GroupLampModel alloc]init];
        model.lampName = nameArr[i];
        model.lampImg = imageArr[i];
        [self.allDataArr addObject:model];
    }
}

- (NSMutableArray *)allDataArr{
    if (_allDataArr == nil) {
        _allDataArr = [NSMutableArray array];
    }
    return _allDataArr;
}

@end


