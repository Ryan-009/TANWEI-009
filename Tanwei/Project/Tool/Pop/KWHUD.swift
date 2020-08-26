//
//  KWHUD.swift
//  KIWI
//
//  Created by li zhou on 2019/11/25.
//  Copyright © 2019 li zhou. All rights reserved.
//

import UIKit
import SVProgressHUD

class KWHUD: NSObject {
    public class func showInfo(info:String){
        SVProgressHUD.setOffsetFromCenter(UIOffset(horizontal: 0, vertical: AutoW(300)))
        SVProgressHUD.setBackgroundColor(UIColor.black.withAlphaComponent(0.5))
        SVProgressHUD.setMaximumDismissTimeInterval(2)
        SVProgressHUD.setForegroundColor(UIColor.white)
        DispatchQueue.main.async {
            SVProgressHUD.showInfo(withStatus: info)
        }
    }
    
    public class func showMqttValueData(info:String){
        SVProgressHUD.setOffsetFromCenter(UIOffset(horizontal: 0, vertical: AutoW(120)))
        SVProgressHUD.setBackgroundColor(UIColor.black.withAlphaComponent(0.5))
        SVProgressHUD.setMaximumDismissTimeInterval(3)
        SVProgressHUD.setForegroundColor(UIColor.white)
//        SVProgressHUD.showInfo(withStatus: info)
        SVProgressHUD.showInfo(withStatus: info)
//        SVProgressHUD.show
    }
}
