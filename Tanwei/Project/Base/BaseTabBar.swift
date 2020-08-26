//
//  BaseTabBar.swift
//  LQM
//
//  Created by 刘昆朋 on 2020/4/12.
//  Copyright © 2020 WKY. All rights reserved.
//

import UIKit

class BaseTabBar: UITabBar {

    let plusButton = UIButton.init(type: .custom)
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        //添加加号按钮
        plusButton.setBackgroundImage(UIImage(named: "salestar_app_tab_icon_ad_u"), for: .normal)
        plusButton.setBackgroundImage(UIImage(named: "salestar_app_tab_icon_ad_s"), for: .highlighted)
        plusButton.setTitleColor(.blue, for: .highlighted)
        plusButton.setTitleColor(.gray, for: .normal)
        plusButton.addTarget(self, action: #selector(presentView), for: .touchUpInside)
        plusButton.isUserInteractionEnabled = true
        plusButton.setTitle("发广告", for: .normal)
        plusButton.layoutButton(style: .Top, imageTitleSpace: 4)
        addSubview(plusButton)
    }
    
    /**
     点击加号
     */
    @objc func presentView(){
        KWPrint("sjdfjklsd")
        let vc = PublishADViewController()
        CurrentVc().navigationController?.pushViewController(vc, animated: true)
//        if KWUser.userInfo.company == "" || KWUser.userInfo.userName == "" || KWUser.userInfo.jobPosition == "" ||  KWUser.userInfo.wechatId == ""{
//            let vc = EditInfoTableViewController()
//            CurrentVc().navigationController?.pushViewController(vc, animated: true)
//            KWHUD.showInfo(info: "请先完善个人信息")
//        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        let width = frame.width * 0.2
        var buttonIndex:CGFloat = 0
        
        plusButton.sizeToFit()
        
        if IS_IPhoneX_Series {
            plusButton.center = CGPoint(x: self.center.x, y: self.frame.height * 0.5 - 17)
        }else{
            plusButton.center = CGPoint(x: self.center.x, y: self.frame.height * 0.5)
        }
        
        
        for item in subviews{
            
            if item.isKind(of: NSClassFromString("UITabBarButton")!){
                
//                item.frame = CGRect(x: width * (buttonIndex > 0 ? buttonIndex + 1 : buttonIndex), y: 0, width: width, height: item.frame.height)
                
                item.frame = CGRect(x: buttonIndex == 0 ? screenWidth*0.1:screenWidth*0.7, y: 0, width: 75, height: TabHeight)
                
                buttonIndex = buttonIndex + 1
                
            }
        }
        addSubview(plusButton)
    }

}









