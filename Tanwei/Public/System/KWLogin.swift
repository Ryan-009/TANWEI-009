//
//  KWApplication.swift
//  KIWI
//
//  Created by li zhou on 2019/11/4.
//  Copyright © 2019 li zhou. All rights reserved.
//

import Foundation

class KWLogin: NSObject {
    
    enum LoginType : Int {
        case awaken   = 0
        case sms      = 1
        case password = 2
    }
}

//MARK: 登录
extension KWLogin {
    
    //登录并且保存登录态
    internal class func loginAndSaveStatus(account : String, password : String, success: @escaping (_ respond : KWNetworkRespond)->(), failure: @escaping (_ error : KWNetworkError.ErrorType)->()) {
        login(account: account, password: password, success: { (respond) in
            if KWParse.string(respond.data, key: KWNetworkDefine.KEY.token.rawValue) != "" {
                KWLogin.saveLoginStatus(respond) //先保存登录态
            }
            success(respond)
        }) { (err) in}
    }
    
    //登录并且保存登录态
    internal class func loginSmsAndSaveStatus(account : String, captcha : String, success: @escaping (_ respond : KWNetworkRespond)->(), failure: @escaping (_ error : KWNetworkError.ErrorType)->()) {
        loginByCaptcha(account: account, captcha: captcha, success: { (respond) in
            if KWParse.string(respond.data, key: KWNetworkDefine.KEY.token.rawValue) != "" {
                KWLogin.saveLoginStatus(respond) //先保存登录态
            }
            success(respond)
        }) { (err) in}
    }

    //ps登录
    private class func login(account : String, password : String, success: @escaping (_ respond : KWNetworkRespond)->(), failure: @escaping (_ error : KWNetworkError.ErrorType)->())  {
        
        KWNetwork.login(account: account, password: password, success: { (respond) in
            success(respond)
        }) { (error) in
            failure(error)
        }
    }
    //sms登录
    private class func loginByCaptcha(account : String, captcha : String, success: @escaping (_ respond : KWNetworkRespond)->(), failure: @escaping (_ error : KWNetworkError.ErrorType)->())  {
        KWNetwork.loginByCaptcha(phone: account, captcha: captcha, success: { (res) in
            success(res)
        }) { (err) in
            failure(err)
        }
    }
}


//MARK:登录方式
extension KWLogin {
    //保存登录方式
    internal class func saveLoginType(type : LoginType) {
        KWSave.write(value: type.rawValue, key: .loginType)
    }
    
    //移除登录方式
    internal class func removeLoginType() {
        KWSave.remove(key: .loginType)
    }
    
    //读取登录方式
    internal class func readLoginType() -> Int {
        return KWSave.read(key: .loginType).int()
    }
}


//MARK: 登录态
extension KWLogin {
    
    //保存登录态
    internal class func saveLoginStatus(_ respond : KWNetworkRespond) {
        let uid      = KWParse.int(respond.data, key: KWNetworkDefine.KEY.userId.rawValue)
        
        let uToken   = KWParse.string(respond.data, key: KWNetworkDefine.KEY.token.rawValue)
        
        if uid != RMNETWORK_DEFAULT_ERROR_CODE {
            Application.save.write(key:.userId , value: "\(uid)")
        }
        
        if uToken != "" {
            Application.save.write(key: .token, value: uToken)
        }
    }
    
    //移除登录态
    internal class func removeLoginStatus() {
        Application.save.remove(key: .userId)
        Application.save.remove(key: .token)
    }
    
    //是否存在登录态
    internal class func existLoginStatus() ->Bool {
        let userId      : String = Application.save.read(key: .userId)
        let token       : String = Application.save.read(key: .token)
        
        if UnEmpty(userId) && UnEmpty(token) {
            return true
        }
        
        return false
    }
    
    //获取登录用户名
    internal class func loginUser() ->String {
        return Application.save.read(key: .userId)
    }
    
    //获取登录Token
    internal class func loginToken() ->String {
        return Application.save.read(key: .token)
    }
}
