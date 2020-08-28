//
//  KWApplication.swift
//  KIWI
//
//  Created by li zhou on 2019/11/4.
//  Copyright © 2019 li zhou. All rights reserved.
//

import Foundation
import SwiftyJSON
//MARK:类
class KWUserInfo : KWUserInfoBase {
    
    //Attribute
//    @objc var account           : String = ""
//    @objc var userName          : String = ""
//    @objc var firstName         : String = ""
//    @objc var lastName          : String = ""
//    @objc var email             : String = ""
//    @objc var mobile            : String = ""
//    @objc var phone             : String = ""
//    @objc var birthday          : String = ""
//    @objc var location          : String = ""
//    @objc var avatar            : String = ""
//    @objc var twitter           : String = ""
//    @objc var facebook          : String = ""
//    @objc var other             : String = ""
//    @objc var desc              : String = ""
//    @objc var createdAt         : String = ""
//    @objc var updatedAt         : String = ""
//    var gender                  : genderType = .unknow
//    var status                  : statusType = .unknow
    
    @objc var company           : String = ""
    @objc var createTime        : String = ""
    @objc var label             : String = ""
    @objc var location          : String = ""
    @objc var password          : String = ""
    @objc var website           : String = ""
//    @objc var userName          : String = ""
    @objc var phone             : String = ""
    @objc var userId            : Int    = 0
    @objc var image             : String  = ""
//    @objc var wechatId          : String  = ""
    @objc var cPhone            : String  = ""
    @objc var jobPosition       : String  = ""
    @objc var jobDesc           : String  = ""
    @objc var commanyAddr       : String  = ""
    @objc var email             : String  = ""
 
    
    //---------------------Tanwei--------------------//
    @objc var addr                  : String = ""
    @objc var contactPhone          : String = ""
    @objc var imageHead             : String = ""
    @objc var userName              : String = ""
    @objc var userType              : Int    = 0
    @objc var wechatId              : String = ""
    @objc var vipStatus              : Int    = 0
    @objc var overTime              : String = ""
    
    public func upload(info : Dictionary<String, Any> , result: @escaping (_ result : KWNetworkError.ErrorType)->()) {
        KWNetwork.updateUserBaseMsg(parameters: info, resendConfig: nil, success: { (respond) in
            let dataInfo = info
            KWUser.userInfo.updateDate(data: dataInfo)
            KWListener.poster.updateUser()
            result(.success)
        }) { (error) in
            result(error)
        }
    }
    
    //从服务器更新
    public func update() {
        KWNetwork.getUser(resendConfig: KWNetworkResendConfig(interval: 3, resendCount: 5), success: { (respond) in
            KWUser.userInfo.updateDate(data: respond.data)
        }) { (error) in
            KWPrint(error)
        }
    }
    
    override func updateListenerPost() {
        KWListener.poster.updateUser()
    }
    
    override internal func convertToSaveKey(key: String) -> KWSaveKey {
        switch key {
    
        case KWNetworkDefine.KEY.addr.rawValue:
            return .addr
            
        case KWNetworkDefine.KEY.contactPhone.rawValue:
            return .contactPhone
            
        case KWNetworkDefine.KEY.imageHead.rawValue:
            return .imageHead
            
        case KWNetworkDefine.KEY.userName.rawValue:
            return .userName

        case KWNetworkDefine.KEY.userType.rawValue:
            return .userType

        case KWNetworkDefine.KEY.wechatId.rawValue:
            return .wechatId

        case KWNetworkDefine.KEY.vipStatus.rawValue:
            return .vipStatus
        
        case KWNetworkDefine.KEY.overTime.rawValue:
            return .overTime
            
        default:
            return .none
        }
    }
    
    override func attributeList() -> [String] {
        var list = super.attributeList()
        list.append(KWNetworkDefine.KEY.gender.rawValue)
        list.append(KWNetworkDefine.KEY.status.rawValue)
        return list
    }
}

//MARK: 支持方法
extension KWUserInfo {
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        var enumValue = 0
        
        if let intValue = value as? String {
            if let number = Int(intValue) {
                enumValue = number
            }
        }
//         if key == KWNetworkDefine.KEY.gender.rawValue {
//             gender = genderType(rawValue: enumValue)
//         }else if key == KWNetworkDefine.KEY.status.rawValue {
//             status = statusType(rawValue: enumValue)
//         }
    }
    
    //将上传的key转换成本地可解析的key
    fileprivate func convertUploadKeyToLocal(info : Dictionary<String, Any>) -> Dictionary<String, Any> {
        var uploadInfo : Dictionary<String,Any> = Dictionary()
        for (key, value) in info {
            uploadInfo[key] = value
        }
        return uploadInfo
    }
}

//MARK : ENUM
extension KWUserInfo {
    
    //是否需要完善资料 - isNeedComplete
    enum IsNeedCompleteType : Int {
        case unknow         = 0
        case isNeedComplete = 1
        case unNeedComplete = 2
        
        init(rawValue : Int) {
            if rawValue == 1 {
                self = .isNeedComplete
            } else if rawValue == 2 {
                self = .unNeedComplete
            } else {
                self = .unknow
            }
        }
    }
}
