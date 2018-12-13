//
//  ELSettingsViewController.swift
//  ElsmartBLEApp
//
//  Created by El-00349 on 05/12/2018.
//  Copyright © 2018 Mahak_Mobiloitte. All rights reserved.
//

import UIKit

class ELSettingsViewController: UIViewController {

    override func viewDidLoad() {
    super.viewDidLoad()
    //  setUpInitial()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func swAuto(_ sender: UISwitch) {
      if  sender.isOn
      {
        print("Pradeep")
        
        }
        
    }
    
    @IBAction func swVib(_ sender: UISwitch) {
        
        if  sender.isOn
        {
            print("PradeepVib")
            
        }
    }
    
    
    @IBAction func swBio(_ sender: UISwitch) {
        if  sender.isOn
        {
            print("PradeepBio")
            
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

}
