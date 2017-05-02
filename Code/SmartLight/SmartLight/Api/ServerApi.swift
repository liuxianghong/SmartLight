//
//  ServerApi.swift
//  RXS
//
//  Created by 刘向宏 on 2017/4/24.
//  Copyright © 2017年 刘向宏. All rights reserved.
//

import UIKit
import Alamofire
import YYKit

class ServerApi: NSObject {
    
    class func getCaptcha(mobile: String, complet: @escaping ((ServerResult) -> ())) {
        let param = ["version": "1.0.0"
            , "email": mobile
            , "userSource": "2"]
        ServerApi.request(url: "http://gaoyi.gooorun.com:8282/uis/user/getCaptcha", parameters: param) { (result) in
            let model = ServerResult()
            model.modelSet(withJSON: result ?? "")
            complet(model)
        }
    }
    
    class func login(loginName: String, password: String, complet: @escaping ((ServerLoginResult) -> ())) {
        let param: [String : Any] = ["version": "1.0.0"
            , "loginName": loginName
            , "password": password.md5String()
            , "platform": 2
            , "userSource": 2]
        ServerApi.request(url: "http://gaoyi.gooorun.com:8282/uis/user/login", parameters: param) { (result) in
            let model = ServerLoginResult()
            model.modelSet(withJSON: result ?? "")
            complet(model)
        }
    }
    
    class func regist(loginName: String, password: String, captcha: String, complet: @escaping ((ServerLoginResult) -> ())) {
        let param: [String : Any] = ["version": "1.0.0"
            , "loginName": loginName
            , "password": password.md5String()
            , "platform": 2
            , "userSource": 2
            , "captcha": captcha
            , "appPackageName": "com.smart.light"
            , "operateType": 1]
        ServerApi.request(url: "http://gaoyi.gooorun.com:8282/uis/user/regist", parameters: param) { (result) in
            let model = ServerLoginResult()
            model.modelSet(withJSON: result ?? "")
            complet(model)
        }
    }
    
    class func getHomeDeviceList(userId: String, token: String, complet: @escaping ((ServerHomeDeviceResult) -> ())) {
        let param: [String : Any] = ["version": "1.0.0"
            , "userId": userId
            , "token": token
            , "homeId": "0"
            , "pageNo": 1
            , "pageSize": 10000]
        ServerApi.request(url: "http://gaoyi.gooorun.com:8282/uis/smartHome/getHomeDeviceList", parameters: param) { (result) in
            //print(result)
            //let rr = "{\"retCode\":\"0\",\"retMsg\":\"成功\",\"homeDeviceList\":[{\"deviceId\":\"1\"},{\"deviceId\":\"2\"}]}"
            let model = ServerHomeDeviceResult()
            model.modelSet(withJSON: result ?? "")
            complet(model)
        }
    }
    
    class func addSmartLamp(userId: String, token: String,devices: [(String, String)], complet: @escaping ((ServerResult) -> ())) {
    
        var list = [[String: String]]()
        for device in devices {
            list.append(["deviceName": device.0, "hardwareId": device.1])
        }
        let param: [String : Any] = ["version": "1.0.0"
            , "userId": userId
            , "token": token
            , "homeId": "0"
            , "deviceList": list]
        ServerApi.request(url: "http://gaoyi.gooorun.com:8282/uis/smartHome/addSmartLamp", parameters: param) { (result) in
            //print(result)
            let model = ServerResult()
            model.modelSet(withJSON: result ?? "")
            complet(model)
        }
    }
    
    class func request(url: String, parameters: [String: Any]? = nil, complet: @escaping ((String?) -> ())) {
        let url = URL(string: url)
        Alamofire.request(url!, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseString { (respon) in
            complet(respon.value)
        }
    }
}

