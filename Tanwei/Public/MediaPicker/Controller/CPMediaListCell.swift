//
//  CPMediaListCell.swift
//  RedsMeMe
//
//  Created by reds on 2017/6/2.
//  Copyright © 2017年 Reds. All rights reserved.
//

import UIKit

class CPMediaListCell: UITableViewCell {

    @IBOutlet weak var coverImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        coverImageView.layer.borderWidth = 1
        coverImageView.layer.borderColor = UIColor(red: 250 / 255, green: 250 / 255, blue: 250 / 255, alpha: 1).cgColor
    }
    
    
    internal func loadData(album : CPCustomMediaAlbum) {
        nameLabel.text = album.name
        countLabel.text = "(\(album.assets.count))"
        
        if album.assets.count > 0 {
            RMMediaPicker.customScaleImage(asset: album.assets.first!, size: coverImageView.bounds.size) { (image) in
                self.coverImageView.image = image
            }
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
