//
//  KWTotalDevicesInfo.swift
//  KIWI
//
//  Created by li zhou on 2019/11/11.
//  Copyright © 2019 li zhou. All rights reserved.
//

import UIKit

class KWDevicesInfo: NSObject {
    
    private let CURRENTHOMEIDKEY   = "CURRENTHOMEIDKEY"
    
    
    var info : [KWDeviceInfoModel] = [] {
        didSet{
            if self.currentHomeId == "" && info.count > 0{
                self.currentHome = info[0]
                self.currentHomeId = self.currentHome.home.homeId
            }else {
                for home in info{
                    if home.home.homeId == currentHomeId {
                        self.currentHome = home
                    }
                }
            }
            self.post()
        }
    }
    var currentHome : KWDeviceInfoModel = KWDeviceInfoModel(){
        didSet{
            for device in currentHome.deviceList{
                if device.type == .camera {
                    
                }
            }
        }
    }
    var currentHomeId : String = "" {
        didSet{
            writeHomeId()
        }
    }
    
    public func loadData() {
        readHomeId()
        Application.list.deviceList(homeId: nil, success: { (models) in
            self.info = models
        }) {}
    }
    public func update() {
        readHomeId()
        Application.list.deviceList(homeId: nil, success: { (models) in
            self.info = models
        }) {}
    }
    public func post() {
        KWUIListener.poster.deviceInfoLoadData()
    }
    
    public func clear(){
        UserDefaults.standard.removeObject(forKey: CURRENTHOMEIDKEY)
    }
    
    private func readHomeId() {
        if let homeId = UserDefaults.standard.value(forKey: CURRENTHOMEIDKEY) as? String {
            self.currentHomeId = homeId
        }
    }
    private func writeHomeId() {
        UserDefaults.standard.set(self.currentHomeId, forKey: CURRENTHOMEIDKEY)
        UserDefaults.standard.synchronize()
    }
    
}
