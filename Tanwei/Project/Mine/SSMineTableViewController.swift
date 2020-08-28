//
//  SSSetTableViewController.swift
//  KIWI
//
//  Created by 吴凯耀 on 2019/11/16.
//  Copyright © 2019 li zhou. All rights reserved.
//

import UIKit

class SSMineTableViewController: KWBaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.backgroundColor = APPGrayBackGroundColor
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.register(SSMineHeaderTableViewCell.self, forCellReuseIdentifier: "MINDEADERVIEWCELLID")
        self.tableView.register(SSMineTableViewCell.self, forCellReuseIdentifier: "MINENORMALCELLID")
        self.navigationItem.title = "我的"
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 1
        }else if section == 1 {
            return 4
        }else if section == 2 {
            return 3
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MINDEADERVIEWCELLID", for: indexPath) as! SSMineHeaderTableViewCell
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MINENORMALCELLID", for: indexPath) as! SSMineTableViewCell
            cell.loadData(with: indexPath)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return AutoW(162)
        }else{
            if indexPath.section == 2 && indexPath.row == 0{
                return 0
            }
            return AutoW(60)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section != 0{
            return AutoW(8)
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            let vc = TanweiEditUserinfoTableViewController.init()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                if KWUser.userInfo.userType == 0 {
                    KWHUD.showInfo(info: "请先在个人信息选择您的身份")
                }else{
                    let vc = TWPayDetailTableViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
            }else if indexPath.row == 1 {
                HUD.show()
                Application.list.getAgentInfo(success: {data in
                    let vc = KWBecomeAgentViewController()
                    vc.data = data
                    vc.view.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
                    DispatchQueue.main.async {
                        self.present(vc, animated: false, completion: nil)
                    }
                    HUD.dismiss()
                }) {
                    HUD.showInfo(withStatus: "发生错误")
                }
            }
            
        }else if indexPath.section == 2 {
            if indexPath.row == 1 {
                let vc = SetViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
            if indexPath.row == 2 {
                let vc = AboutusViewController(nibName: "AboutusViewController", bundle: nil)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
}
