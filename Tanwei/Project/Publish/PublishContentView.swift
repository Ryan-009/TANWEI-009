//
//  PublishContentView.swift
//  salestar
//
//  Created by li zhou on 2019/11/23.
//  Copyright © 2019 li zhou. All rights reserved.
//
import Foundation
import UIKit
class PublishContentView : UIView,UITextViewDelegate {
    
    lazy var textView : UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.delegate = self
        
        return textView
    }()
    
    lazy var textWordLabel : UILabel = {
        let label = UILabel()
        label.text = "0/50字"
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    lazy var placerText : UILabel = {
        let label = UILabel()
        label.text = "请在这里输入"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.lightGray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        selfInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func selfInit(){
        
        let title = UILabel()
        title.attributedText = GetAttributeString(orString: "* 商品关键描述", attString: "*", attrs: [NSAttributedString.Key.foregroundColor: UIColor.red])
        title.font = UIFont.systemFont(ofSize: 17)
        self.addSubview(title)
        title.snp.makeConstraints { (make) in
            make.leading.equalTo(AutoW(21))
            make.top.equalTo(AutoW(25))
        }
        
        self.addSubview(textView)
        textView.snp.makeConstraints { (make) in
            make.leading.equalTo(AutoW(21))
            make.top.equalTo(AutoW(60))
            make.trailing.equalTo(AutoW(-21))
            make.bottom.equalTo(AutoW(-30))
        }
        
        let line = UIView()
        line.backgroundColor = APPSeparatorColor
        self.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.leading.equalTo(AutoW(21))
            make.trailing.equalTo(AutoW(-21))
            make.height.equalTo(AutoW(0.5))
            make.bottom.equalTo(AutoW(-29))
        }
        
        self.addSubview(textWordLabel)
        textWordLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(line)
            make.bottom.equalToSuperview()
        }
        
        self.addSubview(placerText)
        placerText.snp.makeConstraints { (make) in
            make.top.equalTo(textView).offset(AutoW(5))
            make.leading.equalTo(textView)
        }
    }
    
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        placerText.text = ""
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.count == 0 {
            self.placerText.text = "请在这里输入"
        }else {
            self.placerText.text = ""
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.text.count > 50 {
            return false
        }
        return true
    }
}
