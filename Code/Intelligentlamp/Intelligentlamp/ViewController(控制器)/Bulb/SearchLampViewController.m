//
//  SearchLampViewController.m
//  Intelligentlamp
//
//  Created by L on 16/8/25.
//  Copyright © 2016年 L. All rights reserved.
//

#import "SearchLampViewController.h"
#import "GroupLampViewController.h"
#import "AllBulbModel.h"
#import "AllBulbCell.h"
#import "SearchLampFooter.h"
#import "AllLampSetUpViewController.h"
#import "MJRefresh.h"
#import "AllChooseGroupViewController.h"
#import "AllChooseScenarioViewController.h"
#import "XHRadarView.h"

@interface SearchLampViewController(){
    
    BabyBluetooth *baby;
}

@property (nonatomic ,strong) UITableView *tableView;//列表
@property (nonatomic ,strong) NSMutableArray *allDataArr;//列表数据源
@property (nonatomic ,strong) NSMutableArray *selectArr;//选中要删除的数据

@property (nonatomic ,strong) UIView *bgView;//背景view
@property (nonatomic ,strong) UIButton *scenarioBtn;//添加到我的设备列表按钮


@property (nonatomic, assign) CBCentralManager *central;
@property(strong,nonatomic)CBPeripheral *currPeripheral;
@property (nonatomic,strong) LEDFunction *operationModel;
@property (nonatomic, strong) ControlFunction *control;
@property (nonatomic, strong) NSMutableArray <CBPeripheral *> *DataArr;//用来保存所有搜索到的设备

@property (nonatomic, strong) XHRadarView *radarView;//雷达搜索View


@end
@implementation SearchLampViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    _selectArr = [NSMutableArray array];
    [self leftBarButtonItem:[UIImage imageNamed:@"BackArrow"] withClickBtnAction:^{
        //停止扫描
        [baby cancelScan];
        [_allDataArr removeAllObjects];
        [_DataArr removeAllObjects];
        [_tableView reloadData];
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self setTitleViewWithStr:@"搜索蓝牙设备"];
    
    [self layoutUI];
    
    [self setTableID];
    
    [self rightBarButtonItem:[UIImage imageNamed:@"刷新新设备"] withClickBtnAction:^{
        
        //停止扫描
        [baby cancelScan];
        [_allDataArr removeAllObjects];
        [_DataArr removeAllObjects];
        [_tableView reloadData];
        
        [self resetBluetoothState];
        
    }];
    
    [self bgView];
    [self scenarioBtn];
    
    //初始化BabyBluetooth 蓝牙库
    baby = [BabyBluetooth shareBabyBluetooth];
    //设置蓝牙委托
    [self babyDelegate];
    
    [self resetBluetoothState];
    
    
}

- (void)resetBluetoothState{
    
    double delayInSeconds                                 = 5.0;
    //创建一个调度时间,相对于默认时钟或修改现有的调度时间。
    dispatch_time_t delayInNanoSeconds                    = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    //推迟1纳秒执行
    dispatch_queue_t concurrentQueue                      = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_after(delayInNanoSeconds, concurrentQueue, ^(void){
        //停止之前的连接
        [baby cancelAllPeripheralsConnection];
        //设置委托后直接可以使用，无需等待CBCentralManagerStatePoweredOn状态。
        baby.scanForPeripherals().begin(10);
    });
    
}
#pragma mark -蓝牙配置和操作

//蓝牙网关初始化和委托方法设置
-(void)babyDelegate{
    WEAKSELF
    [baby setBlockOnCentralManagerDidUpdateState:^(CBCentralManager *central) {
        if (central.state == CBCentralManagerStatePoweredOn) {
            [weakSelf showRemendSuccessView:@"设备打开成功，开始扫描设备" withBlock:nil];
        }
    }];
    
    //设置扫描到设备的委托
    [baby setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        [weakSelf insertTableView:peripheral advertisementData:advertisementData];
        
    }];
    
    [baby setBlockOnConnected:^(CBCentralManager *central, CBPeripheral *peripheral) {
        NSLog(@"设备：%@--连接成功",peripheral.name);
    }];
    //设置发现设备的Services的委托
    [baby setBlockOnDiscoverServices:^(CBPeripheral *peripheral, NSError *error) {
        for (CBService *service in peripheral.services) {
            NSLog(@"搜索到服务:%@",service.UUID.UUIDString);
        }
    }];
    //设置发现设service的Characteristics的委托
    [baby setBlockOnDiscoverCharacteristics:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        NSLog(@"===service name:%@",service.UUID);
        for (CBCharacteristic *c in service.characteristics) {
            NSLog(@"charateristic name is :%@",c.UUID);
        }
    }];
    //设置读取characteristics的委托
    [baby setBlockOnReadValueForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
        NSLog(@"characteristic name:%@ value is:%@",characteristics.UUID,characteristics.value);
    }];
    //设置发现characteristics的descriptors的委托
    [baby setBlockOnDiscoverDescriptorsForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"===characteristic name:%@",characteristic.service.UUID);
        for (CBDescriptor *d in characteristic.descriptors) {
            NSLog(@"CBDescriptor name is :%@",d.UUID);
        }
    }];
    //设置读取Descriptor的委托
    [baby setBlockOnReadValueForDescriptors:^(CBPeripheral *peripheral, CBDescriptor *descriptor, NSError *error) {
        NSLog(@"Descriptor name:%@ value is:%@",descriptor.characteristic.UUID, descriptor.value);
    }];
    
    
    //设置查找设备的过滤器
    [baby setFilterOnDiscoverPeripherals:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {
        
        if (peripheralName.length >0) {
            return YES;
        }
        return NO;
    }];
    
    
    [baby setBlockOnCancelAllPeripheralsConnectionBlock:^(CBCentralManager *centralManager) {
        NSLog(@"setBlockOnCancelAllPeripheralsConnectionBlock");
    }];
    
    [baby setBlockOnCancelScanBlock:^(CBCentralManager *centralManager) {
        NSLog(@"setBlockOnCancelScanBlock");
    }];
    
    //示例:
    //扫描选项->CBCentralManagerScanOptionAllowDuplicatesKey:忽略同一个Peripheral端的多个发现事件被聚合成一个发现事件
    NSDictionary *scanForPeripheralsWithOptions = @{CBCentralManagerScanOptionAllowDuplicatesKey:@YES};
    //连接设备->
    [baby setBabyOptionsWithScanForPeripheralsWithOptions:scanForPeripheralsWithOptions connectPeripheralWithOptions:nil scanForPeripheralsWithServices:nil discoverWithServices:nil discoverWithCharacteristics:nil];
    
    
    
}
#pragma mark -UIViewController 方法
//插入table数据
-(void)insertTableView:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData{
    if (![self.DataArr containsObject:peripheral]) {
        [self.DataArr addObject:peripheral];
        for (int i =0; i<self.DataArr.count; i++) {
            AllBulbModel *model = [[AllBulbModel alloc]init];
            model.lampName = self.DataArr[i].name;
            model.lampImg = @"Light-Bulb@2x";
            model.isSelected = NO;
            [self.allDataArr addObject:model];
        }
        [_tableView reloadData];
    }
}

- (NSMutableArray *)DataArr
{
    if (!_DataArr) {
        _DataArr = [@[] mutableCopy];
    }
    return _DataArr;
}

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


- (NSMutableArray *)allDataArr{
    if (_allDataArr == nil) {
        _allDataArr = [NSMutableArray array];
    }
    return _allDataArr;
}

- (void)layoutUI{
    
    _tableView = [[UITableView alloc]init];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-65);
    }];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)setTableID{
    [self.tableView registerClass:[AllBulbCell class] forCellReuseIdentifier:NSStringFromClass([AllBulbCell class])];
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (_allDataArr.count == 0) {
        return ScreenHeight;
    }
    return 0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    
    view.frame                                     = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 65);
    XHRadarView *radarView = [[XHRadarView alloc] initWithFrame:view.bounds];
    radarView.frame = view.frame;
    radarView.radius = 100;
    radarView.backgroundColor = [UIColor colorWithRed:0.251 green:0.329 blue:0.490 alpha:1];
    radarView.backgroundImage = [UIImage imageNamed:@"radar_background"];
    radarView.labelText = @"";
    [view addSubview:radarView];
    _radarView = radarView;
    
    [_radarView scan];
    
    return view;
}

#pragma - mark UITableView的编辑方法

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath

{
    return NO;
}

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"rukou_bg@"]];
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

- (UIButton *)scenarioBtn{
    if (!_scenarioBtn) {
        _scenarioBtn           = [UIButton buttonWithType:UIButtonTypeCustom];
        [_scenarioBtn setTitle:@"添加到设备列表" forState:UIControlStateNormal];
        _scenarioBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        _scenarioBtn.imageEdgeInsets = UIEdgeInsetsMake(0,35,15,35);
        _scenarioBtn.titleEdgeInsets = UIEdgeInsetsMake(25,-18,0,18);
        [_scenarioBtn addTarget:self action:@selector(scenarioBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_scenarioBtn setImage:[UIImage imageNamed:@"scene"] forState:UIControlStateNormal];
        [_bgView addSubview:_scenarioBtn];
        [_scenarioBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(120);
            make.height.mas_equalTo(65);
            make.centerX.mas_equalTo(_bgView.mas_centerX);
            make.centerY.mas_equalTo(_bgView.mas_centerY);
        }];
    }
    
    return _scenarioBtn;
}

- (void)scenarioBtnClick{
    
    for (AllBulbModel *model in _allDataArr) {
        if (model.isSelected == YES) {
            [_selectArr addObject:model];
        }
    }
    
    if (_selectArr.count<=0) {
        [self showRemendWarningView:@"请先选择灯泡" withBlock:nil];
        return;
    }
    
    
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i< _selectArr.count; i++) {
        AllBulbModel *model = _selectArr[i];
        NSMutableDictionary * dic2 = [[NSMutableDictionary alloc]init];
        [dic2 setValue:model.lampName forKey:@"deviceName"];
        [dic2 setValue:@"" forKey:@"deviceLogoURL"];
        [dic2 setValue:model.lampName forKey:@"macAddress"];
        [dic2 setValue:_brandId forKey:@"brandId"];
        [dic2 setValue:@"描述" forKey:@"description"];
        [arr addObject:dic2];
    }
    
    NSMutableDictionary *dic                = [NSMutableDictionary dictionary];
    [dic setValue:@"1.0.0" forKey:@"version"];
    [dic setValue:getUserId() forKey:@"userId"];
    [dic setValue:getUserToken() forKey:@"token"];
    [dic setValue:arr forKey:@"deviceList"];
    
    [self showNetWorkView];
    
    
    [LXNetworking postWithUrl:Brand_AddSmartDevice params:dic success:^(id response) {
        [self hideNetWorkView];
        
        [self showRemendSuccessView:@"添加成功" withBlock:^{
            
            [self resetAllData];
            
    NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
    [notification postNotificationName:@"KNotificationChangeLamp" object:self userInfo:nil];
        }];
        
    } fail:^(NSError *error) {
        [self hideNetWorkView];
        
        [self showRemendWarningView:@"添加失败" withBlock:^{
            [self resetAllData];
        }];
        
    } showHUD:nil];
    
}

- (void)resetAllData{
    for (AllBulbModel *model in _allDataArr) {
        model.isSelected                        = NO;
        
    }
    [_selectArr removeAllObjects];
    [_tableView reloadData];
}

@end
