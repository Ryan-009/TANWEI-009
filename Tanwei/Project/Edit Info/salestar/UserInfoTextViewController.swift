//
//  UserInfoTextViewController.swift
//  salestar
//
//  Created by 吴凯耀 on 2020/5/14.
//  Copyright © 2020 li zhou. All rights reserved.
//

import UIKit
import SVProgressHUD

class UserInfoTextViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
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
    public var editType : type = .jobDesc
    public var saveBolck: ((String)->Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textView.layer.borderWidth = 0.6
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.clipsToBounds = true
        
        self.navigationItem.rightBarButtonItem = SetRightBarButtonItem(imageName: "", title: "保存", textColor: APPSubjectColor, target: self, action: #selector(saveFunc))
        if editType == .name {
            self.title = "编辑姓名"
            self.textView.text = KWUser.userInfo.userName
        }else if editType == .company  {
            self.title = "编辑公司名称"
            self.textView.text = KWUser.userInfo.company
        }else if editType == .net {
            self.title = "编辑公司官网"
            self.textView.text = KWUser.userInfo.website
        }else if editType == .wechat {
            self.title = "编辑微信号"
            self.textView.text = "KWUser.userInfo.wechatId"
        }else if editType == .phone {
            self.title = "编辑手机联系号码"
            self.textView.text = KWUser.userInfo.cPhone
        }else if editType == .jobPosition {
            self.title = "编辑职位"
            self.textView.text = KWUser.userInfo.jobPosition
        }else if editType == .jobDesc {
            self.title = "编辑业务介绍"
            self.textView.text = KWUser.userInfo.jobDesc
        }else if editType == .commanyAddr {
            self.title = "编辑公司地址"
            self.textView.text = KWUser.userInfo.commanyAddr
        }else if editType == .email {
            self.title = "编辑手邮箱"
            self.textView.text = KWUser.userInfo.email
        }
    }

    @objc func saveFunc() {
        var par : [String:Any] = [:]
        if editType == .name {
            par["userName"] = self.textView.text!
        }else if editType == .company {
            par["company"]  = self.textView.text!
        }else if editType == .net {
            par["website"]  = self.textView.text!
        }else if editType == .wechat {
            par["wechatId"]  = self.textView.text!
        }else if editType == .phone {
            par["cPhone"]  = self.textView.text!
        }else if editType == .jobPosition {
            par["jobPosition"]  = self.textView.text!
        }else if editType == .jobDesc {
            par["jobDesc"]  = self.textView.text!
        }else if editType == .commanyAddr {
            par["commanyAddr"]  = self.textView.text!
        }else if editType == .email {
            par["email"]  = self.textView.text!
        }
        SVProgressHUD.show()
        KWUser.userInfo.upload(info: par) { (type) in
            if type == .success {
                if UnNil(self.saveBolck) {
                    self.saveBolck!(self.textView.text!)
                }
                KWListener.poster.updateUser()
                self.navigationController?.popViewController(animated: true)
            }
            SVProgressHUD.dismiss()
        }
    }

}
