//
//  ELDeviceListVC.swift
//  ElsmartBLEApp
//
//  Created by Lalit Kumar on 26/04/18.
//  Copyright © 2018 Mahak_Mobiloitte. All rights reserved.
//

import UIKit
import  SwiftyBluetooth
import CoreBluetooth
import AudioToolbox
import SQLite3

let BLE_SERVICE = "0000E0FF-3C17-D293-8E48-14FE2E4DA212"
let BLE_CHARACTERISTIC  = "0000FFE1-0000-1000-8000-00805F9B34FB"

class ELDeviceListVC: UIViewController,UITableViewDataSource,UITableViewDelegate  {
    
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var selectDeviceBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var deviceListTableView: UITableView!
    @IBOutlet weak var popViewHeightConstraint: NSLayoutConstraint!
    var mainPeripheral:CBPeripheral? = nil
    var mainCharacteristic:CBCharacteristic? = nil
    var peripherals:[CBPeripheral] = []
    var connectedDeviceInfo = ELDeviceInfo()
    var commandNumber = 0
    var thirdCommand = [UInt8]()
    var connectedPeripheral : Peripheral? = nil
    var Terdetails : Peripheral? = nil
    
    var deviceList = [ELDeviceInfo]()
    var periArray = [Peripheral]()
    var index = 0
    
    // Timer to set reps
    var repTimer : Timer?
    
    // Timer to set reps
    var commandTimer : Timer?
    var commandTime = 0
    
    var db: OpaquePointer? //pradeep
    
    
    //MARK:- View Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDefaults()
        
        
        //pradeep
        
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("Elsmart.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        
        //creating table
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS tblLogs (id INTEGER PRIMARY KEY AUTOINCREMENT,date TEXT,badgeNo TEXT, ter TEXT,direction TEXT)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
        
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS tblTerminals (id INTEGER PRIMARY KEY AUTOINCREMENT,Name TEXT,Address TEXT)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        searchForNearByBluetoothDevices()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Helper Methods
    
    func setUpDefaults(){
        selectDeviceBtn.setTitle(NSLocalizedString(kSelectDevice, comment: ""), for: .normal)
        cancelBtn.setTitle(NSLocalizedString(kCancel, comment: ""), for: .normal)
        popUpView.layer.borderWidth = 1.5
        popUpView.layer.borderColor = UIColor.init(red: 102/255.0, green: 102/255.0, blue: 102/255.0, alpha: 1.0).cgColor
        popUpView.layer.cornerRadius = 5.0
        popUpView.clipsToBounds = true
    }
    
    func handlePopupCustomHeight(){
        
        let maximumHeight = kWindowHeight() - 140
        let calculatedHeight = (deviceList.count * 72) + 140
        
        if CGFloat(calculatedHeight) > maximumHeight{
            popViewHeightConstraint.constant = maximumHeight
            deviceListTableView.isScrollEnabled = true
        }else{
            popViewHeightConstraint.constant = CGFloat(calculatedHeight)
            deviceListTableView.isScrollEnabled = false
        }
    }
    
    //MARK:- Search for near by devices.
    func searchForNearByBluetoothDevices(){
        
        self.deviceList.removeAll()
        self.periArray.removeAll()

        SwiftyBluetooth.scanForPeripherals(withServiceUUIDs: [CBUUID(string: BLE_SERVICE)] , timeoutAfter: 15) { scanResult in
            switch scanResult {
            case .scanStarted:
                break
            case .scanResult(let peripheral, let advertisementData, let RSSI):
                
                let obj = ELDeviceInfo()
                obj.deviceIP = "\(peripheral.identifier)"
                obj.deviceName = peripheral.name
                obj.deviceRssi = "\(RSSI ?? 0)"
                
                self.deviceList.append(obj)
                self.periArray.append(peripheral)
                DispatchQueue.main.async {
                    self.deviceListTableView.reloadData()
                    self.handlePopupCustomHeight()
                }
                break
            case .scanStopped(let error):
                break
            }
        }
    }
    
    
    
    //MARK:- UITableView DataSource and Delegate Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deviceList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ELDeviceListTableCell", for: indexPath) as! ELDeviceListTableCell
        
        let obj = deviceList[indexPath.row]
        cell.nameLbl.text = obj.deviceName
        cell.deviceRssiLbl.text = "Rssi = \(obj.deviceRssi)"
        cell.deviceAddressLbl.text = obj.deviceIP
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 72
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        connectedDeviceInfo = deviceList[indexPath.row]
        index = indexPath.row
        connectedPeripheral = self.periArray[indexPath.row]
        
        self.connectedPeripheral?.connect(withTimeout: 60) { result in
            switch result {
            case .success:
                self.getNotifiedForConnectedPeripheral(paripheralDevice: self.connectedPeripheral!)
                self.writeVal(paripheralDevice: self.connectedPeripheral!)
                //Terdetails = self.periArray[indexPath.row]
            break // You are now connected to the peripheral
            case .failure(let error):do {
            }
                break // An error happened while connecting
            }
        }
        
    }
    
    //MARK:- Write first command.
    func writeVal(paripheralDevice : Peripheral)  {
        
        // set timer to track time response.
        self.setTimerForAssignedTime()
        let data = Data(bytes: [0xAA,0x55, 0x0D ,0x00, 0x01 ,0x84 ,0x00 ,0x01, 0x88, 0x7F, 0x56, 0x34 ,0x12 ,0x02, 0x29, 0xF0])
        self.connectedPeripheral?.writeValue(ofCharacWithUUID: BLE_CHARACTERISTIC,
                                             fromServiceWithUUID: BLE_SERVICE,
                                             value: data) { result in
                                                switch result {
                                                case .success(let val):
                                                    do {
                                                        self.cancelTimerInResponse()
                                                        print(val)
                                                    }

                                                break // The write was succesful.
                                                case .failure(let error):
                                                    self.disconnectCurrentPeriferal()
                                                    break // An error happened while writting the data.
           }
        }
 

    }
    
    //added by pradeep
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    
    //MARK:- Get notified for connected periferal and set notifier ble connand response.
    func getNotifiedForConnectedPeripheral(paripheralDevice : Peripheral){
        
        paripheralDevice.setNotifyValue(toEnabled: true, forCharacWithUUID: BLE_CHARACTERISTIC, ofServiceWithUUID: BLE_SERVICE) { result  in
            // If there were no errors, you will now receive Notifications when that characteristic value gets updated.
            switch result {
            case .success(let val):
                print(val)
                break
            case .failure(let error):
                print(error)
                break
            }
        }
        
        
        // Add observer for all notification response.
        NotificationCenter.default.addObserver(forName: Peripheral.PeripheralCharacteristicValueUpdate,
                                               object: paripheralDevice,
                                               queue: nil) { (notification) in
                                                let charac = notification.userInfo!["characteristic"] as! CBCharacteristic
                                                if let error = notification.userInfo?["error"] as? SBError {
                                                    print(error.localizedDescription)
                                                } else {
                                                    guard let dataBytes = charac.value else {
                                                        return
                                                    }
                                                    
                                                    var bytearrayString = [String]()
                                                    for bytee in dataBytes {
                                                        bytearrayString.append(String(bytee))
                                                    }
                                                    
                                                    let ReceivedNoOfBytes = dataBytes.count
                                                    let bytes = [UInt8](dataBytes as Data)
                                                    if dataBytes.count > 10 {
                                                        let mrequiredByte = dataBytes[9]
                                                        if mrequiredByte == 0x51 {
                                                            
                                                            // Fetch terminalID 5th byte in response of first command.
                                                            if bytes.count > 4{
                                                                newTerminalID = bytes[5]
                                                            }
                                                            
                                                            newSessionID.removeAll()
                                                            // Get sessionID 4 bytes after 12th index.
                                                            for (index,obj) in bytes.enumerated() {
                                                                if index == 12 || index == 13 || index == 14 || index == 15{
                                                                    newSessionID.append(obj)
                                                                }
                                                            }

                                                            ELDeviceInfo.sharedInstance.processCommandOneResponse(dataArray : bytes, count :  ReceivedNoOfBytes)
                                                            let array = ELDeviceInfo.sharedInstance.GetSecondComandArray()
                                                            self.writeCommandValue2Val(dataArray : array)
   

                                                        }
                                                       else if mrequiredByte == 0x52 {

                                                           self.thirdCommand.removeAll()
                                                           self.thirdCommand = ELDeviceInfo.sharedInstance.GetThirdComandArray()
                                                            self.writeThirdCommandValue()

                                                        }
                                                       else if mrequiredByte == 0x53 {
                                                            
                                                            // Response of third command.
                                                            self.disconnectCurrentPeriferal()
                                                            
                                                            
                                                            var mrequiredfiledir = ""
                                                            
                                                            
                                                            // Name and badge no bytes.
                                                            var badgeNoNameBytes = [0x12]
                                                            
                                                            // Date and time.
                                                            var dateTime  = [0x12]
                                                            var terID = String(bytes[14])
                                                            // Badge number
                                                            var badgeNoBytes  = [0x12]
                                                            
                                                            badgeNoNameBytes.removeAll()
                                                            dateTime.removeAll()
                                                            badgeNoBytes.removeAll()
                                                            
                                                            for (index,obj) in bytes.enumerated() {
                                                                
                                                                // badge number and name bytes. ok
                                                                if index > 39 && index < 56 {
                                                                    badgeNoNameBytes.append(Int(obj))
                                                                }
                                                                
                                                                // date and time bytes. ok
                                                                if index > 15 && index < 22 {
                                                                    dateTime.append(Int(obj))
                                                                }
                                                                
                                                                // badge no bytes.
                                                                if index > 63 && index < 80 {
                                                                    badgeNoBytes.append(Int(obj))
                                                                }
                                                                
                                                                
                                                            }
                                                            
                                                            let formattedDate = self.getFormattedDate(dateHexArr: dateTime)
                                                            
                                                            let charArray = badgeNoNameBytes.map { Character(UnicodeScalar(UInt32($0))!) }
                                                            var nameStr = ""
                                                            for obj in charArray {
                                                                nameStr = nameStr + "\(obj)"
                                                            }

                                                            
                                                            
                                                            
                                                            
                                                            
                                                            
                                                            // Get data from ble as required.
                                                            // Get command status.
                                                            let commandStatus1 = dataBytes[22]
                                                            let commandStatus2 = dataBytes[23]
                                                            var res = (Int)(commandStatus1 + (commandStatus2<<8))
                                                            res=res & 0xFF9E
                                                            if commandStatus1 == 0x00 && commandStatus2 == 0x00
                                                            {
                                                                
                                                                
                                                                 mrequiredfiledir = String(dataBytes[56])
                                                                var mutableArray = [UInt8]()
                                                                mutableArray.append(dataBytes[56])
                                                                let filename = self.getDocumentsDirectory().appendingPathComponent(fileInOut)
                                                                let pointer = UnsafeBufferPointer(start:mutableArray, count:mutableArray.count)
                                                                let data = Data(buffer:pointer)
                                                                do {
                                                                    try data.write(to:filename)
                                                                } catch {
                                                                }
                                                                let filePath = filename.relativePath
                                                                let file: FileHandle? = FileHandle(forReadingAtPath: filePath)
                                                                
                                                                if file != nil {
                                                                    // Read all the data
                                                                    let data : [UInt8] = Array(file!.readDataToEndOfFile())
                                                                    
                                                                    print(data)
                                                                    
                                                                    // Close the file
                                                                    file?.closeFile()
                                                                    
                                                                    // Convert our data to string
                                                                    // print(str!)
                                                                }
                                                                else {
                                                                    print("Ooops! Something went wrong!")
                                                                }
                                                                if mrequiredfiledir=="100"
                                                                {
                                                                    mrequiredfiledir="IN"
                                                                }
                                                                else
                                                                {
                                                                    mrequiredfiledir="OUT"
                                                                }
                                                                
                                                                
                                                                
                                                                var stmt: OpaquePointer?
                                                                
                                                                //the insert query
                                                                let queryString = "INSERT INTO tblLogs (date, badgeNo,ter,direction) VALUES (?,?,?,?)"
                                                                
                                                                //preparing the query
                                                                if sqlite3_prepare(self.db, queryString, -1, &stmt, nil) != SQLITE_OK{
                                                                    let errmsg = String(cString: sqlite3_errmsg(self.db)!)
                                                                    print("error preparing insert: \(errmsg)")
                                                                    return
                                                                }
                                                                
                                                                //binding the parameters
                                                                if sqlite3_bind_text(stmt, 1, formattedDate, -1, nil) != SQLITE_OK{
                                                                    let errmsg = String(cString: sqlite3_errmsg(self.db)!)
                                                                    print("failure binding name: \(errmsg)")
                                                                    return
                                                                }
                                                                
                                                                if sqlite3_bind_text(stmt, 2, nameStr, -1, nil) != SQLITE_OK{
                                                                    let errmsg = String(cString: sqlite3_errmsg(self.db)!)
                                                                    print("failure binding name: \(errmsg)")
                                                                    return
                                                                }
                                                                
                                                                if sqlite3_bind_text(stmt, 3, terID, -1, nil) != SQLITE_OK{
                                                                    let errmsg = String(cString: sqlite3_errmsg(self.db)!)
                                                                    print("failure binding name: \(errmsg)")
                                                                    return
                                                                }
                                                                
                                                                if sqlite3_bind_text(stmt, 4, mrequiredfiledir, -1, nil) != SQLITE_OK{
                                                                    let errmsg = String(cString: sqlite3_errmsg(self.db)!)
                                                                    print("failure binding name: \(errmsg)")
                                                                    return
                                                                }
                                                                
                                                           
                                                                //executing the query to insert values
                                                                if sqlite3_step(stmt) != SQLITE_DONE {
                                                                    let errmsg = String(cString: sqlite3_errmsg(self.db)!)
                                                                    print("failure inserting hero: \(errmsg)")
                                                                    return
                                                                }
                                                                
                                                                print("Logs saved successfully")
                                                                
                                                                let name = self.connectedDeviceInfo.deviceName
                                                                let Address = self.connectedDeviceInfo.deviceIP
                                                                
                                                                let queryStringTer = "INSERT INTO tblTerminals (Address, Name) VALUES (?,?)"
                                                                
                                                                //preparing the query
                                                                if sqlite3_prepare(self.db, queryStringTer, -1, &stmt, nil) != SQLITE_OK{
                                                                    let errmsg = String(cString: sqlite3_errmsg(self.db)!)
                                                                    print("error preparing insert: \(errmsg)")
                                                                    return
                                                                }
                                                                
                                                                //binding the parameters
                                                                if sqlite3_bind_text(stmt, 1, Address, -1, nil) != SQLITE_OK{
                                                                    let errmsg = String(cString: sqlite3_errmsg(self.db)!)
                                                                    print("failure binding name: \(errmsg)")
                                                                    return
                                                                }
                                                                
                                                                if sqlite3_bind_text(stmt, 2, name, -1, nil) != SQLITE_OK{
                                                                    let errmsg = String(cString: sqlite3_errmsg(self.db)!)
                                                                    print("failure binding name: \(errmsg)")
                                                                    return
                                                                }
                                                                
                                                              
                                                                
                                                                
                                                                //executing the query to insert values
                                                                if sqlite3_step(stmt) != SQLITE_DONE {
                                                                    let errmsg = String(cString: sqlite3_errmsg(self.db)!)
                                                                    print("failure inserting hero: \(errmsg)")
                                                                    return
                                                                }
                                                                
                                                                print("Terminal  saved successfully")
                                                                
                                                                
                                                                
                                                                
                                                                
                                                                
                                                                
                                                                
                                                                
                                                            }
                                                            else {
                                                                if commandStatus1 == 0x01 {
                                                                    _ = AlertController.alert("Something went wrong.", message: "Card Blacklisted")
                                                                }
                                                                    if commandStatus1 == 0x02 {
                                                                        _ = AlertController.alert("Something went wrong.", message: "Access Denied")
                                                                }
                                                                if commandStatus1 == 0x03 {
                                                                    _ = AlertController.alert("Something went wrong.", message: "CARD EXPIRED")
                                                                }
                                                                 else if commandStatus1 == 0x04{
                                                                    _ = AlertController.alert("Something went wrong.", message: "ANTIPASS BACK ERROR")
                                                                }
                                                                   else if commandStatus1 == 0x05 {
                                                                        _ = AlertController.alert("Something went wrong.", message: "ACCESS DURING LOCK")
                                                                }
                                                                     else   if commandStatus1 == 0x06 {
                                                                            _ = AlertController.alert("Something went wrong.", message: "ACCESS DURING HOLIDAY")
                                                                }
                                                                         else   if commandStatus1 == 0x07 {                                                                                _ = AlertController.alert("Something went wrong.", message: "ACCESS DURING LEAVE")
                                                             
                                                                } else if commandStatus1 == 0x08{
                                                                    _ = AlertController.alert("Something went wrong.", message: "PIN_FAIL")
                                                                }
                                                                              else  if commandStatus1 == 0x09 {
                                                                                    _ = AlertController.alert("Something went wrong.", message: "BIO_FAIL")
                                                                } else if commandStatus1 == 0x0A{
                                                                    _ = AlertController.alert("Something went wrong.", message: "DURESS_CODE")
                                                                                } else if commandStatus1 == 0x0B{
                                                                                    _ = AlertController.alert("Something went wrong.", message: "ACCESS_SCHEDULE")
                                                                                } else if commandStatus1 == 0x0C{
                                                                                    _ = AlertController.alert("Something went wrong.", message: "FLASH_WRITE_FAIL")
                                                                                } else if commandStatus1 == 0x0D{
                                                                                    _ = AlertController.alert("Something went wrong.", message: "BIO_DEVICE_ERR")
                                                                                } else if commandStatus1 == 0x0E{
                                                                                    _ = AlertController.alert("Something went wrong.", message: "Eacs ACCESCORT")
                                                                                } else if commandStatus1 == 0x0F{
                                                                                    _ = AlertController.alert("Something went wrong.", message: "Eacs CARDTWING")
                                                                                
                                                                } else if commandStatus1 == 0x10{
                                                                    _ = AlertController.alert("Something went wrong.", message: "SYSTEM_HALTED")

                                                                } else if commandStatus1 == 0x11{
                                                                    _ = AlertController.alert("Something went wrong.", message: "FP TIMEOUT ERROR")

                                                                } else if commandStatus1 == 0x12{
                                                                    _ = AlertController.alert("Something went wrong.", message: "NOT SUPPORTED")
                                                                                } else if commandStatus1 == 0x12{
                                                                                    _ = AlertController.alert("Something went wrong.", message: "NOT SUPPORTED")

                            
                                                            } else if commandStatus1 == 0x13{
                                                                _ = AlertController.alert("Something went wrong.", message: "NOT ENROLLED")
                                                                
                                                            
                                                        } else if commandStatus1 == 0x14{
                                                            _ = AlertController.alert("Something went wrong.", message: "NO FINGER DETECTED")
                                                            
                                                        
                                                    } else if commandStatus1 == 0x15{
                                                        _ = AlertController.alert("Something went wrong.", message: "READER ERROR")
                                                        
                                                    
                                                } else if commandStatus1 == 0x16{
                                                    _ = AlertController.alert("Something went wrong.", message: "Cutomer Mismatch")
                                                    
                                                }
                                                                
                                                                
                                                                
                                                                
                                                                else {
                                                                    _ = AlertController.alert("Something went wrong.", message: "\(commandStatus1)")
                                                                }
                                                                
                                                                return
                                                            }
                                                            
                                                            
                                                            let userInfoDict = ["badgeNameNo":"\(nameStr)" ,"dateTime":"\(formattedDate)","Dir":"\(mrequiredfiledir)"]
                                                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "punchInformation"), object: nil, userInfo: ["UserInfo":userInfoDict])
                                                            self.dismiss(animated: true, completion: nil)
                                                            
                                                            //_ = AlertController.alert("bytes third comamnd  == ", message:"\(bytearrayString)")
                                                        }  else {
                                                            self.disconnectCurrentPeriferal()
                                                             //_ = AlertController.alert("other response  == ", message:"\(bytearrayString)")
                                                        }
                                                    }
                                                    
                                                    
                                                }
                                                
                                                
            }
}

    //MARK:- Get formatted date
    func getFormattedDate( dateHexArr : [Int]) -> String{
        let dataYear = dateHexArr[0]
        let dataMonth = dateHexArr[1]
        let dataDay = dateHexArr[2]
        let dataHours = dateHexArr[3]
        let dataMinutes = dateHexArr[4]
        let dataSeconds = dateHexArr[5]
        
        let monthName = DateFormatter().monthSymbols[dataMonth - 1]
        let endIndex = monthName.index(monthName.startIndex, offsetBy: +3)
        let truncatedMonth = monthName.substring(to: endIndex)
        
        let formatedDate = String( format : "%@:%@:%@ %@:%@:%@","\(dataYear+2000)","\(truncatedMonth)","\(dataDay)","\(dataHours)","\(dataMinutes)","\(dataSeconds)")
        print(formatedDate)
        return formatedDate
        
    }
    
    // Get name badge number.
    func getNameBadge( dateHexArr : [Int]) -> String{

        var badgeName = ""
        for byteObj in dateHexArr {
            badgeName = badgeName + "\(byteObj)"
        }
        return badgeName
        
    }
   
    func disconnectCurrentPeriferal(){
        self.connectedPeripheral?.disconnect { result in
            switch result {
            case .success:

            break // You are now disconnected from the peripheral
            case .failure(let error):
                break // An error happened during the disconnection
            }
        }
    }


    //MARK:- Check for send commnad time.
    
    func setTimerForAssignedTime(){
        
        if commandTimer == nil {
            commandTimer = Timer.scheduledTimerWithTimeInterval(1, repeats: true
                , callback: {
                    self.commandTime = self.commandTime + 1
                    if self.commandTime >= 8 {
                        self.commandTime = 0
                        self.disconnectCurrentPeriferal()
                        self.commandTimer?.dispose()
                    }
            })
        }
        
    }
    
    // cancel timer if got response on time.
    func cancelTimerInResponse(){
        self.commandTime = 0
        self.commandTimer?.dispose()
    }
    
    //MARK:- Write second command.
func writeCommandValue2Val(dataArray : [UInt8])  {
   
    self.setTimerForAssignedTime()
    let data = Data(bytes: dataArray)
    self.connectedPeripheral?.writeValue(ofCharacWithUUID: BLE_CHARACTERISTIC,
                                         fromServiceWithUUID: BLE_SERVICE,
                                         value: data) { result in
                                            switch result {
                                            case .success():
                                                self.cancelTimerInResponse()
                                                break // The write was succesful.
                                            case .failure(let error):
                                                self.disconnectCurrentPeriferal()
                                                break // An error happened while writting the data.
                                            }
    }
    
    
}

    
    //MARK:- Write third command.
    // Modified code by anil
    public func writeThirdCommandValue(){
        
        self.setTimerForAssignedTime()

        var requestDict = Dictionary<String,Any>()
        var count  = 0
        var array1 = [UInt8]()
        print("Third Command",self.thirdCommand)
        for bytee in self.thirdCommand {
            if array1.count < 20 {
                array1.append(bytee)
            } else {
                requestDict["\(count)"] = array1
                array1.removeAll()
                array1.append(bytee)
                count = count + 1
            }
        }
        requestDict["\(count)"] = array1
        array1.removeAll()
        self.writeThirdCommandValueInPackets(packetsDict: requestDict)
    }
    
    
    func writeThirdCommandValueInPackets(packetsDict : Dictionary<String,Any>){
        
        var allKeys = Array(packetsDict.keys).sorted(by: >)
        allKeys = allKeys.sorted(by: { (obj1, obj2) -> Bool in
            return obj1 > obj2 ? false : true
        })
        
        var count = 0
        if repTimer == nil {
            repTimer = Timer.scheduledTimerWithTimeInterval(0.10, repeats: true
                , callback: {
                    self.writeThirdComandModules(dataArray: packetsDict.validatedValue("\(count)", expected: NSArray()) as! [UInt8])
                    count = count + 1
                    if allKeys.count == count {
                        self.repTimer?.dispose()
                    }
            })
        }
        
    }
    
    
    
	func writeThirdComandModules(dataArray : [UInt8])
	{
		let data = Data(bytes: dataArray)

		self.connectedPeripheral?.writeValue(ofCharacWithUUID: BLE_CHARACTERISTIC,
																				 fromServiceWithUUID: BLE_SERVICE,
																				 value: data) { result in
																					switch result {
																					case .success(let val):
                                                                                        self.cancelTimerInResponse()
																					break // The write was succesful.
																					case .failure(let error):
                                                                                        self.disconnectCurrentPeriferal()
																						break // An error happened while writting the data.
																					}
		}
	}
	
	

//MARK:- UIButton Action Methods

@IBAction func cancelBtnAction(_ sender: UIButton) {
    self.dismiss(animated: true, completion: nil)
}


//MARK:- Memory Warning Methods

override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
}

}


extension Data {
    struct HexEncodingOptions: OptionSet {
        let rawValue: Int
        static let upperCase = HexEncodingOptions(rawValue: 1 << 0)
    }
    
    func hexEncodedString(options: HexEncodingOptions = []) -> String {
        let format = options.contains(.upperCase) ? "%02hhX" : "%02hhx"
        return map { String(format: format, $0) }.joined()
    }
}

