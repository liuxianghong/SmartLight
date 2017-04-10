//
//  MineViewController.m
//  weixin
//
//  Created by L on 16/8/17.
//  Copyright © 2016年 L. All rights reserved.
//

#import "MineViewController.h"
#import "MineListTableviewCell.h"
#import "MineFootView.h"
#import "MineHeaderView.h"
#import "UserFeedbackVC.h"
#import "SystemUpdateVC.h"
#import "AboutVC.h"
#import "ImageSelector.h"
#import "UIView+Progress.h"
#import "SharedView.h"
#import "LoginViewController.h"
#import "LXNetworking.h"
#import "UIImageView+WebCache.h"
#import "UserModel.h"
#import "UserNameChangeViewController.h"

@interface MineViewController()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) UITableView *tableView;//列表
@property (nonatomic ,strong) NSMutableArray *allDataArr;//列表数据源
@property (nonatomic ,strong) MineFootView *footView;//尾部
@property (nonatomic ,strong) MineHeaderView *headerView;//头部


@property (nonatomic ,strong) UserModel *model;


@end

@implementation MineViewController
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


- (void)viewDidLoad{
    [super viewDidLoad];

//    _model                                  = [[UserModel alloc]init];
    [self setTitleViewWithStr:@"我的"];

     [self networkForUserInfoGet];

    [self layoutUI];
    [self initDataArr];

    [self setTableID];


}


- (void)networkForUserInfoGet{

    WEAKSELF
    NSMutableDictionary *dic                = [NSMutableDictionary dictionary];
    [dic setValue:@"1.0.0" forKey:@"version"];
    [dic setValue:getUserId() forKey:@"userId"];
    [dic setValue:getUserToken() forKey:@"token"];
    [dic setValue:getUserId() forKey:@"infoUserId"];

        [self showNetWorkView];

        [LXNetworking postWithUrl:User_GetDetailUserInfo params:dic success:^(id response) {
            [self hideNetWorkView];
    _model                                  = [[UserModel alloc]init];
    _model.userImg                          = response[@"headBigURL"];
    _model.userName                         = response[@"nickname"];
    _headerView.model                       = _model;

        } fail:^(NSError *error) {


        } showHUD:nil];

}

- (void)initDataArr{
//    NSArray *nameArr                        = @[@"分享应用",@"用户反馈",@"系统更新",@"关于我们"];
//    NSArray *imageArr                       = @[ @"share",@"light_bulb_description",@"system_upgrade",@"about"];
    NSArray *nameArr                        = @[@"分享应用",@"用户反馈",@"关于我们"];
    NSArray *imageArr                       = @[ @"share",@"light_bulb_description",@"about"];

    for (NSInteger i                        = 0; i < nameArr.count; i++) {
    NSMutableDictionary *dic                = [NSMutableDictionary dictionary];
        [dic setObject:nameArr[i] forKey:@"name"];
        [dic setObject:imageArr[i] forKey:@"image"];
        [self.allDataArr addObject:dic];
    }
}

- (NSMutableArray *)allDataArr{
    if (_allDataArr == nil) {
    _allDataArr                             = [NSMutableArray array];
    }
    return _allDataArr;
}

- (void)layoutUI{
    _tableView                              = [[UITableView alloc]init];
    _tableView.backgroundColor              = [UIColor clearColor];
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    WEAKSELF
    //添加_footView
    _footView                               = [[MineFootView alloc]init];
    _tableView.tableFooterView              = _footView;
    [_footView layoutMineFootView];
    CGFloat height                          = [_footView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + _footView.frame.origin.y;

    CGRect footFrame                        = _footView.frame;
    footFrame.size.height                   = height;
    _footView.frame                         = footFrame;
    [self.tableView setTableFooterView:_footView];
    _footView.exitClickBlock                = ^(){
        NSLog(@"退出登录");

        //初始化提示框；
    UIAlertController *alert                = [UIAlertController alertControllerWithTitle:@"" message:@"确定退出当前账号?" preferredStyle:  UIAlertControllerStyleAlert];

    UIAlertAction *cancelAction             = [UIAlertAction actionWithTitle:@"取消"style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancelAction];

        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

            removeUserId();
            //点击按钮的响应事件；
    LoginViewController *vc                 = [[LoginViewController alloc]init];
    UINavigationController *nv              = [[UINavigationController alloc] initWithRootViewController:vc];
    vc.hidesBottomBarWhenPushed             = YES;
            [weakSelf presentViewController:nv animated:YES completion:nil];

        }]];

        //弹出提示框；
        [weakSelf presentViewController:alert animated:true completion:nil];



    };

    //添加头部
    _headerView                             = [[MineHeaderView alloc]init];
    _tableView.tableHeaderView              = _headerView;
    [_headerView layoutHeaderView];


    CGFloat height2                         = [_headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + _headerView.frame.origin.y;

    CGRect headerFrame                      = _headerView.frame;
    headerFrame.size.height                 = height2;
    _headerView.frame                       = headerFrame;
    _headerView.iconImg.image = [UIImage imageNamed:@"my_user_avatar"];
    [self.tableView setTableHeaderView:_headerView];

    _headerView.changeIconBlock             = ^(){
        //更换头像
        [[ImageSelector selector] selectorAvatarAtControlloer:weakSelf afterSelect:^(NSArray *images) {
            [weakSelf.headerView.iconImg setImage:images[0]];

    NSMutableDictionary *dic                = [NSMutableDictionary dictionary];
            [dic setValue:@"1.0.0" forKey:@"version"];
            [dic setValue:getUserId() forKey:@"userId"];
            [dic setValue:getUserToken() forKey:@"token"];


            if ([LXNetworking sharedLXNetworking].networkStats == StatusNotReachable) {
                [weakSelf showRemendWarningView:@"没有网络" withBlock:nil];

            }else{

                [weakSelf showNetWorkView];

                [LXNetworking uploadWithImage:images[0] url:User_UploadUserHeadImg filename:@"head.png" name:@"headImgFile" params:dic progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {

                } success:^(id response) {
                    [weakSelf showRemendSuccessView:@"上传成功" withBlock:nil];

                } fail:^(NSError *error) {

                    [weakSelf showRemendWarningView:@"上传失败" withBlock:nil];

                } showHUD:nil];

            }


        }];


    };

    _headerView.changeNameBlock             = ^(){

    UserNameChangeViewController *vc        = [[UserNameChangeViewController alloc]init];

    vc.titleStr                             = @"修改昵称";
    vc.content                              = weakSelf.model.userName;
    vc.changeContentBlock                   = ^(NSString *str){
    weakSelf.headerView.name.text           = str;
    weakSelf.model.userName                 = str;
            };

    vc.hidesBottomBarWhenPushed             = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };


    self.tableView.delegate                 = self;
    self.tableView.dataSource               = self;
    self.tableView.separatorStyle           = UITableViewCellSeparatorStyleNone;
}

- (void)setTableID{
    [self.tableView registerClass:[MineListTableviewCell class] forCellReuseIdentifier:NSStringFromClass([MineListTableviewCell class])];
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
    MineListTableviewCell *cell             = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MineListTableviewCell class]) forIndexPath:indexPath];
    cell.selectionStyle                     = UITableViewCellSelectionStyleNone;
    cell.indexPath                          = indexPath;
    cell.dataDic                            = self.allDataArr[indexPath.row];

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WEAKSELF
    switch (indexPath.row) {
        case 0:
        {
    [SharedView shareInstance].currentView  = [UIApplication sharedApplication].keyWindow;
            [[SharedView shareInstance] showWithDuration:0.3];
            [[SharedView shareInstance] addShareSuccess:^{
                [[SharedView shareInstance] resetView];
                [[SharedView shareInstance] getCat];
                [weakSelf showRemendSuccessView:@"分享成功" withBlock:nil];
            } withFail:^{
                [[SharedView shareInstance] resetView];
                [weakSelf showRemendWarningView:@"分享失败" withBlock:nil];
            } withCancel:^{
                [[SharedView shareInstance] resetView];
                [weakSelf showRemendWarningView:@"您取消了分享哦" withBlock:nil];
            }];
        }


            break;
        case 1:
        {

    UserFeedbackVC *vc                      = [[UserFeedbackVC alloc]init];
    vc.hidesBottomBarWhenPushed             = YES;
            [self.navigationController pushViewController:vc animated:YES];


        }
            break;
        case 3:
        {
    SystemUpdateVC *vc                      = [[SystemUpdateVC alloc]init];
    vc.hidesBottomBarWhenPushed             = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }

            break;
        case 2:
        {
    AboutVC *vc                             = [[AboutVC alloc]init];
    vc.hidesBottomBarWhenPushed             = YES;
            [self.navigationController pushViewController:vc animated:YES];

        }

            break;

        default:
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 58;
}

@end
