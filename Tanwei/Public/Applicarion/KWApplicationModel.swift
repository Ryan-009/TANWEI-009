//
//  KWApplication.swift
//  KIWI
//
//  Created by li zhou on 2019/11/4.
//  Copyright © 2019 li zhou. All rights reserved.
//

import Foundation
import UIKit

class KWHomeModel: NSObject {
    var homeId              : String = ""
    var name                : String = ""
    var location            : String = ""
    var desc                : String = ""
    var createdAt           : String = ""
    var updatedAt           : String = ""
    var status              : KWNetworkDefine.status = .unknow
}

class KWStationModel: NSObject {
    var stationId           : String = ""
    var sn                  : String = ""
    var macAddr             : String = ""
    var ipAddr              : String = ""
    var name                : String = ""
    var homeId              : String = ""
    var catId               : Int    = 0
    var desc                : String = ""
    var status              : KWNetworkDefine.status = .unknow
    var softwareVer         : String = ""
    var hardwareVer         : String = ""
    var createdAt           : String = ""
    var updatedAt           : String = ""
}

class KWCameraModel: NSObject {
    var uuid                : String = ""
    var sn                  : String = ""
    var account             : String = ""
    var password            : String = ""
    var macAddr             : String = ""
    var ipAddr              : String = ""
    var name                : String = ""
    var homeId              : String = ""
    var status              : KWNetworkDefine.status = .unknow
    var catId               : Int    = 0
    var desc                : String = ""
    var sortByHome          : Int    = 0
    var sortByRoom          : Int    = 0
    var softwareVer         : String = ""
    var hardwareVer         : String = ""
    var createdAt           : String = ""
    var updatedAt           : String = ""
}

class KWDeviceModel: NSObject {
    var modelNo                 : String = ""
    var sn                      : String = ""
    var type                    : KWNetworkDefine.deviceType = .unknow
    var icon                    : String = ""
    var attributes              : String = ""
    var macAddr                 : String = ""
    var ipAddr                  : String = ""
    var name                    : String = ""
    var homeId                  : String = ""
    var catId                   : Int    = 0
    var desc                    : String = ""
    var sortByHome              : Int    = 0
    var sortByRoom              : Int    = 0
    var hardwareVer             : String = ""
    var softwareVer             : String = ""
    var updatedAt               : String = ""
    var createdAt               : String = ""
    var status                  : KWNetworkDefine.status     = .unknow
    var statusCode              : KWNetworkDefine.statusCode = .unknow
}

class KWDeviceInfoModel: NSObject {
    var isManager : KWNetworkDefine.isManagerType = .unknow
    var home : KWHomeModel = KWHomeModel()
    var station : KWStationModel = KWStationModel()
    var cameraList : [KWCameraModel] = []
    var deviceList : [KWDeviceModel] = []
}

class KWFaceidModel: NSObject {
    var faceid      : String = ""
    var faceidCode  : String = ""
    var from        : String = ""
}

class KWFaceidListsModel: NSObject {
    var uid : String = ""
    var faceidList : [KWFaceidModel] = []
}

class KWDeviceCatModel: NSObject {
    var id   : Int      = 0
    var name : String   = ""
    var homeId : String = ""
    var icon : String   = ""
    var desc : String   = ""
    var sort : Int      = 0
    var created_at : String = ""
    var type :KWNetworkDefine.deviceCatType = .defaults
}

class KWADModel : NSObject {
    var images  : [String] = []
    var text    : String = ""
    var header  : String = ""
    var name    : String = ""
    var link    : String = ""
}

class bannerItemModel : NSObject {
    var bannerDesc  : String = ""
    var bannerId    : Int    = 0
    var bannerName  : String = ""
    var createTime  : Int    = 0
    var imageUrl    : String = ""
}

class authorModel: NSObject {
    var company : String = ""
    var credit : Int = 0
    var name : String = ""
    var photoUrl : String = ""
    var userId : String = ""
}

class contentDtoModel: NSObject {
    
    var author : authorModel = authorModel()
    var companyPortal : String = ""
    var content : String = ""
    var createTime : String = ""
    var imgResIds : String = ""
    var keywords : String = ""
    var profession : String = ""
    var region : String = ""
    var reward : Int = 0
    var company : String = ""
    var maxReward : Int = 0
    var userId : Int = 0
    var username : String = ""
    var iconImage : String = ""
    var image      : String = ""
    var cPhone  : String = ""
    var jobPosition : String = ""
    var wechatId : String = ""
    var jobDesc : String = ""
    var commanyAddr : String = ""
    var phone   : String = ""
    var showAll : Bool = false {
        didSet{
            if showAll {
                cellHeight = cellMaxHeight
            }else{
                cellHeight = cellNormalHeight
            }
        }
    }
    var cellHeight       : CGFloat = 0
    var cellMaxHeight    : CGFloat = 0
    var cellNormalHeight : CGFloat = 0
}

class allBannarModel: NSObject {
    var bannerId : Int = 0
    var bannerName : String = ""
    var border : Int = 0
    var createTime : String = ""
    var delFlag : String = ""
    var isShow : Int = 0
    var resId : String = ""
    var updateTime : String = ""
    var winsDt : String = ""
}

class contentModel: NSObject {

    var cotent : String = ""
    var cotentId : Int = 0
    var curPrice : Int = 0
    var origPrice : Int = 0
    var region : String = ""
    var resId : String = ""
    var userId : Int = 0
    var addr : String = ""
    var contactPhone : String = ""
    var imageHead : String = ""
    var userName : String = ""
    var wechatId : String = ""
    var shopCode : String = ""
    var fansNum : Int = 0
    var contentType : String = ""
    var imagesForTransmit : [UIImage] = []
    var userType : KWNetworkDefine.userType = .unknow
    var showAll : Bool = false {
        didSet{
            if showAll {
                cellHeight = cellMaxHeight
            }else{
                cellHeight = cellNormalHeight
            }
        }
    }
    var cellHeight       : CGFloat = 0
    var cellMaxHeight    : CGFloat = 0
    var cellNormalHeight : CGFloat = 0
}

class FocusContent : NSObject {
    var imageHead : String = ""
    var userName : String = ""
    var userId : Int = 0
}

class agentInfo : NSObject {
    
    var acount : String = ""
    var agent_status : String = ""
    var recommendCode : String = ""
    
//    acount = "754208608@qq.com";
//    "agent_status" = 1;
//    imageHead = 35;
//    recommendCode = 000004;
}
