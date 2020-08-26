//
//  KWApplication.swift
//  KIWI
//
//  Created by li zhou on 2019/11/4.
//  Copyright © 2019 li zhou. All rights reserved.
//

import Foundation
import UIKit

internal let Application : KWApplication = KWApplication()

class KWApplication: NSObject {
    fileprivate override init() {}
    
    let window           : UIWindow               = UIApplication.shared.delegate!.window!!
    
    //全局数据库
    let save             : KWDataSave             = KWDataSave()
        
    //拉取内容列表
    let list             : KWInfoListTask         = KWInfoListTask()
        
    //用户更改操作
    let opration         : KWUserOperation        = KWUserOperation()
    
    //缓存个人素材
    let cache            : CacheTask                = CacheTask()
    
    //数据源
//    let dataSource       : DDDataSource           = DDDataSource()
        
    //账户操作
//    let account          : DDAccountTask          = DDAccountTask()
        
    //缓存个人素材
//    let cache            : DDCacheTask            = DDCacheTask()
        
    //分享
//    let shared           : DDSharedTask           = DDSharedTask()
        
    //网络监测
    //    let netObserver      : DDNetObserver          = DDNetObserver()
    //设置
//    let setting          : DDSettingTask          = DDSettingTask()
    
}
