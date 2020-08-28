//
//  TWSelectIdentityTableViewCell.swift
//  Tanwei
//
//  Created by 吴凯耀 on 2020/7/20.
//  Copyright © 2020 吴凯耀. All rights reserved.
//

import UIKit

class TWSelectIdentityTableViewCell: UITableViewCell {

    @IBOutlet weak var pifaButton: UIButton!
    @IBOutlet weak var maijiaButton: UIButton!
    
    
    var data:EditUserModel = EditUserModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        
        pifaButton.setTitle("批发商", for: .normal)
        pifaButton.setTitleColor(.black, for: .normal)
        pifaButton.setTitleColor(APPSubjectColor, for: .selected)
        pifaButton.layer.cornerRadius = AutoW(4)
        pifaButton.layer.borderColor = UIColor.lightGray.cgColor
        pifaButton.layer.borderWidth = AutoW(0.6)
        pifaButton.clipsToBounds = true
        pifaButton.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        
        maijiaButton.setTitle("卖家", for: .normal)
        maijiaButton.setTitleColor(.black, for: .normal)
        maijiaButton.setTitleColor(APPSubjectColor, for: .selected)
        maijiaButton.layer.cornerRadius = AutoW(4)
        maijiaButton.layer.borderColor = UIColor.lightGray.cgColor
        maijiaButton.layer.borderWidth = AutoW(0.6)
        maijiaButton.clipsToBounds = true
        maijiaButton.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateData(data:EditUserModel) {
        self.data = data
        if KWUser.userInfo.userType == 0 {
            self.pifaButton.isUserInteractionEnabled = true
            self.maijiaButton.isUserInteractionEnabled = true
        }else {
            
            self.pifaButton.isUserInteractionEnabled = false
            self.maijiaButton.isUserInteractionEnabled = false
            
            if KWUser.userInfo.userType == 1 {
                buttonClick(button: self.maijiaButton)
            }else if KWUser.userInfo.userType == 2 {
                buttonClick(button: self.pifaButton)
            }
        }
    }
    
    @objc private func buttonClick(button:UIButton) {
        button.isSelected = !button.isSelected
        
        if button.isSelected  {
            button.layer.borderColor = APPSubjectColor.cgColor
            button.layer.borderWidth = AutoW(0.6)
            button.backgroundColor = UIColor.init(red: 224/255, green: 241/255, blue: 251/255, alpha: 1)
            if button == self.pifaButton {
                maijiaButton.layer.borderColor = UIColor.lightGray.cgColor
                maijiaButton.layer.borderWidth = AutoW(0.6)
                maijiaButton.backgroundColor = UIColor.white
                maijiaButton.isSelected = false
                self.data.userType = 2
            }else{
                pifaButton.layer.borderColor = UIColor.lightGray.cgColor
                pifaButton.layer.borderWidth = AutoW(0.6)
                pifaButton.backgroundColor = UIColor.white
                pifaButton.isSelected = false
                self.data.userType = 1
            }
        }else{
            button.layer.borderColor = UIColor.lightGray.cgColor
            button.layer.borderWidth = AutoW(0.6)
            button.backgroundColor = UIColor.white
            self.data.userType = 0
        }
        button.clipsToBounds = true
    }
}
