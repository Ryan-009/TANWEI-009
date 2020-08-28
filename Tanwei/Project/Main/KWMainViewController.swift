//
//  KWMainViewController.swift
//  KIWI
//
//  Created by li zhou on 2019/11/4.
//  Copyright © 2019 li zhou. All rights reserved.
//

import UIKit

class KWMainViewController: KWBaseTabBarViewController {
    
    private let homeItem    : UITabBarItem = UITabBarItem (title: "发现", image: UIImage(named: ImageNameForNomalHomeItem)?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: ImageNameForPressHomeItem)?.withRenderingMode(.alwaysOriginal))
    
    private let profileItem    : UITabBarItem = UITabBarItem (title: "我的", image: UIImage(named: ImageNameForNomalPROFILEItem)?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: ImageNameForPressPROFILEItem)?.withRenderingMode(.alwaysOriginal))
    
    private let starItem    : UITabBarItem = UITabBarItem (title: "发布商品", image: UIImage(named: ImageNameForNomalPublishItem)?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: ImageNameForPressPublishItem)?.withRenderingMode(.alwaysOriginal))
    
    private let likeItem    : UITabBarItem = UITabBarItem (title: "已关注", image: UIImage(named: ImageNameForNomalLikeItem)?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: ImageNameForPressLikeItem)?.withRenderingMode(.alwaysOriginal))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self

        let homeNavigationController     = KWBaseNavigationController(rootViewController: HomeViewController())
        let likeNavigationController     = KWBaseNavigationController(rootViewController: LikeViewController())
        let publishNavigationController = KWBaseNavigationController(rootViewController: PublishADViewController())
        let profileNavigationController  = KWBaseNavigationController(rootViewController: SSMineTableViewController())
        
        homeNavigationController.tabBarItem         = homeItem
        publishNavigationController.tabBarItem      = starItem
        profileNavigationController.tabBarItem      = profileItem
        likeNavigationController.tabBarItem         = likeItem
        self.viewControllers = [homeNavigationController,likeNavigationController,publishNavigationController,profileNavigationController]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //设置tabbar
    func setTabBar(){
        let newTabBar = BaseTabBar.init(frame: tabBar.bounds)
        setValue(newTabBar, forKey: "tabBar")
    }
}
