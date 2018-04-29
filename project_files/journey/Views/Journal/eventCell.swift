//
//  eventCell.swift
//  journey
//
//  Created by sam de smedt on 29/04/2018.
//  Copyright © 2018 sam de smedt. All rights reserved.
//

import UIKit

class cellEvent: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var imageEvent: UIImageView!

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        //configure the view for the selected state
    }
    
}

