//
//  AllSimpleLightSetUpViewController.m
//  Intelligentlamp
//
//  Created by L on 16/8/29.
//  Copyright © 2016年 L. All rights reserved.
//

#import "AllSimpleLightSetUpViewController.h"
#import "AllLightSetUpViewController.h"
#import "AllBulbModel.h"
#import "AllNightModeViewController.h"

#import <CoreBluetooth/CoreBluetooth.h>
#import <BluetoothFoundation/BluetoothFoundation.h>

static NSString *const PropertyWrite = @"6E400002-B5A3-F393-E0A9-E50E24DCCA9E";
static NSString *const PropertyNotify = @"6E400003-B5A3-F393-E0A9-E50E24DCCA9E";

@interface AllSimpleLightSetUpViewController()<CBCentralManagerDelegate,CBPeripheralDelegate>{
   
}
@property (nonatomic ,strong) UIScrollView *scrollView;
@property (nonatomic ,strong) UIImageView *lampImg;//灯泡
@property (nonatomic ,strong) UIImageView *coloWheelImg;//色盘
@property (nonatomic ,strong) UISlider *ColorSider;//色温
@property (nonatomic ,strong) UILabel *ColorLab;//色温
@property (nonatomic ,strong) UISlider *lightSider;//亮度
@property (nonatomic ,strong) UILabel *lightLab;//亮度
@property (nonatomic ,strong) UIButton *hightControl;//高级控制

@property (nonatomic ,strong) UIButton *nightMode;//夜间模式
@property (nonatomic ,strong) UIButton *startBtn;//开关按钮

@property (nonatomic ,strong) UIButton *bluetooth;//蓝牙

@property (nonatomic ,strong) UIImageView *selectImg;
@property (nonatomic ,strong) AllBulbModel *model;

/**
 *  蓝牙sdk
 */
@property (nonatomic, assign) CBCentralManager *central;
@property(strong,nonatomic)CBPeripheral *currPeripheral;
@property (nonatomic,strong) LEDFunction *operationModel;
@property (nonatomic, strong) ControlFunction *control;


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

@implementation AllSimpleLightSetUpViewController

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
    

    _model                                     = [[AllBulbModel alloc]init];
    [self setTitleViewWithStr:@"灯光控制"];

    [self leftBarButtonItem:[UIImage imageNamed:@"BackArrow"] withClickBtnAction:^{
        if (_peripheral) {
            // 停止扫描
            [self.cMgr stopScan];
            // 断开连接
            [self.cMgr cancelPeripheralConnection:_peripheral];
        }
        [self upDataLampMsg];

    }];

    _scrollView                                = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.view addSubview:_scrollView];
    // 是否反弹
    _scrollView.bounces                        = NO;
    //是否显示滚动条
    _scrollView.showsHorizontalScrollIndicator = YES;
    _scrollView.contentSize                    = CGSizeMake(ScreenWidth, ScreenHeight * 1.2);
    
    //SDK断开已经连接的外设
//    [[DataStreamManager sharedManager] disconnectPeripheral];
    
    [self layoutUI];

    [self networkForLampMsg];
    
    //SDK开始搜索设备
//    [[DataStreamManager sharedManager] startScan];
    //SDK监听蓝牙设备状态
//    [self CenteralStartListening];
    
    [self bluetooth];
    
    //新的蓝牙注册
    [self cMgr];

}
// 通常断开连接的操作在此处肯定要进行一次
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // 停止扫描
    [self.cMgr stopScan];
    // 断开连接
    [self.cMgr cancelPeripheralConnection:_peripheral];
}

//显示蓝牙状态的按钮
- (UIButton *)bluetooth{
    if (!_bluetooth) {
        _bluetooth                              = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bluetooth setTitle:@"未连接" forState:UIControlStateNormal];
        [_bluetooth setImage:[UIImage imageNamed:@"connecting"] forState:UIControlStateNormal];
        _bluetooth.titleLabel.font              = [UIFont systemFontOfSize:12];
        [_bluetooth setTitleColor:AllLampTitleColor forState:UIControlStateNormal];
        [_scrollView addSubview:_bluetooth];
        [_bluetooth mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_lampImg.mas_top);
            make.height.mas_equalTo(30);
            make.left.mas_equalTo(_scrollView.mas_left).offset(15);
            make.width.mas_equalTo(80);
        }];
    }
    return _bluetooth;
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
                if ([peripheral.name isEqualToString:_model.lampMacAddress]) {
                    _currPeripheral = peripheral;
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
    [_bluetooth setTitle:@"已连接" forState:UIControlStateNormal];
    [_bluetooth setImage:[UIImage imageNamed:@"connected"] forState:UIControlStateNormal];
    _isConnection = YES;
}

#pragma mark == 中心设备与外设连接失败 ==
- (void)CenteralFailConnectPeripher:(NSNotification *)FailNote
{
    NSLog(@"失败-->%@",FailNote.userInfo);
    [_bluetooth setTitle:@"未连接" forState:UIControlStateNormal];
    [_bluetooth setImage:[UIImage imageNamed:@"connecting"] forState:UIControlStateNormal];
    _isConnection = NO;
}

#pragma mark == 中心设备与外设断开连接 ==
- (void)CenteralDisconnetPeripheral:(NSNotification *)disConnectNote
{
    NSLog(@"--->与外设断开连接");
    [_bluetooth setTitle:@"未连接" forState:UIControlStateNormal];
    [_bluetooth setImage:[UIImage imageNamed:@"connecting"] forState:UIControlStateNormal];
    _isConnection = NO;
}

- (void)upDataLampMsg{

    NSMutableDictionary *dic                   = [NSMutableDictionary dictionary];
    [dic setValue:@"1.0.0" forKey:@"version"];
    [dic setValue:getUserId() forKey:@"userId"];
    [dic setValue:getUserToken() forKey:@"token"];
    [dic setValue:_model.lampId forKey:@"deviceId"];
    [dic setValue:_model.lampName forKey:@"deviceName"];
    [dic setValue:_model.lampImg forKey:@"deviceLogoURL"];
    if (_isSceneId == YES) {
        [dic setValue:_sceneId forKey:@"sceneId"];
    }else{
        [dic setValue:@"0" forKey:@"sceneId"];
    }
    [dic setValue:_model.lampDescription forKey:@"description"];
    [dic setValue:_model.lampTimingOpenTime forKey:@"timingOpenTime"];
    [dic setValue:_model.lampTimingCloseTime forKey:@"timingCloseTime"];
    
    [dic setValue:[NSString stringWithFormat:@"%d",_model.blueColor] forKey:@"blueColor"];
    [dic setValue:[NSString stringWithFormat:@"%d",_model.redColor] forKey:@"redColor"];
    [dic setValue:[NSString stringWithFormat:@"%d",_model.greenColor] forKey:@"greenColor"];
    [dic setValue:[NSString stringWithFormat:@"%d",_model.lampPower] forKey:@"power"];
    [dic setValue:[NSString stringWithFormat:@"%d",_model.lampBrightness] forKey:@"brightness"];
    [dic setValue:[NSString stringWithFormat:@"%d",_model.lampTonal] forKey:@"tonal"];
    [dic setValue:[NSString stringWithFormat:@"%d",_model.lampShow] forKey:@"ra"];
    [dic setValue:[NSString stringWithFormat:@"%d",_model.lampColorTemperature] forKey:@"colorTemperature"];
    [dic setValue:[NSString stringWithFormat:@"%d",_model.lampSaturation] forKey:@"saturation"];

    [dic setValue:[NSString stringWithFormat:@"%d",_model.lamDelayOn] forKey:@"delayOn"];
    [dic setValue:[NSString stringWithFormat:@"%d",_model.lamDelayTime] forKey:@"delayTime"];
    [dic setValue:[NSString stringWithFormat:@"%d",_model.lampTimingOn] forKey:@"timingOn"];
    [dic setValue:[NSString stringWithFormat:@"%d",_model.lamPrandomOn] forKey:@"randomOn"];

    [LXNetworking postWithUrl:Brand_UpdateLampInfo params:dic success:^(id response) {
        [self hideNetWorkView];

        [self showRemendSuccessView:@"更新成功" withBlock:^{

            if (_isSceneId == YES) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [self.navigationController popViewControllerAnimated:NO];
            }

        }];

    } fail:^(NSError *error) {

        [self hideNetWorkView];

        [self showRemendWarningView:@"更新失败" withBlock:nil];

    } showHUD:nil];

}

#pragma -mark ViewController 生命周期函数

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


////查询灯泡信息
- (void)networkForLampMsg{

    NSMutableDictionary *dic                   = [NSMutableDictionary dictionary];
    [dic setValue:@"1.0.0" forKey:@"version"];
    [dic setValue:getUserId() forKey:@"userId"];
    [dic setValue:getUserToken() forKey:@"token"];
    [dic setValue:_lampId forKey:@"deviceId"];
    if (_isSceneId == YES) {
        [dic setValue:_sceneId forKey:@"sceneId"];
    }else{
        [dic setValue:@"0" forKey:@"sceneId"];
    }

    [self showNetWorkView];


    [LXNetworking postWithUrl:Brand_GetQueryLampInfo params:dic success:^(id response) {
        
        
        
        [self hideNetWorkView];

    _model.lampId                              = _lampId;
    _model.lampBrandId                         = response[@"brandId"];
    _model.lampImg                             = response[@"deviceLogoURL"];
    _model.lampName                            = response[@"deviceName"];
    _model.lampMacAddress                      = response[@"macAddress"];
    _model.lampDescription                     = response[@"description"];
    _model.lampUserId                          = response[@"userId"];
    _model.lampTimingOpenTime                  = response[@"timingOpenTime"];
    _model.lampTimingCloseTime                 = response[@"timingCloseTime"];
        _model.lampPower =[response[@"power"] intValue];
        _model.blueColor =[response[@"blueColor"] intValue];
        _model.redColor =[response[@"redColor"] intValue];
        _model.greenColor =[response[@"greenColor"] intValue];
        
        _model.lampBrightness =[response[@"brightness"] intValue];
        _model.lampShow =[response[@"ra"] intValue];
        _model.lampTonal =[response[@"tonal"] intValue];
        _model.lampColorTemperature =[response[@"colorTemperature"] intValue];
        _model.lampSaturation =[response[@"saturation"] intValue];
        _model.lampPoweron =[response[@"powerOn"] intValue];

        _model.lampTimingOn =[response[@"timingOn"] intValue];
        _model.lamPrandomOn =[response[@"randomOn"] intValue];
    _model.lamDelayOn                          = [response[@"delayOn"] intValue];
    _model.lamDelayTime                        = [response[@"delayTime"] intValue];

    _ColorSider.value                          = _model.lampColorTemperature;
    _lightSider.value                          = _model.lampBrightness;
        
        //设置灯泡初始的颜色
        UIImage *theImg                            = [UIImage imageNamed:@"Lightbulb_Off"];
        theImg                                     = [theImg imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _lampImg.image                             = theImg;
        _lampImg.tintColor = [UIColor colorWithRed:_model.redColor/255.0 green:_model.greenColor/255.0 blue:_model.blueColor/255.0 alpha:1.0];
        

    } fail:^(NSError *error) {

        [self hideNetWorkView];

    } showHUD:nil];



}

- (void)layoutUI{

    [self lampImg];
    [self coloWheelImg];
    [self ColorLab];
    [self ColorSider];
    [self lightLab];
    [self lightSider];
    [self hightControl];
    [self nightMode];
    [self startBtn];
}

//点击开关
-(void)startBtnClick{
    if (_isOn) {
        _isOn = NO;
        if (_isConnection == YES) {
            [_bluetooth setTitle:@"已连接" forState:UIControlStateNormal];
            [_bluetooth setImage:[UIImage imageNamed:@"connected"] forState:UIControlStateNormal];
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
                int i = 1;
                NSData *data2 = [NSData dataWithBytes: &i length: sizeof(i)]; //da
                
                
                NSMutableData *blueData = [[NSMutableData alloc]init];
                [blueData appendData:headerData];
                [blueData appendData:bodyData];
                [blueData appendData:data2];
                
                [_peripheral writeValue:blueData // 写入的数据
                      forCharacteristic:_currentCharacteristic // 写给哪个特征
                                   type:CBCharacteristicWriteWithResponse];// 通过此响应记录是否成功写入
                
            }
        }else if (_isConnection == NO){
            if (_peripheral) {
                [self showRemendWarningView:@"设备蓝牙未连接，马上将自动连接" withBlock:nil];
                //断开之前的连接
                [self.cMgr cancelPeripheralConnection:_peripheral];
                //重新连接设备
                [self.cMgr connectPeripheral:self.peripheral options:nil];
                
            }else{
                [self showRemendWarningView:@"蓝牙设备未连接" withBlock:nil];
            }
        }

    }else{
        _isOn = YES;
        if (_isConnection == YES) {
            [_bluetooth setTitle:@"已连接" forState:UIControlStateNormal];
            [_bluetooth setImage:[UIImage imageNamed:@"connected"] forState:UIControlStateNormal];
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
                int i = 99;
                NSData *data2 = [NSData dataWithBytes: &i length: sizeof(i)]; //da
                
                
                NSMutableData *blueData = [[NSMutableData alloc]init];
                [blueData appendData:headerData];
                [blueData appendData:bodyData];
                [blueData appendData:data2];
                
                [_peripheral writeValue:blueData // 写入的数据
                      forCharacteristic:_currentCharacteristic // 写给哪个特征
                                   type:CBCharacteristicWriteWithResponse];// 通过此响应记录是否成功写入
                
            }
        }else if (_isConnection == NO){
            if (_peripheral) {
                [self showRemendWarningView:@"设备蓝牙未连接，马上将自动连接" withBlock:nil];
                //断开之前的连接
                [self.cMgr cancelPeripheralConnection:_peripheral];
                //重新连接设备
                [self.cMgr connectPeripheral:self.peripheral options:nil];
                
            }else{
                [self showRemendWarningView:@"蓝牙设备未连接" withBlock:nil];
            }
        }

    }
}

- (void)nightModeBtnClick{
//    if (_peripheral) {
//        // 停止扫描
//        [self.cMgr stopScan];
//        // 断开连接
//        [self.cMgr cancelPeripheralConnection:_peripheral];
//    }
//
//    
//    AllNightModeViewController *vc          = [[AllNightModeViewController alloc]init];
//    vc.lampModel = _model;
//    vc.hidesBottomBarWhenPushed             = YES;
//    [self.navigationController pushViewController:vc animated:YES];
}

- (UIButton *)nightMode{
    if (_nightMode == nil) {
    _nightMode                                 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nightMode setImage:[UIImage imageNamed:@"NightMode_UnClicked"] forState:UIControlStateNormal];
        [_nightMode setImage:[UIImage imageNamed:@"NightMode_Clicked"] forState:UIControlStateHighlighted];
        [_nightMode addTarget:self action:@selector(nightModeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:_nightMode];
        [_nightMode mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_lampImg.mas_top);
            make.width.mas_equalTo(44);
            make.height.mas_equalTo(44);
            make.right.mas_equalTo(self.view.mas_right).offset(-15);
        }];
    }
    return _nightMode;
}
- (UIButton *)hightControl{
    if (!_hightControl) {
    _hightControl                              = [UIButton buttonWithType:UIButtonTypeCustom];
        [_hightControl setBackgroundImage:[UIImage imageNamed:@"还没账号"] forState:UIControlStateNormal];
        [_hightControl setTitle:@"高级控制" forState:UIControlStateNormal];
    _hightControl.titleLabel.font              = [UIFont systemFontOfSize:14];
        [_hightControl setTitleColor:AllLampTitleColor forState:UIControlStateNormal];
        [_hightControl addTarget:self action:@selector(hightControlClick) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:_hightControl];
        [_hightControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_lightSider.mas_bottom).offset(40);
            make.height.mas_equalTo(50);
            make.centerX.mas_equalTo(_scrollView.mas_centerX);
            make.width.mas_equalTo(250);
        }];
    }
    return _hightControl;
}
- (UILabel *)ColorLab{
    if (!_ColorLab) {
    _ColorLab                                  = [[UILabel alloc]init];
        _ColorLab.font =[UIFont systemFontOfSize:13];
    _ColorLab.text                             = @"色温";
    _ColorLab.textColor                        = AllLampTitleColor;
        [_scrollView addSubview:_ColorLab];
        [_ColorLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(30);
            make.top.mas_equalTo(_coloWheelImg.mas_bottom).offset(10);
            make.left.mas_equalTo(_coloWheelImg.mas_left);
        }];
    }
    return _ColorLab;
}

- (UISlider *)ColorSider{
    if (!_ColorSider) {
    _ColorSider                                = [[UISlider alloc]init];
        [_scrollView addSubview:_ColorSider];
    _ColorSider.userInteractionEnabled         = YES;
    _ColorSider.minimumValue                   = 0.0;
    _ColorSider.maximumValue                   = 100.0;
        [_ColorSider setThumbImage:[UIImage imageNamed:@"SliderBTN"] forState:UIControlStateHighlighted];
        [_ColorSider setThumbImage:[UIImage imageNamed:@"SliderBTN"] forState:UIControlStateNormal];
        [_ColorSider setMinimumTrackTintColor:[UIColor whiteColor]];
        [_ColorSider setMaximumTrackTintColor:[UIColor grayColor]];
         [_ColorSider addTarget:self action:@selector(colorsliderValueChanged:) forControlEvents:UIControlEventValueChanged];

        [_ColorSider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(ScreenWidth - 100);
            make.centerX.mas_equalTo(_scrollView.mas_centerX);
            make.top.mas_equalTo(_ColorLab.mas_bottom).offset(10);
            make.height.mas_equalTo(10);
        }];

    }
    return _ColorSider;
}

- (UILabel *)lightLab{
    if (!_lightLab) {
    _lightLab                                  = [[UILabel alloc]init];
        _lightLab.font =[UIFont systemFontOfSize:13];
    _lightLab.text                             = @"亮度";
    _lightLab.textColor                        = AllLampTitleColor;
        [_scrollView addSubview:_lightLab];
        [_lightLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(160);
            make.height.mas_equalTo(30);
            make.top.mas_equalTo(_ColorSider.mas_bottom).offset(10);
            make.left.mas_equalTo(_coloWheelImg.mas_left);
        }];
    }
    return _lightLab;
}


- (UISlider *)lightSider{
    if (!_lightSider) {
    _lightSider                                = [[UISlider alloc]init];
        [_scrollView addSubview:_lightSider];
    _lightSider.userInteractionEnabled         = YES;
    _lightSider.minimumValue                   = 0.0;
    _lightSider.maximumValue                   = 100.0;
        // As the slider moves it will continously call the -valueChanged:
        _lightSider.continuous = YES; // NO makes it call only once you let go
        [_lightSider setThumbImage:[UIImage imageNamed:@"SliderBTN"] forState:UIControlStateHighlighted];
        [_lightSider setThumbImage:[UIImage imageNamed:@"SliderBTN"] forState:UIControlStateNormal];
        [_lightSider setMinimumTrackTintColor:[UIColor whiteColor]];
        [_lightSider setMaximumTrackTintColor:[UIColor grayColor]];
        [_lightSider addTarget:self action:@selector(lightSliderValueChanged:) forControlEvents:UIControlEventValueChanged];

        [_lightSider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(ScreenWidth - 100);
            make.centerX.mas_equalTo(_scrollView.mas_centerX);
            make.top.mas_equalTo(_lightLab.mas_bottom).offset(10);
            make.height.mas_equalTo(10);
        }];

    }
    return _lightSider;
}

- (UIButton *)startBtn{
    
    if (_startBtn == nil) {
        _startBtn                                  = [UIButton buttonWithType:UIButtonTypeCustom];
        [_startBtn setImage:[UIImage imageNamed:@"shutdown-button@3x"] forState:UIControlStateNormal];
        [_startBtn setImage:[UIImage imageNamed:@"shutdown-button@3x"] forState:UIControlStateHighlighted];
        [_startBtn addTarget:self action:@selector(startBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:_startBtn];
        [_startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(90);
            make.height.mas_equalTo(90);
            make.centerX.mas_equalTo(_coloWheelImg.mas_centerX);
            make.centerY.mas_equalTo(_coloWheelImg.mas_centerY);
        }];
    }
    return _startBtn;
}


- (void)hightControlClick{
    AllLightSetUpViewController *vc            = [[AllLightSetUpViewController alloc]init];
    vc.lampColor                               = _lampImg.tintColor;
    vc.bulbModel                               = _model;
    vc.hidesBottomBarWhenPushed                = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//色温改变
- (void)colorsliderValueChanged:(UISlider *)sender{
    _model.lampColorTemperature                = _ColorSider.value;

}
- (BOOL)judgeDivisibleWithFirstNumber:(CGFloat)firstNumber andSecondNumber:(CGFloat)secondNumber
{
    // 默认记录为整除
    BOOL isDivisible = NO;
    
    if (secondNumber == 0) {
        return NO;
    }
    

    
    CGFloat result = firstNumber / secondNumber;
    
    
    // NSString * resultStr = @"10062.0038";
    NSString * resultStr = [NSString stringWithFormat:@"%f", result];
    
    NSRange range = [resultStr rangeOfString:@"."];
    
    NSString * subStr = [resultStr substringFromIndex:range.location + 1];
    

    
    for (NSInteger index = 0; index < subStr.length; index ++) {
        unichar ch = [subStr characterAtIndex:index];
        
        // 后面的字符中只要有一个不为0，就可判定不能整除，跳出循环
        if ('0' != ch) {
           
            isDivisible = NO;
            break;
        }
        
    }
    
    // YBLog(@"可以整除");
    return isDivisible;
}

//亮度改变
- (void)lightSliderValueChanged:(UISlider *)sender{
    
    int i =(int)sender.value;
    if (i%10 == 0) {
        if (i == 0) {
            _model.lampBrightness = 1;
        }else{
            
       _model.lampBrightness                      = sender.value;
        }
    }

    if (_isConnection == YES) {
        [_bluetooth setTitle:@"已连接" forState:UIControlStateNormal];
        [_bluetooth setImage:[UIImage imageNamed:@"connected"] forState:UIControlStateNormal];
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
            int i = _model.lampBrightness;
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
    }else if (_isConnection == NO){
        if (_peripheral) {
            [self showRemendWarningView:@"设备蓝牙未连接，马上将自动连接" withBlock:nil];
            //断开之前的连接
            [self.cMgr cancelPeripheralConnection:_peripheral];
            //重新连接设备
            [self.cMgr connectPeripheral:self.peripheral options:nil];

        }else{
            [self showRemendWarningView:@"蓝牙设备未连接" withBlock:nil];
        }
    }

}


- (UIImageView *)lampImg{
    if (!_lampImg) {
    _lampImg                                   = [[UIImageView alloc]init];
        [_lampImg setImage:[UIImage imageNamed:@"Lightbulb_Off"]];
        [_scrollView addSubview:_lampImg];
        [_lampImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(74);
            make.height.mas_equalTo(74);
            make.top.mas_equalTo(_scrollView.mas_top).offset(15);
            make.centerX.mas_equalTo(_scrollView.mas_centerX);
        }];
    }
    return _lampImg;
}

- (UIImageView *)coloWheelImg{
    if (!_coloWheelImg) {
    _coloWheelImg                              = [[UIImageView alloc]init];
    _coloWheelImg.image                        = [UIImage imageNamed:@"ColorWheel"];
    UILongPressGestureRecognizer *longPressPR  = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
    longPressPR.minimumPressDuration           = 0.05;

        [_coloWheelImg addGestureRecognizer:longPressPR];
    _coloWheelImg.userInteractionEnabled       = YES;

        [_scrollView addSubview:_coloWheelImg];
        [_coloWheelImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(260);
            make.height.mas_equalTo(260);
            make.top.mas_equalTo(_lampImg.mas_bottom).offset(12);
            make.centerX.mas_equalTo(_scrollView.mas_centerX);
        }];
    }
    return _coloWheelImg;
}

- (UIImageView *)clickLocationX:(int)x WithY:(int)y{
    _selectImg                                 = [[UIImageView alloc]init];
    _selectImg.image                           = [UIImage imageNamed:@"Color-Picker"];
    [_coloWheelImg addSubview:_selectImg];
    [_selectImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
        make.centerY.mas_equalTo(_coloWheelImg.mas_top).offset(y);
        make.centerX.mas_equalTo(_coloWheelImg.mas_left).offset(x);
    }];

    return _selectImg;
}

/**
 *  手指点击色盘事件
 */
- (void)longPressAction:(UILongPressGestureRecognizer *)sender{
    if (sender.state == UIGestureRecognizerStateBegan) {

    CGPoint point                              = [sender locationInView:_coloWheelImg];
        [self clickLocationX:point.x WithY:point.y];

        /**
         *  根据手指点击的位置获取颜色
         */
    UIImage *theImg                            = [UIImage imageNamed:@"Lightbulb_Off"];
    theImg                                     = [theImg imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _lampImg.image                             = theImg;
        _lampImg.tintColor =[self getPixelColorAtLocation:point];
        
                if (_isConnection == YES) {
            /**
             *  设置蓝牙颜色属性的修改
             */
            double delayInSeconds = 1.0;
            //创建一个调度时间,相对于默认时钟或修改现有的调度时间。
            dispatch_time_t delayInNanoSeconds =dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            //推迟两纳秒执行
            dispatch_queue_t concurrentQueue =dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_after(delayInNanoSeconds, concurrentQueue, ^(void){
                self.operationModel = [[LEDFunction alloc] init];
                [self.operationModel setLightColorWithRed:_model.redColor green:_model.greenColor blue:_model.blueColor white:_model.lampBrightness];
            });
        }else{
            [self showRemendWarningView:@"设备蓝牙未连接，马上将自动连接" withBlock:nil];
            
            if (_currPeripheral !=nil) {
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
            }else{
                
                [[DataStreamManager sharedManager] stopScan];
                [[DataStreamManager sharedManager] startScan];
            }
  
        }


    }else if (sender.state == UIGestureRecognizerStateEnded){

        [_selectImg removeFromSuperview];

    }
}

/**
 *  根据点击图片的位置，返回点击位置的颜色
 *
 *  @param point 传入手机点击的位置坐标
 *
 *  @return 返回点击位置的颜色
 */
- (UIColor*) getPixelColorAtLocation:(CGPoint)point {
    UIColor* color                             = nil;
    CGImageRef inImage                         = self.coloWheelImg.image.CGImage;
    // Create off screen bitmap context to draw the image into. Format ARGB is 4 bytes for each pixel: Alpa, Red, Green, Blue
    CGContextRef cgctx                         = [self createARGBBitmapContextFromImage:inImage];
    if (cgctx == NULL) { return nil;  }

    size_t w                                   = CGImageGetWidth(inImage);
    size_t h                                   = CGImageGetHeight(inImage);
    CGRect rect                                = {{0,0},{w,h}};

    // Draw the image to the bitmap context. Once we draw, the memory
    // allocated for the context for rendering will then contain the
    // raw image data in the specified color space.
    CGContextDrawImage(cgctx, rect, inImage);

    // Now we can get a pointer to the image data associated with the bitmap
    // context.
    unsigned char* data                        = CGBitmapContextGetData (cgctx);
    if (data != NULL) {
        //offset locates the pixel in the data from x,y.
        //4 for 4 bytes of data per pixel, w is width of one row of data.
        @try {
    int offset                                 = 4*((w*round(point.y))+round(point.x));
            NSLog(@"offset: %d", offset);
    int alpha                                  = data[offset];
    int red                                    = data[offset+1];
    int green                                  = data[offset+2];
    int blue                                   = data[offset+3];
            NSLog(@"offset: %i colors: RGB A %i %i %i  %i",offset,red,green,blue,alpha);
            _model.redColor = red;
            _model.greenColor = green;
            _model.blueColor = blue;
            
    color                                      = [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:(blue/255.0f) alpha:(alpha/255.0f)];
        }
        @catch (NSException * e) {
            NSLog(@"%@",[e reason]);
        }
        @finally {
        }

    }
    // When finished, release the context
    CGContextRelease(cgctx);
    // Free image data memory for the context
    if (data) { free(data); }

    return color;
}

- (CGContextRef) createARGBBitmapContextFromImage:(CGImageRef) inImage {

    CGContextRef    context                    = NULL;
    CGColorSpaceRef colorSpace;
    void *          bitmapData;
    int             bitmapByteCount;
    int             bitmapBytesPerRow;

    // Get image width, height. We'll use the entire image.
    size_t pixelsWide                          = CGImageGetWidth(inImage);
    size_t pixelsHigh                          = CGImageGetHeight(inImage);

    // Declare the number of bytes per row. Each pixel in the bitmap in this
    // example is represented by 4 bytes; 8 bits each of red, green, blue, and
    // alpha.
    bitmapBytesPerRow                          = (pixelsWide * 4);
    bitmapByteCount                            = (bitmapBytesPerRow * pixelsHigh);

    // Use the generic RGB color space.
    colorSpace                                 = CGColorSpaceCreateDeviceRGB();

    if (colorSpace == NULL)
    {
        fprintf(stderr, "Error allocating color space\n");
        return NULL;
    }

    // Allocate memory for image data. This is the destination in memory
    // where any drawing to the bitmap context will be rendered.
    bitmapData                                 = malloc( bitmapByteCount );
    if (bitmapData == NULL)
    {
        fprintf (stderr, "Memory not allocated!");
        CGColorSpaceRelease( colorSpace );
        return NULL;
    }

    // Create the bitmap context. We want pre-multiplied ARGB, 8-bits
    // per component. Regardless of what the source image format is
    // (CMYK, Grayscale, and so on) it will be converted over to the format
    // specified here by CGBitmapContextCreate.
    context                                    = CGBitmapContextCreate (bitmapData,
                                     pixelsWide,
                                     pixelsHigh,
                                     8,      // bits per component
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaPremultipliedFirst);
    if (context == NULL)
    {
        free (bitmapData);
        fprintf (stderr, "Context not created!");
    }
    // Make sure and release colorspace before returning
    CGColorSpaceRelease( colorSpace );

    return context;
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
    if ([_model.lampMacAddress isEqualToString:@""] || [_model.lampMacAddress isEqual:[NSNull null]] || [peripheral.name isEqualToString:@""]) {
        return;
    }
    if ([peripheral.name isEqualToString:_model.lampMacAddress]) {
        self.peripheral = peripheral;
        // 发现完之后就是进行连接
        [self.cMgr connectPeripheral:self.peripheral options:nil];
    }
}

// 中心管理者连接外设成功
- (void)centralManager:(CBCentralManager *)central // 中心管理者
  didConnectPeripheral:(CBPeripheral *)peripheral // 外设
{
    [_bluetooth setTitle:@"已连接" forState:UIControlStateNormal];
    [_bluetooth setImage:[UIImage imageNamed:@"connected"] forState:UIControlStateNormal];
    _isConnection = YES;
    self.peripheral.delegate = self;
    [self.peripheral discoverServices:nil];
}

// 外设连接失败
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    [_bluetooth setTitle:@"未连接" forState:UIControlStateNormal];
    [_bluetooth setImage:[UIImage imageNamed:@"connecting"] forState:UIControlStateNormal];
    _isConnection = NO;
}

// 丢失连接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    [_bluetooth setTitle:@"未连接" forState:UIControlStateNormal];
    [_bluetooth setImage:[UIImage imageNamed:@"connecting"] forState:UIControlStateNormal];
    _isConnection = NO;
}


#pragma mark - 外设代理
// 发现外设的服务后调用的方法
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error) {
        return;
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
//            [_peripheral setNotifyValue:YES forCharacteristic:cha];
            
        }else if ([cha.UUID isEqual:[CBUUID UUIDWithString:PropertyNotify]]){
            //该特征有接受通知的权限
            _twoCharacteristic = cha;
//            [_peripheral readValueForCharacteristic:cha];
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
        
        
        if (_lampData.length>=10) {
            
        }else{
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
        
    }else if([characteristic.UUID isEqual:[CBUUID UUIDWithString:PropertyNotify]]){
        //该特征具有接受通知的权限,当该特征收到蓝牙设备的通知时有回调
        
        if (characteristic.value.length>=10) {
            
            NSData *data1 = [characteristic.value subdataWithRange:NSMakeRange(0, 1)];
            
            Byte reg[1];
            reg[0]=0x53;
            
            NSData *data=[NSData dataWithBytes:reg length:1];
            if ([data1 isEqualToData:data]) {
                
            }else{
                
                _lampData =  characteristic.value;
            }
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





@end
