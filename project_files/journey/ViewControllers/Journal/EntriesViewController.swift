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
    let averageMood = UIImageView()
    let  topGradientLayer = CAGradientLayer()
    
    var selectedCalendarDate = Date()
    
    let viewDay = UIView()
    var btnAdd = UIButton()
    var btnToday = UIButton()

    var intArray = [Int16]()
    var ySize = 15
    var averageMoodInt : Int = 0

    
    var arrTest = [String]()

    let appDelegate = UIApplication.shared.delegate as! AppDelegate


    let lblDate = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = false
 
        self.view.addSubview(scrollView)
        
        self.title = "ENTRIES"
        tabBarController?.selectedIndex = 1
        self.view.backgroundColor = lightGreyColor
        
        createEntriesView()
        setUpBtnAdd()
    }

    
    func createEntriesView() {
        
        let navBar = navigationController?.navigationBar
        navBar?.applyNavigationGradient(colors: [whiteColor , whiteColor])
        
        let top = (self.tabBarController?.tabBar.frame.size.height)! + (navBar?.frame.size.height)! + 15
        
        // CONTENT
        scrollView.frame = CGRect(x: 0, y: top + 45 + 15, width: self.view.frame.size.width, height: self.view.frame.size.height - top - (tabBarController?.tabBar.frame.size.height)!)
        scrollView.isScrollEnabled = true
  
    }
    
    
    func setUpEntries() {

        averageMoodInt = 0
        let navBar = navigationController?.navigationBar
        ySize = 0
        let top = (self.tabBarController?.tabBar.frame.size.height)! + (navBar?.frame.size.height)! + 15

        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        formatter.locale = Locale(identifier: "en_GB")
        
        let selected = selectedCalendarDate
        let strDate = formatter.string(from: selected)
       
        
        let keywordAttr : [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.font : fontMainRegular20!,
            NSAttributedStringKey.foregroundColor : whiteColor,
            NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue]
        let attributeString = NSMutableAttributedString(string: "Today", attributes: keywordAttr)
        
        let formatterTime = DateFormatter()
        formatterTime.dateFormat = "HH:mm"
        formatterTime.locale = Locale(identifier: "en_GB")
        
        let formatterFull = DateFormatter()
        formatterFull.dateFormat = "yyyy-MM-dd HH:mm:ss +0000"
        formatterFull.locale = Locale(identifier: "en_GB")
        
        //get today's date
        let gradientLayerDay = CAGradientLayer()
        
        viewDay.frame = CGRect(x: 15, y: top, width: self.view.frame.size.width - 30, height: 45)

        lblDate.frame = CGRect(x: 0, y: 0, width: viewDay.frame.size.width, height: viewDay.frame.size.height)
        lblDate.text = strDate.uppercased()
        lblDate.font = fontMainMedium
        lblDate.textColor = whiteColor
        lblDate.textAlignment = .center
        
        averageMood.frame = CGRect(x: 15, y: 5, width: 35, height: 35)
        
        gradientLayerDay.frame = CGRect(x: 0, y: 0, width: viewDay.frame.size.width, height: viewDay.frame.size.height)
        gradientLayerDay.colors = [purpleColor.cgColor, purpleColor.cgColor]
        gradientLayerDay.locations = [ 0.0, 1.0]
        gradientLayerDay.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayerDay.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayerDay.cornerRadius = 22.5
        
        btnToday.setAttributedTitle(attributeString, for: .normal)
        btnToday.backgroundColor = UIColor.clear
        btnToday.titleLabel?.textColor = whiteColor
        btnToday.titleLabel?.textAlignment = .center
        btnToday.frame = CGRect(x: viewDay.frame.size.width - 50 - 15*2, y: 5, width: 90, height: 35)
        btnToday.addTarget(self,action:#selector(showTodaysEntries), for:.touchUpInside)
        

        viewDay.layer.insertSublayer(gradientLayerDay, at: 0)
        viewDay.addSubview(lblDate)
        viewDay.addSubview(averageMood)
         viewDay.addSubview(btnToday)
        self.view.addSubview(viewDay)
        
        var arrRelatedKeywords = [String]()
        var arrRelatedValue = [Int16]()

        // Set up list of entries from data created by the user
        
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequestEntries = NSFetchRequest<Entries>(entityName: "Entries")
        let fetchRequestRelation = NSFetchRequest<EntryKeywords>(entityName: "EntryKeywords")

        let fetchRequestKeywords = NSFetchRequest<Keywords>(entityName: "Keywords")
        let primarySortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        
        fetchRequestEntries.sortDescriptors = [primarySortDescriptor]
        let allEntries = try! context.fetch(fetchRequestEntries)
        
        
        for entry in allEntries {
            
            arrRelatedKeywords.removeAll()
            arrRelatedValue.removeAll()
            
            
            
            //get dates of the entry
            let entryDate = formatter.string(from: entry.date)
            let entryTime = formatterTime.string(from: entry.date)
            let txtButtonDate = entry.date

            let entryFullDate = formatterFull.string(from: txtButtonDate)

            
            //only fetch rows where the date = today
            if(entryDate == strDate){
                
                formatter.dateFormat = "EEEE, MMM d"
                formatter.locale = Locale(identifier: "en_GB")
                
               let predicateRelation = NSPredicate(format: "entry == %@", entry)
                fetchRequestRelation.predicate = predicateRelation
                
                let manyRelations = try! context.fetch(fetchRequestRelation)
                
                for manyRelation in manyRelations {

                    
                    if(manyRelation.severity != 0){
                        
                        let strKeywordID = manyRelation.keyword.objectID
                        let predicateKeywords = NSPredicate(format: "SELF = %@", strKeywordID)
                        fetchRequestKeywords.predicate = predicateKeywords
                        
                        let relatedKeywords = try! context.fetch(fetchRequestKeywords)
                        
                        for keyword in relatedKeywords {
                            
                                let keywordTitle = keyword.title
                                
                                arrRelatedValue.append(manyRelation.severity)
                                arrRelatedKeywords.append(keywordTitle)

                            
                        }
        
                        
                    }
                    
                }
                
                createEntry(title: entry.title, entry: entry.entry, mood: entry.mood, time: entryTime, date: entryFullDate, y: CGFloat(ySize), severity: arrRelatedValue, arrKeywords: arrRelatedKeywords, edited: entry.edited)
                
                //calculate the average mood
                intArray.append(entry.mood)
                let sumArray = intArray.reduce(0, +)
                let avgArrayValue = sumArray / Int16(intArray.count)
                averageMoodInt = Int(avgArrayValue)

                
            }
            
            //set image for average mood
            averageMood.image = UIImage(named: "ic_mood\(averageMoodInt)_white")

        }
        

        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: CGFloat(ySize + 15 + 45))

        //set up a gradient at the bottom of scrollview if the contentsize expands out of view
        viewTopGradient.clipsToBounds = false
        viewTopGradient.backgroundColor = UIColor.clear
        topGradientLayer.frame = CGRect(x: 0, y: self.view.frame.size.height - (self.tabBarController?.tabBar.frame.size.height)! - 45, width: self.view.frame.size.width, height: 45)
        topGradientLayer.colors = [UIColor.white.withAlphaComponent(0).cgColor, lightGreyColor.cgColor]
        
    }
    
    func dateCheck() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        formatter.locale = Locale(identifier: "en_GB")
        
        let now = Date()
        let todayDateStr = formatter.string(from: now)
        let selectedDateStr = formatter.string(from: selectedCalendarDate)
       
        //if selected date is not today's date, add a button to today's entries
        if(selectedDateStr != todayDateStr){
            
          btnToday.isHidden = false
            
            btnAdd.isHidden = true
            
        }
        else {
           btnToday.isHidden = true
            btnAdd.isHidden = false

        }
        
    }
    
    func createEntry(title:String, entry:String, mood:Int16, time:String, date:String, y:CGFloat, severity:Array<Any>, arrKeywords:Array<Any>, edited: Bool) {
    
        let viewEntry = UIView()
        let viewHeader = UIView()
        
        let viewContent = UIView()
        let viewKeywords = UIView()

        let imgView = UIImageView()
        let lblTitle = UILabel()
        let lblTime = UILabel()
        let txtEntry = UITextView()
        let btnEdit = UIButton()

        //get today's date
        let gradientLayer = CAGradientLayer()

        viewEntry.frame = CGRect(x: 15, y: y, width: self.view.frame.size.width - 30, height: 100)
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

        
        lblTime.frame = CGRect(x: 15, y: 0, width: viewHeader.frame.size.width - 30, height: viewHeader.frame.size.height)
        lblTime.textAlignment = .right

        let attrs1 = [NSAttributedStringKey.font : fontMainRegular!, NSAttributedStringKey.foregroundColor : whiteColor]
        let attrs2 = [NSAttributedStringKey.font : fontMainMedium!, NSAttributedStringKey.foregroundColor : whiteColor]
        
        let attributedString1 = NSMutableAttributedString(string:"(Edited) ", attributes:attrs1)
        let attributedString2 = NSMutableAttributedString(string: time, attributes:attrs2)
        
        
        if(edited == true){
            
            attributedString1.append(attributedString2)
            lblTime.attributedText = attributedString1

        }
        else {
            lblTime.attributedText = attributedString2

        }
        
    
        gradientLayer.frame = CGRect(x: 0, y: 0, width: viewEntry.frame.size.width, height: viewHeader.frame.size.height)
        gradientLayer.colors = [blueColor.cgColor, lightBlueColor.cgColor]
        gradientLayer.locations = [ 0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.cornerRadius = 25
        gradientLayer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        viewHeader.layer.insertSublayer(gradientLayer, at: 0)
        viewHeader.addSubview(lblTime)
        viewEntry.addSubview(viewHeader)
        
        viewContent.frame = CGRect(x: 0, y: viewHeader.frame.size.height + 15, width: viewEntry.frame.size.width, height: 40)
    
        imgView.frame = CGRect(x: 15, y: 5, width: 35, height: 35)
        imgView.image = UIImage(named: "ic_mood\(mood)_white")
        
        let strTitle = "\(title.uppercased())"
        let size: CGSize = strTitle.size(withAttributes: [NSAttributedStringKey.font: fontKeywordRegular!])
        var lblHeight = size.height
        let char = strTitle.count
        
        if(char > 16){
            lblHeight = size.height*2
        }
        
        lblTitle.frame =  CGRect(x: 60, y: 0, width: viewEntry.frame.size.width - 60*2, height: lblHeight)
        lblTitle.text = strTitle
        lblTitle.font = fontKeywordRegular
        lblTitle.textAlignment = .center
        lblTitle.numberOfLines = 0
        
        let entryWidth = viewEntry.frame.size.width - 30 - 15
        
        txtEntry.frame = CGRect(x: 15, y: lblTitle.frame.size.height, width: viewEntry.frame.size.width - 30, height: 40)
        txtEntry.text = entry
        txtEntry.font = fontInput
        txtEntry.isEditable = false
        txtEntry.isScrollEnabled = false
        txtEntry.sizeToFit()
        txtEntry.translatesAutoresizingMaskIntoConstraints = false
       

        
        viewKeywords.frame = CGRect(x: 0, y: txtEntry.frame.size.height + lblTitle.frame.size.height, width: viewContent.frame.size.width, height: 0)

        var lblY = CGFloat(0)
        
        for (e1, e2) in zip(arrKeywords, severity) {
            var strKeywords = String()
            let lblKeywords = UILabel()

            strKeywords = "\u{25CF} \(e2)%  \(e1)"
            let size: CGSize = strKeywords.size(withAttributes: [NSAttributedStringKey.font: font17Med!])
            let lblHeight = size.height
            lblKeywords.frame =  CGRect(x: 15, y: lblY, width: entryWidth, height: lblHeight)
            lblKeywords.text = strKeywords
            lblKeywords.font = font17Med
            lblKeywords.textColor = blueColor
            lblKeywords.numberOfLines = 0
            

            
            viewKeywords.addSubview(lblKeywords)

            lblY = lblY + lblHeight
            viewKeywords.frame.size.height = lblY 

        }
        
        
        let idString = String(describing: date)

        btnEdit.frame =  CGRect(x: viewEntry.frame.width - 45, y: 0, width: 30, height: 30)
        let image = UIImage(named: "arrow_down")

        btnEdit.addTarget(self,action:#selector(editEntry),for:.touchUpInside)
        btnEdit.tintColor = blueColor
        btnEdit.setTitle(idString, for: .normal)
        btnEdit.titleLabel?.isHidden = true
        btnEdit.backgroundColor = UIColor.clear
        btnEdit.layer.cornerRadius = 15
        btnEdit.layer.borderWidth = 1.5
        btnEdit.setImage(image, for: .normal)
        btnEdit.addTarget(self,action:#selector(editEntry), for:.touchUpInside)
        btnEdit.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        btnEdit.layer.borderColor = blueColor.cgColor
        
        viewHeader.addSubview(imgView)
        viewContent.addSubview(lblTitle)
        viewContent.addSubview(txtEntry)
        viewContent.addSubview(viewKeywords)
        viewContent.addSubview(btnEdit)
        
        
        viewContent.frame.size.height = lblTitle.frame.size.height + txtEntry.frame.size.height + viewKeywords.frame.size.height + 45
        viewEntry.frame.size.height = viewContent.frame.size.height + 30
        
        viewEntry.addSubview(viewContent)
        scrollView.addSubview(viewEntry)

        ySize = ySize + Int(viewEntry.frame.size.height) + 15
        
    }
    
    func setUpBtnAdd() {
        
        let btnGradientLayer = CAGradientLayer()
        let navBar = navigationController?.navigationBar

        let top = (self.tabBarController?.tabBar.frame.size.height)! + (navBar?.frame.size.height)!

        btnAdd.frame =  CGRect(x: self.view.frame.size.width - 15*2 - 60, y: top + 60 + self.view.frame.size.height/1.7 + 20, width: 60, height: 60)
        
        btnGradientLayer.frame =  btnAdd.bounds
        btnGradientLayer.colors = [purpleColor.cgColor, lightPurpleColor.cgColor]
        btnGradientLayer.locations = [ 0.0, 1.0]
        btnGradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        btnGradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        btnGradientLayer.cornerRadius = 30
        
        btnGradientLayer.shadowColor = blackColor.cgColor
        btnGradientLayer.shadowOffset = CGSize(width: -6, height: 6)
        btnGradientLayer.shadowOpacity = 0.05
        btnGradientLayer.shadowRadius = 5.0

        btnAdd.layer.addSublayer(btnGradientLayer)

        btnAdd.setTitle("+",for: .normal)
        btnAdd.tintColor = whiteColor
        btnAdd.titleLabel?.font = fontIconBig
        btnAdd.addTarget(self,action:#selector(toCreate), for:.touchUpInside)

        
        self.view.addSubview(btnAdd)

    }
    

    
    func btnActionSheet(date: String) {
        
    
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        
        let editButton = UIAlertAction(title: "Edit", style: .default, handler: { (action) -> Void in
            self.toEdit(date: date)
        })
        
        let  deleteButton = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) -> Void in
            self.deleteEntry(date: date)
            self.refresh()
            
        })
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            print("Cancel button tapped")
        })
        
        
        alertController.addAction(editButton)
        alertController.addAction(deleteButton)
        alertController.addAction(cancelButton)
        
        self.navigationController!.present(alertController, animated: true, completion: nil)
    }
    
    func deleteEntry(date: String) {
        
        print("string passed : \(String(describing: date))")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +0000"
        dateFormatter.locale = Locale(identifier: "en_GB")
        
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequestEntries = NSFetchRequest<Entries>(entityName: "Entries")
        let fetchRequestRelation = NSFetchRequest<EntryKeywords>(entityName: "EntryKeywords")
        
        let entries = try! context.fetch(fetchRequestEntries)
        
        for entry in entries {
            
            let entrDate = dateFormatter.string(from: entry.date)
            
            if(entrDate == date){
                
                print("\(String(describing: entry))")
                context.delete(entry)
                
                do {
                    
                    try context.save()
                 
                    let predicateRelation = NSPredicate(format: "entry == %@", entry)
                    fetchRequestRelation.predicate = predicateRelation
                    let manyRelations = try! context.fetch(fetchRequestRelation)
                    
                    for manyRelation in manyRelations {
                        
                        print("\(String(describing: manyRelation))")
                        context.delete(manyRelation)
                        
                        do {
                            try context.save()
                        } catch {
                           print("Failed saving \(manyRelation)")
                        }
                    }
                    
                    
                } catch {
                    
                    print("Failed saving \(entry)")
                    
                }
                
    
                
            }
            
            
            
        }
        
    }
    
    
    @objc func showTodaysEntries() {
        selectedCalendarDate = Date()
        scrollView.removeSubviews()
        setUpEntries()
        dateCheck()
    }
    
    @objc func toCreate() {
    self.tabBarController?.tabBar.isHidden = true
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "createEntry") as! CreateEntryViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    


    @objc func editEntry(sender: UIButton) {
        
        let btnLabel = (sender.titleLabel?.text)!
        if(btnLabel.isEmpty) {
            print("error")
        }
        
        else {
            btnActionSheet(date: btnLabel)
        }
    }
    
    
    
    func toEdit(date: String) {
        self.tabBarController?.tabBar.isHidden = true
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let editEntry = storyboard.instantiateViewController(withIdentifier: "editEntry") as! EditEntryViewController
        editEntry.entryToEdit = date
        self.navigationController?.pushViewController(editEntry, animated: true)
    
    }
    
    func refresh() {
        
        scrollView.removeSubviews()
        setUpEntries()
        dateCheck()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        refresh()
   
        self.tabBarController?.tabBar.isHidden = false
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        

    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
