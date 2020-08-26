//
//  KWApplication.swift
//  KIWI
//
//  Created by li zhou on 2019/11/4.
//  Copyright © 2019 li zhou. All rights reserved.
//

import Foundation
import CryptoSwift
import SwiftyJSON

class KWNetworkTool: NSObject {
    
    //获取第二次登录交互信息[第二次登录交互] 将第一次登录交互获取的信息与用户名密码共同做验证 进行登录
    internal class func authHeader(authInfo : Dictionary<String,Any>, userName : String, password : String) ->String {
        //第一次交互返回的信息
        let qop     = KWParse.string(authInfo, key: KWNetworkDefine.KEY.qop.rawValue)
        let realm   = KWParse.string(authInfo, key: KWNetworkDefine.KEY.realm.rawValue)
        let nonce   = KWParse.string(authInfo, key: KWNetworkDefine.KEY.nonce.rawValue)
        
        //加密参数
        let cnonce  = randomCharset(len: 16)
        let nc      = "00000002"
        
        //url/method
        let uri     = HostPort1 + "/login/auth?"
        let method  = "POST"
        
        //加密
        let password_m : String  = (userName + ":" + password).md5()
        let ha1 : String = KWNetworkTool.md5HA1(userName: userName, realm: realm, password_m: password_m)
        let ha2 : String = KWNetworkTool.md5HA2(method: method, url: uri)
        let response = (ha1 + ":" + nonce + ":" + nc + ":" + cnonce + ":" + qop + ":" + ha2).md5()
        
        //拼接header
        let digestAuthHeader = "Digest username=\"\(userName)\", realm=\"\(realm)\", nonce=\"\(nonce)\""
            + ", uri=\"\(uri)\", response=\"\(response)\""
            + ", qop=\(qop), nc="
            + "\(nc)" + ", cnonce=\""
            + "\(cnonce)\""
        
        return digestAuthHeader
    }
    
    //获取ha1加密[第二次登录交互]
    private class func md5HA1(userName: String, realm: String, password_m: String) -> String {
        return (userName + ":" + realm + ":" + password_m).md5()
    }
    
    //获取ha2加密[第二次登录交互]
    private class func md5HA2(method: String, url: String) -> String {
        return (method + ":" + url).md5()
    }
    
    //获取指定位数的随机字符串[第二次登录交互]
    private class func randomCharset(len: Int) -> String {
        var output = ""
        for _ in 0..<len {
            let randomNumber = arc4random() % 26 + 97
            let randomChar = Character(UnicodeScalar(randomNumber)!)
            output.append(randomChar)
        }
        return output
    }
}
