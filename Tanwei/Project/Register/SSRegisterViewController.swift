//
//  SSRegisterViewController.swift
//  KIWI
//
//  Created by 吴凯耀 on 2019/11/9.
//  Copyright © 2019 li zhou. All rights reserved.
//

import UIKit
import SVProgressHUD

class SSRegisterViewController: UIViewController {

    fileprivate lazy var  titleLabel : UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 27.5)
        label.textColor = ColorFromHexString("#333333")
        label.text = "使用手机号注册"
        return label
    }()
    
    fileprivate lazy var mobileTextFeild : UITextField = {
        let tf = UITextField.init()
        tf.placeholder = "输入手机号"
        tf.font = UIFont.systemFont(ofSize: 18)
        tf.keyboardType = .numberPad
        tf.textAlignment = .left
        return tf
    }()
    
    fileprivate lazy var smsTextFeild : UITextField = {
        let tf = UITextField.init()
        tf.placeholder = "输入验证码"
        tf.font = UIFont.systemFont(ofSize: 18)
        tf.textAlignment = .left
        return tf
    }()
    
    fileprivate lazy var psTextFeild : UITextField = {
        let tf = UITextField.init()
        tf.placeholder = "输入密码"
        tf.font = UIFont.systemFont(ofSize: 18)
        tf.textAlignment = .left
        return tf
    }()
    
    fileprivate lazy var invitationCodeTextFeild : UITextField = {
        let tf = UITextField.init()
        tf.placeholder = "邀请码(选填)"
        tf.keyboardType = .numberPad
        tf.font = UIFont.systemFont(ofSize: 18)
        tf.textAlignment = .left
        return tf
    }()
    
    fileprivate lazy var smsInputView : UIView = {
        let v = UIView()
        v.backgroundColor = ColorFromHexString("#F6F8FF")
        v.layer.cornerRadius = AutoW(6)
        v.clipsToBounds = true
        
        v.addSubview(self.smsTextFeild)
        self.smsTextFeild.snp.makeConstraints { (make) in
            make.leading.equalTo(AutoW(25))
            make.width.equalTo(AutoW(134))
            make.height.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        let line = UIView(frame: CGRect.init(x: AutoW(184), y: AutoW(19), width: 0.5, height: AutoW(17)))
        line.backgroundColor = ColorFromHexString("#979797")
        v.addSubview(line)
        
        v.addSubview(getSmsButton)
        getSmsButton.snp.makeConstraints { (make) in
            make.leading.equalTo(line.snp.trailing)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        return v
    }()
    
    fileprivate lazy var psInputView : UIView = {
        let v = UIView()
        v.backgroundColor = ColorFromHexString("#F6F8FF")
        v.layer.cornerRadius = AutoW(6)
        v.clipsToBounds = true
        
        v.addSubview(self.psTextFeild)
        self.psTextFeild.snp.makeConstraints { (make) in
            make.leading.equalTo(AutoW(25))
            make.trailing.equalTo(AutoW(-60))
            make.top.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        v.addSubview(self.eyeButton)
        self.eyeButton.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview()
            make.width.equalTo(AutoW(60))
            make.height.equalToSuperview()
            make.top.equalToSuperview()
        }
        return v
    }()
    
    fileprivate lazy var eyeButton : UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named:"不可见.png"), for: .normal)
        btn.tag = 1
        btn.addTarget(self, action: #selector(switheye(btn:)), for: .touchUpInside)
        return btn
    }()
    
    fileprivate lazy var finishButton : UIButton = {
        let btn = UIButton(type: .system)
        btn.frame = CGRect.init(x: AutoW(39), y: AutoW(570), width: SCREEN_WIDTH-AutoW(78), height: AutoW(55))
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor = APPSubjectColor//ColorFromHexString("#7FC2FF")
        btn.setTitle("完成", for: .normal)
        btn.layer.cornerRadius = AutoW(27.5)
        btn.clipsToBounds = true
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.addTarget(self, action: #selector(finishFunction), for: .touchUpInside)
        return btn
    }()
    
    lazy var getSmsButton : UIButton = {
        let btn = UIButton.init()
        btn.setTitle("获取验证码", for: .normal)
        btn.setTitleColor(UIColor.gray, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: AutoW(15))
        btn.layer.cornerRadius = AutoW(4)
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(getSmsFunction), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        uiInit()
        self.navigationItem.leftBarButtonItem = SetBackBarButtonItem(target: self, action: #selector(backFunc), imageName: "back")
    }
    
    @objc func backFunc() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func getSmsFunction() {
        if !UnNil(self.mobileTextFeild.text) {
            KWHUD.showInfo(info: "请输入手机号")
            return
        }
        SVProgressHUD.show()
        KWNetwork.getIdeCode(phone: self.mobileTextFeild.text!, type: 1, resendConfig: nil, success: { (res) in
            SVProgressHUD.dismiss()
            self.timeRunning()
        }) { (err) in
            SVProgressHUD.dismiss()
        }
    }
    
    fileprivate func timeRunning() {
        getSmsButton.counterOpen(interval: 1, start: 60, end: 0).counterTimeStart { (sneder) in
            sneder.isEnabled = false
            }.counterTimeRun { (time, sender) in
                sender.titleLabel?.text = "重新获取(\(time))"
                sender.setTitleColor(UIColor.white, for: .normal)
                sender.setTitle("重新获取(\(time))", for: .normal)
                sender.backgroundColor = UIColor.lightGray
                sender.isEnabled = false
            }.counterTimeUp { (sender) in
                sender.setTitleColor(UIColor.white, for: .normal)
                sender.backgroundColor = UIColor.orange
                sender.setTitle("重新获取", for: .normal)
                sender.isEnabled = true
        }
    }
}

extension SSRegisterViewController{
    fileprivate func uiInit() {
        
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(AutoW(39))
            make.top.equalTo(AutoW(141))
        }
        
        let mobileInputView = UIView()
        mobileInputView.backgroundColor = ColorFromHexString("#F6F8FF")
        mobileInputView.layer.cornerRadius = AutoW(6)
        mobileInputView.clipsToBounds = true
        self.view.addSubview(mobileInputView)
        mobileInputView.snp.makeConstraints { (make) in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(AutoW(60))
            make.height.equalTo(AutoW(55))
            make.trailing.equalTo(AutoW(-39))
        }
        
        mobileInputView.addSubview(self.mobileTextFeild)
        mobileTextFeild.snp.makeConstraints { (make) in
            make.leading.equalTo(AutoW(25))
            make.trailing.equalTo(AutoW(-25))
            make.height.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        self.view.addSubview(self.smsInputView)
        smsInputView.snp.makeConstraints { (make) in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(mobileInputView.snp.bottom).offset(AutoW(14.5))
            make.height.equalTo(AutoW(55))
            make.trailing.equalTo(AutoW(-39))
        }
        
        self.view.addSubview(self.psInputView)
        self.psInputView.snp.makeConstraints { (make) in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(smsInputView.snp.bottom).offset(AutoW(14.5))
            make.height.equalTo(AutoW(55))
            make.trailing.equalTo(AutoW(-39))
        }
        
        let invitationCodeInputView = UIView()
        invitationCodeInputView.backgroundColor = ColorFromHexString("#F6F8FF")
        invitationCodeInputView.layer.cornerRadius = AutoW(6)
        invitationCodeInputView.clipsToBounds = true
        self.view.addSubview(invitationCodeInputView)
        invitationCodeInputView.snp.makeConstraints { (make) in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(psInputView.snp.bottom).offset(AutoW(20))
            make.height.equalTo(AutoW(55))
            make.trailing.equalTo(AutoW(-39))
        }
        
        invitationCodeInputView.addSubview(self.invitationCodeTextFeild)
        invitationCodeTextFeild.snp.makeConstraints { (make) in
            make.leading.equalTo(AutoW(25))
            make.trailing.equalTo(AutoW(-25))
            make.height.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        self.view.addSubview(finishButton)
    }
}

extension SSRegisterViewController {
    
    @objc func switheye(btn:UIButton) {
        if self.eyeButton.tag == 1 {
            self.eyeButton.tag = 2
            self.psTextFeild.isSecureTextEntry = false
            self.eyeButton.setImage(UIImage(named:"可见.png"), for: .normal)
        }else if self.eyeButton.tag == 2 {
            self.eyeButton.tag = 1
            self.psTextFeild.isSecureTextEntry = true
            self.eyeButton.setImage(UIImage(named:"不可见.png"), for: .normal)
        }
    }
    
    @objc func finishFunction() {
        if !UnNil(self.mobileTextFeild.text) {
            KWHUD.showInfo(info: "请输入手机号")
            return
        }
        if !UnNil(self.smsTextFeild.text) {
            KWHUD.showInfo(info: "请输入验证码")
            return
        }
        if !UnNil(self.psTextFeild.text) {
            KWHUD.showInfo(info: "请输入密码")
            return
        }
        
        Application.opration.register(mobile: self.mobileTextFeild.text!, captcha: self.smsTextFeild.text!,password: self.psTextFeild.text!, recommentCode:self.invitationCodeTextFeild.text ?? "", success: {
            KWHUD.showInfo(info: "注册成功")
            self.navigationController?.popViewController(animated: true)
        }) {}
    }
}
