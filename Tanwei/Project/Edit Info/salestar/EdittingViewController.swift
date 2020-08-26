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
            self.contetnTextFeild.placeholder = "请输入真实姓名"
            self.contetnTextFeild.text = KWUser.userInfo.userName
        }else if editType == .company  {
            self.title = "编辑公司名称"
            self.contetnTextFeild.placeholder = "请输入公司名称"
            self.contetnTextFeild.text = KWUser.userInfo.company
        }else if editType == .net {
            self.title = "编辑公司官网"
            self.contetnTextFeild.placeholder = "请输入公司官网"
            self.contetnTextFeild.text = KWUser.userInfo.website
        }else if editType == .wechat {
            self.title = "编辑微信号"
            self.contetnTextFeild.placeholder = "请输入微信号,方便客户找到您"
            self.contetnTextFeild.text = "KWUser.userInfo.wechatId"
        }else if editType == .phone {
            self.title = "编辑手机联系号码"
            self.contetnTextFeild.placeholder = "请输入手机号,方便客户找到您"
            self.contetnTextFeild.text = KWUser.userInfo.cPhone
        }else if editType == .jobPosition {
            self.title = "编辑职位"
            self.contetnTextFeild.placeholder = "请填写您的职位"
            self.contetnTextFeild.text = KWUser.userInfo.jobPosition
        }else if editType == .jobDesc {
            self.title = "编辑业务介绍"
            self.contetnTextFeild.placeholder = "请填写您的业务介绍"
            self.contetnTextFeild.text = KWUser.userInfo.jobDesc
        }else if editType == .commanyAddr {
            self.title = "编辑公司地址"
            self.contetnTextFeild.placeholder = "请填写您的公司地址"
            self.contetnTextFeild.text = KWUser.userInfo.commanyAddr
        }else if editType == .email {
            self.title = "编辑手邮箱"
            self.contetnTextFeild.placeholder = "请输入邮箱"
            self.contetnTextFeild.text = KWUser.userInfo.email
        }
    }
    
    
    @objc func saveFunc() {
//        if !UnEmpty(self.contetnTextFeild.text) {
//            KWHUD.showInfo(info: self.contetnTextFeild.placeholder!)
//            return
//        }
        var par : [String:Any] = [:]
        if editType == .name {
            par["userName"] = self.contetnTextFeild.text!
        }else if editType == .company {
            par["company"]  = self.contetnTextFeild.text!
        }else if editType == .net {
            par["website"]  = self.contetnTextFeild.text!
        }else if editType == .wechat {
            par["wechatId"]  = self.contetnTextFeild.text!
        }else if editType == .phone {
            par["cPhone"]  = self.contetnTextFeild.text!
        }else if editType == .jobPosition {
            par["jobPosition"]  = self.contetnTextFeild.text!
        }else if editType == .jobDesc {
            par["jobDesc"]  = self.contetnTextFeild.text!
        }else if editType == .commanyAddr {
            par["commanyAddr"]  = self.contetnTextFeild.text!
        }else if editType == .email {
            par["email"]  = self.contetnTextFeild.text!
        }
        SVProgressHUD.show()
        KWUser.userInfo.upload(info: par) { (type) in
            if type == .success {
                if UnNil(self.saveBolck) {
                    self.saveBolck!(self.contetnTextFeild.text!)
                }
                KWListener.poster.updateUser()
                self.navigationController?.popViewController(animated: true)
            }
            SVProgressHUD.dismiss()
        }
    }
    
}


