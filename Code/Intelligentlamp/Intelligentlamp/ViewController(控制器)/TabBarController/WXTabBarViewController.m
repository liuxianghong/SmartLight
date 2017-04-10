//
//  WXTabBarViewController.m
//  weixin
//
//  Created by L on 16/8/17.
//  Copyright © 2016年 L. All rights reserved.
//

#import "WXTabBarViewController.h"
#define SelColor RGB(85, 85, 85)
#define TitleColor RGB(139, 139, 139)
@interface WXTabBarViewController (){
    NSMutableArray *labelArr;
    NSMutableArray *imgIconArr;
}

@end

@implementation WXTabBarViewController

@synthesize currentSelectedIndex;
@synthesize buttons;

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [self.presentedViewController beginAppearanceTransition: YES animated: animated];
}

-(void) viewDidAppear:(BOOL)animated
{
    [self.presentedViewController endAppearanceTransition];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [self.presentedViewController beginAppearanceTransition: NO animated: animated];
}

-(void) viewDidDisappear:(BOOL)animated
{
    [self.presentedViewController endAppearanceTransition];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithTitle:(NSArray *)titleLabelArr imgArr:(NSArray *)iconArr selectArr:(NSArray *)selArr bgImage:(UIImage *)img{
    
    self = [super init];
    if (self) {
        self.titleArr = titleLabelArr;
        self.iconsArr = iconArr;
        self.iconsSelectArr = selArr;
        self.tabbarBg = img;
        self.currentSelectedIndex = 100;
        labelArr = [NSMutableArray array];
        imgIconArr = [NSMutableArray array];
        
    }
    
    
    return self;
}

- (void)hideRealTabBar{
    for(UIView *view in self.view.subviews){
        if([view isKindOfClass:[UITabBar class]]){
            view.hidden               = YES;
//            view.backgroundColor    = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BottomTabBG.png"]];
            break;
        }
    }
}

-(void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated
{
    [super setViewControllers:viewControllers animated:animated];
    [self customTabBar];
}

- (void)customTabBar
{
    UIView *bgView            = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    bgView.backgroundColor    = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BottomTabBG.png"]];
    
    [self.tabBar addSubview:bgView];
    //创建按钮
    int viewCount             = self.viewControllers.count > 4 ? 4 : (int)self.viewControllers.count;
    self.buttons              = [NSMutableArray arrayWithCapacity:viewCount];
    double _width             = self.tabBar.frame.size.width / viewCount;
    double _height            = self.tabBar.frame.size.height;
    for (int i                = 0; i < viewCount; i++) {
        
        //icon
        NSString *image            = [self.iconsArr objectAtIndex:i];
        float imgW                = 25;
        float imgH                = 25;
        float space               = (_width - 25)/2.0;
        UIImageView *imgView      = [[UIImageView alloc] initWithFrame:CGRectMake(_width*i+space, 5, imgW, imgH)];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        imgView.image             = [UIImage imageNamed:image];
        [self.tabBar   addSubview:imgView];
        [imgIconArr    addObject:imgView];
        
        //title
        UILabel *label            = [[UILabel alloc] initWithFrame:CGRectMake(i == 0?_width*i+space -3:_width*i+space+5, 10+imgH, imgW, 14)];
        label.textAlignment       = NSTextAlignmentCenter;
        label.font                = [UIFont systemFontOfSize:8.0];
        label.backgroundColor     = [UIColor clearColor];
        NSString *titleStr        = [self.titleArr objectAtIndex:i];
        label.text                = titleStr;
        [label sizeToFit];
        [self.tabBar addSubview:label];
        [labelArr addObject:label];
        
        UIButton *btn             = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame                 = CGRectMake(i*_width,0, _width, _height);
        [btn addTarget:self action:@selector(selectTab:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag                   = i;
        [self.buttons addObject:btn];
        [self.tabBar  addSubview:btn];
    }
    
    [self selectTab:[self.buttons objectAtIndex:0]];
    
}


- (void)selectTab:(UIButton *)button{
    if (self.currentSelectedIndex == button.tag) {
        return;
    }
    self.currentSelectedIndex = (int)button.tag;
    self.selectedIndex        = self.currentSelectedIndex;
    
    for (int i                = 0; i<[labelArr count]; i++) {
        UILabel *label            = [labelArr objectAtIndex:i];
        if (i==self.currentSelectedIndex) {

                        label.textColor           = TitleColor;
        }else {

                        label.textColor           = SelColor;
        }
    }
    for (int i                = 0; i<[self.iconsArr count]; i++) {
        UIImageView *imgView      = [imgIconArr objectAtIndex:i];
        if (i==self.currentSelectedIndex) {
            NSString *image            = [self.iconsSelectArr objectAtIndex:i] ;
            imgView.image             = [UIImage imageNamed:image];
        }else {
            NSString *image            = [self.iconsArr objectAtIndex:i] ;
            imgView.image             = [UIImage imageNamed:image];
        }
    }
}

- (void) dealloc{
    
}

@end

