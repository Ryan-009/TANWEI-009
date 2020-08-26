//
//  KWApplication.swift
//  KIWI
//
//  Created by li zhou on 2019/11/4.
//  Copyright © 2019 li zhou. All rights reserved.
//

import Foundation

import SwiftyJSON

class KWParse : NSObject {
    
}

//MARK : Dictionary<String, Any>
extension KWParse {
    
    public class func cgfloat(_ dictionary : Dictionary<String, Any>, key : String) -> CGFloat {
        return CGFloat(double(dictionary, key: key))
    }
    
    ///将字典中的某个Double取出
    public class func double(_ dictionary : Dictionary<String, Any>, key : String) -> Double {
        if let double = dicValue(dictionary, key: key) as? Double {
            return double
        } else if let double = jsonValue(dictionary, key: key)?.double {
            return double
        }
        return Double.greatestFiniteMagnitude
    }
    
    ///将字典中的某个字典取出
    public class func dictionary(_ dictionary : Dictionary<String, Any>, key : String) ->Dictionary<String,Any> {
        if let dictionary = dicValue(dictionary, key: key) as? Dictionary<String,Any> {
            return dictionary
        } else if let dictionary = jsonValue(dictionary, key: key)?.dictionary {
            return dictionary
        }
        return Dictionary()
    }
    
    ///将字典中的某个JSON数组取出
    public class func array(_ dictionary : Dictionary<String, Any>, key : String) ->Array<JSON> {
        if let array = jsonValue(dictionary, key: key)?.array {
            return array
        }
        return Array()
    }
    
    ///将字典中的某个String取出
    public class func string(_ dictionary : Dictionary<String, Any>, key : String) ->String {
        if let string = dicValue(dictionary, key: key) as? String {
            return string
        } else if let string = jsonValue(dictionary, key: key)?.string {
            return string
        }
        return ""
    }
    
    ///将字典中的某个Int取出
    public class func int(_ dictionary : Dictionary<String, Any>, key : String) -> Int {
        if let number = dicValue(dictionary, key: key) as? Int {
            return number
        } else if let number = jsonValue(dictionary, key: key)?.int {
            return number
        } else if let string = dicValue(dictionary, key: key) as? String {
            if let number = Int(string) {
                return number
            }
        }
        return RMNETWORK_DEFAULT_ERROR_CODE
    }
    
    ///将字典中的某个Int32取出
    public class func uint32(_ dictionary : Dictionary<String, Any>, key : String) -> UInt32 {
        if let number = dicValue(dictionary, key: key) as? UInt32 {
            return number
        } else if let number = jsonValue(dictionary, key: key)?.uInt32 {
            return number
        } else if let string = dicValue(dictionary, key: key) as? String {
            if let number = UInt32(string) {
                return number
            }
        }else if let number = jsonValue(dictionary, key: key)?.string {
            if let number = UInt32(number) {
                return number
            }
        }
        return RMNETWORK_DEFAULT_ERROR_CODEU32
    }
    
    
    ///将字典中的某个Int64取出
    public class func int64(_ dictionary : Dictionary<String, Any>, key : String) -> Int64 {
        if let number = dicValue(dictionary, key: key) as? Int64 {
            return number
        } else if let number = jsonValue(dictionary, key: key)?.int64 {
            return number
        }
        return Int64.min
    }
    
    ///将字典中的某个data取出
    public class func data(_ dictionary : Dictionary<String, Any>, key : String) -> Data {
        if let data = dicValue(dictionary, key: key) as? Data {
            return data
        }
        return Data()
    }
    
    
    ///将字符串变成字典
    public class func stringToDictionary(_ string : String) ->Dictionary<String,Any> {
        if let json = JSON(parseJSON: string).dictionary {
            return json
        }
        return Dictionary()
    }
    
    ///将字典转换成字符串
    public class func dictionaryToString(_ dictionary : Dictionary<String, Any>) ->String {
        
        let jsonData : Data =  try! JSONSerialization.data(withJSONObject: dictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
        
        if let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) {
            return jsonString
        }
        
        return ""
    }
    
    public class func jsonToString(json: JSON) -> String{
        do{

            let data = try JSONEncoder().encode(json)

            return String(data: data, encoding:String.Encoding.utf8)!

        }catch{
            return ""
        }
    }
}

//MARK: 底层解析，将字典中的某个Key对应去取出为Any或JSON类型
extension KWParse {
    /****************************************** BASE ******************************************/
    
    //将字典中的某个key对应的value取出
    fileprivate class func dicValue(_ dictionary : Dictionary<String, Any>, key : String) ->Any? {
        if dictionary.keys.contains(key) {
            return dictionary[key]
        }
        return nil
    }
    
    //将JSON中的某个key对应的value取出
    fileprivate class func jsonValue(_ dictionary : Dictionary<String, Any>, key : String) ->JSON? {
        
        if let json = dicValue(dictionary, key: key) as? JSON {
            return json
        }
        
        return nil
    }
}
