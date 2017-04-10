//
//  LampSetUpTimeViewController.m
//  Intelligentlamp
//
//  Created by L on 16/9/22.
//  Copyright © 2016年 L. All rights reserved.
//
#define DateBtnWidth (ScreenWidth - 100)/7
#define AllBulbDescribeColor HEXCOLOR(0x8c8c8e)
#define AllBulbLineColor HEXCOLOR(0x19181b)
#define AllTextFileWidth  (ScreenWidth -80)/2
#define AllCellBgColor RGB(28,27,31)
#import "LampSetUpTimeViewController.h"
#import "AllBulbModel.h"

@interface LampSetUpTimeViewController()<UIPickerViewDelegate>
@property (nonatomic ,strong) UILabel *timingLabel;//场景定时label
@property (nonatomic ,strong) UISwitch *switchBtn;

@property (nonatomic ,strong) UILabel *randomTimeLabel;//随机定时定时label
@property (nonatomic ,strong) UISwitch *randomswitchBtn;


@property (nonatomic ,strong) UIDatePicker *dateSelect;//时间选择器
@property (nonatomic ,strong) UIButton *leftTimeBtn;//左边的时间
@property (nonatomic ,strong) UIButton *rightTimeBtn;//右边的时间
@property (nonatomic ,strong) UIImageView *arrow;//时间之间的箭头
@property (nonatomic ,strong) UIImageView *bgImage;//按钮背景图片
@property (nonatomic ,strong) UIButton *cancleBtn;//取消按钮
@property (nonatomic ,strong) UIButton *deterBtn;//确定按钮
@property (nonatomic ,assign) BOOL isLeft;
@property (nonatomic ,strong) NSString *time;

@property (nonatomic ,strong) NSArray *dataArr;//日期数据


@end

@implementation LampSetUpTimeViewController

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
    
    _time = [[NSString alloc]init];
    
    [self setTitleViewWithStr:@"场景定时"];
    
    [self layoutUI];
    
    [self leftBarButtonItem:[UIImage imageNamed:@"BackArrow"] withClickBtnAction:^{
        [self.navigationController popViewControllerAnimated:YES];
        
        if (self.lampSetUpTimeBlock) {
            self.lampSetUpTimeBlock(_model);
        }
    }];
    
    //设置初始的默认开关灯时间
    
    if (_model.lampTimingOpenTime == nil ||[_model.lampTimingOpenTime isEqual:[NSNull null]] || [_model.lampTimingOpenTime isEqualToString:@""]) {
        [_leftTimeBtn setTitle:@"开灯时间 00:00:00" forState:UIControlStateNormal];
    }else {
        
        
        [_leftTimeBtn setTitle:[NSString stringWithFormat:@"开灯时间 %@",_model.lampTimingOpenTime] forState:UIControlStateNormal];
    }
    
    if ([_model.lampTimingCloseTime isEqual:[NSNull null]]||[_model.lampTimingCloseTime isEqualToString:@""]||_model.lampTimingCloseTime == nil) {
        
        [_rightTimeBtn setTitle:@"关灯时间 00:00:00" forState:UIControlStateNormal];
    }else {
        [_rightTimeBtn setTitle:[NSString stringWithFormat:@"关灯时间 %@",_model.lampTimingCloseTime ] forState:UIControlStateNormal];
    }
    
    //设置默认的定时开关按钮状态
    
    if (_model.lampTimingOn == 1) {
        _switchBtn.on = YES;
    }else{
        _switchBtn.on = NO;
    }
    
    //设置默认的随机开关按钮状态
    
    if (_model.lamPrandomOn == 1) {
        _randomswitchBtn.on = YES;
    }else{
        _randomswitchBtn.on = NO;
    }
    
}

- (NSArray *)dataArr{
    if (!_dataArr) {
        _dataArr                        = @[@"S",@"M",@"T",@"W",@"T",@"F",@"S"];
    }
    return _dataArr;
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
    _timingLabel.textColor          = AllBulbDescribeColor;
    _timingLabel.font               = [UIFont systemFontOfSize:13];
    _timingLabel.text               = @"场景定时";
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
    
    
    UILabel *topLine2                = [[UILabel alloc]init];
    topLine2.backgroundColor         = AllCellBgColor;
    [self.view addSubview:topLine2];
    
    [topLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topLine.mas_bottom).offset(10);
        make.width.mas_equalTo(ScreenWidth);
        make.height.mas_equalTo(45);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    _randomTimeLabel                    = [[UILabel alloc]init];
    _randomTimeLabel.backgroundColor    = AllCellBgColor;
    _randomTimeLabel.textColor          = AllBulbDescribeColor;
    _randomTimeLabel.font               = [UIFont systemFontOfSize:13];
    _randomTimeLabel.text               = @"随机定时";
    [self.view addSubview:_randomTimeLabel];
    
    [_randomTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(80);
        make.left.mas_equalTo(self.view.mas_left).offset(15);
        make.top.mas_equalTo(topLine2.mas_top).offset(5);
    }];
    
    _randomswitchBtn                      = [[UISwitch alloc]init];
    [_randomswitchBtn setOn:YES];
    [_randomswitchBtn addTarget:self action:@selector(randomSwitchBtnClick:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_randomswitchBtn];
    [_randomswitchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(50);
        make.right.mas_equalTo(self.view.mas_right).offset(-15);
        make.top.mas_equalTo(self.randomTimeLabel);
        
    }];
    
    
    _leftTimeBtn                    = [UIButton buttonWithType:UIButtonTypeCustom];
    [_leftTimeBtn setTitleColor:AllBulbDescribeColor forState:UIControlStateNormal];
    [_leftTimeBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [_leftTimeBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _leftTimeBtn.titleLabel.font    = [UIFont systemFontOfSize:13];
    [self.view addSubview:_leftTimeBtn];
    [_leftTimeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(AllTextFileWidth);
        make.height.mas_equalTo(35);
        make.left.mas_equalTo(self.view.mas_left).offset(15);
        make.top.mas_equalTo(topLine2.mas_bottom).offset(50);
    }];
    
    _rightTimeBtn                   = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightTimeBtn setTitleColor:AllBulbDescribeColor forState:UIControlStateNormal];
    [_rightTimeBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    _rightTimeBtn.titleLabel.font   = [UIFont systemFontOfSize:13];
    [self.view addSubview:_rightTimeBtn];
    [_rightTimeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(AllTextFileWidth);
        make.height.mas_equalTo(35);
        make.right.mas_equalTo(self.view.mas_right).offset(-15);
        make.top.mas_equalTo(topLine2.mas_bottom).offset(50);
    }];
    
    //    [self createBtnWithArr:_selectDataArr];
    
}

- (void)createBtnWithArr:(NSMutableArray *)dataArr{
    for (int  i                     = 0; i<7; i++) {
        UIButton *btn                   = [UIButton buttonWithType:UIButtonTypeCustom];
        for (NSString *n in dataArr) {
            if ([n isEqualToString:[NSString stringWithFormat:@"%d",i]]) {
                btn.selected                    = YES;
            }
        }
        NSString *str                   = _dataArr[i];
        btn.layer.masksToBounds         = YES;
        btn.layer.cornerRadius          = 4;
        btn.layer.borderWidth           = 2;
        
        if (btn.selected) {
            btn.backgroundColor             = [UIColor redColor];
        }else{
            btn.backgroundColor             = [UIColor whiteColor];
        }
        [btn setTitle:str forState:UIControlStateNormal];
        btn.titleLabel.font             = [UIFont systemFontOfSize:15];
        [btn setTitleColor:AllLampTitleColor forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(DataBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag                         = i;
        [self.view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_leftTimeBtn.mas_bottom).offset(15);
            make.height.mas_equalTo(25);
            make.left.mas_equalTo(self.view.mas_left).offset(20+(DateBtnWidth +10) * i);
        }];
    }
}

- (void)DataBtnClick:(UIButton *)sender{
    if (sender.selected) {
        sender.selected                 = NO;
        sender.backgroundColor          = [UIColor whiteColor];
        NSString *str                   = [NSString stringWithFormat:@"%ld",(long)sender.tag];
        [_selectDataArr removeObject:str];
        
    }else{
        sender.selected                 = YES;
        sender.backgroundColor          = [UIColor redColor];
        NSString *str                   = [NSString stringWithFormat:@"%ld",(long)sender.tag];
        [_selectDataArr addObject:str];
        
    }
}
- (UIDatePicker *)dateSelect{
    
    _dateSelect                     = [[UIDatePicker alloc]init];
    _dateSelect.tintColor           = AllBulbDescribeColor;
    [_dateSelect setValue:[UIColor whiteColor] forKey:@"textColor"];
    _dateSelect.datePickerMode      = UIDatePickerModeTime;
    _dateSelect.minuteInterval      = 5;
    [_dateSelect addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_dateSelect];
    [_dateSelect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(ScreenWidth - 60);
        make.height.mas_equalTo(200);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-20);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    return _dateSelect;
}

- (UIImageView *)bgImage{
    
    _bgImage                        = [[UIImageView alloc]init];
    _bgImage.userInteractionEnabled = YES;
    _bgImage.backgroundColor        = AllCellBgColor;
    [self.view addSubview:_bgImage];
    [_bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.view.mas_width);
        make.height.mas_equalTo(40);
        make.centerY.mas_equalTo(self.view.mas_centerY);
        make.bottom.mas_equalTo(_dateSelect.mas_top);
    }];
    
    return _bgImage;
}

- (UIButton *)deterBtn{
    
    _deterBtn                       = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [_deterBtn addTarget:self action:@selector(deterBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_deterBtn setTitle:@"确定" forState:UIControlStateNormal];
    _deterBtn.titleLabel.font       = [UIFont systemFontOfSize:13];
    [_deterBtn setTintColor:AllLampTitleColor];
    [_bgImage addSubview:_deterBtn];
    [_deterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(60);
        make.right.mas_equalTo(self.view.mas_right).offset(-20);
        make.centerY.mas_equalTo(_bgImage.mas_centerY);
    }];
    
    return _deterBtn;
}

- (UIButton *)cancleBtn{
    
    _cancleBtn                      = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [_cancleBtn addTarget:self action:@selector(cancleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    _cancleBtn.titleLabel.font      = [UIFont systemFontOfSize:13];
    [_cancleBtn setTintColor:AllLampTitleColor];
    [_bgImage addSubview:_cancleBtn];
    [_cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(60);
        make.left.mas_equalTo(self.view.mas_left).offset(20);
        make.centerY.mas_equalTo(_bgImage.mas_centerY);
    }];
    
    return _cancleBtn;
}

- (void)deterBtnClick{
    
    if (_isLeft) {
        if ([_time isEqualToString:@""]||[_time isEqual:[NSNull class]]) {
            
            NSDate *currentDate = [NSDate date];//获取当前时间，日期
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"HH:mm:ss"];
            NSString *dateString = [dateFormatter stringFromDate:currentDate];
            
            [_leftTimeBtn setTitle:[NSString stringWithFormat:@"开灯时间 %@",dateString] forState:UIControlStateNormal];
            _model.lampTimingOpenTime = dateString;
        }else{
            [_leftTimeBtn setTitle:_time forState:UIControlStateNormal];
        }
        
    }else{
        if ([_time isEqualToString:@""]) {
            
            NSDate *currentDate = [NSDate date];//获取当前时间，日期
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"HH:mm:ss"];
            NSString *dateString = [dateFormatter stringFromDate:currentDate];
            
            [_rightTimeBtn setTitle:[NSString stringWithFormat:@"关灯时间 %@",dateString] forState:UIControlStateNormal];
            _model.lampTimingCloseTime = dateString;
        }else{
            [_rightTimeBtn setTitle:_time forState:UIControlStateNormal];
        }
        
    }
    
    [self RemoveDateSelect];
}
- (void)cancleBtnClick{
    [self RemoveDateSelect];
}

- (void)AdddateSelect{
    [self dateSelect];
    [self bgImage];
    [self deterBtn];
    [self cancleBtn];
}

- (void)RemoveDateSelect{
    [_cancleBtn removeFromSuperview];
    [_deterBtn removeFromSuperview];
    [_bgImage removeFromSuperview];
    [_dateSelect removeFromSuperview];
}

- (void)leftBtnClick{
    _isLeft                         = YES;
    [self RemoveDateSelect];
    [self AdddateSelect];
}

- (void)rightBtnClick{
    _isLeft                         = NO;
    [self RemoveDateSelect];
    [self AdddateSelect];
}

- (void)switchBtnClick:(id)sender{
    UISwitch *switchButton          = (UISwitch*)sender;
    BOOL isButtonOn                 = [switchButton isOn];
    if (isButtonOn) {
        NSLog(@"时间选择器打开");
        _model.lampTimingOn = 1;
        
    }else {
        NSLog(@"时间选择器关闭");
        _model.lampTimingOn = 0;
    }
    
}

- (void)randomSwitchBtnClick:(id)sender{
    UISwitch *switchButton          = (UISwitch*)sender;
    BOOL isButtonOn                 = [switchButton isOn];
    if (isButtonOn) {
        NSLog(@"随机时间选择器打开");
        _model.lamPrandomOn = 1;
    }else {
        NSLog(@"随机时间选择器关闭");
        _model.lamPrandomOn = 0;
    }
    
}

-(void)dateChange:(id)sender{
    UIDatePicker* control           = (UIDatePicker*)sender;
    NSDate* _date                   = control.date;
    NSDateFormatter * formatter     = [[NSDateFormatter alloc] init];
    //格式日期格式化格式
    [formatter setDateFormat:@"HH:mm:ss"];
    NSString * dateString           = [formatter stringFromDate:_date];
    if (_isLeft == YES) {
        _time                           = [NSString stringWithFormat:@"开灯时间 %@",dateString];
        _model.lampTimingOpenTime = dateString;
    }else{
        _time                           = [NSString stringWithFormat:@"关灯时间 %@",dateString];
        _model.lampTimingCloseTime = dateString;
    }
    
    NSLog(@"%@",dateString);
}

@end
