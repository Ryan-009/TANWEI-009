//
//  PersonalInfoTableViewController.swift
//  salestar
//
//  Created by li zhou on 2019/12/10.
//  Copyright © 2019 li zhou. All rights reserved.
//

import UIKit
import SVProgressHUD

class PersonalInfoTableViewController: KWBaseTableViewController {
    
    let header = PersonalInfoHeaderView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: AutoW(240)))
    let leftBtn = UIButton(type: .system)
    let rightBtn = UIButton(type: .system)
    ///用于保存被点击后的图片区域
    var selectedImageView : UIImageView = UIImageView()
    var selTatalPages : Int = 0
    var selectedADRowWhenShowImage = 0
    
    var adModel : contentDtoModel = contentDtoModel() {
        didSet{
            self.header.adModel = adModel
            loadData()
        }
    }
    
    var adList : [contentDtoModel] = [] {
        didSet{
            self.tableView.reloadData()
        }
    }
    
    lazy var banner : UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.white
        
        leftBtn.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH*0.5, height: 60)
        leftBtn.setTitle("个人信息", for: .normal)
        leftBtn.setTitleColor(UIColor.black, for: .normal)
        leftBtn.addTarget(self, action: #selector(leftFunc), for: .touchUpInside)
        view.addSubview(leftBtn)
        
        rightBtn.setTitle("Ta的广告", for: .normal)
        rightBtn.frame = CGRect(x: SCREEN_WIDTH*0.5, y: 0, width: SCREEN_WIDTH*0.5, height: 60)
        rightBtn.setTitleColor(UIColor.lightGray, for: .normal)
        rightBtn.addTarget(self, action: #selector(rightFunc), for: .touchUpInside)
        view.addSubview(rightBtn)
        
        let line = UIView(frame: CGRect(x: 0, y: 59.4, width: SCREEN_WIDTH, height: 0.6))
        line.backgroundColor = UIColor.lightGray
        view.addSubview(line)
        return view
    }()
    
    enum type:Int {
        case info = 0
        case ad   = 1
    }
    
    var cellType : type = .info {
        didSet{
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(KWPersonInfoTableViewCell.self, forCellReuseIdentifier: "PERSONALINFOCELLID")
        self.tableView.register(TextAndImageTableViewCell.self, forCellReuseIdentifier: "TEXTIMAGECELLID")
        self.tableView.register(UINib(nibName: "ADPInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "ADPINFOCELLID")
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.tableHeaderView = header
        self.title = "个人信息"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.adModel.userId == 0 {
            KWUser.adInfo.update()
            self.header.isMySelf = true
            KWListener.register.myAdLoaded(target: self, selector: #selector(loadMyData))
            header.headerClick = {() in
                self.showPhotoAlert()
            }
            self.adModel.company = KWUser.userInfo.company
            self.adModel.companyPortal = KWUser.userInfo.website
            self.adModel.profession = KWUser.userInfo.label
            self.adModel.region = KWUser.userInfo.location
            self.adModel.jobPosition = KWUser.userInfo.jobPosition
            self.adModel.cPhone = KWUser.userInfo.cPhone
            self.adModel.wechatId = "KWUser.userInfo.wechatId"
        }else{
            self.navigationItem.rightBarButtonItem = SetRightBarButtonItem(imageName: "", title: "拉黑", textColor: .black, target: self, action: #selector(blackFunc))
        }
    }
    
    deinit {
        KWListener.remover.myAdLoaded(target: self)
    }
    
    @objc func loadMyData() {
        self.adList = KWUser.adInfo.info
    }
    
    func loadData() {
        var par : [String:Any] = [:]
        par[KWNetworkDefine.KEY.limit.rawValue] = 50
        par[KWNetworkDefine.KEY.start.rawValue] = 0
        par[KWNetworkDefine.KEY.userId.rawValue] = self.adModel.userId
        Application.list.searchByUser(parameters: par, success: { (dtos) in
            self.adList = dtos
        }) {}
    }
    var isSelected = false
    @objc private func blackFunc() {
        
        if !KWLogin.existLoginStatus() {
            let vc = SSLoginViewController()
            let nav = KWBaseNavigationController.init(rootViewController: vc)
            self.present(nav, animated: true, completion: nil)
            return
        }
        
        
        isSelected = !isSelected

        if isSelected {
            AlertActionSheetTool.showAlert(titleStr: "提示", msgStr: "拉黑后你将无法看到ta发布的广告,确认要拉黑ta吗?", currentVC: self, cancelHandler: { (action) in
                
            }, otherBtns: ["确定"]) { (index) in
                Application.opration.opblacklist(op: 0, black_phone: self.adModel.phone, success: {
                    KWHUD.showInfo(info: "拉黑成功")
                    self.navigationItem.rightBarButtonItem = SetRightBarButtonItem(imageName: "", title: "取消拉黑", textColor: .black, target: self, action: #selector(self.blackFunc))
                }) {
                    KWHUD.showInfo(info: "操作失败")
                }
            }
        }else{
            Application.opration.opblacklist(op: 1, black_phone: self.adModel.phone, success: {
                KWHUD.showInfo(info: "取消拉黑成功")
                self.navigationItem.rightBarButtonItem = SetRightBarButtonItem(imageName: "", title: "拉黑", textColor: .black, target: self, action: #selector(self.blackFunc))
            }) {
                KWHUD.showInfo(info: "操作失败")
            }
        }
        
        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.cellType == .info ? 7 : self.adList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.cellType == .info {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "PERSONALINFOCELLID", for: indexPath) as! KWPersonInfoTableViewCell
//            if adModel.userId != 0 {
//                cell.loadData(self.adModel)
//            }else{
//                cell.isMySelf = true
//            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "ADPINFOCELLID", for: indexPath) as! ADPInfoTableViewCell
            cell.loadDataWithIndex(indexPath.row, data: self.adModel)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TEXTIMAGECELLID", for: indexPath) as! TextAndImageTableViewCell
//            cell.loadData(data: self.adList[indexPath.row])
            cell.didSelectImageblock = {[weak self](selView,selIndex,selTatalPages) in
                self?.selectedADRowWhenShowImage = indexPath.row
                self?.selectedImageView = selView
                self?.selTatalPages = selTatalPages
                self?.showImage(index: selIndex, total: selTatalPages)
            }
            cell.updateBlock = {()in
                tableView.reloadRows(at: [indexPath], with: .none)
            }
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.cellType == .info {
            return 60
        }else{
            return self.adList[indexPath.row].cellHeight
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return banner
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    @objc func leftFunc(left:UIButton){
        self.cellType = .info
        left.setTitleColor(UIColor.black, for: .normal)
        rightBtn.setTitleColor(UIColor.lightGray, for: .normal)
    }
    
    @objc func rightFunc(right:UIButton) {
        self.cellType = .ad
        right.setTitleColor(UIColor.black, for: .normal)
        leftBtn.setTitleColor(UIColor.lightGray, for: .normal)
    }
    
    func showPhotoAlert() {
        self.tableView.reloadData()
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "相机", style: .default) { (action) in
            RMMediaPicker.systemMedia(type: .camera, editType: .none) {(image, resultType) in
                if resultType == .success {
                    if let image = image as? UIImage {
                        SVProgressHUD.show()
                        let upload = UploadImage(image, index: 0)
                        KWNetwork.publishUploadImage(uploadImages: [upload], success: { (ids) in
                            var imgResIds = ""
                            for i in 0...ids.count-1 {
                                imgResIds = imgResIds + ids[i].materialId
                                if i != ids.count-1 {
                                    imgResIds = imgResIds + ";"
                                }
                            }
                            var par : [String:Any] = [:]
                            par["image"] = imgResIds
                            KWUser.userInfo.upload(info: par) { (type) in
                                if type == .success {
                                    KWListener.poster.updateUser()
                                }else if type == .failure {
                                    KWHUD.showInfo(info: "更新失败")
                                }
                                SVProgressHUD.dismiss()
                            }
                        }) {
                            SVProgressHUD.dismiss()
                            KWHUD.showInfo(info: "上传失败")
                        }
                    }
                }
            }

        }
        let phpto = UIAlertAction(title: "相册", style: .default) { (action) in
            RMMediaPicker.systemAlbum(editType: .cut, result: {(image) in
                SVProgressHUD.show()
                let upload = UploadImage(image, index: 0)
                KWNetwork.publishUploadImage(uploadImages: [upload], success: { (ids) in
                    var imgResIds = ""
                    for i in 0...ids.count-1 {
                        imgResIds = imgResIds + ids[i].materialId
                        if i != ids.count-1 {
                            imgResIds = imgResIds + ";"
                        }
                    }
                    var par : [String:Any] = [:]
                    par["image"] = imgResIds
                    KWUser.userInfo.upload(info: par) { (type) in
                        if type == .success {
                            KWListener.poster.updateUser()
                        }else if type == .failure {
                            KWHUD.showInfo(info: "更新失败")
                        }
                        SVProgressHUD.dismiss()
                    }
                }) {
                    SVProgressHUD.dismiss()
                    KWHUD.showInfo(info: "上传失败")
                }
            })
        }
        let cancel = UIAlertAction(title: "取消", style: .cancel) { (action) in }
        alert.addAction(camera)
        alert.addAction(phpto)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
}

extension PersonalInfoTableViewController:PhotoBrowserDelegate{

    @objc func showImage(index:Int,total:Int) {
        let vc = PhotoBrowser(showByViewController: self, delegate: self)
        vc.resId = self.adList[selectedADRowWhenShowImage].imgResIds
        // 装配PageControl，提供了两种PageControl实现，若需要其它样式，可参照着自由定制
        vc.pageControlDelegate = PhotoBrowserDefaultPageControlDelegate(numberOfPages:total)
        vc.show(index: index)
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
