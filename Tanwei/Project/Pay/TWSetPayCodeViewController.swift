//
//  TWSetPayCodeViewController.swift
//  Tanwei
//
//  Created by 吴凯耀 on 2020/8/15.
//  Copyright © 2020 吴凯耀. All rights reserved.
//

import UIKit

class TWSetPayCodeViewController: KWBaseViewController ,UITextFieldDelegate{
    
    @IBOutlet weak var oddNumberTextFeild: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "填写交易单号"
        oddNumberTextFeild.delegate = self
        submitButton.backgroundColor = APPSubjectColor
        submitButton.addTarget(self, action: #selector(submitFunc), for: .touchUpInside)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        UIView.animate(withDuration: 0.25) {
            self.view.frame.origin.y = -250
        }
        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        UIView.animate(withDuration: 0.25) {
            self.view.frame.origin.y = 0
        }
        return true
    }
    
    @objc private func submitFunc() {
        if self.oddNumberTextFeild.text!.isEmpty {
            KWHUD.showInfo(info: "请输入订单号")
            return
        }
        HUD.show()
        Application.opration.orderSave(orderCode: self.oddNumberTextFeild.text!, success: {
            HUD.dismiss()
            KWUser.userInfo.update()
            let vc = TWSubmitOddNumberSuccessViewController.init(nibName: "TWSubmitOddNumberSuccessViewController", bundle: nil)
            self.navigationController?.pushViewController(vc, animated: true)
        }) {}
    }
}
