//
//  ADViewController.swift
//  salestar
//
//  Created by 吴凯耀 on 2020/4/6.
//  Copyright © 2020 li zhou. All rights reserved.
//

import UIKit

class SearchADViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var adList : [contentDtoModel] = [] {
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
        imagV.image = UIImage(named: "nothing_icon.png")
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
    var searchMyAD = false {
        didSet{
            loadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if searchMyAD {
            self.title = "我的广告"
        }else{
            self.title = "搜索结果"
        }
        
        selfInit()
    }
    
    func selfInit() {
        self.view.addSubview(tableView)
    }
    
    private func searchFunc() {
        var par : [String:Any] = [:]
        par[KWNetworkDefine.KEY.limit.rawValue] = 100
        par[KWNetworkDefine.KEY.start.rawValue] = 0
        par[KWNetworkDefine.KEY.keyword.rawValue] = self.searchKey
        Application.list.search(parameters: par, success: { (dtos) in
            self.adList = dtos
        }) {}
    }
    func loadData() {
        var par : [String:Any] = [:]
        par[KWNetworkDefine.KEY.limit.rawValue] = 50
        par[KWNetworkDefine.KEY.start.rawValue] = 0
        par[KWNetworkDefine.KEY.userId.rawValue] = KWUser.userInfo.userId
        Application.list.searchByUser(parameters: par, success: { (dtos) in
            self.adList = dtos
        }) {}
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
        cell.updateBlock = {()in
            tableView.reloadData()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.adList[indexPath.row].cellHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func checkNet_break(){
        if self.adList.count == 0{
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
        photoBrowser.resId = self.adList[selectedADRowWhenShowImage].imgResIds
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
        
        let imgResIds = self.adList[selectedADRowWhenShowImage].imgResIds.components(separatedBy: ";")
        if imgResIds.count > index {
            return URL(string: ImageBaseURL + imgResIds[index])
        }
        return nil
    }
    
}

