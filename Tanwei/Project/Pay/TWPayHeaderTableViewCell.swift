//
//  TWPayHeaderTableViewCell.swift
//  Tanwei
//
//  Created by 吴凯耀 on 2020/7/25.
//  Copyright © 2020 吴凯耀. All rights reserved.
//

import UIKit

class TWPayHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tipLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        
        updateData()
        KWListener.register.updateUser(target: self, selector: #selector(updateData))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc private func updateData() {
        if KWUser.userInfo.vipStatus == 0 {
            tipLable.text = "您当前未开通卖家权限"
        }else{
            tipLable.text = KWUser.userInfo.overTime.subString(to: 10) + "后到期,购买后有效期将顺延"
        }
        self.iconView.kf.setImage(with: URL(string: smallImageUrl+KWUser.userInfo.imageHead), placeholder: PlaceHolderForUserHeader, options: nil, progressBlock: nil) { (image, error, type, url) in}
        self.nameLabel.text = KWUser.userInfo.userName
    }
    
}
