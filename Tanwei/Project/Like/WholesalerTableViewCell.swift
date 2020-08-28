//
//  WholesalerTableViewCell.swift
//  Tanwei
//
//  Created by 吴凯耀 on 2020/7/17.
//  Copyright © 2020 吴凯耀. All rights reserved.
//

import UIKit

class WholesalerTableViewCell: UITableViewCell {
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var visitButton: UIButton!
    
    var visitBlock : (()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
        self.visitButton.setTitleColor(APPSubjectColor, for: .normal)
        self.visitButton.layer.borderColor = APPSubjectColor.cgColor
        self.visitButton.layer.borderWidth = AutoW(0.5)
        self.visitButton.layer.cornerRadius = 18
        self.visitButton.clipsToBounds = true
        self.visitButton.addTarget(self, action: #selector(visiFunc), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @objc func visiFunc() {
        if UnNil(visitBlock) {
            self.visitBlock!()
        }
    }
    
    func updateData(data:FocusContent) {
        self.iconView.kf.setImage(with: URL(string: smallImageUrl+data.imageHead), placeholder: PlaceHolderForUserHeader, options: nil, progressBlock: nil) { (image, error, type, url) in}
        self.nameLabel.text = data.userName
    }
    
}
