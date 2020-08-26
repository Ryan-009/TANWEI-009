//
//  UploadImage.swift
//  LQM
//
//  Created by 吴凯耀 on 2020/3/21.
//  Copyright © 2020 WKY. All rights reserved.
//

import Foundation
import UIKit

class UploadImage: NSObject {
    var data         : Data!    //数据 图片的data格式
    var fileName     : String!  //file名 例如 file1  file2  feil3
    var imageName    : String!  //图片名  xxxxxxxxxx.png
    var suffix       : String!  //图片类型 jpg png 等
    var materialId   : String!  //上报的id
    var materialName : String!  //file名 + id 如 file1_materialId,file2_materialId,file3_materialId
    var size         : CGSize!   //图片宽高 //目前动态需要
    
    init(_ image: UIImage, index : Int) {
        super.init()
        data         = data(image: image)
        fileName     = "file" + String(format: "%d",index)
        imageName    = name()
        suffix       = "jpeg"
        materialId   = materialId(imageName: imageName)
        materialName = fileName + "_materialId"
    }
}

extension UploadImage {
    fileprivate func data(image : UIImage) -> Data {
        
        let simpleImage = image.simple(size: CGSize(width: 760.0, height: 760.0))
        
        if let data = simpleImage.jpegData(compressionQuality: 0.4) {
            
            size = simpleImage.size
            
            return data
        }
        
        size = CGSize.zero
        
        return Data()
    }
    
    fileprivate func name() -> String {
        let timeInterval : Double = Date().timeIntervalSince1970 * 1000 * 1000
        return "\(Int(timeInterval))" + ".jpg"
    }
    
    fileprivate func materialId(imageName : String) -> String {
//        if User.userInfo.userId > 0 {
//            let userId = User.userInfo.userId
//            let rand   = (String(arc4random() % 1000000 + 1000000) as NSString).substring(from: 1)
//            let ext    = (imageName as NSString).pathExtension
//            return "\(userId)_\((imageName as NSString).deletingPathExtension + rand)_\(ext)"
//        } else {
//            return " "
//        }
        return ""
    }
}
