//
//  SSMineTableViewCell.swift
//  KIWI
//
//  Created by 吴凯耀 on 2019/11/16.
//  Copyright © 2019 li zhou. All rights reserved.
//

import UIKit

class SSMineTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutUI()
        self.selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutUI() {
        self.contentView.addSubview(self.iconView)
        self.iconView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(AutoW(25))
            make.leading.equalTo(AutoW(20))
        }
        
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalTo(iconView.snp.trailing).offset(AutoW(5))
        }
        
        self.contentView.addSubview(self.rightIconView)
        self.rightIconView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.equalTo(AutoW(14))
            make.height.equalTo(AutoW(14))
            make.trailing.equalTo(AutoW(-21.33))
        }
    }
    
    func loadData(with indexpath:IndexPath) {
        self.rightIconView.isHidden = false
        if indexpath.section == 1 {
            if indexpath.row == 0 {
                self.titleLabel.text = "开通卖家权限"
                self.iconView.image = UIImage(named: "tanwei_mine_vip_icon")
            }else if indexpath.row == 1 {
                self.titleLabel.text = "成为代理赚趣佣金"
                self.iconView.image = UIImage(named: "tanwei_mine_saler_icon")
            }else if indexpath.row == 2 {
                self.titleLabel.text = "我的摊位"
                self.iconView.image = UIImage(named: "tanwei_mine_tanwei_icon")
            }else if indexpath.row == 3 {
                self.titleLabel.text = "分享"
                self.iconView.image = UIImage(named: "tanwei_mine_share_icon")
            }
        }else if indexpath.section == 2 {
            if indexpath.row == 0 {
//                self.titleLabel.text = "意见反馈"
//                self.iconView.image = UIImage(named: "意见反馈")
                self.titleLabel.text = ""
                self.iconView.image = nil
                self.rightIconView.isHidden = true
            }else if indexpath.row == 1 {
                self.titleLabel.text = "设置"
                self.iconView.image = UIImage(named: "tanwei_mine_setting_icon")
            }else if indexpath.row == 2 {
                self.titleLabel.text = "关于我们"
                self.iconView.image = UIImage(named: "tanwei_mine_about_us_icon")
            }
        }
    }
    
    lazy var iconView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    lazy var rightIconView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "right_arrow_icon")
        return imageView
    }()
    
    lazy var titleLabel : UILabel = {
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 14)
        lab.textColor  = UIColor.black
        lab.text = ""
        lab.textAlignment = .left
        return lab
    }()
}
