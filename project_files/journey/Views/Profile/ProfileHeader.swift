//
//  ProfileHeader.swift
//  journey
//
//  Created by sam de smedt on 31/03/2018.
//  Copyright © 2018 sam de smedt. All rights reserved.
//

import UIKit

protocol ProfileHeaderDelegate {
   
}

class ProfileHeader: UIView {
    
    var delegate: ProfileHeaderDelegate?
  
    @IBOutlet weak var lblHeader: UILabel!
    

}

