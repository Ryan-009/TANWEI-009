//
//  SSLoginViewController.swift
//  KIWI
//
//  Created by 吴凯耀 on 2019/11/9.
//  Copyright © 2019 li zhou. All rights reserved.
//

import UIKit
import SVProgressHUD

class SSLoginViewController: UIViewController {

    fileprivate lazy var  titleLabel : UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 27.5)
        label.textColor = ColorFromHexString("#333333")
        label.text = "欢迎来到新零售·摊位"
        return label
    }()
    
    fileprivate lazy var mobileTextFeild : UITextField = {
        let tf = UITextField.init()
        tf.placeholder = "输入手机号"
        tf.font = UIFont.systemFont(ofSize: 18)
        tf.textAlignment = .left
        return tf
    }()
    
    fileprivate lazy var smsTextFeild : UITextField = {
        let tf = UITextField.init()
        tf.placeholder = "输入验证码"
        tf.font = UIFont.systemFont(ofSize: 18)
        tf.textAlignment = .left
        tf.isSecureTextEntry = true
        return tf
    }()
    
    fileprivate lazy var psTextFeild : UITextField = {
        let tf = UITextField.init()
        tf.placeholder = "输入密码"
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
        
        v.addSubview(self.eyeButton)
        self.eyeButton.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview()
            make.width.equalTo(AutoW(60))
            make.height.equalToSuperview()
            make.top.equalToSuperview()
        }
        
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
    
    fileprivate lazy var switchLoginWayButton : UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitleColor(ColorFromHexString("#999999"), for: .normal)
        btn.setTitle("密码登录", for: .normal)
        btn.sizeToFit()
        btn.tag = 1
        btn.addTarget(self, action: #selector(swithLoginWay(btn:)), for: .touchUpInside)
        return btn
    }()
    
    fileprivate lazy var forgotpsButton : UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitleColor(ColorFromHexString("#999999"), for: .normal)
        btn.setTitle("忘记密码?", for: .normal)
        btn.sizeToFit()
        btn.tag = 1
        btn.addTarget(self, action: #selector(forgotpasswordFunction), for: .touchUpInside)
        return btn
    }()
    
    fileprivate lazy var loginButton : UIButton = {
        let btn = UIButton(type: .system)
        btn.frame = CGRect.init(x: AutoW(39), y: AutoW(485), width: SCREEN_WIDTH-AutoW(78), height: AutoW(55))
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor = APPSubjectColor//ColorFromHexString("#7FC2FF")
        btn.setTitle("登录", for: .normal)
        btn.layer.cornerRadius = AutoW(27.5)
        btn.clipsToBounds = true
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.addTarget(self, action: #selector(lgoinFunction), for: .touchUpInside)
        return btn
    }()
    
    private lazy var spLabel:UILabel = {
        let registeLabel = UILabel.init()
        registeLabel.textColor = ColorFromHexString("#666666")
        registeLabel.font = UIFont.boldSystemFont(ofSize: 11)
        return registeLabel
    }()
    private lazy var spLabel2:UILabel = {
        let registeLabel = UILabel.init()
        registeLabel.textColor = ColorFromHexString("#666666")
        registeLabel.font = UIFont.boldSystemFont(ofSize: 11)
        return registeLabel
    }()
    
    private lazy var spBtn:UIButton = {
        let registeBtn = UIButton.init()
        registeBtn.isSelected = true
        registeBtn.setImage(UIImage.init(named: "协议选框"), for: .normal)
        registeBtn.setImage(UIImage.init(named: "协议选中勾"), for: .selected)
        registeBtn.addTarget(self, action: #selector(spBtnClick), for: .touchUpInside)
        return registeBtn
    }()
    
    fileprivate lazy var registerButton : UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitleColor(ColorFromHexString("#0086FF"), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.setTitle("注册", for: .normal)
        btn.frame.size = CGSize(width: AutoW(40), height: AutoW(30))
        btn.frame.origin.y = AutoW(523)
        btn.center.x = SCREEN_WIDTH*0.5
        
        btn.addTarget(self, action: #selector(registerFunction), for: .touchUpInside)
        return btn
    }()
    
    fileprivate lazy var eyeButton : UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named:"不可见.png"), for: .normal)
        btn.tag = 1
        btn.addTarget(self, action: #selector(switheye(btn:)), for: .touchUpInside)
        return btn
    }()
    
    enum loginType:Int {
        case sms = 0
        case ps  = 1
    }
    
    var selectType : loginType = .sms
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiInit()
        self.navigationItem.leftBarButtonItem = SetBackBarButtonItem(target: self, action: #selector(backFunc), imageName: "back")
    }
    
    @objc func backFunc() {
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    @objc func spBtnClick(button:UIButton){
        button.isSelected = !button.isSelected
    }
}

extension SSLoginViewController{
    func uiInit(){
        self.title = "登录"
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
        
        addsmsInputView()
        
        self.view.addSubview(self.switchLoginWayButton)
        switchLoginWayButton.snp.makeConstraints { (make) in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(AutoW(387))
        }
        
        self.view.addSubview(loginButton)
        loginButton.snp.makeConstraints { (make) in
            make.top.equalTo(switchLoginWayButton.snp.bottom).offset(AutoW(60))
            make.leading.equalTo(AutoW(39))
            make.centerX.equalToSuperview()
            make.height.equalTo(AutoW(55))
        }
        
        self.view.addSubview(registerButton)
        registerButton.snp.makeConstraints { (make) in
            make.top.equalTo(loginButton.snp.bottom)
            make.centerX.equalToSuperview()
            make.height.equalTo(loginButton.snp.height)
        }
        
        self.view.addSubview(spBtn)
        spBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(loginButton.snp.leading)
            make.bottom.equalTo(loginButton.snp.top).offset(-AutoW(8))
            make.width.height.equalTo(30)
        }
        
        spLabel.attributedText = getNSAttributedString(str: "我已阅读《摊位隐私政策》")
        spLabel.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(privateAction))
        spLabel.addGestureRecognizer(tap)
        spLabel.sizeToFit()
        self.view.addSubview(spLabel)
        spLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(spBtn)
            make.leading.equalTo(spBtn.snp.trailing)
            make.height.equalTo(30)
        }
        
        spLabel2.attributedText = getNSAttributedString2(str: "《摊位服务协议》")
        spLabel2.isUserInteractionEnabled = true
        let tap2 = UITapGestureRecognizer.init(target: self, action: #selector(serviceAction))
        spLabel2.addGestureRecognizer(tap2)
        spLabel2.sizeToFit()
        self.view.addSubview(spLabel2)
        spLabel2.snp.makeConstraints { (make) in
            make.centerY.equalTo(spBtn)
            make.leading.equalTo(spLabel.snp.trailing)
            make.height.equalTo(30)
        }
    }
    
    @objc func privateAction(){
        let vc = KWWebViewController()
        let nav = KWBaseNavigationController(rootViewController: vc)
        vc.localType = .ssPrivate
        self.present(nav, animated: true, completion: nil)
    }
    @objc func serviceAction(){
       let vc = KWWebViewController()
       let nav = KWBaseNavigationController(rootViewController: vc)
       vc.localType = .ssService
       self.present(nav, animated: true, completion: nil)
    }
    
    //指定字符 指定颜色并加上下划线
    func getNSAttributedString(str:String) -> NSAttributedString {
        let myMutableString = NSMutableAttributedString(string: str)
        let range1 = NSMakeRange(4, 10)
        let range2 = NSMakeRange(5, 8)
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: ColorFromHexString("#4565A7"), range: range1)
        myMutableString.addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: range2)
        return myMutableString
    }
    func getNSAttributedString2(str:String) -> NSAttributedString {
        let myMutableString = NSMutableAttributedString(string: str)
        let range1 = NSMakeRange(0, 10)
        let range2 = NSMakeRange(1, 8)
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: ColorFromHexString("#4565A7"), range: range1)
        myMutableString.addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: range2)
        return myMutableString
    }
}

//MARK:- 按钮点击事件
extension SSLoginViewController{
    @objc func swithLoginWay(btn:UIButton) {
        if self.switchLoginWayButton.tag == 1 {
            self.selectType = .ps
            self.switchLoginWayButton.tag = 2
            self.switchLoginWayButton.setTitle("验证码登录", for: .normal)
            self.removeSmsInputView()
            self.addpsInputView()
            self.addforgotbuttonFunction()
        }else if self.switchLoginWayButton.tag == 2 {
            self.selectType = .sms
            self.switchLoginWayButton.tag = 1
            self.switchLoginWayButton.setTitle("密码登录", for: .normal)
            self.removePsInputView()
            self.addsmsInputView()
            self.removeForgotButtonFunction()
        }
    }
    
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
    
    @objc func forgotpasswordFunction() {
        let vc = ReSetViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func lgoinFunction() {
        
        if !UnNil(self.mobileTextFeild.text) {
            KWHUD.showInfo(info: "请输入手机号")
            return
        }
        if !UnNil(self.psTextFeild.text) {
            KWHUD.showInfo(info: "请输入密码")
            return
        }
        if !spBtn.isSelected {
            KWHUD.showInfo(info: "请阅读平台协议")
            return
        }
        
        if self.selectType == .sms {
            KWSystem.loginByCaptcha(account: self.mobileTextFeild.text!, captcha: self.smsTextFeild.text!) { (res) in
                if res == .success {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }else if self.selectType == .ps {
            KWSystem.login(account: self.mobileTextFeild.text!, password: psTextFeild.text!) { (err) in
                if err == .success {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    @objc func registerFunction() {
        let vc = SSRegisterViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func getSmsFunction() {
        SVProgressHUD.show()
        KWNetwork.getIdeCode(phone: self.mobileTextFeild.text!, type: 2, resendConfig: nil, success: { (res) in
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


//MARK:-界面切换时的布局
extension SSLoginViewController{
    fileprivate func addsmsInputView() {
        self.view.addSubview(self.smsInputView)
        smsInputView.snp.makeConstraints { (make) in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(AutoW(309))
            make.height.equalTo(AutoW(55))
            make.trailing.equalTo(AutoW(-39))
        }
    }
    fileprivate func removeSmsInputView() {
        self.smsInputView.removeFromSuperview()
    }
    fileprivate func addpsInputView() {
        self.view.addSubview(self.psInputView)
        self.psInputView.snp.makeConstraints { (make) in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(AutoW(309))
            make.height.equalTo(AutoW(55))
            make.trailing.equalTo(AutoW(-39))
        }
    }
    fileprivate func removePsInputView() {
        self.psInputView.removeFromSuperview()
    }
    fileprivate func addforgotbuttonFunction(){
        self.view.addSubview(self.forgotpsButton)
        self.forgotpsButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(AutoW(-36))
            make.top.equalTo(AutoW(387))
        }
    }
    fileprivate func removeForgotButtonFunction() {
        self.forgotpsButton.removeFromSuperview()
    }
}
