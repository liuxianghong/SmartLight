//
//  AllTimeDelayViewController.m
//  Intelligentlamp
//
//  Created by L on 16/9/19.
//  Copyright © 2016年 L. All rights reserved.
//
#define kItemW 30
#define kItemH 68
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define MLColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define kRGB236 MLColor(236, 73, 73, 1.0)
#define LampTitleColor HEXCOLOR(0x90c154)

#import "AllTimeDelayViewController.h"
#import "MLPickerScrollView.h"
#import "MLDemoItem.h"
#import "MLDemoModel.h"
#import "AllBulbModel.h"

@interface AllTimeDelayViewController()<MLPickerScrollViewDataSource,MLPickerScrollViewDelegate,UIAlertViewDelegate>{
    MLPickerScrollView *_pickerScollView;
    NSMutableArray *data;
    UIButton *sureButton;
    
    UILabel *label;
}
@property (nonatomic ,strong) UILabel *timingLabel;//场景定时label
@property (nonatomic ,strong) UISwitch *switchBtn;

@end

@implementation AllTimeDelayViewController


- (void)viewDidLoad{
    [super viewDidLoad];


    [self setTitleViewWithStr:@"延时开关"];
    
    [self layoutUI];
    
    [self leftBarButtonItem:[UIImage imageNamed:@"BackArrow"] withClickBtnAction:^{
        
        if (self.lampSetUpDelyBlock) {
            self.lampSetUpDelyBlock(_model);
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    
    [self setUpSureButton];
    
    
    if (_model.lamDelayOn == 1) {
        
        _switchBtn.on = YES;
    }else{
        _switchBtn.on = NO;
    }
    
    if (_model.lamDelayTime >  0) {
        self.discount = _model.lamDelayTime;
    }else{
        self.discount = (NSInteger)arc4random()%60;
    }
    
    [self setUpUI];
}

- (void)layoutUI{
   
    UILabel *topLine                = [[UILabel alloc]init];
    topLine.backgroundColor         = AllCellBgColor;
    
    [self.view addSubview:topLine];
    
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(15);
        make.width.mas_equalTo(ScreenWidth);
        make.height.mas_equalTo(45);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    _timingLabel                    = [[UILabel alloc]init];
    _timingLabel.backgroundColor    = AllCellBgColor;
    _timingLabel.textColor          = AllLampTitleColor;
    _timingLabel.font               = [UIFont systemFontOfSize:13];
    _timingLabel.text               = @"延时开关";
    [self.view addSubview:_timingLabel];
    
    [_timingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(80);
        make.left.mas_equalTo(self.view.mas_left).offset(15);
        make.top.mas_equalTo(self.view.mas_top).offset(20);
    }];
    
    _switchBtn                      = [[UISwitch alloc]init];
    [_switchBtn setOn:YES];
    [_switchBtn addTarget:self action:@selector(switchBtnClick:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_switchBtn];
    [_switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(50);
        make.right.mas_equalTo(self.view.mas_right).offset(-15);
        make.top.mas_equalTo(self.timingLabel);
        
    }];
}

- (void)switchBtnClick:(id)sender{
    UISwitch *switchButton          = (UISwitch*)sender;
    BOOL isButtonOn                 = [switchButton isOn];
    if (isButtonOn) {
        NSLog(@"时间选择器打开");
        _model.lamDelayOn = 1;
    }else {
        NSLog(@"时间选择器关闭");
        _model.lamDelayOn = 0;
    }
    
}

#pragma mark - UI
- (void)setUpUI
{
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 30)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = LampTitleColor;
    [self.view addSubview:label];
    
    
    
    // 1.数据源
    data = [NSMutableArray array];
    NSMutableArray  *muarray=[[NSMutableArray alloc]init];
    for(int i = 0;i<60;i++){
        [muarray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    NSArray *titleArray = [NSArray arrayWithArray:muarray];
    for (int i = 0; i < titleArray.count; i++) {
        MLDemoModel *model = [[MLDemoModel alloc] init];
        model.dicountTitle = [titleArray objectAtIndex:i];
        [data addObject:model];
    }
    
    // 2.初始化
    _pickerScollView = [[MLPickerScrollView alloc] initWithFrame:CGRectMake(kItemW, SCREEN_HEIGHT - 350, SCREEN_WIDTH - kItemH, kItemH)];
//    _pickerScollView.backgroundColor = [UIColor redColor];
    _pickerScollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"light_icon_bg"]];
    _pickerScollView.itemWidth = _pickerScollView.frame.size.width / 8;
    _pickerScollView.itemHeight = kItemH;
    _pickerScollView.firstItemX = (_pickerScollView.frame.size.width - _pickerScollView.itemWidth) * 0.5;
    _pickerScollView.dataSource = self;
    _pickerScollView.delegate = self;
    [self.view addSubview:_pickerScollView];
    
    // 3.刷新数据
    [_pickerScollView reloadData];
    
    // 4.滚动到对应折扣
    
    if (self.discount) {
        NSInteger number = 0;
        for (int i = 0; i < data.count; i++) {
            MLDemoModel *model = [data objectAtIndex:i];
            if (model.dicountIndex == self.discount) {
                number = i;
            }
        }
        _pickerScollView.seletedIndex = number;
        label.text = [NSString stringWithFormat:@"延时%ld分钟关灯",(long)number];
        [_pickerScollView scollToSelectdIndex:number];
    }
}

- (void)setUpSureButton
{
    sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.frame = CGRectMake(40, SCREEN_HEIGHT - 200, SCREEN_WIDTH - 80, 44);
    [sureButton setBackgroundImage:[UIImage imageNamed:@"还没账号"] forState:UIControlStateNormal];
    sureButton.layer.cornerRadius = 22;
    sureButton.layer.masksToBounds = YES;
    sureButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(clickSure) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureButton];
}

#pragma mark - Action
- (void)clickSure
{
    
}

#pragma mark - dataSource
- (NSInteger)numberOfItemAtPickerScrollView:(MLPickerScrollView *)pickerScrollView
{
    return data.count;
}

- (MLPickerItem *)pickerScrollView:(MLPickerScrollView *)pickerScrollView itemAtIndex:(NSInteger)index
{
    // creat
    MLDemoItem *item = [[MLDemoItem alloc] initWithFrame:CGRectMake(0, 0, pickerScrollView.itemWidth, pickerScrollView.itemHeight)];
    
    // assignment
    MLDemoModel *model = [data objectAtIndex:index];
    model.dicountIndex = index;
    item.title = model.dicountTitle;
    [item setGrayTitle];
    
    // tap
    item.PickerItemSelectBlock = ^(NSInteger d){
        [_pickerScollView scollToSelectdIndex:d];
        
        label.text = [NSString stringWithFormat:@"延时%ld分钟关灯",(long)d];
        _model.lamDelayTime = d;
    };
    
    return item;
}

#pragma mark - delegate
- (void)itemForIndexChange:(MLPickerItem *)item
{
    
    [item changeSizeOfItem];
}

- (void)itemForIndexBack:(MLPickerItem *)item
{
   label.text = [NSString stringWithFormat:@"延时%ld分钟关灯",_pickerScollView.seletedIndex];
    _model.lamDelayTime = _pickerScollView.seletedIndex;
    [item backSizeOfItem];
}

@end
