//
//  StatsTabBarController.swift
//  journey
//
//  Created by sam de smedt on 05/06/2018.
//  Copyright © 2018 sam de smedt. All rights reserved.
//

import UIKit
import CoreData

class StatsTabBarController: UITabBarController {
    
    let vcMood = MoodViewController()
    let vcMentalHealth = MentalHealthViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let attributes = [NSAttributedStringKey.font: fontHeaderMain,
                          NSAttributedStringKey.foregroundColor: blackColor]
        
        let viewControllerList = [ vcMood, vcMentalHealth ]
        
        vcMood.tabBarItem = UITabBarItem(title: "MOOD", image: nil, selectedImage: nil)
        vcMentalHealth.tabBarItem = UITabBarItem(title: "MENTAL HEALTH", image: nil, selectedImage: nil)
        
        vcMood.tabBarItem.setTitleTextAttributes(attributes, for: .normal)
        vcMentalHealth.tabBarItem.setTitleTextAttributes(attributes, for: .normal)
        
        tabBar.selectionIndicatorImage = UIImage().createSelectionIndicator(color: blackColor, size: CGSize(width: tabBar.frame.width/CGFloat(tabBar.items!.count), height: tabBar.frame.height - 2), lineWidth: 2.0)
        
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



