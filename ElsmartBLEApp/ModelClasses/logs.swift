//
//  logs.swift
//  ElsmartBLEApp
//
//  Created by El-00349 on 12/12/2018.
//  Copyright © 2018 Mahak_Mobiloitte. All rights reserved.
//

import UIKit

class logs {
    
    var id: Int
    var badgeNo: String?
    var date: String?
    var ter: String?
    var direction: String?
    
    init( id: Int, date: String?, badgeNo: String?,  ter: String?, direction: String?){
       
        self.id = id
         self.date = date
        self.badgeNo = badgeNo
        self.ter = ter
        self.direction = direction
        
        
    }
}



