//
//  KWApplication.swift
//  KIWI
//
//  Created by li zhou on 2019/11/4.
//  Copyright © 2019 li zhou. All rights reserved.
//

import Foundation
import Kingfisher

public typealias DDImageView = UIImageView
public typealias DDButton    = UIButton

extension DDImageView : RedsDDImageProtocol{}
extension DDButton    : RedsDDImageProtocol{}

public final class RedsDDImage<DDBase> {
    fileprivate let base : DDBase
    public init(_ base: DDBase) {
        self.base = base
    }
}

public protocol RedsDDImageProtocol {
    associatedtype ProtocolType
    var dd: ProtocolType { get }
}

public extension RedsDDImageProtocol {
    var dd: RedsDDImage<Self> {
        get { return RedsDDImage(self) }
    }
}

extension RedsDDImage where DDBase : DDImageView {

    //Quick
    public func setSmall(materialId : String, holder: KFCrossPlatformImage?) {
        
        setImage(url: convertUrl(materialId: materialId, source: materialId.small()), holder: holder, finish: {(image) in })
    }
    
    public func setNormal(materialId : String, holder: Image?) {
        setImage(url: convertUrl(materialId: materialId, source: materialId.normal()), holder: holder, finish: {(image) in })
    }
    
    public func setBig(materialId : String, holder: Image?) {
        setImage(url: convertUrl(materialId: materialId, source: materialId.big()), holder: holder, finish: {(image) in })
    }
    
    //Handle Image
    public func setSmall(materialId : String, holder: Image?, finish : @escaping (_ image : Image?,_ width : CGFloat?, _ height : CGFloat?)->()) {
        
        setImage(url: convertUrl(materialId: materialId, source: materialId.small()), holder: holder, finish: {(image) in
            finish(image,image?.size.width, image?.size.height)
        })
    }
    
    public func setNormal(materialId : String, holder: Image?, finish : @escaping (_ image : Image?,_ width : CGFloat?, _ height : CGFloat?)->()) {
        setImage(url: convertUrl(materialId: materialId, source: materialId.normal()), holder: holder, finish: {(image) in
            finish(image,image?.size.width, image?.size.height)
        })
    }
    
    public func setBig(materialId : String, holder: Image?, finish : @escaping (_ image : Image?,_ width : CGFloat?, _ height : CGFloat?)->()) {
        setImage(url: convertUrl(materialId: materialId, source: materialId.big()), holder: holder, finish: {(image) in
            finish(image,image?.size.width, image?.size.height)
        })
    }
}

extension RedsDDImage where DDBase : DDImageView {
    //获取图片路径
    fileprivate func convertUrl(materialId : String,source : String) -> URL {
        if materialId.jpglocal().isExist() {
            return URL(fileURLWithPath: materialId.jpglocal())
        }
        
        if let url = URL(string: source) {
            return url
        }
        
        return URL(fileURLWithPath: "")
    }
    
    //设置图片
    fileprivate func setImage(url : URL, holder: Image?,finish : @escaping (_ image : Image?)->()) {
        weak var imageView : UIImageView? = base
        
        imageView?.kf.setImage(with: url, placeholder: holder, options: nil, progressBlock: nil) { (image, error, type, url) in
            finish(image)
        }
    }
}

