//
//  TWSubmitOddNumberSuccessViewController.swift
//  Tanwei
//
//  Created by 吴凯耀 on 2020/8/15.
//  Copyright © 2020 吴凯耀. All rights reserved.
//

import UIKit

class TWSubmitOddNumberSuccessViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "填写转账单号"
        // Do any additional setup after loading the view.
        self.navigationItem.leftBarButtonItem = SetBackBarButtonItem(target: self, action: #selector(back), imageName: "back")
    }

    @objc func back() {
        self.navigationController?.popToRootViewController(animated: true)
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
