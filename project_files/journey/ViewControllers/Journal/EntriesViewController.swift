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

    var selectedDate : String = ""
    var scrollView = UIScrollView()
    var viewTopGradient = UIView()
    let  topGradientLayer = CAGradientLayer()
    
    var btnAdd = UIButton()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    let viewEntry = Bundle.main.loadNibNamed("entryView", owner: nil, options: nil)?.first as! entryView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "ENTRIES"
        tabBarController?.selectedIndex = 1
        self.view.backgroundColor = lightGreyColor

        setUpBtnAdd()
    }
    
    func createEntriesViewToday() {
        
        // CONTENT
        scrollView.backgroundColor = UIColor.clear
        scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: (self.view.frame.size.height/4)*3)
        scrollView.isScrollEnabled = true
        
        let verticalConstraint = NSLayoutConstraint(item: scrollView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.view.safeAreaLayoutGuide, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
        
        self.view.addConstraints([verticalConstraint])
        
        //set up a gradient at the top of the page to create a 3D effect
        viewTopGradient.clipsToBounds = false
        viewTopGradient.backgroundColor = UIColor.clear
        topGradientLayer.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: (self.view.frame.size.height/3)/2)
        topGradientLayer.colors = [blackColor.withAlphaComponent(0.05).cgColor, UIColor.clear.cgColor]
        topGradientLayer.locations = [ 0.0, 1.0]
        
       viewTopGradient.layer.addSublayer(topGradientLayer)
       scrollView.addSubview(viewTopGradient)
       setUpTodaysEntry()
    }
    
    func setUpTodaysEntry() {
        let gradientLayer = CAGradientLayer()
        viewEntry.frame = CGRect(x: 15, y: 60, width: self.view.frame.size.width - 30, height: (self.view.frame.size.height/3))
        
        viewEntry.clipsToBounds = false
        viewEntry.backgroundColor = whiteColor
        viewEntry.layer.cornerRadius = 25
        viewEntry.layer.shadowColor = blackColor.cgColor
        viewEntry.layer.shadowOffset = CGSize(width: 6, height: 6)
        viewEntry.layer.shadowOpacity = 0.05
        viewEntry.layer.shadowRadius = 10.0
        
        viewEntry.viewHeader.frame = CGRect(x: 0, y: 0, width: viewEntry.frame.size.width, height: 45)
        viewEntry.viewHeader.backgroundColor = UIColor.clear
        
        gradientLayer.frame = CGRect(x: 0, y: 0, width: viewEntry.frame.size.width, height: viewEntry.viewHeader.frame.size.height)
        gradientLayer.colors = [blueColor.cgColor, lightBlueColor.cgColor]
        gradientLayer.locations = [ 0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.cornerRadius = 25
        gradientLayer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        viewEntry.viewHeader.layer.insertSublayer(gradientLayer, at: 0)
        
        viewEntry.lblDate.frame = CGRect(x: 0, y: 0, width: viewEntry.viewHeader.frame.size.width, height: viewEntry.viewHeader.frame.size.height)
        viewEntry.lblDate.text = "MONDAY, 30 SEP"
        viewEntry.lblDate.font = fontMainMedium
        viewEntry.lblDate.textColor = whiteColor
        viewEntry.lblDate.textAlignment = .right

        viewEntry.viewContent.frame = CGRect(x: 0, y: viewEntry.viewHeader.frame.size.height, width: viewEntry.frame.size.width, height: 200)
        viewEntry.viewContent.backgroundColor = whiteColor

        viewEntry.imgMood.frame = CGRect(x: 15, y: 15, width: 60, height: 60)
        viewEntry.imgMood.image = UIImage(named: "ic_mood4_outline")
        
        viewEntry.txtEntry.frame = CGRect(x: viewEntry.imgMood.frame.size.width + 15*2, y: viewEntry.viewContent.frame.size.height/4, width: viewEntry.frame.size.width - 90 - 60, height: viewEntry.viewContent.frame.size.height/2)
        viewEntry.txtEntry.text = "Example text view. Example text view. Example text view. Example text view"
        viewEntry.txtEntry.font = fontInput
        
        viewEntry.lblTitle.frame =  CGRect(x: viewEntry.imgMood.frame.size.width + 15*2, y: 0, width: viewEntry.txtEntry.frame.size.width*0.75, height: viewEntry.viewContent.frame.size.height/4)
        viewEntry.lblTitle.text = "Example Title"
        viewEntry.lblTitle.font = fontMainRegular

        
        viewEntry.lblCreated.frame =  CGRect(x: viewEntry.imgMood.frame.size.width + 15*2 + viewEntry.lblTitle.frame.size.width, y: 0, width: viewEntry.txtEntry.frame.size.width*0.25, height: viewEntry.viewContent.frame.size.height/4)
        viewEntry.lblCreated.textAlignment = .right
        viewEntry.lblCreated.text = "19:22"
        viewEntry.lblCreated.font = fontMainLight19
        
        viewEntry.btnEdit.frame =  CGRect(x: viewEntry.frame.width - 45, y: (viewEntry.viewContent.frame.size.height - 30)/2, width: 30, height: 30)
        viewEntry.btnEdit.setTitle("\u{2228}",for: .normal)
        viewEntry.btnEdit.tintColor = blueColor
        viewEntry.btnEdit.titleLabel?.font = font17Bld
        viewEntry.btnEdit.titleLabel?.textAlignment = .center
        viewEntry.btnEdit.backgroundColor = UIColor.clear
        viewEntry.btnEdit.layer.cornerRadius = 15
        viewEntry.btnEdit.layer.borderWidth = 1.5
        viewEntry.btnEdit.layer.borderColor = blueColor.cgColor
        
        viewEntry.btnExpand.frame =  CGRect(x: (viewEntry.frame.width - 30)/2, y: viewEntry.viewContent.frame.size.height - 20, width: 40, height: 20)
        viewEntry.btnExpand.backgroundColor = blueColor.withAlphaComponent(0.5)
        viewEntry.btnExpand.setTitle("\u{25CF}\u{25CF}\u{25CF}",for: .normal)
        viewEntry.btnExpand.titleLabel?.font = fontIconsSmall
        viewEntry.btnExpand.titleLabel?.textAlignment = .center
        viewEntry.btnExpand.layer.cornerRadius = 8
        
        scrollView.addSubview(viewEntry)

    }
    
    func getData() {
        
        let dataHelper = DataHelper(context: appDelegate.managedObjectContext)
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Keywords>(entityName: "Keywords")
        let primarySortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        fetchRequest.sortDescriptors = [primarySortDescriptor]
        let allEntries = try! context.fetch(fetchRequest)
        
        
        for entry in allEntries {
            
            
        }
    }
    
    func setUpBtnAdd() {
        
        let btnGradientLayer = CAGradientLayer()
        
        btnAdd.frame =  CGRect(x: (self.view.frame.size.width - 70)/2, y: (self.view.frame.size.height/4)*3, width: 70, height: 70)
        btnGradientLayer.frame =  btnAdd.bounds
        btnGradientLayer.colors = [purpleColor.cgColor, lightPurpleColor.cgColor]
        btnGradientLayer.locations = [ 0.0, 1.0]
        btnGradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        btnGradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        btnGradientLayer.cornerRadius = 35

        btnAdd.layer.addSublayer(btnGradientLayer)

        btnAdd.setTitle("+",for: .normal)
        btnAdd.tintColor = whiteColor
        btnAdd.titleLabel?.font = fontIconBig
        
        self.view.addSubview(btnAdd)

    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
         self.view.addSubview(scrollView)
        createEntriesViewToday()
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
