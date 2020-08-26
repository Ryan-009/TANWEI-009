//
//  MoneyPickerViewController.swift
//  salestar
//
//  Created by li zhou on 2019/12/16.
//  Copyright © 2019 li zhou. All rights reserved.
//

import UIKit

class MoneyPickerViewController: UIViewController {
    
    private let picker = moneyPikerView(frame: CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: 240))
    public var didSelected : ((String,String)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.modalPresentationStyle = .custom
        self.view.addSubview(picker)
        picker.clickBlock = {type,left,right in
            
            if type == .comfirm {
                self.didSelected!(left,right)
            }
            
            UIView.animate(withDuration: 0.25, animations: {
                self.picker.frame.origin.y = SCREEN_HEIGHT
            }) { (finish) in
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.25) {
            self.picker.frame.origin.y = SCREEN_HEIGHT-240
        }
    }
    
    
}
