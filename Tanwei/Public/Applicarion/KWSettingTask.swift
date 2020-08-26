//
//  KWApplication.swift
//  KIWI
//
//  Created by li zhou on 2019/11/4.
//  Copyright © 2019 li zhou. All rights reserved.
//

import Foundation
import StoreKit

class KWSettingTask: NSObject, SKStoreProductViewControllerDelegate {
    enum SwitchType {
        case nearby
        case c2cLive
        case sound
        case vibration
        case message
    }
    
    fileprivate var storeController : SKStoreProductViewController?
}
//MARK:跳转
extension KWSettingTask {
    
    internal func exitApp() {
        exit(0)
    }
    
    //跳转到appsotre
    internal func store(link : String) {
        guard let url  = URL(string: link) else { assert(false); return }
        UIApplication.shared.openURL(url)
    }
    
    //跳转到设置
    internal func location() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        guard UIApplication.shared.canOpenURL(url) else { return }
    }
}
