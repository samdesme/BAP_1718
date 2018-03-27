//
//  ProfileViewController.swift
//  journey
//
//  Created by sam de smedt on 25/03/2018.
//  Copyright © 2018 sam de smedt. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    
    //Outlet referentions
    @IBOutlet weak var viewShadow: UIView!
    @IBOutlet weak var navBarProfile: UIView!
    @IBOutlet weak var viewProfieInfo: UIView!
    @IBOutlet weak var lblHeaderProfile: UILabel!

    // VARIABELS
    let  gradientLayer = CAGradientLayer()
    let strHeader = "profile"
    
    //Convert UILayer to CALayer to create shadows and gradients
    var caLayer: CALayer {
        return viewShadow.layer
    }
    
   //Load view controller
    override func viewDidLoad() {
        super.viewDidLoad()

        //Functions
        setUpMainNavBar()
        setUpCAViewUserInfo()
    
    }
    
    
    func setUpCAViewUserInfo() {
        
        //Set up bounds & styling for UIView (general user info)
        viewShadow.clipsToBounds = false
        viewProfieInfo.clipsToBounds = false
        viewShadow.backgroundColor = nil
        
        //Add gradient
        gradientLayer.frame = viewShadow.bounds
        gradientLayer.colors = [purpleColor.cgColor, blueColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        
        //Add drop shadow
        gradientLayer.shadowOpacity = 0.15
        gradientLayer.shadowRadius = 15.0
        gradientLayer.shadowOffset = CGSize(width: 0.0, height: 8.0)
        
        //Round bottom corners
        gradientLayer.cornerRadius = 50
        gradientLayer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        //Add gradient layer to UIView
        viewShadow.layer.addSublayer(gradientLayer)

    }
    
    func setUpMainNavBar() {
        
        //set up main navigation bar
        navBarProfile.backgroundColor = whiteColor
        lblHeaderProfile.text = strHeader.uppercased()
        lblHeaderProfile.font = fontHeaderMain
        lblHeaderProfile.textColor = blackColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  


}

