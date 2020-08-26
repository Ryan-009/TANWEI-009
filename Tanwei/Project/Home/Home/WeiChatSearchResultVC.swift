//
//  WeiChatSearchResultVC.swift
//  CustomWeiChatSearchController
//
//  Created by 范国徽 on 2018/4/8.
//  Copyright © 2018年 范国徽. All rights reserved.
//

import UIKit

class WeiChatSearchResultVC: UIViewController {

    lazy var tableView: UITableView = {

        let table = UITableView.init(frame: self.view.bounds, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        return table
    }()
    var showStyle: Bool = true
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return showStyle ? .default: .lightContent
    }
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.tableView)
        setNeedsStatusBarAppearanceUpdate()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        self.tableView.frame = self.view.bounds
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

     var sourceArray: [String] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension WeiChatSearchResultVC: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{

        return 0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        showStyle = indexPath.row % 2 == 0 ? true:false
//        setNeedsStatusBarAppearanceUpdate()
//        let navigationController = self.parent!
//        let detail = SearchDetailViewController()
//        navigationController.navigationController?.pushViewController(detail, animated: true)
    }

}

extension WeiChatSearchResultVC: UITableViewDataSource{


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return sourceArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = sourceArray[indexPath.row]
        return cell
    }
}
