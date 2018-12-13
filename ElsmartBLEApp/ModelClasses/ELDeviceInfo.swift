//
//  ELDeviceInfo.swift
//  ElsmartBLEApp
//
//  Created by Rakesh Bajeli on 26/04/18.
//  Copyright © 2018 Mahak_Mobiloitte. All rights reserved.
//

import UIKit
import CoreBluetooth

let cmdForMdGetIMEIBLEPAcket =  [0x01, 0x01, 0x7F, 0x56, 0x34,0x12, 0x00, 0x0F, 0x33, 0x35, 0x36, 0x33, 0x31, 0x36, 0x30, 0x36, 0x34, 0x32, 0x36, 0x34, 0x38, 0x31 ,0x35]
let deviceUUID: String = (UIDevice.current.identifierForVendor?.uuidString)!
let IMEI: [UInt8] = Array(deviceUUID.utf8)
let fileNameString = "CardholderData.txt"
let fileInOut = "InOut.txt"//pradeep

let STXArray     = [0xAA , 0x55]
var terminalID   = 1
let FixedVal     = [0x00 , 0x01]
let cmdGetIMEI   = [0x4F, 0x51]
let STX1         = 0xAA
let STX2         = 85
let MAXRXFRAMESize   = 4096
let MAX_BUFF         = 8096
let cmdGetDateTime   = 81
let cmdSetTerID      = 82
let cmdWhoAmI        = -120
let MSB              = 0
var LSB              = 0
let FIX1             = 0
let FIX2             = 1
var SOURCEID         = 132  // 0x84
let ETX              = 240  //0xF0
let CMD_GET_IMEI_1   = 79
let CMD_GET_IMEI_2   = 81
var SESSIONID	  = [UInt8]()
var DATE_TIME	  = [UInt8]()
var comandSecondArray   =  [UInt8]()
var comandThirdArray   =  [UInt8]()



var newTerminalID = UInt8()
var newSiteID = UInt8()
var newSessionID = [UInt8]()



enum FRAGMENTSTATUS: Int {
	case NONE = 0
	case WAITSTX1 = 1
    case WAITSTX2 = 2
	case WAITDATA = 3
	case WAITFrameProcess = 4
	case ReadyForNextCmd = 5
}

class ELDeviceInfo: NSObject {
    
    var deviceName: String?
    var deviceRssi = ""
    var deviceIP: String?
	  var serviceUUID = ""
	  var charUUID  = ""
	  var mainCharacteristic:CBCharacteristic? = nil
	  var frameProcessState : FRAGMENTSTATUS  = FRAGMENTSTATUS(rawValue: 1)!

	   static let sharedInstance = ELDeviceInfo()
	
	func processCommandOneResponse(dataArray : [UInt8], count : Int){
		SESSIONID.removeAll()
		DATE_TIME.removeAll()
		
	//	if dataArray.count == 35 {
			var i = 0
			while i < dataArray.count {
				
				if i == 6 || i == 7 || i == 8 || i == 9 {
					SESSIONID.append(dataArray[i])
				}
				if i == 10 || i == 11 || i == 12 || i == 13 || i == 14 || i == 15{
					DATE_TIME.append(dataArray[i])
				}
				i = i + 1
                if(i == 10)
                {
                    newTerminalID = dataArray[i]//10th byte
                }
                if(i == 11)
                {
                    newSiteID = dataArray[i]//11th byte
                }

			}

	//}
	}
	
	func GetSecondComandArray()-> [UInt8]{
		comandSecondArray.removeAll()
		
        comandSecondArray.append(0xAA) // STX
		comandSecondArray.append(0x55)
        
        comandSecondArray.append(0x00) //lsb
        comandSecondArray.append(0x00) //msb
		
        //comandSecondArray.append(0x01) // Destination id.
        comandSecondArray.append(UInt8(newTerminalID))

		comandSecondArray.append(0x84) // Source id
		comandSecondArray.append(0x00) // fixed
		comandSecondArray.append(0x01) // fixed
        
        // Cmd from here.
		comandSecondArray.append(0x4F)
		comandSecondArray.append(0x51)

        // Site ID is 1 for now.
        comandSecondArray.append(0x01)
        
        // Terminal ID
        comandSecondArray.append(UInt8(newTerminalID))


        // Session ID.
        for obj in newSessionID {
            comandSecondArray.append(UInt8(obj))
        }
        
        // Response Code 0.
		comandSecondArray.append(0x00)
        
        // Number of IMEI digits 16 for now.
        comandSecondArray.append(0x10)
        
        // Get 16 bytes and neglect rest of bytes for IMEI no.
        for (index,item) in IMEI.enumerated() {
            if index < 16 {
                comandSecondArray.append(UInt8(item))
            }
        }

		var i = 4
		var sum : UInt32 = 0
		while i < comandSecondArray.count {
			let item : UInt32 = UInt32 (comandSecondArray[i])
			sum = sum + item
			i = i + 1
		}
		let b_l  = (UInt8)(sum & 0xFF)
		let b_h  = (UInt8) ((sum >> 8 ) & 0xFF)
		comandSecondArray.append((b_h))
		comandSecondArray.append(b_l)
		comandSecondArray.append(0xF0)  // ETX
		let cnt = comandSecondArray.count-3
        comandSecondArray[2] = (UInt8)(cnt & 0xFF)
        comandSecondArray[3] = (UInt8) ((cnt >> 8 ) & 0xFF)
        return comandSecondArray
		
	}
    
    
	func GetThirdComandArray()-> [UInt8]{
		comandThirdArray.removeAll()
		comandThirdArray.append(0xAA) // STX
		comandThirdArray.append(0x55)
        comandThirdArray.append(0x00) // lsb
		comandThirdArray.append(0x00) // msb
        
		//comandThirdArray.append(0x01) // Destination Id
        // Terminal ID.
        comandThirdArray.append(UInt8(newTerminalID))
        
		comandThirdArray.append(0x84) // Source Id
		comandThirdArray.append(0x00) // fixed
		comandThirdArray.append(0x01) // fixed
		comandThirdArray.append(0x4F) // Cmd from here.
		comandThirdArray.append(0x52)
		
        // Site ID is 1 for now.
        comandThirdArray.append(0x01)
        
        // Terminal ID.
        comandThirdArray.append(UInt8(newTerminalID))

        
        // Session ID.
        for obj in newSessionID {
            comandThirdArray.append(UInt8(obj))
        }
        
        // ResponseCode is 0 for now.
        comandThirdArray.append(0x00)
        
        
        // File name upto 16 bytes.
        let fileNameArray :  [UInt8] = Array(fileNameString.utf8) //filename
        for (index,item) in fileNameArray.enumerated() {
            if index < 16 {
                comandThirdArray.append(UInt8(item))
            }
        }
        
        comandThirdArray.append(0x00)   //smart card
        comandThirdArray.append(0x00)   //smart card
        comandThirdArray.append(0x00)   //smart card
        comandThirdArray.append(0x00)   //smart card
        comandThirdArray.append(0x00)   //repeat count
        
        let filename = self.getDocumentsDirectory().appendingPathComponent(fileNameString)
        let filePath = filename.relativePath
        let file: FileHandle? = FileHandle(forReadingAtPath: filePath)
        let data : [UInt8] = Array(file!.readDataToEndOfFile())
        let numberOfBytes = data.count
        
        // Data length no bytes (curently 2 bytes).
        // Sample if 703 is the content size of file
        let lsb = (UInt8)(numberOfBytes & 0xFF)
        let msb = (UInt8) ((numberOfBytes >> 8 ) & 0xFF)

        comandThirdArray.append(lsb) //lsb
        comandThirdArray.append(msb) //msb
        
        
        let filenameStr = self.getDocumentsDirectory().appendingPathComponent(fileNameString)
        let filePathStr = filenameStr.relativePath
        let fileStr: FileHandle? = FileHandle(forReadingAtPath: filePathStr)
        
        
        // Files data (hex) upto 65536 bytes.
		if fileStr != nil
		{
            //let data : [UInt8] = Array(file!.readDataToEndOfFile())
            // Read all the data
            let data : [UInt8] = Array(fileStr!.readDataToEndOfFile())
            print(data)
			
			file?.closeFile()
			for item in data {
				comandThirdArray.append(item)
			}
			
		}
        
        
        
        
        let filenameInOut = self.getDocumentsDirectory().appendingPathComponent(fileInOut)
        let filePathStrInOut = filenameInOut.relativePath
        let fileStrInOut: FileHandle? = FileHandle(forReadingAtPath: filePathStrInOut)
        
        
        // Files data (hex) upto 65536 bytes.
        if fileStrInOut != nil
        {
            //let data : [UInt8] = Array(file!.readDataToEndOfFile())
            // Read all the data
            let data : [UInt8] = Array(fileStrInOut!.readDataToEndOfFile())
            print(data)
            
            file?.closeFile()
            //for item in data {
             comandThirdArray.append(data[0])
           // }
            
            
        }
        else
        {
            comandThirdArray.append(0)
        }
        comandThirdArray.append(0)
        
        var i = 4

		var sum : UInt32 = 0
		while i < comandThirdArray.count {
			let item : UInt32 = UInt32 (comandThirdArray[i])
			sum = sum + item
			i = i + 1
		}
		let b_l  = (UInt8)(sum & 0xFF)
		let b_h  = (UInt8) ((sum >> 8 ) & 0xFF)
		comandThirdArray.append((UInt8(b_h)))
		comandThirdArray.append(UInt8(b_l))
		comandThirdArray.append(0xF0)
		
        let cnt = comandThirdArray.count-3
        comandThirdArray[2] = (UInt8)(cnt & 0xFF)
        comandThirdArray[3] = (UInt8) ((cnt >> 8 ) & 0xFF)
		return comandThirdArray
        
	}
    
	func getDocumentsDirectory() -> URL {
		let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		return paths[0]
	}
	
	
}
