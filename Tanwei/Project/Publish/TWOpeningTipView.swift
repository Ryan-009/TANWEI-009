//
//  TWOpeningTipView.swift
//  Tanwei
//
//  Created by 吴凯耀 on 2020/7/20.
//  Copyright © 2020 吴凯耀. All rights reserved.
//

import UIKit

class TWOpeningTipView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
//        openButton.layer.cornerRadius = 20
//        openButton.clipsToBounds = true
    }
    
    class func getView() -> TWOpeningTipView{
        return Bundle.main.loadNibNamed("TWOpeningTipView", owner: nil, options: nil)?.last as? TWOpeningTipView ?? TWOpeningTipView()
    }
}
