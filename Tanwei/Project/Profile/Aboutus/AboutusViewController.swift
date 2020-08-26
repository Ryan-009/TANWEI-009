//
//  AboutusViewController.swift
//  salestar
//
//  Created by 吴凯耀 on 2020/4/6.
//  Copyright © 2020 li zhou. All rights reserved.
//

import UIKit

class AboutusViewController: UIViewController {

    @IBOutlet weak var line: UIView!
    @IBOutlet weak var versionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        line.backgroundColor = APPGrayBackGroundColor
        
        self.title = "关于我们"
        // Do any additional setup after loading the view.
        versionLabel.text = "版本:" + DeviceInfo.getLocalAppVersion()
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
