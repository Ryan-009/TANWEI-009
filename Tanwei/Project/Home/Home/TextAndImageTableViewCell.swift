//
//  TextAndImageTableViewCell.swift
//  salestar
//
//  Created by li zhou on 2019/12/6.
//  Copyright © 2019 li zhou. All rights reserved.
//

import UIKit
import YYText
import Kingfisher
import SVProgressHUD
let SingelADImageCellWidth : CGFloat = (SCREEN_WIDTH - AutoW(15)*2 - 2*AutoW(8)) / 3
let SHOWORHIDEBUTTONHEIGHT : CGFloat = 20
let ContentNumberOfLines : Int = 5
let NormalTextMaxHeight : CGFloat = 90//ContentNumberOfLines时内容高度

class TextAndImageTableViewCell: UITableViewCell {

    lazy var iconView : UIImageView = {
        let icon = UIImageView()
        icon.layer.cornerRadius = AutoW(5)
        icon.clipsToBounds = true
        icon.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(headerClickFunc))
        icon.addGestureRecognizer(tap)
        return icon
    }()
    
    lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.black
        return label
    }()
    
    lazy var jobPositionAndComAddr : UILabel = {
        let label = UILabel()
        label.text = "粉丝数:3000"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.lightGray
        return label
    }()
    
    lazy var timeLabel : UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.lightGray
        return label
    }()
    
    lazy var contactButton : UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = UIColor.white
        btn.setTitle("联系", for: .normal)
        btn.layer.cornerRadius = AutoW(15)
        btn.layer.borderColor = APPSubjectColor.cgColor
        btn.layer.borderWidth = AutoW(0.5)
        btn.titleLabel?.textColor = APPSubjectColor
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(contactFunc), for: .touchUpInside)
        return btn
    }()
    
    lazy var jubaoButton : UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = UIColor.white
        btn.setTitle("举报", for: .normal)
        btn.layer.cornerRadius = AutoW(10)
        btn.layer.borderColor = UIColor.lightGray.cgColor
        btn.layer.borderWidth = AutoW(0.5)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        btn.setTitleColor(.lightGray, for: .normal)
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(jubaoClickFunc), for: .touchUpInside)
        return btn
    }()
    
    lazy var contentTextLabel : UILabel = {
        let label = UILabel(frame: CGRect(x: AutoW(15), y: AutoW(58), width: SCREEN_WIDTH-AutoW(30), height: 30))
        label.numberOfLines = 0
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 15)
        label.sizeToFit()
        return label
    }()
    
    lazy var collectionView : UICollectionView = {
        let flowFlayout = UICollectionViewFlowLayout()
        flowFlayout.itemSize = CGSize(width: SingelADImageCellWidth, height: SingelADImageCellWidth)
        flowFlayout.minimumLineSpacing = edge;
        flowFlayout.minimumInteritemSpacing = 0;
        let col = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowFlayout)
        col.delegate    = self
        col.dataSource  = self
        col.register(ADPictureCell.self, forCellWithReuseIdentifier: "PUBLISHPICTURECELLID")
        col.backgroundColor = UIColor.white
        col.isScrollEnabled = false
        return col
    }()
    
    ///批发价
    lazy var newPriceLabel : UILabel = {
        let lab = UILabel()
        lab.textColor = ColorFromHexString("#F54C23")
        lab.font = UIFont.systemFont(ofSize: 16)
        lab.text = "批发价: ¥29.9"
        lab.sizeToFit()
        return lab
    }()
    
    ///原价
    lazy var oldPriceLabel : UILabel = {
        let lab = UILabel()
        lab.textColor = .black
        lab.font = UIFont.systemFont(ofSize: 12)
        lab.text = "39.9"
        let line = UIView.init()
        line.backgroundColor = .gray
        lab.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(20)
            make.height.equalTo(1)
        }
        return lab
    }()
    
    
    let edge = AutoW(8)
    lazy var allOrHideTextButton : UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitleColor(APPSubjectColor, for: .normal)
        btn.addTarget(self, action: #selector(showOrHideFunc), for: .touchUpInside)
        return btn
    }()
    
    lazy var shareButton : UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "tanwei_share_products_icon"), for: .normal)
        btn.addTarget(self, action: #selector(copyNumberFunc), for: .touchUpInside)
        return btn
    }()
    
    lazy var copyNumberButton : UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitleColor(APPSubjectColor, for: .normal)
        btn.setTitle("复制商品货号", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.addTarget(self, action: #selector(copyNumberFunc), for: .touchUpInside)
        return btn
    }()
    
    lazy var zfButton : UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitleColor(.white, for: .normal)
        btn.setTitle("一键转发", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.backgroundColor = APPSubjectColor
        btn.layer.cornerRadius = AutoW(15)
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(copyNumberFunc), for: .touchUpInside)
        return btn
    }()
    
    lazy var likeButton : UIButton = {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 0, y: 0, width: AutoW(50), height: AutoW(50))
        btn.setTitleColor(.gray, for: .normal)
        btn.setTitleColor(APPSubjectColor, for: .selected)
        btn.setTitle("关注", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.setImage(UIImage(named: "tanwei_tab_following_icon_u"), for: .normal)
        btn.setImage(UIImage(named: "tanwei_tab_following_icon_s"), for: .selected)
        btn.layoutButton(style: .Top, imageTitleSpace: 9)
        btn.addTarget(self, action: #selector(likeClick), for: .touchUpInside)
        return btn
    }()
    
    lazy var pifaLogo : UIImageView = {
        let imageView = UIImageView(image: UIImage(named:"tanwei_saler_vip_medal_icon"))
        
        
        return imageView
    }()
    
    
    public var didSelectImageblock:((UIImageView,Int,Int)->Void)?
    public var didSelectLinkblock:((String)->Void)?
    var data : contentDtoModel?
    var updateBlock:(()->Void)?
    var headerClick:(()->Void)?
    var jubaoClick:(()->Void)?
    var imgResIds : [String] = [] {
        didSet{
            self.collectionView.reloadData()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        selfInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func selfInit() {
        self.contentView.addSubview(iconView)
        iconView.snp.makeConstraints { (make) in
            make.leading.equalTo(AutoW(15))
            make.top.equalTo(AutoW(15))
            make.width.height.equalTo(AutoW(36))
        }
        
        self.contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(iconView)
            make.leading.equalTo(iconView.snp.trailing).offset(AutoW(10))
        }
        
        self.contentView.addSubview(jobPositionAndComAddr)
        jobPositionAndComAddr.snp.makeConstraints { (make) in
            make.bottom.equalTo(iconView)
            make.leading.equalTo(iconView.snp.trailing).offset(AutoW(10))
            make.trailing.equalTo(AutoW(-90))
        }
        
        self.contentView.addSubview(contactButton)
        contactButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(iconView)
            make.height.equalTo(AutoW(30))
            make.width.equalTo(AutoW(60))
            make.trailing.equalTo(AutoW(-15))
        }
        
        self.contentView.addSubview(self.contentTextLabel)
        contentTextLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(AutoW(15))
            make.top.equalTo(iconView.snp.bottom).offset(AutoW(15))
            make.width.equalTo(SCREEN_WIDTH-AutoW(30))
//            make.height.equalTo(30)
        }
        
        self.contentView.addSubview(allOrHideTextButton)
        allOrHideTextButton.snp.makeConstraints { (make) in
            make.top.equalTo(contentTextLabel.snp.bottom)
            make.leading.equalTo(AutoW(10))
            make.width.equalTo(40)
            make.height.equalTo(SHOWORHIDEBUTTONHEIGHT)
        }
        
        self.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.leading.equalTo(AutoW(15))
            make.trailing.equalTo(AutoW(-15))
            make.top.equalTo(allOrHideTextButton.snp.bottom).offset(AutoW(15))
            make.height.equalTo(SingelADImageCellWidth)
        }
        
        self.addSubview(newPriceLabel)
        newPriceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(collectionView.snp.bottom).offset(AutoW(14.5))
            make.leading.equalTo(collectionView)
            make.height.greaterThanOrEqualTo(16)
        }
        
        self.addSubview(oldPriceLabel)
        oldPriceLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(newPriceLabel)
            make.leading.equalTo(newPriceLabel.snp.trailing).offset(AutoW(6.5))
        }
        
        self.addSubview(shareButton)
        shareButton.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview()
            make.width.height.equalTo(AutoW(50))
            make.centerY.equalTo(newPriceLabel)
        }
        
        self.addSubview(copyNumberButton)
        copyNumberButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(shareButton)
            make.trailing.equalTo(shareButton.snp.leading).offset(AutoW(-5))
        }
        
        self.addSubview(zfButton)
        zfButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(AutoW(-20))
            make.height.equalTo(AutoW(30))
            make.width.equalTo(AutoW(200))
        }
        
        self.addSubview(pifaLogo)
        pifaLogo.snp.makeConstraints { (make) in
            make.leading.equalTo(nameLabel.snp.trailing).offset(AutoW(5))
            make.centerY.equalTo(nameLabel)
        }
        
        self.addSubview(likeButton)
        likeButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(contactButton.snp.leading).offset(AutoW(-6))
            make.centerY.equalTo(contactButton)
        }
        
//        self.addSubview(jubaoButton)
//        jubaoButton.snp.makeConstraints { (make) in
//            make.centerY.equalTo(moneyView)
//            make.trailing.equalTo(AutoW(-15))
//            make.width.equalTo(AutoW(40))
//            make.height.equalTo(AutoW(20))
//        }
    }
    
    func loadData(data:contentDtoModel) {
        self.data = data
        self.iconView.kf.setImage(with: URL(string: smallImageUrl+data.image), placeholder: PlaceHolderForUserHeader, options: nil, progressBlock: nil) { (image, error, type, url) in}
        
        self.nameLabel.text = data.username

        self.imgResIds = data.imgResIds.components(separatedBy: ";")
        if data.imgResIds != "" {
            collectionView.snp.updateConstraints { (make) in
                make.top.equalTo(allOrHideTextButton.snp.bottom).offset(AutoW(15))
                make.height.equalTo(SingelADImageCellWidth)
            }
        }else{
            collectionView.snp.updateConstraints { (make) in
                make.top.equalTo(allOrHideTextButton.snp.bottom)
                make.height.equalTo(0)
            }
        }
        
        if data.cellMaxHeight > data.cellNormalHeight{
            if data.showAll == false {
                self.contentTextLabel.numberOfLines = ContentNumberOfLines
                self.allOrHideTextButton.setTitle("全文", for: .normal)
            }else{
                self.contentTextLabel.numberOfLines = 0
                self.allOrHideTextButton.setTitle("收起", for: .normal)
            }
            self.allOrHideTextButton.snp.updateConstraints { (make) in
                make.height.equalTo(SHOWORHIDEBUTTONHEIGHT)
            }
        }else {
            self.allOrHideTextButton.setTitle("", for: .normal)
            self.allOrHideTextButton.snp.updateConstraints { (make) in
                make.height.equalTo(0)
            }
        }
        self.contentTextLabel.text = data.content
        
    }
    
    @objc private func showOrHideFunc(sender:UIButton) {
        if sender.titleLabel?.text == "全文" {
            sender.setTitle("收起", for: .normal)
            self.data?.showAll = true
        }else if sender.titleLabel?.text == "收起" {
            sender.setTitle("全文", for: .normal)
            self.data?.showAll = false
        }
        if UnNil(updateBlock) {updateBlock!()}
    }
    
    @objc private func copyNumberFunc(sender:UIButton) {
           UIPasteboard.general.string = "banana"
           KWHUD.showInfo(info: "复制成功")
    }
    
    @objc func headerClickFunc() {
        if UnNil(headerClick) {
            headerClick!()
        }
    }
    
    @objc func jubaoClickFunc() {
        if UnNil(jubaoClick) {
            jubaoClick!()
        }
    }
    
    @objc func likeClick(btn:UIButton) {
        btn.isSelected = !btn.isSelected

    }
    
    @objc func contactFunc() {
        
        if !KWLogin.existLoginStatus() {
            SVProgressHUD.showSuccess(withStatus: "请先登录您的账号,才能联系对方哦")
            return
        }
        
        if self.data?.cPhone == "" {
            self.data?.cPhone = self.data?.phone ?? ""
        }
        if UnEmpty(self.data?.cPhone) && UnEmpty(self.data?.wechatId) {
            AlertActionSheetTool.showAlert(titleStr: "", msgStr: "选择联系方式", currentVC: ApplicationWindow.rootViewController!, cancelHandler: { (action) in
                
            }, otherBtns: ["拨打电话号码","点击复制微信号"]) { (index) in
                if index == 0 {
                    let phone = "telprompt://" + self.data!.cPhone
                    if UIApplication.shared.canOpenURL(URL(string: phone)!) {
                         UIApplication.shared.openURL(URL(string: phone)!)
                    }
                }else if index == 1 {
                    UIPasteboard.general.string = self.data?.wechatId
                    KWHUD.showInfo(info: "复制成功")
                }
            }
        }else if UnEmpty(self.data?.cPhone) {
            AlertActionSheetTool.showAlert(titleStr: "", msgStr: "联系方式", currentVC: ApplicationWindow.rootViewController!, cancelHandler: { (action) in
                
            }, otherBtns: ["拨打电话号码"]) { (index) in
                if index == 0 {
                    let phone = "telprompt://" + self.data!.cPhone
                    if UIApplication.shared.canOpenURL(URL(string: phone)!) {
                         UIApplication.shared.openURL(URL(string: phone)!)
                    }
                }
            }
        }else if UnEmpty(self.data?.wechatId) {
            AlertActionSheetTool.showAlert(titleStr: "", msgStr: "联系方式", currentVC: ApplicationWindow.rootViewController!, cancelHandler: { (action) in
                
            }, otherBtns: ["点击复制微信号"]) { (index) in
                if index == 0 {
                    UIPasteboard.general.string = self.data?.wechatId
                    KWHUD.showInfo(info: "复制成功")
                }
            }
        }
    }
    
}



extension TextAndImageTableViewCell : UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgResIds.count > 3 ? 3 : imgResIds.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PUBLISHPICTURECELLID", for: indexPath) as! ADPictureCell
        cell.customIconImageView.kf.setImage(with: URL(string: smallImageUrl + self.imgResIds[indexPath.row]))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if UnNil(didSelectImageblock) {
            let cell = collectionView.cellForItem(at: indexPath) as! ADPictureCell
            self.didSelectImageblock!(cell.customIconImageView,indexPath.row,3)
        }
    }
}


class ADPictureCell: UICollectionViewCell {
    
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
}






















