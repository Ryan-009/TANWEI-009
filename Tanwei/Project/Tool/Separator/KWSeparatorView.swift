//
//  KWSeparatorView.swift
//  KIWI
//
//  Created by li zhou on 2019/11/14.
//  Copyright © 2019 li zhou. All rights reserved.
//

import UIKit

class KWSeparatorView: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.frame = CGRect(x: AutoW(20), y: 0, width: SCREEN_WIDTH-AutoW(40), height: AutoW(0.67))
        self.image = SeparatorLine
        self.contentMode = .scaleAspectFit
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
