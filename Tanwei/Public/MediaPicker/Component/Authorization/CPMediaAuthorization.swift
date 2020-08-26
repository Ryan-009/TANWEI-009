//
//  CPMediaAuthorization.swift
//  CPSwiftComponent
//
//  Created by reds on 2017/5/31.
//  Copyright © 2017年 convictionpeerless. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import Photos

class CPMediaAuthorization: NSObject {
 
    fileprivate let CameraUsageKey      = "NSCameraUsageDescription"
    fileprivate let MicrophoneUsageKey  = "NSMicrophoneUsageDescription"
    fileprivate let LibraryUsageKey     = "NSPhotoLibraryUsageDescription"
    
    //请求授权的类型
    enum AuthType : String {
        case photograph //拍照
        case videotape  //录像
        case library    //相册
    }
    
    //授权结果
    enum AuthResult : String {
        case unknow                    = "unknow"
        case wait                      = "wait"
        case success                   = "success"
        
        //info.plist
        case notExistentInfo           = "Can Not Fetch info.plist"
        case appNotSupportedCamera     = "info.plist Can Not Fetch Key NSCameraUsageDescription"
        case appNotSupportedMicrophone = "info.plist Can Not Fetch Key NSMicrophoneUsageDescription"
        case appNotSupportedLibrary    = "info.plist Can Not Fetch Key NSPhotoLibraryUsageDescription"
        
        //device
        case deviceNotSupportedCamera  = "Device Not Supported Camera"
        case deviceNotSupportedLibrary = "Device Not Supported Photo Library"
        
        //user
        case userDisagreeLibrary             = "User Disagree Library"
        case userDisagreeCamera              = "User Disagree Camera"
        case userDisagreeMicrophone          = "User Disagree Microphone"
        case userDisagreeCameraAndMicrophone = "User Disagree Camera And Microphone"
    }
}


//MARK: Public - 请求授权
extension CPMediaAuthorization {
    //请求相册权限
    public func requestLibrary(result : @escaping (Bool)->()) {
        requestLibraryAuthorization(result: result)
    }
    
    //请求相机权限
    public func requestCamera(result : @escaping (Bool)->()) {
        requestVideoAuthorization(result: result)
    }
    
    //请求拍摄权限
    public func requestRecord(result : @escaping (_ isCameraAuth : Bool, _ isMicrophoneAuth : Bool)->()) {
        
        var isCameraAuth     : Bool?
        var isMicrophoneAuth : Bool?
        
        requestVideoAuthorization { (isAuth) in
            isCameraAuth = isAuth
            if isMicrophoneAuth != nil { result(isMicrophoneAuth!, isCameraAuth!) }
        }
        
        requestAudioAuthorization { (isAuth) in
            isMicrophoneAuth = isAuth
            if isCameraAuth != nil { result(isCameraAuth!, isMicrophoneAuth!) }
        }
    }
    
    //验证可用性以及授权状态
    public func checkAuthStatus(type : AuthType) -> AuthResult {
        
        let availableResult =  availableDeviceStatus(type: type)
        
        guard availableResult == .success else { return availableResult }
        
        let authorizedResult = authorizationStatus(type: type)
        
        guard authorizedResult == .success else { return authorizedResult }
        
        return .success
    }
}


//MARK: 检测授权状态
extension CPMediaAuthorization {
    //验证授权状态
    fileprivate func authorizationStatus(type : AuthType) ->AuthResult {
        
        guard type != .library else {
            let status = PHPhotoLibrary.authorizationStatus()
            if status == .denied        { return .userDisagreeLibrary }
            if status == .notDetermined { return .wait }
            if status == .authorized    { return .success }
            if status == .restricted    { return .wait }
            return .unknow
        }
        
        guard type != .photograph else {
            let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
            if status == .denied        { return .userDisagreeCamera }
            if status == .notDetermined { return .wait }
            if status == .authorized    { return .success }
            if status == .restricted    { return .wait }
            return .unknow
        }
        
        guard type != .videotape else {
            let video = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
            let audio = AVCaptureDevice.authorizationStatus(for: AVMediaType.audio)
            
            if video == .notDetermined { return .wait }
            if video == .restricted    { return .wait }
            
            if audio == .notDetermined { return .wait }
            if audio == .restricted    { return .wait }
            
            if audio == .authorized && video == .authorized { return .success }
            if video == .denied     && audio == .denied     { return .userDisagreeCameraAndMicrophone }
            
            if video == .denied { return .userDisagreeCamera }
            if audio == .denied { return .userDisagreeMicrophone }
            return .unknow
        }
        
        return .unknow
    }

    //验证设备的可用性
    fileprivate func availableDeviceStatus(type : AuthType) -> AuthResult {
        
        let infoResult : AuthResult = infoVerify(type: type)
        
        guard infoResult == .success else { return infoResult } //验证info.plist
        
        let deviceResult : AuthResult = deviceVerify(type: type)
        
        guard deviceResult == .success else { return deviceResult } //验证设备
        
        return .success
    }

    //检测info.plist状态
    private func infoVerify(type : AuthType) -> AuthResult{
        
        guard let info = Bundle.main.infoDictionary else { return .notExistentInfo }
    
        //相册
        guard type != .library else {
            guard info.keys.contains(LibraryUsageKey) else { return .appNotSupportedLibrary }
            return .success
        }
        
        //拍照
        guard  type != .photograph else {
            guard info.keys.contains(CameraUsageKey) else { return .appNotSupportedCamera }
            return .success
        }
        
        //录像
        guard type != .videotape else {
            guard info.keys.contains(CameraUsageKey)     else { return .appNotSupportedCamera }
            guard info.keys.contains(MicrophoneUsageKey) else { return .appNotSupportedMicrophone }
            
            return .success
        }
        
        return .unknow
    }
    
    //检测设备状态
    private func deviceVerify(type : AuthType) -> AuthResult {
        //相册
        guard type != .library else {
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) { return .success }
            return .deviceNotSupportedLibrary
        }
        
        //拍照
        guard type != .photograph else {
            if UIImagePickerController.isSourceTypeAvailable(.camera) { return .success }
            return .deviceNotSupportedCamera
        }
        
        //录像
        guard type != .videotape else {
            if UIImagePickerController.isSourceTypeAvailable(.camera) { return .success }
            return .deviceNotSupportedCamera
        }
        
        return .unknow
    }
}

//MARK: 请求权限
extension CPMediaAuthorization {

    //请求相册权限
    fileprivate func requestLibraryAuthorization(result : @escaping (Bool)->()) {
        PHPhotoLibrary.requestAuthorization({ (status) in
            DispatchQueue.main.async {
                if status == .authorized { result(true); return}
                result(false)
            }
        })
    }
    
    //请求相机权限
    fileprivate func requestVideoAuthorization(result : @escaping (Bool)->()) {
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { (isAuth) in
            DispatchQueue.main.async { result(isAuth) }
        }
    }
    
    //请求麦克风权限
    fileprivate func requestAudioAuthorization(result : @escaping (Bool)->()) {
        AVCaptureDevice.requestAccess(for: AVMediaType.audio) { (isAuth) in
            DispatchQueue.main.async { result(isAuth) }
        }
    }
}




