//
//  PublishImageView.swift
//  salestar
//
//  Created by li zhou on 2019/11/23.
//  Copyright © 2019 li zhou. All rights reserved.
//

import UIKit
import Photos
import Kingfisher

class PublishImageView: UIView {

    lazy var collectionView : UICollectionView = {
        let flowFlayout = UICollectionViewFlowLayout()
        flowFlayout.itemSize = CGSize(width: singelCellWidth, height: singelCellWidth)
        flowFlayout.minimumLineSpacing = edge;
        flowFlayout.minimumInteritemSpacing = 0;
        let col = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowFlayout)
        col.delegate    = self
        col.dataSource  = self
        col.register(PublishPictureCell.self, forCellWithReuseIdentifier: "PUBLISHPICTURECELLID")
        col.backgroundColor = UIColor.white
        col.isScrollEnabled = false
        return col
    }()
    
    let edge = AutoW(8)
    let singelCellWidth : CGFloat = (SCREEN_WIDTH - AutoW(21)*2 - 2*AutoW(8)) / 3

    lazy var pifaTextView : UITextField = {
        let textF = UITextField.init()
        textF.textColor = .red
        textF.keyboardType = .numberPad
        textF.font = UIFont.systemFont(ofSize: 18)
        return textF
    }()
    
    lazy var yuanjiaTextView : UITextField = {
        let textF = UITextField.init()
        textF.textColor = .black
        textF.keyboardType = .numberPad
        textF.font = UIFont.systemFont(ofSize: 18)
        return textF
    }()
    
    var photoArr = [UIImage]() {
        didSet{
            self.collectionView.reloadData()
        }
    }
    var transmitReds : [String] = []
    
    public var itemCickBlock : ((Int)->Void)?
    public var itemDidMove : (([UIImage])->Void)?
    public var itemDeleteBlock : ((Int)->Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        selfInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func selfInit(){
        let label = UILabel()
        label.attributedText = GetAttributeString(orString: "* 添加图片", attString: "*", attrs: [NSAttributedString.Key.foregroundColor: UIColor.red])
        label.font = UIFont.systemFont(ofSize: 17)
        self.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.equalTo(AutoW(21))
        }
        
        self.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.leading.equalTo(AutoW(21))
            make.trailing.equalTo(AutoW(-21))
            make.top.equalTo(label.snp.bottom).offset(AutoW(21))
            make.bottom.equalTo(AutoW(-50))
        }
        
        
        let pifaLabe = UILabel()
        pifaLabe.attributedText = GetAttributeString(orString: "* 批发价:", attString: "*", attrs: [NSAttributedString.Key.foregroundColor : UIColor.red])
        self.addSubview(pifaLabe)
        pifaLabe.snp.makeConstraints { (make) in
            make.leading.equalTo(label)
            make.bottom.equalToSuperview()
            make.height.equalTo(AutoW(40))
            make.width.equalTo(75)
        }
        let biLable = UILabel()
        biLable.textColor = .red
        biLable.text = "¥"
        self.addSubview(biLable)
        biLable.snp.makeConstraints { (make) in
            make.leading.equalTo(pifaLabe.snp.trailing)
            make.centerY.equalTo(pifaLabe)
            make.width.equalTo(10)
        }
        
        self.addSubview(pifaTextView)
        pifaTextView.snp.makeConstraints { (make) in
            make.centerY.equalTo(pifaLabe)
            make.leading.equalTo(biLable.snp.trailing)
            make.trailing.equalTo(-SCREEN_WIDTH*0.5)
            make.height.equalTo(AutoW(40))
        }
        
        let yuanjiaLabel = UILabel()
        yuanjiaLabel.text = "市场价:¥"
        yuanjiaLabel.textColor = .black
        self.addSubview(yuanjiaLabel)
        yuanjiaLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(SCREEN_WIDTH*0.5)
            make.centerY.equalTo(pifaLabe)
        }
        
        self.addSubview(yuanjiaTextView)
        yuanjiaTextView.snp.makeConstraints { (make) in
            make.centerY.equalTo(yuanjiaLabel)
            make.leading.equalTo(yuanjiaLabel.snp.trailing)
            make.height.equalTo(AutoW(40))
            make.trailing.equalToSuperview()
        }
        
        let line = UIView()
        line.backgroundColor = APPSeparatorColor
        self.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.leading.equalTo(pifaLabe)
            make.bottom.equalToSuperview()
            make.height.equalTo(AutoW(0.5))
            make.trailing.equalTo(AutoW(-15))
        }
        
        let longGestureRecognizer: UILongPressGestureRecognizer = UILongPressGestureRecognizer.init(target: self, action: #selector(longPressAction(_:)))
        self.collectionView.addGestureRecognizer(longGestureRecognizer)
    }
    
    @objc func longPressAction(_ longPressGes: UILongPressGestureRecognizer) {
         switch longPressGes.state {
         case .began:
             guard let selectIndexPath = collectionView.indexPathForItem(at: longPressGes.location(in: collectionView)) else { return }
             collectionView.beginInteractiveMovementForItem(at: selectIndexPath)
         case .changed:
             collectionView.updateInteractiveMovementTargetPosition(longPressGes.location(in: collectionView))
         case .ended:
             collectionView.endInteractiveMovement()
         default:
             collectionView.cancelInteractiveMovement()
         }
    }
}

extension PublishImageView : UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return transmitReds.count > 0 ? transmitReds.count : photoArr.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PUBLISHPICTURECELLID", for: indexPath) as! PublishPictureCell
        if transmitReds.count == 0 {
            if indexPath.row == photoArr.count {
                cell.contentView.backgroundColor = UIColor.init(red: 218/255, green: 218/255, blue: 218/255, alpha: 1)
                cell.customIconImageView.image = UIImage(named: "+icon")
                cell.deleteButton.isHidden = true
            }else{
                cell.contentView.backgroundColor = UIColor.white
                cell.customIconImageView.image = photoArr[indexPath.row]
                cell.deleteButton.isHidden = false
                cell.deleteButton.tag = indexPath.row
                cell.deleteButton.addTarget(self, action: #selector(deleteFunc), for: .touchUpInside)
            }
        }else{
            cell.customIconImageView.kf.setImage(with: URL(string: smallImageUrl + self.transmitReds[indexPath.row]))
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if transmitReds.count == 0 {
            if indexPath.row == photoArr.count {
                if itemCickBlock != nil {
                    itemCickBlock!(indexPath.row)
                }
            }else{
                collectionView.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        if transmitReds.count == 0 {
            if indexPath.item == photoArr.count {return false}
            return true
        }
        return false
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if transmitReds.count == 0 {
            let tempCell = photoArr.remove(at: sourceIndexPath.item)
            photoArr.insert(tempCell, at: destinationIndexPath.item)
            if UnNil(itemDidMove) {
                itemDidMove!(photoArr)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, targetIndexPathForMoveFromItemAt originalIndexPath: IndexPath, toProposedIndexPath proposedIndexPath: IndexPath) -> IndexPath {

        if proposedIndexPath.row == photoArr.count {
            return originalIndexPath
        }
        return proposedIndexPath
    }
    
    @objc func deleteFunc(btn:UIButton) {
        if transmitReds.count == 0 {
            if UnNil(itemDeleteBlock) {
                itemDeleteBlock!(btn.tag)
            }
        }
    }
}

class PublishPictureCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = UIColor.white
        addSubview(customIconImageView)
        customIconImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.lessThanOrEqualTo(frame.height)
            make.width.equalTo(customIconImageView.snp.height)
        }
        addSubview(deleteButton)
        deleteButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(30)
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //懒加载imageView
    lazy var customIconImageView :UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        imageView.clipsToBounds = true
        imageView.sizeToFit()
        return imageView
    }()
    
    lazy var deleteButton : UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "jianhao"), for: .normal)
        return btn
    }()
}
