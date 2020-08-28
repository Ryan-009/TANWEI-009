//
//  TWPayRightInstructionTableViewCell.swift
//  Tanwei
//
//  Created by 吴凯耀 on 2020/7/25.
//  Copyright © 2020 吴凯耀. All rights reserved.
//

import UIKit

class TWPayRightInstructionTableViewCell: UITableViewCell {

    @IBOutlet weak var FPoint: UILabel!
    @IBOutlet weak var SPoint: UILabel!
    @IBOutlet weak var TPoint: UILabel!
    
    
    @IBOutlet weak var FServer: UILabel!
    @IBOutlet weak var SServer: UILabel!
    @IBOutlet weak var TServer: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        
        FPoint.layer.cornerRadius = 10
        FPoint.clipsToBounds = true
        SPoint.layer.cornerRadius = 10
        SPoint.clipsToBounds = true
        TPoint.layer.cornerRadius = 10
        TPoint.clipsToBounds = true
        
        if KWUser.userInfo.userType == 1 {
            FServer.text = "1.可以一键转发成千上万的批发商的商品"
            SServer.text = "2.可以一键转发/发布100个商品信息"
            TServer.text = "3.可以让买家用小程序扫码来浏览商品"
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
