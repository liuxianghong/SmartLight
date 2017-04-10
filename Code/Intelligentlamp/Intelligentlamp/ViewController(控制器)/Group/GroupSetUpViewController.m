//
//  GroupSetUpViewController.m
//  Intelligentlamp
//
//  Created by L on 16/8/20.
//  Copyright © 2016年 L. All rights reserved.
//分组设置页面

#import "GroupSetUpViewController.h"
#import "GroupSetUpVCHeaderView.h"
#import "ImageSelector.h"
#import "UIView+Progress.h"
#import "GroupNameSetUpCell.h"
#import "GroupSetUpNameViewController.h"
#import "AllGroupModel.h"
#import "MineListTableviewCell.h"

@interface GroupSetUpViewController()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) UITableView *tableView;//列表
@property (nonatomic ,strong) NSMutableArray *allDataArr;//列表数据源
@property (nonatomic ,strong) GroupSetUpVCHeaderView *headerView;//头部

@property (nonatomic ,strong) NSMutableArray *arr;


@end

@implementation GroupSetUpViewController

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

- (NSMutableArray *)arr{
    if (!_arr) {
        _arr = [NSMutableArray array];
    }
    return _arr;
}

- (void)initDataArr{
    NSArray *nameArr                        = @[@"分组昵称",@"分组描述",@"删除分组"];
    NSArray *imageArr                       = @[ @"groups",@"light_bulb_description",@"bin_available"];
    
    for (NSInteger i                        = 0; i < nameArr.count; i++) {
        NSMutableDictionary *dic                = [NSMutableDictionary dictionary];
        [dic setObject:nameArr[i] forKey:@"name"];
        [dic setObject:imageArr[i] forKey:@"image"];
        [self.arr addObject:dic];
    }
}

- (void)viewDidLoad{
    WEAKSELF
    [super viewDidLoad];
     [self initDataArr];
    
    [self setTitleViewWithStr:_model.groupTitle];

    [self layoutUI];

    [self setTableID];

    [self leftBarButtonItem:[UIImage imageNamed:@"BackArrow"] withClickBtnAction:^{
        [weakSelf upDateGroup];
    }];
    
   
}

/**
 *  更新分组信息
 */
- (void)upDateGroup{

    NSMutableDictionary *dic                = [NSMutableDictionary dictionary];
    [dic setValue:@"1.0.0" forKey:@"version"];
    [dic setValue:getUserId() forKey:@"userId"];
    [dic setValue:getUserToken() forKey:@"token"];
    [dic setValue:_model.groupImg forKey:@"groupLogoURL"];
    [dic setValue:_model.groupTitle forKey:@"groupName"];
    [dic setValue:_model.groupDescribe forKey:@"description"];
    [dic setValue:_model.groupOpenTime forKey:@"timingOpenTime"];
    [dic setValue:_model.groupCloseTime forKey:@"timingCloseTime"];
    [dic setValue:_model.groupId forKey:@"groupId"];
    [dic setValue:@"0" forKey:@"timingOn"];
    [dic setValue:@"" forKey:@"randomOn"];


    if ([LXNetworking sharedLXNetworking].networkStats == StatusNotReachable) {
        [self showRemendWarningView:@"没有网络" withBlock:nil];

    }else{

        [self showNetWorkView];


        [LXNetworking postWithUrl:Group_UpdateDeviceGroup params:dic success:^(id response) {
            [self hideNetWorkView];

            [self showRemendSuccessView:@"修改成功" withBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];

        } fail:^(NSError *error) {
            [self hideNetWorkView];
            [self showRemendWarningView:@"修改失败" withBlock:nil];

        } showHUD:nil];

    }

}
- (void)layoutUI{
    _tableView                              = [[UITableView alloc]init];
    _tableView.backgroundColor              = [UIColor clearColor];
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    //添加头部
    _headerView                             = [[GroupSetUpVCHeaderView alloc]init];
    _tableView.tableHeaderView              = _headerView;
    [_headerView layoutHeaderView];
    CGFloat height2                         = [_headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + _headerView.frame.origin.y;
    CGRect headerFrame                      = _headerView.frame;
    headerFrame.size.height                 = height2;
    _headerView.frame                       = headerFrame;

    _headerView.iconImg.image               = [UIImage imageNamed:@"group_avatar"];
    _headerView.icon                        = _model.groupImg;
    [self.tableView setTableHeaderView:_headerView];


    WEAKSELF
    _headerView.changeIconBlock             = ^(){
        //更换头像
        [[ImageSelector selector] selectorAvatarAtControlloer:weakSelf afterSelect:^(NSArray *images) {
            [weakSelf.headerView.iconImg setImage:images[0]];


    NSMutableDictionary *dic                = [NSMutableDictionary dictionary];
            [dic setValue:@"1.0.0" forKey:@"version"];
            [dic setValue:getUserId() forKey:@"userId"];
            [dic setValue:getUserToken() forKey:@"token"];
            [dic setValue:weakSelf.model.groupId forKey:@"deviceGroupId"];//分组ID，创建分组时传空


            if ([LXNetworking sharedLXNetworking].networkStats == StatusNotReachable) {
                [weakSelf showRemendWarningView:@"没有网络" withBlock:nil];


            }else{

                [weakSelf showNetWorkView];

                [LXNetworking uploadWithImage:images[0] url:Group_UploadDeviceGroupHeadImg filename:@"Group.png" name:@"headImgFile" params:dic progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {


                } success:^(id response) {
                    [weakSelf showRemendSuccessView:@"上传成功" withBlock:nil];

    weakSelf.model.groupImg                 = response[@"fileURL"];

                    [weakSelf hideNetWorkView];

                } fail:^(NSError *error) {

                    [weakSelf showRemendWarningView:@"上传失败" withBlock:nil];
                    [weakSelf hideNetWorkView];

                } showHUD:nil];

            }

        }];

    };



    self.tableView.delegate                 = self;
    self.tableView.dataSource               = self;
    self.tableView.separatorStyle           = UITableViewCellSeparatorStyleNone;
}

- (void)setTableID{
//    [self.tableView registerClass:[GroupNameSetUpCell class] forCellReuseIdentifier:NSStringFromClass([GroupNameSetUpCell class])];
      [self.tableView registerClass:[MineListTableviewCell class] forCellReuseIdentifier:NSStringFromClass([MineListTableviewCell class])];
}

#pragma - mark UITableViewDelegate and DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    GroupNameSetUpCell *cell                = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GroupNameSetUpCell class]) forIndexPath:indexPath];
//    cell.selectionStyle                     = UITableViewCellSelectionStyleNone;
//
//    if (indexPath.row == 0) {
//    cell.title                              = _model.groupTitle;
//    }else if (indexPath.row == 1){
//    cell.title                              = _model.groupDescribe;
//    }else if (indexPath.row == 2){
//    cell.title                              = @"删除分组";
//    }
//
//    return cell;
    
    MineListTableviewCell *cell             = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MineListTableviewCell class]) forIndexPath:indexPath];
    cell.selectionStyle                     = UITableViewCellSelectionStyleNone;
    cell.indexPath                          = indexPath;
    cell.dataDic                            = self.arr[indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 61;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WEAKSELF
    GroupSetUpNameViewController *vc        = [[GroupSetUpNameViewController alloc]init];
    if (indexPath.row == 0) {
    vc.titleStr                             = @"分组名称";
    vc.content                              = _model.groupTitle;
    vc.changeContentBlock                   = ^(NSString *str){
//    GroupNameSetUpCell *cell                = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GroupNameSetUpCell class]) forIndexPath:indexPath];
//    cell.selectionStyle                     = UITableViewCellSelectionStyleNone;
//    cell.title                              = str;
    weakSelf.model.groupTitle               = str;
        };

    }else if (indexPath.row == 1){
    vc.titleStr                             = @"分组描述";
    vc.content                              = _model.groupDescribe;

    vc.changeContentBlock                   = ^(NSString *str){
//    GroupNameSetUpCell *cell                = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GroupNameSetUpCell class]) forIndexPath:indexPath];
//    cell.selectionStyle                     = UITableViewCellSelectionStyleNone;
//    cell.title                              = str;
    weakSelf.model.groupDescribe            = str;
        };
    }else if (indexPath.row == 2){
        //初始化提示框；
    UIAlertController *alert                = [UIAlertController alertControllerWithTitle:@"" message:@"确定删除该分组?" preferredStyle:  UIAlertControllerStyleAlert];

    UIAlertAction *cancelAction             = [UIAlertAction actionWithTitle:@"取消"style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancelAction];

        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

            [self deleteGroup];

        }]];

        //弹出提示框；
        [weakSelf presentViewController:alert animated:true completion:nil];

    }
    vc.hidesBottomBarWhenPushed             = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  删除分组
 */
- (void)deleteGroup{
    NSMutableArray *arr                     = [NSMutableArray array];
    [arr addObject:_model.groupId];
    NSMutableDictionary *dic                = [NSMutableDictionary dictionary];
    [dic setValue:@"1.0.0" forKey:@"version"];
    [dic setValue:getUserId() forKey:@"userId"];
    [dic setValue:getUserToken() forKey:@"token"];
    [dic setValue:arr forKey:@"groupList"];


    if ([LXNetworking sharedLXNetworking].networkStats == StatusNotReachable) {
        [self showRemendWarningView:@"没有网络" withBlock:nil];

    }else{

        [self showNetWorkView];


        [LXNetworking postWithUrl:Group_DeleteGroup params:dic success:^(id response) {
            [self hideNetWorkView];

            [self showRemendSuccessView:@"删除成功" withBlock:^{
                if (self.deleteBlock) {
                    self.deleteBlock();
                }
                [self.navigationController popViewControllerAnimated:YES];
            }];

        } fail:^(NSError *error) {
            [self hideNetWorkView];

            [self showRemendWarningView:@"删除失败" withBlock:nil];
        } showHUD:nil];

    }

}
@end

