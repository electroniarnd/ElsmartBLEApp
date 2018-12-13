//
//  validation.swift
//  ElsmartBLEApp
//
//  Created by Suraj_Mobiloitte on 24/04/18.
//  Copyright © 2018 Mahak_Mobiloitte. All rights reserved.
//

import Foundation
import UIKit

let APPDELEGATE = UIApplication.shared.delegate as! AppDelegate
let NSUSERDEFAULT             = UserDefaults.standard





func kWindowWidth() -> CGFloat {
    let bounds = UIScreen.main.bounds
    let width = bounds.size.width
    return width
}

func kWindowHeight() -> CGFloat {
    let bounds = UIScreen.main.bounds
    let height = bounds.size.height
    return height
}


func getMdGetIMEIArray() {
	/*
    var array = STXArray
    array.append(0x21)  //lsb
    array.append(0x00)  //msb
    array.append(DesinationID)
    array.append(SourceID)
    for byte in FixedVal {
        array.append(byte)
    }
    for byte in cmdGetIMEI {
        array.append(byte)
    }
    for byte in cmdForMdGetIMEIBLEPAcket {
        array.append(byte)
    }
    getCheckSum(array: array)
    array.append(ETX)
*/
	
    
}

func 	getCheckSum(array : Array<Any>) {
    
    var  checkSum : UInt = 0
    for byte in array {
        var hexString : String = byte as! String
        if hexString.hasPrefix("0x") { // true
            hexString.remove(at: hexString.startIndex)
            hexString.remove(at: hexString.startIndex)
        }
        if let num = UInt(hexString, radix: 16) {
            checkSum = checkSum + num
            print(num)
        } else {
            print("invalid input")
        }
    }
}




func logInfo(_ message: String, file: String = #file, function: String = #function, line: Int = #line, column: Int = #column) {
        print("\(function): \(line): \(message)")
}
