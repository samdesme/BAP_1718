//
//  Step1.swift
//  journey
//
//  Created by sam de smedt on 05/04/2018.
//  Copyright © 2018 sam de smedt. All rights reserved.
//

import UIKit

protocol CreateStep1Delegate {
}

class CreateStep1: UIView {
    
    var delegate: CreateStep1Delegate?
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtAbout: UITextView!
    @IBOutlet weak var lblAbout: UILabel!
    @IBOutlet weak var btnToStep2: UIButton!
    @IBOutlet weak var btnNextShadow: UIView!
    
    
    
}

