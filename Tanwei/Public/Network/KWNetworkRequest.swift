//
//  KWApplication.swift
//  KIWI
//
//  Created by li zhou on 2019/11/4.
//  Copyright © 2019 li zhou. All rights reserved.
//

import Foundation
import Alamofire

//全局请求ID
private var RMNETWORK_REQUEST_GLOBAL_ID : Int64 = 0

//MARK:类
class KWNetworkRequest: NSObject {
    
    //URLSessionConfiguration
    fileprivate let config = URLSessionConfiguration.default
    
    //SessionManager
    fileprivate var manager : SessionManager!
    
    //重连配置
    fileprivate var resendConfig : KWNetworkResendConfig?
    
    //请求唯一标识
    var identifier : String = ""
    
    //请求类型
    var type : KWNetworkDefine.URL = .none
    
    override init () {
        super.init()
        initializeConfig()
        initializeIdentifier()
        
//        AFSecurityPolicy * securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
//        //allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
//        //如果是需要验证自建证书，需要设置为YES
//        securityPolicy.allowInvalidCertificates = YES;
//        //validatesDomainName 是否需要验证域名，默认为YES；
//        //假如证书的域名与你请求的域名不一致，需把该项设置为NO
//        //主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
//        securityPolicy.validatesDomainName = NO;
//        //validatesCertificateChain 是否验证整个证书链，默认为YES
//        //设置为YES，会将服务器返回的Trust Object上的证书链与本地导入的证书进行对比，这就意味着，假如你的证书链是这样的：
//        //GeoTrust Global CA
//        //    Google Internet Authority G2
//        //        *.google.com
//        //那么，除了导入*.google.com之外，还需要导入证书链上所有的CA证书（GeoTrust Global CA, Google Internet Authority G2）；
//        //如是自建证书的时候，可以设置为YES，增强安全性；假如是信任的CA所签发的证书，则建议关闭该验证；
//        securityPolicy.validatesCertificateChain = NO;
//        requestOperationManager.securityPolicy = securityPolicy;
    }
}

//MARK:初始化
fileprivate extension KWNetworkRequest {
    //初始化配置
    func initializeConfig() {
        config.timeoutIntervalForRequest = RMNETWORK_DEFAULT_TIME_OUT
    }
    
    //分配identifier
    func initializeIdentifier() {
        RMNETWORK_REQUEST_GLOBAL_ID = RMNETWORK_REQUEST_GLOBAL_ID + 1
        identifier = String(format: "%ld", RMNETWORK_REQUEST_GLOBAL_ID)
    }
}

//MARK:基础请求
fileprivate extension KWNetworkRequest {
    //基础请求
    func baseRequest(url : String, method : HTTPMethod,parameters : Parameters,headers: HTTPHeaders,success : @escaping (_ value : Any?)->(), failure : @escaping (_ errorCode : Int)->()) {
        
        manager = Alamofire.SessionManager(configuration: config)
        
        manager.request(url, method: method, parameters:parameters, encoding: URLEncoding.default, headers: headers).validate().responseJSON { (respond) in
            switch (respond.result) {
            case .success:
                success(respond.value)
                break
            case .failure(let error):
                failure(error._code)
                break
            }
        }
    }
}


//MARK:对外接口 - request
extension KWNetworkRequest {
    ///设置超时时间, 默认 RMNETWORK_DEFAULT_TIME_OUT 必须在send方法之前设置
    public func timeout(interval : TimeInterval) {
        config.timeoutIntervalForRequest = interval
    }
    
    ///取消请求, 注意移除当前RMRequest 对象对应的identifier
    public func cancel() {
        manager.session.invalidateAndCancel()
    }
    
    //发送请求
    public func send(config : KWNetworkRequestConfig, success : @escaping SuccessCallBack, failure : @escaping FailureCallBack) {
        
        type = config.urlType
        
        let requestUrl  = config.port + config.urlType.rawValue
    
        baseRequest(url:requestUrl, method: config.method, parameters: config.parameters, headers: config.header, success: { (value) in
            success(KWNetworkParse.baseParse(value: value))
        }, failure: {(errorCode) in
            failure(KWNetworkError.convertRequestErrorCodeToErrorType(code: errorCode))
        })
    }
}

//MARK:对外接口 - resend
extension KWNetworkRequest {
    
    public func resendConfig(config : KWNetworkResendConfig?) {
        if config != nil {
            
            if !config!.isSend() {
                resendConfig?.cancelResend()
            }
            
            config!.statusSend()
            
            self.resendConfig = config
        }
    }
    
    public func resendIfNeed(task : @escaping ()->()) ->Bool {
        if self.resendConfig != nil {
            self.resendConfig?.task = task
            return self.resendConfig!.resendIfNeed()
        }
        return false
    }
    
}
