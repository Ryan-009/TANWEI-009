//
//  KWApplication.swift
//  KIWI
//
//  Created by li zhou on 2019/11/4.
//  Copyright © 2019 li zhou. All rights reserved.
//
import Foundation
//默认的解析错误Code
let RMNETWORK_DEFAULT_ERROR_CODE    : Int    = Int.min
let RMNETWORK_DEFAULT_ERROR_CODE64  : Int64  = Int64.min
let RMNETWORK_DEFAULT_ERROR_CODEU32 : UInt32 = UInt32.min

//默认超时时间
let RMNETWORK_DEFAULT_TIME_OUT : TimeInterval = 10

//请求的URL类型
class KWNetworkDefine : NSObject {
    ///URL
    enum URL : String {
        case none               = ""
        
//        case register           = "/user/register"
        case vcode              = "/user/vcode"
        case user               = "/user"
        case devicelist         = "/device/list"
        case faceid             = "/user/faceid"
        case faceidlist         = "/user/faceidlist"
        case resetpassword      = "/user/resetpassword"
        case forgetresetpassword = "/user/forgetresetpassword"
        case forgetpassword     = "/user/forgetpassword"
        case detaillist         = "/device/detaillist"
        case camerasort         = "/device/camera/sort"
        case devicesort         = "device/sort"
        case station            = "/device/station"
        case device             = "/device"
        case camera             = "/device/camera"
        case binding            = "/device/binding"
        case checksn            = "/device/checksn"
        case home               = "/home"
        case loginout           = "/user/loginout"
        case devicecat          = "/devicecat"
        case devicecatlist      = "/devicecat/list"
        case devicecatsort      = "/devicecat/sort"
        
        case login              = "/users/login"
        case getIdeCode         = "/users/getIdeCode"
        case register           = "/users/register"
        case loginByCaptcha     = "/users/loginByCaptcha"
        case getUser            = "/users/getUser"
        case activelist         = "/banners/active-list"
        case search             = "/contents/search"
        case publish            = "/contents/publish"
        case allBanners         = "/banners/allBanners"
        
        case updateUserBaseMsg  = "/users/updateUserBaseMsg"
        case upload             = "/res/upload"
        case searchByUser       = "/contents/searchByUser"
        case blacklist          = "/limits/get-blacklist"
        case opblacklist        = "/limits/op-blacklist"
    }
    
    enum KEY : String {
        
        case contentType        = "Content-Type"
        case none               = ""
        case error              = "error"
        case qop                = "qop"
        case realm              = "realm"
        case nonce              = "nonce"
        
        case appVersion         = "appVersion"
        case statusCode         = "statusCode"
        case methodType         = "methodType"
        case description        = "description"
        case result             = "result"
        //用户登录
        case account            = "account"
        case password           = "password"
        case confirmPassword    = "confirmPassword"
        case from               = "from"
        case userToken          = "userToken"
        case user               = "user"
        case uid                = "uid"
        case userName           = "userName"
        case firstName          = "firstName"
        case lastName           = "lastName"
        case email              = "email"
        case mobile             = "mobile"
        case phone              = "phone"
        case birthday           = "birthday"
        case location           = "location"
        case avatar             = "avatar"
        case faceId             = "faceId"
        case twitter            = "twitter"
        case facebook           = "facebook"
        case other              = "other"
        case desc               = "desc"
        case createdAt          = "createdAt"
        case updatedAt          = "updatedAt"
        case vCode              = "vCode"
        case gender             = "gender"
        case status             = "status"
        //发送验证码
        case mobileOrEmail      = "mobileOrEmail"
        case countryCode        = "countryCode"
        
        //列表信息
        case isManager          = "isManager"
        case home               = "home"
        case homeId             = "homeId"
        case name               = "name"
        case sn                 = "sn"
        case macAddr            = "macAddr"
        case ipAddr             = "ipAddr"
        case catId              = "catId"
        case softwareVer        = "softwareVer"
        case hardwareVer        = "hardwareVer"
        case uuid               = "uuid"
        case sortByHome         = "sortByHome"
        case sortByRoom         = "sortByRoom"
        case cameraList         = "cameraList"
        case deviceList         = "deviceList"
        case modelNo            = "modelNo"
        case type               = "type"
        case attributes         = "attributes"
        case station            = "station"
        case stationId          = "stationId"
        case icon               = "icon"
        //faceID上传
        case faceid             = "faceid"
        case faceidCode         = "faceidCode"
        //faceid列表列表信息
        case faceidLists        = "faceidLists"
        case faceidList         = "faceidList"
        
        
        //用户修改密码
        case oldPassword        = "oldPassword"
        //用户忘记密码修改
        case smsOrEmailVcode    = "smsOrEmailVcode"
        case forgetToken        = "forgetToken"
        
        //camera 排序
        case sortByHomes        = "sortByHomes"
        case sortByRooms        = "sortByRooms"
        case key                = "key"
        //设备分组列表
        case created_at         = "created_at"
        case deviceCatList      = "deviceCatList"
        case sort               = "sort"
        case id                 = "id"
        
        //设备分组添加、更新、删除
        case deviceSns          = "deviceSns"
        case validate           = "validate"
        
        
        case captcha        = "captcha"
        case userId         = "userId"
        case userid         = "userid"
        case token          = "token"
        case data           = "data"
        case msg            = "msg"
        case code           = "code"
        
        case bannerItemList = "bannerItemList"
        case bannerDesc = "bannerDesc"
        case bannerId = "bannerId"
        case bannerName = "bannerName"
        case createTime = "createTime"
        case imageUrl = "imageUrl"
        
        case contentDtoList = "contentDtoList"
        case author = "author"
        case company = "company"
        case credit = "credit"
        case photoUrl = "photoUrl"
        case companyPortal = "companyPortal"
        case content = "content"
        case imgResIds = "imgResIds"
        case keywords = "keywords"
        case profession = "profession"
        case region = "region"
        case reward = "reward"
        case total  = "total"
        case start  = "start"
        case limit  = "limit"
        case traceId = "traceId"
        case label = "label"
        case website = "website"
        case username = "username"
        
        
        case border = "border"
        case delFlag = "delFlag"
        case isShow = "isShow"
        case resId = "resId"
        case updateTime = "updateTime"
        case winsDt = "winsDt"
        case maxReward = "maxReward"
        case iconImage = "iconImage"
        case image = "image"
        case keyword = "keyword"
        case cPhone = "cPhone"
        case wechatId = "wechatId"
        case jobPosition = "jobPosition"
        case jobDesc = "jobDesc"
        case commanyAddr = "commanyAddr"
        case black_phone = "black_phone"
        case op = "op"
    }
    
    
    //文件类型
    enum gender : Int {
        case unknow = 0
        case man    = 1
        case women  = 2
    }
    enum status : Int {
        case forbid = 0
        case normal = 1
        case unknow = 99
    }
    //设备添加、删除状态码 0：正常 1：添加中 2：添加失败 3：删除中 4：删除失败"
    enum statusCode : Int {
        case unknow = 99
        case normal = 0
        case adding = 1
        case addfailure = 2
        case deleting = 3
        case deletefailure = 4
    }
    //"是否为管理员 0：不是 1：是"
    enum isManagerType : Int {
        case unknow = 99
        case no     = 0
        case yes    = 1
    }
    //类型 0：默认模版 1：用户设备分组 2:camera分组 3:all分组
    enum deviceCatType : Int{
        case defaults    = 0
        case userOperate = 1
        case camera      = 2
        case all         = 3
    }
    
    //"1为合法，0为不合法"
    enum validateType : Int {
        case validate   = 1
        case invalidate = 0
        case unknow     = 99
    }
    
    enum deviceType : String{
        case unknow      = ""
        case atv         = "ATV"
        case extender    = "Extender"
        case camera      = "Camera"
        case sensor      = "Sensor"
        case lock        = "Lock"
        case socket      = "Socket"
        case Switch      = "Switch"
        case Lamp        = "Lamp"
        case panel       = "Multi-Panel"
        case window      = "Window"
        case Curtain     = "Curtain"
        case button      = "One-Touch Alarm"
        case waterTap    = "Water-Tap"
        case valveTap    = "Valve-Tap"
        case appliance   = "Appliance"
        
        init(rawValue:String) {
            if rawValue == "KK" || rawValue == "KP" {
                self = .atv
            } else if rawValue == "KR" || rawValue == "KD" {
                self = .extender
            }else if rawValue == "CA" || rawValue == "CB" || rawValue == "CC" || rawValue == "CD" || rawValue == "CE" || rawValue == "CF" {
                self = .camera
            }else if rawValue == "SP" || rawValue == "SB" || rawValue == "SE" || rawValue == "SW" || rawValue == "SC" || rawValue == "SS" || rawValue == "SD" || rawValue == "ST" || rawValue == "SA" {
                self = .sensor
            } else if rawValue == "LB" || rawValue == "LN" || rawValue == "LM" {
                self = .lock
            }else if rawValue == "TD" || rawValue == "TE" || rawValue == "TF" || rawValue == "TH" || rawValue == "TJ" || rawValue == "TK" || rawValue == "TN" || rawValue == "TP" || rawValue == "TR" {
                self = .socket
            }else if rawValue == "TT" || rawValue == "TU" || rawValue == "TX" || rawValue == "T1" || rawValue == "T2" || rawValue == "T3" {
                self = .Switch
            }else if rawValue == "TL" {
                self = .Lamp
            }else if rawValue == "TA" {
                self = .panel
            }else if rawValue == "TW" {
                self = .window
            }else if rawValue == "TC" {
                self = .Curtain
            }else if rawValue == "BA" {
                self = .button
            }else if rawValue == "VA" {
                self = .waterTap
            }else if rawValue == "VG" {
                self = .valveTap
            }else if rawValue == "AF" || rawValue == "AC" || rawValue == "AT" {
                self = .appliance
            }else{
                self = .unknow
            }
        }
        
    }
}




