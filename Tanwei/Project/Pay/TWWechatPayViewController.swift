//
//  TWWechatPayViewController.swift
//  Tanwei
//
//  Created by 吴凯耀 on 2020/8/15.
//  Copyright © 2020 吴凯耀. All rights reserved.
//

import UIKit

class TWWechatPayViewController: UIViewController {
    
    var data : PriceModel = PriceModel()
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var writeAccountCodeButton: UIButton!
    @IBOutlet weak var qrCodeImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        selfInit()
    }

    private func selfInit() {
        self.title = "支付"
        self.saveButton.layer.cornerRadius = 4
        self.saveButton.layer.borderColor = UIColor.init(red: 35/255, green: 171/255, blue: 57/255, alpha: 1).cgColor
        self.saveButton.layer.borderWidth = 0.6
        self.saveButton.clipsToBounds = true
        self.writeAccountCodeButton.layer.cornerRadius = 4
        self.writeAccountCodeButton.clipsToBounds = true
        self.saveButton.addTarget(self, action: #selector(saveImage), for: .touchUpInside)
        self.writeAccountCodeButton.addTarget(self, action: #selector(writeCode), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.qrCodeImageView.image = UIImage(named: "tanwei_pay_\(data.newPrice)_img")
    }
    
    @objc private func saveImage() {
        UIImageWriteToSavedPhotosAlbum(self.qrCodeImageView.image!, self, #selector(image(image:didFinishSavingWithError:contextInfo:)
            ), nil)
    }

    @objc func image(image: UIImage, didFinishSavingWithError: NSError?, contextInfo: AnyObject) {
        
        if didFinishSavingWithError != nil {
            KWHUD.showInfo(info: "保存失败")
            return
        }
        KWHUD.showInfo(info: "保存成功")
    }
    
    @objc private func writeCode() {
        let vc = TWSetPayCodeViewController.init(nibName: "TWSetPayCodeViewController", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
   
}
