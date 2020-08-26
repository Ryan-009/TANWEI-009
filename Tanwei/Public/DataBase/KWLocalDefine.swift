//
//  KWApplication.swift
//  KIWI
//
//  Created by li zhou on 2019/11/4.
//  Copyright © 2019 li zhou. All rights reserved.
//

import Foundation
import SQLite

class DDLocalDefine: NSObject {
//    enum Table : String {
//        //聊天
//        case chatList    = "_dd_chat_list_"
//        case chatContent = "_dd_chat_content_"
//        case userInfo    = "_dd_user_info_"
//        case unread      = "_dd_unread_count_"
//        
//        //缓存
//        case cacheObject           = "_dd_cache_object_"
//        case cacheDeleteOperation  = "_dd_delete_object_"
//        case cacheReplaceOperation = "_dd_replace_object_"
//    }
//    
//    enum KEY : String {
//        //聊天
//        case from               = "_from_"
//        case to                 = "_to"
//        case seqNo              = "_seqNo_"
//        case chatUserType       = "_chatUserType_"
//        case chatType           = "_chatType_"
//        case text               = "_text_"
//        case chatContent        = "_chatContent_"
//        case msgContentType     = "_msgContentType_"
//        case msgId              = "_msgId_"
//        case msgTime            = "_msgTime_"
//        case hasUnread          = "_hasUnread_"
//        case obj                = "_obj_"
//        case list               = "_list_"
//        case fromMsgId          = "_fromMsgId_"
//        case pageSize           = "_pageSize_"
//        case userId             = "_userId_"
//        case userHeader         = "_userHeader_"
//        case userName           = "_userName_"
//        case age                = "_age_"
//        case telephone          = "_telephone_"
//        case sex                = "_sex_"
//        case desc               = "_desc_"
//        case status             = "_status_"
//        case primaryKey         = "_primary_"
//        case unreadCount        = "_unreadCount_"
//        case nameRemark         = "_nameRemark_"
//        case certificationRole  = "_certificationRole_"
//        
//        //缓存 - 对象 - 删除操作
//        case cacheId        = "_cacheId_"
//        case cacheType      = "_cacheType_"
//        case object         = "_object_"
//        case objectType     = "_objectType_"
//        case isSuccess      = "_isSuccess_"
//        case replaceObject  = "_replaceObject_" //替换操作
//        case operationTime  = "_cacheTime_"     //替换操作
//        case replaceId      = "_replaceId_"     //替换操作
//        case replaceType    = "_replaceType_"   //替换操作
//    }
//    
//    /********* chatContentTableKey and chatlistTableKey *********/
//    internal class func fromType() ->Expression<Int64> {
//        return Expression<Int64>(DDLocalDefine.KEY.from.rawValue)
//    }
//    
//    internal class func toType() ->Expression<Int64> {
//        return Expression<Int64>(DDLocalDefine.KEY.to.rawValue)
//    }
//    
//    internal class func chatUserTypeType()  ->Expression<Int64>  {
//        return Expression<Int64>(DDLocalDefine.KEY.chatUserType.rawValue)
//    }
//    
//    internal class func chatTypeType() ->Expression<Int64>  {
//        return Expression<Int64>(DDLocalDefine.KEY.chatType.rawValue)
//    }
//    
//    internal class func seqNoType() ->Expression<Int64> {
//        return Expression<Int64>(DDLocalDefine.KEY.seqNo.rawValue)
//    }
//    
//    internal class func msgIdType() ->Expression<Int64> {
//        return Expression<Int64>(DDLocalDefine.KEY.msgId.rawValue)
//    }
//    
//    internal class func msgTimeType() ->Expression<Int64> {
//        return Expression<Int64>(DDLocalDefine.KEY.msgTime.rawValue)
//    }
//    
//    internal class func chatContentType() -> Expression<String> {
//        return Expression<String>(DDLocalDefine.KEY.chatContent.rawValue)
//    }
//    
//    internal class func objType() -> Expression<String> {
//        return Expression<String>(DDLocalDefine.KEY.obj.rawValue)
//    }
//    
//    internal class func statusType() ->Expression<Int64>  {
//        return Expression<Int64>(DDLocalDefine.KEY.status.rawValue)
//    }
//    
//    internal class func primaryKeyType()->Expression<Int64>  {
//        return Expression<Int64>(DDLocalDefine.KEY.primaryKey.rawValue)
//    }
//    
//    internal class func nameRemarkKeyType()->Expression<String> {
//        return Expression<String>(DDLocalDefine.KEY.nameRemark.rawValue)
//    }
//    
//    /******************** unreadCountTableKey ********************/
//    
//    internal class func unreadCountType()->Expression<Int>  {
//        return Expression<Int>(DDLocalDefine.KEY.unreadCount.rawValue)
//    }
//    
//    /******************** userInfoTableKey ********************/
//    internal class func userIdType() ->Expression<Int64> {
//        return Expression<Int64>(DDLocalDefine.KEY.userId.rawValue)
//    }
//    
//    internal class func userHeaderType() -> Expression<String> {
//        return Expression<String>(DDLocalDefine.KEY.userHeader.rawValue)
//    }
//    
//    internal class func userNameType() -> Expression<String> {
//        return Expression<String>(DDLocalDefine.KEY.userName.rawValue)
//    }
//    
//    internal class func ageType() ->Expression<Int> {
//        return Expression<Int>(DDLocalDefine.KEY.age.rawValue)
//    }
//    
//    internal class func telephoneType() -> Expression<String> {
//        return Expression<String>(DDLocalDefine.KEY.telephone.rawValue)
//    }
//    
//    internal class func sexType() ->Expression<Int> {
//        return Expression<Int>(DDLocalDefine.KEY.sex.rawValue)
//    }
//    
//    internal class func descType() -> Expression<String> {
//        return Expression<String>(DDLocalDefine.KEY.desc.rawValue)
//    }
//    
//    internal class func certificationRoleType()-> Expression<String> {
//        return Expression<String>(DDLocalDefine.KEY.certificationRole.rawValue)
//    }
//    
//    //object
//    internal class func cacheIdType() ->Expression<String> {
//        return Expression<String>(DDLocalDefine.KEY.cacheId.rawValue)
//    }
//    
//    internal class func isSuccessType() ->Expression<Bool> {
//        return Expression<Bool>(DDLocalDefine.KEY.isSuccess.rawValue)
//    }
//    
//    internal class func cacheTypeType() ->Expression<Int> {
//        return Expression<Int>(DDLocalDefine.KEY.cacheType.rawValue)
//    }
//    
//    internal class func objectType() ->Expression<String> {
//        return Expression<String>(DDLocalDefine.KEY.object.rawValue)
//    }
//    
//    internal class func objectTypeType() ->Expression<Int> {
//        return Expression<Int>(DDLocalDefine.KEY.objectType.rawValue)
//    }
//    
//    //replace
//    internal class func replaceTypeType() ->Expression<Int> {
//        return Expression<Int>(DDLocalDefine.KEY.replaceType.rawValue)
//    }
//    
//    internal class func replaceObjectType() ->Expression<String> {
//        return Expression<String>(DDLocalDefine.KEY.replaceObject.rawValue)
//    }
//    
//    internal class func operationTimeType() ->Expression<Int64> {
//        return Expression<Int64>(DDLocalDefine.KEY.operationTime.rawValue)
//    }
//    
//    internal class func replaceIdType() ->Expression<String> {
//        return Expression<String>(DDLocalDefine.KEY.replaceId.rawValue)
//    }
    
}


