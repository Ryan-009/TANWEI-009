//
//  SaleStarViewController.swift
//  salestar
//
//  Created by li zhou on 2020/1/4.
//  Copyright © 2020 li zhou. All rights reserved.
//

import UIKit

class SaleStarViewController: UIViewController {

    fileprivate var scrollView : UIScrollView = {
        let scrol = UIScrollView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-TabHeight))
        scrol.showsVerticalScrollIndicator = false
        scrol.showsHorizontalScrollIndicator = false
        scrol.contentSize = CGSize(width: SCREEN_WIDTH, height: 2894)
        return scrol
    }()
    
    fileprivate var imageView : UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "salestar.png"))
        imageView.contentMode = .scaleAspectFit
        imageView.sizeToFit()
        return imageView
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.equalToSuperview()
//            make.height.equalTo(AutoH(2894))
        }
        scrollView.contentSize = CGSize(width: SCREEN_WIDTH, height: imageView.frame.size.height)
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
