//
//  MoneyPicker.swift
//  salestar
//
//  Created by li zhou on 2019/11/29.
//  Copyright © 2019 li zhou. All rights reserved.
//

import Foundation
import UIKit

class moneyPikerView: UIView{
    
    var _kyPikerView : UIPickerView?
    let leftDatas  : [String] = ["100","1000","5000","10000","面谈"]
    let rightDatas : [String] = ["1000","5000","10000","10000以上"]
    var leftSelectString      = "100"
    var rightSelectString     = "1000"
    enum SelectType : Int {
        case cancel  = 0
        case comfirm = 1
    }
    var clickBlock : ((SelectType,String,String)->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPiker()
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupPiker() {
        let width = self.frame.size.width
        let height = self.frame.size.height
        
        //顶部条
        let topView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 40))
        topView.backgroundColor = UIColor.white
        self.addSubview(topView)
        
        let grayView = UIView(frame: CGRect(x: 0, y: 39.5, width: width, height: 0.5))
        grayView.backgroundColor = UIColor(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha:1)
        topView.addSubview(grayView)
        
        //cancel
        let cancelBtn = UIButton(type: .system)
        cancelBtn.frame = CGRect(x: 15, y: 5, width: 40, height: 30)
        cancelBtn.tag = 101
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(UIColor.gray, for: .normal)//#8e8e8e
        cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        cancelBtn.addTarget(self, action: #selector(click), for: .touchUpInside)
        topView.addSubview(cancelBtn)
        //confirm
        let confirmBtn = UIButton(type: .system)
        confirmBtn.frame = CGRect(x: width-55, y: 5, width: 40, height: 30)
        confirmBtn.tag = 102
        confirmBtn.setTitle("确定", for: .normal)
        confirmBtn.setTitleColor(UIColor.gray, for: .normal)//#2c2c2c
        confirmBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        confirmBtn.addTarget(self, action: #selector(click), for: .touchUpInside)
        topView.addSubview(confirmBtn)
        
        _kyPikerView = UIPickerView(frame: CGRect(x: 0, y: 40, width: width, height: height-40))
        _kyPikerView?.delegate = self
        _kyPikerView?.dataSource = self
        self.addSubview(_kyPikerView!)
    }
    
    func initData() {
        
    }
    
    @objc func click(sender:UIButton) {
        if UnNil(clickBlock) {
            if sender.tag == 102{
                self.clickBlock!(.comfirm,leftSelectString,rightSelectString)
            }else{
                self.clickBlock!(.cancel,"","")
            }
        }
    }
}

extension moneyPikerView:UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return 5
        }else if component == 1 {
            return 4
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {

       let label = UILabel.init()
       label.textAlignment = .center
       label.font = UIFont.systemFont(ofSize: 15)
       label.tag = 100 + row
       
       switch component {
       case 0:
           label.frame = CGRect(x: 20, y: 0, width: UIScreen.main.bounds.size.width/3, height: 30)
           label.text = leftDatas[row]
           break
       case 1:
           label.frame = CGRect(x: 20 + UIScreen.main.bounds.size.width/3, y: 0, width: UIScreen.main.bounds.size.width/5, height: 30)
           label.text = rightDatas[row]
           break
       
       default:
           break
       }
       return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            leftSelectString = leftDatas[row]
        }
        if component == 1 {
            rightSelectString = rightDatas[row]
        }
    }
}
