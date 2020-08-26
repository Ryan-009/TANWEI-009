//
//  KWApplication.swift
//  KIWI
//
//  Created by li zhou on 2019/11/4.
//  Copyright © 2019 li zhou. All rights reserved.
//

import Foundation
import SQLite

//缓存 - 删除操作
extension KWLocal {
//    //插入一个删除操作
//    internal func insertDeleteOperation(materialId : String, cacheType : Int) {
//        let wheres = cacheDeleteOperationTable.filter(DDLocalDefine.cacheIdType() == materialId && DDLocalDefine.cacheTypeType() == cacheType)
//        
//        let select = wheres.select(DDLocalDefine.cacheIdType())
//        
//        do { for _ in try userConnection!.prepare(select) { return } } catch { }
//        
//        let insert = cacheDeleteOperationTable.insert(DDLocalDefine.cacheIdType() <- materialId,
//                                                      DDLocalDefine.cacheTypeType() <- cacheType
//        )
//        
//        do { try userConnection?.run(insert) } catch { print(error) }
//    }
//    
//    //删除一个删除操作
//    internal func deleteDeleteOperation(materialId : String, cacheType : Int) {
//        let wheres = cacheDeleteOperationTable.filter(DDLocalDefine.cacheIdType() == materialId && DDLocalDefine.cacheTypeType() == cacheType)
//        let delete = wheres.delete()
//        do { try userConnection?.run(delete) } catch { print(error) }
//    }
//    
//    //查询出删除操作
//    internal func selectDeleteOperation(cacheType : Int) -> Array<String> {
//        
//        let wheres = cacheDeleteOperationTable.filter(DDLocalDefine.cacheTypeType() == cacheType)
//        let select = wheres.select(DDLocalDefine.cacheIdType())
//        
//        var infos : Array<String> = Array()
//        
//        do {
//            for info in try userConnection!.prepare(select) {
//                infos.append(info[DDLocalDefine.cacheIdType()])
//            }
//        } catch { }
//        
//        return infos
//    }
}


//缓存 - 替换操作
extension KWLocal {
    
//    //插入一个替换操作
//    internal func insertReplaceOperation(replaceObject : DDReplaceObject) {
//        //1.验证是否有重复
//        let wheres = cacheReplaceOperationTable.filter(
//            DDLocalDefine.cacheIdType() == replaceObject.cacheId &&
//                DDLocalDefine.replaceTypeType() == replaceObject.replaceType
//        )
//        
//        let select = wheres.select(DDLocalDefine.cacheIdType())
//        do { for _ in try userConnection!.prepare(select) { return } } catch { }
//        
//        //2. 验证通过 可以插入
//        let insert = cacheReplaceOperationTable.insert(DDLocalDefine.cacheIdType() <- replaceObject.cacheId,
//                                                       DDLocalDefine.replaceObjectType() <- replaceObject.object,
//                                                       DDLocalDefine.replaceTypeType() <- replaceObject.replaceType
//        )
//        
//        do { try userConnection?.run(insert) } catch { print(error) }
//    }
//    
//    //更新一个替换操作
//    internal func updateReplaceOperation(replaceObject : DDReplaceObject) {
//        let wheres = cacheReplaceOperationTable.filter(
//            DDLocalDefine.cacheIdType() == replaceObject.cacheId &&
//                DDLocalDefine.replaceTypeType() == replaceObject.replaceType
//        )
//        
//        let update = wheres.update(DDLocalDefine.replaceObjectType() <- replaceObject.object)
//        
//        do { try userConnection?.run(update) } catch { print(error) }
//    }
//    
//    //删除一个替换操作
//    internal func deleteReplaceOperation(cacheId : String, replaceType : Int) {
//        let wheres = cacheReplaceOperationTable.filter(DDLocalDefine.cacheIdType() == cacheId && DDLocalDefine.replaceTypeType() == replaceType)
//        let delete = wheres.delete()
//        do { try userConnection?.run(delete) } catch { print(error) }
//    }
//    
//    //查询出所有的替换操作
//    internal func selectReplaceOperation(replaceType : Int) -> Array<DDReplaceObject> {
//        let wheres = cacheReplaceOperationTable.filter(DDLocalDefine.replaceTypeType() == replaceType)
//        do {
//            var replaceObjects : Array<DDReplaceObject> = Array()
//            for info in try userConnection!.prepare(wheres) {
//                let replaceObject         = DDReplaceObject(cacheId: "", replaceId: "", info: Dictionary<String, String>(), replaceType: .none)
//                replaceObject.cacheId     = info[DDLocalDefine.cacheIdType()]
//                replaceObject.replaceType = info[DDLocalDefine.replaceTypeType()]
//                replaceObject.object      = info[DDLocalDefine.replaceObjectType()]
//                replaceObjects.append(replaceObject)
//            }
//            return replaceObjects
//        } catch { }
//        
//        return Array()
//    }
}
