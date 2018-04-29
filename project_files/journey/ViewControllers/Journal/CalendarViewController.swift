//
//  CalendarViewController.swift
//  journey
//
//  Created by sam de smedt on 27/04/2018.
//  Copyright © 2018 sam de smedt. All rights reserved.
//

import UIKit
import FSCalendar
import CoreData


class CalendarViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate {
    
    @IBOutlet var viewMain: UIView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var tableView: UITableView!
    
   fileprivate weak var calendar: FSCalendar!

    let  topGradientLayer = CAGradientLayer()
    let  gradientLayer = CAGradientLayer()
    var viewTopGradient = UIView()
    var viewCalendar = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        createCalendarView()
        tabBarController?.selectedIndex = 0
        self.title = "CALENDAR"
        self.view.backgroundColor = lightGreyColor
        

        
    }
    
    func createCalendarView() {
        
        let navBar = navigationController?.navigationBar
        
        // CONTENT
        self.view.backgroundColor = lightGreyColor
        
        //set up a gradient at the top of the page to create a 3D effect
        viewTopGradient.clipsToBounds = false
        viewTopGradient.backgroundColor = UIColor.clear
        topGradientLayer.frame = CGRect(x: 0, y: (navBar?.frame.size.height)!, width: self.view.frame.size.width, height: (self.view.frame.size.height/3)/2)
        topGradientLayer.colors = [blackColor.withAlphaComponent(0.05).cgColor, UIColor.clear.cgColor]
        topGradientLayer.locations = [ 0.0, 1.0]
        
        self.view.addSubview(viewTopGradient)
        viewTopGradient.layer.addSublayer(topGradientLayer)
        
        createCalendar()
        

    }
    
    func createCalendar() {
        
        let navBar = navigationController?.navigationBar

        
        viewCalendar.frame = CGRect(x: 15, y: (navBar?.frame.size.height)!*2, width: self.view.frame.size.width - 30, height: (self.view.frame.size.height/3))
        viewCalendar.backgroundColor = whiteColor
        
        // edit corner radius of the view
        viewCalendar.layer.cornerRadius = 25
        
        // add a drop shadow to the view
        gradientLayer.frame = viewCalendar.bounds
        gradientLayer.colors = [purpleColor.cgColor, blueColor.cgColor]
        
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        
        // add a drop shadow to the gradient layer
        viewCalendar.layer.shadowColor = blackColor.cgColor
        viewCalendar.layer.shadowOffset = CGSize(width: 6, height: 6)
        viewCalendar.layer.shadowOpacity = 0.05
        //viewCalendar.layer.shadowRadius = 5.0
        viewCalendar.layer.shadowRadius = 10.0
        
        // edit corner radius op the gradient layer
        gradientLayer.cornerRadius = 25
        
        //add gradient layer to UIView
        viewCalendar.layer.addSublayer(gradientLayer)
        
        self.view.addSubview(viewCalendar)
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
