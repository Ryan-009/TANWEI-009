//
//  KWApplication.swift
//  KIWI
//
//  Created by li zhou on 2019/11/4.
//  Copyright © 2019 li zhou. All rights reserved.
//

import Foundation
class KWUserInfoBase: NSObject {
    
    override init() {
        super.init()
    }
    
    public func loadData() {
        readLocal()
        updateListenerPost()
    }
    
    public func updateDate(data : Dictionary<String, Any>) {
        writeLocal(data: data)
        readLocal()
        updateListenerPost()
    }
    
    public func clearData() {
        cleaDDember()
        clearLocal()
        updateListenerPost()
    }
    
    internal func updateListenerPost() {}
    
    internal func convertToSaveKey(key : String) -> KWSaveKey {
        return .none
    }
    
    internal func attributeList()->[String] {

        var result = [String]()
        let count : UnsafeMutablePointer<UInt32> = UnsafeMutablePointer<UInt32>.allocate(capacity: 0)
        let buff = class_copyPropertyList(object_getClass(self), count)
        let countInt = Int(count[0])
        
        for i in 0..<countInt {
            guard let temp = buff?[i] else {
                continue
            }
            
            let tempPro = property_getName(temp)
            let proper = String(cString: tempPro)
            result.append(proper)
        }
        
        return result
    }
}

//MARK : 持久化
extension KWUserInfoBase {
    //写到本地
    fileprivate func writeLocal(data : Dictionary<String, Any>) {
        for (key, value) in data {
            write(key: key, value: value)
        }
    }
    
    //从本地读取
    fileprivate func readLocal() {
        let attributes = attributeList()
        for attrubute in attributes {
            let saveKey = convertToSaveKey(key: attrubute)
            let value = KWSave.read(key: saveKey).string()
            setValue(value, forKey: attrubute)
        }
    }
    
    //本地持久化
    fileprivate func write(key : String, value : Any) {
        let savekey = convertToSaveKey(key: key)
        if  savekey != .none {
            KWSave.write(value: value, key: savekey)
        } else {
            KWPrint("DDUser writeToLocal key error! - error key : \(key)")
        }
    }
}

//MARK : 清除数据
extension KWUserInfoBase {
    
    fileprivate func cleaDDember() {
        let attrubutes = attributeList()
        for attrubute in attrubutes {
            setValue("", forKey: attrubute)
        }
    }
    
    fileprivate func clearLocal() {
        let attrubutes = attributeList()
        for attrubute in attrubutes {
            write(key: attrubute, value: "")
        }
    }
}

//MARK : 支持方法
extension KWUserInfoBase {
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        KWPrint("found undefined key!")
    }
}

//MARK:枚举
extension KWUserInfoBase {
    
    //是否是vip - isVip
    enum genderType : Int {
        case unknow = 0
        case man    = 1
        case women  = 2
        
        init(rawValue : Int) {
            if rawValue == 1 {
                self = .man
            } else if rawValue == 2 {
                self = .women
            } else {
                self = .unknow
            }
        }
    }
    
    enum statusType : Int {
        case unknow = 99
        case forbid = 0
        case normal = 1
        
        init(rawValue:Int) {
            if rawValue == 0 {
                self = .forbid
            } else if rawValue == 1 {
                self = .normal
            }else{
                self = .unknow
            }
        }
    }
    
    //"是否为管理员 0：不是 1：是"
    enum isManagerType : String{
        case unknow = ""
        case no     = "0"
        case yes    = "1"
        
        init(rawValue:String) {
            if rawValue == "0" {
                self = .no
            } else if rawValue == "1" {
                self = .yes
            }else{
                self = .unknow
            }
        }
    }
}
