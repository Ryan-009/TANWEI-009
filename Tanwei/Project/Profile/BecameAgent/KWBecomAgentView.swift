//
//  KWBecomAgentView.swift
//  Tanwei
//
//  Created by 吴凯耀 on 2020/7/28.
//  Copyright © 2020 吴凯耀. All rights reserved.
//

import UIKit

class KWBecomAgentView: UIView {

    fileprivate lazy var accountTextFeild : UITextField = {
        let tf = UITextField.init()
        tf.placeholder = "请输入支付宝账号"
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.keyboardType = .numbersAndPunctuation
        tf.textAlignment = .left
        return tf
    }()
    
    fileprivate lazy var recommandTextFeild : UITextField = {
        let tf = UITextField.init()
        tf.font = UIFont.systemFont(ofSize: 18)
        tf.textAlignment = .center
        tf.isUserInteractionEnabled = false
        tf.text = "897570"
        tf.backgroundColor = APPGrayBackGroundColor
        return tf
    }()
    
    let confirmButton = UIButton.init(type: .system)
    
    var data : agentInfo = agentInfo() {
        didSet{
            if data.recommendCode != "" {
                self.accountTextFeild.text = data.acount
                self.recommandTextFeild.text = data.recommendCode
                self.confirmButton.setTitle("已开通", for: .normal)
                self.confirmButton.backgroundColor = UIColor.init(red: 72/255, green: 156/255, blue: 239/255, alpha: 1)
                self.confirmButton.isEnabled = false
            }else{
                self.recommandTextFeild.text = "******"
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        selfInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func selfInit() {
        
        self.backgroundColor = .white
        self.layer.cornerRadius = AutoW(10)
        self.clipsToBounds = true
        
        let string = "代理规则:\n*用户首次注册时,若绑定了您的邀请码,并且成功开通卖家权限/批发商权限(7天内未申请无理由退款).则您可获得30元/个的现金奖励."
        
        let topLabel = UILabel()
        topLabel.numberOfLines = 0
        topLabel.textColor = .darkGray
        topLabel.font = UIFont.systemFont(ofSize: 14)
        topLabel.attributedText = GetAttributeString(orString: string, attString: "30元", attrs: [NSAttributedString.Key.foregroundColor : UIColor.orange])
        
        self.addSubview(topLabel)
        topLabel.snp.makeConstraints { (make) in
            make.top.equalTo(AutoW(25))
            make.leading.equalTo(AutoW(20))
            make.trailing.equalTo(AutoW(-25))
        }
        
        let label = UILabel()
        label.text = "收款支付宝账号:"
        self.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.leading.equalTo(topLabel)
            make.top.equalTo(topLabel.snp.bottom).offset(AutoW(50))
        }
        
        self.addSubview(accountTextFeild)
        accountTextFeild.snp.makeConstraints { (make) in
            make.leading.equalTo(topLabel)
            make.top.equalTo(label.snp.bottom).offset(AutoW(10))
            make.trailing.equalTo(AutoW(-50))
            make.height.equalTo(AutoW(35))
        }
        
        let icon = UIImageView.init(image: UIImage(named: "tanwei_alipay_icon"))
        self.addSubview(icon)
        icon.snp.makeConstraints { (make) in
            make.width.height.equalTo(25)
            make.centerY.equalTo(accountTextFeild)
            make.leading.equalTo(accountTextFeild.snp.trailing)
        }
        
        let line = UIView()
        line.backgroundColor = .lightGray
        self.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.leading.equalTo(accountTextFeild)
            make.trailing.equalTo(accountTextFeild)
            make.top.equalTo(accountTextFeild.snp.bottom)
            make.height.equalTo(0.6)
        }
        
        let label2 = UILabel()
        label2.text = "您的商品推荐码:"
        self.addSubview(label2)
        label2.snp.makeConstraints { (make) in
            make.leading.equalTo(topLabel)
            make.top.equalTo(line.snp.bottom).offset(AutoW(50))
        }
        
        self.addSubview(recommandTextFeild)
        recommandTextFeild.snp.makeConstraints { (make) in
            make.leading.equalTo(topLabel)
            make.top.equalTo(label2.snp.bottom).offset(AutoW(10))
            make.trailing.equalTo(AutoW(-25))
            make.height.equalTo(AutoW(40))
        }
        
        
        confirmButton.setTitle("确认开通", for: .normal)
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.backgroundColor = APPSubjectColor
        confirmButton.layer.cornerRadius = AutoW(8)
        confirmButton.clipsToBounds = true
        confirmButton.addTarget(self, action: #selector(confirmFunc), for: .touchUpInside)
        self.addSubview(confirmButton)
        confirmButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(AutoW(-20))
            make.centerX.equalToSuperview()
            make.leading.equalTo(topLabel)
            make.height.equalTo(AutoW(40))
        }
    }
    
    @objc private func confirmFunc() {
        
        if self.accountTextFeild.text?.isEmpty ?? true{
            HUD.showInfo(withStatus: "请输入支付宝账号")
            return
        }
        HUD.show()
        Application.opration.becomeAgent(account: self.accountTextFeild.text!, success: {data in
            KWHUD.showInfo(info: "您已成功开通成为代理")
            self.recommandTextFeild.text = data.recommendCode
            self.confirmButton.setTitle("已开通", for: .normal)
            self.confirmButton.backgroundColor = UIColor.init(red: 72/255, green: 156/255, blue: 239/255, alpha: 1)
            self.confirmButton.isEnabled = false
        }) {
            KWHUD.showInfo(info: "发生错误")
        }
    }
    
    
}
