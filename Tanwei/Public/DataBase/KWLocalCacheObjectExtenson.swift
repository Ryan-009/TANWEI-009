//
//  KWApplication.swift
//  KIWI
//
//  Created by li zhou on 2019/11/4.
//  Copyright © 2019 li zhou. All rights reserved.
//

import Foundation
import SQLite

//缓存 对象 [个人专辑墙 图片 视频 动态]
extension KWLocal {
    
    //插入一个对象
//    internal func insertCacheObject(cacheObject : KWCacheObject, cacheType : Int, objectType : Int) {
//        let wheres = cacheObjectTable.filter (
//            DDLocalDefine.cacheIdType()    == cacheObject.materialId &&
//                DDLocalDefine.cacheTypeType()  == cacheType &&
//                DDLocalDefine.objectTypeType() == objectType
//        )
//
//        let select = wheres.select(DDLocalDefine.cacheIdType())
//
//        do { for _ in try userConnection!.prepare(select) { return } } catch { }
//
//        let insert = cacheObjectTable.insert(DDLocalDefine.objectType()     <- cacheObject.object,
//                                             DDLocalDefine.cacheIdType()    <- cacheObject.materialId,
//                                             DDLocalDefine.cacheTypeType()  <- cacheType,
//                                             DDLocalDefine.objectTypeType() <- objectType,
//                                             DDLocalDefine.isSuccessType()  <- cacheObject.isSuccess
//        )
//        if UnNil(userConnection) {
//            do { try userConnection?.run(insert) } catch { print(error) }
//        }
//    }
//
//    //删除一个对象
//    internal func deleteCacheObject(cacheId : String, cacheType : Int, objectType : Int) {
//        let wheres = cacheObjectTable.filter (
//            DDLocalDefine.cacheIdType()    == cacheId &&
//                DDLocalDefine.cacheTypeType()  == cacheType &&
//                DDLocalDefine.objectTypeType() == objectType
//        )
//        let delete = wheres.delete()
//
//        if UnNil(userConnection) {
//            do { try userConnection?.run(delete) } catch { print(error) }
//        }
//    }
//
//    //更新一个对象状态
//    internal func updateCacheObjectStatus(cacheObject : DDCacheObject, cacheType : Int, objectType : Int) {
//        let wheres = cacheObjectTable.filter (
//            DDLocalDefine.cacheIdType()    == cacheObject.materialId &&
//                DDLocalDefine.cacheTypeType()  == cacheType &&
//                DDLocalDefine.objectTypeType() == objectType
//        )
//
//        let update = wheres.update(DDLocalDefine.isSuccessType() <- cacheObject.isSuccess,
//                                   DDLocalDefine.objectType() <- cacheObject.object)
//
//        if UnNil(userConnection) {
//            do {  _ = try userConnection?.run(update) } catch { DDPrint("DDLocal - updateCacheObjectStatus - Error!" + " \(error)", type: .Database)}
//        }
//    }
//
//    //更新一个对象id
//    internal func updateCacheObjectId(cacheId : String, newCacheId : String, cacheType : Int, objectType : Int) {
//        let wheres = cacheObjectTable.filter (
//            DDLocalDefine.cacheIdType()    == cacheId &&
//                DDLocalDefine.cacheTypeType()  == cacheType &&
//                DDLocalDefine.objectTypeType() == objectType
//        )
//        let update = wheres.update(DDLocalDefine.cacheIdType() <- newCacheId)
//
//        if UnNil(userConnection) {
//            do {  _ = try userConnection?.run(update) } catch { }
//        }
//    }
//
//    //查询单个对象
//    internal func selectCacheObject(cacheId : String, cacheType : Int, objectType : Int) ->Dictionary<String,Any> {
//        let wheres = cacheObjectTable.filter (
//            DDLocalDefine.cacheIdType()    == cacheId &&
//                DDLocalDefine.cacheTypeType()  == cacheType &&
//                DDLocalDefine.objectTypeType() == objectType
//        )
//
//        let select = wheres.select(DDLocalDefine.objectType(),
//                                   DDLocalDefine.cacheIdType(),
//                                   DDLocalDefine.cacheTypeType(),
//                                   DDLocalDefine.isSuccessType())
//
//        do {
//            if UnNil(userConnection) {
//                for info in try userConnection!.prepare(select) {
//                    return DDParse.stringToDictionary(info[DDLocalDefine.objectType()])
//                }
//            }
//        } catch { }
//
//        return Dictionary()
//    }
//
//    //查询对象
//    internal func selectCacheObject(cacheId : String) ->Dictionary<String,Any> {
//        let wheres = cacheObjectTable.filter (DDLocalDefine.cacheIdType() == cacheId)
//
//        let select = wheres.select(DDLocalDefine.objectType(),
//                                   DDLocalDefine.cacheIdType(),
//                                   DDLocalDefine.cacheTypeType(),
//                                   DDLocalDefine.isSuccessType())
//
//        do {
//            if UnNil(userConnection) {
//                for info in try userConnection!.prepare(select) {
//                    return DDParse.stringToDictionary(info[DDLocalDefine.objectType()])
//                }
//            }
//        } catch { }
//
//        return Dictionary()
//    }
//
//    ///查询某个类型的所有对象
//    internal func selectCacheObjects(cacheType : Int, objectType : Int, isSuccess : Bool) -> Array<Dictionary<String,Any>> {
//        let wheres = cacheObjectTable.filter(
//            DDLocalDefine.cacheTypeType() == cacheType &&
//                DDLocalDefine.isSuccessType() == isSuccess &&
//                DDLocalDefine.objectTypeType() == objectType
//        )
//
//        let select = wheres.select(DDLocalDefine.objectType(),
//                                   DDLocalDefine.cacheIdType(),
//                                   DDLocalDefine.cacheTypeType(),
//                                   DDLocalDefine.isSuccessType())
//
//        var infos : Array<Dictionary<String,Any>> = Array()
//
//        do {
//            if UnNil(userConnection) {
//                for info in try userConnection!.prepare(select) {
//                    infos.append(DDParse.stringToDictionary(info[DDLocalDefine.objectType()]))
//                }
//            }
//        } catch { }
//
//        return infos
//    }
//
//    ///查询某个类型的个体对象 区分成功失败
//    internal func selectCacheObject(cacheId : String, cacheType : Int, objectType : Int, isSuccess : Bool) -> Dictionary<String,Any>? {
//        let wheres = cacheObjectTable.filter(
//            DDLocalDefine.cacheIdType() == cacheId &&
//                DDLocalDefine.cacheTypeType() == cacheType &&
//                DDLocalDefine.isSuccessType() == isSuccess &&
//                DDLocalDefine.objectTypeType() == objectType
//        )
//
//        let select = wheres.select(DDLocalDefine.objectType(),
//                                   DDLocalDefine.cacheIdType(),
//                                   DDLocalDefine.cacheTypeType(),
//                                   DDLocalDefine.isSuccessType())
//
//        do {
//            if UnNil(userConnection) {
//                for info in try userConnection!.prepare(select) {
//                    return  DDParse.stringToDictionary(info[DDLocalDefine.objectType()])
//                }
//            }
//        } catch { }
//
//        return nil
//    }
}
