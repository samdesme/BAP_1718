//
//  globalConstant.swift
//  journey
//
//  Created by sam de smedt on 25/03/2018.
//  Copyright © 2018 sam de smedt. All rights reserved.
//

import Foundation
import UIKit


// Configuration file



//COLORS

let purpleColor = UIColor(netHex: 0xC99FC9)
let blueColor = UIColor(netHex: 0x82D3EC)
let lightBlueColor = UIColor(netHex: 0xB2E0F1)
let lightGreyColor = UIColor(netHex: 0xF2F2F2)
let whiteColor = UIColor.white
let blackColor = UIColor.black



//FONTS

//font medium
let font18Med = UIFont(name: "BrandonGrotesque-Medium", size: 18)

//font regular


//header fonts
let fontHeaderMain = UIFont(name:"BrandonGrotesque-Regular", size:19)
let fontHeaderSub = UIFont(name:"BrandonGrotesque-Regular", size:19)

//text fonts
let fontLblFirstName = UIFont(name:"BrandonGrotesque-Light", size:50)

let fontTextLight = UIFont(name:"BrandonGrotesque-Light", size:22)
let fontMainLight = UIFont(name:"BrandonGrotesque-Light", size:20)
let fontMainRegular = UIFont(name:"BrandonGrotesque-Regular", size:20)
let fontKeywordRegular = UIFont(name:"BrandonGrotesque-Regular", size:21)

//button fonts
let fontBtnSmall = UIFont(name:"BrandonGrotesque-Regular", size:24)


//EXTENTIONS

extension UIColor {
    
    //extension for converting RGBA to hex strings
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

extension UILabel {
    
    //extention to set lineSpacing of UILabel
    func setLineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0) {
        
        guard let labelText = self.text else { return }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        
        let attributedString:NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }
        
        // Line spacing attribute
        attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        self.attributedText = attributedString
    }
}


extension UIView {
    
    // extention for creating gradients
    func applyGradient(colours: [UIColor]) -> Void {
        self.applyGradient(colours: colours, locations: nil)
    }
    
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.startPoint = CGPoint(x:0, y:0)
        gradient.endPoint = CGPoint(x:1, y:1)
        //For transparency:
        // gradient.colors = colours.map { $0.withAlphaComponent(0.90).cgColor }
        //gradient.locations = locations
        self.layer.addSublayer(gradient)
    }
    
   /*
    
    func applyGradientButton(colours: [UIColor]) -> Void {
        self.applyGradientButton(colours, locations: nil)
    }
    
    func applyGradientButton(colours: [UIColor], locations: [NSNumber]?) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.addSublayer(gradient)
    }*/
 
    // extention for changing the radius of individual corners of a UIView
    func round(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    // extention for creating a dropshadow to UIView
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
  
    
}









