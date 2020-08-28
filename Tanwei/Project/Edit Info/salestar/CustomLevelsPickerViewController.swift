//
//  CustomLevelsPickerViewController.swift
//  salestar
//
//  Created by li zhou on 2019/12/16.
//  Copyright © 2019 li zhou. All rights reserved.
//

import UIKit
import SwiftyJSON
enum customType : Int {
    case profession = 0
    case city = 1
    case goods = 2
}

class CustomLevelsPickerViewController: UIViewController {
    
    var picker : CustomLevesPickerView?
    
    var didSelected : ((String)->Void)?
    
    var type : customType = .city
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .custom
        selfInit()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.25) {
            self.picker!.frame.origin.y = SCREEN_HEIGHT-462.6
        }
    }
    
    func selfInit() {
        self.picker = CustomLevesPickerView.init(frame: CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: 462.6))
        picker?.type = self.type
        self.view.addSubview(picker!)
        picker!.cancelBlock = {() in
            UIView.animate(withDuration: 0.25, animations: {
                self.picker!.frame.origin.y = SCREEN_HEIGHT
            }) { (finish) in
                self.dismiss(animated: false, completion: nil)
            }
        }
        
        picker!.comfirmBlock = {city in
            if UnNil(self.didSelected) {
                self.didSelected!(city)
            }
            UIView.animate(withDuration: 0.25, animations: {
                self.picker!.frame.origin.y = SCREEN_HEIGHT
            }) { (finish) in
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
}

class CustomLevesPickerView: UIView ,UITableViewDelegate,UITableViewDataSource{
    
    lazy var firstLevelTableView : UITableView = {
        let tabView = UITableView(frame: CGRect(x: 0, y: 52.6, width: AutoW(123), height: 410))
        tabView.separatorStyle = .none
        tabView.backgroundColor = ColorFromHexString("#F8F8F8")
        tabView.delegate = self
        tabView.dataSource = self
        tabView.register(CustomFirstLevesCell.self, forCellReuseIdentifier: "FIRSTLEVELSCELLID")
        tabView.showsVerticalScrollIndicator = false
        tabView.showsHorizontalScrollIndicator = false
        return tabView
    }()
    
    lazy var secondLevelTableView : UITableView = {
        let tabView = UITableView(frame: CGRect(x: AutoW(123), y: 52.6, width: SCREEN_WIDTH-AutoW(123), height: 410))
        tabView.separatorStyle = .none
        tabView.backgroundColor = UIColor.white
        tabView.delegate = self
        tabView.dataSource = self
        tabView.register(CustomSecondLevesCell.self, forCellReuseIdentifier: "SECONDLEVELSCELLID")
        tabView.showsVerticalScrollIndicator = false
        tabView.showsHorizontalScrollIndicator = false
        return tabView
    }()
    fileprivate var type : customType = .city {
        didSet{
            initData()
        }
    }
    var cancelBlock : (()->Void)?
    var comfirmBlock : ((String)->Void)?
    
    var selectedProvinceIndex = -1
    var selectedCityIndex = -1
    
    var provinces : [Any] = [] {
        didSet{
            self.firstLevelTableView.reloadData()
        }
    }
    var professions : [[String:Any]] = [] {
        didSet{
            self.firstLevelTableView.reloadData()
        }
    }
    var citys : [String] = [] {
        didSet{
            self.secondLevelTableView.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        selfInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func selfInit() {
        self.backgroundColor = UIColor.white
        let cancelBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 70, height: 52))
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        cancelBtn.setTitleColor(UIColor.lightGray, for: .normal)
        cancelBtn.addTarget(self, action: #selector(cancelFunc), for: .touchUpInside)
        self.addSubview(cancelBtn)
        let confirmBtn = UIButton(frame: CGRect(x: SCREEN_WIDTH-70, y: 0, width: 70, height: 52))
        confirmBtn.setTitle("确定", for: .normal)
        confirmBtn.addTarget(self, action: #selector(confirmFunc), for: .touchUpInside)
        confirmBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        confirmBtn.setTitleColor(APPSubjectColor, for: .normal)
        self.addSubview(confirmBtn)
        let line = UIView(frame: CGRect(x: 0, y: 52, width: SCREEN_WIDTH, height: 0.6))
        line.backgroundColor = UIColor.lightGray
        self.addSubview(line)
        self.addSubview(self.firstLevelTableView)
        self.addSubview(self.secondLevelTableView)
    }
    
    func initData() {
        if self.type == .city {
            if let array = NSArray(contentsOfFile: Bundle.main.path(forResource: "ProvincesAndCities", ofType: "plist")!) {
                self.provinces = array as! [Any]
            }
        }else if self.type == .profession{
            let path = Bundle.main.path(forResource: "industry_division", ofType: "json")
            let url = URL(fileURLWithPath: path!)
            // 带throws的方法需要抛异常
            do {
                let data = try Data(contentsOf: url)
                let jsonData:Any = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
                self.professions = jsonData as! [Dictionary]
            } catch let error as Error? {
                print("读取本地数据出现错误!",error!)
            }
        }else if self.type == .goods {
            let path = Bundle.main.path(forResource: "goods_classification", ofType: "json")
            let url = URL(fileURLWithPath: path!)
            // 带throws的方法需要抛异常
            do {
                let data = try Data(contentsOf: url)
                let jsonData:Any = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
                self.professions = jsonData as! [Dictionary]
            } catch let error as Error? {
                print("读取本地数据出现错误!",error!)
            }
        }
    }
    
    func getPName(row:Int) -> String{
        if self.type == .city {
            if let dic = provinces[row] as? NSDictionary {
                return dic["State"] as! String
            }
        }else if self.type == .profession{
            if let dic  = professions[row] as? [String:Any] {
                return KWParse.string(dic, key: "label_0")
            }
        }else if self.type == .goods{
            if let dic  = professions[row] as? [String:Any] {
                return KWParse.string(dic, key: "label_0")
            }
        }
        return ""
    }
    
    func getRows(row:Int) -> [String] {
        if self.type == .city {
            guard let dic = provinces[row] as? NSDictionary else {
                return []
            }
            
            guard let citys = dic["Cities"] as? Array<Any> else {
                return []
            }
            
            var results : [String] = []
            
            for city in citys {
                if let c = city as? NSDictionary {
                    results.append(c["city"] as! String)
                }
            }

            return results
        }else{
            if let arr = professions[row]["label_1_set"] as? [String] {
                return arr
            }
        }
        return []
    }
    
    @objc func cancelFunc(){
        if UnNil(self.cancelBlock) {
            self.cancelBlock!()
        }
    }
    
    @objc func confirmFunc(){
        if UnNil(self.comfirmBlock) {
            if self.selectedCityIndex < 0 {
                KWHUD.showInfo(info: "请选择所属城市")
                return
            }
            self.comfirmBlock!(self.citys[selectedCityIndex])
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.firstLevelTableView {
            return self.type == .city ?  provinces.count : professions.count
        }else if tableView == self.secondLevelTableView {
            return citys.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 51.25
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.firstLevelTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FIRSTLEVELSCELLID", for: indexPath) as! CustomFirstLevesCell
            cell.contentLabel.text = getPName(row: indexPath.row)
            if indexPath.row == self.selectedProvinceIndex {
                cell.contentLabel.textColor = APPSubjectColor
            }else{
                cell.contentLabel.textColor = UIColor.darkGray
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SECONDLEVELSCELLID", for: indexPath) as! CustomSecondLevesCell
            cell.contentLabel.text = citys[indexPath.row]
            if indexPath.row == self.selectedCityIndex {
                cell.contentLabel.textColor = APPSubjectColor
            }else{
                cell.contentLabel.textColor = UIColor.darkGray
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = tableView.cellForRow(at: indexPath)
//        if cell?.editingStyle == .insert {
//
//        }
        if tableView == self.firstLevelTableView {
            if self.selectedProvinceIndex != indexPath.row {
                self.selectedCityIndex = -1
                self.selectedProvinceIndex = indexPath.row
                self.citys = self.getRows(row: indexPath.row)
            }
        }else{
            self.selectedCityIndex = indexPath.row
        }
        tableView.reloadData()
    }
}

class CustomFirstLevesCell : UITableViewCell {
    
    lazy var contentLabel : UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.darkGray
        lab.text = "text"
        lab.font = UIFont.systemFont(ofSize: 16)
        return lab
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selfInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func selfInit() {
        self.contentView.backgroundColor = ColorFromHexString("#F8F8F8")
        self.contentLabel.textAlignment = .center
        self.contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
}

class CustomSecondLevesCell: CustomFirstLevesCell {
    override func selfInit() {
        self.contentView.backgroundColor = UIColor.white
        self.contentLabel.textAlignment = .left
        self.contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalTo(AutoW(30.5))
        }
    }
}
