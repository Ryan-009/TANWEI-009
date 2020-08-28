//
//  TWNormalTableViewCell.swift
//  Tanwei
//
//  Created by 吴凯耀 on 2020/7/20.
//  Copyright © 2020 吴凯耀. All rights reserved.
//

import UIKit

class TWNormalTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var redPoint: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func update(indexpath:IndexPath) {
        if indexpath.row == 2 {
            self.titleLabel.text = "店铺名称"
        }else if indexpath.row == 4 {
            self.titleLabel.text = "发货地"
        }else if indexpath.row == 5 {
            self.titleLabel.text = "联系电话"
        }else if indexpath.row == 6 {
            self.titleLabel.text = "微信号"
        }
    }
    
    func updatePublishData(indexpath:IndexPath) {
        if indexpath.row == 0 {
            self.titleLabel.attributedText = GetAttributeString(orString: "* 所属行业", attString: "*", attrs: [NSAttributedString.Key.foregroundColor : UIColor.red])
        }else if indexpath.row == 1 {
            self.titleLabel.attributedText = GetAttributeString(orString: "* 发货地", attString: "*", attrs: [NSAttributedString.Key.foregroundColor : UIColor.red])
        }
    }
    
    func showRedpoint() {
        self.redPoint.isHidden = false
    }
    
    func hideRedpoint() {
        self.redPoint.isHidden = true
    }
}
