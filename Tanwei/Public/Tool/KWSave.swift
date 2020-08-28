//
//  KWApplication.swift
//  KIWI
//
//  Created by li zhou on 2019/11/4.
//  Copyright © 2019 li zhou. All rights reserved.
//

import Foundation

//本地保存的Key
enum KWSaveKey : String {
    case none               = "SAVE_KEY_NONE"
    case uToken             = "SAVE_KEY_U_TOKEN"
    case loginType          = "SAVE_KEY_LOGIN_TYPE"
    case uid                = "SAVE_KEY_UID"
    case account            = "SAVE_KEY_UACCOUNT"
    case userName           = "SAVE_KEY_USERNAME"
    case firstName          = "SAVE_KEY_FIRSTNAME"
    case lastName           = "SAVE_KEY_LASTNAME"
    case gender             = "SAVE_KEY_GENDER"
    case email              = "SAVE_KEY_EMAIL"
    case mobile             = "SAVE_KEY_MOBILE"
    case phone              = "SAVE_KEY_PHONE"
    case birthday           = "SAVE_KEY_BIRTHDAY"
    case location           = "SAVE_KEY_LOCATION"
    case avatar             = "SAVE_KEY_AVATAR"
    case twitter            = "SAVE_KEY_TWITTER"
    case facebook           = "SAVE_KEY_FACEBOOK"
    case other              = "SAVE_KEY_OTHER"
    case desc               = "SAVE_KEY_DESC"
    case status             = "SAVE_KEY_STATUS"
    case createdAt          = "SAVE_KEY_CREATEAT"
    case updatedAt          = "SAVE_KEY_UPDATEAT"
    
    case company            = "SAVE_KEY_company"
    case createTime         = "SAVE_KEY_createTime"
    case label              = "SAVE_KEY_label"
    case password           = "SAVE_KEY_password"
    case website            = "SAVE_KEY_website"
    case userId             = "SAVE_KEY_userId"
    case image              = "SAVE_KEY_IMAGE"
    case cPhone             = "SAVE_KEY_CPHONE"
    case wechatId           = "SAVE_KEY_WECHATID"
    case jobPosition        = "SAVE_KEY_jobPosition"
    case jobDesc            = "SAVE_KEY_jobDesc"
    case commanyAddr        = "SAVE_KEY_commanyAddr"
    
    
    
    case addr               = "SAVE_KEY_Addr"
    case contactPhone       = "SAVE_KEY_contactPhone"
    case imageHead          = "SAVE_KEY_imageHead"
    case userType           = "SAVE_KEY_userType"
    case vipStatus          = "SAVE_KEY_vipStatus"
    case overTime          = "SAVE_KEY_overTime"
}


class KWSave: NSObject {
    fileprivate var value : Any?
    
    init(value : Any) {
        super.init()
        self.value = value
    }
    
    public class func write(value : Any , key : KWSaveKey) {
        if key.rawValue != "" {
            UserDefaults.standard.set("\(value)", forKey: key.rawValue)
            UserDefaults.standard.synchronize()
        } else {
            KWPrint("DDSave.write key is nil!")
        }
    }
    
    public class func read(key : KWSaveKey) ->KWSave {
        if let value = UserDefaults.standard.object(forKey: key.rawValue) {
            let save : KWSave = KWSave(value: value)
            return save
        } else {
            KWPrint("DDSave.read not fount value for key! - \(key.rawValue)")
        }
        return KWSave(value: "")
    }
    
    public class func remove(key : KWSaveKey) {
        if  key.rawValue != "" {
            UserDefaults.standard.removeObject(forKey: key.rawValue)
            UserDefaults.standard.synchronize()
        } else {
            KWPrint("DDSave.remove key is nil!")
        }
    }
}

extension KWSave {
    
    public func strings() -> [String] {
        if let string = value as? [String]  {
            return string
        }else if let strings = value as? [String]? {
            return strings!
        }
        return [""] 
    }
    
    public func string() -> String {
        if let string = value as? String {
            return string
        }
        
        return ""
    }
    
    public func int() -> Int {
        if let number = value as? Int {
            return number
        } else if "" != string() {
            if let number = Int(string()) {
                return number
            }
        }
        return RMNETWORK_DEFAULT_ERROR_CODE
    }
    
    public func int64() -> Int64 {
        if let number = value as? Int64 {
            return number
        } else if "" != string() {
            if let number = Int64(string()) {
                return number
            }
        }
        return RMNETWORK_DEFAULT_ERROR_CODE64
    }
    
    public func interval() -> TimeInterval {
        if let interval = value as? TimeInterval {
            return interval
        } else if let intervalString = value as? String {
            if let interval = Double(intervalString) {
                return interval
            }
        }
        
        return 0.0
    }
    
    public func bool() -> Bool? {
        if let bool = value as? Bool {
            return bool
        } else if let int = value as? Int {
            return int != 0
        } else if let string = value as? String {
            if string == "true" {
                return true
            } else if string == "false"{
                return false
            }
        }
        
        return nil
    }
}
