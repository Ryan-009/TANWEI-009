//
//  PublishADViewController.swift
//  salestar
//
//  Created by li zhou on 2019/11/23.
//  Copyright © 2019 li zhou. All rights reserved.
//

import UIKit
import SVProgressHUD
import Photos

class PublishADViewController: KWBaseViewController {

    fileprivate var scrollView : SSScrollView = {
        let scrol = SSScrollView(frame: CGRect(x: 0, y: NavHeight, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-NavHeight))
        scrol.showsVerticalScrollIndicator = false
        scrol.showsHorizontalScrollIndicator = false
        scrol.contentSize = CGSize(width: SCREEN_WIDTH, height: SCREEN_HEIGHT+AutoW(50))
        return scrol
    }()
    
    fileprivate var keywordTextFeild : UITextField = {
        let tf = UITextField()
        tf.placeholder = "请输入商品货号"
        tf.font = UIFont.systemFont(ofSize: 15)
        return tf
    }()
    
    fileprivate var companyTextFeild : UITextField = {
        let tf = UITextField()
        tf.placeholder = "请输入公司官网"
        tf.font = UIFont.systemFont(ofSize: 15)
        return tf
    }()
    
    fileprivate var publishButton : UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("发布广告", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.layer.cornerRadius = AutoW(6)
        btn.clipsToBounds = true
        btn.backgroundColor = APPSubjectColor
        btn.addTarget(self, action: #selector(publishFunc), for: .touchUpInside)
        return btn
    }()
    
    lazy var tableView : UITableView = {
        let tabView = UITableView()
        tabView.tableFooterView = UIView(frame: .zero)
        tabView.register(UINib(nibName: "TWNormalTableViewCell", bundle: nil), forCellReuseIdentifier: "TWNORMALCELLID")
        tabView.delegate = self
        tabView.dataSource = self
        tabView.isScrollEnabled = false
        return tabView
    }()
    
    fileprivate let textContentView = PublishContentView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: AutoW(150)))
    
    fileprivate let imageContentView = PublishImageView(frame: CGRect(x: 0, y: AutoW(170), width: SCREEN_WIDTH, height: (SCREEN_WIDTH - AutoW(21)*2 - AutoW(8)*2)/3+AutoW(35)+AutoW(50)))
    
    let picItemWidth : CGFloat = (SCREEN_WIDTH - AutoW(21)*2 - AutoW(8)*2)/3
    
    var pictureViewHeight = (SCREEN_WIDTH - AutoW(21)*2 - AutoW(8)*2)/3 + AutoW(35) + AutoW(50) {
        didSet{
            updateImageContentConst()
        }
    }
    
    var photos = [UIImage]() {
        didSet{
            imageContentView.photoArr = photos
            let h = CGFloat((photos.count / 3)+1) > 3 ? 3 : CGFloat((photos.count / 3)+1)
            pictureViewHeight = h*picItemWidth + (h-1)*AutoW(8) + AutoW(35) + AutoW(50)
            if photos.count < 9 {
                self.imageContentView.collectionView.isScrollEnabled = false
            }else {
                self.imageContentView.collectionView.isScrollEnabled = true
            }
        }
    }
    
    private var reward : Int = 0
    private var maxReward : Int = 0
    fileprivate var hanye = ""
    fileprivate var address = ""
    
    var transmitData : contentModel = contentModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selfInit()
        toEditUserInfo()
        
//        KWUIListener.register.transmitToPublish(target: self, selector: #selector(transmitFunc))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.transmitData.cotentId != 0 {
            transmitFunc()
        }
    }
    
    @objc private func transmitFunc(){
        self.textContentView.textView.text = self.transmitData.cotent
        self.textContentView.textViewDidEndEditing(self.textContentView.textView)
        self.photos = self.transmitData.imagesForTransmit
        self.imageContentView.pifaTextView.text = "\(self.transmitData.curPrice)"
        self.imageContentView.yuanjiaTextView.text = "\(self.transmitData.origPrice)"
        self.keywordTextFeild.text = self.transmitData.shopCode
        self.imageContentView.transmitReds = self.transmitData.resId.components(separatedBy: ";")
        self.hanye = self.transmitData.contentType
        self.address = self.transmitData.region
        
//        if let cell = tableView.cellForRow(at: IndexPath(item: 0, section: 0)) as? TWNormalTableViewCell {
//            cell.contentLabel.text = self.transmitData.contentType
//
//        }
//        if let cell2 = tableView.cellForRow(at: IndexPath(item: 1, section: 0)) as? TWNormalTableViewCell {
//            cell2.contentLabel.text = self.transmitData.region
//
//        }
    }
    private func disableUserInteraction() {
        self.keywordTextFeild.isUserInteractionEnabled = false
        self.textContentView.textView.isUserInteractionEnabled = false
    }
    
    private func selfInit() {
       
        self.navigationItem.leftBarButtonItem = SetBackBarButtonItem(target: self, action: #selector(back), imageName: "back")
        
        self.navigationItem.title = "发布商品"
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(textContentView)
        self.scrollView.addSubview(imageContentView)
        imageContentView.itemDidMove = { photos in
            self.photos = photos
        }

        updateImageContentConst()
        
        self.imageContentView.itemCickBlock = {index in
            if index == self.photos.count {
                self.loadsystemAlbum()
            }
        }
        
        self.imageContentView.itemDeleteBlock = {index in
            self.photos.remove(at: index)
        }
        
        let redtip = UILabel()
        redtip.font = UIFont.systemFont(ofSize: 12)
        redtip.textColor = .red
        redtip.text = "温馨提示:请在设置商品价格时考虑七天无理由退货,退货包运费等因素."
        redtip.numberOfLines = 0
        self.view.addSubview(redtip)
        redtip.snp.makeConstraints { (make) in
            make.leading.equalTo(AutoW(21))
            make.top.equalTo(imageContentView.snp.bottom).offset(AutoW(10))
            make.trailing.equalTo(AutoW(-15))
        }
        
        let keyWord : UILabel = UILabel()
        keyWord.attributedText = GetAttributeString(orString: "* 商品货号", attString: "*", attrs: [NSAttributedString.Key.foregroundColor : UIColor.red])
        keyWord.font = UIFont.systemFont(ofSize: 17)
        self.view.addSubview(keyWord)
        keyWord.snp.makeConstraints { (make) in
            make.leading.equalTo(AutoW(21))
            make.top.equalTo(imageContentView.snp.bottom).offset(AutoW(70))
        }
        
        let line1 = UIView()
        line1.backgroundColor = APPSeparatorColor
        self.view.addSubview(line1)
        line1.snp.makeConstraints { (make) in
            make.top.equalTo(keyWord.snp.bottom).offset(35)
            make.leading.equalTo(AutoW(21))
            make.width.equalTo(SCREEN_WIDTH-AutoW(42))
            make.height.equalTo(AutoW(0.5))
        }
        
        self.view.addSubview(keywordTextFeild)
        keywordTextFeild.snp.makeConstraints { (make) in
            make.height.equalTo(AutoW(34))
            make.leading.equalTo(AutoW(21))
            make.width.equalTo(SCREEN_WIDTH-AutoW(21))
            make.bottom.equalTo(line1.snp.top)
        }
        
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(line1.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalTo(line1)
            make.height.equalTo(AutoW(110))
        }
        
        self.view.addSubview(publishButton)
        publishButton.snp.makeConstraints { (make) in
            make.top.equalTo(tableView.snp.bottom).offset(AutoW(78))
            make.leading.equalTo(AutoW(21))
            make.width.equalTo(SCREEN_WIDTH-AutoW(42))
            make.height.equalTo(AutoW(56))
        }
        
    }
    
    private func toEditUserInfo() {
//        let vc = TanweiEditUserinfoTableViewController.init()
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func updateImageContentConst() {
        self.scrollView.contentSize.height = SCREEN_HEIGHT + pictureViewHeight - AutoH(80)
        self.imageContentView.snp.removeConstraints()
        self.imageContentView.snp.makeConstraints { (make) in
            make.leading.equalTo(0)
            make.top.equalTo(textContentView.snp.bottom).offset(AutoW(35))
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(pictureViewHeight)
        }
    }
    
    //发货地
    @objc func citySelectFunc() {
        let vc = CustomLevelsPickerViewController.init()
        vc.view.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        self.present(vc, animated: false, completion: nil)
        vc.didSelected = {city in
            if let cell = self.tableView.cellForRow(at: IndexPath(item: 1, section: 0)) as? TWNormalTableViewCell {
                cell.contentLabel.text = city
                self.address = city
            }
        }
    }
    
    private func selectContentType() {
        let vc = GoodsMenuViewController()
        vc.comfirmBlock = {good in
            if let cell = self.tableView.cellForRow(at: IndexPath(item: 0, section: 0)) as? TWNormalTableViewCell {
                cell.contentLabel.text = good
                self.hanye = good
            }
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //调取相册
    @objc func loadsystemAlbum() {
        let listController = CPMediaListController(nibName: "", bundle: nil, type: .photo, maxCount : 30-self.photos.count)
        let navigation = UINavigationController(rootViewController: listController)
        self.present(navigation, animated: true, completion: nil)
        listController.fetchImagesResult { (images) in
            for i in images {
                self.photos.append(i)
            }
        }
    }
    
    @objc func publishFunc() {
        if self.transmitData.cotentId == 0 {
            publishWithImage()
        }else{
            transmitPublish()
        }
    }
    
    @objc private func transmitPublish() {
        
        guard let content = self.textContentView.textView.text else {
            KWHUD.showInfo(info: "请填写内容")
            return
        }
        
        if !UnEmpty(content) {
            KWHUD.showInfo(info: "请填写内容")
            return
        }
        
        if self.imageContentView.pifaTextView.text == "" {
            KWHUD.showInfo(info: "请输入批发价格")
            return
        }
        
        if self.imageContentView.yuanjiaTextView.text == "" {
            KWHUD.showInfo(info: "请输入市场价格")
            return
        }
        
        if self.keywordTextFeild.text == ""{
            KWHUD.showInfo(info: "请填写商品货号")
            return
        }
        
        if !UnEmpty(self.hanye) {
            KWHUD.showInfo(info: "请选择行业")
            return
        }

        if !UnEmpty(self.address) {
            KWHUD.showInfo(info: "请选择发货地")
            return
        }
        
        var par : [String:Any] = [:]
        par[KWNetworkDefine.KEY.content.rawValue]       = content
        par[KWNetworkDefine.KEY.shopCode.rawValue]  = self.keywordTextFeild.text!
        par[KWNetworkDefine.KEY.origPrice.rawValue] = self.imageContentView.yuanjiaTextView.text!
        par[KWNetworkDefine.KEY.curPrice.rawValue]    = self.imageContentView.pifaTextView.text!
        par[KWNetworkDefine.KEY.contentType.rawValue]   = self.hanye
        par[KWNetworkDefine.KEY.contentRegion.rawValue] = self.address
        par[KWNetworkDefine.KEY.resId.rawValue]         = self.transmitData.resId
        Application.opration.publish(parameters: par, success: {
            self.clearAll()
            self.navigationController?.popViewController(animated: true)
        }) {_ in}
    }
    
    @objc private func publishWithImage(){
        
        guard let content = self.textContentView.textView.text else {
            KWHUD.showInfo(info: "请填写内容")
            return
        }
        
        if !UnEmpty(content) {
            KWHUD.showInfo(info: "请填写内容")
            return
        }
        
        if self.imageContentView.photoArr.count == 0 {
            KWHUD.showInfo(info: "请上传商品图片")
            return
        }
        
        if self.imageContentView.pifaTextView.text == "" {
            KWHUD.showInfo(info: "请输入批发价格")
            return
        }
        
        if self.imageContentView.yuanjiaTextView.text == "" {
            KWHUD.showInfo(info: "请输入市场价格")
            return
        }
        
        if self.keywordTextFeild.text == ""{
            KWHUD.showInfo(info: "请填写商品货号")
            return
        }
        
        if self.hanye.isEmpty {
            KWHUD.showInfo(info: "请选择行业")
            return
        }
        
        if self.address.isEmpty {
            KWHUD.showInfo(info: "请选择发货地")
            return
        }
        
        var par : [String:Any] = [:]
        par[KWNetworkDefine.KEY.content.rawValue] = content
        par[KWNetworkDefine.KEY.shopCode.rawValue]  = self.keywordTextFeild.text!
        par[KWNetworkDefine.KEY.origPrice.rawValue] = self.imageContentView.yuanjiaTextView.text!
        par[KWNetworkDefine.KEY.curPrice.rawValue]    = self.imageContentView.pifaTextView.text!
        par[KWNetworkDefine.KEY.contentType.rawValue] = self.hanye
        par[KWNetworkDefine.KEY.contentRegion.rawValue] = self.address
        var uploads : [UploadImage] = []
        for i in 0...self.photos.count-1 {
            let uploadImage = UploadImage.init(self.photos[i], index: i)
            uploads.append(uploadImage)
        }
        KWNetwork.publishUploadImage(uploadImages: uploads, success: { (ids) in
            var imgResIds = ""
            for i in 0...ids.count-1 {
                imgResIds = imgResIds + ids[i].materialId
                if i != ids.count-1 {
                    imgResIds = imgResIds + ";"
                }
            }
            par[KWNetworkDefine.KEY.resId.rawValue] = imgResIds
            Application.opration.publish(parameters: par, success: {
                KWHUD.showInfo(info: "发布成功")
                self.clearAll()
                self.back()
            }) {errType in}
        }) {}
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc fileprivate func back() {
        self.view.endEditing(true)
        self.tabBarController?.selectedIndex = 0
        self.navigationController?.popViewController(animated: true)
    }
    
    fileprivate func clearAll() {
        self.textContentView.textView.text = ""
        self.reward     = 0
        self.maxReward  = 0
        self.keywordTextFeild.text = ""
        self.companyTextFeild.text = ""
        self.photos = []
        self.imageContentView.pifaTextView.text = ""
        self.imageContentView.yuanjiaTextView.text = ""
        self.hanye = ""
        self.address = ""
        transmitData = contentModel()
        if let cell = tableView.cellForRow(at: IndexPath(item: 0, section: 0)) as? TWNormalTableViewCell {
            cell.contentLabel.text = ""
        }
        if let cell2 = tableView.cellForRow(at: IndexPath(item: 1, section: 0)) as? TWNormalTableViewCell {
            cell2.contentLabel.text = ""
        }
    }
}

extension PublishADViewController : UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        return true
    }
}

extension PublishADViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TWNORMALCELLID") as! TWNormalTableViewCell
        cell.updatePublishData(indexpath: indexPath)
        cell.hideRedpoint()
        if indexPath.row == 0 {
            cell.contentLabel.text = self.hanye
        }else if indexPath.row == 1 {
            cell.contentLabel.text = self.address
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AutoW(55)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.view.endEditing(false)
        if indexPath.row == 0 {
            selectContentType()
        }else if indexPath.row == 1 {
            citySelectFunc()
        }
        
    }
}
