//
//  CacheTask.swift
//  RedsMeMe
//
//  Created by reds on 2017/4/13.
//  Copyright © 2017年 Reds. All rights reserved.
//

import Foundation
import Kingfisher

//替换操作缓存对象
class ReplaceObject : NSObject {
    var object      : String = ""
    var cacheId     : String = ""
    var replaceType : Int = 0 // CacheTask.ReplaceType = .none
    
    init(cacheId : String , replaceId : String ,info : Dictionary<String,String>, replaceType : CacheTask.ReplaceType) {
        self.cacheId     = cacheId
        self.object      = KWParse.dictionaryToString(info)
        self.replaceType = replaceType.rawValue
    }
}

//图片、视频、动态缓存对象
class CacheObject: NSObject {

    var object     : String = ""
    var isSuccess  : Bool   = false
    var materialId : String = ""
    
    init(materialId: String, info : Dictionary<String,String>, isSuccess : Bool) {
        self.materialId = materialId
        self.object     = KWParse.dictionaryToString(info)
        self.isSuccess  = isSuccess
    }
}

class CacheTask: NSObject {
    
    enum ReplaceType : Int {
        case none      = 0
        case wallImage = 1
        case wallVideo = 2
    }
    
    //缓存类型
    enum CacheType : Int {
        case none         = 0
        case wallImage    = 1
        case wallVideo    = 2
        case wallDynamic  = 3
        case replaceImage = 4
        case replaceVideo = 5
        case chatImage    = 6
    }
    
    //缓存的对象的类型
    enum ObjectType : Int {
        case none    = 0
        case image   = 1
        case video   = 2
        case dynamic = 3
    }
    
    fileprivate var cacheUploadVideos : Dictionary<String, String>  = Dictionary()
   
}





//应用缓存
extension CacheTask {
    
    //缓存大小
    internal func size(result : @escaping (_ size : String)->()){
        DispatchQueue.global().async {
            let kfCacheSize    : Double = self.kfImageSize()
            
            DispatchQueue.main.async {
                result(String(format: "%.2lf", (kfCacheSize)) + "M")
                
            }
        }
    }
    
    //清除缓存
    internal func clear(finish : @escaping ()->()) {
        DispatchQueue.global().async {
            self.kfImageClear()
            DispatchQueue.main.async {
                finish()
            }
        }
    }
    
    //kingfisher 缓存的图片大小
    private func kfImageSize() -> Double {
        let path = KingfisherManager.shared.cache.diskStorage.directoryURL.absoluteString
        return forderSizeAtPath(rootPath: path)
    }
    
    //本地文件大小
//    private func localFileSize() -> Double {
//        let cacheImages = selecSuccessWallImages()
//        let cacheVideos = selectSuccessWallVideo()
//
//        var size : Double = 0.0
//
//        for image in cacheImages {
//            size = size + fileSize(path: image.materialId.jpglocal())
//        }
//
//        for video in cacheVideos {
//            size = size + fileSize(path: video.compressionPath)
//        }
//
//        return size
//    }
    
    //清除kingfisher 图片缓存
    private func kfImageClear() {
        KingfisherManager.shared.cache.clearDiskCache()
    }
    

    //获取目录大小
    private func forderSizeAtPath(rootPath : String) -> Double {
        
        let manage = FileManager.default
        
        if !manage.fileExists(atPath: rootPath) {
            return 0
        }
        
        let childFilePath = manage.subpaths(atPath: rootPath)
        
        var size : Double = 0
        
        for path in childFilePath! {
            
            let fileAbsoluePath = rootPath + "/" + path
            
            size += fileSize(path: fileAbsoluePath)
        }
        return size
    }
    
    //获取单个文件大小
    private func fileSize(path : String) -> Double {
        
        let manager = FileManager.default
        
        var fileSize:Double = 0
        
        do {
            let attr = try manager.attributesOfItem(atPath: path)
            
            fileSize = Double(attr[FileAttributeKey.size] as! UInt64)
            
            let dict = attr as NSDictionary
            
            fileSize = Double(dict.fileSize())
            
        } catch {
            
            dump(error)
        }
        
        return fileSize/1024/1024
    }
    
    //删除单个文件
    private func deleteFile(path: String) {
        let manage = FileManager.default
        do {
            try manage.removeItem(atPath: path)
        } catch {
            
        }
    }
}



