//
//  tabBarController.swift
//  journey
//
//  Created by sam de smedt on 16/05/2018.
//  Copyright © 2018 sam de smedt. All rights reserved.
//

import UIKit
import CoreData

class tabBarController: UITabBarController {
    
    let vcCalendar = CalendarViewController()
    let vcEnties = EntriesViewController()
    let vcGoals = GoalsViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewControllerList = [ vcCalendar, vcEnties, vcGoals ]
        viewControllers = viewControllerList

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

