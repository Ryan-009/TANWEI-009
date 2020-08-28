//
//  DDParseTask.swift
//  REDSDD
//
//  Created by rui chen on 2017/10/26.
//  Copyright © 2017年 Reds. All rights reserved.
//
//  KWApplication.swift
//  KIWI
//
//  Created by li zhou on 2019/11/4.
//  Copyright © 2019 li zhou. All rights reserved.
//

import UIKit
import SwiftyJSON

class KWParseTask: NSObject {}

extension KWParseTask {
    
    //用户获取商店商品列表
    internal class func deviceList(array : [JSON]) -> Array<KWDeviceInfoModel> {
        var devicesArray : Array<KWDeviceInfoModel> = []
        
        for devicesJson in array {
            if let devicesDic = devicesJson.dictionary {
                let deviceInfomodel = KWDeviceInfoModel()
                deviceInfomodel.isManager = KWNetworkDefine.isManagerType(rawValue: KWParse.int(devicesDic, key: KWNetworkDefine.KEY.isManager.rawValue)) ?? .unknow
                if let homeDic = devicesDic[KWNetworkDefine.KEY.home.rawValue]?.dictionary {
                    let homeModel = KWHomeModel()
                    homeModel.createdAt = KWParse.string(homeDic, key: KWNetworkDefine.KEY.createdAt.rawValue)
                    homeModel.homeId = KWParse.string(homeDic, key: KWNetworkDefine.KEY.homeId.rawValue)
                    homeModel.name = KWParse.string(homeDic, key: KWNetworkDefine.KEY.name.rawValue)
                    homeModel.location = KWParse.string(homeDic, key: KWNetworkDefine.KEY.updatedAt.rawValue)
                    homeModel.desc = KWParse.string(homeDic, key: KWNetworkDefine.KEY.desc.rawValue)
                    homeModel.updatedAt = KWParse.string(homeDic, key: KWNetworkDefine.KEY.updatedAt.rawValue)
                    homeModel.status = KWNetworkDefine.status(rawValue: KWParse.int(homeDic, key: KWNetworkDefine.KEY.status.rawValue)) ?? .unknow
                    deviceInfomodel.home = homeModel
                }
                
                if let stationDic = devicesDic[KWNetworkDefine.KEY.station.rawValue]?.dictionary {
                    let stationModel = KWStationModel()
                    stationModel.catId = KWParse.int(stationDic, key: KWNetworkDefine.KEY.catId.rawValue)
                    stationModel.createdAt = KWParse.string(stationDic, key: KWNetworkDefine.KEY.createdAt.rawValue)
                    stationModel.desc = KWParse.string(stationDic, key: KWNetworkDefine.KEY.desc.rawValue)
                    stationModel.hardwareVer = KWParse.string(stationDic, key: KWNetworkDefine.KEY.hardwareVer.rawValue)
                    stationModel.homeId = KWParse.string(stationDic, key: KWNetworkDefine.KEY.homeId.rawValue)
                    stationModel.ipAddr = KWParse.string(stationDic, key: KWNetworkDefine.KEY.ipAddr.rawValue)
                    stationModel.status = KWNetworkDefine.status(rawValue: KWParse.int(stationDic, key: KWNetworkDefine.KEY.status.rawValue)) ?? .unknow
                    stationModel.name = KWParse.string(stationDic, key: KWNetworkDefine.KEY.name.rawValue)
                    stationModel.sn = KWParse.string(stationDic, key: KWNetworkDefine.KEY.sn.rawValue)
                    stationModel.softwareVer = KWParse.string(stationDic, key: KWNetworkDefine.KEY.softwareVer.rawValue)
                    stationModel.stationId = KWParse.string(stationDic, key: KWNetworkDefine.KEY.stationId.rawValue)
                    stationModel.updatedAt = KWParse.string(stationDic, key: KWNetworkDefine.KEY.updatedAt.rawValue)
                    stationModel.macAddr = KWParse.string(stationDic, key: KWNetworkDefine.KEY.macAddr.rawValue)
                    
                    deviceInfomodel.station = stationModel
                }
                
                if let deviceListArray = devicesDic[KWNetworkDefine.KEY.deviceList.rawValue]?.array {
                    var deviceList : [KWDeviceModel] = []
                    for deviceJson in deviceListArray {
                        if let deviceDic = deviceJson.dictionary {
                            let deviceModel = KWDeviceModel()
                            deviceModel.modelNo = KWParse.string(deviceDic, key: KWNetworkDefine.KEY.modelNo.rawValue)
                            deviceModel.sn = KWParse.string(deviceDic, key: KWNetworkDefine.KEY.sn.rawValue)
                            deviceModel.type = KWNetworkDefine.deviceType(rawValue: KWParse.string(deviceDic, key: KWNetworkDefine.KEY.type.rawValue))
                            deviceModel.icon = KWParse.string(deviceDic, key: KWNetworkDefine.KEY.icon.rawValue)
                            deviceModel.attributes = KWParse.string(deviceDic, key: KWNetworkDefine.KEY.attributes.rawValue)
                            deviceModel.macAddr = KWParse.string(deviceDic, key: KWNetworkDefine.KEY.macAddr.rawValue)
                            deviceModel.ipAddr = KWParse.string(deviceDic, key: KWNetworkDefine.KEY.ipAddr.rawValue)
                            deviceModel.name = KWParse.string(deviceDic, key: KWNetworkDefine.KEY.name.rawValue)
                            deviceModel.homeId = KWParse.string(deviceDic, key: KWNetworkDefine.KEY.homeId.rawValue)
                            deviceModel.catId = KWParse.int(deviceDic, key: KWNetworkDefine.KEY.catId.rawValue)
                            deviceModel.desc = KWParse.string(deviceDic, key: KWNetworkDefine.KEY.desc.rawValue)
                            deviceModel.sortByHome = KWParse.int(deviceDic, key: KWNetworkDefine.KEY.sortByHome.rawValue)
                            deviceModel.sortByRoom = KWParse.int(deviceDic, key: KWNetworkDefine.KEY.sortByRoom.rawValue)
                            deviceModel.hardwareVer = KWParse.string(deviceDic, key: KWNetworkDefine.KEY.hardwareVer.rawValue)
                            deviceModel.softwareVer = KWParse.string(deviceDic, key: KWNetworkDefine.KEY.softwareVer.rawValue)
                            deviceModel.updatedAt = KWParse.string(deviceDic, key: KWNetworkDefine.KEY.updatedAt.rawValue)
                            deviceModel.createdAt = KWParse.string(deviceDic, key: KWNetworkDefine.KEY.createdAt.rawValue)
                            deviceModel.status = KWNetworkDefine.status(rawValue: KWParse.int(deviceDic, key: KWNetworkDefine.KEY.status.rawValue)) ?? .unknow
                            deviceModel.statusCode = KWNetworkDefine.statusCode(rawValue: KWParse.int(deviceDic, key: KWNetworkDefine.KEY.statusCode.rawValue)) ?? .unknow
                            deviceList.append(deviceModel)
                        }
                    }
                    deviceInfomodel.deviceList = deviceList
                }
                
                if let cameraListArray = devicesDic[KWNetworkDefine.KEY.cameraList.rawValue]?.array {
                    var cameraList : [KWCameraModel] = []
                    for cameraJson in cameraListArray {
                        if let cameraDic = cameraJson.dictionary {
                            let cameraModel = KWCameraModel()
                            cameraModel.sn = KWParse.string(cameraDic, key: KWNetworkDefine.KEY.sn.rawValue)
                            cameraModel.macAddr = KWParse.string(cameraDic, key: KWNetworkDefine.KEY.macAddr.rawValue)
                            cameraModel.ipAddr = KWParse.string(cameraDic, key: KWNetworkDefine.KEY.ipAddr.rawValue)
                            cameraModel.name = KWParse.string(cameraDic, key: KWNetworkDefine.KEY.name.rawValue)
                            cameraModel.homeId = KWParse.string(cameraDic, key: KWNetworkDefine.KEY.homeId.rawValue)
                            cameraModel.catId = KWParse.int(cameraDic, key: KWNetworkDefine.KEY.catId.rawValue)
                            cameraModel.desc = KWParse.string(cameraDic, key: KWNetworkDefine.KEY.desc.rawValue)
                            cameraModel.sortByHome = KWParse.int(cameraDic, key: KWNetworkDefine.KEY.sortByHome.rawValue)
                            cameraModel.sortByRoom = KWParse.int(cameraDic, key: KWNetworkDefine.KEY.sortByRoom.rawValue)
                            cameraModel.hardwareVer = KWParse.string(cameraDic, key: KWNetworkDefine.KEY.hardwareVer.rawValue)
                            cameraModel.softwareVer = KWParse.string(cameraDic, key: KWNetworkDefine.KEY.softwareVer.rawValue)
                            cameraModel.updatedAt = KWParse.string(cameraDic, key: KWNetworkDefine.KEY.updatedAt.rawValue)
                            cameraModel.createdAt = KWParse.string(cameraDic, key: KWNetworkDefine.KEY.createdAt.rawValue)
                            cameraModel.account = KWParse.string(cameraDic, key: KWNetworkDefine.KEY.account.rawValue)
                            cameraModel.password = KWParse.string(cameraDic, key: KWNetworkDefine.KEY.password.rawValue)
                            cameraModel.status = KWNetworkDefine.status(rawValue: KWParse.int(cameraDic, key: KWNetworkDefine.KEY.status.rawValue)) ?? .unknow
                           
                            cameraList.append(cameraModel)
                        }
                    }
                    deviceInfomodel.cameraList = cameraList
                }
                
                devicesArray.append(deviceInfomodel)
            }
        }
        
    
        return devicesArray
    }
    
    //用户获取商店商品列表
    internal class func faceidlist(list : Dictionary<String,JSON>) -> Array<KWFaceidListsModel> {
        var lists : Array<KWFaceidListsModel> = Array()
        let array = KWParse.array(list, key: KWNetworkDefine.KEY.faceidLists.rawValue)
        for objJson in array {
            let listsMode = KWFaceidListsModel()
            if let dic = objJson.dictionary {
                listsMode.uid       = KWParse.string(dic, key: KWNetworkDefine.KEY.uid.rawValue)
                let faceidArray = KWParse.array(dic, key: KWNetworkDefine.KEY.faceidList.rawValue)
                for faceidJson in faceidArray {
                    let faceidmodel = KWFaceidModel()
                    if let faceidDic = faceidJson.dictionary {
                        faceidmodel.faceid = KWParse.string(faceidDic, key: KWNetworkDefine.KEY.faceid.rawValue)
                        faceidmodel.faceidCode = KWParse.string(faceidDic, key: KWNetworkDefine.KEY.faceidCode.rawValue)
                        faceidmodel.from = KWParse.string(faceidDic, key: KWNetworkDefine.KEY.from.rawValue)
                        listsMode.faceidList.append(faceidmodel)
                    }
                }
            }
            lists.append(listsMode)
        }
        return lists
    }
    
    //用户获取商店商品列表
    internal class func devicecatlist(list : Dictionary<String,JSON>) -> Array<KWDeviceCatModel> {
        var lists : Array<KWDeviceCatModel> = Array()
        let array = KWParse.array(list, key: KWNetworkDefine.KEY.deviceCatList.rawValue)
        for objJson in array {
            
            if let dic = objJson.dictionary {
                let listsMode = KWDeviceCatModel()
                
                listsMode.name       = KWParse.string(dic, key: KWNetworkDefine.KEY.name.rawValue)
                listsMode.homeId     = KWParse.string(dic, key: KWNetworkDefine.KEY.homeId.rawValue)
                listsMode.icon       = KWParse.string(dic, key: KWNetworkDefine.KEY.icon.rawValue)
                listsMode.desc       = KWParse.string(dic, key: KWNetworkDefine.KEY.desc.rawValue)
                listsMode.sort       = KWParse.int(dic, key: KWNetworkDefine.KEY.sort.rawValue)
                listsMode.created_at = KWParse.string(dic, key: KWNetworkDefine.KEY.created_at.rawValue)
                listsMode.id         = KWParse.int(dic, key: KWNetworkDefine.KEY.id.rawValue)
                listsMode.type     = KWNetworkDefine.deviceCatType(rawValue: KWParse.int(dic, key: KWNetworkDefine.KEY.type.rawValue)) ?? .defaults
                
                lists.append(listsMode)
            }
            
        }
        return lists
    }

    
    //用户获取商店商品列表
    internal class func activelist(list : Dictionary<String,JSON>) -> Array<bannerItemModel> {
        var lists : Array<bannerItemModel> = Array()
        let array = KWParse.array(list, key: KWNetworkDefine.KEY.bannerItemList.rawValue)
        for objJson in array {
            
            if let dic = objJson.dictionary {
                let listsMode = bannerItemModel()
                listsMode.bannerDesc       = KWParse.string(dic, key: KWNetworkDefine.KEY.bannerDesc.rawValue)
                listsMode.bannerId       = KWParse.int(dic, key: KWNetworkDefine.KEY.bannerId.rawValue)
                listsMode.bannerName       = KWParse.string(dic, key: KWNetworkDefine.KEY.bannerName.rawValue)
                listsMode.createTime       = KWParse.int(dic, key: KWNetworkDefine.KEY.createTime.rawValue)
                listsMode.imageUrl       = KWParse.string(dic, key: KWNetworkDefine.KEY.imageUrl.rawValue)
                
                lists.append(listsMode)
            }
            
        }
        return lists
    }
    
    //用户获取商店商品列表
    internal class func allBanners(list : Dictionary<String,JSON>) -> Array<allBannarModel> {
        var lists : Array<allBannarModel> = Array()
        let array = KWParse.array(list, key: KWNetworkDefine.KEY.bannerItemList.rawValue)
        for objJson in array {
            
            if let dic = objJson.dictionary {
                let listsMode = allBannarModel()
                listsMode.bannerId       = KWParse.int(dic, key: KWNetworkDefine.KEY.bannerId.rawValue)
                listsMode.bannerName       = KWParse.string(dic, key: KWNetworkDefine.KEY.bannerName.rawValue)
                listsMode.border       = KWParse.int(dic, key: KWNetworkDefine.KEY.border.rawValue)
                listsMode.createTime       = KWParse.string(dic, key: KWNetworkDefine.KEY.createTime.rawValue)
                listsMode.delFlag       = KWParse.string(dic, key: KWNetworkDefine.KEY.delFlag.rawValue)
                
                listsMode.isShow       = KWParse.int(dic, key: KWNetworkDefine.KEY.isShow.rawValue)
                listsMode.resId       = KWParse.string(dic, key: KWNetworkDefine.KEY.resId.rawValue)
                listsMode.updateTime       = KWParse.string(dic, key: KWNetworkDefine.KEY.updateTime.rawValue)
                listsMode.winsDt       = KWParse.string(dic, key: KWNetworkDefine.KEY.winsDt.rawValue)
            
                lists.append(listsMode)
            }
            
        }
        return lists
    }
    
    
    //用户获取商店商品列表
    internal class func search(list : Dictionary<String,JSON>) -> Array<contentDtoModel> {
        var lists : Array<contentDtoModel> = Array()
        let array = KWParse.array(list, key: KWNetworkDefine.KEY.contentDtoList.rawValue)
        for objJson in array {

            if let dic = objJson.dictionary {
                let listsMode = contentDtoModel()
                listsMode.companyPortal       = KWParse.string(dic, key: KWNetworkDefine.KEY.companyPortal.rawValue)
                listsMode.content       = KWParse.string(dic, key: KWNetworkDefine.KEY.content.rawValue)
                listsMode.createTime    = KWParse.string(dic, key: KWNetworkDefine.KEY.createTime.rawValue)
                listsMode.imgResIds     = KWParse.string(dic, key: KWNetworkDefine.KEY.imgResIds.rawValue)
                listsMode.keywords      = KWParse.string(dic, key: KWNetworkDefine.KEY.keywords.rawValue)
                listsMode.profession    = KWParse.string(dic, key: KWNetworkDefine.KEY.profession.rawValue)
                listsMode.region        = KWParse.string(dic, key: KWNetworkDefine.KEY.region.rawValue)
                listsMode.reward        = KWParse.int(dic, key: KWNetworkDefine.KEY.reward.rawValue)
                listsMode.username      = KWParse.string(dic, key: KWNetworkDefine.KEY.username.rawValue)
                listsMode.userId        = KWParse.int(dic, key: KWNetworkDefine.KEY.userId.rawValue)
                listsMode.maxReward     = KWParse.int(dic, key: KWNetworkDefine.KEY.maxReward.rawValue)
                listsMode.iconImage     = KWParse.string(dic, key: KWNetworkDefine.KEY.iconImage.rawValue)
                listsMode.image     = KWParse.string(dic, key: KWNetworkDefine.KEY.image.rawValue)
                listsMode.commanyAddr     = KWParse.string(dic, key: KWNetworkDefine.KEY.commanyAddr.rawValue)
                listsMode.jobDesc     = KWParse.string(dic, key: KWNetworkDefine.KEY.jobDesc.rawValue)
                listsMode.wechatId     = KWParse.string(dic, key: KWNetworkDefine.KEY.wechatId.rawValue)
                listsMode.jobPosition     = KWParse.string(dic, key: KWNetworkDefine.KEY.jobPosition.rawValue)
                listsMode.cPhone     = KWParse.string(dic, key: KWNetworkDefine.KEY.cPhone.rawValue)
                listsMode.company = KWParse.string(dic, key: KWNetworkDefine.KEY.company.rawValue)
                listsMode.phone = KWParse.string(dic, key: KWNetworkDefine.KEY.phone.rawValue)
                var maxHeight : CGFloat = 0
                var normalHeight : CGFloat = 0
                let realTextHeight = GetLabHeigh(labelStr: listsMode.content, font: UIFont.systemFont(ofSize: 15), width: SCREEN_WIDTH-AutoW(30))
                //当有图片内容时，加上图片高度
                if listsMode.imgResIds != "" {
                    //内容少于5行情况
                    if realTextHeight < NormalTextMaxHeight {
                        maxHeight = realTextHeight + SingelADImageCellWidth +  AutoW(15)*5 + AutoW(83)
                        normalHeight = realTextHeight + SingelADImageCellWidth +  AutoW(15)*5 + AutoW(83)
                    }else{
                        maxHeight = realTextHeight + SingelADImageCellWidth +  AutoW(15)*5 + AutoW(83)
                        normalHeight = NormalTextMaxHeight + SingelADImageCellWidth +  AutoW(15)*5 + AutoW(83)
                    }
                }else{
                    if realTextHeight < NormalTextMaxHeight {
                        maxHeight = realTextHeight + AutoW(15)*4 + AutoW(83)
                        normalHeight = realTextHeight + AutoW(15)*4 + AutoW(83)
                    }else{
                        maxHeight = realTextHeight + AutoW(15)*4 + AutoW(83)
                        normalHeight = NormalTextMaxHeight + AutoW(15)*4 + AutoW(83)
                    }
                }
                //当内容大于NormalTextMaxHeight时，加上全文按钮高度
                if maxHeight > normalHeight + 2{///2是计算可容纳的误差
                    maxHeight = maxHeight + SHOWORHIDEBUTTONHEIGHT
                    normalHeight = normalHeight + SHOWORHIDEBUTTONHEIGHT
                }
                //头像变大8px,暂时这里加上
                maxHeight += AutoW(8) + AutoW(30)
                normalHeight += AutoW(8) + AutoW(30)

                listsMode.cellMaxHeight = maxHeight
                listsMode.cellNormalHeight = normalHeight
                listsMode.cellHeight = normalHeight

                if let authorDic = dic[KWNetworkDefine.KEY.author.rawValue]?.dictionary {
                    let author = authorModel()
                    author.company = KWParse.string(authorDic, key: KWNetworkDefine.KEY.company.rawValue)
                    author.credit = KWParse.int(authorDic, key: KWNetworkDefine.KEY.credit.rawValue)
                    author.name = KWParse.string(authorDic, key: KWNetworkDefine.KEY.name.rawValue)
                    author.photoUrl = KWParse.string(authorDic, key: KWNetworkDefine.KEY.photoUrl.rawValue)
                    author.userId = KWParse.string(authorDic, key: KWNetworkDefine.KEY.userId.rawValue)
                    listsMode.author = author
                }

                lists.append(listsMode)
            }
        }
        return lists
    }
    
    internal class func allContentFactory(list : Dictionary<String,JSON>) -> Array<contentModel> {
        var lists : Array<contentModel> = Array()
        let array = KWParse.array(list, key: KWNetworkDefine.KEY.array.rawValue)
        for objJson in array {
            if let dic = objJson.dictionary {
                let objc = contentModel()
                objc.cotent = KWParse.string(dic, key: KWNetworkDefine.KEY.cotent.rawValue)
                objc.region = KWParse.string(dic, key: KWNetworkDefine.KEY.region.rawValue)
                objc.resId = KWParse.string(dic, key: KWNetworkDefine.KEY.resId.rawValue)
                objc.cotentId = KWParse.int(dic, key: KWNetworkDefine.KEY.cotentId.rawValue)
                objc.curPrice = KWParse.int(dic, key: KWNetworkDefine.KEY.curPrice.rawValue)
                objc.origPrice = KWParse.int(dic, key: KWNetworkDefine.KEY.origPrice.rawValue)
                objc.userId = KWParse.int(dic, key: KWNetworkDefine.KEY.userId.rawValue)
                objc.addr = KWParse.string(dic, key: KWNetworkDefine.KEY.addr.rawValue)
                objc.contactPhone = KWParse.string(dic, key: KWNetworkDefine.KEY.contactPhone.rawValue)
                objc.imageHead = KWParse.string(dic, key: KWNetworkDefine.KEY.imageHead.rawValue)
                objc.userName = KWParse.string(dic, key: KWNetworkDefine.KEY.userName.rawValue)
                objc.wechatId = KWParse.string(dic, key: KWNetworkDefine.KEY.wechatId.rawValue)
                objc.shopCode = KWParse.string(dic, key: KWNetworkDefine.KEY.shopCode.rawValue)
                objc.contentType = KWParse.string(dic, key: KWNetworkDefine.KEY.contentType.rawValue)
                objc.fansNum = KWParse.int(dic, key: KWNetworkDefine.KEY.fansNum.rawValue)
                objc.userType = .wholesaler
                var maxHeight : CGFloat = 0
                var normalHeight : CGFloat = 0
                let realTextHeight = GetLabHeigh(labelStr: objc.cotent, font: UIFont.systemFont(ofSize: 15), width: SCREEN_WIDTH-AutoW(30))
                
                //当有图片内容时，加上图片高度
                if objc.resId != "" {
                    //内容少于5行情况
                    if realTextHeight < NormalTextMaxHeight {
                        maxHeight = realTextHeight + SingelADImageCellWidth +  AutoH(15)*5
                        normalHeight = realTextHeight + SingelADImageCellWidth +  AutoH(15)*5
                    }else{
                        maxHeight = realTextHeight + SingelADImageCellWidth +  AutoH(15)*5
                        normalHeight = NormalTextMaxHeight + SingelADImageCellWidth +  AutoH(15)*5
                    }
                }else{
                    if realTextHeight < NormalTextMaxHeight {
                        maxHeight = realTextHeight + AutoH(15)*4
                        normalHeight = realTextHeight + AutoH(15)*4
                    }else{
                        maxHeight = realTextHeight + AutoH(15)*4
                        normalHeight = NormalTextMaxHeight + AutoH(15)*4
                    }
                }
                //当内容大于NormalTextMaxHeight时，加上全文按钮高度
                if maxHeight > normalHeight + 2{///2是计算可容纳的误差
                    maxHeight = maxHeight + SHOWORHIDEBUTTONHEIGHT
                    normalHeight = normalHeight + SHOWORHIDEBUTTONHEIGHT
                }
                
                if KWUser.userInfo.userType == 1 {//卖家
                    maxHeight += AutoH(120)
                    normalHeight += AutoH(120)
                }else{
                    maxHeight += AutoH(50)
                    normalHeight += AutoH(50)
                }
                
                objc.cellMaxHeight = maxHeight
                objc.cellNormalHeight = normalHeight
                objc.cellHeight = normalHeight
                
                lists.append(objc)
            }
        }
        
        return lists
    }
    
    internal class func allContentShop(list : Dictionary<String,JSON>) -> Array<contentModel> {
        var lists : Array<contentModel> = Array()
        let array = KWParse.array(list, key: KWNetworkDefine.KEY.array.rawValue)
        for objJson in array {
            if let dic = objJson.dictionary {
                let objc = contentModel()
                objc.cotent = KWParse.string(dic, key: KWNetworkDefine.KEY.cotent.rawValue)
                objc.region = KWParse.string(dic, key: KWNetworkDefine.KEY.region.rawValue)
                objc.resId = KWParse.string(dic, key: KWNetworkDefine.KEY.resId.rawValue)
                objc.cotentId = KWParse.int(dic, key: KWNetworkDefine.KEY.cotentId.rawValue)
                objc.curPrice = KWParse.int(dic, key: KWNetworkDefine.KEY.curPrice.rawValue)
                objc.origPrice = KWParse.int(dic, key: KWNetworkDefine.KEY.origPrice.rawValue)
                objc.userId = KWParse.int(dic, key: KWNetworkDefine.KEY.userId.rawValue)
                objc.addr = KWParse.string(dic, key: KWNetworkDefine.KEY.addr.rawValue)
                objc.contactPhone = KWParse.string(dic, key: KWNetworkDefine.KEY.contactPhone.rawValue)
                objc.imageHead = KWParse.string(dic, key: KWNetworkDefine.KEY.imageHead.rawValue)
                objc.userName = KWParse.string(dic, key: KWNetworkDefine.KEY.userName.rawValue)
                objc.wechatId = KWParse.string(dic, key: KWNetworkDefine.KEY.wechatId.rawValue)
                objc.shopCode = KWParse.string(dic, key: KWNetworkDefine.KEY.shopCode.rawValue)
                objc.contentType = KWParse.string(dic, key: KWNetworkDefine.KEY.contentType.rawValue)
                objc.fansNum = KWParse.int(dic, key: KWNetworkDefine.KEY.fansNum.rawValue)
                objc.userType = .saler
                
                var maxHeight : CGFloat = 0
                var normalHeight : CGFloat = 0
                let realTextHeight = GetLabHeigh(labelStr: objc.cotent, font: UIFont.systemFont(ofSize: 15), width: SCREEN_WIDTH-AutoW(30))
                //当有图片内容时，加上图片高度
                if objc.resId != "" {
                    //内容少于5行情况
                    if realTextHeight < NormalTextMaxHeight {
                        maxHeight = realTextHeight + SingelADImageCellWidth +  AutoH(15)*5
                        normalHeight = realTextHeight + SingelADImageCellWidth +  AutoH(15)*5
                    }else{
                        maxHeight = realTextHeight + SingelADImageCellWidth +  AutoH(15)*5
                        normalHeight = NormalTextMaxHeight + SingelADImageCellWidth +  AutoH(15)*5
                    }
                }else{
                    if realTextHeight < NormalTextMaxHeight {
                        maxHeight = realTextHeight + AutoH(15)*4
                        normalHeight = realTextHeight + AutoH(15)*4
                    }else{
                        maxHeight = realTextHeight + AutoH(15)*4
                        normalHeight = NormalTextMaxHeight + AutoH(15)*4
                    }
                }
                //当内容大于NormalTextMaxHeight时，加上全文按钮高度
                if maxHeight > normalHeight + 2{///2是计算可容纳的误差
                    maxHeight = maxHeight + SHOWORHIDEBUTTONHEIGHT
                    normalHeight = normalHeight + SHOWORHIDEBUTTONHEIGHT
                }
                
//                if KWUser.userInfo.userType == 1 {//卖家
//                    maxHeight += AutoW(120)
//                    normalHeight += AutoW(120)
//                }else{
                    maxHeight += AutoH(50)
                    normalHeight += AutoH(50)
//                }
                
                objc.cellMaxHeight = maxHeight
                objc.cellNormalHeight = normalHeight
                objc.cellHeight = normalHeight
                
                lists.append(objc)
            }
        }
        
        return lists
    }
    
    internal class func getFocusFactory(list : Dictionary<String,JSON>) -> Array<FocusContent> {
        var lists : Array<FocusContent> = Array()
        let array = KWParse.array(list, key: KWNetworkDefine.KEY.array.rawValue)
        for objJson in array {
            if let dic = objJson.dictionary {
                let objc = FocusContent()
                objc.imageHead = KWParse.string(dic, key: KWNetworkDefine.KEY.imageHead.rawValue)
                objc.userName = KWParse.string(dic, key: KWNetworkDefine.KEY.userName.rawValue)
                objc.userId = KWParse.int(dic, key: KWNetworkDefine.KEY.userId.rawValue)
                
                lists.append(objc)
            }
        }
        
        return lists
    }
    
    internal class func getAgentInfo(list : Dictionary<String,JSON>) -> agentInfo{
        let objc = agentInfo()
        objc.acount = KWParse.string(list, key: KWNetworkDefine.KEY.acount.rawValue)
        objc.recommendCode = KWParse.string(list, key: KWNetworkDefine.KEY.recommendCode.rawValue)
        return objc
    }
}







