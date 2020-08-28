//
//  RMMediaPicker.swift
//  RedsMeMe
//
//  Created by reds on 2017/4/8.
//  Copyright © 2017年 Reds. All rights reserved.
//

import Foundation
import Photos
import UIKit

class RMMediaPicker: NSObject {
    
    fileprivate static let sharedPicker = RMMediaPicker()
    public class func shared() -> RMMediaPicker { return sharedPicker }
    
    //系统权限管理
    fileprivate var authorize : CPMediaAuthorization = CPMediaAuthorization()
    
    //系统媒体
    fileprivate var systemMedia : CPSystemMedia = CPSystemMedia()
    
    //自定义媒体 - 相册
    fileprivate let customMedia : CPCustomMedia = CPCustomMedia()
    
}

//授权
extension RMMediaPicker {
    
    //拍照
    public class func authForPhotograph(result : @escaping (CPMediaAuthorization.AuthResult)->()) {
        let authStatus : CPMediaAuthorization.AuthResult = sharedPicker.authorize.checkAuthStatus(type: .photograph)
        
        if authStatus != .wait { result(authStatus); return }
        
        sharedPicker.authorize.requestCamera(result: { (isAllow) in
            guard isAllow else { result(.userDisagreeCamera); return }
            result(.success)
        })
    }
    
    //拍摄
    public class func authForVideotape(result : @escaping (CPMediaAuthorization.AuthResult)->()) {
        let authStatus : CPMediaAuthorization.AuthResult = sharedPicker.authorize.checkAuthStatus(type: .videotape)
        
        if authStatus != .wait { result(authStatus); return }
        
        sharedPicker.authorize.requestRecord(result: { (isCameraAllow, isMicrophoneAllow) in
            if isCameraAllow && isMicrophoneAllow { result(.success); return }
            
            if isCameraAllow { result(.userDisagreeMicrophone); return }
            
            if isMicrophoneAllow { result(.userDisagreeCamera); return }
            
            result(.userDisagreeCameraAndMicrophone)
        })
    }
    
    //相册
    public class func authForAlbum(result : @escaping (CPMediaAuthorization.AuthResult)->()) {
        
        let authStatus : CPMediaAuthorization.AuthResult = sharedPicker.authorize.checkAuthStatus(type: .library)
        
        if authStatus != .wait { result(authStatus); return }
        
        sharedPicker.authorize.requestLibrary(result: { (isAllow) in
            
            guard isAllow else { result(.userDisagreeLibrary); return }
            
            result(.success)
        })
    }
}

//系统媒体 - 相机
extension RMMediaPicker {
    
    //拍照
    public class func systemCamera(editType : CPSystemMedia.EditType, result : @escaping (_ image : UIImage)->()) {
        systemMedia(type: .camera, editType: editType, result: {(image, type) in
            
            guard type == .success else { result(UIImage()); return }
            
            result(image as! UIImage)
        })
    }
    
    //拍摄
    public class func systemRecord(result : @escaping (_ url : String)->()) {
        systemMedia(type: .record, editType: .none, result: {(url, type) in
            
            guard type == .success else {result(""); return }
            
            result(url as! String)
        })
    }
    
    //选择相册照片
    public class func systemAlbum(editType : CPSystemMedia.EditType, result : @escaping (_ image : UIImage)->()) {
        systemMedia(type: .photo, editType: editType, result: {(image, type) in
            
            guard type == .success else { result(UIImage()); return }
           
            result(image as! UIImage)
        })
    }
    
    //选择相册视频
    public class func systemVideo(result : @escaping (_ url : String)->()) {
        systemMedia(type: .video, editType: .none, result: {(url, type) in
            
            guard type == .success else { result(""); return }
            
            result(url as! String)
        })
    }
    
    //选择资源 private
    public class func systemMedia(type : CPSystemMedia.MediaType, editType : CPSystemMedia.EditType, result : @escaping CPSystemMedia.Result) {
        sharedPicker.systemMedia.requestSystemMedia(type: type, editType: editType, result: result)
    }
}

//自定义媒体 - 图片
extension RMMediaPicker {
    //集合
    public class func customImageAssets(results : @escaping (_ assets : Array<PHAsset>)->()) {
        sharedPicker.customMedia.pickAssets(results: results, type: .image)
    }
    
    //缩略图
    public class func customScaleImage(asset : PHAsset, size : CGSize, result : @escaping (_ image : UIImage)->()) {
        sharedPicker.customMedia.pickScaleImage(asset: asset, size: size, result: result)
    }

    //原图
    public class func customSourceImage(asset : PHAsset, result : @escaping (_ image : UIImage)->()) {
        sharedPicker.customMedia.pickSourceImage(asset: asset, result: result)
    }
}

//自定义媒体 - 视频
extension RMMediaPicker{
    //集合
    public class func customVideoAssets(results : @escaping (_ assets : Array<PHAsset>)->()) {
        sharedPicker.customMedia.pickAssets(results: results, type: .video)
    }
    
    //路径
    public class func customSourceVideo(asset : PHAsset, result : @escaping (_ url : URL)->()) {
        sharedPicker.customMedia.pickerSourceVideo(asset: asset, result: result)
    }
}

//自定义媒体 - 相册
extension RMMediaPicker{
    // 图片
    public class func customImageAlbum(result : @escaping (_ albums : Array<CPCustomMediaAlbum>)->()) {
        sharedPicker.customMedia.pickAlbum(result: result, type: .image)
    }
    
    //视频
    public class func customVideoAlbum(result : @escaping (_ albums : Array<CPCustomMediaAlbum>)->()) {
        sharedPicker.customMedia.pickAlbum(result: result, type: .video)
    }
}


//MARK: 抓取资源中的图片或视频
extension RMMediaPicker {
    //抓取所有资源中的图片
    public class func fetchImages(assets : Array<PHAsset>, result : @escaping (_ images : Array<UIImage>)->()) {
       
        DispatchQueue.global().async {
            
            var images : Array<UIImage> = Array()
            
            for asset in assets {
                
                customSourceImage(asset: asset, result: { (image) in
                    
                    images.append(image)
                    
                    if images.count == assets.count {
                        
                        result(images)
                    }
                })
            }
        }
    }
    
    //抓取所有资源中的视频路径
    public class func fetchVideoPath(assets : Array<PHAsset>, result : @escaping (_ paths : Array<String>)->()) {
        
        DispatchQueue.global().async {
            
            var paths : Array<String> = Array()
            
            for asset in assets {
                
                customSourceVideo(asset: asset, result: { (url) in
                    
                    paths.append(url.absoluteString)
                    
                    if paths.count == assets.count {
                        
                        result(paths)
                    }
                })
            }
        }
    }
}


//MARK : 工具
extension RMMediaPicker {
    //跳转设置
    public class func requestOpenSetting() {
        let alert : UIAlertController = UIAlertController(title: "应用需要相机访问权限", message: "", preferredStyle: UIAlertController.Style.alert)
        let configAction = UIAlertAction(title: "允许", style: UIAlertAction.Style.default, handler: { (action) in
            
            if let url = URL(string: UIApplication.openSettingsURLString) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.openURL(url)
                }
            }
        })
        
        let calcelAction = UIAlertAction(title: "取消", style: UIAlertAction.Style.default, handler: { (action) in
            print("用户取消相册权限设置")
        })
        
        alert.addAction(configAction)
        alert.addAction(calcelAction)
        UIApplication.shared.delegate!.window!!.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    //授权失败 - 无键值对
    public class func fetchCrashResult(result : CPMediaAuthorization.AuthResult) -> Bool {
        let crashResult : Array<CPMediaAuthorization.AuthResult> = [.notExistentInfo,
                                                                    .appNotSupportedCamera,
                                                                    .appNotSupportedMicrophone,
                                                                    .appNotSupportedLibrary]
        return crashResult.contains(result)
    }
    
    //授权失败 - 用户不同意
    public class func fetchDisagreeResult(result : CPMediaAuthorization.AuthResult) -> Bool {
        let crashResult : Array<CPMediaAuthorization.AuthResult> = [.userDisagreeLibrary,
                                                                    .userDisagreeCamera,
                                                                    .userDisagreeMicrophone,
                                                                    .userDisagreeCameraAndMicrophone]
        return crashResult.contains(result)
    }

    //授权失败 - 设备不支持
    public class func fetchUnsupportedResult(result : CPMediaAuthorization.AuthResult) -> Bool {
        let crashResult : Array<CPMediaAuthorization.AuthResult> = [.deviceNotSupportedCamera,
                                                                    .deviceNotSupportedLibrary]
        return crashResult.contains(result)
    }
}



