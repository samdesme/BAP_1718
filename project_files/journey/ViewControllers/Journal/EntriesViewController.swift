//
//  EntriesViewController.swift
//  journey
//
//  Created by sam de smedt on 27/04/2018.
//  Copyright © 2018 sam de smedt. All rights reserved.
//

import UIKit
import CoreData

class EntriesViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "ENTRIES"
        tabBarController?.selectedIndex = 1
        self.view.backgroundColor = blueColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
