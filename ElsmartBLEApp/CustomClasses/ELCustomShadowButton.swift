//
//  CustomShadowButton.swift
//  ElsmartBLEApp
//
//  Created by Mahak Mittal on 21/04/18.
//  Copyright © 2018 Mahak_Mobiloitte. All rights reserved.
//

import UIKit

class ELCustomShadowButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        setButtonBorderWithBackgroundColor()
    }
    func setButtonBorderWithBackgroundColor(){
        self.backgroundColor = kAppLightGrayColor
        self.layer.borderColor = kAppGrayShadowColor.cgColor
        self.layer.borderWidth = 1.0
    }

}
