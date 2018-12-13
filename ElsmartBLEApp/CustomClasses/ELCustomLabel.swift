//
//  CustomLabel.swift
//  ElsmartBLEApp
//
//  Created by Mahak Mittal on 21/04/18.
//  Copyright © 2018 Mahak_Mobiloitte. All rights reserved.
//

import UIKit

class ELCustomLabel: UILabel {

    override func awakeFromNib() {
        super.awakeFromNib()
        changeFontName()
    }
    
    func changeFontName()
    {
        self.font = ELAppFont.RobotoRegular(size: 18)
    }
}
