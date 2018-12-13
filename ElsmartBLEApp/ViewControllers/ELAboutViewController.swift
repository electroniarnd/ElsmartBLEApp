//
//  ELAboutViewController.swift
//  ElsmartBLEApp
//
//  Created by Suraj_Mobiloitte on 26/04/18.
//  Copyright © 2018 Mahak_Mobiloitte. All rights reserved.
//

import UIKit

class ELAboutViewController: UIViewController {

    @IBOutlet weak var navigationBarHeightConst: NSLayoutConstraint!
    @IBOutlet weak var varsionHeading: UILabel!
    @IBOutlet weak var versionDetail: UILabel!
    
    //MARK:- View life cycle method.
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpInitial()
    }
    
    //MARK:- Helper Methods
    func setUpInitial(){
        if kWindowHeight() > 667{
            navigationBarHeightConst.constant += 20
        }
        varsionHeading.text = NSLocalizedString(KVersion, comment: "")
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            versionDetail.text! = NSLocalizedString(mElsmart, comment: "") + " \(version)"
        }
    }
    
    //MARK:- UIButtonAction Methods.
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK:- Memory management method.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
