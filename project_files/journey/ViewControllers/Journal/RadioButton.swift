//
//  RadioButton.swift
//  journey
//
//  Created by sam de smedt on 07/05/2018.
//  Copyright © 2018 sam de smedt. All rights reserved.
//

import UIKit

class RadioButton: UIButton {

    var alternateButton:Array<RadioButton>?
    
    override func awakeFromNib() {
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 2.0
        self.layer.masksToBounds = true
    }
    
    func unselectAlternateButtons(){
        if alternateButton != nil {
            self.isSelected = true
            
            for aButton:RadioButton in alternateButton! {
                aButton.isSelected = false
            }
        }else{
            toggleButton()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        unselectAlternateButtons()
        super.touchesBegan(touches, with: event)
    }
    
    func toggleButton(){
        self.isSelected = !isSelected
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.layer.borderColor = blueColor.cgColor
            } else {
                self.layer.borderColor = lightGreyColor.cgColor
            }
        }
    }
}
