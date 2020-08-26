//
//  KWBaseTabBarViewController.swift
//  KIWI
//
//  Created by li zhou on 2019/11/4.
//  Copyright © 2019 li zhou. All rights reserved.
//

import UIKit

class KWBaseTabBarViewController: UITabBarController,UITabBarControllerDelegate {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        FinishEditControl.shared().setKeyboardObserver()
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        FinishEditControl.shared().removeKeyboardObserver()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FinishEditControl.shared().set(self, #selector(finishEdit))
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        if (viewController.tabBarItem.title == "我的" || viewController.tabBarItem.title == "发广告") && !KWLogin.existLoginStatus(){
            let vc = SSLoginViewController()
            let nav = KWBaseNavigationController.init(rootViewController: vc)
            self.present(nav, animated: true, completion: nil)
            return false
        }
        
        return true
    }
    @objc func finishEdit() {
        self.view.endEditing(true)
    }
}
