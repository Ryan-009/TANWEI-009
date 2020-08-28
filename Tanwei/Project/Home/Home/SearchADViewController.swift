//
//  ADViewController.swift
//  salestar
//
//  Created by 吴凯耀 on 2020/4/6.
//  Copyright © 2020 li zhou. All rights reserved.
//

import UIKit

class SearchADViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var contentlist : [contentModel] = [] {
        didSet{
            checkNet_break()
            self.tableView.reloadData()
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
        label.frame.size = CGSize(width: AutoW(200), height: AutoW(40))
        label.textColor = ColorFromHexString("#969696")
        label.text = "未找到相关结果"
        label.font = UIFont.systemFont(ofSize: 14)
        label.sizeToFit()
        return label
    }()
    var selectedImageView : UIImageView = UIImageView()
    var selTatalPages : Int = 0
    var selectedADRowWhenShowImage = 0
    
    var searchKey = "" {
        didSet{
            searchFunc()
        }
    }
    
    lazy var seg : UISegmentedControl = {
        let tags = ["批发商","卖家"] as [Any]
        let segmented = UISegmentedControl(items: tags)
        segmented.selectedSegmentIndex = 0
        segmented.addTarget(self, action: #selector(segSwitch), for: .valueChanged)
        return segmented
    }()
    
    enum SalerType {
        case wholesaler
        case saler
    }
    
    fileprivate var saleType : SalerType = .wholesaler
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.title = "搜索结果"
        selfInit()
    }
    
    func selfInit() {
        self.view.addSubview(tableView)
        self.navigationItem.titleView = seg
    }
    
    @objc fileprivate func segSwitch() {
        if self.seg.selectedSegmentIndex == 0 {
            self.saleType = .wholesaler
        }else{
            self.saleType = .saler
        }
        HUD.show()
        searchFunc()
    }
    
    private func searchFunc() {
        var par : [String:Any] = [:]
        par[KWNetworkDefine.KEY.start.rawValue] = 0
        par[KWNetworkDefine.KEY.limit.rawValue] = 100
        par[KWNetworkDefine.KEY.content.rawValue] = searchKey
        if self.saleType == .wholesaler {
            Application.list.allContentFactory(parameters: par, success: {dataList in
                self.tableView.mj_header?.endRefreshing()
                self.tableView.mj_footer?.endRefreshing()
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

extension SearchADViewController:PhotoBrowserDelegate{
   
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

