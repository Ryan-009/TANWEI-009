//
//  KWUIListener.swift
//  KIWI
//
//  Created by li zhou on 2019/11/6.
//  Copyright © 2019 li zhou. All rights reserved.
//

import Foundation
//监听的Key
enum KWUIListenerKey : String {
    //register
    case register                   = "LISTENER_KEY_REGISTER_LOGINPARAMETER"
    //languageswitch
    case languageSwitch             = "LISTENER_KEY_GLOBAL_LANGUAGESWITCH"
    //KWDevicesInfo load data
    case deviceInfoLoadData         = "LISTENER_KEY_GLOBAL_DEVICEINFOLOADDATA"
    //Cat load data
    case catInfoLoadData         = "LISTENER_KEY_GLOBAL_CATINFOLOADDATA"
    //分组排序
    case deviceCatSort              = "LISTENER_KEY_DEVICECAT_SORT"
    //选中分组
    case catIndexUpdate              = "LISTENER_KEY_DEVICECAT_CATINDEXUPDATE"
    //接受消息后刷新界面
    case reloadDataAfterGetSate      = "LISTENER_KEY_RELOADDATA_AFTERGETSTATE"
}

class KWUIListener: NSObject {
    public static var poster   : KWUIListenerPoster   = KWUIListenerPoster()
    public static var register : KWUIListenerRegister = KWUIListenerRegister()
    public static var remover  : KWUIListenerRemover  = KWUIListenerRemover()
}

//MARK : Base - DDUIListenerHandle
class KWUIListenerHandle : NSObject {
    fileprivate func addCustomObserver(observer : Any, selector : Selector, key : KWUIListenerKey) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: Name(key: key), object: nil)
    }
    
    fileprivate func removeCustomObserver(observer : Any, key : KWUIListenerKey) {
        NotificationCenter.default.removeObserver(observer, name: Name(key: key), object: nil)
    }
    
    private func Name(key : KWUIListenerKey)->NSNotification.Name {
        return NSNotification.Name(rawValue: key.rawValue)
    }
    
    fileprivate func postCustomObserver(key : KWUIListenerKey) {
        NotificationCenter.default.post(name: Name(key: key), object: nil)
    }
    
    fileprivate func postCustomObserverWithUserInfo(key : KWUIListenerKey,userInfo:[String:Any]) {
        NotificationCenter.default.post(name: Name(key: key), object: nil,userInfo:userInfo)
    }
}

//MARK :添加监听
class KWUIListenerRegister : KWUIListenerHandle {
    /************************************* 注册成功后携带登陆数据到登陆页面 *************************************/
    internal func register(target: Any, selector : Selector) {
        addCustomObserver(observer: target, selector: selector, key: .register)
    }
    internal func languageSwitch(target: Any, selector : Selector) {
        addCustomObserver(observer: target, selector: selector, key: .languageSwitch)
    }
    internal func deviceInfoLoadData(target: Any, selector : Selector) {
        addCustomObserver(observer: target, selector: selector, key: .deviceInfoLoadData)
    }
    internal func catInfoLoadData(target: Any, selector : Selector) {
        addCustomObserver(observer: target, selector: selector, key: .catInfoLoadData)
    }
    internal func deviceCatSort(target: Any, selector : Selector) {
        addCustomObserver(observer: target, selector: selector, key: .deviceCatSort)
    }
    internal func catIndexUpdate(target: Any, selector : Selector) {
        addCustomObserver(observer: target, selector: selector, key: .catIndexUpdate)
    }
    internal func reloadDataAfterGetSate(target: Any, selector : Selector) {
        addCustomObserver(observer: target, selector: selector, key: .reloadDataAfterGetSate)
    }
}

//MARK : 移除监听
class KWUIListenerRemover : KWUIListenerHandle {
    /************************************* 注册成功后携带登陆数据到登陆页面 *************************************/
    internal func register(target : Any) {
        removeCustomObserver(observer: target, key: .register)
    }
    internal func languageSwitch(target : Any) {
        removeCustomObserver(observer: target, key: .languageSwitch)
    }
    internal func deviceInfoLoadData(target : Any) {
        removeCustomObserver(observer: target, key: .deviceInfoLoadData)
    }
    internal func catInfoLoadData(target : Any) {
        removeCustomObserver(observer: target, key: .catInfoLoadData)
    }
    internal func deviceCatSort(target : Any) {
        removeCustomObserver(observer: target, key: .deviceCatSort)
    }
    internal func catIndexUpdate(target : Any) {
        removeCustomObserver(observer: target, key: .catIndexUpdate)
    }
    internal func reloadDataAfterGetSate(target : Any) {
        removeCustomObserver(observer: target, key: .reloadDataAfterGetSate)
    }
}

//MARK : 发送监听
class KWUIListenerPoster : KWUIListenerHandle {
    
    internal func register(userInfo:[String:Any]) {
        postCustomObserverWithUserInfo(key: .languageSwitch, userInfo: userInfo)
    }
    internal func languageSwitch() {
        postCustomObserver(key: .languageSwitch)
    }
    internal func deviceInfoLoadData() {
        postCustomObserver(key: .deviceInfoLoadData)
    }
    internal func catInfoLoadData() {
        postCustomObserver(key: .catInfoLoadData)
    }
    internal func deviceCatSort(userInfo:[String:Any]) {
        postCustomObserverWithUserInfo(key: .deviceCatSort, userInfo: userInfo)
    }
    internal func catIndexUpdate(userInfo:[String:Any]) {
        postCustomObserverWithUserInfo(key: .catIndexUpdate, userInfo: userInfo)
    }
    internal func reloadDataAfterGetSate() {
        postCustomObserver(key: .reloadDataAfterGetSate)
    }
}

