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
    var btnFilter = UIButton()

    
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
    
    
    func setUpGoals(evaluation:String) {
        print("selectedCalendarDate: \(String(describing: selectedCalendarDate))")

        ySize = 0
        var strDateShort = String()
        let top = (self.tabBarController?.tabBar.frame.size.height)! + 5

        let formatter = DateFormatter()
        formatter.dateFormat = "E, MMM d"
        formatter.locale = Locale(identifier: "en_GB")
        
        let formatterShort = DateFormatter()
        formatterShort.dateFormat = "dd-MM-yyyy"
        formatterShort.locale = Locale(identifier: "en_GB")
        
     
        
        if(selectedCalendarDate.isEmpty){
            bool = false
            let strTitle = "All goals"
            strDate = strTitle.uppercased()
            btnAll.isHidden = true
            lblDate.text = strDate


        }
        else if(selectedCalendarDate == "no date") {
            bool = false
            strDate = selectedCalendarDate.uppercased()
            lblDate.text = strDate
            
        }
            
        else if(selectedCalendarDate == "accomplished") {
            bool = false
            strDate = selectedCalendarDate.uppercased()
            btnAll.isHidden = true
            lblDate.text = strDate

        }
            
        else if(selectedCalendarDate == "hide accomplished") {
            bool = false
            let strTitle = "TO DO"
            strDate = strTitle.uppercased()
            btnAll.isHidden = true
            lblDate.text = strDate

        }
            
        else {
            bool = true
            btnAll.isHidden = false
            
            let toDateFormat = formatterShort.date(from: selectedCalendarDate)
            let toStr = formatter.string(from: toDateFormat!)
            
            strDate = selectedCalendarDate
            strDateShort = toStr
            lblDate.text = strDateShort.uppercased()

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
        
        var evalReview = String()
        var evalMood = Int16()
        
        // Set up list of entries from data created by the user
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequestGoals = NSFetchRequest<Goals>(entityName: "Goals")
        let fetchRequestRelation = NSFetchRequest<GoalKeywords>(entityName: "GoalKeywords")
        
        let fetchRequestKeywords = NSFetchRequest<Keywords>(entityName: "Keywords")
        let primarySortDescriptor = NSSortDescriptor(key: "created", ascending: true)
        
        
        
        if(bool == true){
            
            let predicateDeadline = NSPredicate(format: "deadline == %@", strDate)
            fetchRequestGoals.predicate = predicateDeadline

        }
        else if(strDate == "NO DATE") {
           
            let predicateDeadline = NSPredicate(format: "deadline == %@", "")
            fetchRequestGoals.predicate = predicateDeadline
            
        }
            
        else if(strDate == "ACCOMPLISHED") {
            let predicateDeadline = NSPredicate(format: "accomplished == %@", NSNumber(value: true))
            fetchRequestGoals.predicate = predicateDeadline
        }
            
        else if(strDate == "TO DO") {
            let predicateDeadline = NSPredicate(format: "accomplished == %@", NSNumber(value: false))
            fetchRequestGoals.predicate = predicateDeadline
        }
        
        
        fetchRequestGoals.sortDescriptors = [primarySortDescriptor]
        let allGoals = try! context.fetch(fetchRequestGoals)
        
        for goal in allGoals {
            
            evalMood = 0
            
            arrRelatedKeywords.removeAll()
            arrRelatedValue.removeAll()
            
            
            if(goal.created == evaluation){
                
                let fetchRequestEval = NSFetchRequest<Evaluation>(entityName: "Evaluation")
                
                let predicateEval = NSPredicate(format: "goal == %@", goal)
                fetchRequestEval.predicate = predicateEval
                
                let evalObjects = try! context.fetch(fetchRequestEval)
                
                for eval in evalObjects {
                    
                    evalReview = eval.review
                    evalMood = eval.mood
                    
                }
            }
                
       
                
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
                            arrRelatedValue.append(manyRelation.rate)
                            
                        }
                    
                }
                
            createGoal(title: goal.title, note: goal.note, deadline: goal.deadline , created: goal.created, y: CGFloat(ySize), arrKeywords: arrRelatedKeywords, accomplished: goal.accomplished, evalMood:  evalMood, evalReview: evalReview, evalRateArr: arrRelatedValue)
           

                
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
    
    func createGoal(title:String, note:String, deadline:String, created:String, y:CGFloat, arrKeywords:Array<Any>, accomplished: Bool, evalMood:Int16, evalReview:String, evalRateArr:Array<Int16>) {
        
        let viewGoal = UIView()
        let viewHeader = UIView()

        let viewContent = UIView()
        let viewKeywords = UIView()
        
        let imgView = UIImageView()
        let lblTitle = UILabel()
        let lblAffected = UILabel()

        let lblEvalMood = UILabel()
        let lblTime = UILabel()
        let txtEntry = UITextView()
        let btnEdit = UIButton()
        let viewBorder = UIView()
        
        var headerHeight = CGFloat()
        
        
        let formatterShort = DateFormatter()
        formatterShort.dateFormat = "MMM d"
        formatterShort.locale = Locale(identifier: "en_GB")
        
        let formatterDate = DateFormatter()
        formatterDate.dateFormat = "dd-MM-yyyy"
        formatterDate.locale = Locale(identifier: "en_GB")
        

        
        //get today's date
        
        let gradientLayer = CAGradientLayer()
        
        viewGoal.frame = CGRect(x: 15, y: y, width: self.view.frame.size.width - 30, height: 100)
        viewGoal.clipsToBounds = false
        viewGoal.layer.cornerRadius = 25
        viewGoal.layer.shadowColor = blackColor.cgColor
        viewGoal.layer.shadowOffset = CGSize(width: 6, height: 6)
        viewGoal.layer.shadowOpacity = 0.05
        viewGoal.layer.shadowRadius = 10.0
        
        viewHeader.frame.size.width = viewGoal.frame.size.width
        lblTime.frame = CGRect(x: 15, y: 0, width: viewHeader.frame.size.width - 30, height: 45)
        lblTime.textAlignment = .center
        
        gradientLayer.frame = CGRect(x: 0, y: 0, width: viewGoal.frame.size.width, height: 45)
        gradientLayer.cornerRadius = 25
        gradientLayer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
 
        lblAffected.textAlignment = .left
        lblAffected.font = fontInput

        if(accomplished == true){
            
            let btnViewEval = UIButton()
            let strBtnEval = created
            let imgEval = UIImage(named: "ic_more_white")
            
            btnViewEval.frame = CGRect(x: viewDay.frame.size.width - 30 - 15, y: 7.5, width: 30, height: 30)
            btnViewEval.backgroundColor = UIColor.clear
            viewHeader.backgroundColor = UIColor.clear
            
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 1)
            viewHeader.layer.insertSublayer(gradientLayer, at: 0)
            
            lblAffected.text = "Evaluation of related issues:"
            
            if (evalMood == 0){
                
                lblTime.text = "Accomplished!"
                lblTime.font = fontMainMedium
                lblTime.textColor = whiteColor
            
                lblEvalMood.isHidden = true
                gradientLayer.colors = [purpleColor.cgColor, blueColor.cgColor]
                
                lblAffected.textColor = blackColor.withAlphaComponent(0.4)

                btnViewEval.imageEdgeInsets = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
                btnViewEval.setTitle(strBtnEval, for: .normal)
                btnViewEval.titleLabel?.isHidden = true
                btnViewEval.addTarget(self,action:#selector(showEvaluation), for:.touchUpInside)
                btnViewEval.setImage(imgEval, for: .normal)

                
            }
          
            else {
                lblEvalMood.isHidden = false
                lblEvalMood.text = "Overall:"
                lblEvalMood.textColor = whiteColor
                lblEvalMood.textAlignment = .right
                lblEvalMood.font = fontInput
                
                lblTime.text = "Evaluation"
                lblTime.font = fontMainMedium
                lblTime.textColor = purpleColor
                
                gradientLayer.colors = [whiteColor.cgColor, whiteColor.cgColor]

                lblAffected.textColor = whiteColor

                btnViewEval.titleLabel?.font = fontMainMedium
                btnViewEval.setTitle("X", for: .normal)
                btnViewEval.titleLabel?.textColor = purpleColor
                btnViewEval.titleLabel?.isHidden = false

                btnViewEval.addTarget(self,action:#selector(hideEvaluation), for:.touchUpInside)
                btnViewEval.backgroundColor = UIColor.clear
                //btnViewEval.setImage(imgEval, for: .normal)
                
                
            }
            

            headerHeight = 45
            viewHeader.addSubview(lblTime)
            viewHeader.addSubview(btnViewEval)

            
            
        }
            
        else if (deadline.isEmpty) {
            lblAffected.text = "Issues related to this goal:"
            lblAffected.textColor = blackColor.withAlphaComponent(0.4)
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
           
            lblAffected.text = "Issues related to this goal:"
            lblAffected.textColor = blackColor.withAlphaComponent(0.4)

            viewHeader.addSubview(lblTime)
            
            headerHeight = 45

        }
        
        
        viewContent.frame = CGRect(x: 0, y: 15, width: viewGoal.frame.size.width, height: 40)
        viewContent.backgroundColor = UIColor.clear
        
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
        
        if(evalMood == 0){
            viewGoal.backgroundColor = whiteColor
            lblTitle.textColor = blackColor
            txtEntry.text = note
            btnEdit.isHidden = false
            imgView.isHidden = true
            viewBorder.backgroundColor = blackColor.withAlphaComponent(0.1)

            txtEntry.font = fontInput
            
        }
        else {
            viewGoal.backgroundColor = purpleColor
            txtEntry.backgroundColor = UIColor.clear
            lblTitle.textColor = whiteColor
            lblTitle.font = fontInput
            txtEntry.textColor = whiteColor
            btnEdit.isHidden = true
            imgView.isHidden = false
            viewBorder.backgroundColor = whiteColor.withAlphaComponent(0.4)
            txtEntry.font = font18Med
            txtEntry.text = evalReview

        }

        
        txtEntry.isEditable = false
        txtEntry.isScrollEnabled = false
        
        if(txtEntry.text.isEmpty){
            txtEntry.frame.size.height = 140
        }
        else {
            txtEntry.sizeToFit()
            //txtEntry.translatesAutoresizingMaskIntoConstraints = false

        }

       viewKeywords.frame = CGRect(x: 0, y: txtEntry.frame.size.height + lblTitle.frame.size.height + 35, width: viewContent.frame.size.width, height: 0)
        
        
        
        var lblY = CGFloat(0)
        
          for (keyword, value) in zip(arrKeywords, evalRateArr) {

            var lblHeight = CGFloat()
            var strKeywords = String()
            let lblKeywords = UILabel()
            
            if(accomplished == true){

            if(value == 0){
               
                 lblKeywords.isHidden = true
                 lblHeight = 0
                lblKeywords.text = ""

            }
            else {
                if (evalMood == 0){
                    strKeywords = "\(value)%  \(keyword)"
                    lblKeywords.textColor = blueColor
                    lblKeywords.font = fontReg18

                    lblKeywords.text = strKeywords
                 
                }
                else{
                    let strVal = "\(value)% "

                    
                    let attrs1 = [NSAttributedStringKey.font : font19Med!, NSAttributedStringKey.foregroundColor : whiteColor]
                    let attrs2 = [NSAttributedStringKey.font : fontInput!, NSAttributedStringKey.foregroundColor : whiteColor]
                    
                    let attributedString1 = NSMutableAttributedString(string:strVal, attributes:attrs1)
                    let attributedString2 = NSMutableAttributedString(string: "\(keyword)", attributes:attrs2)
                    
                    attributedString1.append(attributedString2)

                   // strKeywords = "\(value)%  \(keyword)"
                    lblKeywords.attributedText = attributedString1
                    
                }
                
                let size: CGSize = strKeywords.size(withAttributes: [NSAttributedStringKey.font: font17Med!])
                lblHeight = size.height
               
            }
                
          }
            
            else {
                if(value == 0){
                    
                    lblKeywords.isHidden = false
                    strKeywords = "\(keyword)"
                    lblKeywords.textColor = blueColor
                    lblKeywords.font = fontReg18

                    lblKeywords.text = strKeywords

                    
                    let size: CGSize = strKeywords.size(withAttributes: [NSAttributedStringKey.font: font17Med!])
                    lblHeight = size.height
                    
                }
                else {
                    
                    lblKeywords.isHidden = true
                    lblHeight = 0
                    
                }
               
                
            }
            
            lblKeywords.frame =  CGRect(x: 15, y: lblY + 15, width: goalWidth, height: lblHeight)
            lblKeywords.numberOfLines = 0
            
            print("arrKeywords : \(String(describing: arrKeywords))")
            print("evalRateArr : \(String(describing: evalRateArr))")

            viewKeywords.addSubview(lblKeywords)
            
            lblY = lblY + lblHeight
            viewKeywords.frame.size.height = lblY
            
        }
        
        
        let strCreated = created
        
        
        btnEdit.frame =  CGRect(x: viewGoal.frame.width - 45, y: 0, width: 30, height: 30)
        let image = UIImage(named: "arrow_down")
        
        imgView.image = UIImage(named: "ic_mood\(evalMood)_white")
        print("ic_mood\(evalMood)_white")
        
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
        

        viewContent.frame.size.height = lblTitle.frame.size.height + txtEntry.frame.size.height + viewKeywords.frame.size.height + 30 + 25
        viewGoal.frame.size.height = viewContent.frame.size.height + headerHeight + 25
         lblAffected.frame = CGRect(x: 15, y: txtEntry.frame.size.height + lblTitle.frame.size.height + 18, width: viewContent.frame.size.width - 30, height: 25)
        
         lblEvalMood.frame = CGRect(x: viewGoal.frame.size.width - 100, y: txtEntry.frame.size.height + lblTitle.frame.size.height + 18, width: 100, height: 25)
        imgView.frame = CGRect(x: viewGoal.frame.size.width - 35 - 15, y: viewGoal.frame.size.height - 45 - 15 - 35, width: 35, height: 35)

        viewBorder.frame = CGRect(x: 15, y: txtEntry.frame.size.height + lblTitle.frame.size.height + 15, width: viewContent.frame.size.width - 30, height: 1.5)
        

        viewContent.addSubview(imgView)
        viewContent.addSubview(lblTitle)
        viewContent.addSubview(lblAffected)
        viewContent.addSubview(lblEvalMood)

        viewContent.addSubview(txtEntry)
        viewContent.addSubview(viewKeywords)
        viewContent.addSubview(btnEdit)
        viewContent.addSubview(viewBorder)
        
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
        btnFilter.frame =  CGRect(x: 15*2, y: top + 60 + self.view.frame.size.height/1.7 + 20 + 15, width: 100, height: 45)
        
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
        
        btnFilter.setTitle("Filter",for: .normal)
        btnFilter.setTitleColor(whiteColor, for: .normal)
        btnFilter.isEnabled = true
        //btnFilter.titleLabel?.textColor = blackColor
        btnFilter.titleLabel?.textAlignment = .center
        //btnFilter.tintColor = blackColor
        btnFilter.backgroundColor = lightPurpleColor
        btnFilter.titleLabel?.font = fontMainRegular
        btnFilter.addTarget(self,action:#selector(btnFilterActionSheet), for:.touchUpInside)
        
        btnFilter.layer.cornerRadius = 22.5
        /*
        btnFilter.layer.borderWidth = 0
        btnFilter.layer.borderColor = blackColor.withAlphaComponent(0.1).cgColor
        btnFilter.layer.shadowColor = blackColor.cgColor
        btnFilter.layer.shadowOffset = CGSize(width: -6, height: 6)
        btnFilter.layer.shadowOpacity = 0.05
        btnFilter.layer.shadowRadius = 5.0
        */
        self.view.addSubview(btnFilter)
        self.view.addSubview(btnAdd)
        
    }
  
    
    @objc func btnFilterActionSheet() {
        
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        
        let allButton = UIAlertAction(title: "Show all", style: .default, handler: { (action) -> Void in
             self.selectedCalendarDate = ""
            self.refresh(strEval: "")

        })
        
        let  noDateButton = UIAlertAction(title: "Show without date", style: .default, handler: { (action) -> Void in
            self.selectedCalendarDate = "no date"
            self.refresh(strEval: "")
            
        })
        
        let  accomplishButton = UIAlertAction(title: "Show accomplished", style: .default, handler: { (action) -> Void in
            self.selectedCalendarDate = "accomplished"
            self.refresh(strEval: "")
            
        })
        
        let  hideAccomplishButton = UIAlertAction(title: "Hide accomplished", style: .default, handler: { (action) -> Void in
            self.selectedCalendarDate = "hide accomplished"
            self.refresh(strEval: "")
            
        })
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            print("Cancel button tapped")
        })
        
        
        alertController.addAction(allButton)
        alertController.addAction(noDateButton)
        alertController.addAction(accomplishButton)
        alertController.addAction(hideAccomplishButton)
        alertController.addAction(cancelButton)

        self.navigationController!.present(alertController, animated: true, completion: nil)
    }
    
    
    func btnActionSheet(created: String) {
        
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        
        let editButton = UIAlertAction(title: "Edit", style: .default, handler: { (action) -> Void in
            self.toEdit(created: created)
        })
        
        let  deleteButton = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) -> Void in
            self.deleteGoal(created: created)
            self.refresh(strEval: "")
            
        })
        
        let  accomplishButton = UIAlertAction(title: "Accomplish", style: .default, handler: { (action) -> Void in
            
            self.toEvaluation(created: created)
           
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
    
    func getEvaluation(created:String) {
        
       refresh(strEval: created)
        
    }
    
    @objc func hideEvaluation(sender: UIButton) {
        
       refresh(strEval: "")
        
    }
    
    @objc func showEvaluation(sender: UIButton) {
        
        let btnLabel = (sender.titleLabel?.text)!
        if(btnLabel.isEmpty) {
            print("error")
        }
            
        else {
            getEvaluation(created: btnLabel)
        }
        
    }
    
    @objc func showAllGoals() {
        selectedCalendarDate = ""
        bool = false
        scrollView.removeSubviews()
        setUpGoals(evaluation: "")
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
    
    func toEvaluation(created: String) {
        self.tabBarController?.tabBar.isHidden = true
        lblHeader.alpha = 0
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let evalGoal = storyboard.instantiateViewController(withIdentifier: "evaluateGoal") as! EvaluateGoalViewController
        evalGoal.goalToEvaluate = created
        self.navigationController?.pushViewController(evalGoal, animated: true)
        
    }
    
    func toEdit(created: String) {
        self.tabBarController?.tabBar.isHidden = true
        lblHeader.alpha = 0
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let editGoal = storyboard.instantiateViewController(withIdentifier: "editGoal") as! EditGoalViewController
        editGoal.goalToEdit = created
        self.navigationController?.pushViewController(editGoal, animated: true)
        
    }
    
    func refresh(strEval:String) {
        scrollView.removeSubviews()
        setUpGoals(evaluation: strEval)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        createHeaderMain()
        refresh(strEval: "")

        self.tabBarController?.tabBar.isHidden = false
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

