//
//  KWApplication.swift
//  KIWI
//
//  Created by li zhou on 2019/11/4.
//  Copyright © 2019 li zhou. All rights reserved.
//

import Foundation
import SwiftyJSON


class KWNetworkParse : NSObject {
    
    
}

//MARK:上传图片
extension KWNetworkParse {
//    //图片上传返回的是 error message uploadResultList 而不是data 所以单独解析
//    internal class func multiUpload(value : Any?)->KWNetworkRespond {
//        let respond = KWNetworkRespond()
//
//        if let json = parseValue(value)?.dictionary {
//            respond.statusCode = KWParse.int(json, key: KWNetworkDefine.KEY.statusCode.rawValue)
//            respond.desc   = KWParse.string(json, key: KWNetworkDefine.KEY.description.rawValue)
//            respond.result   = KWParse.string(json, key: KWNetworkDefine.KEY.description.rawValue)
//            if let resultList = json[KWNetworkDefine.KEY.result.rawValue] {
//                respond.result = [KWNetworkDefine.KEY.result.rawValue : resultList]
//            }
//        }
//
//        return respond
//    }
}

//MARK:登录
extension KWNetworkParse {
    ///第一次登录交互的返回解析 - 不是message  error  data 格式 单独解析
    internal class func parseFuzzyRequest(value : Any?) ->KWNetworkRespond {
        let respond = KWNetworkRespond()
        
        if let json = parseValue(value)?.dictionary {
            respond.msg = "not found \"error,message,data\", fuzzy parse!"
            respond.code = 200
            
            for (key,value) in json {
                if key == KWNetworkDefine.KEY.code.rawValue {
                    respond.code = value.intValue
                }
                
                if key == KWNetworkDefine.KEY.msg.rawValue {
                    respond.msg = value.stringValue
                }
                
                if key == KWNetworkDefine.KEY.data.rawValue {
                    respond.data = value.dictionaryValue
                }
            }
        }
        
        return respond
    }
}


/**************** 基础解析 网络请求后直接解析第一层数据 ***************/
///MARK:基础解析 Public
extension KWNetworkParse {
    ///基础解析 - 只提供给 DDNetworkRequest send方法的success返回中使用
    internal class func baseParse(value : Any?) ->KWNetworkRespond {
        return parseToRespond(value: value)
    }
}

///MARK:基础解析 Private
fileprivate extension KWNetworkParse {
    
    ///将服务器返回的data error message 解析成 KWNetworkRespond对象
    class func parseToRespond(value : Any?) ->KWNetworkRespond {
        KWPrint(value ?? [:])
        
        let respond = KWNetworkRespond()
        
        if let json = parseValue(value) {
            respond.code        = int(json: json, key: .code) == RMNETWORK_DEFAULT_ERROR_CODE ? Int(string(json: json, key: .code)) ?? RMNETWORK_DEFAULT_ERROR_CODE : int(json: json, key: .code)
            respond.msg         = string(json: json, key: .msg)
            respond.data        = dictionary(json: json, key: .data)
            respond.resultArray = array(json: json, key: .result)
        }
        
        respond.value = value
        return respond
    }
    
    ///解析返回体
    class func parseValue(_ value : Any?) -> JSON? {
        if value != nil {
            let json = SwiftyJSON.JSON(value!)
            if  json != JSON.null {
                return json
            } else {
                print("KWJsonParse", "KWJsonParse", "json is nil")
                return nil
            }
        } else {
            print("KWJsonParse", "KWJsonParse", "value can not be nil")
            return nil
        }
    }
}

///MARK:KEY Handle
fileprivate extension KWNetworkParse {
    
    ///json.string
    class func string(json : JSON, key : KWNetworkDefine.KEY) -> String {
        if let string = json[key.rawValue].string {
            return string
        }
        return ""
    }
    
    ///json.int
    class func int(json : JSON, key : KWNetworkDefine.KEY) -> Int {
        if let int = json[key.rawValue].int {
            return int
        }
        return RMNETWORK_DEFAULT_ERROR_CODE
    }
    
    ///json.dictionary
    class func dictionary(json : JSON, key : KWNetworkDefine.KEY) -> Dictionary<String, JSON> {
        if let dictionary = json[key.rawValue].dictionary {
            return dictionary
        }
        return Dictionary()
    }
    
    class func array(json : JSON, key : KWNetworkDefine.KEY) -> [JSON] {
        if let array = json[key.rawValue].array {
            return array
        }
        return []
    }
}
