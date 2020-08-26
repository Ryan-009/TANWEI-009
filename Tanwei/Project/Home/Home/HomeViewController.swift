//
//  HomeViewController.swift
//  salestar
//
//  Created by li zhou on 2019/11/23.
//  Copyright © 2019 li zhou. All rights reserved.
//

import UIKit
import YYText
import MJRefresh
import SVProgressHUD

class HomeViewController: KWBaseViewController,UITableViewDelegate,UITableViewDataSource{
    
    var adList : [contentDtoModel] = [] {
        didSet{
            self.tableView.reloadData()
        }
    }
    
    var bannarList : [allBannarModel] = [] {
        didSet{
            
        }
    }
    
    lazy var tableView : UITableView = {
        let tab = UITableView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-TabHeight))
        tab.delegate = self
        tab.dataSource = self
        tab.tableFooterView = UIView(frame: .zero)
        tab.register(TextAndImageTableViewCell.self, forCellReuseIdentifier: "TEXTANDIMAGECELLID")
        return tab
    }()
    
    lazy var headerView : UIView = {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: AutoW(210)+44+AutoW(10)+AutoW(40)))
        header.backgroundColor = UIColor.white
        header.addSubview(self.searchBar)
        header.addSubview(citySelectButton)
        header.addSubview(professorButton)
        header.addSubview(adView)
        let line = UIView(frame: CGRect(x: 0, y: 44+AutoW(12)+AutoW(40), width: screenWidth, height: AutoW(0.5)))
        line.backgroundColor = ColorFromHexString("#D6D6D6")
        header.addSubview(line)
        
        header.addSubview(seg)
        seg.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(professorButton)
        }
        
        return header
    }()
    
    let adView = HomeHeaderView.init(frame: CGRect(x: 0, y: 44+AutoW(10)+AutoW(40), width: SCREEN_WIDTH, height: AutoW(210)))
    
    lazy var searchBar: CustomSearchBar = {
        let bar = CustomSearchBar.init(frame: CGRect.init(x: AutoW(8), y: 0, width: SCREEN_WIDTH-AutoW(16), height: 44))
        bar.searchIconOffset = true
        bar.delegate = self
        return bar
    }()
    
    lazy var searchVC: WeiChatSearchViewController = {
        let searchResultVC = WeiChatSearchResultVC.init(nibName: nil, bundle: nil)
        let searchVC = WeiChatSearchViewController.init(searchResultVC: searchResultVC)
        searchVC.searchControllerDelegate = self
        let cancleAction: cancelHandler = {
            [weak self] in
            guard let strong = self else {return}
            strong.searchVC.view.removeFromSuperview()
            strong.searchVC.removeFromParent()
            CATransaction.begin()
            strong.searchBar.setShowsCancelButton(true, animated: false)
            CATransaction.setDisableActions(true)
            CATransaction.commit()
            CATransaction.setCompletionBlock({
                UIView.animate(withDuration: 0.28, animations: {
                    strong.searchBar.setShowsCancelButton(false, animated: true)
                }, completion: {
                    [weak self](_) in
                })
            })
        }
        searchVC.cancelBlock = cancleAction
        return searchVC
    }()
    
    var filterResult: [String] = []
    var dataArray: [String] = []
    var selectedADRowWhenShowImage = 0
    private var page = 0
    private let limit = 10
    lazy var citySelectButton : UIButton = {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: SCREEN_WIDTH-AutoW(85)-AutoW(15), y: AutoW(10)+44, width: AutoW(85), height: AutoW(30))
        btn.layer.cornerRadius = AutoW(6)
        btn.layer.borderColor = ColorFromHexString("#979797").cgColor
        btn.layer.borderWidth = AutoW(0.5)
        btn.clipsToBounds = true
        btn.setTitle("发货地", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitleColor(UIColor.darkGray, for: .normal)
        btn.setImage(UIImage(named: "arrow_down"), for: .normal)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: AutoW(-25), bottom: 0, right: 0)
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: AutoW(90), bottom: 0, right: 0)
        btn.addTarget(self, action: #selector(citySelectFunc), for: .touchUpInside)
        return btn
    }()
    
    lazy var professorButton : UIButton = {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: AutoW(15), y: AutoW(10)+44, width: AutoW(85), height: AutoW(30))
        btn.layer.cornerRadius = AutoW(6)
        btn.layer.borderColor = ColorFromHexString("#979797").cgColor
        btn.layer.borderWidth = AutoW(0.5)
        btn.clipsToBounds = true
        btn.setTitle("商品分类", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitleColor(UIColor.darkGray, for: .normal)
        btn.setImage(UIImage(named: "arrow_down"), for: .normal)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: AutoW(-15), bottom: 0, right: 0)
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: AutoW(90), bottom: 0, right: 0)
        btn.addTarget(self, action: #selector(professorSelectFunc), for: .touchUpInside)
        return btn
    }()
    
    lazy var seg : UISegmentedControl = {
        let tags = ["批发商","卖家"] as [Any]
        let segmented = UISegmentedControl(items: tags)
        segmented.selectedSegmentIndex = 0
        return segmented
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    ///用于保存被点击后的图片区域
    var selectedImageView : UIImageView = UIImageView()
    var selTatalPages : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selfInit()
//        KWSystem.loginPresent(self)
        loadBannar()
        KWListener.register.openedApplicationService(target: self, selector: #selector(loadData))
    }
    
    func selfInit() {
        self.view.addSubview(tableView)
        self.tableView.tableHeaderView = self.headerView
        let header = MJRefreshNormalHeader()
        header.ignoredScrollViewContentInsetTop = 30
        header.setRefreshingTarget(self, refreshingAction: #selector(loadData))
        self.tableView.mj_header = header
        
        let footer  = MJRefreshAutoNormalFooter()
        footer.setRefreshingTarget(self, refreshingAction: #selector(loadMoreData))
        self.tableView.mj_footer = footer
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return adList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TEXTANDIMAGECELLID", for: indexPath) as! TextAndImageTableViewCell
        cell.loadData(data: self.adList[indexPath.row])
        cell.didSelectImageblock = {[weak self](selView,selIndex,selTatalPages) in
            self?.selectedADRowWhenShowImage = indexPath.row
            self?.selectedImageView = selView
            self?.selTatalPages = selTatalPages
            self?.showImage(index: selIndex, total: selTatalPages)
        }
        cell.headerClick = {[unowned self] in
            let vc = PersonalInfoTableViewController()
            vc.adModel = self.adList[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
        cell.updateBlock = {()in
            tableView.reloadRows(at: [indexPath], with: .none)
        }
        cell.didSelectLinkblock = { link in
            let webVc = KWServiceViewController();
            webVc.url = link
            let nav = KWBaseNavigationController(rootViewController: webVc)
            self.present(nav, animated: true, completion: nil)
        }
        cell.jubaoClick = {() in
            let contentArr = ["低俗色情","标题党","内容不实","垃圾内容"]
            
            AlertActionSheetTool.showAlert(titleStr: "举报理由", msgStr: "", style: .actionSheet, currentVC: self, cancelBtn: "取消", cancelHandler: { (action) in
                
            }, otherBtns: contentArr) { (index) in
                
                if !KWLogin.existLoginStatus() {
                    let vc = SSLoginViewController()
                    let nav = KWBaseNavigationController.init(rootViewController: vc)
                    self.present(nav, animated: true, completion: nil)
                    return
                }
                
                Application.opration.resetpassword(oldPassword: "123456", password: "123456", confirmPassword: "123456", success: {
                    SVProgressHUD.showSuccess(withStatus: "举报成功")
                }) {
                    SVProgressHUD.showSuccess(withStatus: "举报成功")
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.adList[indexPath.row].cellHeight
    }

    deinit {
        KWListener.remover.openedApplicationService(target: self)
    }
}

extension HomeViewController {
    @objc func citySelectFunc() {
        let vc = CustomLevelsPickerViewController.init()
        vc.view.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        self.present(vc, animated: false, completion: nil)
        vc.didSelected = {city in
            self.citySelectButton.setTitle(city, for: .normal)
        }
    }
    
    @objc func professorSelectFunc() {
        
    }
    
    @objc func loadData() {
        var par : [String:Any] = [:]
        par[KWNetworkDefine.KEY.limit.rawValue] = limit
        par[KWNetworkDefine.KEY.start.rawValue] = page
        Application.list.search(parameters: par, success: { (dtos) in
            self.adList = dtos
            self.tableView.mj_header?.endRefreshing()
            self.tableView.mj_footer?.endRefreshing()
            self.page = 0
        }) {
            self.tableView.mj_header?.endRefreshing()
            self.tableView.mj_footer?.endRefreshing()
        }
    }
    
    @objc func loadMoreData() {
        var par : [String:Any] = [:]
        par[KWNetworkDefine.KEY.limit.rawValue] = limit
        par[KWNetworkDefine.KEY.start.rawValue] = page
        Application.list.search(parameters: par, success: { (dtos) in
            self.adList.append(contentsOf: dtos)
            self.tableView.mj_footer?.endRefreshing()
            self.page += self.limit
        }) {
            self.tableView.mj_header?.endRefreshing()
            self.tableView.mj_footer?.endRefreshing()
        }
    }
    
    func loadBannar() {
        Application.list.allBanners(success: { (bannarList) in
//            self.bannarList = bannarList
            self.adView.bannerDataList = bannarList
        }) {}
    }
}
