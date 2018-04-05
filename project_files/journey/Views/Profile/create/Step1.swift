//
//  Step1.swift
//  journey
//
//  Created by sam de smedt on 05/04/2018.
//  Copyright © 2018 sam de smedt. All rights reserved.
//

import UIKit

protocol createStep1Delegate {
    
}

class createStep1: UIView {
    
    var delegate: createStep1Delegate?
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtAbout: UITextView!
    @IBOutlet weak var lblAbout: UILabel!
    @IBOutlet weak var btnToStep2: UIButton!
    
}

