//
//  CreateStep2.swift
//  journey
//
//  Created by sam de smedt on 11/04/2018.
//  Copyright © 2018 sam de smedt. All rights reserved.
//

import UIKit

protocol CreateStep2Delegate {
    func addKeyword()
}

class CreateStep2: UIView {
    
    var delegate: CreateStep2Delegate?
    
    @IBOutlet weak var lblMain: UILabel!
    @IBOutlet weak var lblSub: UILabel!
    
}
