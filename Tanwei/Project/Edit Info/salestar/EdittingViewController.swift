//
//  EdittingViewController.swift
//  salestar
//
//  Created by li zhou on 2019/12/15.
//  Copyright © 2019 li zhou. All rights reserved.
//

import UIKit
import SVProgressHUD
class EdittingViewController: UIViewController {

    enum type : Int{
        case name = 0
        case company = 1
        case net = 2
        case wechat = 3
        case phone = 4
        case jobPosition = 5
        case jobDesc = 6
        case commanyAddr = 7
        case email = 8
    }
    public var editType : type = .name
    @IBOutlet weak var contetnTextFeild: UITextField!
    
    public var saveBolck: ((String)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = SetRightBarButtonItem(imageName: "", title: "保存", textColor: APPSubjectColor, target: self, action: #selector(saveFunc))
        if editType == .name {
            self.title = "编辑姓名"
            self.contetnTextFeild.placeholder = "请输入店铺名称"
            self.contetnTextFeild.text = KWUser.userInfo.userName
        }else if editType == .wechat {
            self.title = "编辑微信号"
            self.contetnTextFeild.placeholder = "请输入微信号,方便客户找到您"
            self.contetnTextFeild.text = "\(KWUser.userInfo.wechatId)"
        }else if editType == .phone {
            self.title = "编辑手机联系号码"
            self.contetnTextFeild.placeholder = "请输入手机号,方便客户找到您"
            self.contetnTextFeild.text = KWUser.userInfo.contactPhone
        }
    }
    
    
    @objc func saveFunc() {
        if !UnEmpty(self.contetnTextFeild.text) {
            KWHUD.showInfo(info: self.contetnTextFeild.placeholder!)
            return
        }
        var par : [String:Any] = [:]
        if editType == .name {
            par[KWNetworkDefine.KEY.userName.rawValue] = self.contetnTextFeild.text!
        }else if editType == .wechat {
            par[KWNetworkDefine.KEY.wechatId.rawValue]  = self.contetnTextFeild.text!
        }else if editType == .phone {
            par[KWNetworkDefine.KEY.contactPhone.rawValue]  = self.contetnTextFeild.text!
        }
        if UnNil(self.saveBolck) {
            self.saveBolck!(self.contetnTextFeild.text!)
            self.navigationController?.popViewController(animated: true)
        }
//        HUD.show()
//        KWUser.userInfo.upload(info: par) { (type) in
//            if type == .success {
//                if UnNil(self.saveBolck) {
//                    self.saveBolck!(self.contetnTextFeild.text!)
//                }
//                KWListener.poster.updateUser()
//                self.navigationController?.popViewController(animated: true)
//            }
//            HUD.dismiss()
//        }
    }
    
}


