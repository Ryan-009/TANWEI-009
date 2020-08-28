//
//  GoodsMenuViewController.swift
//  Tanwei
//
//  Created by 吴凯耀 on 2020/8/20.
//  Copyright © 2020 吴凯耀. All rights reserved.
//

import UIKit

class GoodsMenuViewController: KWBaseViewController {

    lazy var firstLevelTableView : UITableView = {
        let tabView = UITableView(frame: CGRect(x: 0, y: 0, width: AutoW(123), height: SCREEN_HEIGHT-AutoH(70)))
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
        let tabView = UITableView(frame: CGRect(x: AutoW(123), y: 0, width: SCREEN_WIDTH-AutoW(123), height: SCREEN_HEIGHT-NavHeight))
        tabView.separatorStyle = .none
        tabView.backgroundColor = UIColor.white
        tabView.delegate = self
        tabView.dataSource = self
        tabView.register(CustomSecondLevesCell.self, forCellReuseIdentifier: "SECONDLEVELSCELLID")
        tabView.showsVerticalScrollIndicator = false
        tabView.showsHorizontalScrollIndicator = false
        return tabView
    }()
    
    var comfirmBlock : ((String)->Void)?
    var selectedFirstLevelIndex = 0
    var selectedSecondLevelIndex = -1
    var selectedSecondLevelSection = -1
    var selectedGood = ""
    
    var goodsData : [goodsModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initData()
        selfInit()
    }
    
    private func selfInit() {
        self.title = "商品分类"
        self.view.addSubview(self.firstLevelTableView)
        self.view.addSubview(self.secondLevelTableView)
        
        let cancelBtn = UIButton.init(type: .system)
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.backgroundColor = APPGrayBackGroundColor
        cancelBtn.setTitleColor(.darkGray, for: .normal)
        cancelBtn.addTarget(self, action: #selector(cancelFunc), for: .touchUpInside)
        self.view.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { (make) in
            make.top.equalTo(firstLevelTableView.snp.bottom).offset(AutoH(15))
            make.leading.equalTo(AutoW(25))
            make.width.equalTo(AutoW(110))
            make.bottom.equalTo(AutoH(-15))
        }
        
        let confirmBtn = UIButton.init(type: .system)
        confirmBtn.setTitle("确定", for: .normal)
        confirmBtn.backgroundColor = APPSubjectColor
        confirmBtn.setTitleColor(.white, for: .normal)
        confirmBtn.addTarget(self, action: #selector(confirmFunc), for: .touchUpInside)
        self.view.addSubview(confirmBtn)
        confirmBtn.snp.makeConstraints { (make) in
            make.top.equalTo(firstLevelTableView.snp.bottom).offset(AutoH(15))
            make.trailing.equalTo(AutoW(-25))
            make.leading.equalTo(cancelBtn.snp.trailing).offset(AutoW(25))
            make.bottom.equalTo(AutoH(-15))
        }
    }
    
    @objc func cancelFunc() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func confirmFunc() {
        if selectedGood.isEmpty {
            KWHUD.showInfo(info: "请选择商品类别")
            return
        }
        if UnNil(comfirmBlock) {
            comfirmBlock!(selectedGood)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func initData() {
        let path = Bundle.main.path(forResource: "goods_classification", ofType: "json")
        let url = URL(fileURLWithPath: path!)
        // 带throws的方法需要抛异常
        do {
            let data = try Data(contentsOf: url)
            let jsonData:Any = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
            var resourceData : [goodsModel] = []
            let dataArray = jsonData as! [Dictionary<String, Any>]
            for dataDic in dataArray {
                let goods = goodsModel()
                goods.classificationTitle = dataDic["classification_0"] as! String
                
                let subsArray = dataDic["classification_1_array"] as! [Dictionary<String, Any>]
                for subDic in subsArray {
                    let subGoods = subGoodsModel()
                    subGoods.subClassificationTitle = subDic["classification_1"] as! String
                    subGoods.subClassificationData = subDic["classification_2_array"] as! [String]
                    goods.classificationData.append(subGoods)
                }
                resourceData.append(goods)
            }
            self.goodsData = resourceData
            
        } catch let error as Error? {
            print("读取本地数据出现错误!",error!)
        }
    }
}

extension GoodsMenuViewController : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == self.firstLevelTableView {
            return 1
        }else if tableView == self.secondLevelTableView {
            return goodsData[selectedFirstLevelIndex].classificationData.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == secondLevelTableView {
            return 51.25
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == secondLevelTableView {
            return goodsData[selectedFirstLevelIndex].classificationData[section].subClassificationTitle
        }else{
            return ""
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.firstLevelTableView {
            return goodsData.count
        }else if tableView == self.secondLevelTableView {
            return goodsData[selectedFirstLevelIndex].classificationData[section].subClassificationData.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 51.25
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.firstLevelTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FIRSTLEVELSCELLID", for: indexPath) as! CustomFirstLevesCell
            cell.contentLabel.text = self.goodsData[indexPath.row].classificationTitle
            if indexPath.row == self.selectedFirstLevelIndex {
                cell.contentLabel.textColor = APPSubjectColor
                
            }else{
                cell.contentLabel.textColor = UIColor.darkGray
            }
            return cell
        }else if tableView == self.secondLevelTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SECONDLEVELSCELLID", for: indexPath) as! CustomSecondLevesCell
            cell.contentLabel.text = self.goodsData[selectedFirstLevelIndex].classificationData[indexPath.section].subClassificationData[indexPath.row]
            
            if indexPath.row == self.selectedSecondLevelIndex && indexPath.section == self.selectedSecondLevelSection{
                cell.contentLabel.textColor = APPSubjectColor
            }else{
                cell.contentLabel.textColor = UIColor.darkGray
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.firstLevelTableView {
            if self.selectedFirstLevelIndex != indexPath.row {
                self.selectedSecondLevelIndex = -1
                self.selectedFirstLevelIndex = indexPath.row
            }
        }else{
            self.selectedSecondLevelIndex = indexPath.row
            self.selectedSecondLevelSection = indexPath.section
            self.selectedGood = self.goodsData[selectedFirstLevelIndex].classificationData[indexPath.section].subClassificationData[indexPath.row]
        }
        self.firstLevelTableView.reloadData()
        self.secondLevelTableView.reloadData()
    }
    
}

class goodsModel : NSObject {
    var classificationTitle : String = ""
    var classificationData : [subGoodsModel] = []
}

class subGoodsModel : NSObject {
    var subClassificationTitle : String = ""
    var subClassificationData : [String] = []
}
