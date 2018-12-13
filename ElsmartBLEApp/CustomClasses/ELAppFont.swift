//
//  ELAppFont.swift
//  ElsmartBLEApp
//
//  Created by Mahak Mittal on 21/04/18.
//  Copyright © 2018 Mahak_Mobiloitte. All rights reserved.
//

import Foundation
import UIKit

class ELAppFont: NSObject {
    
    class func RobotoRegular(size: CGFloat) -> UIFont {
       return UIFont(name: "Roboto-Regular", size: size)!
    }
    class func RobotoMedium(size: CGFloat) -> UIFont {
        return UIFont(name: "HelveticaNeue-Medium", size: size)!
    }
    class func RobotoBold(size: CGFloat) -> UIFont {
        return UIFont(name: "HelveticaNeue-Bold", size: size)!
    }
    class func RobotoLight(size: CGFloat) -> UIFont {
        return UIFont(name: "HelveticaNeue-Light", size: size)!
    }
}
