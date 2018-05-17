//
//  GoalsViewController.swift
//  journey
//
//  Created by sam de smedt on 25/03/2018.
//  Copyright © 2018 sam de smedt. All rights reserved.
//

import UIKit
import CoreData

class GoalsViewController: UIViewController {
    
    @IBOutlet var viewMain: UIView!
    @IBOutlet weak var backButtonItem: UINavigationItem!
    
    var selectedDate : String = ""
    var scrollView = UIScrollView()
    var viewTopGradient = UIView()
    let topGradientLayer = CAGradientLayer()
    
    var selectedCalendarDate = String()
    
    let viewDay = UIView()
    var btnAdd = UIButton()
    var btnAll = UIButton()
    
    let strHeader = "goals"
    let lblHeader = UILabel()
    var strDate = String()
    var bool = Bool()
    
    var intArray = [Int16]()
    var ySize = 15
    
    var arrTest = [String]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let lblDate = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = false
        self.view.addSubview(scrollView)
        
        //self.title = "Goals"
        self.tabBarController?.selectedIndex = 2
        self.view.backgroundColor = lightGreyColor
        
        createGoalsView()
        setUpBtnAdd()
       
    }
    
    func createHeaderMain() {
        
        //variables
        let navBar = navigationController?.navigationBar
        let frameTitle = CGRect(x: 0, y: (navBar?.frame.height)!/2 - 5, width: (navBar?.frame.width)!, height: (navBar?.frame.height)!/2)
        lblHeader.frame = frameTitle
        
        //Create navigation bar
        navBar?.applyNavigationGradient(colors: [whiteColor , whiteColor])
        lblHeader.alpha = 1
        lblHeader.text = strHeader.uppercased()
        lblHeader.font = fontHeaderMain
        lblHeader.textAlignment = .center
        //lblHeader.backgroundColor = UIColor.clear
        navBar?.addSubview(lblHeader)
        
    }
    
    func createGoalsView() {
        
        let top = (self.tabBarController?.tabBar.frame.size.height)! + 5
        
        // CONTENT
        scrollView.backgroundColor = lightGreyColor
        scrollView.frame = CGRect(x: 0, y: top + 45 + 15*2, width: self.view.frame.size.width, height: self.view.frame.size.height - top - (tabBarController?.tabBar.frame.size.height)!)
        scrollView.isScrollEnabled = true
        
    }
    
    
    func setUpGoals() {
        
        ySize = 0
        let top = (self.tabBarController?.tabBar.frame.size.height)! + 5

        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        formatter.locale = Locale(identifier: "en_GB")
        
        
        
        
        if(selectedCalendarDate.isEmpty){
            bool = false
            let strTitle = "All goals"
            strDate = strTitle.uppercased()
            btnAll.isHidden = true

        }
        
        else {
            bool = true
            btnAll.isHidden = false
            
            let toDateFormat = formatter.date(from: selectedCalendarDate)
            let toStr = formatter.string(from: toDateFormat!)
            
            strDate = toStr
        }


        let keywordAttr : [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.font : fontMainRegular20!,
            NSAttributedStringKey.foregroundColor : whiteColor,
            NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue]
    
        let attributeString = NSMutableAttributedString(string: "All", attributes: keywordAttr)
        
        let formatterTime = DateFormatter()
        formatterTime.dateFormat = "HH:mm"
        formatterTime.locale = Locale(identifier: "en_GB")
        
        let formatterFull = DateFormatter()
        formatterFull.dateFormat = "dd-MM-yyyy HH:mm:ss +0000"
        formatterFull.locale = Locale(identifier: "en_GB")
        
        //get today's date
        let gradientLayerDay = CAGradientLayer()
        
        viewDay.frame = CGRect(x: 15, y: Int(top + 15), width: Int(self.view.frame.size.width - 30), height: 45)
        
        lblDate.frame = CGRect(x: 0, y: 0, width: viewDay.frame.size.width, height: viewDay.frame.size.height)
        lblDate.font = fontMainMedium
        lblDate.textColor = whiteColor
        lblDate.text = strDate
        lblDate.textAlignment = .center
        
        gradientLayerDay.frame = CGRect(x: 0, y: 0, width: viewDay.frame.size.width, height: viewDay.frame.size.height)
        gradientLayerDay.colors = [purpleColor.cgColor, purpleColor.cgColor]
        gradientLayerDay.locations = [ 0.0, 1.0]
        gradientLayerDay.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayerDay.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayerDay.cornerRadius = 22.5
        
        btnAll.setAttributedTitle(attributeString, for: .normal)
        btnAll.backgroundColor = UIColor.clear
        btnAll.titleLabel?.textColor = whiteColor
        btnAll.titleLabel?.textAlignment = .center
        btnAll.frame = CGRect(x: viewDay.frame.size.width - 50 - 15*2, y: 5, width: 90, height: 35)
        btnAll.addTarget(self,action:#selector(showAllGoals), for:.touchUpInside)
        
        viewDay.layer.insertSublayer(gradientLayerDay, at: 0)
        viewDay.addSubview(lblDate)
        viewDay.addSubview(btnAll)
        self.view.addSubview(viewDay)
        
        var arrRelatedKeywords = [String]()
        var arrRelatedValue = [Int16]()
        
        // Set up list of entries from data created by the user
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequestGoals = NSFetchRequest<Goals>(entityName: "Goals")
        let fetchRequestRelation = NSFetchRequest<GoalKeywords>(entityName: "GoalKeywords")
        
        let fetchRequestKeywords = NSFetchRequest<Keywords>(entityName: "Keywords")
        let primarySortDescriptor = NSSortDescriptor(key: "created", ascending: true)
        
        let predicateDeadline = NSPredicate(format: "deadline == %@", strDate)
        
        if(bool == true){
            
            fetchRequestGoals.predicate = predicateDeadline

        }
        
        fetchRequestGoals.sortDescriptors = [primarySortDescriptor]
        let allGoals = try! context.fetch(fetchRequestGoals)
        
        for goal in allGoals {
            
            arrRelatedKeywords.removeAll()
            arrRelatedValue.removeAll()
            
            let formatterShort = DateFormatter()
            formatterShort.dateFormat = "dd-MM-yyyy"
            formatterShort.locale = Locale(identifier: "en_GB")
            
            //if(goal.deadline == strDate){
                
       
                
                let predicateRelation = NSPredicate(format: "goal == %@", goal)
                fetchRequestRelation.predicate = predicateRelation
            
                
                let manyRelations = try! context.fetch(fetchRequestRelation)
            print("relations : \(String(describing: manyRelations))")

                for manyRelation in manyRelations {
                    
            
                        let strKeywordID = manyRelation.keyword.objectID
                        let predicateKeywords = NSPredicate(format: "SELF = %@", strKeywordID)
                        fetchRequestKeywords.predicate = predicateKeywords
                        
                        let relatedKeywords = try! context.fetch(fetchRequestKeywords)
                        
                        for keyword in relatedKeywords {
                            
                            let keywordTitle = keyword.title
                            arrRelatedKeywords.append(keywordTitle)
  
                            
                        }
                    
                }
                
                createGoal(title: goal.title, note: goal.note, deadline: goal.deadline , created: goal.created, y: CGFloat(ySize), arrKeywords: arrRelatedKeywords, accomplished: goal.accomplished)
           

                
          //  }
            
            
        }
        
        
        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: CGFloat(ySize + 15 + 45))
        
        //viewGoal.frame.size.height = scrollView.contentSize.height - 15
        //scrollView.addSubview(viewGoal)
        
        //let yGrad = (self.tabBarController?.tabBar.frame.size.height)! + (navBar?.frame.size.height)! + 60 + self.view.frame.size.height/1.7 - 45
        
        //set up a gradient at the bottom of scrollview if the contentsize expands out of view
        viewTopGradient.clipsToBounds = false
        viewTopGradient.backgroundColor = UIColor.clear
        topGradientLayer.frame = CGRect(x: 0, y: self.view.frame.size.height - (self.tabBarController?.tabBar.frame.size.height)! - 45, width: self.view.frame.size.width, height: 45)
        topGradientLayer.colors = [UIColor.white.withAlphaComponent(0).cgColor, lightGreyColor.cgColor]
        
        //gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        //gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        
        //viewTopGradient.layer.addSublayer(topGradientLayer)
        //topGradientLayer.addBorder(toSide: .Bottom, withColor: blackColor.withAlphaComponent(0.5).cgColor, andThickness: 0.5)
        //self.view.insertSubview(viewTopGradient, at: 1)
        
    }
    
    func createGoal(title:String, note:String, deadline:String, created:String, y:CGFloat, arrKeywords:Array<Any>, accomplished: Bool) {
        
        let viewGoal = UIView()
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
        
        viewGoal.frame = CGRect(x: 15, y: y, width: self.view.frame.size.width - 30, height: 100)
        viewGoal.clipsToBounds = false
        viewGoal.backgroundColor = whiteColor
        viewGoal.layer.cornerRadius = 25
        viewGoal.layer.shadowColor = blackColor.cgColor
        viewGoal.layer.shadowOffset = CGSize(width: 6, height: 6)
        viewGoal.layer.shadowOpacity = 0.05
        viewGoal.layer.shadowRadius = 10.0
        
        viewGoal.backgroundColor = whiteColor
        
        viewHeader.frame.size.width = viewGoal.frame.size.width
        viewHeader.backgroundColor = UIColor.clear
        
        
        lblTime.frame = CGRect(x: 15, y: 0, width: viewHeader.frame.size.width - 30, height: 45)
        lblTime.textAlignment = .center
        
        
        gradientLayer.frame = CGRect(x: 0, y: 0, width: viewGoal.frame.size.width, height: 45)
        gradientLayer.cornerRadius = 25
        gradientLayer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        
        
        var headerHeight = CGFloat()
        
        let formatterShort = DateFormatter()
        formatterShort.dateFormat = "MMM d"
        formatterShort.locale = Locale(identifier: "en_GB")
        
        let formatterDate = DateFormatter()
        formatterDate.dateFormat = "dd-MM-yyyy"
        formatterDate.locale = Locale(identifier: "en_GB")

        if(accomplished == true){
          
            lblTime.text = "Accomplished!"
            
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 1)
            gradientLayer.colors = [purpleColor.cgColor, blueColor.cgColor]
            viewHeader.layer.insertSublayer(gradientLayer, at: 0)
            headerHeight = 45
            viewHeader.addSubview(lblTime)

            
            
        }
        else if (deadline.isEmpty) {
            
            
            gradientLayer.locations = [ 0.0, 1.0]
            gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
            headerHeight = 0


            
        }
        
        else {
            
            let attrs1 = [NSAttributedStringKey.font : fontMainRegular!, NSAttributedStringKey.foregroundColor : whiteColor]
            let attrs2 = [NSAttributedStringKey.font : fontMainMedium!, NSAttributedStringKey.foregroundColor : whiteColor]
            
            let toDateFormat = formatterDate.date(from: deadline)
            let toStr = formatterShort.string(from: toDateFormat!)
            
            
            let attributedString1 = NSMutableAttributedString(string:"Deadline: ", attributes:attrs1)
            let attributedString2 = NSMutableAttributedString(string: toStr, attributes:attrs2)
            
            attributedString1.append(attributedString2)
            
            lblTime.attributedText = attributedString1
            
            viewHeader.layer.cornerRadius = 25
            viewHeader.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            viewHeader.layer.backgroundColor = blueColor.withAlphaComponent(0.5).cgColor
           
            
            viewHeader.addSubview(lblTime)
            
            headerHeight = 45

        }
        
        
        
        viewContent.frame = CGRect(x: 0, y: 15, width: viewGoal.frame.size.width, height: 40)
        
        imgView.frame = CGRect(x: 15, y: 5, width: 35, height: 35)
        imgView.image = UIImage(named: "ic_mood1")
        
        
        let strTitle = "\(title.uppercased())"
        let size: CGSize = strTitle.size(withAttributes: [NSAttributedStringKey.font: fontKeywordRegular!])
        var lblHeight = size.height
        let char = strTitle.count
        
        if(char > 16){
            lblHeight = size.height*2
        }
        
        
        lblTitle.frame =  CGRect(x: 60, y: 0, width: viewGoal.frame.size.width - 60*2, height: lblHeight)
        lblTitle.text = "\(title.uppercased())"
        lblTitle.font = fontKeywordRegular
        lblTitle.textAlignment = .center
        lblTitle.numberOfLines = 0
        
        
        let goalWidth = viewGoal.frame.size.width - 30 - 15

        txtEntry.frame = CGRect(x: 15, y: lblTitle.frame.size.height, width: viewGoal.frame.size.width - 30, height: 140)
        txtEntry.text = note
        txtEntry.font = fontInput
        txtEntry.isEditable = false
        txtEntry.isScrollEnabled = false
        
        if(note.isEmpty){
            txtEntry.frame.size.height = 140
        }
        else {
            txtEntry.sizeToFit()
            //txtEntry.translatesAutoresizingMaskIntoConstraints = false

        }
        
          viewKeywords.frame = CGRect(x: 0, y: txtEntry.frame.size.height + lblTitle.frame.size.height + 15, width: viewContent.frame.size.width, height: 0)
        //viewKeywords.backgroundColor = blueColor.withAlphaComponent(0.2)
        var lblY = CGFloat(0)
        
        for keyword in arrKeywords {
            var strKeywords = String()
            let lblKeywords = UILabel()
            
            //print("\(e1) - \(e2)")
            strKeywords = "\u{25CF} \(keyword)"
            let size: CGSize = strKeywords.size(withAttributes: [NSAttributedStringKey.font: font17Med!])
            let lblHeight = size.height
            lblKeywords.frame =  CGRect(x: 15, y: lblY, width: goalWidth, height: lblHeight)
            //lblKeywords.backgroundColor = blueColor.withAlphaComponent(0.2)
            lblKeywords.text = strKeywords
            lblKeywords.font = font17Med
            lblKeywords.textColor = blueColor
            lblKeywords.numberOfLines = 0
        print("keyword : \(String(describing: strKeywords))")
            viewKeywords.addSubview(lblKeywords)
            
            lblY = lblY + lblHeight
            viewKeywords.frame.size.height = lblY
            
        }
        
        
        let strCreated = created
        
        
        btnEdit.frame =  CGRect(x: viewGoal.frame.width - 45, y: 0, width: 30, height: 30)
        let image = UIImage(named: "arrow_down")
        
        btnEdit.addTarget(self,action:#selector(editGoal),for:.touchUpInside)
        btnEdit.tintColor = blueColor
        btnEdit.setTitle(strCreated, for: .normal)
        btnEdit.titleLabel?.isHidden = true
        btnEdit.backgroundColor = UIColor.clear
        btnEdit.layer.cornerRadius = 15
        btnEdit.layer.borderWidth = 1.5
        btnEdit.setImage(image, for: .normal)
        
        btnEdit.addTarget(self,action:#selector(editGoal), for:.touchUpInside)
        
        
        btnEdit.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        btnEdit.layer.borderColor = blueColor.cgColor
        
        viewContent.addSubview(lblTitle)
        viewContent.addSubview(txtEntry)
        viewContent.addSubview(viewKeywords)
        viewContent.addSubview(btnEdit)
        
        //viewContent.backgroundColor = blueColor.withAlphaComponent(0.2)

        viewContent.frame.size.height = lblTitle.frame.size.height + txtEntry.frame.size.height + viewKeywords.frame.size.height + 30
        viewGoal.frame.size.height = viewContent.frame.size.height + headerHeight + 15
        
        viewHeader.frame = CGRect(x: 0, y: viewGoal.frame.size.height - 45, width: viewGoal.frame.size.width, height: headerHeight)
        viewGoal.addSubview(viewHeader)
        //viewHeader.alpha = 0.6
        
        viewGoal.addSubview(viewContent)
        scrollView.addSubview(viewGoal)
        
        ySize = ySize + Int(viewGoal.frame.size.height) + 15
        
    }
    
    func setUpBtnAdd() {
        
        let btnGradientLayer = CAGradientLayer()
        let top = (self.tabBarController?.tabBar.frame.size.height)! + 5

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
    
    
    
    func btnActionSheet(created: String) {
        
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        
        let editButton = UIAlertAction(title: "Edit", style: .default, handler: { (action) -> Void in
            self.toEdit(created: created)
        })
        
        let  deleteButton = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) -> Void in
            self.deleteGoal(created: created)
            self.refresh()
            
        })
        
        let  accomplishButton = UIAlertAction(title: "Accomplish", style: .default, handler: { (action) -> Void in
            
            
        })
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            print("Cancel button tapped")
        })
        
        
        alertController.addAction(editButton)
        alertController.addAction(accomplishButton)
        alertController.addAction(deleteButton)
        alertController.addAction(cancelButton)
        
        self.navigationController!.present(alertController, animated: true, completion: nil)
    }
    
    
    func deleteGoal(created: String) {
        
        print("string passed : \(String(describing: created))")
        
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequestGoals = NSFetchRequest<Goals>(entityName: "Goals")
        let fetchRequestRelation = NSFetchRequest<GoalKeywords>(entityName: "GoalKeywords")
        
        //let predicateEntry = NSPredicate(format: "date = %@", date)
        //fetchRequestEntries.predicate = predicateEntry
        
        let goals = try! context.fetch(fetchRequestGoals)
        
        for goal in goals {
            
            if(goal.created == created){
                
                
                context.delete(goal)
                
                do {
                    
                    try context.save()
                    
                    let predicateRelation = NSPredicate(format: "goal == %@", goal)
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
                    
                    print("Failed saving \(goal)")
                    
                }
                
            }
            
            
            
        }
        
    }
    
    
    @objc func showAllGoals() {
        selectedCalendarDate = ""
        bool = false
        scrollView.removeSubviews()
        setUpGoals()
    }
    
    @objc func toCreate() {
        self.tabBarController?.tabBar.isHidden = true
        lblHeader.alpha = 0
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "createGoal") as! CreateGoalViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    @objc func editGoal(sender: UIButton) {
        
        let btnLabel = (sender.titleLabel?.text)!
        if(btnLabel.isEmpty) {
            print("error")
        }
            
        else {
            btnActionSheet(created: btnLabel)
        }
    }
    
    
    
    func toEdit(created: String) {
        self.tabBarController?.tabBar.isHidden = true
        lblHeader.alpha = 0
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let editGoal = storyboard.instantiateViewController(withIdentifier: "editGoal") as! EditGoalViewController
        editGoal.goalToEdit = created
        self.navigationController?.pushViewController(editGoal, animated: true)
        
    }
    
    func refresh() {
        scrollView.removeSubviews()
        setUpGoals()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        createHeaderMain()
        refresh()

        self.tabBarController?.tabBar.isHidden = false
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

