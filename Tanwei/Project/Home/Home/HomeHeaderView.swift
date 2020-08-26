//
//  HomeHeaderView.swift
//  salestar
//
//  Created by li zhou on 2019/12/7.
//  Copyright © 2019 li zhou. All rights reserved.
//

import UIKit

class DDGetHomePageAdList : NSObject {
    var adCover   : String = ""
    var adId      : Int = 0
    var commodityId : Int = 0
    var shopId    : Int = 0
    var urlLink   : String = ""
    var title     : String = ""
}

class HomeHeaderView: UIView {
    
    let edge : CGFloat = AutoW(15)
    let bannerHeight  : CGFloat = AutoW(180)
    var banner : LLCycleScrollView!
    var bannerDataList : [allBannarModel] = []{didSet{
            setCircleView()
    }}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
     
        selfInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func selfInit() {
        self.backgroundColor = UIColor.white
    }
    
    func setCircleView() {
        if banner != nil {
            banner.removeFromSuperview()
        }
        var imageUrl : [String] = []
        for i in bannerDataList {imageUrl.append(ImageBaseURL+i.resId)}
        banner = LLCycleScrollView.llCycleScrollViewWithFrame(CGRect(x: edge, y: edge, width: SCREEN_WIDTH-AutoW(30), height: bannerHeight), imageURLPaths: imageUrl, titles: []) { (selectedIndex) in
            if self.bannerDataList.count > selectedIndex {
//                 self.delegate?.bannerClickWithData(data: self.bannerDataList[selectedIndex])
            }
        }
        banner.backgroundColor = UIColor.black
        banner.customPageControlStyle = .fill
        banner.pageControlPosition    = .center
        banner.imageViewContentMode   = .scaleToFill
        banner.autoScrollTimeInterval = 5
        if imageUrl.count == 1 {
            banner.autoScroll = false
        }else{
            banner.autoScroll = true
        }
        
        self.addSubview(banner)
    }
}
