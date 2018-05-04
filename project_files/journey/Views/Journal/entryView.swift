//
//  entryView.swift
//  journey
//
//  Created by sam de smedt on 03/05/2018.
//  Copyright © 2018 sam de smedt. All rights reserved.
//

import UIKit

protocol entryViewDelegate {
  
}

class entryView: UIView {
    
    var delegate: entryViewDelegate?
    
    @IBOutlet weak var viewHeader: UIView!
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var txtEntry: UITextView!
    @IBOutlet weak var imgMood: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var lblCreated: UILabel!
    @IBOutlet weak var btnExpand: UIButton!
    
}

