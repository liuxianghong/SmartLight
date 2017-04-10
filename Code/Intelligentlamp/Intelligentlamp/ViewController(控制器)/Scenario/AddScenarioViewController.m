//
//  AddScenarioViewController.m
//  Intelligentlamp
//
//  Created by L on 16/8/25.
//  Copyright © 2016年 L. All rights reserved.
//

#define AllBulbDescribeColor HEXCOLOR(0x8c8c8e)
#define AllBulbLineColor HEXCOLOR(0x19181b)
#import "GroupSetUpVCHeaderView.h"
#import "ImageSelector.h"
#import "UIView+Progress.h"
#import "GroupNameSetUpCell.h"
#import "GroupSetUpNameViewController.h"
#import "GroupLampModel.h"
#import "SelectLampCell.h"
#import "GroupSetUpTimeViewController.h"
#import "AddScenarioViewController.h"
#import "AllLightSetUpViewController.h"
#import "AllSimpleLightSetUpViewController.h"
#import "AllScenarioModel.h"

@interface AddScenarioViewController()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) UITableView *tableView;//列表
@property (nonatomic ,strong) NSMutableArray *allDataArr;//列表数据源
@property (nonatomic ,strong) GroupSetUpVCHeaderView *headerView;//头部
@property (nonatomic ,strong) NSMutableArray *selectLampArr;//选中的灯泡

@property (nonatomic ,strong) AllScenarioModel *model;


@end

@implementation AddScenarioViewController

#pragma -mark ViewController 生命周期函数

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

    _model                                  = [[AllScenarioModel alloc]init];
    _selectLampArr                          = [NSMutableArray array];

    [self setTitleViewWithStr:@"创建场景"];

    [self initDataArr];

    [self layoutUI];

    [self setTableID];

    [self leftBarButtonItem:[UIImage imageNamed:@"BackArrow"] withClickBtnAction:^{

        [self.navigationController popViewControllerAnimated:YES];
    }];

    [self rightBarButtonItemWithTitle:@"确定" withClickBtnAction:^{

        [self addNewScenario];
    }];
}

/**
 *  创建场景
 */
- (void)addNewScenario{

    NSArray *arr                            = @[];
    NSMutableDictionary *dic                = [NSMutableDictionary dictionary];
    [dic setValue:@"1.0.0" forKey:@"version"];
    [dic setValue:getUserId() forKey:@"userId"];
    [dic setValue:getUserToken() forKey:@"token"];
    [dic setValue:_model.ScenarioImg forKey:@"sceneLogoURL"];
    [dic setValue:_model.ScenarioTitle forKey:@"sceneName"];
    [dic setValue:_model.ScenarioDescribe forKey:@"description"];
    [dic setValue:_model.ScenarioOpenTime forKey:@"timingOpenTime"];
    [dic setValue:_model.ScenarioCloseTime forKey:@"timingCloseTime"];
    [dic setValue:[NSString stringWithFormat:@"%d",_model.ScenarioTimingOn] forKey:@"timingOn"];
    [dic setValue:[NSString stringWithFormat:@"%d",_model.ScenarioRandomOn] forKey:@"randomOn"];
    [dic setValue:arr forKey:@"deviceList"];


    if ([LXNetworking sharedLXNetworking].networkStats == StatusNotReachable) {
        [self showRemendWarningView:@"没有网络" withBlock:nil];

    }else{

        [self showNetWorkView];


        [LXNetworking postWithUrl:Group_CreateDeviceScene params:dic success:^(id response) {
            [self hideNetWorkView];

            [self showRemendSuccessView:@"创建成功" withBlock:^{
                if (self.refreshBlock) {
                    self.refreshBlock();
                }
                [self.navigationController popViewControllerAnimated:YES];
            }];

        } fail:^(NSError *error) {
            [self hideNetWorkView];

            [self showRemendWarningView:@"创建失败" withBlock:nil];
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
    _headerView.iconImg.image               = [UIImage imageNamed:@"scene_avatar"];
    [self.tableView setTableHeaderView:_headerView];


    WEAKSELF
    _headerView.changeIconBlock             = ^(){
        //更换头像
        
        [[ImageSelector selector] showSelectorAtControlloer:weakSelf type:ImageSelectorTypeCameraAndAlbum allowEditing:NO afterSelect:^(NSArray *images) {
            [weakSelf.headerView.iconImg setImage:images[0]];
            
            NSMutableDictionary *dic                = [NSMutableDictionary dictionary];
            [dic setValue:@"1.0.0" forKey:@"version"];
            [dic setValue:getUserId() forKey:@"userId"];
            [dic setValue:getUserToken() forKey:@"token"];
            [dic setValue:@"" forKey:@"sceneId"];//场景ID，创建场景时传空
            
            
            if ([LXNetworking sharedLXNetworking].networkStats == StatusNotReachable) {
                [weakSelf showRemendWarningView:@"没有网络" withBlock:nil];
                
                
            }else{
                
                [weakSelf showNetWorkView];
                
                [LXNetworking uploadWithImage:images[0] url:Group_UploadSceneHeadImg filename:@"Scenario.png" name:@"headImgFile" params:dic progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
                    
                    
                } success:^(id response) {
                    [weakSelf showRemendSuccessView:@"上传成功" withBlock:nil];
                    
                    weakSelf.model.ScenarioImg              = response[@"headImgFileURL"];
                    
                    [weakSelf hideNetWorkView];
                    
                } fail:^(NSError *error) {
                    
                    [weakSelf showRemendWarningView:@"上传失败" withBlock:nil];
                    [weakSelf hideNetWorkView];
                    
                } showHUD:nil];
                
            }
 
        }];
//        [[ImageSelector selector] selectorAvatarAtControlloer:weakSelf afterSelect:^(NSArray *images) {
//            [weakSelf.headerView.iconImg setImage:images[0]];
//
//    NSMutableDictionary *dic                = [NSMutableDictionary dictionary];
//            [dic setValue:@"1.0.0" forKey:@"version"];
//            [dic setValue:getUserId() forKey:@"userId"];
//            [dic setValue:getUserToken() forKey:@"token"];
//            [dic setValue:@"" forKey:@"sceneId"];//场景ID，创建场景时传空
//
//
//            if ([LXNetworking sharedLXNetworking].networkStats == StatusNotReachable) {
//                [weakSelf showRemendWarningView:@"没有网络" withBlock:nil];
//
//
//            }else{
//
//                [weakSelf showNetWorkView];
//
//                [LXNetworking uploadWithImage:images[0] url:Group_UploadSceneHeadImg filename:@"Scenario.png" name:@"headImgFile" params:dic progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
//
//
//                } success:^(id response) {
//                    [weakSelf showRemendSuccessView:@"上传成功" withBlock:nil];
//
//    weakSelf.model.ScenarioImg              = response[@"headImgFileURL"];
//
//                    [weakSelf hideNetWorkView];
//
//                } fail:^(NSError *error) {
//
//                    [weakSelf showRemendWarningView:@"上传失败" withBlock:nil];
//                    [weakSelf hideNetWorkView];
//
//                } showHUD:nil];
//
//            }
//        }];


    };


    self.tableView.delegate                 = self;
    self.tableView.dataSource               = self;
    self.tableView.separatorStyle           = UITableViewCellSeparatorStyleNone;
}

- (void)setTableID{
    [self.tableView registerClass:[GroupNameSetUpCell class] forCellReuseIdentifier:NSStringFromClass([GroupNameSetUpCell class])];
    [self.tableView registerClass:[SelectLampCell class] forCellReuseIdentifier:NSStringFromClass([SelectLampCell class])];
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
    if (indexPath.section == 0) {
    GroupNameSetUpCell *cell                = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GroupNameSetUpCell class]) forIndexPath:indexPath];
    cell.selectionStyle                     = UITableViewCellSelectionStyleNone;

        switch (indexPath.row) {
            case 0:
    cell.title                              = @"场景名称";
                break;

            case 1:
    cell.title                              = @"场景描述";
                break;

            case 2:
    cell.title                              = @"定时开关";
                break;

            case 3:
    cell.title                              = @"本场景灯光设置";
                break;
            default:
                break;
        }
        return cell;

    }else if (indexPath.section == 1){
    SelectLampCell *cell                    = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SelectLampCell class]) forIndexPath:indexPath];
    cell.selectionStyle                     = UITableViewCellSelectionStyleNone;

    cell.indexPath                          = indexPath;

    GroupLampModel *model                   = _allDataArr[indexPath.row];
    cell.model                              = model;

    cell.selectBlock                        = ^(NSIndexPath *index){

            [_selectLampArr addObject:index];

        };

        return cell;

    }

    return nil;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 61;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 40;
    }
    return 0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
    UIView *view                            = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth,39)];
    view.backgroundColor                    = AllCellBgColor;
    UILabel *label                          = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 39)];
    label.text                              = @"    选择灯泡";
    label.font                              = [UIFont systemFontOfSize:15];
    label.textColor                         = AllBulbDescribeColor;
        [view addSubview:label];

    UILabel *label2                         = [[UILabel alloc]initWithFrame:CGRectMake(0, 39, ScreenWidth, 1)];
    label.backgroundColor                   = AllBulbLineColor;
        [view addSubview:label2];

        return view;

    }
    return nil;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WEAKSELF
    GroupSetUpNameViewController *vc        = [[GroupSetUpNameViewController alloc]init];
    if (indexPath.section == 0) {

        if (indexPath.row == 0) {
    vc.titleStr                             = @"场景名称";
    vc.content                              = _model.ScenarioTitle;
    vc.changeContentBlock                   = ^(NSString *str){
    GroupNameSetUpCell *cell                = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GroupNameSetUpCell class]) forIndexPath:indexPath];
    cell.selectionStyle                     = UITableViewCellSelectionStyleNone;
    cell.title                              = str;
    weakSelf.model.ScenarioTitle            = str;
            };

    vc.hidesBottomBarWhenPushed             = YES;
            [self.navigationController pushViewController:vc animated:YES];

        }else if (indexPath.row == 1){
    vc.titleStr                             = @"场景描述";
    vc.content                              = _model.ScenarioDescribe;

    vc.changeContentBlock                   = ^(NSString *str){
    GroupNameSetUpCell *cell                = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GroupNameSetUpCell class]) forIndexPath:indexPath];
    cell.selectionStyle                     = UITableViewCellSelectionStyleNone;
    cell.title                              = str;
    weakSelf.model.ScenarioDescribe         = str;

            };

    vc.hidesBottomBarWhenPushed             = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row == 2){

    GroupSetUpTimeViewController *vc        = [[GroupSetUpTimeViewController alloc]init];
    vc.hidesBottomBarWhenPushed             = YES;
    vc.model                                = _model;
    vc.scenarioSetUpBlock                   = ^(AllScenarioModel *allModel){
    _model                                  = allModel;
            };
            [self.navigationController pushViewController:vc animated:YES];

        }else if (indexPath.row == 3){

    AllSimpleLightSetUpViewController *vc   = [[AllSimpleLightSetUpViewController alloc]init];
    vc.hidesBottomBarWhenPushed             = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }


    }else if (indexPath.section == 1){

    }

}

- (void)initDataArr{
    NSArray *nameArr                        = @[@"灯泡名称",@"灯泡名称",@"灯泡名称",@"灯泡名称"];
    NSArray *imageArr                       = @[ @"mine_shetuan",@"mine_huodong",@"mine_haoyou",@"mine_shoucang"];

    for (NSInteger i                        = 0; i < nameArr.count; i++) {
    GroupLampModel *model                   = [[GroupLampModel alloc]init];
    model.lampName                          = nameArr[i];
    model.lampImg                           = imageArr[i];
        [self.allDataArr addObject:model];
    }
}

- (NSMutableArray *)allDataArr{
    if (_allDataArr == nil) {
    _allDataArr                             = [NSMutableArray array];
    }
    return _allDataArr;
}

@end



