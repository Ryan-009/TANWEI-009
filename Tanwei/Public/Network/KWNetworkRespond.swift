//
//  KWApplication.swift
//  KIWI
//
//  Created by li zhou on 2019/11/4.
//  Copyright © 2019 li zhou. All rights reserved.
//

import Foundation
import SwiftyJSON

class KWNetworkRespond : NSObject {
    var code : Int = RMNETWORK_DEFAULT_ERROR_CODE
    var msg : String = ""
    var data : Dictionary<String, JSON> = Dictionary()
    //设备列表信息接口result是数组类型
    var resultArray : [JSON] = []
    //当产生parseError时，此字段有值,服务器的直接返回
    var value : Any?
}
