//
//  ELRegistrationInfo.swift
//  ElsmartBLEApp
//
//  Created by Suraj_Mobiloitte on 27/04/18.
//  Copyright © 2018 Mahak_Mobiloitte. All rights reserved.
//

import UIKit


class ELRegistrationInfo: NSObject {
    
    static let registrationObject = ELRegistrationInfo()

        var regUsername = ""
        var regBadgeNo = ""
        var regTitle = ""
        var regDepartment = ""
        var regCardValidFrom = ""
        var regCardIsuedFrom = ""
        var regCardExpired = ""
        var regIMEI = ""
        var regModelNo = ""
        var regStatus = NSLocalizedString(KUnregistered, comment: "")
        var regServiceUrl = "http://93.95.24.25/Emobile/Service1.svc"
        var regSystem = ""
}
