//
//  DiscoverTitleButton.swift
//  WANGHONG
//
//  Created by 吴凯耀 on 2016/10/10.
//  Copyright © 2016年 凯胜. All rights reserved.
//

import UIKit

class DiscoverTitleButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        //设置标题样式
        titleLabel?.font = UIFont(name: "", size: 16)
        setTitleColor(ColorFromHexString("#969696"), for: .normal)
        setTitleColor(UIColor.black, for: .selected)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
