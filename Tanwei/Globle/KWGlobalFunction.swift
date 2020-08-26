//
//  KWGlobalFunction.swift
//  KIWI
//
//  Created by li zhou on 2019/11/4.
//  Copyright © 2019 li zhou. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

public func KWPrint(_ info : Any) {
    print(info)
}


internal func ColorFromHexString(_ colorStr:String) -> UIColor {
    
    var color = UIColor.red
    var cStr : String = colorStr.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
    
    if cStr.hasPrefix("#") {
        let index = cStr.index(after: cStr.startIndex)
        cStr = cStr.substring(from: index)
    }
    if cStr.count != 6 {
        return UIColor.black
    }
    
    let rRange = cStr.startIndex ..< cStr.index(cStr.startIndex, offsetBy: 2)
    let rStr = cStr.substring(with: rRange)
    
    let gRange = cStr.index(cStr.startIndex, offsetBy: 2) ..< cStr.index(cStr.startIndex, offsetBy: 4)
    let gStr = cStr.substring(with: gRange)
    
    let bIndex = cStr.index(cStr.endIndex, offsetBy: -2)
    let bStr = cStr.substring(from: bIndex)
    
    var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
    Scanner(string: rStr).scanHexInt32(&r)
    Scanner(string: gStr).scanHexInt32(&g)
    Scanner(string: bStr).scanHexInt32(&b)
    
    color = UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha:CGFloat(1))
    
    return color
}

//设置右bar button
func SetRightBarButtonItem(imageName:String,title:String,textColor:UIColor,target:Any,action:Selector) -> UIBarButtonItem{
    let btn = UIButton(type: .custom)
    btn.titleLabel?.font = UIFont.systemFont(ofSize: AutoW(16))
    btn.setImage( UIImage(named: imageName), for: .normal)
    btn.setTitleColor(UIColor(red: 81/255, green: 81/255, blue: 81/255, alpha: 1), for: .normal)
    btn.addTarget(target, action: action, for: .touchUpInside)
    btn.setTitle(title, for: .normal)
    btn.setTitleColor(textColor, for: .normal)
    btn.contentMode = .scaleAspectFit
    if title != "" {//如果设置的是文字 根据文字的长度决定按钮的大小
        btn.frame.size = CGSize(width: CalStringWidth(str: title, width: SCREEN_WIDTH, fontSize: AutoW(16)).width+AutoW(8), height: 40)
    }else{
        btn.frame.size = CGSize(width: 30, height: 40)
    }
    //  button 里的内容左对齐
    btn.contentHorizontalAlignment = .right
    btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    return UIBarButtonItem.init(customView: btn)
}

//设置左bar button
func SetBackBarButtonItem(target:Any,action:Selector,imageName:String) -> UIBarButtonItem{
    
    let button = UIButton.init(type: .custom)
    button.setImage(UIImage(named: imageName), for: .normal)
    button.setTitleColor(UIColor(red: 81/255, green: 81/255, blue: 81/255, alpha: 1), for: .normal)
    button.addTarget(target, action: action, for: .touchUpInside)
    button.frame.size = CGSize(width: 64, height: 44)
    //  button 里的内容左对齐
    button.contentHorizontalAlignment = .left
    button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    return UIBarButtonItem.init(customView: button)
}

func SubCityString(city:String) -> String {
    var c = city
    if let range = c.range(of: "市") {
        c.replaceSubrange(range, with: "")
        return c
    }
    return c
}





func CalStringWidth(str:String,width:CGFloat,fontSize:CGFloat) -> CGSize{
    // 计算字符串的宽度，高度
    let string:String = str
    if let font:UIFont = UIFont(name: "EuphemiaUCAS", size: fontSize) {
        let attributes  = [NSAttributedString.Key.font:font]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let rect:CGRect = string.boundingRect(with: CGSize(width: width, height: SCREEN_HEIGHT), options: option, attributes: attributes, context: nil)
        return rect.size
    }
    
    return CGSize.zero
}

internal func GetNormalTime(utime: Int64,style : String) -> String {
    let formatter = DateFormatter()
    
    if style == "MD"{
        formatter.dateFormat = "MM-dd"
    }else if style == "HM"{
        formatter.dateFormat = "HH:mm"
    }else if style == "M" {
        formatter.dateFormat = "MM"
    }else if style == "D" {
        formatter.dateFormat = "DD"
    }else if style == "MDHM" {
        formatter.dateFormat = "MM-dd HH:mm"
    }else if style == "YMDHM" {
        formatter.dateFormat = "YYYY-MM-dd HH:mm"
    }else if style == "YMD" {
        formatter.dateFormat = "YYYY-MM-dd"
    }
    
    let date = NSDate(timeIntervalSince1970: Double(utime/1000))
    return formatter.string(from: date as Date)
}

func StringToTimeStamp(stringTime:String)->Int {
    let dfmatter = DateFormatter()
    dfmatter.dateFormat="yyyy-MM-dd HH:mm:ss"
    let date = dfmatter.date(from: stringTime)
    let dateStamp:TimeInterval = (date ?? Date()).timeIntervalSince1970
    let dateSt:Int = Int(dateStamp)
    return dateSt
}

func StringToTimeInterval(stringTime:String)->TimeInterval {
    let dfmatter = DateFormatter()
    dfmatter.dateFormat="yyyy-MM-dd HH:mm:ss"
    let date = dfmatter.date(from: stringTime)
    let dateStamp:TimeInterval = (date ?? Date()).timeIntervalSince1970
    return dateStamp
}

func IsTimeStringBigThanNow(stringTime:String) -> Bool{
    //获取当前时间
    let now = NSDate()
    //当前时间的时间戳
    let timeInterval:TimeInterval = now.timeIntervalSince1970
    let timeStamp = Int(timeInterval)
    return false
}

//把秒转换成时间格式
internal func ChangeTimeToFormateString(time:Int) -> String {

    let timeCount = time
    let day  = timeCount / (60*60*24)
    let hour = (timeCount%(60*60*24)) / (60*60)
    let minute = (timeCount%3600)/60
    let second = timeCount%60
 
    if day > 0 {
        return String.init(format: "%02d", day)+"天 "+String.init(format: "%02d", hour)+":"+String.init(format: "%02d", minute)+":"+String.init(format: "%02d", second)
    }
    
    return String.init(format: "%02d", hour)+":"+String.init(format: "%02d", minute)+":"+String.init(format: "%02d", second)
}

//xxx xxxx xxxx转回原手机号码
internal func OriginalTelephone(tel:String?) -> String {
    let telphone : String = tel ?? ""
    let strs = telphone.components(separatedBy: " ")
    var result = ""
    if strs.count > 0 {
        for i in strs  {
            result += i
        }
    }
    return result
//    if tel.characters.count == 13 {
//        let start = tel.index(tel.startIndex, offsetBy: 3)
//        let oneString = tel.substring(to: start)
//
//        let start2 = tel.index(tel.startIndex, offsetBy: 4)
//        let end2 = tel.index(tel.startIndex, offsetBy: 8)
//        let twoString = tel.substring(with: Range(uncheckedBounds: (start2, end2)))
//
//        let start3 = tel.index(tel.startIndex, offsetBy: 9)
//        let end3 = tel.index(tel.startIndex, offsetBy: 13)
//        let threeString = tel.substring(with: Range(uncheckedBounds: (start3, end3)))
//
//        return oneString+twoString+threeString
//    }else{
//        return tel
//    }
}
//手机号码格式化为xxx xxxx xxxx
internal func FormateTelephone(tel:String) -> String {
    
    if tel.count == 11 {
        let start = tel.index(tel.startIndex, offsetBy: 3)
        let oneString = tel.substring(to: start)
        
        let start2 = tel.index(tel.startIndex, offsetBy: 3)
        let end2 = tel.index(tel.startIndex, offsetBy: 7)
        let twoString = tel.substring(with: Range(uncheckedBounds: (start2, end2)))
        
        let start3 = tel.index(tel.startIndex, offsetBy: 7)
        let end3 = tel.index(tel.startIndex, offsetBy: 11)
        let threeString = tel.substring(with: Range(uncheckedBounds: (start3, end3)))
        
        return oneString+" "+twoString+" "+threeString
    }else{
        return tel
    }
}

//截取字符串中¥后面的数字 例如：¥：123
func StringToFloat(str:String) -> CGFloat{
    
    let string = str.components(separatedBy: "¥：")
    var cgFloat: CGFloat = 0
    
    if let doubleValue = Double(string.last ?? "")
    {
        cgFloat = CGFloat(doubleValue)
    }
    return cgFloat
}
//截取字符串中¥后面的数字 例如：¥：123
func StringToInt(str:String) -> Int{
    let string = str.components(separatedBy: "¥：")
    var cgFloat: CGFloat = 0
    if let doubleValue = Double(string.last ?? "")
    {
        cgFloat = CGFloat(doubleValue)*100
    }
    let intValue = Int(cgFloat)
    return intValue
}
//获取json字符串
func GetJSONStringFromDictionary(dictionary:NSDictionary) -> NSString {
    if (!JSONSerialization.isValidJSONObject(dictionary)) {
        print("无法解析出JSONString")
        return ""
    }
    let data : NSData! = try? JSONSerialization.data(withJSONObject: dictionary, options: JSONSerialization.WritingOptions.prettyPrinted) as NSData?
    
    let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
    
    return JSONString!
}
//单位为分 转成 元
func GetRealPrice(price:Int) -> CGFloat {
    let p = CGFloat(price)
    
    return p/100.00
}

func GetRealPriceString(price:Int) -> String {
    let p = CGFloat(price)
    
    return String.init(format: "%.2f", p/100.00)
}

//发布商品  适用范围-截取字符串
func GetIntFormString(httpString:String) -> (Int,Int){
    if httpString != "" {
        let str = NSString.init(string: httpString)
        let strs = str.components(separatedBy: "元")
        if strs.count > 2 {
            let str1 = strs[0].replacingOccurrences(of: "最低消费满", with: "")
            _ = strs[1].replacingOccurrences(of: "可用不足", with: "")
            let str3 = strs[2].replacingOccurrences(of: "可抵", with: "")
            
            guard let int1 = Int(str1) else{
                return(0,0)
            }
            
            guard let int3 = Int(str3) else{
                return(0,0)
            }
            return (int1,int3)
        }
    }
    
    return (0,0)
}

//登录
//func PresentTologinFunction() {
//    let vc = DDUserLoginViewController()
//    let nav = DDBaseNavigationController(rootViewController: vc)
//    currentVc().present(nav, animated: true, completion: nil)
//}

//手机号隐秘
internal func GetTelephoneSecurityNumberString(telephone:String) -> String {
    if telephone.lengthOfBytes(using: .utf8) == 11 {
        let start = telephone.index(telephone.startIndex, offsetBy: 3)
        let startString = telephone.substring(to: start)
        
        let start2 = telephone.index(telephone.startIndex, offsetBy: 7)
        let end = telephone.index(telephone.startIndex, offsetBy: 11)
        let endString = telephone.substring(with: Range(uncheckedBounds: (start2, end)))
        
        return startString+"****"+endString
    }else{
        return ""
    }
}

//把字符串以逗号切成字符串数组  去掉最后一个,
func StringToArray(string:String) -> [String] {
    var strs = string.components(separatedBy: ",")
    if strs.count > 0 {
        strs.removeLast()
        return strs
    }
    return []
}

func Regex_areaCode_fourDigit() -> String{
    let fourDigit03 = "03([157]\\d|35|49|9[1-68])"
    let fourDigit04 = "04([17]\\d|2[179]|[3,5][1-9]|4[08]|6[4789]|8[23])"
    let fourDigit05 = "05([1357]\\d|2[37]|4[36]|6[1-6]|80|9[1-9])"
    let fourDigit06 = "06(3[1-5]|6[0238]|9[12])"
    let fourDigit07 = "07(01|[13579]\\d|2[248]|4[3-6]|6[023689])"
    let fourDigit08 = "08(1[23678]|2[567]|[37]\\d|5[1-9]|8[3678]|9[1-8])"
    let fourDigit09 = "09(0[123689]|[17][0-79]|[39]\\d|4[13]|5[1-5])"
    
    return NSString.localizedStringWithFormat("%@|%@|%@|%@|%@|%@|%@", fourDigit03,fourDigit04,fourDigit05,fourDigit06,fourDigit07,fourDigit08,fourDigit09) as String
}

func CurrentVc() -> UIViewController {
    let keywindow = UIApplication.shared.keyWindow
    
//    guard let firstView = keywindow?.subviews.first else {
//        return applicationWindow.rootViewController!
//    }
//
//    guard let secondView = firstView.subviews.first else {
//        return applicationWindow.rootViewController!
//    }
    
//    let vc = viewForController(view: secondView)
//    return vc ?? applicationWindow.rootViewController!
    return ViewController()
}

func ViewForController(view:UIView)->UIViewController?{
    var next:UIView? = view
    repeat{
        if let nextResponder = next?.next, nextResponder is UIViewController {
            return (nextResponder as! UIViewController)
        }
        next = next?.superview
    }while next != nil
    return nil
}

func GetAttributeString(orString:String,attString:String,attrs:[NSAttributedString.Key : Any]) -> NSMutableAttributedString{
    let strs = NSString.init(string: orString)
    let str  = NSMutableAttributedString.init(string: orString)
    let rang =  strs.range(of: attString)
    str.addAttributes([NSAttributedString.Key.font:UIFont.systemFont(ofSize: AutoW(13))], range: rang)
    str.addAttributes(attrs, range: rang)
    return str
}

func GetLabHeigh(labelStr:String,font:UIFont,width:CGFloat) -> CGFloat {
    
    let statusLabelText: NSString = labelStr as NSString
    
    let size = CGSize(width: width, height: 2000)
    
    let dic = NSDictionary(object: font, forKey: NSAttributedString.Key.font as NSCopying)
    
    let strSize = statusLabelText.boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: dic as? [NSAttributedString.Key : Any], context: nil).size
    
    return strSize.height
}
