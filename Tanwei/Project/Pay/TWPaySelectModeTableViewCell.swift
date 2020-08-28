//
//  TWPaySelectModeTableViewCell.swift
//  Tanwei
//
//  Created by 吴凯耀 on 2020/7/25.
//  Copyright © 2020 吴凯耀. All rights reserved.
//

import UIKit

class TWPaySelectModeTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var Fbutton: UIButton!
    @IBOutlet weak var Sbutton: UIButton!
    @IBOutlet weak var Tbutton: UIButton!
    
    @IBOutlet weak var mothLabel: UILabel!
    @IBOutlet weak var mothNewPrice: UILabel!
    @IBOutlet weak var mothOldPrice: UILabel!
    
    @IBOutlet weak var halfYearLabel: UILabel!
    @IBOutlet weak var halfYearNewPrice: UILabel!
    @IBOutlet weak var halfYearOldPrice: UILabel!
    
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var yearNewPrice: UILabel!
    @IBOutlet weak var yearOldPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        
        mothLabel.textColor = .darkGray
        halfYearLabel.textColor = .darkGray
        yearLabel.textColor = .darkGray
        
        Fbutton.layer.cornerRadius = AutoW(6)
        Fbutton.layer.borderWidth = AutoW(0.3)
        Fbutton.layer.borderColor = UIColor.lightGray.cgColor
        Fbutton.clipsToBounds = true
        Fbutton.addTarget(self, action: #selector(FClick), for: .touchUpInside)
    
        Sbutton.layer.cornerRadius = AutoW(6)
        Sbutton.layer.borderWidth = AutoW(0.3)
        Sbutton.layer.borderColor = UIColor.lightGray.cgColor
        Sbutton.clipsToBounds = true
        Sbutton.addTarget(self, action: #selector(SClick), for: .touchUpInside)
        
        Tbutton.layer.cornerRadius = AutoW(6)
        Tbutton.layer.borderWidth = AutoW(0.3)
        Tbutton.layer.borderColor = UIColor.lightGray.cgColor
        Tbutton.clipsToBounds = true
        Tbutton.addTarget(self, action: #selector(TClick), for: .touchUpInside)
        
        
        mothNewPrice.textColor = UIColor.init(red: 233/255, green: 170/255, blue: 136/255, alpha: 1)
        mothNewPrice.font = UIFont.boldSystemFont(ofSize: 20)
        halfYearNewPrice.textColor = UIColor.init(red: 233/255, green: 170/255, blue: 136/255, alpha: 1)
        halfYearNewPrice.font = UIFont.boldSystemFont(ofSize: 20)
        yearNewPrice.textColor = UIColor.init(red: 233/255, green: 170/255, blue: 136/255, alpha: 1)
        yearNewPrice.font = UIFont.boldSystemFont(ofSize: 20)
        
        SClick(btn: Sbutton)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var selectedPriceIndex : ((Int)->Void)?
    
    @objc private func FClick(btn:UIButton) {
        Fbutton.backgroundColor = UIColor.init(red: 255/255, green: 245/255, blue: 236/255, alpha: 1)
        Sbutton.backgroundColor = .white
        Tbutton.backgroundColor = .white
        if UnNil(selectedPriceIndex) {
            selectedPriceIndex!(0)
        }
    }
    
    @objc private func SClick(btn:UIButton) {
        Sbutton.backgroundColor = UIColor.init(red: 255/255, green: 245/255, blue: 236/255, alpha: 1)
        Fbutton.backgroundColor = .white
        Tbutton.backgroundColor = .white
        if UnNil(selectedPriceIndex) {
            selectedPriceIndex!(1)
        }
    }
    
    @objc private func TClick(btn:UIButton) {
        Tbutton.backgroundColor = UIColor.init(red: 255/255, green: 245/255, blue: 236/255, alpha: 1)
        Sbutton.backgroundColor = .white
        Fbutton.backgroundColor = .white
        if UnNil(selectedPriceIndex) {
            selectedPriceIndex!(2)
        }
    }
    
    func updateData(datas:[PriceModel]) {
        if datas.count > 0 {
            mothNewPrice.text = "¥\(datas.first!.newPrice)"
            mothOldPrice.text = "¥\(datas.first!.oldPrice)"
            halfYearNewPrice.text = "¥\(datas[1].newPrice)"
            halfYearOldPrice.text = "¥\(datas[1].oldPrice)"
            yearNewPrice.text = "¥\(datas[2].newPrice)"
            yearOldPrice.text = "¥\(datas[2].oldPrice)"
        }
    }
}
