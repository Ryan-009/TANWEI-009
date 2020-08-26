//
//  KWApplication.swift
//  KIWI
//
//  Created by li zhou on 2019/11/4.
//  Copyright © 2019 li zhou. All rights reserved.
//

import UIKit

class KWInfoListTask: NSObject {
    //获取开放城市列表
    internal func deviceList(homeId: String?,success: @escaping (_ list : Array<KWDeviceInfoModel>)->(), failure: @escaping ()->()) {}
    
    //faceid
    internal func faceidlist(homeId: String,limit: Int?,success: @escaping (_ list : Array<KWFaceidListsModel>)->(), failure: @escaping ()->()) {}
    
    //设备分组列表
    internal func devicecatlist(homeId: String,success: @escaping (_ list : Array<KWDeviceCatModel>)->(), failure: @escaping ()->()) {}
    
 
    internal func activelist(success: @escaping (_ list : Array<bannerItemModel>)->(), failure: @escaping ()->()) {
        KWNetwork.activelist(resendConfig: nil, success: { (res) in
            success(KWParseTask.activelist(list: res.data))
        }) { (err) in
            failure()
        }
    }
    
    
    internal func allBanners(success: @escaping (_ list : Array<allBannarModel>)->(), failure: @escaping ()->()) {
        KWNetwork.allBanners(resendConfig: nil, success: { (res) in
            success(KWParseTask.allBanners(list: res.data))
        }) { (err) in
            failure()
        }
    }
    
    internal func search(parameters: [String : Any],success: @escaping (_ list : Array<contentDtoModel>)->(), failure: @escaping ()->()) {
        KWNetwork.search(parameters: parameters, resendConfig: KWNetworkResendConfig(interval: 1, resendCount: 2), success: { (respond) in
            success(KWParseTask.search(list: respond.data))
        }) { (err) in
            failure()
        }
    }
    
    internal func searchByUser(parameters: [String : Any],success: @escaping (_ list : Array<contentDtoModel>)->(), failure: @escaping ()->()) {
        KWNetwork.searchByUser(parameters: parameters, resendConfig: KWNetworkResendConfig(interval: 1, resendCount: 2), success: { (respond) in
            success(KWParseTask.search(list: respond.data))
        }) { (err) in
            failure()
        }
    }
    
    
    
    
    
    
}

