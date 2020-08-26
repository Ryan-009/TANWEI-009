//
//  KWApplication.swift
//  KIWI
//
//  Created by li zhou on 2019/11/4.
//  Copyright © 2019 li zhou. All rights reserved.
//

import Foundation

class KWUserOperation : NSObject {
    internal func register(parameter: Dictionary<String,Any>,success: @escaping () -> (),failure:@escaping ()->()) {
        KWNetwork.register(parameter: parameter, success: { (respond) in
            success()
        }) { (error) in failure() }
    }
    
    internal func register(mobile: String, captcha: String, password: String,success: @escaping () -> (),failure:@escaping ()->()) {
        KWNetwork.register(mobile: mobile, captcha: captcha, password: password, resendConfig: nil, success: { (respond) in
            success()
        }) { (err) in
            failure()
        }
    }
    
    internal func getIdeCode(phone: String,type: Int,success: @escaping () -> (),failure:@escaping ()->()) {
        KWNetwork.getIdeCode(phone: phone, type: type, resendConfig: nil, success: { (respond) in
            success()
        }) { (error) in
            failure()
        }
    }
    
    internal func vcode(mobileOrEmail: String, countryCode: String,success: @escaping () -> (),failure:@escaping ()->()) {
        KWNetwork.vcode(mobileOrEmail: mobileOrEmail, countryCode: countryCode, success: { (respond) in
            success()
        }) { (err) in failure()}
    }
    
    internal func resetpassword(oldPassword: String, password: String,confirmPassword: String,success: @escaping () -> (),failure:@escaping ()->()) {
        KWNetwork.resetpassword(oldPassword: oldPassword, password: password, confirmPassword: confirmPassword, resendConfig: nil, success: { (respond) in
            success()
        }) { (err) in
            failure()
        }
    }
    
    internal func forgetresetpassword(account: String, countryCode: String,smsOrEmailVcode: String,password:String,success: @escaping () -> (),failure:@escaping ()->()) {
        KWNetwork.forgetresetpassword(account: account, countryCode: countryCode, smsOrEmailVcode: smsOrEmailVcode, password: password, resendConfig: nil, success: { (respond) in
            success()
        }) { (err) in
            failure()
        }
    }
    
    internal func camerasort(homeId : String,sortByHomes:String?,sortByRooms:String?,success: @escaping () -> (),failure:@escaping ()->()) {
        KWNetwork.camerasort(homeId: homeId, sortByHomes: sortByHomes, sortByRooms: sortByRooms, resendConfig: nil, success: { (respond) in
            success()
        }) { (err) in
            failure()
        }
    }
    
    internal func devicesort(homeId : String,sortByHomes:String?,sortByRooms:String?,success: @escaping () -> (),failure:@escaping ()->()) {
        KWNetwork.devicesort(homeId: homeId, sortByHomes: sortByHomes, sortByRooms: sortByRooms, resendConfig: nil, success: { (respond) in
            success()
        }) { (err) in
            failure()
        }
    }
    
    internal func station(parameter:Dictionary<String,Any>,success: @escaping () -> (),failure:@escaping ()->()) {
        KWNetwork.station(parameter: parameter, resendConfig: nil, success: { (re) in
            success()
        }) { (err) in
            failure()
        }
    }
    
    internal func device(parameter:Dictionary<String,Any>,success: @escaping () -> (),failure:@escaping ()->()) {
        KWNetwork.device(parameter: parameter, resendConfig: nil, success: { (re) in
            success()
        }) { (err) in
            failure()
        }
    }
    internal func deleteDevice(stationId:String,homeId:String,sn:String,success: @escaping () -> (),failure:@escaping ()->()) {
        KWNetwork.deleteDevice(stationId:stationId,homeId:homeId,sn:sn, resendConfig: nil, success: { (re) in
            success()
        }) { (err) in
            failure()
        }
    }
    
    internal func camera(parameter:Dictionary<String,Any>,success: @escaping () -> (),failure:@escaping ()->()) {
        KWNetwork.camera(parameter: parameter, resendConfig: nil, success: { (re) in
            success()
        }) { (err) in
            failure()
        }
    }
    
    internal func binding(stationId:String,success: @escaping () -> (),failure:@escaping ()->()) {
        KWNetwork.binding(stationId: stationId, resendConfig: nil, success: { (re) in
            success()
        }) { (err) in
            failure()
        }
    }
    
    internal func checksn(sn:String,success: @escaping (_ validate:KWNetworkDefine.validateType) -> (),failure:@escaping ()->()) {}
    
    internal func home(parameter:Dictionary<String,Any>,success: @escaping () -> (),failure:@escaping ()->()) {
        KWNetwork.home(parameter: parameter, resendConfig: nil, success: { (re) in
            success()
        }) { (err) in
            failure()
        }
    }
    
    internal func devicecatsort(homeId:String,sort:String,success: @escaping () -> (),failure:@escaping ()->()) {
        KWNetwork.devicecatsort(homeId:homeId,sort: sort, resendConfig: nil, success: { (respond) in
            success()
        }) { (err) in
            failure()
        }
    }
    
    internal func devicecat(parameter:Dictionary<String,Any>,success: @escaping () -> (),failure:@escaping ()->()) {
        KWNetwork.devicecat(parameter: parameter, resendConfig: nil, success: { (re) in
            success()
        }) { (err) in
            failure()
        }
    }
    
    internal func deleteDevicecat(id:String,success: @escaping () -> (),failure:@escaping ()->()) {
        KWNetwork.deleteDevicecat(id: id, resendConfig: nil, success: { (res) in
            success()
        }) { (err) in
            failure()
        }
    }
    
    internal func publish(parameters:[String : Any],success: @escaping () -> (),failure:@escaping ()->()) {
        KWNetwork.publish(parameters: parameters, resendConfig: nil, success: { (respond) in
            success()
        }) { (err) in
            failure()
        }
    }
    
    internal func opblacklist(op:Int,black_phone: String,success: @escaping () -> (),failure:@escaping ()->()) {
        KWNetwork.opblacklist(op: op, black_phone: black_phone, resendConfig: nil, success: { (respond) in
            success()
        }) { (err) in
            failure()
        }
    }
}
