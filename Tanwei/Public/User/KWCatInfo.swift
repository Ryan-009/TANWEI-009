//
//  KWCatInfo.swift
//  KIWI
//
//  Created by li zhou on 2019/11/20.
//  Copyright © 2019 li zhou. All rights reserved.
//

import UIKit

class KWCatInfo: NSObject {
    
    
    private let CURRENTCAMERAIDKEY = "CURRENTCAMERAIDKEY"
    
    var info : [KWDeviceCatModel] = [] {
        didSet{
            for cat in KWUser.catInfo.info{
                if cat.type == .camera {
                    self.currentCameraCatId = cat.id
                }
            }
        }
    }
    
    var currentCameraCatId : Int = 0 {
        didSet{
            writeCameraId()
        }
    }
    
    public func loadData() {
        if KWUser.devicesInfo.info.count > 0 {
            Application.list.devicecatlist(homeId: KWUser.devicesInfo.currentHome.home.homeId, success: { (catList) in
                self.info = catList
                self.post()
            }) {}
        }
    }
    
    public func update() {
        if KWUser.devicesInfo.info.count > 0 {
            Application.list.devicecatlist(homeId: KWUser.devicesInfo.currentHome.home.homeId, success: { (catList) in
                self.info = catList
                self.post()
            }) {}
        }
    }
    
    public func clear() {
        UserDefaults.standard.removeObject(forKey: CURRENTCAMERAIDKEY)
    }
    
    public func post() {
        KWUIListener.poster.catInfoLoadData()
    }
    
    private func readCameraId() {
        if let cameraId = UserDefaults.standard.value(forKey: CURRENTCAMERAIDKEY) as? Int {
            self.currentCameraCatId = cameraId
        }
    }
    private func writeCameraId() {
        UserDefaults.standard.set(currentCameraCatId, forKey: CURRENTCAMERAIDKEY)
        UserDefaults.standard.synchronize()
    }
}
