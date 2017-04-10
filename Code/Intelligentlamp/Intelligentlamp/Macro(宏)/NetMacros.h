//
//  NetMacros.h
//  Intelligentlamp
//
//  Created by L on 16/8/26.
//  Copyright © 2016年 L. All rights reserved.
//

#ifndef NetMacros_h
#define NetMacros_h


#endif /* NetMacros_h */

#define HTTPBASEURL       @"http://smartlamp.gooorun.com:8082/uis"

/**
 *  用户信息接口
 */
#define User_Login          @"/user/login" //登录
#define User_Regist         @"/user/regist" //注册/忘记密码
#define User_UploadUserHeadImg          @"/user/uploadUserHeadImg" //上传用户头像
#define User_GetDetailUserInfo          @"/user/getDetailUserInfo" //获取用户详细信息
#define User_Feedback         @"/user/feedback" //用户意见反馈
#define User_UpdateUserInfo         @"/user/updateUserInfo" //用户信息修改

/**
 *  分组接口
 */
#define Group_GetDeviceGroupList           @"/smartlamp/getDeviceGroupList" //获取用户所有分组
#define Group_UploadDeviceGroupHeadImg           @"/smartlamp/uploadDeviceGroupHeadImg" //分组头像上传
#define Group_GetGroupDeviceList           @"/smartlamp/getGroupDeviceList" //获取用户某个分组的所有设备
#define Group_CreateDeviceGroup           @"/smartlamp/createDeviceGroup" //创建分组
#define Group_UpdateDeviceGroup           @"/smartlamp/updateDeviceGroup" //更新分组信息
#define Group_AddDeviceToGroup           @"/smartlamp/addDeviceToGroup" //添加设备进分组
#define Group_DeleteDeviceFromGroup           @"/smartlamp/deleteDeviceFromGroup" //从分组删除设备
#define Group_DeleteGroup           @"/smartlamp/deleteGroup" //删除分组
/**
 *  场景接口
 */
#define Group_GetSceneList           @"/smartlamp/getSceneList" //获取用户所有场景
#define Group_UploadSceneHeadImg           @"/smartlamp/uploadSceneHeadImg" //场景头像上传
#define Group_UpdateSceneInfo           @"/smartlamp/updateSceneInfo" //更新场景信息
#define Group_CreateDeviceScene           @"/smartlamp/createDeviceScene" //创建场景
#define Group_AddDeviceToScene          @"/smartlamp/addDeviceToScene" //添加设备进场景
#define Group_GetSceneDeviceList           @"/smartlamp/getSceneDeviceList" //获取用户某个场景的详细信息
#define Group_DeleteDeviceFromScene          @"/smartlamp/deleteDeviceFromScene" //从场景删除设备
#define Group_DeleteScene          @"/smartlamp/deleteScene" //删除场景
/**
 *  获取设备品牌列表
 */

#define Brand_GetBrandList           @"/smartlamp/getBrandList" //获取灯泡品牌
#define Brand_UploadDeviceHeadImg           @"/smartlamp/uploadDeviceHeadImg" //上传灯泡头像

/**
 *  获取我的所有设备列表
 */

#define Brand_getMyDeviceList           @"/smartlamp/getMyDeviceList" //获取我的所有设备列表
#define Brand_GetQueryLampInfo           @"/smartlamp/queryLampInfo" //查询灯泡详细信息
#define Brand_UpdateLampInfo           @"/smartlamp/updateLampInfo" //更新灯泡信息接口
#define Brand_DeleteDevice          @"/smartlamp/deleteDevice" //删除设备
#define Brand_AddSmartDevice          @"/smartlamp/addSmartDevice" //添加设备

















