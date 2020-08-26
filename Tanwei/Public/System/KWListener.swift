//
//  KWApplication.swift
//  KIWI
//
//  Created by li zhou on 2019/11/4.
//  Copyright © 2019 li zhou. All rights reserved.
//

import Foundation

//监听的Key
enum KWListenerKey : String {
    case none = "none"
    case updateUser = "LISTENER_KEY_UPDATE_USER_INFO"
    case openedApplicationService = "LISTENER_KEY_OPEND_SERVICE"
    case myAdLoaded = "LISTENER_KEY_LOADED_AD"
}


class KWListener: NSObject {
    public static var poster   : KWListenerPoster   = KWListenerPoster()
    public static var register : KWListenerRegister = KWListenerRegister()
    public static var remover  : KWListenerRemover  = KWListenerRemover()
}

//MARK :添加监听
class KWListenerRegister : KWListenerHandle {
    internal func updateUser(target: Any, selector : Selector) {
        addCustomObserver(observer: target, selector: selector, key: .updateUser)
    }
    internal func openedApplicationService(target: Any, selector : Selector) {
        addCustomObserver(observer: target, selector: selector, key: .openedApplicationService)
    }
    internal func myAdLoaded(target: Any, selector : Selector) {
        addCustomObserver(observer: target, selector: selector, key: .myAdLoaded)
    }
}

//MARK : 移除监听
class KWListenerRemover : KWListenerHandle {
    /************************************* 用户信息 *************************************/
    internal func updateUser(target : Any) {
        removeCustomObserver(observer: target, key: .updateUser)
    }
    internal func openedApplicationService(target : Any) {
        removeCustomObserver(observer: target, key: .openedApplicationService)
    }
    internal func myAdLoaded(target : Any) {
        removeCustomObserver(observer: target, key: .myAdLoaded)
    }
    
}

//MARK : 发送监听
class KWListenerPoster : KWListenerHandle {
    
    /************************************* 用户信息 *************************************/
    internal func updateUser() {
        postCustomObserver(key: .updateUser)
    }
    internal func openedApplicationService() {
        postCustomObserver(key: .openedApplicationService)
    }
    internal func myAdLoaded() {
        postCustomObserver(key: .myAdLoaded)
    }
}

//MARK : Base - KWListenerHandle
class KWListenerHandle : NSObject {
    fileprivate func addCustomObserver(observer : Any, selector : Selector, key : KWListenerKey) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: Name(key: key), object: nil)
    }
    
    fileprivate func removeCustomObserver(observer : Any, key : KWListenerKey) {
        NotificationCenter.default.removeObserver(observer, name: Name(key: key), object: nil)
    }
    
    
    fileprivate func postCustomObserver(key : KWListenerKey) {
        NotificationCenter.default.post(name: Name(key: key), object: nil)
    }
    
    private func Name(key : KWListenerKey)->NSNotification.Name {
        return NSNotification.Name(rawValue: key.rawValue)
    }
}
