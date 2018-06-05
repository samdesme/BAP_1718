//
//  MentalHealthViewController.swift
//  journey
//
//  Created by sam de smedt on 05/06/2018.
//  Copyright © 2018 sam de smedt. All rights reserved.
//

import UIKit

class MentalHealthViewController: UIViewController {
    
    @IBOutlet var viewMain: UIView!
    @IBOutlet weak var backButtonItem: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tabBarController?.selectedIndex = 1
        self.title = "MENTAL HEALTH"
        self.view.backgroundColor = lightGreyColor
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
