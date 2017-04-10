//
//  ScenarioViewController.m
//  weixin
//
//  Created by L on 16/8/17.
//  Copyright © 2016年 L. All rights reserved.
//

#import "ScenarioViewController.h"
#import "ScenarioFooterView.h"
#import "AllScenarioModel.h"
#import "AllScenarioCell.h"
#import "AddScenarioViewController.h"
#import "ScenarioLampViewController.h"
#import "ScenarioSetUpViewController.h"
#import "LoginViewController.h"
#import "MJRefresh.h"
#import "NoLampHeaderView.h"


#import "SideCell.h"
#import "WLColView.h"
#import "NewScenarioCell.h"
#import "AllBulbModel.h"
@interface ScenarioViewController()<UITableViewDelegate,UITableViewDataSource,WLColViewDataSource,WLColViewDelegate>{
    WLColView *vi;
}
@property (nonatomic ,strong) UITableView *tableView;//列表
@property (nonatomic ,strong) NSMutableArray *allDataArr;//列表数据源
@property (nonatomic ,strong) ScenarioFooterView *footView;//尾部
@property (nonatomic ,strong) NoLampHeaderView *noLampView;//没有数据时的提示

@property (assign , nonatomic) int pageno; /*第几页*/
@property (nonatomic, copy) NSString *refreshTime;//最后刷新的时间，下拉刷新时要传
@property(nonatomic,strong)UICollectionView *collectionView;

@property (nonatomic ,strong) NSTimer *timer;//定时器

@property (nonatomic ,strong) NSMutableArray *setDataArr;//需要更新状态的所有灯泡数组


@property (nonatomic, assign) CBCentralManager *central;
@property(strong,nonatomic)CBPeripheral *currPeripheral;
@property (nonatomic,strong) LEDFunction *operationModel;
@property (nonatomic, strong) ControlFunction *control;
@property (nonatomic ,strong)AllBulbModel *selectModel;
@end

@implementation ScenarioViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    _setDataArr = [NSMutableArray array];
    self.view.backgroundColor               = AllBgColor;
    _refreshTime                            = [[NSString alloc]init];
    _pageno                                 = 1;

    [self setTitleViewWithStr:@"场景"];

    _timer                                  = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(action) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];

//    [self layoutUI];
//
//    [self setTableID];


    [self networkForAllScenario];

    [self layoutNewUI];

    [self rightBarButtonItemWithTitle:@"添加" withClickBtnAction:^{

    AddScenarioViewController *vc           = [[AddScenarioViewController alloc]init];
    vc.refreshBlock                         = ^(){

            [self.allDataArr removeAllObjects];
            [self networkForAllScenario];
        };
    vc.hidesBottomBarWhenPushed             = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }];
}
#pragma -mark ViewController 生命周期函数

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [LXNetworking startMonitoring];

    if (isUserLogin() == NO) {

    LoginViewController *vc                 = [[LoginViewController alloc]init];
    UINavigationController *nv              = [[UINavigationController alloc] initWithRootViewController:vc];
    vc.hidesBottomBarWhenPushed             = YES;
        [self presentViewController:nv animated:YES completion:nil];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (NSMutableArray *)allDataArr{
    if (_allDataArr == nil) {
    _allDataArr                             = [NSMutableArray array];
    }
    return _allDataArr;
}

- (void)layoutNewUI{
    vi                                      = [[WLColView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 108)];
    [self.view addSubview:vi];

    SideModel *sideModel                    = [[SideModel alloc] init];
    sideModel.cellSize                      = CGSizeMake(CGRectGetWidth(vi.frame) * 0.6, CGRectGetHeight(vi.frame) * 0.6);
    sideModel.between                       = 30;
    sideModel.maxR                          = 0.2;
    sideModel.initOffSetX                   = CGRectGetWidth(vi.frame) / 2 - sideModel.cellSize.width / 2;
    vi.sideModel                            = sideModel;
    vi.dataSource                           = self;
    vi.delegate                             = self;
    [vi.collectionView registerClass:[NewScenarioCell class] forCellWithReuseIdentifier:@"cee"];

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
    _footView                               = [[ScenarioFooterView alloc]init];
    _tableView.tableFooterView              = _footView;
    [_footView layoutFooterView];
    CGFloat height                          = [_footView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + _footView.frame.origin.y;

    CGRect footFrame                        = _footView.frame;
    footFrame.size.height                   = height;
    _footView.frame                         = footFrame;
    [self.tableView setTableFooterView:_footView];

    _footView.addGroupBlock                 = ^(){
    AddScenarioViewController *vc           = [[AddScenarioViewController alloc]init];
    vc.hidesBottomBarWhenPushed             = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];

    };


    self.tableView.delegate                 = self;
    self.tableView.dataSource               = self;
    self.tableView.separatorStyle           = UITableViewCellSeparatorStyleNone;

    _tableView.mj_footer                    = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _pageno ++;
        // 进入刷新状态后会自动调用这个block
        [weakSelf networkForAllScenario];
    }];

    _tableView.mj_header                    = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [_allDataArr removeAllObjects];
    weakSelf.pageno                         = 1;
        [weakSelf networkForAllScenario];

    }];
    [_tableView.mj_header beginRefreshing];
}


- (void)networkForAllScenario{

    NSMutableDictionary *dic                = [NSMutableDictionary dictionary];
    [dic setValue:@"1.0.0" forKey:@"version"];
    [dic setValue:@"0" forKey:@"deviceId"];
    [dic setValue:getUserId() forKey:@"userId"];
    [dic setValue:getUserToken() forKey:@"token"];
    [dic setValue:[NSString stringWithFormat:@"%d",_pageno] forKey:@"pageNo"];//页数
    [dic setValue:@"100" forKey:@"pageSize"];//每页多少数据

    [self showNetWorkView];


    [LXNetworking postWithUrl:Group_GetSceneList params:dic success:^(id response) {
        [self hideNetWorkView];

        if ([response[@"sceneList"] isEqual:[NSNull null]]) {

            [self showRemendWarningView:@"没有更多数据" withBlock:nil];
            [_tableView.mj_footer endRefreshing];
            [_tableView.mj_header endRefreshing];
            return ;
        }

        if (response[@"deviceGroupList"] != nil ||![response[@"deviceGroupList"] isEqual:[NSNull null]]) {

    NSArray *arr                            = response[@"sceneList"];
    _refreshTime                            = response[@"refreshTime"];
    for (int i                              = 0; i<arr.count; i++) {
    AllScenarioModel *model                 = [[AllScenarioModel alloc]init];
    model.ScenarioId                        = arr[i][@"sceneId"];
    model.ScenarioImg                       = arr[i][@"sceneLogoURL"];
    model.ScenarioTitle                     = arr[i][@"sceneName"];
    model.ScenarioDescribe                  = arr[i][@"description"];
    model.ScenarioOpenTime                  = arr[i][@"timingOpenTime"];
    model.ScenarioCloseTime                 = arr[i][@"timingCloseTime"];
    model.ScenarioCreateTime                = arr[i][@"createTime"];

                [self.allDataArr addObject:model];
            }

        }

        [vi reloadView];

    } fail:^(NSError *error) {
        [self hideNetWorkView];

    } showHUD:nil];

}
- (void)setTableID{
    [self.tableView registerClass:[AllScenarioCell class] forCellReuseIdentifier:NSStringFromClass([AllScenarioCell class])];

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
    AllScenarioCell *cell                   = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AllScenarioCell class]) forIndexPath:indexPath];
    cell.selectionStyle                     = UITableViewCellSelectionStyleNone;
    cell.indexPath                          = indexPath ;
    cell.model                              = _allDataArr[indexPath.row];

    cell.setUpBlock                         = ^(NSIndexPath *index){

    ScenarioSetUpViewController *vc         = [[ScenarioSetUpViewController alloc]init];
    vc.model                                = _allDataArr[index.row];
    vc.hidesBottomBarWhenPushed             = YES;
        [self.navigationController pushViewController:vc animated:YES];
    };

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ScenarioLampViewController *vc          = [[ScenarioLampViewController alloc]init];
    vc.hidesBottomBarWhenPushed             = YES;
    AllScenarioModel *model                 = [[AllScenarioModel alloc]init];
    model                                   = _allDataArr[indexPath.row];
    vc.controllerTitle                      = model.ScenarioTitle;
    vc.scenarioId                           = model.ScenarioId;
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
        AddScenarioViewController *vc           = [[AddScenarioViewController alloc]init];
        vc.refreshBlock                         = ^(){
            
            [weakSelf.allDataArr removeAllObjects];
            [weakSelf networkForAllScenario];
        };
        vc.hidesBottomBarWhenPushed             = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    return _noLampView;
}


#pragma mark - colViewDataSource

- (NSInteger)colView:(WLColView *)colView collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return _allDataArr.count;
}

- (SideCell *)colView:(WLColView *)colView collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    NewScenarioCell *cell                   = (NewScenarioCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cee" forIndexPath:indexPath];
    cell.indexPath                          = indexPath ;
    cell.model                              = _allDataArr[indexPath.row];

    cell.setUpBlock                         = ^(NSIndexPath *index){

    ScenarioSetUpViewController *vc         = [[ScenarioSetUpViewController alloc]init];
    vc.deleteBlock                          = ^(){
            [_allDataArr removeObject:_allDataArr[indexPath.row]];
            [vi reloadView];
        };
    vc.model                                = _allDataArr[index.row];
    vc.hidesBottomBarWhenPushed             = YES;
        [self.navigationController pushViewController:vc animated:YES];
    };
    return cell;
}

- (void)colView:(WLColView *)colView collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    ScenarioLampViewController *vc          = [[ScenarioLampViewController alloc]init];
    vc.hidesBottomBarWhenPushed             = YES;
    AllScenarioModel *model                 = [[AllScenarioModel alloc]init];
    model                                   = _allDataArr[indexPath.row];
    vc.controllerTitle                      = model.ScenarioTitle;
    vc.scenarioId                           = model.ScenarioId;
    [self.navigationController pushViewController:vc animated:YES];
}

//设置成功之后，更新灯泡定时开关事件
- (void)action{
    NSDate *now                             = [NSDate date];
    NSDateFormatter *formatter1             = [[NSDateFormatter alloc] init];
    [formatter1 setDateStyle:NSDateFormatterMediumStyle];
    [formatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr1                      = [formatter1 stringFromDate:now];
    NSArray *array=[dateStr1 componentsSeparatedByString:@" "];


    for (AllScenarioModel *scenario in _allDataArr) {
        //灯泡定时开关打开，做一些操作
      NSLog(@"______________________________%@",[array objectAtIndex:1]);
        NSLog(@"==============%@",scenario.ScenarioOpenTime);
        if (scenario.ScenarioTimingOn == 1) {

            if ([[array objectAtIndex:1] isEqualToString:scenario.ScenarioOpenTime]) {
                /**
                 *  做事情

                 */
                NSLog(@"========到了灯泡%@的开灯时间========%@",scenario.ScenarioId,[array objectAtIndex:1]);
                [self getScenarioLampArrWithId:scenario.ScenarioId];
            }

        }
    }


}

- (void)getScenarioLampArrWithId:(NSString *)scenarioId{
    NSMutableDictionary *dic                = [NSMutableDictionary dictionary];
    [dic setValue:@"1.0.0" forKey:@"version"];
    [dic setValue:getUserId() forKey:@"userId"];
    [dic setValue:getUserToken() forKey:@"token"];
    [dic setValue:@"1" forKey:@"pageNo"];
    [dic setValue:@"100" forKey:@"pageSize"];
    [dic setValue:@"" forKey:@"refreshTime"];
    [dic setValue:scenarioId forKey:@"sceneId"];

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
        
        [_setDataArr addObject:model];
        }
        if (_setDataArr.count == 0) {
            return ;
        }else if(_setDataArr.count >0){
             [self getLampWithLampId:_setDataArr[0]];
        }else{
            return;
        }
        
    } fail:^(NSError *error) {

        [self hideNetWorkView];

    } showHUD:nil];


}


/**
 *  设置灯泡的定时开关事件
 *
 *  @param bulb 传入有事件的灯泡
 */

- (void)getLampWithLampId:(AllBulbModel *)bulb{
    _selectModel                                          = bulb;
    [[DataStreamManager sharedManager] stopScan];
    [[DataStreamManager sharedManager] startScan];
    [self CenteralStartListening];
}

#pragma mark - 开启监听通知
- (void)CenteralStartListening
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CenteralUpdateState:) name:BLECentralStateUpdateNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CenteralScanedPeripheral:) name:BLEScanedPeripheralNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CenteralSuccessConnnectPeripher:) name:BLEPeripheralConnectSuccedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CenteralFailConnectPeripher:) name:BLEConnectFailNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CenteralDisconnetPeripheral:) name:BLEPeripheralDisconnectNotification object:nil];
    
}

#pragma mark - 收到通知后回调方法

#pragma mark == 中心设备状态改变 ==
- (void)CenteralUpdateState:(NSNotification *)StateNote
{
    CBCentralManager *manager = StateNote.userInfo[@"centralManager"];
    _central = manager;
    switch (manager.state) {
        case CBCentralManagerStateUnknown:
            NSLog(@"%@",[NSString stringWithFormat:@"CBCentralManagerStateUnknown-->设备蓝牙状态未知"]);
            [self showRemendWarningView:@"设备蓝牙状态未知" withBlock:nil];
            break;
        case CBCentralManagerStateResetting:
            NSLog(@"%@",[NSString stringWithFormat:@"CBCentralManagerStateResetting-->设备蓝牙正在重置"]);
            [self showRemendWarningView:@"设备蓝牙正在重置" withBlock:nil];
            break;
        case CBCentralManagerStateUnsupported:
            NSLog(@"%@",[NSString stringWithFormat:@"CBCentralManagerStateUnsupported-->设备蓝牙不支持"]);
            [self showRemendWarningView:@"设备蓝牙不支持" withBlock:nil];
            break;
        case CBCentralManagerStateUnauthorized:
            NSLog(@"%@",[NSString stringWithFormat:@"CBCentralManagerStateUnauthorized-->设备蓝牙未授权"]);
            [self showRemendWarningView:@"设备蓝牙未授权" withBlock:nil];
            break;
        case CBCentralManagerStatePoweredOff:
            NSLog(@"%@",[NSString stringWithFormat:@"CBCentralManagerStatePoweredOff-->设备蓝牙关闭"]);
            [self showRemendWarningView:@"设备蓝牙关闭" withBlock:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:BLEPeripheralDisconnectNotification object:nil];
            break;
        case CBCentralManagerStatePoweredOn:
            NSLog(@"%@",[NSString stringWithFormat:@"CBCentralManagerStatePoweredOn-->设备蓝牙开启"]);
            [self showRemendSuccessView:@"设备蓝牙开启" withBlock:nil];
            
            break;
            
        default:
            break;
    }
}


#pragma mark == 中心设备扫描到外设 ==
- (void)CenteralScanedPeripheral:(NSNotification *)PeripheralNote
{
    //遍历单例中保存的外设
    for (CBPeripheral *peripheral in [DataStreamManager sharedManager].searchedPeripheralArr) {
        if ([peripheral.name isEqualToString:_selectModel.lampMacAddress]) {
            _currPeripheral                                       = peripheral;
            
            /**
             *  断开之前的连接
             */
            [[DataStreamManager sharedManager] disconnectPeripheral];
            /**
             *  保存连接的设备
             */
            [DataStreamManager sharedManager].connectedPeripheral = _currPeripheral;
            /**
             *  开始连接
             */
            [[DataStreamManager sharedManager] connectPeripheral:_currPeripheral];
        }
        
    }
    
}
#pragma mark == 中心设备成功连接外设 ==
- (void)CenteralSuccessConnnectPeripher:(NSNotification *)SuccessNote
{
    NSLog(@"-->与外设连接成功");
    [self showRemendSuccessView:@"与灯泡连接成功" withBlock:nil];
    
    double delayInSeconds                                 = 1.0;
    //创建一个调度时间,相对于默认时钟或修改现有的调度时间。
    dispatch_time_t delayInNanoSeconds                    = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    //推迟1纳秒执行
    dispatch_queue_t concurrentQueue                      = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_after(delayInNanoSeconds, concurrentQueue, ^(void){
        self.operationModel                                   = [[LEDFunction alloc] init];
        [self.operationModel setLightColorWithRed:_selectModel.redColor green:_selectModel.redColor blue:_selectModel.blueColor white:0];
        
        [_setDataArr removeObjectAtIndex:0];
        
        if (_setDataArr.count == 0) {
            //这个场景的灯泡已经设置完成，停止搜索蓝牙
        [[DataStreamManager sharedManager] stopScan];
            //断开之前的连接
        [[DataStreamManager sharedManager] disconnectPeripheral];
            
        }else if (_setDataArr.count>0){
            //这个场景的的灯泡还没有设置完成，继续搜索最新的灯泡
            [self getLampWithLampId:_setDataArr[0]];
        }
        
    });
}

#pragma mark == 中心设备与外设连接失败 ==
- (void)CenteralFailConnectPeripher:(NSNotification *)FailNote
{
    NSLog(@"失败-->%@",FailNote.userInfo);
    [self showRemendWarningView:@"与灯泡连接失败" withBlock:nil];
}

#pragma mark == 中心设备与外设断开连接 ==
- (void)CenteralDisconnetPeripheral:(NSNotification *)disConnectNote
{
    NSLog(@"--->与外设断开连接");
    [self showRemendWarningView:@"与灯泡断开连接" withBlock:nil];
}


@end



