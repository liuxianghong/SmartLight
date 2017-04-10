//
//  LampSetUpViewController.m
//  Intelligentlamp
//
//  Created by L on 16/9/22.
//  Copyright © 2016年 L. All rights reserved.
//

#import "LampSetUpViewController.h"
#import "MineListTableviewCell.h"
#import "GroupSetUpNameViewController.h"
#import "GroupSetUpTimeViewController.h"
#import "AllGroupViewController.h"
#import "AllScenarioViewController.h"
#import "GroupSetUpVCHeaderView.h"
#import "ImageSelector.h"
#import "UIView+Progress.h"
#import "AllChooseGroupViewController.h"
#import "AllTimeDelayViewController.h"
#import "AllBulbModel.h"

@interface LampSetUpViewController()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) UITableView *tableView;//列表
@property (nonatomic ,strong) NSMutableArray *allDataArr;//列表数据源

@property (nonatomic ,strong) GroupSetUpVCHeaderView *headerView;//头部
@property (nonatomic ,strong) AllBulbModel *model;

@end

@implementation LampSetUpViewController

#pragma -mark ViewController 生命周期函数

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


- (void)viewDidLoad{
    [super viewDidLoad];

    _model                                  = [[AllBulbModel alloc]init];

    [self setTitleViewWithStr:@"灯泡设置"];

    [self initDataArr];

    [self layoutUI];

    [self setTableID];

    [self leftBarButtonItem:[UIImage imageNamed:@"BackArrow"] withClickBtnAction:^{

        [self upDataLampMsg];

    }];

    [self networkForLampMsg];
}

/**
 *  更新灯泡信息
 */
- (void)upDataLampMsg{

    NSMutableDictionary *dic                = [NSMutableDictionary dictionary];
    [dic setValue:@"1.0.0" forKey:@"version"];
    [dic setValue:getUserId() forKey:@"userId"];
    [dic setValue:getUserToken() forKey:@"token"];
    [dic setValue:_model.lampId forKey:@"deviceId"];
    [dic setValue:_model.lampName forKey:@"deviceName"];
    [dic setValue:_model.lampImg forKey:@"deviceLogoURL"];
    [dic setValue:_sceneId forKey:@"sceneId"];
    [dic setValue:_model.lampDescription forKey:@"description"];
    [dic setValue:_model.lampTimingOpenTime forKey:@"timingOpenTime"];
    [dic setValue:_model.lampTimingCloseTime forKey:@"timingCloseTime"];
    [dic setValue:[NSString stringWithFormat:@"%d",_model.lampTimingOn] forKey:@"timingOn"];
    [dic setValue:[NSString stringWithFormat:@"%d",_model.lamDelayTime] forKey:@"delayTime"];
    [dic setValue:[NSString stringWithFormat:@"%d",_model.lamPrandomOn] forKey:@"randomOn"];
    [dic setValue:[NSString stringWithFormat:@"%d",_model.lampPower] forKey:@"power"];
    [dic setValue:[NSString stringWithFormat:@"%d",_model.lampBrightness] forKey:@"brightness"];
    [dic setValue:[NSString stringWithFormat:@"%d",_model.lampShow] forKey:@"ra"];
    [dic setValue:[NSString stringWithFormat:@"%d",_model.lampTonal] forKey:@"tonal"];
    [dic setValue:[NSString stringWithFormat:@"%d",_model.lampColorTemperature] forKey:@"colorTemperature"];
    [dic setValue:[NSString stringWithFormat:@"%d",_model.lampSaturation] forKey:@"saturation"];
    [dic setValue:[NSString stringWithFormat:@"%d",_model.lamDelayOn] forKey:@"delayOn"];

    [LXNetworking postWithUrl:Brand_UpdateLampInfo params:dic success:^(id response) {
        [self hideNetWorkView];

        [self showRemendSuccessView:@"更新成功" withBlock:^{
          [self.navigationController popViewControllerAnimated:YES];

        }];


    } fail:^(NSError *error) {

        [self showRemendWarningView:@"更新失败" withBlock:nil];

        [self hideNetWorkView];

    } showHUD:nil];


}

/**
 *  查询灯泡信息
 */
- (void)networkForLampMsg{

    NSMutableDictionary *dic                = [NSMutableDictionary dictionary];
    [dic setValue:@"1.0.0" forKey:@"version"];
    [dic setValue:getUserId() forKey:@"userId"];
    [dic setValue:getUserToken() forKey:@"token"];
    [dic setValue:_lampId forKey:@"deviceId"];
    [dic setValue:_sceneId forKey:@"sceneId"];


    [self showNetWorkView];


    [LXNetworking postWithUrl:Brand_GetQueryLampInfo params:dic success:^(id response) {
        [self hideNetWorkView];

    _model.lampId                           = _lampId;
    _model.lampBrandId                      = response[@"brandId"];
    _model.lampImg                          = response[@"deviceLogoURL"];
    _model.lampName                         = response[@"deviceName"];
    _model.lampMacAddress                   = response[@"macAddress"];
    _model.lampDescription                  = response[@"description"];
    _model.lampUserId                       = response[@"userId"];
        _model.lampTimingOn =[response[@"timingOn"] intValue];
    _model.lampTimingOpenTime               = response[@"timingOpenTime"];
    _model.lampTimingCloseTime              = response[@"timingCloseTime"];
        _model.lamPrandomOn =[response[@"randomOn"] intValue];
        _model.lampPower =[response[@"power"] intValue];
        _model.lampBrightness =[response[@"brightness"] intValue];
        _model.lampShow =[response[@"ra"] intValue];
        _model.lampTonal =[response[@"tonal"] intValue];
        _model.lampColorTemperature =[response[@"colorTemperature"] intValue];
        _model.lampSaturation =[response[@"saturation"] intValue];
        _model.lampPoweron =[response[@"powerOn"] intValue];
    _model.lamDelayOn                       = [response[@"delayOn"] intValue];
    _model.lamDelayTime                     = [response[@"delayTime"] intValue];

    _headerView.icon                        = _model.lampImg;

    } fail:^(NSError *error) {

        [self hideNetWorkView];

    } showHUD:nil];



}

- (void)initDataArr{
    NSArray *nameArr                        = @[@"灯泡昵称",@"灯泡描述",@"所属分组",@"场景应用",@"延时开关"];
    NSArray *imageArr                       = @[ @"light_bulb_nickname",@"night_mode",@"groups",@"scenes",@"delay"];

    for (NSInteger i                        = 0; i < nameArr.count; i++) {
    NSMutableDictionary *dic                = [NSMutableDictionary dictionary];
        [dic setObject:nameArr[i] forKey:@"name"];
        [dic setObject:imageArr[i] forKey:@"image"];
        [self.allDataArr addObject:dic];
    }
}

- (NSMutableArray *)allDataArr{
    if (_allDataArr == nil) {
    _allDataArr                             = [NSMutableArray array];
    }
    return _allDataArr;
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
    _headerView.iconImg.image               = [UIImage imageNamed:@"light_icon"];
    //    _headerView.icon = _model.groupImg;
    [self.tableView setTableHeaderView:_headerView];


    WEAKSELF
    _headerView.changeIconBlock             = ^(){
        //更换头像
        [[ImageSelector selector] selectorAvatarAtControlloer:weakSelf afterSelect:^(NSArray *images) {
            [weakSelf.headerView.iconImg setImage:images[0]];


    NSMutableDictionary *dic                = [NSMutableDictionary dictionary];
            [dic setValue:@"1.0.0" forKey:@"version"];
            [dic setValue:getUserId() forKey:@"userId"];
            [dic setValue:getUserToken() forKey:@"token"];
            [dic setValue:weakSelf.model.lampId forKey:@"deviceId"];


                [weakSelf showNetWorkView];

                [LXNetworking uploadWithImage:images[0] url:Brand_UploadDeviceHeadImg filename:@"Group.png" name:@"headImgFile" params:dic progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {


                } success:^(id response) {
                    [weakSelf showRemendSuccessView:@"上传成功" withBlock:nil];


    weakSelf.model.lampImg                  = response[@"fileURL"];

                    [weakSelf hideNetWorkView];

                } fail:^(NSError *error) {

                    [weakSelf showRemendWarningView:@"上传失败" withBlock:nil];
                    [weakSelf hideNetWorkView];

                } showHUD:nil];


        }];

    };


    self.tableView.delegate                 = self;
    self.tableView.dataSource               = self;
    self.tableView.separatorStyle           = UITableViewCellSeparatorStyleNone;
}

- (void)setTableID{
    [self.tableView registerClass:[MineListTableviewCell class] forCellReuseIdentifier:NSStringFromClass([MineListTableviewCell class])];
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
    MineListTableviewCell *cell             = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MineListTableviewCell class]) forIndexPath:indexPath];
    cell.selectionStyle                     = UITableViewCellSelectionStyleNone;
    cell.indexPath                          = indexPath;
    cell.dataDic                            = self.allDataArr[indexPath.row];

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 61;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    switch (indexPath.row) {
        case 0:{
    GroupSetUpNameViewController *vc        = [[GroupSetUpNameViewController alloc]init];
    vc.titleStr                             = @"灯泡名称";
    vc.content                              = _model.lampName;
    vc.hidesBottomBarWhenPushed             = YES;
    vc.changeContentBlock                   = ^(NSString *str){
    self.model.lampName                     = str;
            };
            [self.navigationController pushViewController:vc animated:YES];
        }

            break;

        case 1:{

    GroupSetUpNameViewController *vc        = [[GroupSetUpNameViewController alloc]init];
    vc.titleStr                             = @"灯泡描述";
    vc.content                              = _model.lampDescription;
    vc.hidesBottomBarWhenPushed             = YES;
    vc.changeContentBlock                   = ^(NSString *str){
    self.model.lampDescription              = str;
            };
            [self.navigationController pushViewController:vc animated:YES];
        }

            break;

        case 6:{
            //            AllScenarioViewController *vc = [[AllScenarioViewController alloc]init];
            //            vc.hidesBottomBarWhenPushed = YES;
            //            [self.navigationController pushViewController:vc animated:YES];
        }

            break;

        case 2:{
    AllGroupViewController *vc              = [[AllGroupViewController alloc]init];
    vc.hidesBottomBarWhenPushed             = YES;
    vc.lampId                               = _model.lampId;
            [self.navigationController pushViewController:vc animated:YES];
        }

            break;

        case 3:{
    AllScenarioViewController *vc           = [[AllScenarioViewController alloc]init];
    vc.hidesBottomBarWhenPushed             = YES;
    vc.lampId                               = _model.lampId;
            [self.navigationController pushViewController:vc animated:YES];
        }

            break;

        case 4:{

    AllTimeDelayViewController *vc          = [[AllTimeDelayViewController alloc]init];
    vc.model                                = _model;

    vc.lampSetUpDelyBlock                   = ^(AllBulbModel *allModel){
    _model                                  = allModel;
            };
    vc.hidesBottomBarWhenPushed             = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }

            break;

        case 5:{
    AllTimeDelayViewController *vc          = [[AllTimeDelayViewController alloc]init];
    vc.hidesBottomBarWhenPushed             = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }

            break;

        default:
            break;
    }
}
@end

