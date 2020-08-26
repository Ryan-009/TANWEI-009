//
//  ADPInfoTableViewCell.swift
//  salestar
//
//  Created by 吴凯耀 on 2020/5/17.
//  Copyright © 2020 li zhou. All rights reserved.
//

import UIKit

class ADPInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func loadDataWithIndex(_ index:Int,data:contentDtoModel) {
        if index == 0 {
            self.titleLabel.text = "公司"
            self.contentLabel.text = data.company
        }else if index == 1 {
            self.titleLabel.text = "官网"
            self.contentLabel.text = data.companyPortal
        }else if index == 2 {
            self.titleLabel.text = "所在地区"
            self.contentLabel.text = data.region
        }else if index == 3 {
            self.titleLabel.text = "行业标签"
            self.contentLabel.text = data.profession
        }else if index == 4 {
            self.titleLabel.text = "职位"
            self.contentLabel.text = data.jobPosition
        }else if index == 5 {
            self.titleLabel.text = "联系电话"
            self.contentLabel.text = data.cPhone
        }else if index == 6 {
            self.titleLabel.text = "微信号"
            self.contentLabel.text = data.wechatId
        }
    }
    
}
