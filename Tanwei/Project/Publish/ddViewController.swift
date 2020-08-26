//
//  ddViewController.swift
//  salestar
//
//  Created by li zhou on 2019/11/23.
//  Copyright © 2019 li zhou. All rights reserved.
//

import UIKit

class ddViewController: UIViewController {
    
    fileprivate var scrollView : UIScrollView = {
        let scrol = UIScrollView(frame: CGRect(x: 0, y: NavHeight, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-NavHeight))
        scrol.showsVerticalScrollIndicator = true
        scrol.showsHorizontalScrollIndicator = true
        scrol.contentSize = CGSize(width: SCREEN_WIDTH, height: SCREEN_HEIGHT+AutoW(100))
        scrol.backgroundColor = UIColor.red
        return scrol
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(scrollView)
        
        let sdf = UIView(frame: CGRect(x: 0, y: 100, width: SCREEN_WIDTH, height: 200))
        sdf.backgroundColor = UIColor.yellow
        self.scrollView.addSubview(sdf)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
