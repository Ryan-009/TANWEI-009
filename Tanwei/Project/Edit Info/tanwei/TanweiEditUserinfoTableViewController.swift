//
//  TanweiEditUserinfoTableViewController.swift
//  Tanwei
//
//  Created by 吴凯耀 on 2020/7/20.
//  Copyright © 2020 吴凯耀. All rights reserved.
//

import UIKit

class TanweiEditUserinfoTableViewController: KWBaseTableViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.register(UINib(nibName: "TWInfoTitleTableViewCell", bundle: nil), forCellReuseIdentifier: "TWINFOTITLECELLID")
        self.tableView.register(UINib(nibName: "TWSelectIdentityTableViewCell", bundle: nil), forCellReuseIdentifier: "SELECTIDENTITYCELLID")
        self.tableView.register(UINib(nibName: "TWImageContentTableViewCell", bundle: nil), forCellReuseIdentifier: "IMAGECONTENTCELLID")
        self.tableView.register(UINib(nibName: "TWNormalTableViewCell", bundle: nil), forCellReuseIdentifier: "TWNORMALCELLID")
        self.title = "个人信息"
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
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "TWNORMALCELLID") as! TWNormalTableViewCell
                cell.update(indexpath: indexPath)
                return cell
            case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: "IMAGECONTENTCELLID") as! TWImageContentTableViewCell
                return cell
            case 4:
                let cell = tableView.dequeueReusableCell(withIdentifier: "TWNORMALCELLID") as! TWNormalTableViewCell
                cell.update(indexpath: indexPath)
                return cell
            case 5:
                let cell = tableView.dequeueReusableCell(withIdentifier: "TWNORMALCELLID") as! TWNormalTableViewCell
                cell.update(indexpath: indexPath)
                return cell
            case 6:
                let cell = tableView.dequeueReusableCell(withIdentifier: "TWNORMALCELLID") as! TWNormalTableViewCell
                cell.update(indexpath: indexPath)
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
        if indexPath.row == 5 {
            vc.editType = .phone
        }else if indexPath.row == 6{
            vc.editType = .wechat
        }
        vc.saveBolck = {net in
            if let cell = self.tableView.cellForRow(at: indexPath) as? TWNormalTableViewCell{
                cell.contentLabel.text = net
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
                        }
                    }
                }
            }

        }
        let phpto = UIAlertAction(title: "相册", style: .default) { (action) in
            RMMediaPicker.systemAlbum(editType: .cut, result: {(image) in
                if let cell = self.tableView.cellForRow(at: IndexPath(item: 3, section: 0)) as? TWImageContentTableViewCell {
                    cell.imageContenView.image = image
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
