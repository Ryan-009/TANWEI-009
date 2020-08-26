//
//  KWBaseNavigationController.swift
//  KIWI
//
//  Created by li zhou on 2019/11/4.
//  Copyright © 2019 li zhou. All rights reserved.
//

import UIKit
import SVProgressHUD

class KWBaseNavigationController: UINavigationController {

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            viewController.navigationItem.leftBarButtonItem = SetBackBarButtonItem(target: self, action: #selector(back), imageName: "back.png")
        }
        super.pushViewController(viewController, animated: animated)
    }
    
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
        
        self.navigationBar.isTranslucent = true
        self.navigationBar.barTintColor  = UIColor.white
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        FinishEditControl.shared().set(self, #selector(finishEdit))
    }
    
    @objc func back() {
        SVProgressHUD.dismiss()
        self.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }

    @objc func finishEdit() {
        self.view.endEditing(true)
    }
}
