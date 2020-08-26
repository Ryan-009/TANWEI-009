//
//  WeiChatSearchViewController.swift
//  CustomWeiChatSearchController
//
//  Created by 范国徽 on 2018/4/8.
//  Copyright © 2018年 范国徽. All rights reserved.
//

import UIKit
let screenWidth = UIScreen.main.bounds.width
let screenHeight: CGFloat = UIScreen.main.bounds.height

@objc protocol WeiChatSerachViewControllerDelegate {

    func willPresentSearchController(_ searchController: WeiChatSearchViewController)
    func willDismissSearchController(_ searchController: WeiChatSearchViewController)
    func updateSearchResults(for searchController: WeiChatSearchViewController)
}
typealias cancelHandler = () -> ()


class WeiChatSearchViewController: KWBaseViewController {

    var searchResultViewController: WeiChatSearchResultVC!
    
    weak var searchControllerDelegate: WeiChatSerachViewControllerDelegate?

    init(searchResultVC: WeiChatSearchResultVC){
        super.init(nibName: nil, bundle: nil)
        self.searchResultViewController = searchResultVC
        let yCoordinate: CGFloat = StatusBarHeight + 44
        self.searchResultViewController.view.frame = CGRect.init(x: 0, y: yCoordinate, width: self.view.bounds.width, height: screenHeight-yCoordinate)
    }

    var cancelBlock: cancelHandler?

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.searchBar.becomeFirstResponder()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.customNavigationBar)
        self.view.addSubview(self.searchBar)
        self.setNeedsStatusBarAppearanceUpdate()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        let navigationViewHeight: CGFloat =  statusBarHeight + 44
//        customNavigationBar.frame = CGRect.init(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: navigationViewHeight)
    }

    lazy var customNavigationBar: CustomNavigationView = {
        let navigationView = CustomNavigationView.init(frame: .zero)
//        navigationView.title = ""
        navigationView.backgroundColor = UIColor.groupTableViewBackground
        return navigationView
    }()


    //自定义搜索框
    lazy var searchBar: CustomSearchBar = {
        var yCoordinate: CGFloat = StatusBarHeight
//        if UIDevice.isIPhoneX {
//            yCoordinate = 34
//        }
         let searchBar = CustomSearchBar.init(frame: CGRect.init(x: 0, y: yCoordinate, width: screenWidth , height: 44))
         searchBar.searchIconOffset = false
         searchBar.delegate = self
         return searchBar
    }()

}

extension WeiChatSearchViewController: UISearchBarDelegate {

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        cancelBlock?()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        guard let content =  self.searchBar.text, !content.isEmpty else {
            self.searchControllerDelegate?.willDismissSearchController(self)
            return
        }

        if content.count == 1 {
            self.searchControllerDelegate?.willPresentSearchController(self)
        }

        self.searchControllerDelegate?.updateSearchResults(for: self)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if UnEmpty(searchBar.text) {
            searchBar.resignFirstResponder()
            let vc = SearchADViewController()
            vc.searchKey = searchBar.text!
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
extension WeiChatSearchViewController {
    
}
