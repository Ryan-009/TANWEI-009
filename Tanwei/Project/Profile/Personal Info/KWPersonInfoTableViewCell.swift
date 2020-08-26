//
//  KWPersonInfoTableViewCell.swift
//  salestar
//
//  Created by li zhou on 2019/12/10.
//  Copyright © 2019 li zhou. All rights reserved.
//

import UIKit

class KWPersonInfoTableViewCell: UITableViewCell {

    lazy var infoLabel : UILabel = {
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 15)
        lab.textColor = UIColor.black
        lab.text  = "基本信息"
        return lab
    }()
    
    lazy var cityLabel : UILabel = {
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 16)
        lab.textColor = ColorFromHexString("#666666")
        lab.text  = "所在地"
        return lab
    }()
    
    lazy var professionLabel : UILabel = {
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 16)
        lab.textColor = ColorFromHexString("#666666")
        lab.text  = "行业标签"
        return lab
    }()
    
    lazy var cityContent : UILabel = {
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 16)
        lab.textColor = UIColor.black
        lab.text  = ""
        return lab
    }()
    
    lazy var professionContent : UILabel = {
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 16)
        lab.textColor = UIColor.black
        lab.text  = ""
        return lab
    }()
    
    lazy var contactButton : UIButton = {
        let btn = UIButton(type: .system)
//        btn.setTitle("联系Ta", for: .normal)
//        btn.setTitleColor(UIColor.white, for: .normal)
//        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
//        btn.backgroundColor = APPSubjectColor
//        btn.layer.cornerRadius = AutoW(6)
//        btn.clipsToBounds = true
        return btn
    }()
    
    var data : contentDtoModel = contentDtoModel() {
        didSet{
            if data.userId == KWUser.userInfo.userId {
                KWListener.register.updateUser(target: self, selector: #selector(myData))
            }
            self.cityContent.text       = data.region
            self.professionContent.text = data.profession
        }
    }
    
    var isMySelf : Bool = false {
        didSet{
            if isMySelf {
                KWListener.register.updateUser(target: self, selector: #selector(myData))
                self.cityContent.text       = KWUser.userInfo.location
                self.professionContent.text = KWUser.userInfo.label
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selfInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func selfInit(){
        self.selectionStyle = .none
        let line0 = UIView()
        line0.backgroundColor = UIColor.lightGray
        self.addSubview(line0)
        line0.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.top.equalTo(AutoW(53.5))
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(0.6)
        }
        
        self.contentView.addSubview(infoLabel)
        infoLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.equalTo(AutoW(20.5))
            make.bottom.equalTo(line0.snp.top)
        }
        
        let line1 = UIView()
        line1.backgroundColor = UIColor.lightGray
        self.addSubview(line1)
        line1.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.top.equalTo(line0.snp.bottom).offset(AutoW(53.5))
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(0.6)
        }
        
        self.contentView.addSubview(cityLabel)
        cityLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(infoLabel.snp.leading)
            make.top.equalTo(line0.snp.bottom)
            make.bottom.equalTo(line1.snp.top)
        }
        
        let line2 = UIView()
        line2.backgroundColor = UIColor.lightGray
        self.addSubview(line2)
        line2.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.top.equalTo(line1.snp.bottom).offset(AutoW(53.5))
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(0.6)
        }
        
        self.contentView.addSubview(professionLabel)
        professionLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(infoLabel.snp.leading)
            make.top.equalTo(line1.snp.bottom)
            make.bottom.equalTo(line2.snp.top)
        }
        
        self.contentView.addSubview(cityContent)
        cityContent.snp.makeConstraints { (make) in
            make.leading.equalTo(cityLabel.snp.trailing).offset(AutoW(52.5))
            make.centerY.equalTo(cityLabel)
        }
        
        self.contentView.addSubview(professionContent)
        professionContent.snp.makeConstraints { (make) in
            make.leading.equalTo(cityContent)
            make.centerY.equalTo(professionLabel)
        }
        
        self.contentView.addSubview(contactButton)
        contactButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.leading.equalTo(AutoW(20.5))
            make.height.equalTo(AutoW(56))
            make.top.equalTo(line2).offset(AutoW(46))
        }
    }
    
    @objc func loadData(_ data:contentDtoModel) {
        self.data = data
    }
    
    @objc private func myData() {
        self.cityContent.text       = KWUser.userInfo.location
        self.professionContent.text = KWUser.userInfo.label
    }
    
    deinit {
        KWListener.remover.updateUser(target: self)
    }
}
