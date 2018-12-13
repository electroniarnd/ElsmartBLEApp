//
//  ELCBHelper.swift
//  ElsmartBLEApp
//
//  Created by Mahak_Mobiloitte on 27/04/18.
//  Copyright © 2018 Mahak_Mobiloitte. All rights reserved.
//

import UIKit
import CoreBluetooth



class ELCBHelper: NSObject {

    var centralManager:CBCentralManager!
    
    class var sharedInstance: ELCBHelper {
        struct Static {
            static let instance: ELCBHelper = ELCBHelper()
        }
        return Static.instance
    }
    
}
