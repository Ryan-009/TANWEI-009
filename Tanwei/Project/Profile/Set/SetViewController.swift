//
//  SetViewController.swift
//  salestar
//
//  Created by 吴凯耀 on 2020/4/6.
//  Copyright © 2020 li zhou. All rights reserved.
//

import UIKit

class SetViewController: KWBaseViewController,UITableViewDelegate,UITableViewDataSource {
    

    lazy var tableView : UITableView = {
        let tab = UITableView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-TabHeight))
        tab.delegate = self
        tab.dataSource = self
        tab.tableFooterView = UIView(frame: .zero)
        tab.register(UINib(nibName: "EditInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "SETINGOCELID")
        return tab
    }()
    
    lazy var footerView : UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0.5, width: screenWidth, height: AutoW(130)))
        view.backgroundColor = UIColor.white
        let logoutButton = UIButton(type: .system)
        logoutButton.setTitle("退出登录", for: .normal)
        logoutButton.setTitleColor(UIColor.black, for: .normal)
        logoutButton.layer.cornerRadius = AutoW(8)
        logoutButton.clipsToBounds = true
        logoutButton.backgroundColor = ColorFromHexString("#EDEEF4")
        logoutButton.addTarget(self, action: #selector(loginOutClick), for: .touchUpInside)
        view.addSubview(logoutButton)
        logoutButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.leading.equalTo(15)
            make.height.equalTo(AutoW(55))
            make.top.equalTo(AutoW(72))
        }
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "设置"
        self.tableView.tableFooterView  = footerView
        self.view.addSubview(tableView)
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SETINGOCELID", for: indexPath) as! EditInfoTableViewCell
        cell.setViewData(indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AutoW(60)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = APPGrayBackGroundColor
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 1 {
            Application.cache.clear {
                if let cell = tableView.cellForRow(at: indexPath) as? EditInfoTableViewCell {
                    cell.titleLabel.text = "0.00M"
                    KWHUD.showInfo(info: "清理完成")
                }
            }
        }
    }
    
    @objc func loginOutClick() {
        let alertVC = UIAlertController(title:"提示",message:"确认退出销售之星?",preferredStyle: UIAlertController.Style.alert )
        let alertAction = UIAlertAction(title: "取消",style: UIAlertAction.Style.default,handler: { action in
            self.tableView.reloadData()
        })
        let alertAction2 = UIAlertAction(title: "确认",style: UIAlertAction.Style.default,handler: { action in
            KWSystem.logout()
            ApplicationWindow.rootViewController = KWMainViewController()
        })
        alertVC.addAction(alertAction)
        alertVC.addAction(alertAction2)
        self.present(alertVC, animated: true, completion: nil)
    }
}
