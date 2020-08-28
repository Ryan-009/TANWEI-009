//
//  MyFocusSalerTableViewController.swift
//  Tanwei
//
//  Created by 吴凯耀 on 2020/7/30.
//  Copyright © 2020 吴凯耀. All rights reserved.
//

import UIKit
import MJRefresh

class MyFocusSalerTableViewController: UITableViewController {

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
        label.text = "您尚未关注任何批发商"
        label.font = UIFont.systemFont(ofSize: 14)
        label.sizeToFit()
        return label
    }()
    
    var contentlist : [FocusContent] = [] {
        didSet{
            self.tableView.reloadData()
        }
    }
    private var page = 0
    private let limit = 10
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selfInit()
        loadData()
    }

    func selfInit() {
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.register(UINib(nibName: "WholesalerTableViewCell", bundle: nil), forCellReuseIdentifier: "WHOLESALERCELLID")
        
        let header = MJRefreshNormalHeader()
        header.setRefreshingTarget(self, refreshingAction: #selector(loadData))
        self.tableView.mj_header = header
    }
    
    @objc private func loadData() {
        page = 0
        Application.list.focusGetShop(start: page, limit: limit, success: {list in
            self.contentlist = list
            self.checkNet_break()
            self.tableView.mj_header?.endRefreshing()
        }) {
            self.checkNet_break()
            self.tableView.mj_header?.endRefreshing()
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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return contentlist.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WHOLESALERCELLID", for: indexPath) as! WholesalerTableViewCell
        cell.updateData(data: self.contentlist[indexPath.row])
        cell.visitBlock = {() in
            let vc = ShopDetailViewController.init()
            vc.saleType = .wholesaler
            vc.userId = self.contentlist[indexPath.row].userId
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
