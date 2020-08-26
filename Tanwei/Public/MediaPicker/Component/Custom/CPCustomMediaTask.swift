//
//  CPCustomMediaTask.swift
//  RedsMeMe
//
//  Created by reds on 2017/6/2.
//  Copyright © 2017年 Reds. All rights reserved.
//

import Foundation
import Photos

class CPCustomMediaTask: NSObject{
    enum PickType {
        case assets
        case albums
    }
    
    typealias FetchAssets = (_ assets : Array<PHAsset>)->()
    typealias FetchAlbums = (_ albums : Array<CPCustomMediaAlbum>)->()
    
    var assetsResult : FetchAssets?  //资源类型选择结果
    var albumsResult : FetchAlbums?  //相册类型选择结果
    
    var fetchType : PHAssetMediaType! //资源类型  [图片，视频]
    var pickType  : PickType!         //选择器类型[图片，相册]
    
    //资源类型
    init(fetchType : PHAssetMediaType, pickType : PickType , assetsResult : @escaping FetchAssets) {
        super.init()
        self.fetchType    = fetchType
        self.pickType     = pickType
        self.assetsResult = assetsResult
    }
    
    //相册类型
    init(fetchType : PHAssetMediaType, pickType : PickType , albumsResult : @escaping FetchAlbums) {
        super.init()
        self.fetchType    = fetchType
        self.pickType     = pickType
        self.albumsResult = albumsResult
    }
    
}
