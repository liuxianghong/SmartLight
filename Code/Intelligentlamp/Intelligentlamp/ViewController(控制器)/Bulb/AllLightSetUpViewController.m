//
//  AllLightSetUpViewController.m
//  Intelligentlamp
//
//  Created by L on 16/8/28.
//  Copyright © 2016年 L. All rights reserved.
//
#define LampCirWidth  (ScreenWidth - 90)/2

#import "AllLightSetUpViewController.h"
#import "LampCircularSlider.h"
#import "AllBulbModel.h"

@interface AllLightSetUpViewController()
@property (nonatomic ,strong) UIScrollView *scrollView;
@property (nonatomic ,strong) UIImageView *lampImg;//灯泡图片
@property (nonatomic ,strong) LampCircularSlider *powerCir;//功率
@property (nonatomic ,strong) LampCircularSlider *showCir;//显指
@property (nonatomic ,strong) LampCircularSlider *tonalCir;//色调
@property (nonatomic ,strong) LampCircularSlider *psaturationCir;//饱和度

@end

@implementation AllLightSetUpViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self setTitleViewWithStr:@"高级设置"];
    [self leftBarButtonItem:[UIImage imageNamed:@"BackArrow"] withClickBtnAction:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [self layoutUI];

    
    //功率默认值
    if (_bulbModel.lampPower <=0) {
        
    }else{
        _powerCir.value = _bulbModel.lampPower * 0.01;
    }
    
    //显指默认值
    if (_bulbModel.lampShow <=0) {
        
    }else{
        _showCir.value = _bulbModel.lampShow *0.01;
    }
    
    //色调默认值
    if (_bulbModel.lampTonal <=0) {
        
    }else{
        _tonalCir.value = _bulbModel.lampTonal *0.01;
    }
    
    //饱和度默认值
    if (_bulbModel.lampSaturation <=0) {
        
    }else{
        _psaturationCir.value = _bulbModel.lampSaturation *0.01;
    }
}
#pragma -mark ViewController 生命周期函数

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)layoutUI{
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.view addSubview:_scrollView];
    // 是否反弹
    _scrollView.bounces = NO;
    //是否显示滚动条
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight * 1.2);
    
    [self.scrollView addSubview:self.lampImg];
    [self.scrollView addSubview:self.powerCir];
    [self.scrollView addSubview:self.showCir];
    [self.scrollView addSubview:self.tonalCir];
    [self.scrollView addSubview:self.psaturationCir];
    
    
}

- (UIImageView *)lampImg{
    if(_lampImg == nil){
        _lampImg = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenWidth - 74)/2, 50, 74, 74)];
//         [_lampImg setImage:[UIImage imageNamed:@"Lightbulb_Off"]];
        UIImage *theImg = [UIImage imageNamed:@"Lightbulb_Off"];
        theImg = [theImg imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _lampImg.image = theImg;
        _lampImg.tintColor =_lampColor;
        
    }
    return _lampImg;
}

- (LampCircularSlider *)powerCir{
    if (!_powerCir) {
        _powerCir = [[LampCircularSlider alloc] init];
        _powerCir.frame = CGRectMake(30, 154, LampCirWidth, LampCirWidth);
        
        _powerCir.sliderStyle = MTTCircularSliderStyleImage;
        _powerCir.unselectImage = [UIImage imageNamed:@"功率"];
        _powerCir.indicatorImage = [UIImage imageNamed:@"指针"];
        _powerCir.maxAngle = 360;
        
        [_powerCir addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [_powerCir addTarget:self action:@selector(sliderEditingDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
    }
    
    return _powerCir;
}

- (LampCircularSlider *)showCir{
    if (!_showCir) {
        _showCir = [[LampCircularSlider alloc] init];
        _showCir.frame = CGRectMake(60 +  LampCirWidth, 154, LampCirWidth, LampCirWidth);
        
        _showCir.sliderStyle = MTTCircularSliderStyleImage;
        _showCir.unselectImage = [UIImage imageNamed:@"显指"];
        _showCir.indicatorImage = [UIImage imageNamed:@"指针"];
        _showCir.maxAngle = 360;
        
        [_showCir addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [_showCir addTarget:self action:@selector(sliderEditingDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
    }
    
    return _showCir;
}

- (LampCircularSlider *)tonalCir{
    if (!_tonalCir) {
        _tonalCir = [[LampCircularSlider alloc] init];
        _tonalCir.frame = CGRectMake(30, 154 + 60 + LampCirWidth, LampCirWidth, LampCirWidth);
        
        _tonalCir.sliderStyle = MTTCircularSliderStyleImage;
        _tonalCir.unselectImage = [UIImage imageNamed:@"色调"];
        _tonalCir.indicatorImage = [UIImage imageNamed:@"指针"];
        _tonalCir.maxAngle = 360;
        
        [_tonalCir addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [_tonalCir addTarget:self action:@selector(sliderEditingDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
    }
    
    return _tonalCir;
}

- (LampCircularSlider *)psaturationCir{
    if (!_psaturationCir) {
        _psaturationCir = [[LampCircularSlider alloc] init];
        _psaturationCir.frame = CGRectMake(60 +  LampCirWidth, 154 + 60 + LampCirWidth, LampCirWidth, LampCirWidth);
        
        _psaturationCir.sliderStyle = MTTCircularSliderStyleImage;
        _psaturationCir.unselectImage = [UIImage imageNamed:@"饱和度"];
        _psaturationCir.indicatorImage = [UIImage imageNamed:@"指针"];
        _psaturationCir.maxAngle = 360;
        
        [_psaturationCir addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [_psaturationCir addTarget:self action:@selector(sliderEditingDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
    }
    
    return _psaturationCir;
}

- (void)sliderValueChanged:(LampCircularSlider*)slider
{
    _bulbModel.lampPower=_powerCir.value * 100;
    _bulbModel.lampShow=_showCir.value * 100;
    _bulbModel.lampTonal=_tonalCir.value* 100;
    _bulbModel.lampSaturation=_psaturationCir.value* 100;
}
- (void)sliderEditingDidEnd:(LampCircularSlider*)slider
{
//    self.valueLabel.text = [NSString stringWithFormat:@"%.2f%%", slider.value];
}
- (void)segmentedChangeValue:(UISegmentedControl*)segmented
{
    CGPoint point = CGPointMake(self.scrollView.frame.size.width * segmented.selectedSegmentIndex, 0);
    [self.scrollView setContentOffset:point animated:YES];
}
@end
