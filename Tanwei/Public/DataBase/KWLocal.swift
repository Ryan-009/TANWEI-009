//
//  KWApplication.swift
//  KIWI
//
//  Created by li zhou on 2019/11/4.
//  Copyright © 2019 li zhou. All rights reserved.
//

import Foundation
import SQLite

class KWLocal: NSObject {
    fileprivate static let local = KWLocal()
    
    public class func shared() -> KWLocal {return KWLocal.local}
    
    private override init() {}
    
    
}
