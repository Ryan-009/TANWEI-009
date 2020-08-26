//
//  KWApplication.swift
//  KIWI
//
//  Created by li zhou on 2019/11/4.
//  Copyright © 2019 li zhou. All rights reserved.
//

import Foundation
import SQLite

class KWSDataSaveDefined: NSObject {
    enum KEY : String {
        
        //database
        case saveCollection = "_dd_data_save_collection_"
        
        //table - mapTable
        case mapTable = "_dd_data_save_map_table_"
        
        //column - mapTable
        case saveKey   = "_dd_data_save_key_"
        case saveValue = "_dd_data_save_value_"
        
        //login status
        case userId      = "_dd_data_save_user_id_"
        case token       = "_dd_data_save_user_token_"
        
    }
}

//MARK:saveCollection
extension KWSDataSaveDefined {
    internal class func saveKeyType()-> Expression<String> {
        return Expression<String>(KWSDataSaveDefined.KEY.saveKey.rawValue)
    }
    
    internal class func saveValueType()-> Expression<String> {
        return Expression<String>(KWSDataSaveDefined.KEY.saveValue.rawValue)
    }
}
