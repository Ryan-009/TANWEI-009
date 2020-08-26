//
//  CusotmNavigationView.swift
//  CustomWeiChatSearchController
//
//  Created by 范国徽 on 2018/4/9.
//  Copyright © 2018年 范国徽. All rights reserved.
//

import UIKit

class CustomNavigationView: UIView {


    private lazy var titleLabel: UILabel = {

        let label = UILabel.init(frame: CGRect.zero)
        label.textColor = UIColor.white
        label.textAlignment = .center
        return label
    }()

    var title: String = ""{

        didSet{
            self.titleLabel.text = title
            setNeedsLayout()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black
        addSubview(titleLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        var frame = self.bounds
        frame.origin.y += StatusBarHeight
        frame.size.height -= StatusBarHeight
        titleLabel.frame = frame
    }

}
