//
//  ELDeviceListTableCell.swift
//  ElsmartBLEApp
//
//  Created by Rakesh Bajeli on 26/04/18.
//  Copyright © 2018 Mahak_Mobiloitte. All rights reserved.
//

import UIKit

class ELDeviceListTableCell: UITableViewCell {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var deviceAddressLbl: UILabel!
    @IBOutlet weak var deviceRssiLbl: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
