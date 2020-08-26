//
//  KWAlertView.swift
//  KIWI
//
//  Created by li zhou on 2019/11/5.
//  Copyright © 2019 li zhou. All rights reserved.
//

import UIKit

class KWAlertView: NSObject {

    private override init() {}
    
    class func showWhithText(text : String) {
        
        let alertView = DLAlertView.init(withText: text, font: UIFont.systemFont(ofSize: AutoW(16)), textColor: UIColor.darkGray, clickCallBack: {}, andCloseCallBack: {})
        alertView?.show()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+6) {
            alertView?.hide()
        }
    }
}
