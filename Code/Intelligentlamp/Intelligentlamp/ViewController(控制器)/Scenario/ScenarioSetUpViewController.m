//
//  ScenarioSetUpViewController.m
//  Intelligentlamp
//
//  Created by L on 16/8/25.
//  Copyright © 2016年 L. All rights reserved.
//

#import "ScenarioSetUpViewController.h"
#import "GroupSetUpVCHeaderView.h"
#import "ImageSelector.h"
#import "UIView+Progress.h"
#import "GroupNameSetUpCell.h"
#import "GroupSetUpNameViewController.h"
#import "GroupSetUpTimeViewController.h"
#import "AllSimpleLightSetUpViewController.h"
#import "AllScenarioModel.h"
#import "AllBulbModel.h"
#import "MineListTableviewCell.h"

@interface ScenarioSetUpViewController()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) UITableView *tableView;//列表
@property (nonatomic ,strong) NSMutableArray *allDataArr;//列表数据源
@property (nonatomic ,strong) GroupSetUpVCHeaderView *headerView;//头部

@property (nonatomic ,strong) AllScenarioModel *scenarioModel;
@property (nonatomic ,strong) NSMutableArray *arr;

@end
@implementation ScenarioSetUpViewController

#pragma -mark ViewController 生命周期函数

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (NSMutableArray *)arr{
    if (!_arr) {
        _arr = [NSMutableArray array];
    }
    return _arr;
}

- (void)initDataArr{
    NSArray *nameArr                        = @[@"场景昵称",@"场景描述",@"场景定时",@"删除场景"];
    NSArray *imageArr                       = @[ @"scenes",@"light_bulb_description",@"auto_open_close",@"bin_available"];
    
    for (NSInteger i                        = 0; i < nameArr.count; i++) {
        NSMutableDictionary *dic                = [NSMutableDictionary dictionary];
        [dic setObject:nameArr[i] forKey:@"name"];
        [dic setObject:imageArr[i] forKey:@"image"];
        [self.arr addObject:dic];
    }
}

- (void)viewDidLoad{
    [super viewDidLoad];
    WEAKSELF

    [self networkForScenarioMsg];
    [self initDataArr];

    _scenarioModel                          = [[AllScenarioModel alloc]init];
    _allDataArr                             = [NSMutableArray array];

    [self setTitleViewWithStr:_model.ScenarioTitle];

    [self layoutUI];

    [self setTableID];

    [self leftBarButtonItem:[UIImage imageNamed:@"BackArrow"] withClickBtnAction:^{
        [weakSelf upDateScenario];

    }];
}

//查询场景信息
- (void)networkForScenarioMsg{

    NSMutableDictionary *dic                = [NSMutableDictionary dictionary];
    [dic setValue:@"1.0.0" forKey:@"version"];
    [dic setValue:getUserId() forKey:@"userId"];
    [dic setValue:getUserToken() forKey:@"token"];
    [dic setValue:@"1" forKey:@"pageNo"];
    [dic setValue:@"10" forKey:@"pageSize"];
    [dic setValue:@"" forKey:@"refreshTime"];
    [dic setValue:_model.ScenarioId forKey:@"sceneId"];

    [self showNetWorkView];


    [LXNetworking postWithUrl:Group_GetSceneDeviceList params:dic success:^(id response) {
        [self hideNetWorkView];


    NSArray *arr                            = response[@"deviceList"];
    for (int i                              = 0; i<arr.count; i++) {
    AllBulbModel *model                     = [[AllBulbModel alloc]init];
    model.lampId                            = arr[i][@"deviceId"];
    model.lampImg                           = arr[i][@"deviceLogoURL"];
    model.lampName                          = arr[i][@"deviceName"];
    model.lampMacAddress                    = arr[i][@"macAddress"];
    model.lampPower                         = [arr[i][@"power"] intValue];
    model.lampBrightness                    = [arr[i][@"brightness"] intValue];
    model.lampShow                          = [arr[i][@"ra"] intValue];
    model.lampTonal                         = [arr[i][@"tonal"] intValue];
    model.lampColorTemperature              = [arr[i][@"colorTemperature"] intValue];
    model.lampSaturation                    = [arr[i][@"saturation"] intValue];
    model.lampPoweron                       = [arr[i][@"poweron"] intValue];


                [self.allDataArr addObject:model];
            }

    _model.ScenarioTimingOn                 = [response[@"timingOn"] intValue];
    _model.ScenarioRandomOn                 = [response[@"randomOn"] intValue];
    _model.ScenarioOpenTime                 = response[@"timingOpenTime"];
    _model.ScenarioCreateTime               = response[@"timingCloseTime"];

        [_tableView reloadData];

    } fail:^(NSError *error) {

        [self hideNetWorkView];

    } showHUD:nil];



}

/**
 *  更新场景信息
 */
- (void)upDateScenario{

    NSMutableDictionary *dic                = [NSMutableDictionary dictionary];
    [dic setValue:@"1.0.0" forKey:@"version"];
    [dic setValue:getUserId() forKey:@"userId"];
    [dic setValue:getUserToken() forKey:@"token"];
    [dic setValue:_model.ScenarioImg forKey:@"sceneLogoURL"];
    [dic setValue:_model.ScenarioTitle forKey:@"sceneName"];
    [dic setValue:_model.ScenarioDescribe forKey:@"description"];
    [dic setValue:_model.ScenarioOpenTime forKey:@"timingOpenTime"];
    [dic setValue:_model.ScenarioCloseTime forKey:@"timingCloseTime"];
    [dic setValue:[NSString stringWithFormat:@"%d",_model.ScenarioTimingOn] forKey:@"timingOn"];
    [dic setValue:[NSString stringWithFormat:@"%d",_model.ScenarioRandomOn] forKey:@"randomOn"];
    [dic setValue:_model.ScenarioId forKey:@"sceneId"];


    if ([LXNetworking sharedLXNetworking].networkStats == StatusNotReachable) {
        [self showRemendWarningView:@"没有网络" withBlock:nil];

    }else{

        [self showNetWorkView];


        [LXNetworking postWithUrl:Group_UpdateSceneInfo params:dic success:^(id response) {
            [self hideNetWorkView];

            [self.navigationController popViewControllerAnimated:YES];
        } fail:^(NSError *error) {
            [self hideNetWorkView];

        } showHUD:nil];

    }

}

- (void)layoutUI{
    _tableView                              = [[UITableView alloc]init];
    _tableView.backgroundColor              = [UIColor clearColor];
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    //添加头部
    _headerView                             = [[GroupSetUpVCHeaderView alloc]init];

    _tableView.tableHeaderView              = _headerView;
    [_headerView layoutHeaderView];
    CGFloat height2                         = [_headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + _headerView.frame.origin.y;

    CGRect headerFrame                      = _headerView.frame;
    headerFrame.size.height                 = height2;
    _headerView.frame                       = headerFrame;

    _headerView.iconImg.image               = [UIImage imageNamed:@"scene_avatar"];
    _headerView.icon                        = _model.ScenarioImg;
    [self.tableView setTableHeaderView:_headerView];


    WEAKSELF
    _headerView.changeIconBlock             = ^(){
        
        [[ImageSelector selector] showSelectorAtControlloer:weakSelf type:ImageSelectorTypeCameraAndAlbum allowEditing:NO afterSelect:^(NSArray *images) {
            [weakSelf.headerView.iconImg setImage:images[0]];
            
            NSMutableDictionary *dic                = [NSMutableDictionary dictionary];
            [dic setValue:@"1.0.0" forKey:@"version"];
            [dic setValue:getUserId() forKey:@"userId"];
            [dic setValue:getUserToken() forKey:@"token"];
            [dic setValue:weakSelf.model.ScenarioId forKey:@"sceneId"];//场景ID，创建场景时传空
            
            
            if ([LXNetworking sharedLXNetworking].networkStats == StatusNotReachable) {
                [weakSelf showRemendWarningView:@"没有网络" withBlock:nil];
                
                
            }else{
                
                [weakSelf showNetWorkView];
                
                [LXNetworking uploadWithImage:images[0] url:Group_UploadSceneHeadImg filename:@"Scenario.png" name:@"headImgFile" params:dic progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
                    
                    
                } success:^(id response) {
                    [weakSelf showRemendSuccessView:@"上传成功" withBlock:nil];
                    
                    weakSelf.model.ScenarioImg              = response[@"fileURL"];
                    
                    [weakSelf hideNetWorkView];
                    
                } fail:^(NSError *error) {
                    
                    [weakSelf showRemendWarningView:@"上传失败" withBlock:nil];
                    [weakSelf hideNetWorkView];
                    
                } showHUD:nil];
                
            }
        }];
        //更换头像
//        [[ImageSelector selector] selectorAvatarAtControlloer:weakSelf afterSelect:^(NSArray *images) {
//            [weakSelf.headerView.iconImg setImage:images[0]];
//
//    NSMutableDictionary *dic                = [NSMutableDictionary dictionary];
//            [dic setValue:@"1.0.0" forKey:@"version"];
//            [dic setValue:getUserId() forKey:@"userId"];
//            [dic setValue:getUserToken() forKey:@"token"];
//            [dic setValue:weakSelf.model.ScenarioId forKey:@"sceneId"];//场景ID，创建场景时传空
//
//
//            if ([LXNetworking sharedLXNetworking].networkStats == StatusNotReachable) {
//                [weakSelf showRemendWarningView:@"没有网络" withBlock:nil];
//
//
//            }else{
//
//                [weakSelf showNetWorkView];
//
//                [LXNetworking uploadWithImage:images[0] url:Group_UploadSceneHeadImg filename:@"Scenario.png" name:@"headImgFile" params:dic progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
//
//
//                } success:^(id response) {
//                    [weakSelf showRemendSuccessView:@"上传成功" withBlock:nil];
//
//    weakSelf.model.ScenarioImg              = response[@"fileURL"];
//
//                    [weakSelf hideNetWorkView];
//
//                } fail:^(NSError *error) {
//
//                    [weakSelf showRemendWarningView:@"上传失败" withBlock:nil];
//                    [weakSelf hideNetWorkView];
//
//                } showHUD:nil];
//
//            }
//        }];


    };



    self.tableView.delegate                 = self;
    self.tableView.dataSource               = self;
    self.tableView.separatorStyle           = UITableViewCellSeparatorStyleNone;
}

- (void)setTableID{
//    [self.tableView registerClass:[GroupNameSetUpCell class] forCellReuseIdentifier:NSStringFromClass([GroupNameSetUpCell class])];
          [self.tableView registerClass:[MineListTableviewCell class] forCellReuseIdentifier:NSStringFromClass([MineListTableviewCell class])];
}

#pragma - mark UITableViewDelegate and DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    GroupNameSetUpCell *cell                = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GroupNameSetUpCell class]) forIndexPath:indexPath];
//    cell.selectionStyle                     = UITableViewCellSelectionStyleNone;
//
//    if (indexPath.row == 0) {
//    cell.title                              = _model.ScenarioTitle;
//    }else if (indexPath.row == 1){
//    cell.title                              = _model.ScenarioDescribe;
//    }else if (indexPath.row == 2){
//    cell.title                              = @"定时";
//    }else if (indexPath.row == 3){
//    cell.title                              = @"删除场景";
//    }
//
//    return cell;
    
    MineListTableviewCell *cell             = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MineListTableviewCell class]) forIndexPath:indexPath];
    cell.selectionStyle                     = UITableViewCellSelectionStyleNone;
    cell.indexPath                          = indexPath;
    cell.dataDic                            = self.arr[indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 61;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    WEAKSELF
    GroupSetUpNameViewController *vc        = [[GroupSetUpNameViewController alloc]init];
    if (indexPath.row == 0) {
    vc.titleStr                             = @"场景名称";
    vc.content                              = _model.ScenarioTitle;
    vc.changeContentBlock                   = ^(NSString *str){
//    GroupNameSetUpCell *cell                = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GroupNameSetUpCell class]) forIndexPath:indexPath];
//    cell.selectionStyle                     = UITableViewCellSelectionStyleNone;
//    cell.title                              = str;
    weakSelf.model.ScenarioTitle            = str;
        };

    vc.hidesBottomBarWhenPushed             = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 1){
    vc.titleStr                             = @"场景描述";
    vc.content                              = _model.ScenarioDescribe;
    vc.changeContentBlock                   = ^(NSString *str){
//    GroupNameSetUpCell *cell                = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GroupNameSetUpCell class]) forIndexPath:indexPath];
//    cell.selectionStyle                     = UITableViewCellSelectionStyleNone;
//    cell.title                              = str;
    weakSelf.model.ScenarioDescribe         = str;
        };
    vc.hidesBottomBarWhenPushed             = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 2){

    GroupSetUpTimeViewController *vc        = [[GroupSetUpTimeViewController alloc]init];
    vc.hidesBottomBarWhenPushed             = YES;
    vc.model                                = _model;
    vc.scenarioSetUpBlock                   = ^(AllScenarioModel *allModel){
    _model                                  = allModel;
        };
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 3){

        //初始化提示框；
    UIAlertController *alert                = [UIAlertController alertControllerWithTitle:@"" message:@"确定删除该场景?" preferredStyle:  UIAlertControllerStyleAlert];

    UIAlertAction *cancelAction             = [UIAlertAction actionWithTitle:@"取消"style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancelAction];

        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

            [self deleteScenario];

        }]];

        //弹出提示框；
        [weakSelf presentViewController:alert animated:true completion:nil];

    }

}

/**
 *  删除场景
 */
- (void)deleteScenario{
    NSMutableArray *arr                     = [NSMutableArray array];
    [arr addObject:_model.ScenarioId];
    NSMutableDictionary *dic                = [NSMutableDictionary dictionary];
    [dic setValue:@"1.0.0" forKey:@"version"];
    [dic setValue:getUserId() forKey:@"userId"];
    [dic setValue:getUserToken() forKey:@"token"];
    [dic setValue:arr forKey:@"sceneList"];


    if ([LXNetworking sharedLXNetworking].networkStats == StatusNotReachable) {
        [self showRemendWarningView:@"没有网络" withBlock:nil];

    }else{

        [self showNetWorkView];


        [LXNetworking postWithUrl:Group_DeleteScene params:dic success:^(id response) {
            [self hideNetWorkView];

            [self showRemendSuccessView:@"删除成功" withBlock:^{
                if (self.deleteBlock) {
                    self.deleteBlock();
                }
                [self.navigationController popViewControllerAnimated:YES];
            }];

        } fail:^(NSError *error) {
            [self hideNetWorkView];

            [self showRemendWarningView:@"删除失败" withBlock:nil];
        } showHUD:nil];

    }

}
@end


