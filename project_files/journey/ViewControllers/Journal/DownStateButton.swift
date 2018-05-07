//
//  DownStateButton.swift
//  journey
//
//  Created by sam de smedt on 07/05/2018.
//  Copyright © 2018 sam de smedt. All rights reserved.
//

import UIKit

class DownStateButton : UIButton {
    
    var myAlternateButton:Array<DownStateButton>?
    
    var downStateImage:String? = "ic_mood4_outline.pdf"{
        
        didSet{
            
            if downStateImage != nil {
                
                self.setImage(UIImage(named: downStateImage!), for: UIControlState.selected)
            }
        }
    }
    
    func unselectAlternateButtons(){
        
        if myAlternateButton != nil {
            
            self.isSelected = true
            
            for aButton:DownStateButton in myAlternateButton! {
                
                aButton.isSelected = false
            }
            
        }else{
            
            toggleButton()
        }
    }
    
     func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        unselectAlternateButtons()
        super.touchesBegan(touches as! Set<UITouch>, with: event)
    }
    
    func toggleButton(){
        
        if self.isSelected==false{
            
            self.isSelected = true
        }else {
            
            self.isSelected = false
        }
    }
}
