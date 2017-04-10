//
//  BulbViewController.m
//  weixin
//
//  Created by L on 16/8/17.
//  Copyright © 2016年 L. All rights reserved.
//

#import "BulbViewController.h"
#import "AllBulbCell.h"
#import "AddBulbCell.h"
#import "AllBulbModel.h"
#import "NoLampHeaderView.h"
#import "ChooseLampSpeciesVC.h"
#import "CommonUtility.h"
#import "LampNodataView.h"
#import "LoginViewController.h"
#import "AllLampSetUpViewController.h"
#import "AddLampFooterView.h"
#import "AllChooseGroupViewController.h"
#import "AllChooseScenarioViewController.h"
#import "AllSimpleLightSetUpViewController.h"


#import <CoreBluetooth/CoreBluetooth.h>
#import <BluetoothFoundation/BluetoothFoundation.h>

static NSString *const PropertyWrite = @"6E400002-B5A3-F393-E0A9-E50E24DCCA9E";
static NSString *const PropertyNotify = @"6E400003-B5A3-F393-E0A9-E50E24DCCA9E";
@interface BulbViewController()<UITableViewDelegate,UITableViewDataSource,CBCentralManagerDelegate,CBPeripheralDelegate>{
    UIButton *btn;
}
@property (nonatomic ,strong) UITableView *tableView;//列表
@property (nonatomic ,strong) NSMutableArray *allDataArr;//列表数据源
@property (nonatomic ,strong) NSMutableArray *allDetailArr;//列表详细数据源

@property (nonatomic ,strong) NoLampHeaderView *noLampView;//没有灯泡时的提示
@property (nonatomic ,strong) AddLampFooterView *footerView;

@property (nonatomic ,strong) NSMutableArray *selectArr;//选中要删除的数据
@property (assign , nonatomic) int pageno; /*第几页*/
@property (nonatomic, copy) NSString *refreshTime;//最后刷新的时间，下拉刷新时要传

@property (nonatomic ,strong) UIView *bgView;//背景view
@property (nonatomic ,strong) UIButton *groupBtn;//添加到分组按钮
@property (nonatomic ,strong) UIButton *scenarioBtn;//添加到场景按钮

@property (nonatomic ,strong) NSTimer *timer;//定时器
@property (nonatomic ,assign) BOOL isEditing;

@property (nonatomic ,strong) UIView *deleteView;
@property (nonatomic ,strong) UIButton *deleteBtn;//删除按钮


@property (nonatomic, assign) CBCentralManager *central;
@property(strong,nonatomic)CBPeripheral *currPeripheral;
@property (nonatomic,strong) LEDFunction *operationModel;
@property (nonatomic, strong) ControlFunction *control;
@property (nonatomic ,strong)AllBulbModel *selectModel;



@property (nonatomic ,assign) BOOL isConnection;//蓝牙是否连接
@property (nonatomic ,assign) BOOL isWrite;//是否写入成功
@property (nonatomic ,assign) BOOL isOn;//是否开启

/** 中心管理者 */
@property (nonatomic, strong) CBCentralManager *cMgr;

/** 连接到的外设 */
@property (nonatomic, strong) CBPeripheral *peripheral;

/** 需要写入的特征 */
@property (nonatomic, strong) CBCharacteristic *currentCharacteristic;

/** 需要读取信息的特证 */
@property (nonatomic, strong) CBCharacteristic *twoCharacteristic;

@property (nonatomic ,strong) NSData *lampData;

@end
@implementation BulbViewController

- (CBCentralManager *)cMgr
{
    if (!_cMgr) {
        _cMgr = [[CBCentralManager alloc] initWithDelegate:self
                                                     queue:dispatch_get_main_queue() options:nil];
    }
    return _cMgr;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    if (_peripheral) {
        // 停止扫描
        [self.cMgr stopScan];
        // 断开连接
        [self.cMgr cancelPeripheralConnection:_peripheral];
    }

    _isEditing                                            = NO;
    _refreshTime                                          = [[NSString alloc]init];
    _pageno                                               = 1;
//    _timer                                                = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(action) userInfo:nil repeats:YES];
//    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];

    [self setTitleViewWithStr:@"所有灯泡"];
    _selectArr                                            = [NSMutableArray array];
    _allDetailArr                                         = [NSMutableArray array];

    [self allDataArr];

    [self layoutUI];

    [self setTableID];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(RefreshView:) name:@"KNotificationChangeLamp" object:nil];
}


- (void)RefreshView:(NSNotification *)nf{
    [_allDataArr removeAllObjects];
    [self networkForMyAllLamp];
}

-(UIView *)deleteView{
    _deleteView                                           = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight - 50, ScreenWidth, 50)];
    _deleteView.backgroundColor                           = AllBgColor;
    _deleteBtn                                            = [UIButton buttonWithType:UIButtonTypeCustom];
    _deleteBtn.frame                                      = CGRectMake((ScreenWidth - 44)/2, 0, 44, 44);
    [_deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_deleteBtn setImage:[UIImage imageNamed:@"bin_available"] forState:UIControlStateNormal];
    [_deleteView addSubview:_deleteBtn];

        [ [ [ UIApplication  sharedApplication ]  keyWindow ] addSubview : _deleteView ] ;
    return _deleteView;
}

#pragma -mark ViewController 生命周期函数

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];


    if (isUserLogin() == NO) {

    LoginViewController *vc                               = [[LoginViewController alloc]init];
    UINavigationController *nv                            = [[UINavigationController alloc] initWithRootViewController:vc];
    vc.hidesBottomBarWhenPushed                           = YES;
        [self presentViewController:nv animated:YES completion:nil];
    }

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

}


- (UIBarButtonItem *)rightBarItem{

    btn                                                   = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame                                             = CGRectMake(0, 0, 40, 30);
    [btn setTitle:@"编辑" forState:UIControlStateNormal];
    btn.titleLabel.font                                   = [UIFont systemFontOfSize:14];
    [btn setTitleColor:AllLampTitleColor forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItem                         = [[UIBarButtonItem alloc]initWithCustomView:btn];
    return rightBarItem;
}
//按钮对应tableView的编辑模式
-(void)btnPressed:(id)sender
{
    UIButton *button                                      = (UIButton *)sender;
    if (_isEditing == YES)
    {
        [self refreshRightBtn];
    }
    else
    {
        for (AllBulbModel *model in _allDataArr) {
    model.isNeedSetUp                                     = NO;

        }
        [_tableView reloadData];
        [self deleteView];
        [button setTitle:@"取消" forState:UIControlStateNormal];
    _isEditing                                            = YES;
    }
}

- (NSMutableArray *)allDataArr{
    if (_allDataArr == nil) {
    _allDataArr                                           = [NSMutableArray array];
    }
    return _allDataArr;
}

- (void)layoutUI{
    WEAKSELF
    _tableView                                            = [[UITableView alloc]init];
    _tableView.backgroundColor                            = [UIColor clearColor];
    _tableView.showsVerticalScrollIndicator               = NO;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-65);
    }];

    //添加_footView
    _footerView                                           = [[AddLampFooterView alloc]init];
    _tableView.tableFooterView                            = _footerView;
    [_footerView layoutFooterView];
    CGFloat height                                        = [_footerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + _footerView.frame.origin.y;

    CGRect footFrame                                      = _footerView.frame;
    footFrame.size.height                                 = height;
    _footerView.frame                                     = footFrame;

     [self.tableView setTableFooterView:_footerView];

    _footerView.addLampBlock                              = ^(){
        [weakSelf refreshRightBtn];
    ChooseLampSpeciesVC *vc                               = [[ChooseLampSpeciesVC alloc]init];
    vc.hidesBottomBarWhenPushed                           = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];

    };

    self.tableView.delegate                               = self;
    self.tableView.dataSource                             = self;
    self.tableView.separatorStyle                         = UITableViewCellSeparatorStyleNone;


    _tableView.mj_footer                                  = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _pageno ++;
        // 进入刷新状态后会自动调用这个block
        [weakSelf networkForMyAllLamp];
    }];


    _tableView.mj_header                                  = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [_allDataArr removeAllObjects];
    weakSelf.pageno                                       = 1;
        [weakSelf networkForMyAllLamp];

    }];
    [_tableView.mj_header beginRefreshing];
}


- (void)networkForMyAllLamp{

    NSMutableDictionary *dic                              = [NSMutableDictionary dictionary];
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

    NSArray *arr                                          = response[@"deviceList"];
    _refreshTime                                          = response[@"refreshTime"];
    for (int i                                            = 0; i<arr.count; i++) {
    AllBulbModel *model                                   = [[AllBulbModel alloc]init];
    model.lampId                                          = arr[i][@"deviceId"];
    model.lampImg                                         = arr[i][@"deviceLogoURL"];
    model.lampName                                        = arr[i][@"deviceName"];
    model.lampBrandId                                     = arr[i][@"brandId"];
    model.lampMacAddress                                  = arr[i][@"macAddress"];
    model.lampDescription                                 = arr[i][@"description"];
    model.lampTimingOpenTime                              = arr[i][@"timingOpenTime"];
    model.lampTimingCloseTime                             = arr[i][@"timingCloseTime"];
    model.redColor =[arr[i][@"redColor"] intValue];
        model.greenColor =[arr[i][@"greenColor"] intValue];
        model.blueColor =[arr[i][@"blueColor"] intValue];
        
    model.lampPower =[arr[i][@"power"] intValue];
    model.lampBrightness =[arr[i][@"brightness"] intValue];
    model.lampTonal =[arr[i][@"tonal"] intValue];
    model.lampColorTemperature =[arr[i][@"colorTemperature"] intValue];
    model.lampSaturation =[arr[i][@"saturation"] intValue];
    model.lampShow =[arr[i][@"ra"] intValue];
    model.lampPoweron =[arr[i][@"powerOn"] intValue];
    model.lampTimingOn =[arr[i][@"timingOn"] intValue];
    model.lamPrandomOn =[arr[i][@"randomOn"] intValue];
    model.lamDelayOn                                      = [arr[i][@"delayOn"] intValue];
    model.lamDelayTime                                    = [arr[i][@"delayTime"] intValue];
    model.isNeedSetUp                                     = YES;

                [self.allDataArr addObject:model];
            }

        }

        if (_allDataArr.count >0) {

    self.navigationItem.rightBarButtonItem                = [self rightBarItem];

            [self bgView];
            [self groupBtn];
            [self scenarioBtn];

        }else{
    self.navigationItem.rightBarButtonItem                = [[UIBarButtonItem alloc]init];
    _tableView.tableFooterView                            = [[UIView alloc]init];
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

    WEAKSELF
    AllBulbCell *cell                                     = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AllBulbCell class]) forIndexPath:indexPath];
    cell.selectionStyle                                   = UITableViewCellSelectionStyleNone;
    cell.indexPath                                        = indexPath ;
    cell.model                                            = _allDataArr[indexPath.row];


    cell.setUpBlock                                       = ^(NSIndexPath *index){
    AllLampSetUpViewController *vc                        = [[AllLampSetUpViewController alloc]init];
    AllBulbModel *model                                   = _allDataArr[indexPath.row];
    vc.lampId                                             = model.lampId;
    vc.needOpen                                           = @"1";
    vc.hidesBottomBarWhenPushed                           = YES;
        [self refreshRightBtn];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };

    cell.deleteBlock                                      = ^(NSIndexPath *index){

    };

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self refreshRightBtn];

    AllSimpleLightSetUpViewController *vc                 = [[AllSimpleLightSetUpViewController alloc]init];
    vc.hidesBottomBarWhenPushed                           = YES;
    AllBulbModel *m                                       = _allDataArr[indexPath.row];
    vc.lampId                                             = m.lampId;
    vc.isSceneId                                          = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 61;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (_allDataArr.count == 0) {
        return ScreenHeight;
    }
    return 0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    _noLampView                                           = [[NoLampHeaderView alloc]init];
    _noLampView.frame                                     = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [_noLampView layoutNoLampHeaderView];

 WEAKSELF
    _noLampView.addLampBlock                              = ^(){
    ChooseLampSpeciesVC *vc                               = [[ChooseLampSpeciesVC alloc]init];
    vc.hidesBottomBarWhenPushed                           = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };

    return _noLampView;
}

#pragma - mark UITableView的编辑方法


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    if (editingStyle == UITableViewCellEditingStyleDelete) {


    AllBulbModel *bulb                                    = _allDataArr[indexPath.row];
    NSMutableArray *arr                                   = [NSMutableArray array];
        [arr addObject:bulb.lampId];
    NSMutableDictionary *dic                              = [NSMutableDictionary dictionary];
        [dic setValue:@"1.0.0" forKey:@"version"];
        [dic setValue:getUserId() forKey:@"userId"];
        [dic setValue:getUserToken() forKey:@"token"];
        [dic setValue:arr forKey:@"deviceList"];

            [self showNetWorkView];


            [LXNetworking postWithUrl:Brand_DeleteDevice params:dic success:^(id response) {
                [self hideNetWorkView];
                [self showRemendSuccessView:@"删除成功" withBlock:nil];

                [_allDataArr removeObjectAtIndex:indexPath.row];
                [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];

            } fail:^(NSError *error) {
                [self hideNetWorkView];
                [self showRemendWarningView:@"删除失败" withBlock:nil];
            } showHUD:nil];

    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (UIView *)bgView{
    if (!_bgView) {
    _bgView                                               = [[UIView alloc]init];
    _bgView.backgroundColor                               = [UIColor colorWithPatternImage:[UIImage imageNamed:@"rukou_bg@"]];
        [self.view addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.tableView.mas_bottom);
            make.left.mas_equalTo(self.tableView.mas_left);
            make.right.mas_equalTo(self.tableView.mas_right);
            make.height.mas_equalTo(65);
        }];
    }
    return _bgView;
}

-(UIButton *)groupBtn{
    if (!_groupBtn) {
    _groupBtn                                             = [UIButton buttonWithType:UIButtonTypeCustom];
        [_groupBtn setTitle:@"添加到分组" forState:UIControlStateNormal];
    _groupBtn.titleLabel.font                             = [UIFont systemFontOfSize:10];
    _groupBtn.imageEdgeInsets                             = UIEdgeInsetsMake(0,35,15,35);
    _groupBtn.titleEdgeInsets                             = UIEdgeInsetsMake(25,-18,0,18);
        [_groupBtn addTarget:self action:@selector(groupBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_groupBtn setImage:[UIImage imageNamed:@"group"] forState:UIControlStateNormal];
        [_bgView addSubview:_groupBtn];
        [_groupBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(65);
            make.left.mas_equalTo(self.view.mas_left).offset(60);
            make.centerY.mas_equalTo(_bgView.mas_centerY);
        }];
    }

    return _groupBtn;
}

- (UIButton *)scenarioBtn{
    if (!_scenarioBtn) {
    _scenarioBtn                                          = [UIButton buttonWithType:UIButtonTypeCustom];
        [_scenarioBtn setTitle:@"添加到场景" forState:UIControlStateNormal];
    _scenarioBtn.titleLabel.font                          = [UIFont systemFontOfSize:10];
    _scenarioBtn.imageEdgeInsets                          = UIEdgeInsetsMake(0,35,15,35);
    _scenarioBtn.titleEdgeInsets                          = UIEdgeInsetsMake(25,-18,0,18);
        [_scenarioBtn addTarget:self action:@selector(scenarioBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_scenarioBtn setImage:[UIImage imageNamed:@"scene"] forState:UIControlStateNormal];
        [_bgView addSubview:_scenarioBtn];
        [_scenarioBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(65);
            make.right.mas_equalTo(self.view.mas_right).offset(-60);
            make.centerY.mas_equalTo(_bgView.mas_centerY);
        }];
    }

    return _scenarioBtn;
}

- (void)groupBtnClick{

    AllChooseGroupViewController *vc                      = [[AllChooseGroupViewController alloc]init];
    for (AllBulbModel *model in _allDataArr) {
        if (model.isSelected == YES) {
            [_selectArr addObject:model];
        }else{

        }

    }

    if (_selectArr.count<=0) {
        [self showRemendWarningView:@"请先选择灯泡" withBlock:nil];
        return;
    }

    vc.dataArr                                            = _selectArr;
    vc.hidesBottomBarWhenPushed                           = YES;
    vc.refreshBlock                                       = ^(){
        [self refreshRightBtn];
    };
    [_deleteView removeFromSuperview];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)scenarioBtnClick{

    AllChooseScenarioViewController *vc                   = [[AllChooseScenarioViewController alloc]init];
    for (AllBulbModel *model in _allDataArr) {
        if (model.isSelected == YES) {
            [_selectArr addObject:model];
        }else{

        }

    }

    if (_selectArr.count<=0) {
        [self showRemendWarningView:@"请先选择灯泡" withBlock:nil];
        return;
    }

    vc.dataArr                                            = _selectArr;
    vc.hidesBottomBarWhenPushed                           = YES;
    vc.refreshBlock                                       = ^(){
        [self refreshRightBtn];
    };
    [_deleteView removeFromSuperview];
    [self.navigationController pushViewController:vc animated:YES];
}

//设置成功之后，更新灯泡定时开关事件
- (void)action{
    NSDate *now                                           = [NSDate date];
    NSDateFormatter *formatter1                           = [[NSDateFormatter alloc] init];
    [formatter1 setDateStyle:NSDateFormatterMediumStyle];
    [formatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr1                                    = [formatter1 stringFromDate:now];
    NSArray *array=[dateStr1 componentsSeparatedByString:@" "];
    NSLog(@"______________________________%@",[array objectAtIndex:1]);


    for (AllBulbModel *bulb in _allDataArr) {
        //灯泡定时开关打开，做一些操作
        if (bulb.lampTimingOn == 1) {
            if ([[array objectAtIndex:1] isEqualToString:bulb.lampTimingOpenTime]) {
                NSLog(@"========到了灯泡%@的开灯时间========%@",bulb.lampId,[array objectAtIndex:1]);
                [self getLampWithLampId:bulb];
            }
        }
    }


}
/**
 *  设置灯泡的定时开关事件
 *
 *  @param bulb 传入有事件的灯泡
 */

- (void)getLampWithLampId:(AllBulbModel *)bulb{
    _selectModel                                          = bulb;
//    [[DataStreamManager sharedManager] stopScan];
//    [[DataStreamManager sharedManager] startScan];
//    [self CenteralStartListening];
    
    //新的蓝牙注册
    [self cMgr];
}

#pragma mark - CBCentralManagerDelegate新的蓝牙代理方法

// 只要中心管理者初始化,就会触发此代理方法
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state) {
        case CBCentralManagerStateUnknown:
            NSLog(@"CBCentralManagerStateUnknown");
            break;
        case CBCentralManagerStateResetting:
            NSLog(@"CBCentralManagerStateResetting");
            break;
        case CBCentralManagerStateUnsupported:
            NSLog(@"CBCentralManagerStateUnsupported");
            break;
        case CBCentralManagerStateUnauthorized:
            NSLog(@"CBCentralManagerStateUnauthorized");
            break;
        case CBCentralManagerStatePoweredOff:
            NSLog(@"CBCentralManagerStatePoweredOff");
            break;
        case CBCentralManagerStatePoweredOn:
        {
            NSLog(@"CBCentralManagerStatePoweredOn");
            // 在中心管理者成功开启后再进行一些操作
            // 搜索外设
            [self.cMgr scanForPeripheralsWithServices:nil // 通过某些服务筛选外设
                                              options:nil]; // dict,条件
            
        }
            break;
            
        default:
            break;
    }
}


// 发现外设后调用的方法
- (void)centralManager:(CBCentralManager *)central // 中心管理者
 didDiscoverPeripheral:(CBPeripheral *)peripheral // 外设
     advertisementData:(NSDictionary *)advertisementData // 外设携带的数据
                  RSSI:(NSNumber *)RSSI // 外设发出的蓝牙信号强度
{
    if ([_selectModel.lampMacAddress isEqualToString:@""] || [_selectModel.lampMacAddress isEqual:[NSNull null]] || [peripheral.name isEqualToString:@""]) {
        return;
    }
    if ([peripheral.name isEqualToString:_selectModel.lampMacAddress]) {
        self.peripheral = peripheral;
        // 发现完之后就是进行连接
        [self.cMgr connectPeripheral:self.peripheral options:nil];
    }
}

// 中心管理者连接外设成功
- (void)centralManager:(CBCentralManager *)central // 中心管理者
  didConnectPeripheral:(CBPeripheral *)peripheral // 外设
{
    _isConnection = YES;
    self.peripheral.delegate = self;
    [self.peripheral discoverServices:nil];
}

// 外设连接失败
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    _isConnection = NO;
}

// 丢失连接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    _isConnection = NO;
}


#pragma mark - 外设代理
// 发现外设的服务后调用的方法
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    // 判断没有失败
    if (error) {
        return;
#warning 下面的方法中凡是有error的在实际开发中,都要进行判断
    }
    for (CBService *service in peripheral.services) {
        // 发现服务后,让设备再发现服务内部的特征们 didDiscoverCharacteristicsForService
        [_peripheral discoverCharacteristics:nil forService:service];
    }
}

// 发现外设服务里的特征的时候调用的代理方法
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    for (CBCharacteristic *cha in service.characteristics) {
        if ([cha.UUID isEqual:[CBUUID UUIDWithString:PropertyWrite]]) {
            
            
            //该特征有写入权限
            _currentCharacteristic = cha;
            [_peripheral readValueForCharacteristic:cha];
            [_peripheral setNotifyValue:YES forCharacteristic:cha];

            
        }else if ([cha.UUID isEqual:[CBUUID UUIDWithString:PropertyNotify]]){
            //该特征有接受通知的权限
            _twoCharacteristic = cha;
            [_peripheral readValueForCharacteristic:cha];
            [_peripheral setNotifyValue:YES forCharacteristic:cha];
        }
    }
}

//中心读取外设实时数据
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    if (error) {
        NSLog(@"Error changing notification state：%@",error.localizedDescription);
    }
    
    if (characteristic.isNotifying) {
        [_peripheral readValueForCharacteristic:characteristic];
    }
}

// 更新特征的value的时候会调用,所有蓝牙发送的数据都在这里接收
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:PropertyWrite]]) {
        
        if (_isConnection == YES) {
            _isConnection = YES;
            
            if (_lampData.length >=10) {
                Byte header[2];
                header[0] = 0x3A;
                header[1] = 0x11;
                //头部标示固定
                NSData *headerData = [NSData dataWithBytes:header length:2];
                //中间部分是灯泡的芯片ID
                NSData *bodyData = [_lampData subdataWithRange:NSMakeRange(0, 8)];
                //尾部是灯泡的亮度
                int i = _selectModel.lampBrightness;
                NSData *data2 = [NSData dataWithBytes: &i length: sizeof(i)]; //da
                
                
                NSMutableData *blueData = [[NSMutableData alloc]init];
                [blueData appendData:headerData];
                [blueData appendData:bodyData];
                [blueData appendData:data2];
                
                [_peripheral writeValue:blueData // 写入的数据
                      forCharacteristic:_currentCharacteristic // 写给哪个特征
                                   type:CBCharacteristicWriteWithResponse];// 通过此响应记录是否成功写入
                
            }else{
                //还没有读取到灯泡的信息，在此读取
                
                //该特征具有写入权限，当该特征的写入值有改变时调用
                Byte reg[11];
                reg[0]=0x3A;
                reg[1]=0x00;
                reg[2]=0x00;
                reg[3]=0x00;
                reg[4]=0x00;
                reg[5]=0x00;
                reg[6]=0x00;
                reg[7]=0x00;
                reg[8]=0x00;
                reg[9]=0x00;
                reg[10]=0xFF;
                
                NSData *data=[NSData dataWithBytes:reg length:11];
                [_peripheral writeValue:data // 写入的数据
                      forCharacteristic:_currentCharacteristic // 写给哪个特征
                                   type:CBCharacteristicWriteWithResponse];// 通过此响应记录是否成功写入
                
            }
        }
        
    }else if([characteristic.UUID isEqual:[CBUUID UUIDWithString:PropertyNotify]]){
        //该特征具有接受通知的权限,当该特征收到蓝牙设备的通知时有回调
        
        if (characteristic.value.length>=10) {
            
            _lampData =  characteristic.value;
            
        }
    }
    //继续监听值改变
    for (CBDescriptor *descriptor in characteristic.descriptors) {
        // 它会触发
        [peripheral readValueForDescriptor:descriptor];
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"=======%@",error.userInfo);

    }else{
        NSLog(@"发送数据成功%@",characteristic.value);
    }
    
    [_peripheral readValueForCharacteristic:characteristic];
}

// 更新特征的描述的值的时候会调用
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error
{
    
    // 这里当描述的值更新的时候,直接调用此方法即可
    [_peripheral readValueForDescriptor:descriptor];
}
// 发现外设的特征的描述数组
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(nonnull CBCharacteristic *)characteristic error:(nullable NSError *)error
{
    
    //打印出Characteristic和他的Descriptors
    NSLog(@"characteristic uuid:%@",characteristic.UUID);
    for (CBDescriptor *d in characteristic.descriptors) {
        NSLog(@"Descriptor uuid:%@",d.UUID);
    }
    
    // 在此处读取描述即可
    for (CBDescriptor *descriptor in characteristic.descriptors) {
        // 它会触发
        [_peripheral readValueForDescriptor:descriptor];
    }
}

- (void)refreshRightBtn{
    [_deleteView removeFromSuperview];
    [btn setTitle:@"编辑" forState:UIControlStateNormal];
    _isEditing                                            = NO;
    for (AllBulbModel *model in _allDataArr) {
    model.isNeedSetUp                                     = YES;
    model.isSelected                                      = NO;

    }
    [_selectArr removeAllObjects];
    [_tableView reloadData];
}

- (void)deleteBtnClick{

    for (AllBulbModel *model in _allDataArr) {
        if (model.isSelected == YES) {
            [_selectArr addObject:model];
        }else{

        }

    }

    if (_selectArr.count<=0) {
        [self showRemendWarningView:@"请先选择灯泡" withBlock:nil];
        return;
    }

    NSMutableArray *arr                                   = [NSMutableArray array];
    for (AllBulbModel * model in _selectArr) {

        [arr addObject:model.lampId];
    }

    NSMutableDictionary *dic                              = [NSMutableDictionary dictionary];
    [dic setValue:@"1.0.0" forKey:@"version"];
    [dic setValue:getUserId() forKey:@"userId"];
    [dic setValue:getUserToken() forKey:@"token"];
    [dic setValue:arr forKey:@"deviceList"];

    [self showNetWorkView];


    [LXNetworking postWithUrl:Brand_DeleteDevice params:dic success:^(id response) {
        [self hideNetWorkView];

        [self showRemendSuccessView:@"删除成功" withBlock:^{
            [_allDataArr removeObjectsInArray:_selectArr];
            [_tableView reloadData];
            
            [self refreshRightBtn];
        }];

    } fail:^(NSError *error) {
        [self hideNetWorkView];
        [self showRemendWarningView:@"删除失败" withBlock:nil];
    } showHUD:nil];
}

//移除通知
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"KNotificationChangeLamp" object:nil];
}
@end

