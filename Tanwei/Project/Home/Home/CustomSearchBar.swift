//
//  CustomSearchBar.swift
//  CustomWeiChatSearchController
//
//  Created by 范国徽 on 2018/4/8.
//  Copyright © 2018年 范国徽. All rights reserved.
//

import UIKit

class CustomSearchBar: UISearchBar {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var searchIconOffset: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white

        self.placeholder = "搜索"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        let barBackgroundView = self.subviews.first!.subviews.first!
        barBackgroundView.alpha = 0

        let subView = self.subviews[0].subviews[1].subviews[0]
        subView.layer.cornerRadius = 5
        subView.layer.masksToBounds = true
        subView.layer.borderWidth = 0.3
        subView.layer.borderColor = UIColor.lightGray.cgColor
        if searchIconOffset {
           setPositionAdjustment(UIOffset.init(horizontal: self.bounds.width/2 - 40, vertical: 0), for: .search)
        }else {
            setPositionAdjustment(UIOffset.zero, for: .search)
        }

        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "取消"
    }

}
