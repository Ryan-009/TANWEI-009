//
//  CPCustomMediaAlbum.swift
//  RedsMeMe
//
//  Created by reds on 2017/6/2.
//  Copyright © 2017年 Reds. All rights reserved.
//

import Foundation
import Photos

class CPCustomMediaAlbum: NSObject {
    var name : String!
    var assets : Array<PHAsset>!
    
    init(name : String, result : PHFetchResult<PHAsset>) {
        super.init()
        self.name   = name
        self.assets = fetchAssets(result: result)
        
    }
}

extension CPCustomMediaAlbum {
    fileprivate func fetchAssets(result : PHFetchResult<PHAsset>) ->Array<PHAsset> {
        
        var assets : Array<PHAsset> = Array()
        
        let count : Int = result.count
        
        for i in 0..<count { assets.append(result[i] as PHAsset) }
        
        return assets
    }
}
