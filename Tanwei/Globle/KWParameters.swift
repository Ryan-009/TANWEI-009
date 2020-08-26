//
//  KWParameters.swift
//  KIWI
//
//  Created by li zhou on 2019/11/4.
//  Copyright © 2019 li zhou. All rights reserved.
//

import Foundation
import UIKit

let SCREEN_WIDTH                       : CGFloat      = UIScreen.main.bounds.size.width  //屏幕宽
let SCREEN_HEIGHT                      : CGFloat      = UIScreen.main.bounds.size.height //屏幕高
let SCREEN_BOUNDS                      : CGRect       = UIScreen.main.bounds             //屏幕尺寸bounds

let PlaceHolderForUserHeader           : UIImage?     = UIImage(named : "women.png") //头像占位图
let PlaceHolderForPreLoad              : UIImage?     = UIImage(named : "robot")       //普通图片占位图
let PlaceHolderForHomePage             : UIImage?     = UIImage(named : "personal_bg_image.jpg")       //个人页占位图
let PlaceHolderForShare                : UIImage?     = UIImage(named : "share_normal_icon.png")
    //分割线
let SeparatorLine                      : UIImage?     = UIImage(named: "line_item_divider.9")

public func AutoFont(_ size   : CGFloat) -> CGFloat { return size }
public func AutoW   (_ width  : CGFloat) -> CGFloat { return width  * SCREEN_WIDTH  / 375 }
public func AutoH   (_ height : CGFloat) -> CGFloat { return height * SCREEN_HEIGHT / 667 }
public func UnNil   (_ any    : Any?   ) -> Bool    { return any    != nil }
public func UnEmpty (_ string : String?) -> Bool    { return string != nil && string != "" }

let APPSubjectColor            = ColorFromHexString("#0086FF")//主体颜色
let APPBackGroundColor         = ColorFromHexString("#f1f7f8")//背景颜色
let APPGrayBackGroundColor     = ColorFromHexString("#F1F1F1")//背景颜色
let APPItemUnSelectedColor     = ColorFromHexString("#333436")//未选中颜色
let APPSeparatorColor          = ColorFromHexString("#e5e5e5")//分割线颜色

//tabbar item imageName
var ImageNameForNomalHomeItem           = "发现-未选中.png"
var ImageNameForPressHomeItem           = "发现-已选中.png"
var ImageNameForNomalSCENEItem          = "salestar_app_tab_icon_ad_u.png"
var ImageNameForPressSCENEItem          = "salestar_app_tab_icon_ad_s.png"
var ImageNameForNomalSERVERItem         = "server.png"
var ImageNameForPressSERVERItem         = "server_highlight.png"
var ImageNameForNomalPROFILEItem        = "我的-未选中.png"
var ImageNameForPressPROFILEItem        = "我的-已选中.png"

let NavHeight : CGFloat = SCREEN_HEIGHT == 812.0 ? 88 : (SCREEN_HEIGHT == 896.0 ? 88 : 64)
let TabHeight : CGFloat = SCREEN_HEIGHT == 812.0 ? 83 : (SCREEN_HEIGHT == 896.0 ? 83 : 49)
let TabOffset : CGFloat = TabHeight - 49 // ihphoneX与常规机型tabbar的高度差
let StatusBarHeight = UIApplication.shared.statusBarFrame.height
let StatusBarOffset : CGFloat = StatusBarHeight - 20

let ApplicationWindow  : UIWindow = UIApplication.shared.delegate!.window!!


//MARK:- 是否是IPX系列
let IS_IPhoneX_Series = (UIApplication.shared.statusBarFrame.height == 44)
