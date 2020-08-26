//
//  KWApplication.swift
//  KIWI
//
//  Created by li zhou on 2019/11/4.
//  Copyright © 2019 li zhou. All rights reserved.
//

import Foundation

class KWUser : NSObject {
    public class func shared() -> KWUser {return KWUser.sharedUser}
    private static let sharedUser = KWUser()
    private override init() {}
    
    //用户类型
    enum UserType : Int {
        case unknow  = 0
    }
    
    static var userInfo = KWUserInfo()
    static var devicesInfo = KWDevicesInfo()
    static var catInfo  = KWCatInfo()
    static var adInfo  = KWADInfo()
    
    public class func open() {
        userInfo.loadData()
        devicesInfo.loadData()
    }
    
    public class func update() {
        userInfo.update()
    }
    
    public class func close() {
        userInfo.clearData()
        devicesInfo.clear()
        adInfo.clear()
    }
}
