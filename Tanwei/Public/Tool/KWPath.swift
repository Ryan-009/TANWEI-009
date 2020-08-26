//
//  KWApplication.swift
//  KIWI
//
//  Created by li zhou on 2019/11/4.
//  Copyright © 2019 li zhou. All rights reserved.
//

import Foundation

class KWPath : NSObject {
    public class func document(_ fileName : String) -> String {
        let docPaths : Array = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let docPath : String? = docPaths.first
        
        if UnNil(docPath) {
            return docPath! + "/" + fileName
        } else {
            return ""
        }
    }
}

