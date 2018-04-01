//
//  ProfileKeywords.swift
//  journey
//
//  Created by sam de smedt on 31/03/2018.
//  Copyright © 2018 sam de smedt. All rights reserved.
//


import UIKit

protocol ProfileKeywordsDelegate {
    
}

class ProfileKeywords: UIView {
    
    var delegate: ProfileKeywordsDelegate?
    
  
    @IBOutlet weak var keyword1: UILabel!
    @IBOutlet weak var keyword2: UILabel!
    @IBOutlet weak var keyword3: UILabel!
    @IBOutlet weak var btnEditKeywords: UIButton!
    @IBOutlet weak var viewBtnSadow: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    
}

