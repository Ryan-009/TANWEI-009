//
//  KWApplication.swift
//  KIWI
//
//  Created by li zhou on 2019/11/4.
//  Copyright © 2019 li zhou. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit
import SVProgressHUD

///value在网络访问时，一般会以json数据形式，在用户数据返回时，一般会以模型形式
typealias SuccessCallBack = (_ respond : KWNetworkRespond)->()

///errorInfo一般会以错误展示的形式
typealias FailureCallBack = (_ error : KWNetworkError.ErrorType)->()

///如果是登录时出错  还是需要 返回数据
typealias LoginFailureCallBack = (_ respond : KWNetworkRespond,_ error : KWNetworkError.ErrorType)->()

class KWNetwork: NSObject {}

//基础请求
extension KWNetwork {
    //发送请求
    fileprivate class func sendRequest(requestConfig : KWNetworkRequestConfig, resendConfig : KWNetworkResendConfig?, success : @escaping SuccessCallBack, failure : @escaping FailureCallBack){
        
        let request : KWNetworkRequest = KWNetworkHandle.containsInTasks(type: requestConfig.urlType)
        
        request.resendConfig(config: resendConfig)
        
        request.send(config: requestConfig, success: { (respond) in
            
            let error = KWNetworkError.convertRespondErrorCodeToErrorType(code: respond.code)
            
            KWNetworkHandle.removeFromTasks(request: request)
            
            if KWNetworkError.ErrorType.success == error {
                success(respond)
            } else if KWNetworkError.fetchTokenInvalid(errorType: error) {
                KWNetworkError.handleTokeninvalid()
            }else {
                KWHUD.showInfo(info: respond.msg)
                failure(error)
            }
        }) { (error) in
            if error != .cancel {
                
                let isResend = request.resendIfNeed(task: {
                    sendRequest(requestConfig: requestConfig, resendConfig: resendConfig, success: success, failure: failure)
                })
                
                if !isResend {
                    KWNetworkHandle.removeFromTasks(request: request)
                    failure(error)
                }
            }else{}
        }
    }
    
    ///发送请求 - 与sendRequest唯一区别 parseError错误 也会返回成功 可以从中获取value， value是服务器返回的直接数据
    fileprivate class func sendFuzzyRequest(requestConfig : KWNetworkRequestConfig, resendConfig : KWNetworkResendConfig?, success : @escaping SuccessCallBack, failure : @escaping FailureCallBack) {
        
        let request : KWNetworkRequest = KWNetworkHandle.containsInTasks(type: requestConfig.urlType)
        
        request.resendConfig(config: resendConfig)
        
        request.send(config: requestConfig, success: { (respond) in
            
            let error = KWNetworkError.convertRespondErrorCodeToErrorType(code: respond.code)
            
            KWNetworkHandle.removeFromTasks(request: request)
            
            if KWNetworkError.ErrorType.success == error {
                success(KWNetworkParse.parseFuzzyRequest(value: respond.value))
            }
//            else if KWNetworkError.ErrorType.parseError == error && respond.value != nil {
//                success(KWNetworkParse.parseFuzzyRequest(value: respond.value))
//            }
            else {
                failure(error)
            }
            
        }, failure: {(error) in
            
            if error != .cancel {
                let isResend = request.resendIfNeed(task: {
                    sendRequest(requestConfig: requestConfig, resendConfig: resendConfig, success: success, failure: failure)
                })
                
                if  !isResend {
                    KWNetworkHandle.removeFromTasks(request: request)
                    failure(error)
                }
            }
        })
    }
    
    ///发送请求 - 与sendRequest唯一区别 parseError错误 也会返回成功 可以从中获取value， value是服务器返回的直接数据
    fileprivate class func sendLoginRequest(requestConfig : KWNetworkRequestConfig, resendConfig : KWNetworkResendConfig?, success : @escaping SuccessCallBack, failure : @escaping LoginFailureCallBack) {
        
        let request : KWNetworkRequest = KWNetworkHandle.containsInTasks(type: requestConfig.urlType)
        
        request.resendConfig(config: resendConfig)
        
        request.send(config: requestConfig, success: { (respond) in
            
            let error = KWNetworkError.convertRespondErrorCodeToErrorType(code: respond.code)
            
            KWNetworkHandle.removeFromTasks(request: request)
            
            if KWNetworkError.ErrorType.success == error {
                success(respond)
            } else if KWNetworkError.ErrorType.parseError == error && respond.value != nil {
                success(respond)
            } else if KWNetworkError.ErrorType.passwordError == error && respond.value != nil {
                failure(respond, error)
                KWAlertView.showWhithText(text: respond.msg)
            } else{
//                KWHUD.showWhithText(currentVc().view, respond.message)
                KWAlertView.showWhithText(text: respond.msg)
            }
            
        }, failure: {(error) in})
    }
}

//MARK:快捷配置
fileprivate extension KWNetwork {
    /********************************* 添加必须字段 ***********************************/
    ///返回配置好的config, 并且添加必须字段
    private class func getConfig(urlType : KWNetworkDefine.URL, port : String, method : HTTPMethod) -> KWNetworkRequestConfig {
        let config : KWNetworkRequestConfig = KWNetworkRequestConfig()
        config.set(urlType: urlType, port: port, method: method)
        if KWLogin.existLoginStatus() {
            config.set(head: KWLogin.loginToken(), key: .token)
            if urlType != .searchByUser {
                config.set(paramet: KWLogin.loginUser(), key: .userId)
            }
        }
        config.set(head: DeviceInfo.getMacAddress(), key: .traceId)
        
        return config
    }
    
    /********************************* 快捷获取配置 ***********************************/
    
    ///端口38001[GET]
    class func getPort1(urlType : KWNetworkDefine.URL) -> KWNetworkRequestConfig {
        return getConfig(urlType: urlType, port: HostPort1, method: .get)
    }
    
    ///端口38002[GET]
    ///端口38003[GET]
    
    ///端口38001[POST]
    class func postPort1(urlType : KWNetworkDefine.URL) -> KWNetworkRequestConfig {
        return getConfig(urlType: urlType, port: HostPort1, method: .post)
    }
    
    class func deletePort1(urlType : KWNetworkDefine.URL) -> KWNetworkRequestConfig {
        return getConfig(urlType: urlType, port: HostPort1, method: .delete)
    }
    
    ////端口38002[POST]
    ///端口38003[POST]
}

//MARK:登录
extension KWNetwork {
    public class func login(account : String, password : String, success : @escaping SuccessCallBack, failure : @escaping FailureCallBack) {
        let config = postPort1(urlType: .login)
        config.set(paramet: account  , key: .phone)
        config.set(paramet: password, key: .password)
        sendFuzzyRequest(requestConfig: config, resendConfig: nil, success: success, failure: failure)
    }
    public class func loginByCaptcha(phone : String, captcha : String, success : @escaping SuccessCallBack, failure : @escaping FailureCallBack) {
        let config = postPort1(urlType: .loginByCaptcha)
        config.set(paramet: phone  , key: .phone)
        config.set(paramet: captcha, key: .captcha)
        sendFuzzyRequest(requestConfig: config, resendConfig: nil, success: success, failure: failure)
    }
    public class func loginout(success : @escaping SuccessCallBack, failure : @escaping FailureCallBack) {
        let config = postPort1(urlType: .loginout)
        sendFuzzyRequest(requestConfig: config, resendConfig: nil, success: success, failure: failure)
    }
}

//MARK:注册
extension KWNetwork {
    public class func register(parameter : Dictionary<String,Any>, success : @escaping SuccessCallBack, failure : @escaping FailureCallBack) {
        let config = postPort1(urlType: .register)
        config.set(parameters: parameter)
        sendFuzzyRequest(requestConfig: config, resendConfig: nil, success: success, failure: failure)
    }
}

//MARK:发送验证码
extension KWNetwork {
    public class func vcode(mobileOrEmail : String,countryCode : String, success : @escaping SuccessCallBack, failure : @escaping FailureCallBack) {
        let config = postPort1(urlType: .vcode)
        config.set(paramet: mobileOrEmail, key: KWNetworkDefine.KEY.mobileOrEmail)
        if countryCode != "" {config.set(paramet: countryCode, key: KWNetworkDefine.KEY.countryCode)}
        sendFuzzyRequest(requestConfig: config, resendConfig: nil, success: success, failure: failure)
    }
}

//用户信息获取、更新
extension KWNetwork {
    public class func user(resendConfig: KWNetworkResendConfig?, success : @escaping SuccessCallBack, failure : @escaping FailureCallBack) {
        let config = getPort1(urlType: .user)
        sendRequest(requestConfig: config, resendConfig: resendConfig, success: success, failure: failure)
    }
    public class func editUser(parameter : Dictionary<String,Any>,resendConfig: KWNetworkResendConfig?, success : @escaping SuccessCallBack, failure : @escaping FailureCallBack) {
        let config = postPort1(urlType: .user)
        config.set(parameters: parameter)
        sendRequest(requestConfig: config, resendConfig: resendConfig, success: success, failure: failure)
    }
}

//发布
extension KWNetwork {
    
    public class func publishUpload(uploadImages:[UIImage], success : @escaping (_ successMaterialIds : Array<String>)->(), failure: @escaping ()->()){
        
//        var materialIds : [String] = []
//
//        DispatchQueue.global().async {
//
//            var finishNum = 0
//            for i in 0...uploadImages.count-1 {
//                uploadImageData(imageData: uploadImages[i].data, success: { (id) in
//                    finishNum += 1
//                    uploadImages[i].materialId = id
//                    if finishNum == uploadImages.count {
//
//                    }
//
//                }) { (err) in
//                    failure()
//                }
//            }
//
//        }
    }
    public class func publishUploadImage(uploadImages:[UploadImage], success : @escaping (_ successMaterialIds : [UploadImage])->(), failure: @escaping ()->()){
//        DispatchQueue.global().async {
            let semaphore = DispatchSemaphore(value: 1)
            let queue = DispatchQueue.global()
            let group = DispatchGroup()
            var finishNum = 0
            for i in 0...uploadImages.count-1 {
                queue.async(group:group) {
                    semaphore.wait()
                    uploadImageData(imageData: uploadImages[i].data, success: { (id) in
                        finishNum += 1
                        uploadImages[i].materialId = id
                        KWPrint("i是多少:"+"\(i)")
                        DispatchQueue.main.async {
                            let count : CGFloat = CGFloat(uploadImages.count) + 0.0
                            SVProgressHUD.showProgress(Float(CGFloat(i+1)/count), status: "数据上传中...")
                        }
                        semaphore.signal()
                        if finishNum == uploadImages.count {
                            success(uploadImages)
                        }
                    }) { (err) in
                        failure()
                        SVProgressHUD.dismiss()
                    }
                }
            }
    }
    private class func uploadImage(image:UIImage,success : @escaping ((_ id : String) -> ()), failure : @escaping FailureCallBack) {
        if let data = image.jpegData(compressionQuality: 1.0) {
            
            KWNetwork.salestarUpload(imageData: data, success: { (id) in
                success(id)
            }) { (type) in
                failure(.failure)
            }
        }
    }
    private class func uploadImageData(imageData:Data,success : @escaping ((_ id : String) -> ()), failure : @escaping FailureCallBack) {
        KWNetwork.salestarUpload(imageData: imageData, success: { (id) in
            success(id)
        }) { (type) in
            failure(.failure)
        }
    }
    private class func salestarUpload(imageData:Data, success : @escaping ((_ id : String) -> ()), failure : @escaping FailureCallBack) {
        
        Alamofire.upload(multipartFormData: {(multipartFormData) in
            multipartFormData.append(imageData, withName: "file",
            fileName: "file.jpeg", mimeType: "image/jpeg")
        }, to: HostPort1 + KWNetworkDefine.URL.upload.rawValue,method: .post,
           headers:["token":KWLogin.loginToken(),"Content-Type":"multipart/form-data"], encodingCompletion: {(encodingResult) in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseString { (dataRespond) in
                    print(dataRespond)
                    if dataRespond.result.isSuccess {
                        success(dataRespond.result.value!)
                    }else{
                        failure(.failure)
                    }
                }
            case .failure(_):
                failure(.failure)
            }
        })
    }
}
//上传图片
extension KWNetwork {
    //用户头像上传
    
}
//上传图片
extension KWNetwork {
    //用户头像上传
    public class func userMultiUpload(uploadImage:UIImage, success : @escaping SuccessCallBack, failure : @escaping FailureCallBack) {
        let simpleImage = uploadImage.simple(size: CGSize(width: 760.0, height: 760.0))
        if let data = simpleImage.jpegData(compressionQuality: 0.4) {
            upload(imageData: data, success: { (respond) in
                KWUser.userInfo.updateDate(data: respond.data)
                success(respond)
            }) { (_) in
                failure(.failure)
            }
        }
    }
    //上传faceid
    public class func faceIdUpload(uploadImage:UIImage,faceidCode:String?, success : @escaping SuccessCallBack, failure : @escaping FailureCallBack){
        if let data = uploadImage.jpegData(compressionQuality: 0.6) {
            uploadFaceid(imageData: data, faceidCode: faceidCode, success: { (respond) in
                KWUser.userInfo.updateDate(data: respond.data)
                success(respond)
            }) { (_) in
                failure(.failure)
            }
        }
    }
    private class func uploadFaceid(imageData:Data,faceidCode:String?, success : @escaping SuccessCallBack, failure : @escaping FailureCallBack) {
        Alamofire.upload(multipartFormData: {(multipartFormData) in
            multipartFormData.append(imageData, withName: "avatar",
            fileName: ".jpeg", mimeType: "multipart/form-data")
            multipartFormData.append(KWLogin.loginUser().data(using: String.Encoding.utf8)!, withName:"uid")
            multipartFormData.append("IOS".data(using: String.Encoding.utf8) ?? Data(), withName:"from")
            if faceidCode != nil {
                multipartFormData.append(faceidCode!.data(using: String.Encoding.utf8) ?? Data(), withName:"faceidCode")
            }
        }, to: HostPort1 + KWNetworkDefine.URL.faceid.rawValue,method: .post,
           headers:["userToken":KWLogin.loginToken()], encodingCompletion: {(encodingResult) in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON {(response) in
                    if response.result.isSuccess {
                        success(KWNetworkParse.baseParse(value: response.result.value))
                    } else {
                        failure(.failure)
                    }
                }
            case .failure(_): break
                failure(.failure)
            }
        })
    }
    private class func upload(imageData:Data, success : @escaping SuccessCallBack, failure : @escaping FailureCallBack) {
        Alamofire.upload(multipartFormData: {(multipartFormData) in
            multipartFormData.append(imageData, withName: "avatar",
            fileName: ".jpeg", mimeType: "multipart/form-data")
            multipartFormData.append(KWLogin.loginUser().data(using: String.Encoding.utf8)!, withName:"uid")
            multipartFormData.append("IOS".data(using: String.Encoding.utf8) ?? Data(), withName:"from")
        }, to: HostPort1 + KWNetworkDefine.URL.user.rawValue,method: .post,
           headers:["userToken":KWLogin.loginToken()], encodingCompletion: {(encodingResult) in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON {(response) in
                    if response.result.isSuccess {
                        success(KWNetworkParse.baseParse(value: response.result.value))
                    } else {
                        failure(.failure)
                    }
                }
            case .failure(_): break
                failure(.failure)
            }
        })
    }
}
//设备列表信息
extension KWNetwork {
    public class func deviceList(homeId : String?,resendConfig:KWNetworkResendConfig?,success : @escaping SuccessCallBack, failure : @escaping FailureCallBack) {
        let config = getPort1(urlType: .devicelist)
        if homeId != nil {config.set(paramet: homeId!, key: KWNetworkDefine.KEY.homeId)}
        sendRequest(requestConfig: config, resendConfig: resendConfig, success: success, failure: failure)
    }
}

//faceid列表
extension KWNetwork {
    public class func faceidlist(homeId : String,limit:Int?,resendConfig:KWNetworkResendConfig?,success : @escaping SuccessCallBack, failure : @escaping FailureCallBack) {
        let config = getPort1(urlType: .faceidlist)
        config.set(paramet: homeId, key: KWNetworkDefine.KEY.homeId)
        if limit != nil {config.set(paramet: limit!, key: KWNetworkDefine.KEY.limit)}
        sendRequest(requestConfig: config, resendConfig: resendConfig, success: success, failure: failure)
    }
}

//用户修改密码
extension KWNetwork {
    public class func resetpassword(oldPassword : String,password:String,confirmPassword:String,resendConfig:KWNetworkResendConfig?,success : @escaping SuccessCallBack, failure : @escaping FailureCallBack) {
        let config = postPort1(urlType: .resetpassword)
        config.set(paramet: oldPassword, key: KWNetworkDefine.KEY.oldPassword)
        config.set(paramet: password, key: KWNetworkDefine.KEY.password)
        config.set(paramet: confirmPassword, key: KWNetworkDefine.KEY.confirmPassword)
        sendRequest(requestConfig: config, resendConfig: resendConfig, success: success, failure: failure)
    }
    //用户忘记密码修改
    public class func forgetresetpassword(account : String,countryCode:String,smsOrEmailVcode:String,password:String,resendConfig:KWNetworkResendConfig?,success : @escaping SuccessCallBack, failure : @escaping FailureCallBack) {
        forgetpassword(account: account, countryCode: countryCode, resendConfig: KWNetworkResendConfig(interval: 2.0, resendCount: 2), success: { (respond) in
            let forgetToken = KWParse.string(respond.data, key: KWNetworkDefine.KEY.forgetToken.rawValue)
            let config = postPort1(urlType: .forgetresetpassword)
            config.set(head: forgetToken, key: KWNetworkDefine.KEY.forgetToken)
            config.set(paramet: account, key: KWNetworkDefine.KEY.account)
            config.set(paramet: smsOrEmailVcode, key: KWNetworkDefine.KEY.smsOrEmailVcode)
            config.set(paramet: password, key: KWNetworkDefine.KEY.password)
            sendRequest(requestConfig: config, resendConfig: resendConfig, success: success, failure: failure)
        }) { (err) in}
    }
    //用户忘记密码 用于获取forgetToken 会
    fileprivate class func forgetpassword(account:String,countryCode : String,resendConfig:KWNetworkResendConfig?,success : @escaping SuccessCallBack, failure : @escaping FailureCallBack) {
        let config = postPort1(urlType: .forgetpassword)
        config.set(paramet: account, key: KWNetworkDefine.KEY.account)
        if countryCode != "" {config.set(paramet: countryCode, key: KWNetworkDefine.KEY.countryCode)}
        sendRequest(requestConfig: config, resendConfig: resendConfig, success: success, failure: failure)
    }
}

//camera 排序
extension KWNetwork {
    public class func camerasort(homeId : String,sortByHomes:String?,sortByRooms:String?,resendConfig:KWNetworkResendConfig?,success : @escaping SuccessCallBack, failure : @escaping FailureCallBack) {
        let config = postPort1(urlType: .camerasort)
        config.set(paramet: homeId, key: KWNetworkDefine.KEY.homeId)
        if sortByHomes != nil {config.set(paramet: sortByHomes!, key: KWNetworkDefine.KEY.sortByHomes)}
        if sortByRooms != nil {config.set(paramet: sortByRooms!, key: KWNetworkDefine.KEY.sortByRooms)}
        sendRequest(requestConfig: config, resendConfig: resendConfig, success: success, failure: failure)
    }
}

//设备排序
extension KWNetwork {
    public class func devicesort(homeId : String,sortByHomes:String?,sortByRooms:String?,resendConfig:KWNetworkResendConfig?,success : @escaping SuccessCallBack, failure : @escaping FailureCallBack) {
        let config = postPort1(urlType: .devicesort)
        config.set(paramet: homeId, key: KWNetworkDefine.KEY.homeId)
        if sortByHomes != nil {config.set(paramet: sortByHomes!, key: KWNetworkDefine.KEY.sortByHomes)}
        if sortByRooms != nil {config.set(paramet: sortByRooms!, key: KWNetworkDefine.KEY.sortByRooms)}
        sendRequest(requestConfig: config, resendConfig: resendConfig, success: success, failure: failure)
    }
}

//Station绑定、更新、解绑删除
extension KWNetwork {
    public class func station(parameter:Dictionary<String,Any>,resendConfig:KWNetworkResendConfig?,success : @escaping SuccessCallBack, failure : @escaping FailureCallBack) {
        let config = postPort1(urlType: .station)
        config.set(parameters: parameter)
        sendRequest(requestConfig: config, resendConfig: resendConfig, success: success, failure: failure)
    }
}

//设备Device添加、更新、删除
extension KWNetwork {
    public class func device(parameter:Dictionary<String,Any>,resendConfig:KWNetworkResendConfig?,success : @escaping SuccessCallBack, failure : @escaping FailureCallBack) {
        let config = postPort1(urlType: .device)
        config.set(parameters: parameter)
        sendRequest(requestConfig: config, resendConfig: resendConfig, success: success, failure: failure)
    }
    public class func deleteDevice(stationId:String,homeId:String,sn:String,resendConfig:KWNetworkResendConfig?,success : @escaping SuccessCallBack, failure : @escaping FailureCallBack) {
        let config = deletePort1(urlType: .device)
        config.set(head: stationId, key: KWNetworkDefine.KEY.stationId)
        config.set(head: homeId, key: KWNetworkDefine.KEY.homeId)
        config.set(head: sn, key: KWNetworkDefine.KEY.sn)
        sendRequest(requestConfig: config, resendConfig: resendConfig, success: success, failure: failure)
    }
}

//设备Camera添加、更新、删除
extension KWNetwork {
    public class func camera(parameter:Dictionary<String,Any>,resendConfig:KWNetworkResendConfig?,success : @escaping SuccessCallBack, failure : @escaping FailureCallBack) {
        let config = postPort1(urlType: .camera)
        config.set(parameters: parameter)
        sendRequest(requestConfig: config, resendConfig: resendConfig, success: success, failure: failure)
    }
}

//设备Station绑定登录
extension KWNetwork {
    public class func binding(stationId:String,resendConfig:KWNetworkResendConfig?,success : @escaping SuccessCallBack, failure : @escaping FailureCallBack) {
        let config = postPort1(urlType: .binding)
        config.set(paramet: stationId, key: KWNetworkDefine.KEY.stationId)
        sendRequest(requestConfig: config, resendConfig: resendConfig, success: success, failure: failure)
    }
}

//设备Device sn 合法性码校验
extension KWNetwork {
    public class func checksn(sn:String,resendConfig:KWNetworkResendConfig?,success : @escaping SuccessCallBack, failure : @escaping FailureCallBack) {
        let config = postPort1(urlType: .checksn)
        config.set(paramet: sn, key: KWNetworkDefine.KEY.sn)
        sendRequest(requestConfig: config, resendConfig: resendConfig, success: success, failure: failure)
    }
}

//家庭信息更新
extension KWNetwork {
    public class func home(parameter:Dictionary<String,Any>,resendConfig:KWNetworkResendConfig?,success : @escaping SuccessCallBack, failure : @escaping FailureCallBack) {
        let config = postPort1(urlType: .home)
        config.set(parameters: parameter)
        sendRequest(requestConfig: config, resendConfig: resendConfig, success: success, failure: failure)
    }
}

//设备分组列表
extension KWNetwork {
    public class func devicecatlist(homeId:String,resendConfig:KWNetworkResendConfig?,success : @escaping SuccessCallBack, failure : @escaping FailureCallBack) {
        let config = getPort1(urlType: .devicecatlist)
        config.set(head: homeId, key: KWNetworkDefine.KEY.homeId)
        sendRequest(requestConfig: config, resendConfig: resendConfig, success: success, failure: failure)
    }
}

//分组排序
extension KWNetwork {
    public class func devicecatsort(homeId:String,sort:String,resendConfig:KWNetworkResendConfig?,success : @escaping SuccessCallBack, failure : @escaping FailureCallBack) {
        let config = postPort1(urlType: .devicecatsort)
        config.set(paramet: sort, key: KWNetworkDefine.KEY.sort)
        config.set(paramet: homeId, key: KWNetworkDefine.KEY.homeId)
        sendRequest(requestConfig: config, resendConfig: resendConfig, success: success, failure: failure)
    }
}

//设备分组添加、更新、删除
extension KWNetwork {
    public class func devicecat(parameter:Dictionary<String,Any>,resendConfig:KWNetworkResendConfig?,success : @escaping SuccessCallBack, failure : @escaping FailureCallBack) {
        let config = postPort1(urlType: .devicecat)
        config.set(parameters: parameter)
        sendRequest(requestConfig: config, resendConfig: resendConfig, success: success, failure: failure)
    }
    public class func deleteDevicecat(id:String,resendConfig:KWNetworkResendConfig?,success : @escaping SuccessCallBack, failure : @escaping FailureCallBack) {
        let config = deletePort1(urlType: .devicecat)
        config.set(head: id, key: KWNetworkDefine.KEY.id)
        sendRequest(requestConfig: config, resendConfig: resendConfig, success: success, failure: failure)
    }
}

extension KWNetwork {
    public class func getIdeCode(phone:String,type:Int,resendConfig:KWNetworkResendConfig?,success : @escaping SuccessCallBack, failure : @escaping FailureCallBack) {
           let config = postPort1(urlType: .getIdeCode)
            config.set(paramet: phone, key: KWNetworkDefine.KEY.phone)
            config.set(paramet: type, key: KWNetworkDefine.KEY.type)
           sendRequest(requestConfig: config, resendConfig: resendConfig, success: success, failure: failure)
    }
    
    public class func register(mobile:String,captcha:String,password:String,resendConfig:KWNetworkResendConfig?,success : @escaping SuccessCallBack, failure : @escaping FailureCallBack) {
        let config = postPort1(urlType: .register)
        config.set(paramet: captcha, key: KWNetworkDefine.KEY.captcha)
        config.set(paramet: password, key: KWNetworkDefine.KEY.password)
        config.set(paramet: mobile, key: KWNetworkDefine.KEY.phone)
        sendRequest(requestConfig: config, resendConfig: resendConfig, success: success, failure: failure)
    }
}

extension KWNetwork {
    public class func getUser(resendConfig:KWNetworkResendConfig?,success : @escaping SuccessCallBack, failure : @escaping FailureCallBack){
        let config = getPort1(urlType: .getUser)
        config.set(paramet: KWLogin.loginUser(), key: .userid)
        sendRequest(requestConfig: config, resendConfig: resendConfig, success: success, failure: failure)
    }
}

extension KWNetwork {
    public class func activelist(resendConfig:KWNetworkResendConfig?,success : @escaping SuccessCallBack, failure : @escaping FailureCallBack){
        let config = getPort1(urlType: .activelist)
        sendRequest(requestConfig: config, resendConfig: resendConfig, success: success, failure: failure)
    }
}

 
extension KWNetwork {
    public class func search(parameters:[String:Any],resendConfig:KWNetworkResendConfig?,success : @escaping SuccessCallBack, failure : @escaping FailureCallBack){
        let config = getPort1(urlType: .search)
        config.set(parameters: parameters)
        sendRequest(requestConfig: config, resendConfig: resendConfig, success: success, failure: failure)
    }
}

extension KWNetwork {
    public class func searchByUser(parameters:[String:Any],resendConfig:KWNetworkResendConfig?,success : @escaping SuccessCallBack, failure : @escaping FailureCallBack){
        let config = getPort1(urlType: .searchByUser)
        config.set(parameters: parameters)
        sendRequest(requestConfig: config, resendConfig: resendConfig, success: success, failure: failure)
    }
}
  
extension KWNetwork {
    public class func publish(parameters:[String:Any],resendConfig:KWNetworkResendConfig?,success : @escaping SuccessCallBack, failure : @escaping FailureCallBack){
        let config = postPort1(urlType: .publish)
        config.set(parameters: parameters)
        sendRequest(requestConfig: config, resendConfig: resendConfig, success: success, failure: failure)
    }
}

extension KWNetwork {
    public class func allBanners(resendConfig:KWNetworkResendConfig?,success : @escaping SuccessCallBack, failure : @escaping FailureCallBack){
        let config = getPort1(urlType: .allBanners)
        sendRequest(requestConfig: config, resendConfig: resendConfig, success: success, failure: failure)
    }
}

extension KWNetwork {
    public class func updateUserBaseMsg(parameters:[String:Any],resendConfig:KWNetworkResendConfig?,success : @escaping SuccessCallBack, failure : @escaping FailureCallBack){
        let config = postPort1(urlType: .updateUserBaseMsg)
        config.set(parameters: parameters)
        sendRequest(requestConfig: config, resendConfig: resendConfig, success: success, failure: failure)
    }
}

extension KWNetwork {
    public class func blacklist(resendConfig:KWNetworkResendConfig?,success : @escaping SuccessCallBack, failure : @escaping FailureCallBack){
        let config = getPort1(urlType: .blacklist)
        sendRequest(requestConfig: config, resendConfig: resendConfig, success: success, failure: failure)
    }
}

extension KWNetwork {
    public class func opblacklist(op:Int,black_phone:String,resendConfig:KWNetworkResendConfig?,success : @escaping SuccessCallBack, failure : @escaping FailureCallBack){
        let config = postPort1(urlType: .opblacklist)
        config.set(paramet: op, key: .op)
        config.set(paramet: black_phone, key: .black_phone)
        sendRequest(requestConfig: config, resendConfig: resendConfig, success: success, failure: failure)
    }
}
