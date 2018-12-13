//
//  ViewController.swift
//  ElsmartBLEApp
//
//  Created by Mahak_Mobiloitte on 20/04/18.
//  vghCopyright © 2018 Mahak_Mobiloitte. All rights reserved.
//

import UIKit
import SwiftyBluetooth
import CoreBluetooth
import AudioToolbox

class ELHomeVC: UIViewController,UITableViewDataSource,UITableViewDelegate,CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
    }
    
    @IBOutlet weak var homeTitleLbl: ELCustomLabel!
    @IBOutlet weak var connectBtn: UIButton!
    @IBOutlet weak var badgeNoLbl: ELCustomLabel!
    @IBOutlet weak var nameLbl: ELCustomLabel!
    @IBOutlet weak var statusDescriptionLbl: ELCustomLabel!
    @IBOutlet weak var deviceNameLbl: ELCustomLabel!
  //  @IBOutlet weak var punchBtn: ELCustomShadowButton!
    @IBOutlet weak var homeMenuView: UIView!
    @IBOutlet weak var responseView: UIView!
    @IBOutlet weak var homeOptionTableView: UITableView!
    @IBOutlet weak var navigationViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var statusIdLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
   // @IBOutlet weak var badgeNoLabel: UILabel!
    @IBOutlet weak var checkMarkBtn: UIButton!
    
    @IBOutlet weak var dir: UILabel!
    
    var optionArrayList = [String]()

    
    var dateFinal = ""
    var nameStr = ""
    
    //MARK: View Controller Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkMarkBtn.isHidden = true
        // Do any additional setup after loading the view, typically from a nib.
        self.setUpInitial()

    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        homeMenuView.isHidden = true
    }
	
	override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
		updateLabels()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateUserInfo(notification:)), name: NSNotification.Name(rawValue: "punchInformation"), object: nil)
		
	}
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "punchInformation"), object: nil)
    }
	
    //MARK:- Shhow updated data from notification.
    @objc func updateUserInfo( notification : NSNotification) {
        if let info = notification.userInfo as? Dictionary<String,Any>{
            DispatchQueue.main.async {
               let dict = info.validatedValue("UserInfo", expected: NSDictionary() as AnyObject) as? Dictionary<String,Any>
                self.responseView.isHidden = false
                self.statusIdLabel.text = dict?.validatedValue("badgeNameNo", expected: "" as AnyObject) as? String
                self.dateLabel.text = dict?.validatedValue("dateTime", expected: "" as AnyObject) as? String
                self.dir.text = dict?.validatedValue("Dir", expected: "" as AnyObject) as? String
                self.checkMarkBtn.isHidden = false

            }
        }
    }

    
    //MARK: Helper Methods
    func setUpInitial(){
        if kWindowHeight() > 667{
            navigationViewHeightConst.constant += 20
        }
        responseView.isHidden = true
     //   punchBtn.setTitle(NSLocalizedString(kPunch, comment: ""), for: .normal)
      
        homeOptionTableView.rowHeight = UITableViewAutomaticDimension
        homeOptionTableView.estimatedRowHeight = 55
        homeOptionTableView.isScrollEnabled = false
        optionArrayList = [NSLocalizedString(KRegistration, comment: ""),  NSLocalizedString(KLogs, comment: ""),NSLocalizedString(KVSetting, comment: ""), NSLocalizedString(KRegisteredTerminal, comment: ""), NSLocalizedString(KAbout, comment: "")]
        
        //Adding drop shadow effect to homeOptionView
        homeMenuView.layer.shadowOpacity = 0.7
        homeMenuView.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)
        homeMenuView.layer.shadowRadius = 5.0
        homeMenuView.layer.shadowColor = UIColor.darkGray.cgColor
			
			
    }
    
    
    //MARK: TableVIewDelegates and datasource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionArrayList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ELHomeOptionTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ELHomeOptionTableViewCell", for: indexPath) as! ELHomeOptionTableViewCell
        cell.selectionStyle = .none
          cell.optionLabel.text = self.optionArrayList[indexPath.item]
          print(cell.optionLabel?.text)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            DispatchQueue.main.async {
                let registrationVC = self.storyboard?.instantiateViewController(withIdentifier: "ELRegistrationVC") as! ELRegistrationVC
                self.present(registrationVC, animated: true, completion: nil)
            }
            homeMenuView.isHidden = !homeMenuView.isHidden
        }
        
        
        
        else if indexPath.row == 1{
            DispatchQueue.main.async {
                let SettingsVC = self.storyboard?.instantiateViewController(withIdentifier: "ELLogsViewController") as! ELLogsViewController
                self.present(SettingsVC, animated: true, completion: nil)
            }
            homeMenuView.isHidden = !homeMenuView.isHidden
        }
        
        
        
        else if indexPath.row == 2{
            DispatchQueue.main.async {
                let SettingsVC = self.storyboard?.instantiateViewController(withIdentifier: "ELSettingsViewController") as! ELSettingsViewController
                self.present(SettingsVC, animated: true, completion: nil)
            }
            homeMenuView.isHidden = !homeMenuView.isHidden
        }
            
            
        else if indexPath.row == 3{
            DispatchQueue.main.async {
                let aboutVC = self.storyboard?.instantiateViewController(withIdentifier: "ELTerminalViewController") as! ELTerminalViewController
                self.present(aboutVC, animated: true, completion: nil)
            }
            homeMenuView.isHidden = !homeMenuView.isHidden
        }
        
        
        else if indexPath.row == 4{
             DispatchQueue.main.async {
            let aboutVC = self.storyboard?.instantiateViewController(withIdentifier: "ELAboutViewController") as! ELAboutViewController
            self.present(aboutVC, animated: true, completion: nil)
            }
            homeMenuView.isHidden = !homeMenuView.isHidden
        }
        
        
        
        
       
        
        
       
            
            
        
        
       
    }
    
    //MARK: UIButton Action Methods
    @IBAction func dotBtnAction(_ sender: UIButton) {
        homeMenuView.isHidden = !homeMenuView.isHidden
    }
    
    @IBAction func punchBtnAction(_ sender: ELCustomShadowButton) {

    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    @IBAction func connectAction(_ sender: UIButton) {
			if let badgeNumber = NSUSERDEFAULT.value(forKey: "badgeNumber") {
				print(badgeNumber)

				SwiftyBluetooth.asyncState { (AsyncCentralState) in
					switch AsyncCentralState{
					case .poweredOn:
						DispatchQueue.main.async {
							let deviceVC = self.storyboard?.instantiateViewController(withIdentifier: "ELDeviceListVC") as! ELDeviceListVC
							deviceVC.modalTransitionStyle = .crossDissolve
							deviceVC.modalPresentationStyle = .overFullScreen
							self.present(deviceVC, animated: true, completion: nil)
						}
						break
					default:
						let opts = [CBCentralManagerOptionShowPowerAlertKey: true]
						CBCentralManager(delegate: self, queue: nil, options: opts)
						break
					}
				}
			} else {
				_ = AlertController.alert("", message: NSLocalizedString(KUnregisteredUser, comment: ""))
				
			}
			
    }
	
	func updateLabels()  {
		if let badgeNumber = NSUSERDEFAULT.value(forKey: "badgeNumber") {
				statusDescriptionLbl.text = NSLocalizedString(KRegistered, comment: "")
				statusDescriptionLbl.backgroundColor = .green
				badgeNoLbl.text = badgeNumber as? String
				nameLbl.text = NSUSERDEFAULT.value(forKey: "regUsername") as? String
               // self.badgeNoLabel.text = badgeNumber as? String
		} else {
				statusDescriptionLbl.text = NSLocalizedString(KUnregistered, comment: "")
				statusDescriptionLbl.backgroundColor = .red
		}
	}
    
    //MARK: Memory Warning Methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	func updateUIForSuccess()  {
		
	}
	func updateUIForFail()  {
		
	}

    
}

