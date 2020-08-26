//
//  KWApplication.swift
//  KIWI
//
//  Created by li zhou on 2019/11/4.
//  Copyright © 2019 li zhou. All rights reserved.
//
import UIKit
import Foundation


class KWSystem: NSObject {
    //初始化
    public class func makeKeyAndVisible(_ delegate : AppDelegate) {
        delegate.window = UIWindow(frame: SCREEN_BOUNDS)
        delegate.window?.backgroundColor = UIColor.white
        delegate.window?.rootViewController = KWMainViewController()
        delegate.window?.makeKeyAndVisible()
        openBaseService()
        perform(#selector(toMainWaitOpenService), on: .main, with: nil, waitUntilDone: true)
    }
    
    //登录
    public class func login(account : String, password : String, result: @escaping (_ resultData : KWNetworkError.ErrorType)->()) {
        KWLogin.loginAndSaveStatus(account: account, password: password, success: { (respond) in
            KWSystem.openApplicationService()
            result(.success)
        }) { (error) in
            result(error)
        }
    }
    
    //登录
    public class func loginByCaptcha(account : String, captcha : String, result: @escaping (_ resultData : KWNetworkError.ErrorType)->()) {
        KWLogin.loginSmsAndSaveStatus(account: account, captcha: captcha, success: { (respond) in
            KWSystem.openApplicationService()
            result(.success)
        }) { (error) in
            result(error)
        }
    }
    
    //注销
    public class func logout() {
        KWLogin.removeLoginType()   //移除登录方式
        KWLogin.removeLoginStatus() //移除登录态
        KWUser.close()              //关闭User 功能
    }
    
    class func loginPresent(_ target:UIViewController) {
        if !KWLogin.existLoginStatus() {
            let vc = SSLoginViewController()
            let nav = KWBaseNavigationController.init(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            target.present(nav, animated: false) {
                if !UnNil(UserDefaults.standard.value(forKey: "ISGUIDEPAGELOADED")) {
                    guidePage()
                }
            }
        }
    }
    
    private class func guidePage() {
        let imageNameArray: [String] = ["引导页01", "引导页02", "引导页03"]
        let guideView = HHGuidePageHUD.init(imageNameArray: imageNameArray, isHiddenSkipButton: true)
        ApplicationWindow.addSubview(guideView)
        UserDefaults.standard.set(true, forKey: "ISGUIDEPAGELOADED")
    }
}

extension KWSystem {
    
    @objc fileprivate class func toMainWaitOpenService() {
        perform(#selector(openService), with: nil, afterDelay: 0)
    }
    
    @objc fileprivate class func openService() {
        if KWLogin.existLoginStatus() {
            KWSystem.openApplicationService()
        }
    }
    
    //打开基础服务 - 无需登录
    fileprivate class func openBaseService(){
        Application.save.open() //打开全局数据库
    }
    
    //打开基础服务 - 需要登录
    fileprivate class func openApplicationService() {
        KWUser.open()
        KWUser.update()
        KWListener.poster.openedApplicationService()
    }
}
