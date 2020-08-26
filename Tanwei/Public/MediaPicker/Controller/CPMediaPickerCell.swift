//
//  CPMediaPickerCell.swift
//  CPSwiftComponent
//
//  Created by reds on 2017/6/1.
//  Copyright © 2017年 convictionpeerless. All rights reserved.
//

import UIKit

class CPMediaPickerCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var selectedStatus: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectedStatus.tag = 0
        selectedStatus.image = UIImage(named: "unselected.png")
    }

    internal func loadData(image : UIImage) {
        imageView.image = image
    }
    
    internal func selectStatusChange() {
        if selectedStatus.tag == 0 {
            selectedStatus.tag = 1
            selectedStatus.image = UIImage(named: "selected.png")
        } else {
            selectedStatus.tag = 0
            selectedStatus.image = UIImage(named: "unselected.png")
        }
    }
    
    internal func clearSelectedStatus() {
        selectedStatus.tag = 0
        selectedStatus.image = UIImage(named: "unselected.png")
    }
    
    internal func addSelectedStatus() {
        selectedStatus.tag = 1
        selectedStatus.image = UIImage(named: "selected.png")
    }
}
