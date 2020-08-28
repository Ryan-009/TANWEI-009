//
//  KWApplication.swift
//  KIWI
//
//  Created by li zhou on 2019/11/4.
//  Copyright © 2019 li zhou. All rights reserved.
//

import Foundation

///MARK:类
class KWNetworkError: NSObject {
    
    ///RMNetwork类的请求错误类型，错误判断时，不需要判断calcel 其他错误类型对应请求接口进行判断
    public enum ErrorType : String {
        case none = "UNKNOW"
        
        /** 请求错误 **/
        case cancel     = "请求取消" //NSURLErrorCancelled
        case timedOut   = "请求超时" //NSURLErrorTimedOut
        case pathError  = "路径错误" //NSFileNoSuchFileError 域名或者请求方法(GET,POST)错误
        case hostError  = "不能连接到主机" //NSURLErrorCannotConnectToHost
        
        case withoutNetwork     = "没有网络" //NSURLErrorNotConnectedToInternet
        case urlErroOrNetLost   = "URL错误或者网络连接丢失" //NSURLErrorNetworkConnectionLost
        case noSuchFileError    = "没有这样的文件"
        
        /** 响应错误 - 基础类型 **/
        case success      = "请求成功" //服务器返回 errCode = 0, 并且解析成功
        case failure      = "请求失败" //服务器返回 errCode = -1, 失败
        case parseError   = "解析错误" //服务器返回 errCode = 0, 但数据没有解析成功
        case recordRepeat = "记录重复" //服务器返回 errCode = -4 记录重复
//        case imageCodeError = "记录重复" //服务器返回 errCode = -4 记录重复
        
        /** 登录 **/
        case phoneNumberFormatError     = "手机号码格式错误"
        case phoneNumberUnRegiste       = "手机号码未注册"
        case phoneNumberAlreadyRegiste  = "手机号码已经注册"
        
        case smsInvalid     = "验证码过期或不正确"
        case passwordError  = "密码错误"
        case tokenInvalid   = "登录token失效"
        case unLogin        = "未登录"
        
        
    }
}

//MARK:错误码转换 ErrorType
extension KWNetworkError {
    ///将request产生的错误码转换成RMNetworkErrorType类型
    public class func convertRequestErrorCodeToErrorType(code : Int) ->ErrorType {
        switch code {
        case NSURLErrorCancelled    : return ErrorType.cancel
        case NSURLErrorTimedOut     : return ErrorType.timedOut
        case NSFileNoSuchFileError  : return ErrorType.pathError
        case NSURLErrorCannotConnectToHost : return ErrorType.hostError
        case NSURLErrorNotConnectedToInternet: return ErrorType.withoutNetwork
        case NSURLErrorNetworkConnectionLost : return ErrorType.urlErroOrNetLost
        case NSFileNoSuchFileError           : return .noSuchFileError
        default: return .none
        }
    }
    
    ///将respond产生的错误码转换成RMNetworkErrorType类型
    public class func convertRespondErrorCodeToErrorType(code : Int) ->ErrorType {
        switch code {
        //响应错误 - 基础类型
        case  200      : return .success
        case -1      : return .failure
        case -4      : return .recordRepeat
        case RMNETWORK_DEFAULT_ERROR_CODE : return .parseError
            
        //登录
        case 10011   : return .phoneNumberFormatError
        case 10000   : return .phoneNumberUnRegiste
        case 10007   : return .smsInvalid
        case 401   : return .tokenInvalid//登录态失效
        case 10001   : return .unLogin
        case 10020   : return .passwordError
        
        
        default      : return .none
        }
    }
}

//异常处理
extension KWNetworkError {
    //捕获登录态异常
    internal class func fetchTokenInvalid(errorType : ErrorType) -> Bool {
        return errorType == .tokenInvalid
    }
    
    //处理登录态异常
    internal class func handleTokeninvalid() {
//        KWNetworkHandle.removeAllTask()
//        DDSystem.logout()

//        DDPrint("登录状态过期,请重新登录", type: .NetWork)
    }
}
