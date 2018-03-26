//
//  ProfileViewController.swift
//  journey
//
//  Created by sam de smedt on 25/03/2018.
//  Copyright © 2018 sam de smedt. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var navBarProfile: UIView!
    @IBOutlet weak var viewProfieInfo: UIView!
    @IBOutlet weak var lblHeaderProfile: UILabel!
    let strHeader = "profile"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        //Main navigation bar
        navBarProfile.backgroundColor = whiteColor
        lblHeaderProfile.text = strHeader.uppercased()
        lblHeaderProfile.font = fontHeaderMain
        lblHeaderProfile.textColor = blackColor
        
        //UIView: general info
        viewProfieInfo.applyGradient(colours: [purpleColor, blueColor])
        viewProfieInfo.clipsToBounds = true
        viewProfieInfo.round(corners: [.bottomLeft, .bottomRight], radius: 50)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  


}

