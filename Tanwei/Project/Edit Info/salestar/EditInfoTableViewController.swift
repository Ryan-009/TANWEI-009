//
//  EditInfoTableViewController.swift
//  salestar
//
//  Created by li zhou on 2019/12/15.
//  Copyright © 2019 li zhou. All rights reserved.
//

import UIKit

class EditInfoTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selfInit()
    }
    
    func selfInit() {
        self.title = "基本信息"
        self.tableView.tableFooterView  = UIView(frame: .zero)
        self.tableView.register(UINib(nibName: "EditInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "EDITINGOCELID")
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 12
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EDITINGOCELID", for: indexPath) as! EditInfoTableViewCell
        cell.setData(indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AutoW(60)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            let vc = EdittingViewController.init(nibName: "EdittingViewController", bundle: nil)
            vc.editType = .name
            vc.saveBolck = {name in
                if let cell = tableView.cellForRow(at: indexPath) as? EditInfoTableViewCell{
                    cell.contentLabel.text = name
                }
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 2 {
            let vc = EdittingViewController.init(nibName: "EdittingViewController", bundle: nil)
            vc.editType = .company
            vc.saveBolck = {company in
                if let cell = tableView.cellForRow(at: indexPath) as? EditInfoTableViewCell{
                    cell.contentLabel.text = company
                }
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 3 {
            let vc = EdittingViewController.init(nibName: "EdittingViewController", bundle: nil)
            vc.editType = .net
            vc.saveBolck = {net in
                if let cell = tableView.cellForRow(at: indexPath) as? EditInfoTableViewCell{
                    cell.contentLabel.text = net
                }
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 4 {
            let vc = CustomLevelsPickerViewController.init()
            vc.type = .city
            vc.view.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
            self.present(vc, animated: false, completion: nil)
            vc.didSelected = {city in
                if let cell = tableView.cellForRow(at: indexPath) as? EditInfoTableViewCell{
                    cell.contentLabel.text = city
                    var par : [String:Any] = [:]
                    par["location"] = city
                    KWUser.userInfo.upload(info: par) { (type) in
                        if type == .success {
//                            KWHUD.showInfo(info: "")
                            KWPrint("设置成功")
                        }
                    }
                }
            }
        }else if indexPath.row == 5 {
            let vc = CustomLevelsPickerViewController.init()
            vc.type = .profession
            vc.view.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
            self.present(vc, animated: false, completion: nil)
            vc.didSelected = {profession in
                if let cell = tableView.cellForRow(at: indexPath) as? EditInfoTableViewCell{
                    cell.contentLabel.text = profession
                    var par : [String:Any] = [:]
                    par["label"] = profession
                    KWUser.userInfo.upload(info: par) { (type) in
                        if type == .success {
//                            KWHUD.showInfo(info: "")
                            KWPrint("设置成功")
                        }
                    }
                }
            }
        }else if indexPath.row == 6 {
            let vc = EdittingViewController.init(nibName: "EdittingViewController", bundle: nil)
            vc.editType = .jobPosition
            vc.saveBolck = {net in
                if let cell = tableView.cellForRow(at: indexPath) as? EditInfoTableViewCell{
                    cell.contentLabel.text = net
                }
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 7 {
            let vc = UserInfoTextViewController.init(nibName: "UserInfoTextViewController", bundle: nil)
            vc.editType = .jobDesc
            vc.saveBolck = {net in
                if let cell = tableView.cellForRow(at: indexPath) as? EditInfoTableViewCell{
                    cell.contentLabel.text = net
                }
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 8 {
            let vc = UserInfoTextViewController.init(nibName: "UserInfoTextViewController", bundle: nil)
            vc.editType = .commanyAddr
            vc.saveBolck = {net in
                if let cell = tableView.cellForRow(at: indexPath) as? EditInfoTableViewCell{
                    cell.contentLabel.text = net
                }
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 9 {
            let vc = EdittingViewController.init(nibName: "EdittingViewController", bundle: nil)
            vc.editType = .email
            vc.saveBolck = {net in
                if let cell = tableView.cellForRow(at: indexPath) as? EditInfoTableViewCell{
                    cell.contentLabel.text = net
                }
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 10 {
            let vc = EdittingViewController.init(nibName: "EdittingViewController", bundle: nil)
            vc.editType = .wechat
            vc.saveBolck = {net in
                if let cell = tableView.cellForRow(at: indexPath) as? EditInfoTableViewCell{
                    cell.contentLabel.text = net
                }
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 11 {
            let vc = EdittingViewController.init(nibName: "EdittingViewController", bundle: nil)
            vc.editType = .phone
            vc.saveBolck = {net in
                if let cell = tableView.cellForRow(at: indexPath) as? EditInfoTableViewCell{
                    cell.contentLabel.text = net
                }
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
