//
//  KWApplication.swift
//  KIWI
//
//  Created by li zhou on 2019/11/4.
//  Copyright © 2019 li zhou. All rights reserved.
//

import Foundation

class KWNetworkHandle: NSObject {
    /******************** 单例 ********************/
    public class func shared() -> KWNetworkHandle {return KWNetworkHandle.handle}
    private static let handle = KWNetworkHandle()
    private override init() {}
    
    /******************** 任务集 ***************/
    var tasks : Dictionary<String, KWNetworkRequest> = Dictionary()
}

//MARK:操作任务集
extension KWNetworkHandle {
    
    //移除所有任务
    public class func removeAllTask() {
        KWNetworkHandle.shared().tasks.removeAll()
    }
    
    ///添加到任务集
    public class func addToTasks(request : KWNetworkRequest) {
        if KWNetworkHandle.shared().tasks.keys.contains(request.identifier) {
            return
        }
        
        KWNetworkHandle.shared().tasks[request.identifier] = request
    }
    
    ///从任务集中移除
    public class func removeFromTasks(request : KWNetworkRequest) {
        if KWNetworkHandle.shared().tasks.keys.contains(request.identifier) {
            KWNetworkHandle.shared().tasks.removeValue(forKey: request.identifier)
        }
    }
    
    ///是否包含在任务集,包含则返回 否则创建并添加到任务集合
    public class func containsInTasks(type : KWNetworkDefine.URL)-> KWNetworkRequest {
        
        objc_sync_enter(KWNetworkHandle.shared().tasks)
        var request : KWNetworkRequest!
        
        for (_,req) in KWNetworkHandle.shared().tasks {
            
            if isAllowRepeat(urlType: type) {
                break
            }
            
            if type == req.type {
                req.cancel()
                request = req
            }
        }
        
        if request == nil {
            request = KWNetworkRequest()
            KWNetworkHandle.addToTasks(request: request)
        }
        objc_sync_exit(KWNetworkHandle.shared().tasks)
        
        return request
    }
}

extension KWNetworkHandle {
    
    ///设置可以重复的任务集
    private class func allowRepeatUrl() ->Array<String> {
        return []
    }
    
    ///是否允许重复
    fileprivate class func isAllowRepeat(urlType : KWNetworkDefine.URL) ->Bool {
        return allowRepeatUrl().contains(urlType.rawValue)
    }
}
