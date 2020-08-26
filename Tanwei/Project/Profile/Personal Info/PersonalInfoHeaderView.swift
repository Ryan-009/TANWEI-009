//
//  PersonalInfoHeaderView.swift
//  salestar
//
//  Created by li zhou on 2019/12/10.
//  Copyright © 2019 li zhou. All rights reserved.
//

import UIKit

class PersonalInfoHeaderView: UIView {

    lazy var headerIcon : UIImageView = {
        let imageView = UIImageView(image: PlaceHolderForPreLoad)
        imageView.layer.cornerRadius = AutoW(48)
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(headerClickFunc))
        imageView.addGestureRecognizer(tap)
        return imageView
    }()
    
    lazy var nameLabel : UILabel = {
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 23)
        lab.textColor = UIColor.black
        lab.text  = ""
        return lab
    }()
    
    lazy var companyLabel : UILabel = {
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 14.5)
        lab.textColor = ColorFromHexString("#666666")
        lab.text  = ""
        return lab
    }()
    
    lazy var cityInfoLabel : UILabel = {
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 13)
        lab.textColor = ColorFromHexString("#999999")
        lab.text  = ""
        return lab
    }()
    
    var adModel : contentDtoModel = contentDtoModel(){
        didSet{
            if adModel.userId == KWUser.userInfo.userId {
                loadData()
                KWListener.register.updateUser(target: self, selector: #selector(loadData))
            }else{
                
                self.headerIcon.kf.setImage(with: URL(string: smallImageUrl+adModel.image), placeholder: PlaceHolderForUserHeader, options: nil, progressBlock: nil) { (image, error, type, url) in}
                self.nameLabel.text = adModel.username
                self.companyLabel.text = adModel.company
                self.cityInfoLabel.text = adModel.region
            }
        }
    }
    
    var isMySelf : Bool = false {
        didSet{
            if isMySelf {
                loadData()
                KWListener.register.updateUser(target: self, selector: #selector(loadData))
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        
        selfInit()
    }
    var headerClick:(()->Void)?
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func selfInit() {
        self.addSubview(headerIcon)
        headerIcon.snp.makeConstraints { (make) in
            make.top.equalTo(AutoW(10))
            make.height.width.equalTo(AutoW(96))
            make.centerX.equalToSuperview()
        }
        
        self.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(headerIcon.snp.bottom).offset(AutoW(10))
            make.centerX.equalToSuperview()
        }
        
        self.addSubview(companyLabel)
        companyLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(AutoW(2))
            make.centerX.equalToSuperview()
        }
        
        self.addSubview(cityInfoLabel)
        cityInfoLabel.snp.makeConstraints { (make) in
            make.top.equalTo(companyLabel.snp.bottom).offset(AutoW(20))
            make.centerX.equalToSuperview()
        }
        
        let line = UIView()
        line.backgroundColor = APPGrayBackGroundColor
        self.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(AutoW(10))
            make.width.equalTo(SCREEN_WIDTH)
        }
    }
    
    @objc func loadData() {
        self.headerIcon.kf.setImage(with: URL(string: smallImageUrl+KWUser.userInfo.image), placeholder: PlaceHolderForUserHeader, options: nil, progressBlock: nil) { (image, error, type, url) in}
        self.nameLabel.text = KWUser.userInfo.userName
        self.companyLabel.text = KWUser.userInfo.company
        self.cityInfoLabel.text = KWUser.userInfo.location
    }
    
    @objc private func headerClickFunc() {
        if UnNil(headerClick) {
            headerClick!()
        }
    }
}
