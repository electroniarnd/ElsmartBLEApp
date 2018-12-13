//
//  ELRegistrationTableViewCell.swift
//  ElsmartBLEApp
//
//  Created by Suraj_Mobiloitte on 24/04/18.
//  Copyright © 2018 Mahak_Mobiloitte. All rights reserved.
//

import UIKit

class ELRegistrationTableViewCell: UITableViewCell {

    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var underlineLbl: UILabel!
    @IBOutlet weak var radioCheckView: UIView!
    @IBOutlet weak var eacsRadioBtn: UIButton!
    @IBOutlet weak var eacsLbl: UILabel!
    @IBOutlet weak var elsmartRadioBtn: UIButton!
    @IBOutlet weak var elsmartLbl: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
