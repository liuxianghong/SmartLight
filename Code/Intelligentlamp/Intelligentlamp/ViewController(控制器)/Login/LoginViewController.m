//
//  LoginViewController.m
//  Intelligentlamp
//
//  Created by L on 16/8/21.
//  Copyright © 2016年 L. All rights reserved.
//
#define SCREEN_WIDTH    ScreenWidth
#define SCREEN_HEIGHT   ScreenHeight - 180
#define IMAGEVIEW_COUNT 3
#define AllSloganTitleColor HEXCOLOR(0x90c154)

#import "LoginViewController.h"
#import "IQKeyboardManager.h"
#import "IQKeyboardReturnKeyHandler.h"
#import "AllLoginViewController.h"
#import "RegisteredViewController.h"


@interface LoginViewController()<UIScrollViewDelegate>{
    UIScrollView *_scrollView;
    UIImageView *_leftImageView;
    UIImageView *_centerImageView;
    UIImageView *_rightImageView;
    UIPageControl *_pageControl;
    NSMutableDictionary *_imageData;//图片数据
    int _currentImageIndex;//当前图片索引
    int _imageCount;//图片总数
}

@property (nonatomic ,strong) UIImageView *logo;
@property (nonatomic ,strong) UILabel *slogan;
@end

@implementation LoginViewController

#pragma -mark ViewController 生命周期函数

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[self buttonImageFromColor:AllBgColor] forBarMetrics:UIBarMetricsDefault];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"BottomTabBG.png"] forBarMetrics:UIBarMetricsDefault];
    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 0;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    //添加滚动控件
//    [self addScrollView];
    //添加图片控件
//    [self addImageViews];
    //添加分页控件
//    [self addPageControl];
    //加载默认图片
//    [self setDefaultImage];
    _imageCount = 6;
    
    [self layoutWithUI];
}

- (void)layoutWithUI{
    
    _logo = [[UIImageView alloc]init];
    _logo.image = [UIImage imageNamed:@"Icon-167"];
    [self.view addSubview:_logo];
    [_logo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(26);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(100);
    }];
    _slogan = [[UILabel alloc]init];
    _slogan.text = NSLocalizedString(@"AppDisplayName", nil);
    _slogan.textColor = AllSloganTitleColor;
    _slogan.font = [UIFont systemFontOfSize:24];
    _slogan.numberOfLines = 0;
    _slogan.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_slogan];
    [_slogan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_logo.mas_bottom).offset(30);
        make.width.mas_equalTo(self.view.mas_width);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.height.mas_greaterThanOrEqualTo(50);
    }];
    
    
    UIButton *registered = [UIButton buttonWithType:UIButtonTypeCustom];
    [registered addTarget:self action:@selector(registeredBtnClick) forControlEvents:UIControlEventTouchUpInside];
    registered.frame = CGRectMake(20, _scrollView.frame.size.height + 89, ScreenWidth - 40, 54);
    [registered setBackgroundImage:[UIImage imageNamed:@"登录按钮"] forState:UIControlStateNormal];
    registered.titleLabel.font = [UIFont systemFontOfSize:13];
    [registered setTitleColor:AllLampTitleColor forState:UIControlStateNormal];
//    [registered setTitle:@"还没有账号？" forState:UIControlStateNormal];
    [registered setTitle:NSLocalizedString(@"NoAccount", nil) forState:UIControlStateNormal];
    [self.view addSubview:registered];
    [registered mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-20);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(ScreenWidth - 40);
        make.height.mas_equalTo(54);
    }];
    
    
    UIButton *Login = [UIButton buttonWithType:UIButtonTypeCustom];
    [Login addTarget:self action:@selector(LoginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    Login.titleLabel.font = [UIFont systemFontOfSize:13];
    [Login setTitleColor:AllSloganTitleColor forState:UIControlStateNormal];
//    [Login setTitle:@"登录" forState:UIControlStateNormal];
    [Login setTitle:NSLocalizedString(@"login", nil) forState:UIControlStateNormal];
    [self.view addSubview:Login];
    [Login mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(registered.mas_top).offset(-12);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(ScreenWidth - 40);
        make.height.mas_equalTo(54);
    }];
    [Login setBackgroundImage:[UIImage imageNamed:@"登录按钮"] forState:UIControlStateNormal];
    
//    UIButton *registered = [UIButton buttonWithType:UIButtonTypeCustom];
//    [registered addTarget:self action:@selector(registeredBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [registered setTitle:@"注册" forState:UIControlStateNormal];
//    registered.frame = CGRectMake(20, _scrollView.frame.size.height + 89, ScreenWidth - 40, 54);
//    [registered setBackgroundImage:[UIImage imageNamed:@"登录按钮"] forState:UIControlStateNormal];
//    registered.titleLabel.font = [UIFont systemFontOfSize:13];
//    [registered setTitleColor:AllLampTitleColor forState:UIControlStateNormal];
//    
//    [self.view addSubview:registered];

    
}
- (void)LoginBtnClick{

    AllLoginViewController *vc = [[AllLoginViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)registeredBtnClick{
    RegisteredViewController *vc = [[RegisteredViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark 加载图片数据
//-(void)loadImageData{
//    //读取程序包路径中的资源文件
//    NSString *path=[[NSBundle mainBundle] pathForResource:@"imageInfo" ofType:@"plist"];
//    _imageData=[NSMutableDictionary dictionaryWithContentsOfFile:path];
//    _imageCount=(int)_imageData.count;
//}

#pragma mark 添加控件
-(void)addScrollView{
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:_scrollView];
    //设置代理
    _scrollView.delegate=self;
    //设置contentSize
    _scrollView.contentSize=CGSizeMake(IMAGEVIEW_COUNT*SCREEN_WIDTH, SCREEN_HEIGHT) ;
    //设置当前显示的位置为中间图片
    [_scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:NO];
    //设置分页
    _scrollView.pagingEnabled=YES;
    //去掉滚动条
    _scrollView.showsHorizontalScrollIndicator=NO;
}

#pragma mark 添加图片三个控件
-(void)addImageViews{
    _leftImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    _leftImageView.contentMode=UIViewContentModeScaleAspectFit;
    [_scrollView addSubview:_leftImageView];
    _centerImageView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    _centerImageView.contentMode=UIViewContentModeScaleAspectFit;
    [_scrollView addSubview:_centerImageView];
    _rightImageView=[[UIImageView alloc]initWithFrame:CGRectMake(2*SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    _rightImageView.contentMode=UIViewContentModeScaleAspectFit;
    [_scrollView addSubview:_rightImageView];
    
}
#pragma mark 设置默认显示图片
-(void)setDefaultImage{
    //加载默认图片
    _leftImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%i.png",_imageCount-1]];
    _centerImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%i.png",0]];
    _rightImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%i.png",1]];
    _currentImageIndex=0;
    //设置当前页
    _pageControl.currentPage=_currentImageIndex;
    
}

#pragma mark 添加分页控件
-(void)addPageControl{
    _pageControl=[[UIPageControl alloc]init];
    //注意此方法可以根据页数返回UIPageControl合适的大小
    _pageControl.bounds=CGRectMake(0, 0, 200, 10);
    _pageControl.center=CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT-20);
    //    设置颜色
    _pageControl.pageIndicatorTintColor= [UIColor whiteColor];
    //设置当前页颜色
    _pageControl.currentPageIndicatorTintColor= [UIColor redColor];
    
    //设置总页数
    _pageControl.numberOfPages=_imageCount;
    
    [self.view addSubview:_pageControl];
}
#pragma mark 滚动停止事件
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //重新加载图片
    [self reloadImage];
    //移动到中间
    [_scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:NO];
    //设置分页
    _pageControl.currentPage=_currentImageIndex;
    
}

#pragma mark 重新加载图片
-(void)reloadImage{
    
    int leftImageIndex,rightImageIndex;
    CGPoint offset=[_scrollView contentOffset];
    if (offset.x>SCREEN_WIDTH) { //向右滑动
        _currentImageIndex=(_currentImageIndex+1)%_imageCount;
    }else if(offset.x<SCREEN_WIDTH){ //向左滑动
        _currentImageIndex=(_currentImageIndex+_imageCount-1)%_imageCount;
    }
    //UIImageView *centerImageView=(UIImageView *)[_scrollView viewWithTag:2];
    _centerImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%i.png",_currentImageIndex]];
    
    //重新设置左右图片
    leftImageIndex=(_currentImageIndex+_imageCount-1)%_imageCount;
    rightImageIndex=(_currentImageIndex+1)%_imageCount;
    _leftImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%i.png",leftImageIndex]];
    _rightImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%i.png",rightImageIndex]];
}

- (UIImage *)buttonImageFromColor:(UIColor *)color{
    
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
@end
