//
//  CPMediaListController.swift
//  RedsMeMe
//
//  Created by reds on 2017/6/2.
//  Copyright © 2017年 Reds. All rights reserved.
//

import UIKit
import Photos

class CPMediaListController: CPMediaBaseController,UITableViewDelegate,UITableViewDataSource {
    
    fileprivate let CPMediaListCellID : String = "CPMediaListCellID"
    fileprivate var albums : Array<CPCustomMediaAlbum> = Array()
    fileprivate var picker : CPMediaPickerController!
    @IBOutlet weak var listTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        initializeListTable()
        initializeAlbums()
        initializeStyle()
        performSelector(onMainThread: #selector(waitToPicker), with: nil, waitUntilDone: true)
    }
    
    @objc private func waitToPicker() {
        perform(#selector(toPicker), with: nil)
    }
    
    @objc private func toPicker() {
        self.navigationController?.pushViewController(picker, animated: false)
    }

    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, type : AssetType, maxCount : Int) {
        super.init(nibName: "CPMediaListController", bundle: Bundle.main)
        picker = CPMediaPickerController(nibName: "", bundle: nil, type: type, maxCount: maxCount)
        self.assetType = type
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal override func fetchImagesResult(_ result : @escaping (_ images : Array<UIImage>)->()) {
        picker.fetchImagesResult(result)
    }
    
    internal override func fetchVideoResult(_ result : @escaping (_ images : Array<String>)->()) {
        picker.fetchVideoResult(result)
    }
    
    internal override func fetchAssetResult(_ result : @escaping (_ images : Array<PHAsset>)->()) {
        picker.fetchAssetResult(result)
    }

}

extension CPMediaListController {
    fileprivate func initializeListTable() {
        listTable.delegate   = self
        listTable.dataSource = self
        listTable.separatorStyle = .none
        listTable.register(UINib(nibName: "CPMediaListCell", bundle: Bundle.main), forCellReuseIdentifier: CPMediaListCellID)
    }
    
    fileprivate func initializeAlbums() {
        
        if assetType == .photo {
            RMMediaPicker.customImageAlbum { (albums) in
                self.albums = albums
                self.listTable.reloadData()
            }
            return
        }
        
        if assetType == .video {
            RMMediaPicker.customVideoAlbum(result: { (albums) in
                self.albums = albums
                self.listTable.reloadData()
            })
            return
        }
        
    }
    
    fileprivate func initializeStyle() {
        
        let cancel : UIButton = UIButton()
        cancel.addTarget(self, action: #selector(cancelAndBack), for: .touchUpInside)
        cancel.frame = CGRect(x: 15, y: 0, width: 64, height: 32)
        cancel.setTitle("取消", for: .normal)
        cancel.setTitleColor(UIColor.black, for: .normal)
        cancel.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        cancel.titleEdgeInsets  = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0)
        
        let rightbar : UIBarButtonItem = UIBarButtonItem(customView: cancel)
        navigationItem.rightBarButtonItem = rightbar
    }

    @objc private func cancelAndBack() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension CPMediaListController {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CPMediaListCellID, for: indexPath) as! CPMediaListCell
        cell.loadData(album: albums[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        picker.loadAssets(assets: albums[indexPath.row].assets)
        
        navigationController?.pushViewController(picker, animated: true)
    }
}
