//
//  SSMineHeaderTableViewCell.swift
//  KIWI
//
//  Created by rui chen on 2019/11/16.
//  Copyright © 2019 li zhou. All rights reserved.
//

import UIKit
import SnapKit

class SSMineHeaderTableViewCell: UITableViewCell {
    lazy var iconView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = AutoW(5)
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var titleLabel : UILabel = {
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 16)
        lab.textColor  = UIColor.black
        lab.text = ""
        lab.textAlignment = .left
        return lab
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutUI()
        loadData()
        self.selectionStyle = .none
        KWListener.register.updateUser(target: self, selector: #selector(loadData))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutUI() {
        self.contentView.addSubview(iconView)
        self.iconView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(AutoW(72))
            make.leading.equalTo(AutoW(21.33))
        }
        
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalTo(iconView.snp.trailing).offset(AutoW(20))
        }
    }
    
    @objc func loadData() {
        self.iconView.kf.setImage(with: URL(string: smallImageUrl+KWUser.userInfo.imageHead), placeholder: PlaceHolderForUserHeader, options: nil, progressBlock: nil) { (image, error, type, url) in}
        self.titleLabel.text = KWUser.userInfo.userName
    }
    
}
