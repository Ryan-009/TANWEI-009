//
//  KWApplication.swift
//  KIWI
//
//  Created by li zhou on 2019/11/4.
//  Copyright © 2019 li zhou. All rights reserved.
//

import Foundation
import SQLite

class KWDataSave: NSObject {
    
    var saveCollection   : Connection?
    
    var mapTable : Table = Table(KWSDataSaveDefined.KEY.mapTable.rawValue)
}

extension KWDataSave {
    public func open() {
        let path = KWPath.document(KWSDataSaveDefined.KEY.saveCollection.rawValue + ".db")
        
        do {
            saveCollection = try Connection(path)
        } catch {
            //error
        }
        
        if UnNil(saveCollection) {
            createMapTable()
        }
    }
}

extension KWDataSave {
    fileprivate func createMapTable() {
        do {
            try saveCollection?.run(mapTable.create(block: { (table) in
                table.column(KWSDataSaveDefined.saveKeyType(),  defaultValue: "")
                table.column(KWSDataSaveDefined.saveValueType(),defaultValue: "")
            }))
        } catch {
            //error
        }
    }
}

extension KWDataSave {
    
    //写入 - DDSDataSaveDefined.KEY
    public func write(key : KWSDataSaveDefined.KEY, value : String) {
        write(keyString: key.rawValue, value: value)
    }
    
    //读取 - DDSDataSaveDefined.KEY
    public func read(key : KWSDataSaveDefined.KEY) -> String {
        return read(keyString: key.rawValue)
    }
    
    //移除 - DDSDataSaveDefined.KEY
    public func remove(key : KWSDataSaveDefined.KEY) {
        remove(keyString: key.rawValue)
    }
}

extension KWDataSave {
    //读取 - String
    public func read(keyString : String) -> String {
        guard UnNil(saveCollection) else { return "" }
        
        let wheres = mapTable.filter(KWSDataSaveDefined.saveKeyType() == keyString)
        
        let select = wheres.select(KWSDataSaveDefined.saveValueType())
        
        do {
            for result in try saveCollection!.prepare(select) {
                
                let value = result[KWSDataSaveDefined.saveValueType()]
                
                return value
            }
        } catch { }//DDPrint(error, type: .Database) }
        
        return ""
    }
    
    //写入 - String
    public func write(keyString : String, value : String) {
        guard UnEmpty(read(keyString: keyString)) else {
            //insert
            let insert = mapTable.insert(KWSDataSaveDefined.saveKeyType()   <- keyString,
                                         KWSDataSaveDefined.saveValueType() <- value)
            
            do { try saveCollection?.run(insert) } catch { print(error) }
            
            return
        }
        
        //update
        let wheres = mapTable.filter(KWSDataSaveDefined.saveKeyType() == keyString)
        
        let update = wheres.update(KWSDataSaveDefined.saveValueType() <- value)
        
        do { try saveCollection?.run(update) } catch { print(error) }
    }
    
    //移除 - String
    public func remove(keyString : String) {
        let wheres = mapTable.filter(KWSDataSaveDefined.saveKeyType() == keyString)
        do { try saveCollection?.run(wheres.delete()) } catch {
//            DDPrint(error, type: .Database)
        }
    }
}
