//
//  KWApplication.swift
//  KIWI
//
//  Created by li zhou on 2019/11/4.
//  Copyright © 2019 li zhou. All rights reserved.
//

import Foundation
import UIKit
class KWDevice : NSObject {
    
    public class func testDeveictID()->String {
        return uuid()
        //        return "test Deveice ID"
    }
    
    //uuid
    public class func uuid() ->String {
        
        if let deveiceUUID = UIDevice.current.identifierForVendor?.uuidString {
            return deveiceUUID
        }
        
        return ""
    }
//    deveiceUUID    String    "9D3B6086-7760-495F-926C-605039140C15"
//    deveiceUUID    String    "9D3B6086-7760-495F-926C-605039140C15"
    //设备信息
    public class func deviceInfo() -> String {
        return deviceType() + "-" + deviceVersion()
    }
    
    //版本
    public class func appVersion()-> String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return "AppVersionMark" + version
        }
        return ""
    }
    
    //版本
    public class func bundleVersion() -> String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return version
        }
        return ""
    }
}

extension KWDevice {
    //系统版本
    fileprivate class func deviceVersion() -> String {
        return UIDevice.current.systemVersion
    }
    
    //机型
    fileprivate class func deviceType() -> String {
        
        var systemInfo : utsname = utsname()
        
        uname(&systemInfo)
        
        let mirror = Mirror(reflecting: systemInfo.machine)
        
        let device = mirror.children.reduce("")
        { result, element in
            
            guard let value = element.value as? Int8, value != 0
                
                else { return result }
            
            return result + String(UnicodeScalar(UInt8(value)))
        }
        
        switch device {
        case "iPhone1,1" :  return "iPhone 1G"
        case "iPhone1,2" :  return "iPhone 3G"
        case "iPhone2,1" :  return "iPhone 3GS"
        case "iPhone3,1" :  return "iPhone 4"
        case "iPhone3,2" :  return "Verizon iPhone 4"
        case "iPhone4,1" :  return "iPhone 4S"
        case "iPhone5,1" :  return "iPhone 5"
        case "iPhone5,2" :  return "iPhone 5"
        case "iPhone5,3" :  return "iPhone 5C"
        case "iPhone5,4" :  return "iPhone 5C"
        case "iPhone6,1" :  return "iPhone 5S"
        case "iPhone6,2" :  return "iPhone 5S"
        case "iPhone7,1" :  return "iPhone 6 Plus"
        case "iPhone7,2" :  return "iPhone 6"
        case "iPhone8,1" :  return "iPhone 6s"
        case "iPhone8,2" :  return "iPhone 6s Plus"
        case "iPhone8,4" :  return "iPhone SE"
        case "iPhone9,1" :  return "iPhone 7"
        case "iPhone9,2" :  return "iPhone 7 Plus"
        case "iPod1,1"   :  return "iPod Touch 1G"
        case "iPod2,1"   :  return "iPod Touch 2G"
        case "iPod3,1"   :  return "iPod Touch 3G"
        case "iPod4,1"   :  return "iPod Touch 4G"
        case "iPod5,1"   :  return "iPod Touch 5G"
        case "iPad1,1"   :  return "iPad"
        case "iPad2,1"   :  return "iPad 2 (WiFi)"
        case "iPad2,2"   :  return "iPad 2 (GSM)"
        case "iPad2,3"   :  return "iPad 2 (CDMA)"
        case "iPad2,4"   :  return "iPad 2 (32nm)"
        case "iPad2,5"   :  return "iPad mini (WiFi)"
        case "iPad2,6"   :  return "iPad mini (GSM)"
        case "iPad2,7"   :  return "iPad mini (CDMA)"
        case "iPad3,1"   :  return "iPad 3(WiFi)"
        case "iPad3,2"   :  return "iPad 3(CDMA)"
        case "iPad3,3"   :  return "iPad 3(4G)"
        case "iPad3,4"   :  return "iPad 4 (WiFi)"
        case "iPad3,5"   :  return "iPad 4 (4G)"
        case "iPad3,6"   :  return "iPad 4 (CDMA)"
        case "iPad4,1"   :  return "iPad Air"
        case "iPad4,2"   :  return "iPad Air"
        case "iPad4,3"   :  return "iPad Air"
        case "iPad5,3"   :  return "iPad Air 2"
        case "iPad5,4"   :  return "iPad Air 2"
        case "i386"      :  return "Simulator"
        case "x86_64"    :  return "Simulator"
        case "iPad4,4"   :  return "iPad mini 2"
        case "iPad4,5"   :  return "iPad mini 2"
        case "iPad4,6"   :  return "iPad mini 2"
        case "iPad4,7"   :  return "iPad mini 3"
        case "iPad4,8"   :  return "iPad mini 3"
        case "iPad4,9"   :  return "iPad mini 3"
        default          :  return device
        }
    }
}


extension KWDevice {
    
    fileprivate class func bundleId() -> String {
        if let bundleId = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String {
            return bundleId
        }
        return ""
    }
}
