//
//  KWApplication.swift
//  KIWI
//
//  Created by li zhou on 2019/11/4.
//  Copyright © 2019 li zhou. All rights reserved.
//

import Foundation
import Alamofire

//MARK:类
///RMNetworkRequest的请求配置,在RMNetworkRequest实例的send方法中使用
class KWNetworkRequestConfig : NSObject {
    ///URL类型 不建议直接设置,调用set(url,port,method)进行统一设置
    var urlType : KWNetworkDefine.URL = .none
    
    ///请求方法 不建议直接设置,调用set(url,port,method)进行统一设置
    var method : HTTPMethod = HTTPMethod.post
    
    ///端口 不建议直接设置,调用set(url,port,method)进行统一设置
    var port : String = ""
    
    ///请求头
    var header : HTTPHeaders = [:]
    
    ///不建议直接设置,调用set(paramet,key)进行添加
    var parameters : Parameters = Dictionary<String,Any>()
    
    ///加入一个参数,如果key重复则设置无效
    public func setNull(key : KWNetworkDefine.KEY) {
        if parameters.keys.contains(key.rawValue) {
            return
        }
        parameters[key.rawValue] = nil
    }
    
    ///加入一个参数,如果key重复则设置无效
    public func set(paramet : Any, key : KWNetworkDefine.KEY) {
        if parameters.keys.contains(key.rawValue) {
            return
        }
        parameters[key.rawValue] = paramet
    }
    
    ///设置url 端口号 请求方法
    public func set(urlType : KWNetworkDefine.URL, port : String, method : HTTPMethod) {
        self.urlType = urlType
        self.method = method
        self.port = port
    }
    
    ///加入一个请求头,如果key重复则设置无效
    public func set(head : String, key : KWNetworkDefine.KEY) {
//        if header.keys.contains(key.rawValue) {
//            return
//        }
        header[key.rawValue] = head
    }
    
    //加入一个参数集
    public func set(parameters: Dictionary<String,Any>) {
        for (key,value) in parameters {
            if let k = KWNetworkDefine.KEY(rawValue: key) {
                set(paramet: value, key: k)
            }
        }
    }
}
