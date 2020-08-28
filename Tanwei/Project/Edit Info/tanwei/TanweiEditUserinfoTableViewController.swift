//
//  TanweiEditUserinfoTableViewController.swift
//  Tanwei
//
//  Created by 吴凯耀 on 2020/7/20.
//  Copyright © 2020 吴凯耀. All rights reserved.
//

import UIKit

class TanweiEditUserinfoTableViewController: KWBaseTableViewController {
    
    let footerHeight = AutoW(80)
    var eidtUserModel : EditUserModel = EditUserModel()
    
    lazy var footerView : UIView = {
        let footer = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: footerHeight))
        footer.backgroundColor = .white
        let btn = UIButton.init(type: .system)
        btn.backgroundColor = APPSubjectColor
        btn.setTitle("保存", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.addTarget(self, action: #selector(nextFunc), for: .touchUpInside)
        btn.layer.cornerRadius = AutoW(25)
        btn.clipsToBounds = true
        footer.addSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.leading.equalTo(AutoW(50))
            make.trailing.equalTo(AutoW(-50))
            make.height.equalTo(footerHeight-AutoW(30))
        }
        return footer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selfInit()
    }
    
    private func selfInit() {
        self.tableView.backgroundColor = .white
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.register(UINib(nibName: "TWInfoTitleTableViewCell", bundle: nil), forCellReuseIdentifier: "TWINFOTITLECELLID")
        self.tableView.register(UINib(nibName: "TWSelectIdentityTableViewCell", bundle: nil), forCellReuseIdentifier: "SELECTIDENTITYCELLID")
        self.tableView.register(UINib(nibName: "TWImageContentTableViewCell", bundle: nil), forCellReuseIdentifier: "IMAGECONTENTCELLID")
        self.tableView.register(UINib(nibName: "TWNormalTableViewCell", bundle: nil), forCellReuseIdentifier: "TWNORMALCELLID")
        self.title = "个人信息"
        self.tableView.tableFooterView = footerView
        
        self.eidtUserModel.userName     = KWUser.userInfo.userName
        self.eidtUserModel.imageHead    = KWUser.userInfo.imageHead
        self.eidtUserModel.addr         = KWUser.userInfo.addr
        self.eidtUserModel.contactPhone = KWUser.userInfo.contactPhone
        self.eidtUserModel.wechatId     = "\(KWUser.userInfo.wechatId)"
        self.eidtUserModel.userType     = KWUser.userInfo.userType
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 7
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "TWINFOTITLECELLID") as! TWInfoTitleTableViewCell
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "SELECTIDENTITYCELLID") as! TWSelectIdentityTableViewCell
                cell.updateData(data: self.eidtUserModel)
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "TWNORMALCELLID") as! TWNormalTableViewCell
                cell.update(indexpath: indexPath)
                cell.contentLabel.text = self.eidtUserModel.userName
                return cell
            case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: "IMAGECONTENTCELLID") as! TWImageContentTableViewCell
                cell.imageContenView.kf.setImage(with: URL(string: smallImageUrl+KWUser.userInfo.imageHead), placeholder: PlaceHolderForUserHeader, options: nil, progressBlock: nil) { (image, error, type, url) in}
                return cell
            case 4:
                let cell = tableView.dequeueReusableCell(withIdentifier: "TWNORMALCELLID") as! TWNormalTableViewCell
                cell.update(indexpath: indexPath)
                cell.contentLabel.text = KWUser.userInfo.addr
                return cell
            case 5:
                let cell = tableView.dequeueReusableCell(withIdentifier: "TWNORMALCELLID") as! TWNormalTableViewCell
                cell.update(indexpath: indexPath)
                cell.contentLabel.text = KWUser.userInfo.contactPhone
                return cell
            case 6:
                let cell = tableView.dequeueReusableCell(withIdentifier: "TWNORMALCELLID") as! TWNormalTableViewCell
                cell.update(indexpath: indexPath)
                cell.contentLabel.text = "\(KWUser.userInfo.wechatId)"
                return cell
            default:
                return UITableViewCell()
        }
    }
   

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 || indexPath.row == 3{
            return AutoW(85)
        }
        return AutoW(55)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 2 {
            self.goSetWechat(indexPath: indexPath)
        }
        if indexPath.row == 3 {
            showPhotoAlert()
        }
        if indexPath.row == 4 {
            self.citySelectFunc()
        }
        if indexPath.row == 5 {
            self.goSetWechat(indexPath: indexPath)
        }
        if indexPath.row == 6 {
            self.goSetWechat(indexPath: indexPath)
        }
    }
}

//MARK:- wechat
extension TanweiEditUserinfoTableViewController {
    fileprivate func goSetWechat(indexPath:IndexPath) {
        let vc = EdittingViewController.init(nibName: "EdittingViewController", bundle: nil)
        if indexPath.row == 2 {
            vc.editType = .name
        }else if indexPath.row == 5 {
            vc.editType = .phone
        }else if indexPath.row == 6{
            vc.editType = .wechat
        }
        vc.saveBolck = {net in
            if let cell = self.tableView.cellForRow(at: indexPath) as? TWNormalTableViewCell{
                cell.contentLabel.text = net
                if indexPath.row == 2 {
                    self.eidtUserModel.userName = net
                }else if indexPath.row == 5 {
                    self.eidtUserModel.contactPhone = net
                }else if indexPath.row == 6 {
                    self.eidtUserModel.wechatId = net
                }
            }
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK:- deliver
extension TanweiEditUserinfoTableViewController{
    fileprivate func citySelectFunc() {
        let vc = CustomLevelsPickerViewController.init()
        vc.view.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        self.present(vc, animated: false, completion: nil)
        vc.didSelected = {city in
            if let cell = self.tableView.cellForRow(at: IndexPath(item: 4, section: 0)) as? TWNormalTableViewCell {
                cell.contentLabel.text = city
                self.eidtUserModel.addr = city
            }
        }
    }
}

//MARK:- image
extension TanweiEditUserinfoTableViewController {
    fileprivate func showPhotoAlert() {
        self.tableView.reloadData()
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "相机", style: .default) { (action) in
            RMMediaPicker.systemMedia(type: .camera, editType: .none) {(image, resultType) in
                if resultType == .success {
                    if let image = image as? UIImage {
                        if let cell = self.tableView.cellForRow(at: IndexPath(item: 3, section: 0)) as? TWImageContentTableViewCell {
                            cell.imageContenView.image = image
                            self.uploadImage(image: image)
                        }
                    }
                }
            }

        }
        let phpto = UIAlertAction(title: "相册", style: .default) { (action) in
            RMMediaPicker.systemAlbum(editType: .cut, result: {(image) in
                if let cell = self.tableView.cellForRow(at: IndexPath(item: 3, section: 0)) as? TWImageContentTableViewCell {
                    cell.imageContenView.image = image
                    self.uploadImage(image: image)
                }
            })
        }
        let cancel = UIAlertAction(title: "取消", style: .cancel) { (action) in }
        alert.addAction(camera)
        alert.addAction(phpto)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func uploadImage(image:UIImage) {
        HUD.show()
        let uploadImage = UploadImage.init(image, index: 0)
        let uploads = [uploadImage]
        KWNetwork.publishUploadImage(uploadImages: uploads, success: { (ids) in
            var imgResIds = ""
            for i in 0...ids.count-1 {
                imgResIds = imgResIds + ids[i].materialId
                if i != ids.count-1 {
                    imgResIds = imgResIds + ";"
                }
            }
            KWHUD.showInfo(info: "店铺头像设置成功")
            self.eidtUserModel.imageHead = imgResIds
        }) {
            HUD.dismiss()
            HUD.showInfo(withStatus: "上传图片失败")
        }
    }
}

//MARK:- 下一步
extension TanweiEditUserinfoTableViewController {
    
    //卖家:1 批发商:2
    @objc fileprivate func nextFunc() {
        if KWUser.userInfo.userType == 0 {
            Application.opration.setIdentity(userType: self.eidtUserModel.userType, success: {
                var parameter : [String:Any] = [:]
                parameter[KWNetworkDefine.KEY.userName.rawValue] = self.eidtUserModel.userName
                parameter[KWNetworkDefine.KEY.imageHead.rawValue] = self.eidtUserModel.imageHead
                parameter[KWNetworkDefine.KEY.addr.rawValue] = self.eidtUserModel.addr
                parameter[KWNetworkDefine.KEY.contactPhone.rawValue] = self.eidtUserModel.contactPhone
                parameter[KWNetworkDefine.KEY.wechatId.rawValue] = self.eidtUserModel.wechatId
                KWUser.userInfo.upload(info: parameter) { (type) in
                    if type == .success {
                        KWHUD.showInfo(info: "保存成功")
                        KWUser.userInfo.update()
                    }else{
                        KWHUD.showInfo(info: "更新个人信息发生错误")
                    }
                }
            }) {
                KWHUD.showInfo(info: "设置身份发生错误")
            }
        }else{
            var parameter : [String:Any] = [:]
            parameter[KWNetworkDefine.KEY.userName.rawValue] = self.eidtUserModel.userName
            parameter[KWNetworkDefine.KEY.imageHead.rawValue] = self.eidtUserModel.imageHead
            parameter[KWNetworkDefine.KEY.addr.rawValue] = self.eidtUserModel.addr
            parameter[KWNetworkDefine.KEY.contactPhone.rawValue] = self.eidtUserModel.contactPhone
            parameter[KWNetworkDefine.KEY.wechatId.rawValue] = self.eidtUserModel.wechatId
            KWUser.userInfo.upload(info: parameter) { (type) in
                if type == .success {
                    KWHUD.showInfo(info: "保存成功")
                    KWUser.userInfo.update()
                }else{
                    KWHUD.showInfo(info: "更新个人信息发生错误")
                }
            }
        }
        
    }
}

class EditUserModel: NSObject {
    var userType : Int = 1
    var userName : String = ""
    var imageHead : String = ""
    var addr : String = ""
    var contactPhone : String = ""
    var wechatId : String = ""
}
