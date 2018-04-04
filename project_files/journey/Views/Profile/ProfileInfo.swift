//
//  ProfileInfo.swift
//  journey
//
//  Created by sam de smedt on 31/03/2018.
//  Copyright © 2018 sam de smedt. All rights reserved.
//


import UIKit

protocol ProfileInfoDelegate {
    func create1()
}

class ProfileInfo: UIView {
    
    var delegate: ProfileInfoDelegate?
    
    @IBOutlet weak var txtAbout: UITextView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnEditInfo: UIButton!
    @IBOutlet weak var viewShadow: UIView!
    @IBOutlet weak var viewTopGradient: UIView!
    
  
/*
    @IBAction func pushStep1(_ sender: Any) {
        delegate?.create1()
    }*/
    
    
    
}
