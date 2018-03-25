//
//  globalConstant.swift
//  journey
//
//  Created by sam de smedt on 25/03/2018.
//  Copyright © 2018 sam de smedt. All rights reserved.
//

import Foundation
import UIKit

// Configuration


// Colors
let purpleColor = UIColor(netHex: 0xC99FC9)
let whiteColor = UIColor.white


// font light
let font18base = UIFont(name: "SFUIText-Medium", size: 18)

// font medium
let font16regular = UIFont(name: "SFUIText-Regular", size: 16)

//font regular







extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

