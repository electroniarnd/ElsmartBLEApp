//
//  ELRegcistrationVC.swift
//  ElsmartBLEApp
//
//  Created by Suraj_Mobiloitte on 24/04/18.
//  Copyright © 2018 Mahak_Mobiloitte. All rights reserved.
//

import UIKit
import AudioToolbox

class ELRegistrationVC: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate {
   
    @IBOutlet weak var registrationTableView: UITableView!
    @IBOutlet weak var navBarHeightConst: NSLayoutConstraint!
    @IBOutlet weak var registerBtn: ELCustomShadowButton!
    @IBOutlet weak var unRegisterBtn: ELCustomShadowButton!
    @IBOutlet weak var registrationTitleLbl: ELCustomLabel!
    
    var registrationTitleList = [String]()
    var regObj = ELRegistrationInfo.registrationObject
    var additionaltDataList = NSMutableArray()
    
    var isEacsRadioSelected : Bool = false
    var isElsmartRadioSelected : Bool = true
    
    //MARK:- View life cycle method.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        // Fetch user data stored locally.
        self.fetchLastRegisteredUserDataLocally()
        self.setUpInitial()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    //MARK:- Helper Methods
    // MARK:- Fetch user data.
    func fetchLastRegisteredUserDataLocally(){
        DispatchQueue.global(qos: .userInteractive).async {
            self.regObj.regBadgeNo = ""
            self.regObj.regTitle = ""
            self.regObj.regDepartment = ""
            self.regObj.regCardExpired = ""
            self.regObj.regCardValidFrom = ""
            self.regObj.regCardIsuedFrom = ""
            self.regObj.regIMEI = ""
            self.regObj.regModelNo = ""
            self.regObj.regModelNo = ""
            self.regObj.regSystem = ""
 
            self.regObj.regStatus = NSLocalizedString(KUnregistered, comment: "")
            if let badgeNo = NSUSERDEFAULT.value(forKey: "badgeNumber") {
                self.regObj.regBadgeNo = badgeNo as! String
            }
            if let title = NSUSERDEFAULT.value(forKey: "regTitle") {
                self.regObj.regTitle = title as! String
            }
            if let department = NSUSERDEFAULT.value(forKey: "regDepartment") {
                self.regObj.regDepartment = department as! String
            }
            if let cardExpired = NSUSERDEFAULT.value(forKey: "regCardExpired") {
                self.regObj.regCardExpired = cardExpired as! String
            }
            if let regCardValid = NSUSERDEFAULT.value(forKey: "regCardValidFrom") {
                self.regObj.regCardValidFrom = regCardValid as! String
            }
            if let regcardValidFrom = NSUSERDEFAULT.value(forKey: "regCardIsuedFrom") {
                self.regObj.regCardIsuedFrom = regcardValidFrom as! String
            }
            if let regIMEI = NSUSERDEFAULT.value(forKey: "regIMEI") {
                self.regObj.regIMEI = regIMEI as! String
            }
            if let regModel = NSUSERDEFAULT.value(forKey: "regModel") {
                self.regObj.regModelNo = regModel as! String
            }
            if let serviceURL = NSUSERDEFAULT.value(forKey: "serviceURL") {
                self.regObj.regServiceUrl = serviceURL as! String
            }
            if let regStatus = NSUSERDEFAULT.value(forKey: "regStatus") {
                self.regObj.regStatus = regStatus as! String
            }
            if let regSystem = NSUSERDEFAULT.value(forKey: "regSystem") {
                self.regObj.regSystem = regSystem as! String
            }
            if(self.regObj.regSystem == "eacs")
            {
            self.isEacsRadioSelected = true
            self.isElsmartRadioSelected = false
            }
            else
            {
              self.isEacsRadioSelected = false
              self.isElsmartRadioSelected = true
            }
            
            
            DispatchQueue.main.async {
                self.registrationTableView.reloadData()
            }
        }

        
    }
    
    func setUpInitial(){
        if kWindowHeight() > 667{
            navBarHeightConst.constant += 20
        }
        
        registerBtn.setTitle(NSLocalizedString(KRegister, comment: ""), for: .normal)
        unRegisterBtn.setTitle(NSLocalizedString(KUnregister, comment: ""), for: .normal)
        
        registrationTableView.rowHeight = UITableViewAutomaticDimension
        registrationTableView.estimatedRowHeight = 40
        
        registrationTitleList = [NSLocalizedString(KBadgeNo, comment: ""),NSLocalizedString(KTitle, comment: ""),NSLocalizedString(KDepartment, comment: ""),NSLocalizedString(KCardValidFrom, comment: ""),NSLocalizedString(KCardIsuedFrom, comment: ""),NSLocalizedString(KCardExpired, comment: ""),NSLocalizedString(KIMEI, comment: ""),NSLocalizedString(KModelNo, comment: ""),NSLocalizedString(KStatus, comment: ""),NSLocalizedString(KServiceURL, comment: ""),NSLocalizedString(KSystem, comment: "")]

        DispatchQueue.main.async {
            if self.regObj.regStatus == KRegistered {
                self.unRegisterBtn.alpha = 1.0
                self.unRegisterBtn.isUserInteractionEnabled = true
                self.registerBtn.alpha = 1.0
                self.registerBtn.isUserInteractionEnabled = true
            } else if self.regObj.regStatus == NSLocalizedString(KUnregistered, comment: "") {
                self.unRegisterBtn.alpha = 0.5
                self.unRegisterBtn.isUserInteractionEnabled = false
                self.registerBtn.alpha = 1.0
                self.registerBtn.isUserInteractionEnabled = true
            }
        }

        
    }
    
    // MARK:- Actions handler.
    @objc func tapOnEacsBtn(_ sender: UITapGestureRecognizer){
        isElsmartRadioSelected = false
        let indexPath = IndexPath.init(row: registrationTitleList.count-1, section: 0)
        registrationTableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    @objc func tapOnElsmartBtn(_ sender: UITapGestureRecognizer){
        isElsmartRadioSelected = true
        let indexPath = IndexPath.init(row: registrationTitleList.count-1, section: 0)
        registrationTableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    // MARK: - Validation Method
    func verifyFields() -> Bool{
        var verify = true
        // ---  email validation  ---
        if regObj.regBadgeNo == "" {
            _ = AlertController.alert("", message: NSLocalizedString(KBlankBadgeNo, comment: ""))
            verify = false
        }else if regObj.regIMEI == "" {
            _ = AlertController.alert("", message: NSLocalizedString(KBlankIMEI, comment: ""))
            verify = false
            // ---  password validation  ---
        }else if regObj.regModelNo == ""{
            _ = AlertController.alert("", message: NSLocalizedString(KBlankModelNO, comment: ""))
            verify = false
        }
        return verify
    }
    
    //MARK:- UITextField Delegates Methods
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
       
        switch textField.tag {
        case 1000:
           // textField.keyboardType = .numberPad
            break
        case 1006:
           // textField.keyboardType = .numberPad
            break
        default:
            break
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let indexPath = IndexPath.init(row: textField.tag - 1000, section: 0)
        let texField: UITextField
        textField.resignFirstResponder()
        switch indexPath.row {
        case 0:
            texField = self.view.viewWithTag(1006) as! UITextField
            texField.becomeFirstResponder()
           break
        case 6:
            texField = self.view.viewWithTag(1007) as! UITextField
            texField.becomeFirstResponder()
            break
        case 7:
            texField = self.view.viewWithTag(1009) as! UITextField
            texField.becomeFirstResponder()
            break
        default:
            break
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let indexPath = IndexPath.init(row: textField.tag - 1000, section: 0)
        let cell = registrationTableView.cellForRow(at: indexPath) as! ELRegistrationTableViewCell
        
        switch indexPath.row {
        case 0:
            regObj.regBadgeNo = cell.descriptionTextField.text!.trimmingCharacters(in: .whitespaces)
        case 6:
            regObj.regIMEI = cell.descriptionTextField.text!
        case 7:
            regObj.regModelNo = cell.descriptionTextField.text!
        case 9:
            regObj.regServiceUrl = cell.descriptionTextField.text!
        default:
            //fatalError("Unexpected section \(indexPath.row)")
            break
        }
    }

    //MARK:- UIButton ACtion Methods
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func registrationBtnACtion(_ sender: UIButton) {
        self.view.endEditing(true)
        if self.regObj.regStatus == NSLocalizedString(KRegistered, comment: "")  {
            _ = AlertController.alert("", message: NSLocalizedString("Are you sure to do Registration Again", comment: ""), buttons: [NSLocalizedString("Cancel", comment: ""),NSLocalizedString("Ok", comment: "")], tapBlock: { (action, index) in
                if index == 1{
                    if self.verifyFields(){
                        self.getCardHolderData()
                    }
                }
            })
        } else {
            if verifyFields(){
                getCardHolderData()
            }
        }

    }
    
    @IBAction func unregisterBtnACtion(_ sender: UIButton) {
        
        
        
        _ = AlertController.alert("", message: NSLocalizedString("Are you sure to Unregister?", comment: ""), buttons: [NSLocalizedString("Cancel", comment: ""),NSLocalizedString("Ok", comment: "")], tapBlock: { (action, index) in
            if index == 1{
                self.regObj.regStatus = NSLocalizedString(KUnregistered, comment: "")
                if( self.regObj.regStatus == NSLocalizedString(KUnregistered, comment: "")){
                     self.unRegisterBtn.alpha = 0.5
                     self.unRegisterBtn.isUserInteractionEnabled = false
                }else{
                     self.unRegisterBtn.alpha = 1.0
                     self.unRegisterBtn.isUserInteractionEnabled = true
                }
                DispatchQueue.global(qos: .background).async {
                    self.removeUser()
                    // Fetch user data stored locally.
                    self.fetchLastRegisteredUserDataLocally()
                    DispatchQueue.main.async {
                        self.registrationTableView.reloadData()
                    }
                }

            }
        })
        
        
        
        
       
    }
    
    //MARK:- UITableVIew Delegates and DataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.registrationTitleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ELRegistrationTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ELRegistrationTableViewCell", for: indexPath) as! ELRegistrationTableViewCell
        cell.selectionStyle = .none
        cell.descriptionTextField.isUserInteractionEnabled = false
        cell.eacsLbl.text = NSLocalizedString(KEacs, comment: "")
        cell.elsmartLbl.text = NSLocalizedString(KElsmart, comment: "")
        
        //TapGestures for radio button
        let tapOnEacs = UITapGestureRecognizer(target: self, action: #selector(self.tapOnEacsBtn(_:)))
        cell.eacsRadioBtn.addGestureRecognizer(tapOnEacs)
        cell.eacsRadioBtn.isUserInteractionEnabled = true
        
        let tapOnElsmart = UITapGestureRecognizer(target: self, action: #selector(self.tapOnElsmartBtn(_:)))
        cell.elsmartRadioBtn.addGestureRecognizer(tapOnElsmart)
        cell.elsmartRadioBtn.isUserInteractionEnabled = true
        
        cell.descriptionTextField.tag = indexPath.row + 1000
        cell.headingLabel.text = self.registrationTitleList[indexPath.item]
        cell.descriptionTextField.delegate = self
        switch indexPath.row {
        case 0:
            cell.descriptionTextField.textColor = UIColor.black
            cell.descriptionTextField.font = UIFont(name: "Roboto-Medium", size: 20)
            cell.descriptionTextField.text = regObj.regBadgeNo
            cell.underlineLbl.isHidden = false
            cell.descriptionTextField.isUserInteractionEnabled = true
            cell.descriptionTextField.returnKeyType = .next
            cell.descriptionTextField.keyboardType = .alphabet
            return cell
        case 1:
            cell.descriptionTextField.text = regObj.regTitle
            return cell
        case 2:
            cell.descriptionTextField.text = regObj.regDepartment
            return cell
        case 3:
            cell.descriptionTextField.text = regObj.regCardValidFrom
            return cell
        case 4:
            cell.descriptionTextField.text = regObj.regCardIsuedFrom
            return cell
        case 5:
            cell.descriptionTextField.text = regObj.regCardExpired
            return cell
        case 6:
            cell.descriptionTextField.text = regObj.regIMEI
            cell.descriptionTextField.isUserInteractionEnabled = true
            cell.descriptionTextField.returnKeyType = .next
            cell.descriptionTextField.keyboardType = .alphabet
            cell.underlineLbl.isHidden = false
            return cell
        case 7:
            cell.descriptionTextField.text = regObj.regModelNo
            cell.descriptionTextField.isUserInteractionEnabled = true
            cell.descriptionTextField.returnKeyType = .next
            cell.descriptionTextField.keyboardType = .alphabet
            cell.underlineLbl.isHidden = false
            return cell
        case 8:
            if regObj.regStatus ==  NSLocalizedString(KRegistered, comment: ""){
                cell.descriptionTextField.layer.backgroundColor = UIColor.green.cgColor
            }else{
                cell.descriptionTextField.layer.backgroundColor = UIColor.red.cgColor
            }
            cell.descriptionTextField.text = regObj.regStatus
            cell.descriptionTextField.isUserInteractionEnabled = false
            return cell
        case 9:
            cell.descriptionTextField.textColor = UIColor.black
            cell.descriptionTextField.font = UIFont(name: "Roboto-Medium", size: 20)
            cell.descriptionTextField.text = regObj.regServiceUrl
            cell.underlineLbl.isHidden = false
            cell.descriptionTextField.isUserInteractionEnabled = true
            cell.descriptionTextField.returnKeyType = .done
            cell.descriptionTextField.keyboardType = .alphabet
            return cell
        case 10:
            cell.descriptionTextField.isHidden = true
            cell.radioCheckView.isHidden = false
   
            if isElsmartRadioSelected{
                cell.elsmartRadioBtn.setImage(UIImage(named:"sel"), for: .normal)
                cell.eacsRadioBtn.setImage(UIImage(named:"un"), for: .normal)
            }else{
                cell.elsmartRadioBtn.setImage(UIImage(named:"un"), for: .normal)
                cell.eacsRadioBtn.setImage(UIImage(named:"sel"), for: .normal)
            }
            return cell
        default:
            return cell
           // fatalError("Unexpected section \(indexPath.row)")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
	
	func getDocumentsDirectory() -> URL {
		let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		return paths[0]
	}
	
    //MARK:- Service Helper Methods
    func getCardHolderData(){
        let UUID : String
        UUID = UIDevice.current.identifierForVendor!.uuidString
        
        let api:String
        if isElsmartRadioSelected{
            api = "\(regObj.regServiceUrl)/getCardholderDataElsmart/'\(regObj.regBadgeNo)'/'\(regObj.regIMEI)'/'\(regObj.regModelNo)'/'\(UUID)'"
        }else{
            api = "\(regObj.regServiceUrl)/getCardholderData/'\(regObj.regBadgeNo)'/'\(regObj.regIMEI)'/'\(regObj.regModelNo)'/'\(UUID)'"
        }
        
        ServiceHelper.callAPIWithParameters([:], method:.get, apiName: api) { (result, error,status) in
            
            guard result != nil else {
                _ = AlertController.alert("", message:  (error?.localizedDescription)!)
                return
            }
            
            guard status == 200 else {
                _ = AlertController.alert("", message:  NSLocalizedString(KSomethingWrong, comment: ""))
                return
            }
            
            let hexString : String = result as! String
        
            if (hexString.contains("`")) {
                let errormessage: String = hexString.replacingOccurrences(of: "`", with: "")
                _ = AlertController.alert("", message:  errormessage.replacingOccurrences(of: "\"", with: ""))
                return
            }
            if ( hexString.contains("<HTML><HEAD>"))
            {
                let errormessage: String = hexString.replacingOccurrences(of: "`", with: "")
                _ = AlertController.alert("", message:  errormessage.replacingOccurrences(of: "\"", with: ""))
                return
            }
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            self.regObj.regStatus = NSLocalizedString(KRegistered, comment: "")
            DispatchQueue.main.async{
                if(self.regObj.regStatus == NSLocalizedString(KUnregistered, comment: "")){
                    self.unRegisterBtn.alpha = 0.5
                    self.unRegisterBtn.isUserInteractionEnabled = false
                }else{
                    self.unRegisterBtn.alpha = 1.0
                    self.unRegisterBtn.isUserInteractionEnabled = true
                }
            }
            
         let newHexString = hexString.replacingOccurrences(of: "\"", with: "")
            let len = newHexString.count
	
          var i = 0
            var mutableArray = [Int8]()
            while i < len {
                let character =  newHexString[newHexString.index(newHexString.startIndex, offsetBy:i)]
							
                let character1 =  newHexString[newHexString.index(newHexString.startIndex, offsetBy: i+1)]

             // print((String(character), radix: 16) + (String(character1), radix: 16))
				let obj = Int8(Int8(String(character), radix: 16)! << 4 + (Int8(String(character1), radix: 16)!))
			 // print(obj)
                mutableArray.append(obj)
                i += 2
            }
           // print(mutableArray)

            
            let filename = self.getDocumentsDirectory().appendingPathComponent(fileNameString)
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

            // Get additional data.
            self.getAdditionalData()
        }
    }
    
    // Call api to get additional data.
    func getAdditionalData(){
        let currentLanguage: String = Locale.current.languageCode!
        let api : String
        if isElsmartRadioSelected{
             api = "\(regObj.regServiceUrl)/GetAdditionalDataElsmart/'\(regObj.regBadgeNo)'/\(currentLanguage)"
        
              self.regObj.regSystem = "elsmart"
        }else{
             api = "\(regObj.regServiceUrl)/GetAdditionalData/'\(regObj.regBadgeNo)'/\(currentLanguage)"
        
            self.regObj.regSystem = "eacs"
        }
        ServiceHelper.callAPIWithParameters([:], method:.get, apiName: api) { (result, error,status) in
            if  let responseString = result as? String{
                
                if (responseString.contains("`"))
                {
                    let errormessage: String = responseString.replacingOccurrences(of: "`", with: "")
                    _ = AlertController.alert("", message:  errormessage.replacingOccurrences(of: "\"", with: ""))
                    return
                }
                if ( responseString.contains("<HTML><HEAD>"))
                {
                     let errormessage: String = responseString.replacingOccurrences(of: "`", with: "")
                     _ = AlertController.alert("", message:  errormessage.replacingOccurrences(of: "\"", with: ""))
                    return
                }
                //Remove inverted commas(") and (\)from API string response
                var newResponseString = responseString.replacingOccurrences(of: "\"", with: "")
                newResponseString = responseString.replacingOccurrences(of: "\\", with: "")
                var additionalDataArr = [String?]()
                additionalDataArr = newResponseString.components(separatedBy: ",")
                if additionalDataArr.count < 4{
                    additionalDataArr = newResponseString.components(separatedBy: "~")
                }

                //Store info into model class from API response
                if let additionalDataArr = additionalDataArr[1]{
                    self.regObj.regTitle = additionalDataArr
                }
                if let additionalDataArr = additionalDataArr[2]  {
                    self.regObj.regDepartment = additionalDataArr
                }
                if let additionalDataArr = additionalDataArr[3]  {
                    self.regObj.regCardExpired = additionalDataArr
                }
                if let additionalDataArr =  additionalDataArr[4] {
                    self.regObj.regCardValidFrom = additionalDataArr
                }
                if let additionalDataArr = additionalDataArr[5]{
                    self.regObj.regCardIsuedFrom = additionalDataArr
                }
                if  let additionalDataArr = additionalDataArr[6]{
                    self.regObj.regUsername = additionalDataArr
                }
                
                
                
                _ = AlertController.alert( NSLocalizedString("Information", comment: ""), message: " \(NSLocalizedString("Secondary Data added successfully", comment: "")) \n\n \(NSLocalizedString("BadgeNo", comment: "")): \(self.regObj.regBadgeNo) \n IMEI: \(self.regObj.regIMEI)", buttons: ["\(NSLocalizedString("Ok", comment: ""))"], tapBlock: { (UIAlertAction, Int) in
                    _ = AlertController.alert(NSLocalizedString("Information", comment: ""), message: " \(NSLocalizedString("Registered successfully", comment: "")) \n\n \(NSLocalizedString("BadgeNo", comment: "")): \(self.regObj.regBadgeNo) \n IMEI: \(self.regObj.regIMEI)",acceptMessage: NSLocalizedString("OK", comment: ""))
                })
				self.saveData()
               
                
            }
            DispatchQueue.main.async {
                self.registrationTableView.reloadData()
                self.registrationTableView.layoutIfNeeded()
            }
            
        }
    }
	
    // MARK:- Save data locally.
	func saveData(){
        
        DispatchQueue.global(qos: .background).async {
            NSUSERDEFAULT.set(self.regObj.regBadgeNo, forKey: "badgeNumber")
            NSUSERDEFAULT.set(self.regObj.regTitle, forKey: "regTitle")
            NSUSERDEFAULT.set(self.regObj.regDepartment, forKey: "regDepartment")
            NSUSERDEFAULT.set(self.regObj.regCardExpired, forKey: "regCardExpired")
            NSUSERDEFAULT.set(self.regObj.regCardValidFrom, forKey: "regCardValidFrom")
            NSUSERDEFAULT.set(self.regObj.regCardIsuedFrom, forKey: "regCardIsuedFrom")
            NSUSERDEFAULT.set(self.regObj.regUsername, forKey: "regUsername")
            NSUSERDEFAULT.set(self.regObj.regIMEI, forKey: "regIMEI")
            NSUSERDEFAULT.set(self.regObj.regModelNo, forKey: "regModel")
            NSUSERDEFAULT.set(self.regObj.regServiceUrl, forKey: "serviceURL")
            NSUSERDEFAULT.set(self.regObj.regStatus, forKey: "regStatus")
            NSUSERDEFAULT.set(self.regObj.regSystem, forKey: "regSystem")
            
            NSUSERDEFAULT.synchronize()
        }
        
	}
    
    // MARK:- Remove data stored locally.
	func removeUser()  {
        
        DispatchQueue.global(qos: .userInteractive).async {
            NSUSERDEFAULT.removeObject(forKey: "badgeNumber")
            NSUSERDEFAULT.removeObject(forKey: "regTitle")
            NSUSERDEFAULT.removeObject(forKey: "regDepartment")
            NSUSERDEFAULT.removeObject(forKey: "regCardExpired")
            NSUSERDEFAULT.removeObject(forKey: "regCardValidFrom")
            NSUSERDEFAULT.removeObject(forKey: "regCardIsuedFrom")
            NSUSERDEFAULT.removeObject(forKey: "regUsername")
            NSUSERDEFAULT.removeObject(forKey: "regIMEI")
            NSUSERDEFAULT.removeObject(forKey: "regModel")
            NSUSERDEFAULT.removeObject(forKey: "serviceURL")
            NSUSERDEFAULT.removeObject(forKey: "regStatus")
            NSUSERDEFAULT.removeObject(forKey: "regSystem")
            self.regObj.regStatus = NSLocalizedString(KUnregistered, comment: "")
            NSUSERDEFAULT.synchronize()
        }
        
	}

    //MARK:- Memory Warning Methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
