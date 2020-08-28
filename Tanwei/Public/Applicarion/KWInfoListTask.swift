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
    
    internal func getAgentInfo(success: @escaping (_ data:agentInfo)->(), failure: @escaping ()->()) {
        KWNetwork.getAgentInfo(resendConfig: KWNetworkResendConfig(interval: 1, resendCount: 2), success: { (respond) in
            success(KWParseTask.getAgentInfo(list: respond.data))
        }) { (err) in
            failure()
        }
    }
    
    internal func allContentFactory(parameters:[String:Any],success: @escaping (_ list : Array<contentModel>)->(), failure: @escaping ()->()) {
        KWNetwork.allContentFactory(parameters: parameters, resendConfig: nil, success: { (respond) in
            success(KWParseTask.allContentFactory(list: respond.data))
        }) { (err) in
            failure()
        }
    }
    
    internal func allContentShop(parameters:[String:Any],success: @escaping (_ list : Array<contentModel>)->(), failure: @escaping ()->()) {
        KWNetwork.allContentShop(parameters: parameters, resendConfig: nil, success: { (respond) in
            success(KWParseTask.allContentShop(list: respond.data))
        }) { (err) in
            failure()
        }
    }
    
    internal func getCustomer(success: @escaping ()->(), failure: @escaping ()->()) {
        KWNetwork.getCustomer(resendConfig: KWNetworkResendConfig(interval: 1, resendCount: 2), success: { (respond) in
            success()
        }) { (err) in
            failure()
        }
    }
    
    internal func getFactory(success: @escaping ()->(), failure: @escaping ()->()) {
        KWNetwork.getFactory(resendConfig: KWNetworkResendConfig(interval: 1, resendCount: 2), success: { (respond) in
            success()
        }) { (err) in
            failure()
        }
    }
    
    internal func getShop(success: @escaping ()->(), failure: @escaping ()->()) {
        KWNetwork.getShop(resendConfig: KWNetworkResendConfig(interval: 1, resendCount: 2), success: { (respond) in
            success()
        }) { (err) in
            failure()
        }
    }
    
    internal func getContent(success: @escaping ()->(), failure: @escaping ()->()) {
        KWNetwork.getContent(resendConfig: KWNetworkResendConfig(interval: 1, resendCount: 2), success: { (respond) in
            success()
        }) { (err) in
            failure()
        }
    }
    
    internal func focusGetFactory(start:Int,limit:Int,success: @escaping (_ list : [FocusContent])->(), failure: @escaping ()->()) {
        KWNetwork.focusGetFactory(start: start, limit: limit, resendConfig: KWNetworkResendConfig(interval: 1, resendCount: 2), success: { (respond) in
            success(KWParseTask.getFocusFactory(list: respond.data))
        }) { (err) in
            failure()
        }
    }
    
    internal func focusGetShop(start:Int,limit:Int,success: @escaping (_ list : [FocusContent])->(), failure: @escaping ()->()) {
        KWNetwork.focusGetShop(start: start, limit: limit, resendConfig: KWNetworkResendConfig(interval: 1, resendCount: 2), success: { (respond) in
            success(KWParseTask.getFocusFactory(list: respond.data))
        }) { (err) in
            failure()
        }
    }
    
}

