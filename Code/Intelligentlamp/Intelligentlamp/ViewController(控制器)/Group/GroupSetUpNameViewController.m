//
//  GroupSetUpNameViewController.m
//  Intelligentlamp
//
//  Created by L on 16/8/20.
//  Copyright © 2016年 L. All rights reserved.
//
#define AllBulbTitleColor HEXCOLOR(0x8c8c8e)
#define AllBulbLineColor HEXCOLOR(0x19181b)

#import "GroupSetUpNameViewController.h"

@interface GroupSetUpNameViewController()<UITextFieldDelegate>

@property (nonatomic ,strong) UITextField *textFild;
@end

@implementation GroupSetUpNameViewController

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
    
    [self setTitleViewWithStr:self.titleStr];
    
    [self layoutUI];
    
    [self leftBarButtonItem:[UIImage imageNamed:@"BackArrow"] withClickBtnAction:^{
        [self.navigationController popViewControllerAnimated:YES];
        if (self.changeContentBlock) {
            self.changeContentBlock(_textFild.text);
        }
    }];
    

}

- (void)layoutUI{
    
    _textFild = [[UITextField alloc]init];
    _textFild.text = self.content;
    _textFild.background = [UIImage imageNamed:@"enter_frame_bg"];
    _textFild.font = [UIFont systemFontOfSize:15];
    _textFild.textColor = AllBulbTitleColor;
    [self.view addSubview:_textFild];
    
    [_textFild mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(51);
        make.top.mas_equalTo(15);
        make.width.mas_equalTo(self.view.mas_width);
        
    }];
    
    UILabel *line = [[UILabel alloc]init];
    line.backgroundColor = AllBulbLineColor;
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_textFild.mas_bottom).offset(1);
        make.width.mas_equalTo(_textFild.mas_width);
        make.height.mas_equalTo(1);
    }];
    
    
}
@end
