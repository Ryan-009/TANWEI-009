//
//  CPMediaBaseController.swift
//  RedsMeMe
//
//  Created by reds on 2017/6/2.
//  Copyright © 2017年 Reds. All rights reserved.
//

import Foundation
import Photos
import UIKit

class CPMediaBaseController: UIViewController {
    enum AssetType {
        case photo
        case video
    }
    
    var assetType      : AssetType!
    
    typealias FetchImageResult = (_ images : Array<UIImage>)->()
    typealias FetchPathResult  = (_ images : Array<String>)->()
    typealias FetchAssetResult = (_ images : Array<PHAsset>)->()
    
    var selectImagesCallBack : FetchImageResult?
    var selectVideoCallBack  : FetchPathResult?
    var selectAssetCallback  : FetchAssetResult?
    
    internal func fetchImagesResult(_ result : @escaping (_ images : Array<UIImage>)->()) {
        selectImagesCallBack = result
    }
    
    internal func fetchVideoResult(_ result : @escaping (_ images : Array<String>)->()) {
        selectVideoCallBack = result
    }
    
    internal func fetchAssetResult(_ result : @escaping (_ images : Array<PHAsset>)->()) {
        selectAssetCallback = result
    }
    
    override func viewDidLoad() {
        if assetType == .photo {
            self.title = "选择照片"
        } else if assetType == .video {
            self.title = "选择视频"
        }
    }
}
