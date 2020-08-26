//
//  CPButton.swift
//  RedsMeme
//
//  Created by reds on 2016/12/27.
//  Copyright © 2016年 Reds. All rights reserved.
//

import Foundation
import UIKit

///通常用于特定的场景，比如点击获取验证码后，执行禁止重复获取
extension UIButton {
    
    //执行时调用
    private typealias RunningAction = (_ second : Int, _ sender : UIButton) -> Void
    
    //执行结束调用
    private typealias TimeUpAction = (_ sender : UIButton) -> Void
    
    //回调
    private class ExcuteAction {
        var timeUpAction : TimeUpAction?
        var runningAction : RunningAction?
    }
    
    //计数类型
    private enum counterType {
        case none       //初始
        case increase   //递增
        case reduce     //递减
    }
    
    //block - ExcuteAction
    private var excuteAction : ExcuteAction {
         get {
            if let action = objc_getAssociatedObject(self,PrototypeKey.excuteActionKey!) as? ExcuteAction {
                return action
            } else {
                return ExcuteAction()
            }
        }
        
        set {
            objc_setAssociatedObject(self, PrototypeKey.excuteActionKey!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    //属性Key
    private struct PrototypeKey {
        //计数器
        static let counterKey = UnsafeRawPointer.init(bitPattern: "PROTOTYPE_KEY_BUTTON_COUNTER".hashValue)
        //开始数
        static let startSecondKey = UnsafeRawPointer.init(bitPattern: "PROTOTYPE_KEY_BUTTON_START_SECOND".hashValue)
        //结束数
        static let endSecondKey = UnsafeRawPointer.init(bitPattern: "PROTOTYPE_KEY_BUTTON_END_SECOND".hashValue)
        //计数器类型
        static let counterTypeKey = UnsafeRawPointer.init(bitPattern: "PROTOTYPE_KEY_BUTTON_COUNT_TYPE".hashValue)
        //保存title
        static let saveTitleKey = UnsafeRawPointer.init(bitPattern: "PROTOTYPE_KEY_BUTTON_CURRENT_TITLE".hashValue)
        //block
        static let excuteActionKey = UnsafeRawPointer.init(bitPattern: "PROTOTYPE_KEY_BUTTON_EXCUTE_ACTION".hashValue)
    }

    //开始秒数
    private var startSecond : Int {
        get {
            if let value = objc_getAssociatedObject(self,PrototypeKey.startSecondKey!) as? Int {
                return value
            } else {
                return 0
            }
        }
        
        set {
            objc_setAssociatedObject(self, PrototypeKey.startSecondKey!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    //结束秒数
    private var endSecond : Int {
        get {
            if let value = objc_getAssociatedObject(self,PrototypeKey.endSecondKey!) as? Int {
                return value
            } else {
                return 0
            }
        }
        
        set {
            objc_setAssociatedObject(self, PrototypeKey.endSecondKey!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    //计时器
    private var counter : Timer {
        get {
            if let value = objc_getAssociatedObject(self,PrototypeKey.counterKey!) as? Timer {
                return value
            } else {
                return Timer()
            }
        }
        
        set {
            objc_setAssociatedObject(self, PrototypeKey.counterKey!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    //计时器
    private var type : counterType {
        get {
            if let value = objc_getAssociatedObject(self,PrototypeKey.counterTypeKey!) as? counterType {
                return value
            } else {
                return counterType.increase
            }
        }
        
        set {
            objc_setAssociatedObject(self, PrototypeKey.counterTypeKey!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
    //保存title
    private var saveTitle : String {
        get {
            if let value = objc_getAssociatedObject(self,PrototypeKey.saveTitleKey!) as? String {
                return value
            } else {
                return ""
            }
        }
        
        set {
            objc_setAssociatedObject(self, PrototypeKey.saveTitleKey!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    ///
    /// public func counterOpen()
    /**
     Open counter
     */
    /// - parameter interval: - Time interval for each execution
    ///
    /// - parameter start: - Initial count values, will increase or decrease with interval
    ///
    /// - parameter end: - The maximum or minimum of count，When start equals or exceeds end, the program ends
    ///
    /// - returns: UIButton
    ///
    public func counterOpen(interval : TimeInterval, start : Int, end : Int) -> UIButton {
        
        reset()
        
        if start > end {
            type = .reduce
        } else if start < end {
            type = .increase
        } else {
            type = .none
        }
        
        if type == .none {
            return self
        }
        
        startSecond = start
        
        endSecond = end
        
        if let text = titleLabel?.text {
            saveTitle = text
        }
        
        if type == .reduce{
            counter = Timer(timeInterval: interval, target: self, selector: #selector(secondDescending), userInfo: nil, repeats: true)
        } else if type == .increase {
            counter = Timer(timeInterval: interval, target: self, selector: #selector(secondIncrease), userInfo: nil, repeats: true)
        } else {
            return self
        }
        
        counter.fireDate = Date()
        
        RunLoop.main.add(counter, forMode: .common)
        
        return self
    }
    
    ///
    /// public func counterClose()
    /**
     Close counter
     */
    /// - returns: Void
    ///
    public func counterClose() {
        reset()
    }
    
    ///
    /// public func counterTimeUp()
    /**
     At the end of the count,"action" will be executed
     */
    /// - parameter action: - At the end of the count,"action" will be executed
    ///
    /// - parameter sender: - UIButton
    ///
    /// - returns: Void
    ///
    public func counterTimeUp(action : @escaping (_ sender : UIButton)->()) {
        if type != .none {
            excuteAction.timeUpAction = action
        }
    }
    
    ///
    /// public func counterTimeRun()
    /**
     It will be executed every time interval
     */
    /// - parameter action: - "action" will be executed every time interval
    ///
    /// - parameter second: - Number of current execution cycle counts
    ///
    /// - parameter sender: - UIButton
    ///
    /// - returns: UIButton
    ///
    public func counterTimeRun(action : @escaping (_ second : Int , _ sender : UIButton)->()) -> UIButton {
        if type != .none {
            excuteAction.runningAction = action
        }
        return self
    }
    
    ///
    /// public func counterTimeStart()
    /**
     Execution at the beginning of the counter, will be slightly delayed, usually does not affect the normal use
     */
    /// - parameter action: - Execution at the beginning of the counter, will be slightly delayed,
    ///
    /// - parameter sender: - UIButton
    ///
    /// - returns: UIButton
    ///
    public func counterTimeStart(action : (_ sender : UIButton)->()) -> UIButton {
        if type != .none {
            action(self)
        }
        return self
    }
    
    ///递增
    @objc private func secondIncrease() {
        startSecond = startSecond + 1
        
        if startSecond > endSecond {
            
            counter.fireDate = Date.distantFuture
            
            resetTitle()
            
            if excuteAction.timeUpAction != nil {
                excuteAction.timeUpAction!(self)
            }
        } else {
            
            if excuteAction.runningAction != nil {
                excuteAction.runningAction!(startSecond,self)
            }
            
         //   setTitle(second: startSecond)
        }
    }
    
    ///递减
    @objc private func secondDescending() {
        startSecond = startSecond - 1
        
        if startSecond < endSecond {
            
            counter.fireDate = Date.distantFuture
            
            resetTitle()
            
            if excuteAction.timeUpAction != nil {
                excuteAction.timeUpAction!(self)
            }
        } else {
            
            if excuteAction.runningAction != nil {
                excuteAction.runningAction!(startSecond,self)
            }
            
           // setTitle(second: startSecond)
        }
    }
    
    //设置title
    private func setTitle(second : Int) {
//        let title = String(format: "%ds", second)
//        setTitle(title, for: UIControlState.normal)
    }
    
    //重置title
    private func resetTitle() {
//        setTitle(saveTitle, for: UIControlState.normal)
    }
    
    //重置所有属性
    private func reset() {
        counter.fireDate = Date.distantFuture
        
        counter.invalidate()

        excuteAction = ExcuteAction()
        
        type = .none
        
        startSecond = 0
        
        endSecond = 0
        
       
        /*
        if let text = titleLabel?.text {
            saveTitle = text
        }
        */
    }
}
