//
//  MySalerFansTableViewController.swift
//  Tanwei
//
//  Created by 吴凯耀 on 2020/7/30.
//  Copyright © 2020 吴凯耀. All rights reserved.
//

import UIKit

class MySalerFansTableViewController: UITableViewController {

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
        label.text = "您尚未有任何粉丝"
        label.font = UIFont.systemFont(ofSize: 14)
        label.sizeToFit()
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.register(UINib(nibName: "WholesalerTableViewCell", bundle: nil), forCellReuseIdentifier: "WHOLESALERCELLID")
        loadData()
    }

    private func loadData() {
        var par : [String:Any] = [:]
        par[KWNetworkDefine.KEY.start.rawValue] = 1
        par[KWNetworkDefine.KEY.limit.rawValue] = 10
        Application.list.allContentFactory(parameters: par, success: {_ in 
            self.checkNet_break()
        }) {
            self.checkNet_break()
        }
    }
    
    func checkNet_break(){
//        if self.discoverNearFlashByListObjects.count == 0{
            self.nil_imageView.center = CGPoint(x: SCREEN_WIDTH * 0.5, y: (SCREEN_HEIGHT) * 0.4)
            self.view.addSubview(self.nil_imageView)
            self.nil_label.center = CGPoint(x: SCREEN_WIDTH * 0.5, y: SCREEN_HEIGHT * 0.56)
            self.view.addSubview(self.nil_label)
//        }else{
//            self.nil_label.removeFromSuperview()
//            self.nil_imageView.removeFromSuperview()
//        }
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WHOLESALERCELLID", for: indexPath) as! WholesalerTableViewCell

        return cell
    }
   

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        loadData()
    }
}
