//
//  JournalTabBarController.swift
//  journey
//
//  Created by sam de smedt on 28/04/2018.
//  Copyright © 2018 sam de smedt. All rights reserved.
//

import UIKit
import CoreData

class JournalTabBarController: UITabBarController {
    
    let vcCalendar = CalendarViewController()
    let vcEnties = EntriesViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let attributes = [NSAttributedStringKey.font: fontHeaderMain,
                          NSAttributedStringKey.foregroundColor: blackColor]
        
        let viewControllerList = [ vcCalendar, vcEnties ]

        vcCalendar.tabBarItem = UITabBarItem(title: "CALENDAR", image: nil, selectedImage: nil)
        vcEnties.tabBarItem = UITabBarItem(title: "ENTRIES", image: nil, selectedImage: nil)
        
        tabBar.selectionIndicatorImage = UIImage().createSelectionIndicator(color: blackColor, size: CGSize(width: tabBar.frame.width/CGFloat(tabBar.items!.count), height: tabBar.frame.height - 2), lineWidth: 2.0)
        
        UITabBarItem.appearance().setTitleTextAttributes(attributes, for: .normal)
        
        viewControllers = viewControllerList
        
        
    }
    
    override func viewDidLayoutSubviews() {
      
        let navBar = navigationController?.navigationBar
        
        tabBar.frame = CGRect(x: 0, y: 0, width: (navBar?.frame.width)!, height: (navBar?.frame.height)!)
        tabBar.clipsToBounds = true
        
        navBar?.applyNavigationGradient(colors: [whiteColor , whiteColor])
        navBar?.addSubview(self.tabBar)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


