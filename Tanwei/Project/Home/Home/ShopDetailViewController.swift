//
//  ShopDetailViewController.swift
//  Tanwei
//
//  Created by 吴凯耀 on 2020/8/8.
//  Copyright © 2020 吴凯耀. All rights reserved.
//

import UIKit
import MJRefresh

class ShopDetailViewController: KWBaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    enum SalerType {
        case wholesaler
        case saler
    }
    
    var saleType : SalerType = .wholesaler

    var contentlist : [contentModel] = [] {
        didSet{
            self.tableView.reloadData()
        }
    }
    lazy var nil_imageView : UIImageView = {
        let imagV = UIImageView()
        imagV.image = UIImage(named: "tanwei_empty_img.png")
        imagV.frame.size = CGSize(width: AutoW(155), height: AutoW(155))
        imagV.contentMode = .scaleAspectFit
        imagV.clipsToBounds = true
        return imagV
    }()
    
    lazy var nil_label : UILabel = {
        let label = UILabel()
        label.frame.size = CGSize(width: SCREEN_WIDTH, height: AutoW(40))
        label.textColor = ColorFromHexString("#969696")
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 14)
        label.sizeToFit()
        return label
    }()
    lazy var tableView : UITableView = {
        let tab = UITableView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        tab.delegate = self
        tab.dataSource = self
        tab.tableFooterView = UIView(frame: .zero)
        tab.register(TextAndImageTableViewCell.self, forCellReuseIdentifier: "TEXTANDIMAGECELLID")
        return tab
    }()
    
    var filterResult: [String] = []
    var dataArray: [String] = []
    var selectedADRowWhenShowImage = 0
    private var page = 0
    private let limit = 10
    ///用于保存被点击后的图片区域
    var selectedImageView : UIImageView = UIImageView()
    var selTatalPages : Int = 0
    var userId : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        selfInit()
        loadData()
    }
    
    func selfInit() {
        self.view.addSubview(tableView)
        let header = MJRefreshNormalHeader()
        header.ignoredScrollViewContentInsetTop = 30
        header.setRefreshingTarget(self, refreshingAction: #selector(loadData))
        self.tableView.mj_header = header
        
        let footer  = MJRefreshAutoNormalFooter()
        footer.setRefreshingTarget(self, refreshingAction: #selector(loadMoreData))
        self.tableView.mj_footer = footer
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TEXTANDIMAGECELLID", for: indexPath) as! TextAndImageTableViewCell
        cell.loadData(data: self.contentlist[indexPath.row])
        cell.didSelectImageblock = {[weak self](selView,selIndex,selTatalPages) in
            self?.selectedADRowWhenShowImage = indexPath.row
            self?.selectedImageView = selView
            self?.selTatalPages = selTatalPages
            self?.showImage(index: selIndex, total: selTatalPages)
        }
        cell.headerClick = {[unowned self] in
            let vc = PersonalInfoTableViewController()
//            vc.adModel = self.contentlist[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
        cell.updateBlock = {()in
            tableView.reloadRows(at: [indexPath], with: .none)
        }
        cell.transmitClick = {()in
            let vc = PublishADViewController.init()
            vc.transmitData = self.contentlist[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
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
                    HUD.showSuccess(withStatus: "举报成功")
                }) {
                    HUD.showSuccess(withStatus: "举报成功")
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.contentlist[indexPath.row].cellHeight
    }

    deinit {
        KWListener.remover.openedApplicationService(target: self)
    }
    
    @objc fileprivate func loadData() {
        HUD.show()
        var par : [String:Any] = [:]
        par[KWNetworkDefine.KEY.start.rawValue] = 0
        par[KWNetworkDefine.KEY.limit.rawValue] = limit
        par[KWNetworkDefine.KEY.userIdFocus.rawValue] = userId
        if self.saleType == .wholesaler {
            Application.list.allContentFactory(parameters: par, success: {dataList in
                self.tableView.mj_header?.endRefreshing()
                self.tableView.mj_footer?.endRefreshing()
                self.page = self.limit
                self.contentlist = dataList
                self.checkNet_break()
                HUD.dismiss()
            }) {
                self.tableView.mj_header?.endRefreshing()
                self.tableView.mj_footer?.endRefreshing()
                self.checkNet_break()
                HUD.dismiss()
            }
        }else{
            Application.list.allContentShop(parameters: par, success: {dataList in
                self.checkNet_break()
                self.tableView.mj_header?.endRefreshing()
                self.tableView.mj_footer?.endRefreshing()
                self.contentlist = dataList
                HUD.dismiss()
            }) {
                self.checkNet_break()
                self.tableView.mj_header?.endRefreshing()
                self.tableView.mj_footer?.endRefreshing()
                HUD.dismiss()
            }
        }
    }

    @objc func loadMoreData() {
        var par : [String:Any] = [:]
        par[KWNetworkDefine.KEY.limit.rawValue] = limit
        par[KWNetworkDefine.KEY.start.rawValue] = page
        par[KWNetworkDefine.KEY.userIdFocus.rawValue] = userId
        
        if self.saleType == .wholesaler {
            Application.list.allContentFactory(parameters: par, success: {dataList in
                self.contentlist.append(contentsOf: dataList)
                self.tableView.mj_header?.endRefreshing()
                self.tableView.mj_footer?.endRefreshing()
                self.page += self.limit
                self.checkNet_break()
            }) {
                self.checkNet_break()
                self.tableView.mj_header?.endRefreshing()
                self.tableView.mj_footer?.endRefreshing()
            }
        }else{
            Application.list.allContentShop(parameters: par, success: {dataList in
                self.contentlist.append(contentsOf: dataList)
                self.tableView.mj_header?.endRefreshing()
                self.tableView.mj_footer?.endRefreshing()
                self.page += self.limit
                self.checkNet_break()
            }) {
                self.checkNet_break()
                self.tableView.mj_header?.endRefreshing()
                self.tableView.mj_footer?.endRefreshing()
            }
        }
    }
    
    func checkNet_break(){
        if self.contentlist.count == 0{
            self.nil_imageView.center = CGPoint(x: SCREEN_WIDTH * 0.5, y: (SCREEN_HEIGHT) * 0.4)
            self.view.addSubview(self.nil_imageView)
            self.nil_label.center = CGPoint(x: SCREEN_WIDTH * 0.5, y: SCREEN_HEIGHT * 0.56)
            self.view.addSubview(self.nil_label)
        }else{
            self.nil_label.removeFromSuperview()
            self.nil_imageView.removeFromSuperview()
        }
    }
}

extension ShopDetailViewController:PhotoBrowserDelegate{
   
    @objc func showImage(index:Int,total:Int) {
        let photoBrowser = PhotoBrowser(showByViewController: self, delegate: self)
        photoBrowser.resId = self.contentlist[selectedADRowWhenShowImage].resId
        // 装配PageControl，提供了两种PageControl实现，若需要其它样式，可参照着自由定制
        photoBrowser.pageControlDelegate = PhotoBrowserDefaultPageControlDelegate(numberOfPages:total)
        photoBrowser.show(index: index)
    }
    
    func numberOfPhotos(in photoBrowser: PhotoBrowser) -> Int {
        return self.selTatalPages
    }
    
    func photoBrowser(_ photoBrowser: PhotoBrowser, thumbnailViewForIndex index: Int) -> UIView? {
        return self.selectedImageView
    }
    
    func photoBrowser(_ photoBrowser: PhotoBrowser, thumbnailImageForIndex index: Int) -> UIImage? {
        // 取thumbnailImage
        return self.selectedImageView.image
    }
    
    func photoBrowser(_ photoBrowser: PhotoBrowser, highQualityUrlStringForIndex index: Int) -> URL? {
        
        let imgResIds = self.contentlist[selectedADRowWhenShowImage].resId.components(separatedBy: ";")
        if imgResIds.count > index {
            return URL(string: ImageBaseURL + imgResIds[index])
        }
        return nil
    }
    
}
