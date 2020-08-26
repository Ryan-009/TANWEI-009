//
//  FinishEditControl.swift
//  KIWI
//
//  Created by li zhou on 2019/11/6.
//  Copyright © 2019 li zhou. All rights reserved.
//

import Foundation
import UIKit

class FinishEditControl: UIView {
    public class func shared() -> FinishEditControl {return FinishEditControl.sharedControl}
    private static let sharedControl = FinishEditControl.init()
    
    let Height : CGFloat = 40.0
    var finishButton : UIButton?
    var grayLine : UIView?
    var moveToY : CGFloat?
    
    init() {
        super.init(frame: CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: Height))
    }
    
    func set(_ target : Any, _ action : Selector) {
        
        finishButton = UIButton(frame: CGRect(x: SCREEN_WIDTH - 60, y: 0, width: 60, height: Height))
        finishButton?.setTitle("完成", for: UIControl.State.normal)
        finishButton?.setTitleColor(APPSubjectColor, for: .normal)
        finishButton?.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        finishButton?.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.right
        finishButton?.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        
        grayLine = UIView()
        grayLine?.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 0.5)
        grayLine?.backgroundColor = APPSeparatorColor
        
        backgroundColor = ColorFromHexString("#f2f2f4")
        addSubview(finishButton!)
        addSubview(grayLine!)
        addFinishAction(target : target, action : action)
    }
    
    func addFinishAction(target : Any, action : Selector)  {
        finishButton?.addTarget(target, action: action, for: UIControl.Event.touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(_ pointY : CGFloat) {
        UIApplication.shared.delegate!.window!!.insertSubview(FinishEditControl.shared(), at: 9999)
        FinishEditControl.shared().frame = CGRect(x: 0, y: pointY, width: SCREEN_WIDTH, height: Height)
    }
    
    func hide() {
        FinishEditControl.shared().removeFromSuperview()
        FinishEditControl.shared().frame = CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: Height)
    }
    
    func setKeyboardObserver() {
        NotificationCenter.default.addObserver(FinishEditControl.shared(), selector: #selector(keyboardShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(FinishEditControl.shared(), selector: #selector(keyboardHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardObserver(){
        NotificationCenter.default.removeObserver(FinishEditControl.shared(), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(FinishEditControl.shared(), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardShow(notification : NSNotification) {
        if notification.name ==  UIResponder.keyboardWillShowNotification{
            if let showFrame : CGRect = notification.userInfo!["UIKeyboardFrameEndUserInfoKey"] as? CGRect {
                let finishViewY : CGFloat = showFrame.origin.y - Height
                show(finishViewY)
            }
        }
    }
    
    @objc func keyboardHide(notification : NSNotification) {
        if notification.name == UIResponder.keyboardWillHideNotification {
            hide()
        }
    }
}
