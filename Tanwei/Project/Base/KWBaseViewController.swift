//
//  KWBaseViewController.swift
//  KIWI
//
//  Created by li zhou on 2019/11/20.
//  Copyright © 2019 li zhou. All rights reserved.
//

import UIKit

class KWBaseViewController: UIViewController {

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

        self.view.backgroundColor = UIColor.white
        FinishEditControl.shared().set(self, #selector(finishEdit))
    }
    
    @objc func finishEdit() {
        self.view.endEditing(true)
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
