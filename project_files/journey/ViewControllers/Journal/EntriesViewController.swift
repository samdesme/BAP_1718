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
    

    @IBOutlet var viewMain: UIView!
    
    @IBOutlet weak var backButtonItem: UINavigationItem!
    
    var selectedDate : String = ""
    var scrollView = UIScrollView()
    var viewTopGradient = UIView()
    let  topGradientLayer = CAGradientLayer()
    
    var btnAdd = UIButton()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    //let viewEntry = Bundle.main.loadNibNamed("entryView", owner: nil, options: nil)?.first as! entryView
    let viewEntry = UIView()
    let viewHeader = UIView()
    let lblDate = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = false
 
        self.view.addSubview(scrollView)

        self.title = "ENTRIES"
        tabBarController?.selectedIndex = 1
        self.view.backgroundColor = lightGreyColor
        
        createEntriesViewToday()
        setUpBtnAdd()


    }
    
    func createEntriesViewToday() {
        
        let navBar = navigationController?.navigationBar
        navBar?.applyNavigationGradient(colors: [whiteColor , whiteColor])

        // CONTENT
        scrollView.backgroundColor = lightGreyColor
        scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height - (self.tabBarController?.tabBar.frame.size.height)! - (navBar?.frame.size.height)! - 90)
        scrollView.isScrollEnabled = true
        
        //set up a gradient at the top of the page to create a 3D effect
        viewTopGradient.clipsToBounds = false
        viewTopGradient.backgroundColor = UIColor.clear
        topGradientLayer.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 45)
        topGradientLayer.colors = [blackColor.withAlphaComponent(0.05).cgColor, UIColor.clear.cgColor]
        topGradientLayer.locations = [ 0.0, 1.0]
        
        scrollView.removeSubviews()
        
        //viewTopGradient.layer.addSublayer(topGradientLayer)
        //self.view.insertSubview(viewTopGradient, at: 0)

        setUpEntries()
    }
    
    func setUpEntries() {
        
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        formatter.locale = Locale(identifier: "en_GB")
        
        let formatterTime = DateFormatter()
        formatterTime.dateFormat = "HH:mm"
        formatterTime.locale = Locale(identifier: "en_GB")
        
        //get today's date
        let nowDate = formatter.string(from: now)
        
        let gradientLayer = CAGradientLayer()
        
        viewEntry.frame = CGRect(x: 15, y: 15, width: self.view.frame.size.width - 30, height: scrollView.frame.size.height)

        //viewEntry.frame = CGRect(x: 15, y: 15, width: self.view.frame.size.width - 30, height: scrollView.contentSize.height)
        //viewEntry.frame.size.width = scrollView.frame.size.width
        viewEntry.clipsToBounds = false
        viewEntry.backgroundColor = whiteColor
        viewEntry.layer.cornerRadius = 25
        viewEntry.layer.shadowColor = blackColor.cgColor
        viewEntry.layer.shadowOffset = CGSize(width: 6, height: 6)
        viewEntry.layer.shadowOpacity = 0.05
        viewEntry.layer.shadowRadius = 10.0
        
        viewEntry.backgroundColor = whiteColor
        
        viewHeader.frame = CGRect(x: 0, y: 0, width: viewEntry.frame.size.width, height: 45)
        viewHeader.backgroundColor = UIColor.clear
        
        lblDate.frame = CGRect(x: 15, y: 0, width: viewHeader.frame.size.width - 30, height: viewHeader.frame.size.height)
        lblDate.text = nowDate.uppercased()
        lblDate.font = fontMainMedium
        lblDate.textColor = whiteColor
        lblDate.textAlignment = .right
        
        gradientLayer.frame = CGRect(x: 0, y: 0, width: viewEntry.frame.size.width, height: viewHeader.frame.size.height)
        gradientLayer.colors = [blueColor.cgColor, lightBlueColor.cgColor]
        gradientLayer.locations = [ 0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.cornerRadius = 25
        gradientLayer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        viewHeader.layer.insertSublayer(gradientLayer, at: 0)
        viewHeader.addSubview(lblDate)
        viewEntry.addSubview(viewHeader)
        
        var ySize = 15

        // Set up list of entries from data created by the user
        
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Entries>(entityName: "Entries")
        let primarySortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        
        fetchRequest.sortDescriptors = [primarySortDescriptor]
        
        let allEntries = try! context.fetch(fetchRequest)
        
            
            for entry in allEntries {
                
                //get dates of the entry
                let entryDate = formatter.string(from: entry.date)
                let entryTime = formatterTime.string(from: entry.date)
                
                //only fetch rows where the date = today
                if(entryDate == nowDate){
                    
                    formatter.dateFormat = "EEEE, MMM d"
                    formatter.locale = Locale(identifier: "en_GB")
                    
                    createEntry(title: entry.title, entry: entry.entry, mood: entry.mood, date: entryTime, y: CGFloat(ySize))
                    ySize = ySize + 100 + 15

                
            }
           
        }

        


        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: CGFloat(ySize + 15))
        viewEntry.frame.size.height = scrollView.contentSize.height + 30
        scrollView.addSubview(viewEntry)

    }
    
    func createEntry(title:String, entry:String, mood:Int16, date:String, y:CGFloat) {
        
        let viewContent = UIView()
        let imgView = UIImageView()
        let lblTitle = UILabel()
        let lblTime = UILabel()
        let txtEntry = UITextView()
        let btnEdit = UIButton()
        let btnExpand = UIButton()
        
        /*
        viewContent = viewEntry.viewContent
        imgView = viewEntry.imgMood
        lblTitle = viewEntry.lblTitle
        lblTime = viewEntry.lblCreated
        txtEntry = viewEntry.txtEntry
        btnEdit = viewEntry.btnEdit
        btnExpand = viewEntry.btnExpand
        */
        
        viewContent.frame = CGRect(x: 0, y: viewHeader.frame.size.height + y, width: viewEntry.frame.size.width, height: 100)
        viewContent.backgroundColor = blueColor.withAlphaComponent(0.2)
    
        imgView.frame = CGRect(x: 15, y: 30, width: 50, height: 50)
        imgView.image = UIImage(named: "ic_mood\(mood)_outline")
        
        txtEntry.frame = CGRect(x: imgView.frame.size.width + 15*2, y: 30, width: viewEntry.frame.size.width - imgView.frame.size.width - 15*2 - 15, height: 60)
        txtEntry.text = entry
        txtEntry.font = fontInput
        txtEntry.isScrollEnabled = false
        txtEntry.translatesAutoresizingMaskIntoConstraints = false

        
        lblTitle.frame =  CGRect(x: imgView.frame.size.width + 15*2, y: 0, width: txtEntry.frame.size.width/2, height: 30)
        lblTitle.text = title.uppercased()
        lblTitle.font = fontMainRegular19
        
        
        lblTime.frame =  CGRect(x: 15, y: 0, width: 50, height: 30)
        lblTime.textAlignment = .center
        lblTime.text = date
        lblTime.textColor = blueColor
        lblTime.font = fontInput
        
        btnEdit.frame =  CGRect(x: viewEntry.frame.width - 45, y: 0, width: 30, height: 30)
        btnEdit.setTitle("\u{2228}",for: .normal)
        btnEdit.titleLabel?.textColor = blueColor
        btnEdit.tintColor = blueColor
        btnEdit.titleLabel?.font = font17Bld
        btnEdit.titleLabel?.textAlignment = .center
        btnEdit.backgroundColor = UIColor.clear
        btnEdit.layer.cornerRadius = 15
        btnEdit.layer.borderWidth = 1.5
        btnEdit.layer.borderColor = blueColor.cgColor
        
        /*
        btnExpand.frame =  CGRect(x: (viewEntry.frame.width - 30)/2, y: viewContent.frame.size.height - 20, width: 40, height: 20)
        btnExpand.backgroundColor = blueColor.withAlphaComponent(0.5)
        btnExpand.setTitle("\u{25CF}\u{25CF}\u{25CF}",for: .normal)
        btnExpand.titleLabel?.font = fontIconsSmall
        btnExpand.titleLabel?.textAlignment = .center
        btnExpand.layer.cornerRadius = 8
        */
        
        viewContent.frame.size.height = lblTitle.frame.size.height + txtEntry.frame.size.height + 15
        
        viewContent.addSubview(imgView)
        viewContent.addSubview(lblTitle)
        viewContent.addSubview(lblTime)
        viewContent.addSubview(txtEntry)
        viewContent.addSubview(btnEdit)
        //viewContent.addSubview(btnExpand)

        viewEntry.addSubview(viewContent)
        
        
    }
    
    func setUpBtnAdd() {
        
        let btnGradientLayer = CAGradientLayer()
        
        btnAdd.frame =  CGRect(x: (self.view.frame.size.width - 60)/2, y: scrollView.frame.size.height + 30, width: 60, height: 60)
        btnGradientLayer.frame =  btnAdd.bounds
        btnGradientLayer.colors = [purpleColor.cgColor, lightPurpleColor.cgColor]
        btnGradientLayer.locations = [ 0.0, 1.0]
        btnGradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        btnGradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        btnGradientLayer.cornerRadius = 30

        btnAdd.layer.addSublayer(btnGradientLayer)

        btnAdd.setTitle("+",for: .normal)
        btnAdd.tintColor = whiteColor
        btnAdd.titleLabel?.font = fontIconBig
        btnAdd.addTarget(self,action:#selector(toCreate), for:.touchUpInside)

        
        self.view.addSubview(btnAdd)

    }
    
    @objc func toCreate() {
    self.tabBarController?.tabBar.isHidden = true
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "createEntry") as! CreateEntryViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func getData() {
   
    }
    

    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //createEntriesViewToday()
        self.tabBarController?.tabBar.isHidden = false
        self.navigationItem.setHidesBackButton(true, animated: false)

    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
