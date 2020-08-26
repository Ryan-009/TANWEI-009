//
//  KWApplication.swift
//  KIWI
//
//  Created by li zhou on 2019/11/4.
//  Copyright © 2019 li zhou. All rights reserved.
//

import Foundation
//MARK:类 - 直接调用初始化，不需要任何配置
class KWNetworkResendConfig : NSObject {
    enum ResendStatus {
        case send
        case sleep
    }
    
    typealias ResendTask = ()->()
    
    //任务
    var task : ResendTask?
    
    //发送状态
    fileprivate var status : ResendStatus = .sleep
    
    //任务控制
    fileprivate var taskControl : Timer!
    
    //重试次数
    fileprivate var count : Int = 0
    
    //重试时间
    fileprivate var interval : TimeInterval = 0
    
    ///直接调用初始化
    init(interval : Double, resendCount : Int) {
        super.init()
        initializeSelf(interval : interval, resendCount : resendCount)
    }
    
    //分配identifier
    private func initializeSelf(interval : Double, resendCount : Int) {
        
        self.count = resendCount
        
        self.interval = interval
        
        if interval <= 0 {
            self.count = -1
            return
        }
        
        self.taskControl = Timer(timeInterval: interval, target: self, selector: #selector(excuteTask), userInfo: nil, repeats: true)
        RunLoop.main.add(self.taskControl, forMode: .common)
        self.taskControl.fireDate = Date.distantFuture
    }
}

//MARK:任务设置
extension KWNetworkResendConfig {
    ///执行任务
    @objc fileprivate func excuteTask() {
        if task != nil && self.count >= 0 {
            task!()
            pauseTask()
        }
    }
    
    ///开始任务
    fileprivate func startTask() {
        self.count = self.count - 1
        self.taskControl.fireDate = Date(timeIntervalSinceNow: self.interval)
    }
    
    ///停止任务
    fileprivate func stopTask() {
        pauseTask()
        task = nil
        count = -1
        self.taskControl.invalidate()
    }
    
    //暂停任务
    fileprivate func pauseTask() {
        self.taskControl.fireDate = Date.distantFuture
    }
    
}

///对外接口 Task
extension KWNetworkResendConfig  {
    
    ///重发
    internal func resendIfNeed() ->Bool {
        
        if count <= 0 {
            stopTask()
            return false
        }
        
        startTask()
        
        return true
    }
    
    ///取消重发任务
    internal func cancelResend() {
        stopTask()
    }
    
    //设置为发送状态
    internal func statusSend() {
        status = .send
    }
    
    //是否正在发送 主要判断重发时，是否是当前对象
    internal func isSend() ->Bool {
        return self.status == .send
    }
}
