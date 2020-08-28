//
//  TWPayDetailTableViewController.swift
//  Tanwei
//
//  Created by 吴凯耀 on 2020/7/25.
//  Copyright © 2020 吴凯耀. All rights reserved.
//

import UIKit

class TWPayDetailTableViewController: KWBaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    lazy var bottomView : TWPaybottomView = {
        let view = TWPaybottomView.init(frame: CGRect(x: 0, y: SCREEN_HEIGHT-AutoW(80), width: SCREEN_WIDTH, height: AutoW(80)))
        return view
    }()
    
    lazy var tableView : UITableView = {
        let tab = UITableView.init()
        tab.delegate = self
        tab.dataSource = self
        tab.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: screenHeight-AutoW(80))
        tab.tableFooterView = UIView(frame: .zero)
        tab.separatorStyle = .none
        return tab
    }()
    
    var priceList : [PriceModel] = [] {
        didSet{
            self.bottomView.updateData(data: priceList[selectedIndex])
            self.tableView.reloadData()
        }
    }
    
    fileprivate var selectedIndex = 1 {
        didSet{
            self.bottomView.updateData(data: self.priceList[selectedIndex])
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.tableView)
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.register(UINib(nibName: "TWPayHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "PAYHEADERCELLID")
        self.tableView.register(UINib(nibName: "TWPaySelectModeTableViewCell", bundle: nil), forCellReuseIdentifier: "PAYSELECTMODECELLID")
        self.tableView.register(UINib(nibName: "TWPayRightInstructionTableViewCell", bundle: nil), forCellReuseIdentifier: "PAYRIGHTINSCELLID")
        
        if KWUser.userInfo.userType == 1 {
            //卖家
            priceList = [PriceModel.init(newPrice: 48, oldPrice: 188),PriceModel.init(newPrice: 168, oldPrice: 488),PriceModel.init(newPrice: 268, oldPrice: 788)]
        }else if KWUser.userInfo.userType == 2 {
            //批发商
            priceList = [PriceModel.init(newPrice: 88, oldPrice: 188),PriceModel.init(newPrice: 288, oldPrice: 488),PriceModel.init(newPrice: 488, oldPrice: 788)]
        }
        
        self.bottomView.payButton.addTarget(self, action: #selector(topayFunc), for: .touchUpInside)
    }
    
    @objc func topayFunc() {
        let vc = TWWechatPayViewController.init(nibName: "TWWechatPayViewController", bundle: nil)
        vc.data = priceList[selectedIndex]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        self.navigationController?.view.addSubview(bottomView)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        bottomView.removeFromSuperview()
        self.navigationController?.navigationBar.shadowImage = nil
    }
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PAYHEADERCELLID", for: indexPath) as! TWPayHeaderTableViewCell
            return cell
        }
        
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PAYSELECTMODECELLID", for: indexPath) as! TWPaySelectModeTableViewCell
            cell.updateData(datas: priceList)
            cell.selectedPriceIndex = { index in
                self.selectedIndex = index
            }
            return cell
        }
        
        if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PAYRIGHTINSCELLID", for: indexPath) as! TWPayRightInstructionTableViewCell
            
            return cell
        }

        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return AutoW(105)
        }
        if indexPath.section == 1 {
            return AutoW(200)
        }
        if indexPath.section == 2 {
            return 340
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section != 0 {
            return 10
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
}

struct PriceModel {
    var newPrice : Int = 0
    var oldPrice : Int = 0
}
