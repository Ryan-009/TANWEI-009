//
//  CPMediaPickerController.swift
//  CPSwiftComponent
//
//  Created by reds on 2017/6/1.
//  Copyright © 2017年 convictionpeerless. All rights reserved.
//

import UIKit
import Photos
import SVProgressHUD

class CPMediaPickerController: CPMediaBaseController,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   
    @IBOutlet weak var previewHolder: UIView!
    @IBOutlet weak var collection : UICollectionView!
    @IBOutlet weak var finishButton: UIButton!
    
    fileprivate let edge  : CGFloat = 2.0
    
    fileprivate let baseW : CGFloat = (UIScreen.main.bounds.width - 2.0 * 4 ) / 4   // 1.0 -> edge
    
    fileprivate let CPMediaPickerCellID = "CPMediaPickerCellID"
    
    fileprivate var assets         : Array<PHAsset> = Array()
    
    fileprivate var maxCount       : Int = 0
    
    fileprivate var selectedAssets : Dictionary<String,PHAsset> = Dictionary()
    
    fileprivate var selectedImages : Array<UIImage> = Array()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeCollection()
        initializeAssets()
        initializeStyle()
        initializeNavigation()
    }

    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, type : AssetType, maxCount : Int) {
        super.init(nibName: "CPMediaPickerController", bundle: Bundle.main)
        self.maxCount  = maxCount
        self.assetType = type
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //预览按钮 Action
    @IBAction func preview(_ sender: Any) {
        
        guard selectedAssets.count > 0 else { return }
        
        SVProgressHUD.show()
        
        fetchSelectedImage {
            
            SVProgressHUD.dismiss()
            
            let vc = PhotoBrowser(showByViewController: self, delegate: self)
            
            vc.pageControlDelegate = PhotoBrowserDefaultPageControlDelegate(numberOfPages: self.selectedImages.count)
            
            vc.show(index: 0)
        }
    }
    
    //完成按钮 Action
    @IBAction func finish(_ sender: Any) {
        finishSelected()
    }
}

//MARK: 重新加载资源
extension CPMediaPickerController {
    internal func loadAssets(assets : Array<PHAsset>) {
        self.assets = assets
        self.collection.contentOffset = CGPoint(x: 0, y: 0)
        self.collection.reloadData()
    }
}

//MARK: 预览按钮 Selector
extension CPMediaPickerController {
    
    fileprivate func fetchSelectedImage(finish : @escaping ()->()) {
        
        selectedImages.removeAll()
        
        for asset in selectedAssets.values {
            
            let size = CGSize(width: asset.pixelWidth, height: asset.pixelHeight).scaleToScreen()
            
            RMMediaPicker.customScaleImage(asset: asset, size: size, result: { (image) in
                
                self.selectedImages.append(image)
                
                if self.selectedImages.count == self.selectedAssets.count {
                    
                    finish()
                }
            })
        }
    }
}

// 实现浏览器代理协议
extension CPMediaPickerController: PhotoBrowserDelegate {
    /// 实现本方法以返回图片数量
    func numberOfPhotos(in photoBrowser: PhotoBrowser) -> Int {
        return selectedImages.count
    }

    /// 实现本方法以返回默认图片，缩略图或占位图
    func photoBrowser(_ photoBrowser: PhotoBrowser, thumbnailImageForIndex index: Int) ->UIImage? {
        return selectedImages[index]
    }

    func photoBrowser(_ photoBrowser: PhotoBrowser, thumbnailViewForIndex index: Int) -> UIView? {
        return self.previewHolder
    }
}

//MARK: 完成按钮 Selector
extension CPMediaPickerController {
    
    fileprivate func finishSelected() {
        
        SVProgressHUD.show()
        
        var assets : Array<PHAsset> = Array()
        
        assets.append(contentsOf: selectedAssets.values)
        
        weak var weakSelf = self
        
        if selectAssetCallback != nil {
            
            DispatchQueue.main.async {
                
                weakSelf?.selectAssetCallback!(assets)
                
                SVProgressHUD.dismiss()
                
                weakSelf?.dismiss(animated: true, completion: nil)
            }
        }
        
        if selectImagesCallBack != nil {
            
            RMMediaPicker.fetchImages(assets: assets) { (images) in
                
                weakSelf?.selectImagesCallBack!(images)
                
                SVProgressHUD.dismiss()
                
                weakSelf?.dismiss(animated: true, completion: nil)
            }
        }
        
        if selectVideoCallBack != nil {
            
            RMMediaPicker.fetchVideoPath(assets: assets, result: { (paths) in
                
                weakSelf?.selectVideoCallBack!(paths)
                
                SVProgressHUD.dismiss()
                
                weakSelf?.dismiss(animated: true, completion: nil)
            })
        }
    }
}

//MARK: 初始化
extension CPMediaPickerController {
    fileprivate func initializeCollection() {
        collection.delegate   = self
        collection.dataSource = self
        collection.register(UINib(nibName: "CPMediaPickerCell", bundle: Bundle.main), forCellWithReuseIdentifier: CPMediaPickerCellID)
    }
    
    fileprivate func initializeAssets() {
        weak var weakSelf = self
        
        RMMediaPicker.authForAlbum { (result) in
            
            guard result == .success else { self.alertToSetting(); return }
            
            weakSelf?.requestAssets()
        }
    }
    
    fileprivate func initializeStyle() {
        finishButton.layer.cornerRadius  = 2.0
        finishButton.layer.masksToBounds = true
        finishButton.clipsToBounds       = true
        
        selectButtonNormalStyle()
    }
    
    fileprivate func initializeNavigation () {
        
        let cancel : UIButton = UIButton()
        let back   : UIButton = UIButton()
        
        back.contentHorizontalAlignment = .left
        cancel.contentHorizontalAlignment = .right
        
        cancel.addTarget(self, action: #selector(cancelAndBack), for: .touchUpInside)
        back.addTarget(self, action: #selector(backToAlbumList), for: .touchUpInside)
        
        cancel.frame = CGRect(x: 0.0, y: 0.0, width: 64.0, height: 32.0)
        back.frame   = CGRect(x: 0.0, y: 0.0, width: 64.0, height: 32.0)

        cancel.setTitle("取消", for: .normal)
        back.setTitle  ("相册", for: .normal)
        
        cancel.setTitleColor(UIColor.black, for: .normal)
        back.setTitleColor  (UIColor.black, for: .normal)
        
        cancel.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        back.titleLabel?.font   = UIFont.systemFont(ofSize: 16.0)
        
        back.setImage(UIImage(named: "back"), for: .normal)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: cancel)
        navigationItem.leftBarButtonItem  = UIBarButtonItem(customView: back)
    }
    
    @objc private func backToAlbumList() {
        assets.removeAll()
        selectedAssets.removeAll()
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func cancelAndBack() {
        dismiss(animated: true, completion: nil)
    }
}

//MARK: 初始化 - 请求资源 - 失败处理
extension CPMediaPickerController {
    
    fileprivate func alertToSetting() {
        let alert : UIAlertController = UIAlertController(title: "App需要开启相册权限", message: "App需要访问您的相册，是否前往设置开启相关权限?", preferredStyle: .alert)
        
        let config : UIAlertAction = UIAlertAction(title: "确定", style: .default) { (action) in self.linkToSetting() }
        let cancel : UIAlertAction = UIAlertAction(title: "取消", style: .cancel)  { (action) in }
        
        alert.addAction(config)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func linkToSetting() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        guard UIApplication.shared.canOpenURL(url) else { return }
    }
}

//MARK: 初始化 - 请求资源 - 成功处理
extension CPMediaPickerController {
    
    fileprivate func requestAssets() {
        if assetType == .photo { requestPhotos(); return }
        if assetType == .video { requestVideos(); return }
    }
    
    private func requestPhotos() {
        weak var weakSelf = self
        
        RMMediaPicker.customImageAssets { (result) in
            weakSelf?.assets = result
            weakSelf?.collection.reloadData()
        }
    }
    
    private func requestVideos() {
        weak var weakSelf = self
        
        RMMediaPicker.customVideoAssets { (result) in
            weakSelf?.assets = result
            weakSelf?.collection.reloadData()
        }
    }
}

//MARK: 完成按钮样式
extension CPMediaPickerController {
    fileprivate func selectButtonNormalStyle() {
        finishButton.backgroundColor = UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 1)
        finishButton.setTitleColor(UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1), for: .normal)
        finishButton.layer.borderColor = UIColor(red: 219/255, green: 219/255, blue: 219/255, alpha: 1).cgColor
        finishButton.layer.borderWidth = 1.0
        finishButton.isEnabled = false
    }
    
    fileprivate func selectButtonSelectStyle() {
        finishButton.backgroundColor = UIColor(red: 247/255, green: 142/255, blue: 2/255, alpha: 1)
        finishButton.setTitleColor(UIColor.white, for: .normal)
        finishButton.layer.borderColor = UIColor.white.cgColor
        finishButton.layer.borderWidth = 0.0
        finishButton.isEnabled = true
    }
}

//UICollectionView 代理
extension CPMediaPickerController {
    
    @available(iOS 6.0, *)
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collection.dequeueReusableCell(withReuseIdentifier: CPMediaPickerCellID, for: indexPath) as! CPMediaPickerCell
        
        if assets.count > indexPath.row {
            RMMediaPicker.customSourceImage(asset: assets[indexPath.row]) { (image) in
                cell.loadData(image: image)
                
                if self.isNeedInsertToSelected(index: indexPath.row) {
                    cell.clearSelectedStatus()
                } else {
                    cell.addSelectedStatus()
                }
            }
//            RMMediaPicker.customScaleImage(asset: assets[indexPath.row], size: CGSize(width: baseW * 2, height: baseW * 2)) { (image) in
//
//                cell.loadData(image: image)
//
//                if self.isNeedInsertToSelected(index: indexPath.row) {
//                    cell.clearSelectedStatus()
//                } else {
//                    cell.addSelectedStatus()
//                }
//            }
        }
        
        return cell
    }
    
    @available(iOS 6.0, *)
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assets.count
    }
    
    @available(iOS 6.0, *)
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    @available(iOS 6.0, *)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: baseW , height: baseW)
    }
    
    @available(iOS 6.0, *)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return edge
    }
    
    @available(iOS 6.0, *)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return edge
    }

    @available(iOS 6.0, *)
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if isNeedInsertToSelected(index: indexPath.row) {
            
            guard canSelect() else { alertMaxCount(); return }
            
            insertToSelected(index: indexPath.row)
        } else {
            removeFromSelected(index: indexPath.row)
        }
        
        if let cell = collectionView.cellForItem(at: indexPath) as? CPMediaPickerCell {
            cell.selectStatusChange()
        }
        
        if selectedAssets.count > 0 {
            selectButtonSelectStyle()
        } else {
            selectButtonNormalStyle()
        }
    }
    
    private func canSelect() -> Bool  {
        return selectedAssets.count < maxCount
    }
    
    private func isNeedInsertToSelected(index : Int) -> Bool {
        if selectedAssets.keys.contains("\(index)") {
            return false
        }
        return true
    }
    
    private func insertToSelected(index : Int)  {
        if assets.count > index {
            selectedAssets["\(index)"] = assets[index]
        }
    }
    
    private func removeFromSelected(index : Int) {
        if selectedAssets.keys.contains("\(index)") {
            selectedAssets.removeValue(forKey: "\(index)")
        }
    }
    
    private func alertMaxCount() {
        let alert : UIAlertController = UIAlertController(title: "不能选取更多", message: "您最多可以选择\(maxCount)张相片", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default) { (action) in  })
        self.present(alert, animated: true, completion: nil)
    }
}

