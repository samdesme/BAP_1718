//
//  EvaluateGoalViewController.swift
//  journey
//
//  Created by sam de smedt on 17/05/2018.
//  Copyright © 2018 sam de smedt. All rights reserved.
//

import UIKit
import CoreData

class EvaluateGoalViewController: UIViewController, CreateStep1Delegate {
    
    
    //VARIABLES
    @IBOutlet var viewMain: UIView!
    @IBOutlet weak var backButtonItem: UINavigationItem!
    
        
        //VARIABLES
        //strings
        let strHeader = "evaluate your goal"
        let strRate = "Rate how much your selected struggle(s) played a part in the process of completing this goal (optional)"
        let strLblDescr = "Review your experience"
        let strMood = "How would you rate your overall experience with this goal?"
        var value = String()
        let strDateMsg = "edit an entry"
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        
        //view
        let viewDateMsg = UIView()
        let form = UIView()
        let lblReview = UILabel()
        let txtReview = UITextView()
        let viewSliders = UIView()
        let viewOptions = UIView()
        var scrollView = UIScrollView()
        
        
        
        //DATA
        var moodInt : Int16 = 0
        var strGoalTitle = String()
        var strGoalDeadline = String()
        
        
        //edit
        var currentDateTime = Date()
        var entryToEdit = String()
        var getMoodInt = Int16()
        var arrayGetSliderValues = [Int16]()
        var arrayUserKeywords = [String]()
        var titleEdit = String()
        var entryEdit = String()
        
        //update
        var arrayUpdateSliderValues = [Int16]()
        
        //EVALUATE
        var goalToEvaluate = String()

    
        //labels
        let lblMsg = UILabel()
        let lblDate = UILabel()
        let lblSub = UILabel()
        let lblMain = UILabel()
        var lblDisplay = UILabel()
        
        //gradient layers
        let  btnGradientLayer = CAGradientLayer()
        
        //Load view controller
        override func viewDidLoad() {
            super.viewDidLoad()
            
            self.view.addSubview(scrollView)
            
            createView()
            getData()
            setUpDateMsg() 
            setUpSliders()
            createForm()
            setUpMoods()
            
            
        }
        
        
        
        // MARK: layout functions
        
        func createView() {
            self.view.backgroundColor = whiteColor
            scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            scrollView.isScrollEnabled = true
            
        }
        
        func setUpDateMsg() {
            viewDateMsg.frame = CGRect(x: 15, y: 0, width: self.view.frame.size.width - 30, height: 120)
            viewDateMsg.backgroundColor = whiteColor
            
            lblMsg.frame = CGRect(x: 0, y: 40, width: viewDateMsg.frame.size.width, height: 30)
            lblMsg.text = strGoalTitle.uppercased()
            lblMsg.font = fontTitleBig
            lblMsg.textAlignment = .center
            viewDateMsg.addSubview(lblMsg)
            
            var strSub = String()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            formatter.locale = Locale(identifier: "en_GB")
            
            let formatterFull = DateFormatter()
            formatterFull.dateFormat = "MMM d"
            formatterFull.locale = Locale(identifier: "en_GB")
            
            if(strGoalDeadline.isEmpty){
                strSub = ""
            }
            
            else {
                let dateCreated = formatter.date(from: strGoalDeadline)
                let strCreated = formatterFull.string(from: dateCreated!)
                strSub = strCreated
                viewDateMsg.addSubview(lblDate)

            }

            
            lblDate.frame = CGRect(x: 0, y: 40 + 30 + 5, width: viewDateMsg.frame.size.width, height: 25)
            lblDate.text = strSub
            lblDate.textColor = blackColor.withAlphaComponent(0.5)
            lblDate.font = fontMainLight
            lblDate.textAlignment = .center
            
            scrollView.addSubview(viewDateMsg)
        }
        
    func setUpSliders() {
        let lblSliders = UILabel()
        
    
        
        let count = Int(arrayUserKeywords.count)
        let viewHeight = 130 + (60 * count)
        
        viewSliders.frame = CGRect(x: 15, y: 130, width: self.view.frame.width - 30, height: CGFloat(viewHeight))
        
        lblSliders.frame = CGRect(x: 0, y: 0, width: viewSliders.frame.width, height: 120)
        lblSliders.font = fontLabel
        lblSliders.textColor = blackColor
        lblSliders.textAlignment = .left
        lblSliders.text = strRate
        lblSliders.numberOfLines = 0
        
        viewSliders.addSubview(lblSliders)
        
        var yTitle = 0
        var ySlider = 70
        var tag = 1
        
        for (keyword, value) in zip(arrayUserKeywords, arrayGetSliderValues) {
            
            let lblTitle = UILabel()
            let lbltag = UILabel()
            
            lblDisplay = lbltag
            
            let keywordSlider = UISlider()
            
            lblTitle.frame = CGRect(x: 0, y: 130 + yTitle, width: Int(viewSliders.frame.size.width), height: 25)
            lblTitle.text = "\(keyword)"
            lblTitle.textAlignment = .right
            lblTitle.font = fontInput
            lblTitle.textColor = blackColor
            
            lblDisplay.frame = CGRect(x: 0, y: 80 + ySlider, width: 60, height: 50)
            lblDisplay.text = String(value) + "%"
            lblDisplay.textAlignment = .center
            lblDisplay.font = fontMainRegular20
            lblDisplay.tag = tag
            lblDisplay.textColor = blueColor
            
            keywordSlider.frame = CGRect(x: 60, y: 80 + ySlider, width: Int(viewSliders.frame.size.width - 60), height: 40)
            keywordSlider.minimumValue = 0
            keywordSlider.maximumValue = 100
            keywordSlider.tag = 100 + tag
            keywordSlider.value = Float(value)
            keywordSlider.isContinuous = true
            keywordSlider.tintColor = blueColor
            keywordSlider.addTarget(self, action: #selector(self.sliderValueDidChange(_:)), for: .valueChanged)
            
            viewSliders.addSubview(lblTitle)
            viewSliders.addSubview(lblDisplay)
            viewSliders.addSubview(keywordSlider)
            
            tag = tag + 1
            yTitle = yTitle + 60
            ySlider = ySlider + 60
            
        }
        
        scrollView.addSubview(viewSliders)
    }
        
        func createForm() {
            
            //create form view
            form.frame = CGRect(x: 15, y: 120 + viewSliders.frame.size.height + 15*2, width: self.view.frame.width - 30, height: 200)
            
            lblReview.frame = CGRect(x: 0, y: 15, width: form.frame.size.width, height: 30)
            txtReview.frame = CGRect(x: 0, y: 15 + 30 + 10, width: form.frame.size.width, height: 115)
            
            lblReview.font = fontLabel
            lblReview.text = strLblDescr
            lblReview.textColor = blackColor
            lblReview.textAlignment = .left
            
            //UITextfield
            txtReview.layer.cornerRadius = 5
            
            txtReview.layer.borderColor = UIColor.gray.withAlphaComponent(0.4).cgColor
            txtReview.layer.borderWidth = 1
            txtReview.font = fontInput
            txtReview.clipsToBounds = false
            
            //add view to content view
            form.addSubview(lblReview)
            form.addSubview(txtReview)
            scrollView.addSubview(form)
        }
        
        func setUpMoods() {
            
            let lblMoodRate = UILabel()
            var x = 0
            
            let y = 120 + viewSliders.frame.size.height + 15*2 + form.frame.size.height
            
            viewOptions.frame =  CGRect(x: 15, y: y, width: self.view.frame.width - 30, height: 120)
            let columnWidth = (viewOptions.frame.width - 60*5)/4
            
            lblMoodRate.frame = CGRect(x: 0, y: 0, width: viewOptions.frame.width, height: 80)
            lblMoodRate.font = fontLabel
            lblMoodRate.textColor = blackColor
            lblMoodRate.textAlignment = .left
            lblMoodRate.text = strMood
            lblMoodRate.numberOfLines = 0
            
            viewOptions.addSubview(lblMoodRate)
            
            for i in 1...5 {
                
                let btnMood = UIButton()
                let image = UIImage(named: "ic_mood\(i)_outline")
                
                btnMood.setBackgroundImage(image, for: .normal)
                btnMood.tag = 1110 + i
                btnMood.isSelected = false
                btnMood.frame =  CGRect(x: x, y: 80, width: 60, height: 60)
                btnMood.addTarget(self,action:#selector(selectMood), for:.touchUpInside)
                
                viewOptions.addSubview(btnMood)
                
                x = x + 60 + Int(columnWidth)
                
            }
            
            scrollView.addSubview(viewOptions)
            scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 120 + form.frame.size.height + viewSliders.frame.size.height + viewOptions.frame.size.height + 50)
            
        }
        
        @objc func selectMood(sender: UIButton) {
            
            sender.isSelected = !sender.isSelected
            
            if sender.isSelected {
                
                if (sender.tag == 1111){
                    let img = UIImage(named: "ic_mood1")
                    sender.setBackgroundImage(img, for: .normal)
                    deselect(tag: 1111)
                    moodInt = 1
                }
                else if (sender.tag == 1112) {
                    let img = UIImage(named: "ic_mood2")
                    sender.setBackgroundImage(img, for: .normal)
                    deselect(tag: 1112)
                    moodInt = 2
                    
                }
                else if (sender.tag == 1113) {
                    let img = UIImage(named: "ic_mood3")
                    sender.setBackgroundImage(img, for: .normal)
                    deselect(tag: 1113)
                    moodInt = 3
                    
                }
                else if (sender.tag == 1114) {
                    let img = UIImage(named: "ic_mood4")
                    sender.setBackgroundImage(img, for: .normal)
                    deselect(tag: 1114)
                    moodInt = 4
                    
                }
                else if (sender.tag == 1115) {
                    let img = UIImage(named: "ic_mood5")
                    sender.setBackgroundImage(img, for: .normal)
                    deselect(tag: 1115)
                    moodInt = 5
                }
                
            }
            
            
        }
        
        func deselect(tag:Int) {
            
            for index in 1111...1115 where index != tag {
                
                if let buttons = view.viewWithTag(index) as? UIButton {
                    
                    let imgInt = index - 1110
                    let img = UIImage(named: "ic_mood\(imgInt)_outline")
                    buttons.isSelected = false
                    buttons.setBackgroundImage(img, for: .normal)
                    
                }
                
            }
            
        }
        
        @objc func printSliderValues() {
            getSliderValues()
            print("\(String(describing: arrayUpdateSliderValues))")
            
            
        }
        
        func getSliderValues() {
            let tagCount = arrayUserKeywords.count + 100
            for i in 101...tagCount {
                
                if let slider = viewSliders.viewWithTag(i) as? UISlider {
                    let value = Int(round(slider.value))
                    arrayUpdateSliderValues.append(Int16(value))
                    print("\(Decimal(value))")
                }
                
            }
        }
        
        @objc func sliderValueDidChange(_ sender:UISlider!)
        {
            let tagCount = arrayUserKeywords.count + 100
            for i in 101...tagCount {
                
                if (sender.tag == i){
                    
                    let value = Int(round(sender.value))
                    let tagLabels = i - 100
                    
                    if let theLabel = view.viewWithTag(tagLabels) as? UILabel {
                        theLabel.text = String(value) + "%"
                    }
                }
            }
        }
        
        
        func createHeaderSub() {
            
            //variables
            let navBar = navigationController?.navigationBar
            let frameTitle = CGRect(x: 0, y: 0, width: (navBar?.frame.size.width)!, height: (navBar?.frame.size.height)!)
            lblSub.frame = frameTitle
            
            //Create navigation bar for sub views
            navBar?.barStyle = .blackTranslucent
            navBar?.applyNavigationGradient(colors: [blueColor , lightBlueColorHeader])
            lblSub.text = strHeader.uppercased()
            lblSub.font = fontHeaderSub
            lblSub.textColor = whiteColor
            lblSub.textAlignment = .center
            
            navBar?.addSubview(lblSub)
            addBackButton()
            addSaveButton()
            
        }
        
        func createHeaderMain() {
            
            //variables
            let navBar = navigationController?.navigationBar
            
            //Edit navigation bar back to main settings
            navBar?.barStyle = .default
            navBar?.applyNavigationGradient(colors: [whiteColor , whiteColor])
            navBar?.addSubview(lblMain)
            
        }
        
        
        // MARK: data functions
        func saveData() {
            
            let context = appDelegate.persistentContainer.viewContext
            
            let note = txtReview.text
            var strNote = String()
            
            let newEval = NSEntityDescription.insertNewObject(forEntityName: "Evaluation", into: appDelegate.persistentContainer.viewContext) as! Evaluation
            let goalFetchRequest = NSFetchRequest<Goals>(entityName: "Goals")
            let fetchRequestRelation = NSFetchRequest<GoalKeywords>(entityName: "GoalKeywords")
            
            let allGoals = try! context.fetch(goalFetchRequest)
            
            for goal in allGoals {
                
                
                let goalCr = goal.created
                
                if(goalCr == goalToEvaluate){
                    

                    if(note?.isEmpty)!{
                        strNote = ""
                    }
                    else{
                        strNote = note!
                    }
                    
                    newEval.review = strNote
                    newEval.mood = moodInt
                    newEval.goal = goal
                    
                    
                    do {
                        try context.save()
                        
                        goal.evaluation = newEval
                        goal.accomplished = true
                        
                        
                        do {
                            try context.save()
                            
                            getSliderValues()
                            print("\(String(describing: arrayUpdateSliderValues))")
                            
                            
                            let predicateRelation = NSPredicate(format: "goal == %@", goal)
                            fetchRequestRelation.predicate = predicateRelation
                            
                            let manyRelations = try! context.fetch(fetchRequestRelation)
                            
                            for (index, element ) in manyRelations.enumerated() {
                                
                                let sliderValue = arrayUpdateSliderValues[index]
                                
                                element.rate = sliderValue
                                
                            }
                            
                            do {
                                
                                try context.save()
                                print("updated evaluation successfully!")
                                
                            } catch {
                                print("Failed saving relations")
                            }
                            
                            
                            
                        } catch {
                            print("Failed saving \(goal)")
                        }
                        
                        
                    } catch {
                        print("Failed saving \(newEval)")
                    }
                    
                }
                
               
            }
            
            
        }
        
        func getData() {
            
            let formatterFull = DateFormatter()
            formatterFull.dateFormat = "yyyy-MM-dd HH:mm:ss +0000"
            formatterFull.locale = Locale(identifier: "en_GB")
            
            //fetch data from custom added keywords and return them as an array
            let context = appDelegate.persistentContainer.viewContext
            let keywordFetchRequest = NSFetchRequest<Keywords>(entityName: "Keywords")
            let goalsFetchRequest = NSFetchRequest<Goals>(entityName: "Goals")
            let fetchRequestRelation = NSFetchRequest<GoalKeywords>(entityName: "GoalKeywords")
            
            //let predicateRelation = NSPredicate(format: "date == %@", entryToEdit)
            //entryFetchRequest.predicate = predicateRelation
            
            let allGoals = try! context.fetch(goalsFetchRequest)
            
            for goal in allGoals {
                
                
                let goalCreated = goal.created
                
                if(goalCreated == goalToEvaluate){
                    
                    
                    let predicateRelation = NSPredicate(format: "goal == %@", goal)
                    fetchRequestRelation.predicate = predicateRelation
                    
                    let manyRelations = try! context.fetch(fetchRequestRelation)
                    
                    for manyRelation in manyRelations {
                        
                        
                        let strKeywordID = manyRelation.keyword.objectID
                        let predicateKeywords = NSPredicate(format: "SELF = %@", strKeywordID)
                        keywordFetchRequest.predicate = predicateKeywords
                        
                        let relatedKeywords = try! context.fetch(keywordFetchRequest)
                        
                        for keyword in relatedKeywords {
                            
                            
                            arrayGetSliderValues.append(manyRelation.rate)
                            arrayUserKeywords.append(keyword.title as String)
                            
                            print("arrayUserKeywords : \(String(describing: arrayUserKeywords))")

                            print("strGoalTitle : \(String(describing: goal.title))")

                            strGoalTitle = goal.title
                            strGoalDeadline = goal.deadline
                            
                            
                            
                        }
                        
                        
                    }
                    
                    
                }
                
                
            }
            
        }
        
        
        
        
        
        // MARK: alerts
        
        func showAlertQuit() {
            
            let refreshAlert = UIAlertController(title: "Go back to your entries", message: "Are you sure you want to quit adding your entries? Your data will be lost", preferredStyle: UIAlertControllerStyle.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Quit", style: .default, handler: { (action: UIAlertAction!) in
                self.popBack()
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Nevermind", style: .cancel, handler: { (action: UIAlertAction!) in
                
            }))
            
            present(refreshAlert, animated: true, completion: nil)
        }
        
        func showAlertFormCheck() {
            
            let refreshAlert = UIAlertController(title: "Empty fields", message: "To add an entry, you must fill in all fields.", preferredStyle: UIAlertControllerStyle.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                
            }))
            
            present(refreshAlert, animated: true, completion: nil)
        }
        
        
        // MARK: actions
        
        @IBAction func backAction(_ sender: UIButton) {
            showAlertQuit()
        }
        
        func popBack() {
            lblSub.removeFromSuperview()
            createHeaderMain()
            self.tabBarController?.tabBar.alpha = 1
            let _ = self.navigationController?.popViewController(animated: true)
        }
        
        func addSaveButton() {
            let NavLinkAttr : [NSAttributedStringKey: Any] = [
                NSAttributedStringKey.font : fontBtnNavLink!,
                NSAttributedStringKey.foregroundColor : whiteColor,
                NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue]
            let attributeString = NSMutableAttributedString(string: "Save",
                                                            attributes: NavLinkAttr)
            
            let btnCreate = UIButton(type: .custom)
            
            btnCreate.setAttributedTitle(attributeString, for: .normal)
            btnCreate.addTarget(self, action: #selector(toMainPage), for: .touchUpInside)
            //add btn
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: btnCreate)
        }
        
        @objc func toMainPage() {
            
            let title = txtReview.text
            
            if(title?.isEmpty)!{
                
                showAlertFormCheck()
                
            }
                
            else {
                
                saveData()
                lblSub.removeFromSuperview()
                createHeaderMain()
                self.tabBarController?.tabBar.alpha = 1
                
                var viewControllers = navigationController?.viewControllers
                viewControllers?.removeLast(1)
                navigationController?.setViewControllers(viewControllers!, animated: true)
            }
        }
        
        func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
        {
            
            let updatedStringDescr = (self.txtReview.text as NSString?)?.replacingCharacters(in: range, with: string)
            self.txtReview.text = updatedStringDescr
          
            return true
        }
        
        func addBackButton() {
            let backButton = UIButton(type: .custom)
            backButton.setImage(UIImage(named: "btnBackWhite.png"), for: .normal)
            backButton.setTitle("", for: .normal)
            backButton.setTitleColor(whiteColor, for: .normal)
            backButton.addTarget(self, action: #selector(self.backAction(_:)), for: .touchUpInside)
            //add btn
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        }
        
        
        override func viewWillAppear(_ animated: Bool) {
            
            super.viewWillAppear(animated)
            createHeaderSub()
            self.tabBarController?.tabBar.alpha = 0
            
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        
        
}

