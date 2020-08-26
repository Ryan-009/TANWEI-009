//
//  KWADInfo.swift
//  salestar
//
//  Created by 吴凯耀 on 2020/3/31.
//  Copyright © 2020 li zhou. All rights reserved.
//

import Foundation

class KWADInfo: NSObject {
    
    private let CURRENTCAMERAIDKEY = "CURRENTCAMERAIDKEY"
    
    var info : [contentDtoModel] = [] {
        didSet{}
    }
    
    public func loadData() {
        
    }
    
    public func update() {
        var par : [String:Any] = [:]
        par[KWNetworkDefine.KEY.limit.rawValue] = 50
        par[KWNetworkDefine.KEY.start.rawValue] = 0
        par[KWNetworkDefine.KEY.userId.rawValue] = KWUser.userInfo.userId
        Application.list.searchByUser(parameters: par, success: { (dtos) in
            self.info = dtos
            KWListener.poster.myAdLoaded()
        }) {}
    }
    
    public func clear() {
        
    }
    
    public func post() {
        
    }
    
}
