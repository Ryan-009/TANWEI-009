//
//  TWPaybottomView.swift
//  Tanwei
//
//  Created by 吴凯耀 on 2020/7/25.
//  Copyright © 2020 吴凯耀. All rights reserved.
//

import UIKit

class TWPaybottomView: UIView {

    let h = AutoW(80)
    let w = AutoW(120)
    
    lazy var payButton : UIButton = {
        let btn = UIButton.init(frame: CGRect(x: SCREEN_WIDTH-w, y: 0, width: w, height: h))
        btn.setTitle("确认支付", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .orange
        return btn
    }()
    
    lazy var newPrice : UILabel = {
        let lab = UILabel.init()
        lab.text = "¥"
        lab.textColor = .orange
        return lab
    }()
    
    lazy var discountPrice : UILabel = {
        let lab = UILabel.init()
        lab.text = "已优惠¥"
        lab.textColor = .lightGray
        lab.font = UIFont.systemFont(ofSize: 13)
        return lab
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        selfInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func selfInit() {
        
        let line = UIView()
        line.backgroundColor = APPBackGroundColor
        self.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        self.addSubview(payButton)
        payButton.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalTo(w)
        }
        
        let label = UILabel()
        label.text = "总价:"
        label.textColor = .black
        self.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.top.equalTo(AutoW(13))
        }
        
        self.addSubview(newPrice)
        newPrice.snp.makeConstraints { (make) in
            make.leading.equalTo(label.snp.trailing).offset(AutoW(1))
            make.centerY.equalTo(label)
        }
        
        self.addSubview(discountPrice)
        discountPrice.snp.makeConstraints { (make) in
            make.centerY.equalTo(newPrice)
            make.leading.equalTo(newPrice.snp.trailing).offset(AutoW(20))
        }
        
        let tip = UILabel()
        tip.text = "开通会员代表接受"
        tip.textColor = .darkGray
        tip.font = UIFont.systemFont(ofSize: 13)
        self.addSubview(tip)
        tip.snp.makeConstraints { (make) in
            make.leading.equalTo(label)
            make.bottom.equalTo(AutoW(-12))
        }
        
        let button = UIButton.init(type: .system)
        button.setTitle("<<会员服务协议>>", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        self.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.leading.equalTo(tip.snp.trailing).offset(AutoW(1))
            make.centerY.equalTo(tip)
        }
    }
    
    func updateData(data:PriceModel) {
        newPrice.text = "¥\(data.newPrice)"
        discountPrice.text = "已优惠¥\(data.oldPrice-data.newPrice)"
    }
    
}
