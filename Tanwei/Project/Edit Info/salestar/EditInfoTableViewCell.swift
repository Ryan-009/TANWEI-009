//
//  EditInfoTableViewCell.swift
//  salestar
//
//  Created by li zhou on 2019/12/15.
//  Copyright © 2019 li zhou. All rights reserved.
//

import UIKit

class EditInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var icon_width_const: NSLayoutConstraint!
    @IBOutlet weak var tipPoint: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setData(_ indexPath : IndexPath) {
        self.icon_width_const.constant = 15
        self.selectionStyle = .default
        self.tipPoint.text = ""
        if indexPath.row == 0 {
            self.titleLabel.text = "ID"
            self.contentLabel.text = "\(KWUser.userInfo.userId)"
            self.icon_width_const.constant = 0
            self.selectionStyle = .none
        }else if indexPath.row == 1 {
            self.titleLabel.text = "姓名"
            self.contentLabel.text = KWUser.userInfo.userName
            self.tipPoint.text = "*"
        }else if indexPath.row == 2 {
            self.titleLabel.text = "公司"
            self.contentLabel.text = KWUser.userInfo.company
            self.tipPoint.text = "*"
        }else if indexPath.row == 3 {
            self.titleLabel.text = "官网"
            self.contentLabel.text = KWUser.userInfo.website
        }else if indexPath.row == 4 {
            self.titleLabel.text = "所在地"
            self.contentLabel.text = KWUser.userInfo.location
            self.selectionStyle = .none
        }else if indexPath.row == 5 {
            self.titleLabel.text = "行业标签"
            self.contentLabel.text = KWUser.userInfo.label
            self.selectionStyle = .none
        }else if indexPath.row == 6 {
            self.titleLabel.text = "职位"
            self.contentLabel.text = KWUser.userInfo.jobPosition
            self.tipPoint.text = "*"
            self.selectionStyle = .none
        }else if indexPath.row == 7 {
            self.titleLabel.text = "业务介绍"
            self.contentLabel.text = KWUser.userInfo.jobDesc
            self.selectionStyle = .none
        }else if indexPath.row == 8 {
            self.titleLabel.text = "公司地址"
            self.contentLabel.text = KWUser.userInfo.commanyAddr
            self.selectionStyle = .none
        }else if indexPath.row == 9 {
            self.titleLabel.text = "邮箱"
            self.contentLabel.text = KWUser.userInfo.email
            self.selectionStyle = .none
        }else if indexPath.row == 10 {
            self.titleLabel.text = "微信号"
            self.contentLabel.text = "KWUser.userInfo.wechatId"
            self.tipPoint.text = "*"
            self.selectionStyle = .none
        }else if indexPath.row == 11 {
            self.titleLabel.text = "联系电话"
            self.contentLabel.text = KWUser.userInfo.cPhone
            self.selectionStyle = .none
        }
    }
    
    //用于设置页面的cell
    func setViewData(_ indexPath : IndexPath) {
        self.icon_width_const.constant = 15
        self.selectionStyle = .default
        if indexPath.row == 0 {
            self.titleLabel.text = "登录账号"
            self.contentLabel.text = "\(KWUser.userInfo.userId)"
            self.icon_width_const.constant = 0
            self.selectionStyle = .none
        }else if indexPath.row == 1 {
            self.titleLabel.text = "清理缓存"
            Application.cache.size(result: { (ss) in
                self.contentLabel.text = ss
            })
        }
    }
    
}
