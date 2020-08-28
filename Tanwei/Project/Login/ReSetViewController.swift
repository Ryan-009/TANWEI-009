//
//  ReSetViewController.swift
//  salestar
//
//  Created by li zhou on 2019/11/23.
//  Copyright © 2019 li zhou. All rights reserved.
//

import UIKit
import SVProgressHUD

class ReSetViewController: UIViewController {

    fileprivate lazy var  titleLabel : UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 27.5)
        label.textColor = ColorFromHexString("#333333")
        label.text = "设置新密码"
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
        tf.placeholder = "输入新密码"
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
        btn.frame = CGRect.init(x: AutoW(39), y: AutoW(505), width: SCREEN_WIDTH-AutoW(78), height: AutoW(55))
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor = ColorFromHexString("#7FC2FF")
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
        SVProgressHUD.show()
        KWNetwork.getIdeCode(phone: self.mobileTextFeild.text!, type: 3, resendConfig: nil, success: { (res) in
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

extension ReSetViewController{
    func uiInit(){
        self.title = "注册"
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
        
        self.view.addSubview(finishButton)
        finishButton.snp.makeConstraints { (make) in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(psInputView.snp.bottom).offset(AutoW(60))
            make.height.equalTo(AutoW(55))
            make.trailing.equalTo(AutoW(-39))
        }
        
        self.view.addSubview(spBtn)
        spBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(finishButton)
            make.top.equalTo(psInputView.snp.bottom).offset(AutoW(25))
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
    @objc func spBtnClick(button:UIButton){
           button.isSelected = !button.isSelected
    }
}
extension ReSetViewController {
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
        
    }
}
