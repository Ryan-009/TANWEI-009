//
//  SSScrollView.swift
//  salestar
//
//  Created by li zhou on 2020/1/4.
//  Copyright © 2020 li zhou. All rights reserved.
//

import UIKit

class SSScrollView: UIScrollView {

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        self.isScrollEnabled = true
        return view
    }

}
