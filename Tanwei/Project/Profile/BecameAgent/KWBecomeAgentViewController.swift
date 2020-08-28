//
//  KWBecomeAgentViewController.swift
//  Tanwei
//
//  Created by 吴凯耀 on 2020/7/28.
//  Copyright © 2020 吴凯耀. All rights reserved.
//

import UIKit

class KWBecomeAgentViewController: KWBaseViewController {

    let agentView = KWBecomAgentView.init(frame: CGRect(x: AutoW(45), y: NavHeight+15, width: SCREEN_WIDTH-AutoW(90), height: AutoW(440)))
    
    lazy var closeButton : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage(named: "tanwei_popup_close_icon"), for: .normal)
        btn.addTarget(self, action: #selector(closeClick), for: .touchUpInside)
        return btn
    }()
    
    var data : agentInfo = agentInfo() {
        didSet{
            self.agentView.data =  self.data
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.modalPresentationStyle = .custom
        self.view.addSubview(agentView)
        self.view.addSubview(closeButton)
        closeButton.snp.makeConstraints { (make) in
            make.top.equalTo(agentView.snp.bottom).offset(AutoW(15))
            make.centerX.equalToSuperview()
        }
        
    }
    
    @objc private func closeClick() {
        DispatchQueue.main.async {
            self.dismiss(animated: false, completion: nil)
        }
    }
}
