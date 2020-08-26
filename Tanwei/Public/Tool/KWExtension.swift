//
//  KWApplication.swift
//  KIWI
//
//  Created by li zhou on 2019/11/4.
//  Copyright © 2019 li zhou. All rights reserved.
//

import Foundation
import UIKit

//MARK:DispatchQueue
public extension DispatchQueue {
    
    fileprivate static func after(queue : DispatchQueue , delay : Double, excute : @escaping ()->()) -> Void {
        let deadline = DispatchTime.now() + delay
        queue.asyncAfter(deadline: deadline, execute: {() in
            excute()
        })
    }
    
    class func globalAfter(delay : Double, excute : @escaping ()->()) -> Void {
        DispatchQueue.after(queue: DispatchQueue.global(), delay: delay, excute: excute)
    }
    
    class func mainAfter(delay : Double, excute : @escaping ()->()) -> Void {
        DispatchQueue.after(queue: DispatchQueue.main, delay: delay, excute: excute)
    }
    
    class func mainAsync(excute : @escaping ()->()) {
        DispatchQueue.main.async { excute() }
    }
}

//MARK:Int64
public extension Int64 {
    func string() -> String {
        return String(format: "%ld", self)
    }
}

//MARK:Int
public extension Int {
    func string() -> String {
        return String(format: "%ld", self)
    }
}

public extension CGFloat {
    func string() -> String {
        return String(format: "%lf", self)
    }
}



//MARK: String
public extension String {
    //图片URL - big
    func big () -> String {
        return coverToMaterialURL(type: "big")
    }
    
    //图片URL - small
    func small () -> String {
        return coverToMaterialURL(type: "small")
    }
    
    //图片URL - normal
    func normal() -> String {
        return coverToMaterialURL(type: "")
    }
    
    //图片URL - 支持方法
    private func coverToMaterialURL(type : String) ->String {
        let imageInfo : Array = self.components(separatedBy: "_")
        if imageInfo.count > 2 {
            let imageID   : String = imageInfo[0] as String
            let imageName : String = imageInfo[1] as String
            let imageType : String = imageInfo[2] as String
            if type == "" {
                return ImageBaseURL + "/" + imageID + "/" + imageName + "." + imageType
            } else {
                return ImageBaseURL + "/" + imageID + "/" + imageName + "_" + type + "." + imageType
            }
            
        } else {
            return ImageBaseURL
        }
    }
    
    //视频URL
    func source() -> String{
//        let videoInfo : Array   = self.components(separatedBy: "_")
//
//        if videoInfo.count > 2 {
//            let videoID   : String  = videoInfo[0] as String
//            let videoName : String  = videoInfo[1] as String
//            let videoType : String  = videoInfo[2] as String
//
//            return VideoBaseURL + "/" + videoID + "/" + videoName + "." + videoType
//        }
        
        return ""//VideoBaseURL
    }
    
    //string to data
    func data() -> Data {
        if let data = Data(base64Encoded: self) {
            return data
        }
        return Data()
    }
    
    //string to Int64
    func int64() -> Int64 {
        if let int64 = Int64(self) {
            return int64
        }
        
        return RMNETWORK_DEFAULT_ERROR_CODE64
    }
    
    //string to Int
    func int() -> Int {
        if let int = Int(self) {
            return int
        }
        
        return RMNETWORK_DEFAULT_ERROR_CODE
    }
    
    //string to CGFloat
    func cgfloat() ->CGFloat {
        return CGFloat(double())
    }
    
    //string to CGFloat
    func double() ->Double {
        if let double = Double(self) {
            return double
        }
        
        return 0.0
    }
    
    //返回document的沙盒路径
    private func local() -> String {
        return KWPath.document(self)
    }
    
    //返回jpg路径
    private func jpg() -> String {
        return self + ".jpg"
    }
    
    //jpg缓存路径
    func jpglocal() -> String {
        return self.local().jpg()
    }
    
    //是否存在文件
    func isExist() ->Bool {
        return FileManager.default.fileExists(atPath: self)
    }
    
    //手机号码转换
    internal func security() -> String {
        
        guard lengthOfBytes(using: .utf8) == 11 else { return "" }
        
        let leftIndex   = index(startIndex, offsetBy: 3)
        let leftNumber  = substring(to: leftIndex)
        
        let rightIndex  = index(endIndex, offsetBy: -4)
        let rightNumber = substring(from: rightIndex)
        
        return leftNumber + "****" + rightNumber
    }
}

//MARK: Data
public extension Data {
    func image() -> UIImage? {
        if let image = UIImage(data: self) {
            return image
        }
        return nil
    }
    
    //将data写到沙盒
    func toLocal(path : String) {
        do {
            try write(to: URL(fileURLWithPath: path), options: [])
        } catch {
            
        }
    }
}
//MARK: TimeInterval
public extension TimeInterval {
    static func now13() ->TimeInterval {
        return Date().timeIntervalSince1970 * 1000
    }
    
    static func now10() ->TimeInterval {
        return Date().timeIntervalSince1970
    }
    
    func int64() ->Int64 {
        return Int64(self)
    }
}

//MARK: UIImage
public extension UIImage {
    
    func jpg07() -> UIImage {
        if let imageData = self.jpegData(compressionQuality: 0.7) {
            if let image = UIImage(data: imageData) {
                return image
            }
        }
        return self
    }
    
    //转成data
    func data() -> Data{
        if let imageData = self.pngData() {
            return imageData
        }
        return Data()
    }
    
    //压缩
    func simple(size:CGSize) -> UIImage {
        
        if self.size.width <= size.width && self.size.height <= size.height {
            return self
        }
        
        var width:CGFloat!
        var height:CGFloat!
        
        if self.size.width/size.width >= self.size.height / size.height{
            width  = size.width
            height = self.size.height / (self.size.width/size.width)
        }else{
            height = size.height
            width  = self.size.width / (self.size.height/size.height)
        }
        let sizeImageSmall = CGSize(width: width, height: height)
        
        UIGraphicsBeginImageContextWithOptions(sizeImageSmall, false, 0.0)
        
        self.draw(in: CGRect(x: 0, y: 0, width: sizeImageSmall.width, height: sizeImageSmall.height))
        
        var newImage : UIImage!
        
        if  let img = UIGraphicsGetImageFromCurrentImageContext() {
            newImage = img
        } else {
            newImage = UIImage()
        }
        
        UIGraphicsEndImageContext();
        
        return newImage;
    }
}

//遮盖
public extension UIWindow {
    func cover() {//强制更细时添加
        let coverView : UIView = UIView(frame: SCREEN_BOUNDS)
        coverView.alpha = 0.5
        Application.window.addSubview(coverView)
    }
}

public extension CGSize {
    //for extension UIImage - autoScale
    func scaleToScreen() -> CGSize {
        return CGSize(width: SCREEN_WIDTH, height: self.height * SCREEN_WIDTH / self.width)
    }
}
