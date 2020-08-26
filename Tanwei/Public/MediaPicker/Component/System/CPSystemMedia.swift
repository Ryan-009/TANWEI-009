//
//  CPSystemMedia.swift
//  RedsMeMe
//
//  Created by reds on 2017/4/8.
//  Copyright © 2017年 Reds. All rights reserved.
//

import Foundation
import AVFoundation
import MobileCoreServices
import UIKit

class CPSystemMedia: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    enum MediaType : String {
        case camera = "拍照"
        case record = "录像"
        case photo  = "照片"
        case video  = "视频"
        case all    = "照片加视频"
    }
    
    enum ResultType {
        case success
        case failure
    }
    
    enum EditType {
        case none 
        case cut    //可编辑
        case source //原图
    }

    typealias Result = (_ object : Any, _ resultType : ResultType)->()

    fileprivate var result  : Result!
    fileprivate var type    : MediaType!
    fileprivate var edit    : EditType = .source
}

//MARK : 拍照
extension CPSystemMedia {
    public func requestSystemMedia(type : MediaType, editType : EditType, result : @escaping Result) {
        self.result = result
        self.type   = type
        self.edit   = editType
        
        if MediaType.camera == type {
            handleCameraRequest()
        } else if MediaType.photo == type {
            handlePhotoRequest()
        } else if MediaType.video == type {
            handleVideoRequest()
        } else if MediaType.record == type {
            handleRecordRequest()
        }
    }
}

//MARK : 处理各种媒体请求
extension CPSystemMedia {
    //拍照
    fileprivate func handleCameraRequest()  {
 
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            let picker = UIImagePickerController()
            
            picker.delegate = self
            
            picker.sourceType = .camera
            
            if edit == .cut {
                picker.allowsEditing = true
            } else {
                picker.allowsEditing = false
            }
            
            if UIImagePickerController.isCameraDeviceAvailable(UIImagePickerController.CameraDevice.front){
                picker.cameraDevice = UIImagePickerController.CameraDevice.front
            }
            
            topViewController()?.present(picker, animated: true, completion: nil)
        } else {
            result(UIImage(),.failure)
        }
    }
    
    //拍摄
    fileprivate func handleRecordRequest() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .camera
            picker.videoQuality = .type640x480
            picker.mediaTypes = [kUTTypeMovie as String]
            
            topViewController()?.present(picker, animated: true, completion: nil)
        } else {
            result("",.failure)
        }
    }
    
    //照片
    fileprivate func handlePhotoRequest() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary)  {
            
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .photoLibrary
            picker.modalTransitionStyle = .coverVertical
            
            if edit == .cut {
                picker.allowsEditing = true
            } else {
                picker.allowsEditing = false
            }
            
            topViewController()?.present(picker, animated: true, completion: nil)
        }else {
            result(UIImage(),.failure)
        }
    }
    
    //视频
    fileprivate func handleVideoRequest() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let picker = UIImagePickerController()
            picker.delegate   = self
            picker.sourceType = .photoLibrary
            picker.mediaTypes = [kUTTypeMovie as String]
            picker.allowsEditing = false
            topViewController()?.present(picker, animated: true, completion: nil)
        } else {
            result(UIImage(),.failure)
        }
    }
}

//MARK : 处理各种媒体结果
extension CPSystemMedia {
    //拍照
    fileprivate func handleCameraRespond(info: [UIImagePickerController.InfoKey : Any]) {
        
        var key : UIImagePickerController.InfoKey
        
        if edit == .cut {
            key = UIImagePickerController.InfoKey.editedImage
        } else {
            key = UIImagePickerController.InfoKey.originalImage
        }
        
        if let image = info[key] as? UIImage {
            result(image,.success)
        }
    }
    
    //拍摄
    fileprivate func handleRecordRespond(info: [UIImagePickerController.InfoKey : Any]) {
        if let url = info[UIImagePickerController.InfoKey.mediaURL] as? NSURL {
            if let path = url.relativePath {
                
                if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(path) {
                    UISaveVideoAtPathToSavedPhotosAlbum(path, nil, nil, nil)
                }
                
                result(path,.success)
                return
            }
        }
        result("", .failure)
    }
    
    //照片
    fileprivate func handlePhotoRespond(info: [UIImagePickerController.InfoKey : Any]) {
        var key : UIImagePickerController.InfoKey
        
        if edit == .cut {
            key = UIImagePickerController.InfoKey.editedImage
        } else {
            key = UIImagePickerController.InfoKey.originalImage
        }
        
        if let image = info[key] as? UIImage {
            result(image,.success)
        } else {
            result(UIImage(),.failure)
        }
    }
    
    //视频
    fileprivate func handleVideoRespond(info: [UIImagePickerController.InfoKey : Any]) {
        if let url = info[UIImagePickerController.InfoKey.mediaURL] as? NSURL {
            if let path = url.relativePath {
                result(path,.success)
                return
            }
        }
        result("", .failure)
    }
}

//MARK : Delegate
extension CPSystemMedia {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if MediaType.camera == type {
            handleCameraRespond(info: info)
        } else if MediaType.photo == type {
            handlePhotoRespond(info: info)
        } else if MediaType.video == type {
            handleVideoRespond(info: info)
        } else if MediaType.record == type {
            handleRecordRespond(info: info)
        }

        topViewController()?.dismiss(animated: true, completion: nil)
    }
}

//MARK: Tool
extension CPSystemMedia {
    fileprivate func topViewController() -> UIViewController? {
        let rootViewController = UIApplication.shared.delegate?.window??.rootViewController
        
        guard let presentViewController = rootViewController?.presentedViewController else {
            return rootViewController
        }
        return presentViewController
    }
}
