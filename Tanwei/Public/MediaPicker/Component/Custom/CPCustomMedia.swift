//
//  RMImagePicker.swift
//  RedsMeMe
//
//  Created by reds on 2017/4/8.
//  Copyright © 2017年 Reds. All rights reserved.
//

import Foundation
import Photos
import UIKit
class CPCustomMedia: NSObject, PHPhotoLibraryChangeObserver {

    deinit { PHPhotoLibrary.shared().unregisterChangeObserver(self) }

    fileprivate var tasks : Array<CPCustomMediaTask> = Array()

    internal func photoLibraryDidChange(_ changeInstance: PHChange) {

        guard tasks.count > 0 else { return }
        
        
        for task in tasks {
            
            if task.pickType == .assets {
                DispatchQueue.main.async { self.pickAssets(results: task.assetsResult!,type: task.fetchType) }
                continue
            }
            
            if task.pickType == .albums {
                DispatchQueue.main.async { self.pickAlbum(result: task.albumsResult!, type: task.fetchType) }
                continue
            }
        }
        
        tasks.removeAll()
    }
}

//MARK: 抓取资源
extension CPCustomMedia {
    //所有资源集
    public func pickAssets(results : @escaping (_ assets : Array<PHAsset>)->(), type : PHAssetMediaType) {
        
        PHPhotoLibrary.shared().register(self)
        
        let task : CPCustomMediaTask = CPCustomMediaTask(fetchType: type, pickType: .assets, assetsResult: results)
        
        let options = PHFetchOptions()
        
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        DispatchQueue.global().async {
            let result : PHFetchResult<PHAsset> = PHAsset.fetchAssets(with: type, options: options)
            
            guard result.count > 0 else { self.tasks.append(task); return }
            
            var assetCollection : Array<PHAsset> = Array()
            
            let count : Int = result.count
            
            for i in 0..<count { assetCollection.append(result[i] as PHAsset) }
            
            DispatchQueue.main.async {
                
                results(assetCollection)
            }
        }
    }
    
    //获取相册资源集
    public func pickAlbum(result : @escaping (_ albums : Array<CPCustomMediaAlbum>)->(), type : PHAssetMediaType) {
        
        PHPhotoLibrary.shared().register(self)

        let task : CPCustomMediaTask = CPCustomMediaTask(fetchType: type, pickType: .albums, albumsResult: result)
        
        DispatchQueue.global().async {
            let systemAlbums : Array<CPCustomMediaAlbum> = self.pickSystemAlbumAssets(type: type)
            let userAlbums   : Array<CPCustomMediaAlbum> = self.pickUserAlbumAssets(type: type)
            
            guard systemAlbums.count > 0 || userAlbums.count > 0 else { self.tasks.append(task); return }
            
            DispatchQueue.main.async {
                
                result(systemAlbums + userAlbums)
            }
        }
    }
    
    //获取系统相册资源
    private func pickSystemAlbumAssets(type : PHAssetMediaType) -> Array<CPCustomMediaAlbum> {
        let options : PHFetchOptions = PHFetchOptions()
        let albums  : PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: options)
        return convertCollectionToAssets(result: albums, type: type)
    }
    
    //获取用户相册资源
    private func pickUserAlbumAssets(type : PHAssetMediaType) -> Array<CPCustomMediaAlbum> {
        let options : PHFetchOptions = PHFetchOptions()
        let albums  : PHFetchResult<PHCollection> = PHCollectionList.fetchTopLevelUserCollections(with: options)
        return convertCollectionToAssets(result: albums, type: type)
    }
    
    //将抓取结果转换为资源集合
    private func convertCollectionToAssets<Collection>(result : PHFetchResult<Collection>,type : PHAssetMediaType) -> Array<CPCustomMediaAlbum> {
        
        let count = result.count
        
        var albums : Array<CPCustomMediaAlbum> = Array()
        
        for i in 0..<count {
            
            let options : PHFetchOptions = PHFetchOptions()
            
            options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            
            options.predicate       = NSPredicate(format: "mediaType = %d", type.rawValue)
            
            guard let collection = result[i] as? PHAssetCollection else { return Array()}
            
            let fetchResult : PHFetchResult<PHAsset> = PHAsset.fetchAssets(in: collection, options: options)
            
            if fetchResult.count > 0 {
                let title : String = collection.localizedTitle != nil ? collection.localizedTitle! : "未命名"
                
                let album : CPCustomMediaAlbum = CPCustomMediaAlbum(name: title, result: fetchResult)
                
                albums.append(album)
            }
        }
        
        return albums
    }
}


//MARK: 获取单个媒体
extension CPCustomMedia {
    
    //缩略图
    public func pickScaleImage(asset : PHAsset, size : CGSize, result : @escaping (_ image : UIImage)->()) {
        let options : PHImageRequestOptions = PHImageRequestOptions()
        options.isNetworkAccessAllowed = false
        options.isSynchronous = true
        options.resizeMode = .exact
        options.deliveryMode = .fastFormat
        
        DispatchQueue.global().async {
            
            PHCachingImageManager.default().requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: options, resultHandler: {(image,info) in
                
                DispatchQueue.main.async {
                    
                    guard let scaleImage = image else { result(UIImage()); return}
                    
                    result(scaleImage)
                }
            })
        }
    }
    
    //原图
    public func pickSourceImage(asset : PHAsset, result : @escaping (_ image : UIImage)->()) {
        let options : PHImageRequestOptions = PHImageRequestOptions()
        options.isNetworkAccessAllowed = false
        options.isSynchronous = true
        options.resizeMode = .exact
        options.deliveryMode = .highQualityFormat
        
        DispatchQueue.global().async {
            
            PHCachingImageManager.default().requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: options, resultHandler: {(image,info) in
                
                DispatchQueue.main.async {
                    
                    guard let sourceImage = image else { result(UIImage()); return }
                    
                    result(sourceImage)
                }
            })
        }
    }
    
    //视频
    public func pickerSourceVideo(asset : PHAsset, result : @escaping (_ url : URL)->()) {
        let options : PHVideoRequestOptions = PHVideoRequestOptions()
        options.isNetworkAccessAllowed = false
        options.deliveryMode = .fastFormat
        
        DispatchQueue.global().async {
            
            PHCachingImageManager.default().requestAVAsset(forVideo: asset, options: options) { (avAsset, audioMix, info) in
                
                DispatchQueue.main.async {
                    
                    guard let urlAsset = avAsset as? AVURLAsset else { result(URL(fileURLWithPath: "")); return }
                    
                    result(urlAsset.url)
                }
            }
        }
    }
    
}

