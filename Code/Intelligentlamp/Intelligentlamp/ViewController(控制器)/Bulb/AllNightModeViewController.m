//
//  AllNightModeViewController.m
//  Intelligentlamp
//
//  Created by L on 16/9/23.
//  Copyright © 2016年 L. All rights reserved.
//

static int kItemW                                     = -25;
#define ContentTitleColor HEXCOLOR(0x666666)
#import "AllNightModeViewController.h"
#import "AllNightModeDetailViewController.h"
#import "AllBulbModel.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import <BluetoothFoundation/BluetoothFoundation.h>

static NSString *const PropertyWrite = @"6E400002-B5A3-F393-E0A9-E50E24DCCA9E";
static NSString *const PropertyNotify = @"6E400003-B5A3-F393-E0A9-E50E24DCCA9E";
@interface AllNightModeViewController()<CBCentralManagerDelegate,CBPeripheralDelegate>

@property (nonatomic ,strong) UIImageView *lightImg;//灯泡
@property (nonatomic ,strong) UILabel *contentLab;//提示文字
@property (nonatomic ,strong) UIButton *controlBtn;//控制按钮

@property (nonatomic ,strong) AllBulbModel *model;

@property (nonatomic ,assign) int i;

/** 中心管理者 */
@property (nonatomic, strong) CBCentralManager *cMgr;

/** 连接到的外设 */
@property (nonatomic, strong) CBPeripheral *peripheral;

/** 需要写入的特征 */
@property (nonatomic, strong) CBCharacteristic *currentCharacteristic;

/** 需要读取信息的特证 */
@property (nonatomic, strong) CBCharacteristic *twoCharacteristic;

@property (nonatomic ,assign) BOOL isConnection;//蓝牙是否连接

@property (nonatomic ,strong) NSData *lampData;

@end

@implementation AllNightModeViewController

#pragma -mark ViewController 生命周期函数

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

}

- (CBCentralManager *)cMgr
{
    if (!_cMgr) {
        _cMgr = [[CBCentralManager alloc] initWithDelegate:self
                                                     queue:dispatch_get_main_queue() options:nil];
    }
    return _cMgr;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (_peripheral) {
        // 停止扫描
        [self.cMgr stopScan];
        // 断开连接
        [self.cMgr cancelPeripheralConnection:_peripheral];
    }
    

_i                                                    = 0;
//    _model                                     = [[AllBulbModel alloc]init];
    [self setTitleViewWithStr:@"夜间模式"];
    [self leftBarButtonItem:[UIImage imageNamed:@"BackArrow"] withClickBtnAction:^{
        
        if (_peripheral) {
            // 停止扫描
            [self.cMgr stopScan];
            // 断开连接
            [self.cMgr cancelPeripheralConnection:_peripheral];
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    [self layoutUI];
//    [self networkForLampMsg];

    // 调用get方法,先将中心管理者初始化
    [self cMgr];
    
}

////查询灯泡信息
- (void)networkForLampMsg{
    
    NSMutableDictionary *dic                   = [NSMutableDictionary dictionary];
    [dic setValue:@"1.0.0" forKey:@"version"];
    [dic setValue:getUserId() forKey:@"userId"];
    [dic setValue:getUserToken() forKey:@"token"];
    [dic setValue:_lampModel.lampId forKey:@"deviceId"];
    [dic setValue:@"1" forKey:@"sceneId"];

    
    [self showNetWorkView];
    
    
    [LXNetworking postWithUrl:Brand_GetQueryLampInfo params:dic success:^(id response) {
        
        
        
        [self hideNetWorkView];
        
        _model.lampId                              = _lampModel.lampId;
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
        
    } fail:^(NSError *error) {
        
        [self hideNetWorkView];
        
    } showHUD:nil];
    
    
    
}

- (void)layoutUI{

    [self lightImg];
    [self contentLab];
    [self controlBtn];
}

- (UIImageView *)lightImg{
    if (!_lightImg) {
_lightImg                                             = [[UIImageView alloc]init];

_lightImg.userInteractionEnabled                      = YES;
UITapGestureRecognizer*tapGesture                     = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Actiondo)];
        [_lightImg addGestureRecognizer:tapGesture];

        [self.view addSubview:_lightImg];
_lightImg.image                                       = [UIImage imageNamed:@"light_bulb_night_ver"];
        [_lightImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(190);
            make.height.mas_equalTo(280);
            make.top.mas_equalTo(10);
            make.centerX.mas_equalTo(self.view.mas_centerX);
        }];

    }
    return _lightImg;
}

- (UILabel *)contentLab{
    if (!_contentLab) {
_contentLab                                           = [[UILabel alloc]init];
_contentLab.textColor                                 = ContentTitleColor;
_contentLab.font                                      = [UIFont systemFontOfSize:12];
_contentLab.textAlignment                             = NSTextAlignmentCenter;
_contentLab.text                                      = @"点击灯泡可以切换灯光亮度";
        [self.view addSubview:_contentLab];
        [_contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.view.mas_width);
            make.top.mas_equalTo(_lightImg.mas_bottom).offset(10);
            make.height.mas_equalTo(35);
            make.centerX.mas_equalTo(self.view.mas_centerX);
        }];
    }
    return _contentLab;
}

- (UIButton *)controlBtn{
    if (!_controlBtn) {
_controlBtn                                           = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:_controlBtn];
_controlBtn.titleLabel.font                           = [UIFont systemFontOfSize:15];
        [_controlBtn setTitle:@"夜间模式灯光控制" forState:UIControlStateNormal];
        [_controlBtn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
        [_controlBtn setBackgroundImage:[UIImage imageNamed:@"还没账号"] forState:UIControlStateNormal];
        [_controlBtn setTitleColor:AllLampTitleColor forState:UIControlStateNormal];
        [_controlBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(249);
            make.bottom.mas_equalTo(self.view.mas_bottom).offset(-20);
            make.height.mas_equalTo(50);
            make.centerX.mas_equalTo(self.view.mas_centerX);
        }];
    }
    return _controlBtn;
}

- (void)click{

AllNightModeDetailViewController *vc                  = [[AllNightModeDetailViewController alloc]init];
vc.hidesBottomBarWhenPushed                           = YES;
    vc.lampModel = _model;

    [self.navigationController pushViewController:vc animated:YES];
}

- (void)Actiondo{
    if (_i == 0) {
kItemW                                                = - kItemW;
    }else if (_i == 100){
kItemW                                                = - kItemW;
    }

_i                                                    = _i + kItemW;

//_contentLab.text                                      = [NSString stringWithFormat:@"点击灯泡可以切换灯光亮度%d",_i];

    if (_isConnection == YES) {
        
        if (_lampData.length >=10) {
            Byte header[2];
            header[0] = 0x3A;
            header[1] = 0x11;
            //头部标示固定
            NSData *headerData = [NSData dataWithBytes:header length:2];
            //中间部分是灯泡的芯片ID
            NSData *bodyData = [_lampData subdataWithRange:NSMakeRange(0, 8)];
            //尾部是灯泡的亮度
            int i = _i;
            if (i== 0) {
                i = 1;
            }
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

#pragma mark - CBCentralManagerDelegate

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
            // 搜索成功之后,会调用我们找到外设的代理方法
            // - (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI; //找到外设
            
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
    
    if ([peripheral.name isEqualToString:_lampModel.lampMacAddress]) {
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
    NSLog(@"%s, line = %d, %@=连接成功", __FUNCTION__, __LINE__, peripheral.name);
    // 连接成功之后,可以进行服务和特征的发现
    // 4.1 获取外设的服务们
    // 4.1.1 设置外设的代理
    self.peripheral.delegate = self;
    
    // 4.1.2 外设发现服务,传nil代表不过滤
    // 这里会触发外设的代理方法 - (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
    [self.peripheral discoverServices:nil];
}

// 外设连接失败
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    _isConnection = NO;
    NSLog(@"%s, line = %d, %@=连接失败", __FUNCTION__, __LINE__, peripheral.name);
}

// 丢失连接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    _isConnection = NO;
    NSLog(@"%s, line = %d, %@=断开连接", __FUNCTION__, __LINE__, peripheral.name);
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
    NSLog(@"%s, line = %d--------%@", __FUNCTION__, __LINE__,characteristic.value);
    
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
    
    /* When a write occurs, need to set off a re-read of the local CBCharacteristic to update its value */
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

#pragma mark - 自定义方法

@end
