//
//  HUD.swift
//  Tanwei
//
//  Created by 吴凯耀 on 2020/8/3.
//  Copyright © 2020 吴凯耀. All rights reserved.
//

import UIKit
import SVProgressHUD

class HUD: NSObject {
    class func show() {
        DispatchQueue.main.async {
            SVProgressHUD.show()
        }
    }
    
    class func dismiss() {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
    }
    
    class func showSuccess(withStatus:String) {
        DispatchQueue.main.async {
            SVProgressHUD.showSuccess(withStatus: withStatus)
        }
    }
    
    class func showInfo(withStatus:String) {
        DispatchQueue.main.async {
            SVProgressHUD.showInfo(withStatus: withStatus)
        }
    }
}
