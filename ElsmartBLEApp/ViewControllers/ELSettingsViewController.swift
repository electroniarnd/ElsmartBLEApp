//
//  ELSettingsViewController.swift
//  ElsmartBLEApp
//
//  Created by El-00349 on 05/12/2018.
//  Copyright © 2018 Mahak_Mobiloitte. All rights reserved.
//

import UIKit

class ELSettingsViewController: UIViewController {
  
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var biometricSW: UISwitch!
    @IBOutlet weak var vibration: UISwitch!
    @IBOutlet weak var autosw: UISwitch!
    var autovalue: String?
    var vibrationvalue: String?
    var biometricvalue: String?
    override func viewDidLoad() {
    super.viewDidLoad()
    //  setUpInitial()
        // Do any additional setup after loading the view.
        self.fetchLastRegisteredUserDataLocally()
    }
    
    
    
    func fetchLastRegisteredUserDataLocally(){
            let AutoValue = defaults.string(forKey: "AutoValue")
            self.autovalue=AutoValue  as! String?
            let VibrationValue = defaults.string(forKey: "VibrationValue")
            self.vibrationvalue=VibrationValue  as! String?
            let BiometricValue = defaults.string(forKey: "BiometricValue")
            self.biometricvalue=BiometricValue  as! String?
            
            if( self.autovalue == "1" )
            {
                self.autosw.setOn(true, animated: true)
            }
            else
            {
                self.autosw.setOn(false, animated: true)
            }
            
            if( self.vibrationvalue == "1" )
            {
                self.vibration.setOn(true, animated: true)
            }
            else
            {
                self.vibration.setOn(false, animated: true)
            }
            if( self.biometricvalue == "1" )
            {
                self.biometricSW.setOn(true, animated: true)
            }
            else
            {
                self.biometricSW.setOn(false, animated: true)
            }
    }
    
    
    @IBAction func swAuto(_ sender: UISwitch) {
      if  sender.isOn
      {
         defaults.set("1", forKey: "AutoValue")
      }
      else{
        defaults.set("0", forKey: "AutoValue")
          }
    }
    
    @IBAction func swVib(_ sender: UISwitch) {
        
        if  sender.isOn
        {
             defaults.set("1", forKey: "VibrationValue")
        }
        else{
            defaults.set("0", forKey: "VibrationValue")
        }
    }
    @IBAction func swBio(_ sender: UISwitch) {
        if  sender.isOn
        {
            defaults.set("1", forKey: "BiometricValue")
        }
        else{
           defaults.set("0", forKey: "BiometricValue")
        }
    }
    
    @IBAction func backbtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setUpInitial(){
       
    }
    // MARK:- Memory management method.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func saveDataAuto(){
        
          defaults.set(self.autovalue, forKey: "AutoValue")
    }
    
    func saveDataVibration(){
        
        defaults.set(self.vibration, forKey: "VibrationValue")        
    }
    
    func saveDatabiometric(){
    
            defaults.set(self.biometricvalue, forKey: "BiometricValue")
    }

}
