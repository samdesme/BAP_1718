//
//  EditGoalViewController.swift
//  journey
//
//  Created by sam de smedt on 14/05/2018.
//  Copyright © 2018 sam de smedt. All rights reserved.
//

import UIKit
import CoreData

class EditGoalViewController: UIViewController, CreateStep1Delegate {
    
    //OUTLET REFERENTIONS
    
    @IBOutlet var viewMain: UIView!
    @IBOutlet weak var backButtonItem: UINavigationItem!
        
        //VARIABLES
        
        //strings
        let strHeader = "edit your goal"
        let strLblTitle = "Title"
        let strLblDescr = "Your note (opinional)"
        var goalToEdit = String()
        var value = String()
        var heightOptions = CGFloat()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        var arrayUserKeywords = [String]()
        
        var datePicker = UIDatePicker()
        var txtFieldDate = UITextField()
        var arraySelection = [String]()
        
        //view
        let form = Bundle.main.loadNibNamed("CreateStep1", owner: nil, options: nil)?.first as! CreateStep1
        var scrollView = UIScrollView()
        let viewToggle = UIView()
        let viewSwitch = UIView()
        var viewKeywords = UIView()
        var switchAction = UISwitch()
    
        //data
        var arrayGetRateValues = [Int16]()
        var arraySavedSelection = [String]()
        var boolDeadline = Bool()
        var dateDeadline = Date()

    
        //labels
        let lblSub = UILabel()
        let lblMain = UILabel()
        var lblDeadline = UILabel()
        
        //gradient layers
        let  btnGradientLayer = CAGradientLayer()
        
        //Load view controller
        override func viewDidLoad() {
            super.viewDidLoad()
            
            
            
            self.view.addSubview(scrollView)
            self.datePicker.datePickerMode = UIDatePickerMode.date
            self.datePicker.locale = Locale(identifier: "en_GB")
            
            getData()
            createView()
            
        }
        
        func createView() {
    
            let navBar = navigationController?.navigationBar
            self.view.backgroundColor = whiteColor
            
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "dd-MM-yyyy"
            dateformatter.locale = Locale(identifier: "en_GB")
            
            scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            scrollView.isScrollEnabled = true
            //scrollView.backgroundColor = blueColor.withAlphaComponent(0.2)
            
            createForm()
            setUpSwitch()
            setUpButtons()
            
            if(boolDeadline == true){
                self.datePicker.minimumDate = dateDeadline
                self.datePicker.date = dateDeadline
                switchAction.setOn(true, animated:true)
                viewToggle.isHidden = false
                let strFromDate = dateformatter.string(from: dateDeadline)
                txtFieldDate.text = strFromDate
                
                viewKeywords.frame = CGRect(x: 15, y: 100 + self.view.frame.height/3, width: self.view.frame.width - 30, height: heightOptions)
                
                
            }
                
            else {
                let currentDate = Date()
                self.datePicker.minimumDate = currentDate
                self.datePicker.date = currentDate
                switchAction.setOn(false, animated:true)
                viewToggle.isHidden = true
                txtFieldDate.text = ""

                viewKeywords.frame = CGRect(x: 15, y: 50 + self.view.frame.height/3, width: self.view.frame.width - 30, height: heightOptions)
            }
            
            let bottom = (navBar?.frame.size.height)! + form.frame.size.height + viewSwitch.frame.size.height + viewKeywords.frame.size.height + 15
            
            
            scrollView.contentSize.height = bottom
        }
        
        // MARK: layout functions
        
        func createForm() {
            
            //create form view
            form.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: (self.view.frame.height/3))
            form.backgroundColor = whiteColor
            
            // UILabels
            form.lblName.frame.size.height = 100
            form.lblName.font = fontLabel
            form.lblName.text = strLblTitle
            form.lblName.textColor = blackColor
            form.lblName.textAlignment = .left
            
            form.lblAbout.font = fontLabel
            form.lblAbout.text = strLblDescr
            form.lblAbout.textColor = blackColor
            form.lblAbout.textAlignment = .left
            
            //UITextView
            form.txtName.layer.cornerRadius = 5
            form.txtName.layer.borderColor = UIColor.gray.withAlphaComponent(0.4).cgColor
            form.txtName.layer.borderWidth = 1
            form.txtName.font = fontInput
            form.txtName.clipsToBounds = true
            
            //UITextfield
            form.txtAbout.layer.cornerRadius = 5
            form.txtAbout.frame.size.height = 200
            form.txtAbout.layer.borderColor = UIColor.gray.withAlphaComponent(0.4).cgColor
            form.txtAbout.layer.borderWidth = 1
            form.txtAbout.font = fontInput
            form.txtAbout.clipsToBounds = true
            
            // UIButton
            form.btnNextShadow.isHidden = true
            form.btnToStep2.isHidden = true
            
            //add view to content view
            scrollView.addSubview(form)
        }
        
        func setUpSwitch() {
            
            let lblSwitch = UILabel()
            
            viewSwitch.frame = CGRect(x: 0, y: self.view.frame.height/3, width: self.view.frame.width, height: 100)
            
            lblSwitch.frame = CGRect(x: 15, y: 0, width: (self.view.frame.width - 30)/2, height: 20)
            lblSwitch.text = "Add a deadline?"
            lblSwitch.textAlignment = .left
            lblSwitch.font = fontLabel
            lblSwitch.textColor = blackColor
            
            switchAction.frame = CGRect(x: viewSwitch.frame.size.width - 50 - 15, y: 0, width: 50, height: 20)
            switchAction.addTarget(self, action: #selector(buttonClicked), for: .valueChanged)
            
            viewToggle.frame = CGRect(x: 0, y: lblSwitch.frame.height + 20, width: self.view.frame.width, height: 50)
            viewToggle.backgroundColor = whiteColor
            viewToggle.layer.borderWidth = 1
            viewToggle.layer.borderColor = UIColor.gray.withAlphaComponent(0.4).cgColor
            
            txtFieldDate.frame = CGRect(x: 15, y: 0, width: viewToggle.frame.size.width - 30, height: viewToggle.frame.size.height)
            txtFieldDate.inputView = self.datePicker
            txtFieldDate.clipsToBounds = true
            txtFieldDate.textAlignment = .right
            txtFieldDate.isUserInteractionEnabled = true
            txtFieldDate.addTarget(self, action: #selector(textFieldDidBeginEditing), for: UIControlEvents.editingDidBegin)
            txtFieldDate.addTarget(self, action: #selector(textFieldDidEndEditing), for: UIControlEvents.editingDidEnd)
            txtFieldDate.font = fontMainRegular19
            txtFieldDate.textColor = blackColor
            txtFieldDate.placeholder = "Add a date"
            
            /*   let btnInput = UIButton()
             btnInput.frame = CGRect(x: 15, y: 0, width: viewToggle.frame.size.width - 30, height: viewToggle.frame.size.height)
             btnInput.setTitle("click", for: .normal)
             btnInput.backgroundColor = blueColor
             btnInput.addTarget(self,action:#selector(textfieldActive(sender:)),
             for:.touchUpInside)
             viewToggle.addSubview(btnInput)
             */
            
            //txtFieldDate.addConstraint(txtFieldDate.heightAnchor.constraint(equalToConstant: 20))
            
            lblDeadline.frame = CGRect(x: 15, y: 0, width: viewToggle.frame.width/2, height: viewToggle.frame.size.height)
            //lblDeadline.backgroundColor = blueColor.withAlphaComponent(0.2)
            lblDeadline.text = "Deadline: "
            lblDeadline.textAlignment = .left
            lblDeadline.font = fontMainRegular19
            lblDeadline.textColor = purpleColor
            lblDeadline.backgroundColor = UIColor.clear
            
            self.datePicker.addTarget(self, action: #selector(self.datePickerValueChanged(datePicker:)), for: .valueChanged)
            self.datePicker.backgroundColor = whiteColor
            
            // ToolBar
            let toolBar = UIToolbar()
            toolBar.barStyle = UIBarStyle.default
            toolBar.isTranslucent = true
            toolBar.tintColor = blueColor
            toolBar.sizeToFit()
            
            // Adding Button ToolBar
            let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneClick))
            let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            doneButton.setTitleTextAttributes([NSAttributedStringKey.font: fontHeaderSub!], for: .normal)
            doneButton.tintColor = blackColor
            toolBar.setItems([spaceButton, doneButton], animated: false)
            toolBar.isUserInteractionEnabled = true
            txtFieldDate.inputAccessoryView = toolBar
            
            
            viewToggle.addSubview(lblDeadline)
            viewToggle.addSubview(txtFieldDate)
            
            viewSwitch.addSubview(lblSwitch)
            viewSwitch.addSubview(switchAction)
            viewSwitch.addSubview(viewToggle)
            
            scrollView.addSubview(viewSwitch)
        }
        
        @objc func doneClick(sender: UITextField){
            txtFieldDate.resignFirstResponder()
            
        }
        
        @objc func textFieldDidBeginEditing(textField: UITextField) {
            viewToggle.backgroundColor = lightGreyColor.withAlphaComponent(0.5)
            
        }
        
        @objc func textFieldDidEndEditing(textField: UITextField) {
            viewToggle.backgroundColor = whiteColor
            txtFieldDate.resignFirstResponder()
            
        }
        
        @objc func buttonClicked(sender: UIButton) {
            if switchAction.isOn {
                
                switchAction.setOn(false, animated:true)
                viewToggle.isHidden = true
                viewKeywords.frame = CGRect(x: 15, y: 50 + self.view.frame.height/3, width: self.view.frame.width - 30, height: heightOptions)
                
                
            } else {
                
                switchAction.setOn(true, animated:true)
                viewToggle.isHidden = false
                txtFieldDate.resignFirstResponder()
                txtFieldDate.text = ""
                viewKeywords.frame = CGRect(x: 15, y: 100 + self.view.frame.height/3, width: self.view.frame.width - 30, height: heightOptions)
                
            }
        }
        
        
        
        @objc func datePickerValueChanged(datePicker: UIDatePicker) {
            
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "dd-MM-yyyy"
            dateformatter.locale = Locale(identifier: "en_GB")
            let dateGoals = dateformatter.string(from: datePicker.date)
            txtFieldDate.text = dateGoals
            
        }
        
        func setUpButtons() {
            let lblKeywords = UILabel()
            
            getDataKeywords()
            
            viewKeywords.frame = CGRect(x: 15, y: 50 + self.view.frame.height/3, width: self.view.frame.width - 30, height: 200)
            
            lblKeywords.frame = CGRect(x: 0, y: 0, width: viewSwitch.frame.width, height: 80)
            lblKeywords.font = fontLabel
            lblKeywords.textColor = blackColor
            lblKeywords.textAlignment = .left
            lblKeywords.numberOfLines = 0
            
            viewKeywords.addSubview(lblKeywords)
            
            var buttonX: CGFloat = 0
            var buttonY: CGFloat = 10
            
            for keyword in arrayUserKeywords {
                let ySpace: Int = 10
                let btnKeyword = UIButton()
                
                let myString: String = "\(keyword)"
                let size: CGSize = myString.size(withAttributes: [NSAttributedStringKey.font: fontBtnKeyword!])
                let btnWidth = size.width + 20
                let totalWidth = buttonX + btnWidth
                
                if(totalWidth > self.view.frame.size.width - 30){
                    buttonY = buttonY + 40 + CGFloat(ySpace)
                    buttonX = 0
                }
                
                btnKeyword.frame = CGRect(x: buttonX, y: buttonY, width: btnWidth, height: 40)
                buttonX = buttonX + btnWidth + 10
                
                btnKeyword.setTitle("\(keyword)",for: .normal)
                btnKeyword.titleLabel?.font = fontBtnKeyword
                btnKeyword.setTitleColor(blackColor, for: .normal)
                btnKeyword.titleLabel?.textAlignment = .center
                btnKeyword.backgroundColor = whiteColor
                btnKeyword.isSelected = false
                
                btnKeyword.addTarget(self,action:#selector(selectKeyword),
                                     for:.touchUpInside)
                
                btnKeyword.isEnabled = true
                btnKeyword.layer.cornerRadius = 20
                btnKeyword.layer.borderWidth = 1.5
                btnKeyword.layer.borderColor = blackColor.cgColor
                
                
                if(arraySavedSelection.contains("\(keyword)")){
                    
                    btnKeyword.isSelected = true
                    
                    //styling when selected
                    btnKeyword.setTitleColor(whiteColor, for: .normal)
                    btnKeyword.titleLabel?.font = fontMainMedium
                    btnKeyword.backgroundColor = blueColor
                    btnKeyword.layer.borderWidth = 0
                    
                }
                
                viewKeywords.addSubview(btnKeyword)
                
                
                
            }
            
            heightOptions = buttonY + 80
            viewKeywords.frame.size.height = heightOptions
            scrollView.addSubview(viewKeywords)
            
            
        }
        
        
        @objc func selectKeyword(sender: UIButton) {
            
            sender.isSelected = !sender.isSelected
            
            if sender.isSelected {
                
                print(sender.isSelected)
                
                //styling when selected
                sender.setTitleColor(whiteColor, for: .normal)
                sender.titleLabel?.font = fontMainMedium
                sender.backgroundColor = blueColor
                sender.layer.borderWidth = 0
                
                //add label to array
                txtFieldDate.resignFirstResponder()
                arraySavedSelection.append((sender.titleLabel?.text)!)
                
                
            }
                
            else {
                
                print(sender.isSelected)
                
                //styling when deselected
                sender.setTitleColor(blackColor, for: .normal)
                sender.titleLabel?.font = fontBtnKeyword
                sender.backgroundColor = whiteColor
                sender.layer.borderWidth = 1.5
                
                
                //remove label from array
                if let indexValue = arraySavedSelection.index(of: (sender.titleLabel?.text)!) {
                    arraySavedSelection.remove(at: indexValue)
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
            let now = Date()
            var strGoal = String()
            
            let context = appDelegate.persistentContainer.viewContext
            let dataHelper = DataHelper(context: context)
            
            let title = form.txtName.text
            let entry = form.txtAbout.text
            
            let newGoal = NSEntityDescription.insertNewObject(forEntityName: "Goals", into: appDelegate.persistentContainer.viewContext) as! Goals
            let newRelation = NSEntityDescription.insertNewObject(forEntityName: "GoalKeywords", into: appDelegate.persistentContainer.viewContext) as! GoalKeywords
            
            let keywords : [Keywords] = dataHelper.getAll()
            
            // created formatter
            
            let formatterFull = DateFormatter()
            formatterFull.dateFormat = "yyyy-MM-dd HH:mm:ss +0000"
            formatterFull.locale = Locale(identifier: "en_GB")
            let strNow = formatterFull.string(from: now)
            
            
            if(txtFieldDate.text!.isEmpty){
                strGoal = ""
            }
            else{
                strGoal = txtFieldDate.text!
            }
            
            
            newGoal.title = title!
            newGoal.note = entry!
            newGoal.created = strNow
            newGoal.deadline = strGoal
            newGoal.accomplished = false
            //newGoal.evaluation = Evaluation()
            
            // dataHelper.saveChanges()
            
            print("\(String(describing: arraySavedSelection))")
            
            //let savedEntry = dataHelper.getEntryById(id: newEntry.objectID)
            
            
            
            do {
                
                try context.save()
                print("Saved relation: \(String(describing: newGoal)) successfully!")
                
                for (_, element) in arraySavedSelection.enumerated() {
                    
                    let i = keywords.index(where: { $0.title == element }) as! Int
                    
                    let keywordObject = dataHelper.getById(id: keywords[i].objectID)
                    
                    //let newRelation = dataHelper.createSeverity(keyword: keywordObject!, entry: savedEntry!, severity: sliderValue)
                    
                    newRelation.keyword = keywordObject!
                    newRelation.goal = newGoal
                    newRelation.rate = 0
                    
                    //dataHelper.saveChanges()
                    
                    
                    do {
                        
                        try context.save()
                        print("Saved relation: \(String(describing: newRelation)) successfully!")
                        
                        
                    } catch {
                        print("Failed saving")
                    }
                    
                    
                }
                
                
                
            } catch {
                print("Failed saving")
            }
            
            
        }
    
    func updateData() {
        
        let title = form.txtName.text
        let txtGoal = form.txtAbout.text
        var strSaveGoal = String()
        
        let formatterFull = DateFormatter()
        formatterFull.dateFormat = "yyyy-MM-dd HH:mm:ss +0000"
        formatterFull.locale = Locale(identifier: "en_GB")
        
        let context = appDelegate.persistentContainer.viewContext
        
        let dataHelper = DataHelper(context: context)
        let keywords : [Keywords] = dataHelper.getAll()

        let goalFetchRequest = NSFetchRequest<Goals>(entityName: "Goals")
        let fetchRequestRelation = NSFetchRequest<GoalKeywords>(entityName: "GoalKeywords")
        
        
        let allGoals = try! context.fetch(goalFetchRequest)
        
        for goal in allGoals {
            
            
            let goalCr = goal.created
            
            if(goalCr == goalToEdit){
                
                
                if(txtFieldDate.text!.isEmpty){
                    strSaveGoal = ""
                }
                else{
                    strSaveGoal = txtFieldDate.text!
                }
                
                goal.title = title!
                goal.note = txtGoal!
                goal.deadline = strSaveGoal
                
                let predicateRelation = NSPredicate(format: "goal == %@", goal)
                fetchRequestRelation.predicate = predicateRelation
                
                let manyRelations = try! context.fetch(fetchRequestRelation)
                for manyRelation in manyRelations {
                    
                    print("deleted : \(String(describing: manyRelation))")
                    context.delete(manyRelation)
                    
                    do {
                        try context.save()
                    } catch {
                        print("Failed saving \(manyRelation)")
                    }
                }
                
                do {
                    
                    try context.save()
                    print("array selection: \(arraySavedSelection)")
                    for (_, element) in arraySavedSelection.enumerated() {
                        
                        let newRelation = NSEntityDescription.insertNewObject(forEntityName: "GoalKeywords", into: appDelegate.persistentContainer.viewContext) as! GoalKeywords
                        
                        let i = keywords.index(where: { $0.title == element }) as! Int
                        let keywordObject = dataHelper.getById(id: keywords[i].objectID)
                        
                        newRelation.keyword = keywordObject!
                        newRelation.goal = goal
                        newRelation.rate = 0
                        
                        
                        do {
                            
                            try context.save()
                            print("Saved relation: \(String(describing: newRelation)) successfully!")
                            
                            
                        } catch {
                            print("Failed saving")
                        }
                        
                        
                    }
                    
                    print("updated \(String(describing: goal)) successfully")
                    
                } catch {
                    print("Failed saving")
                }
                
                
            }
            
            
        }
        
        
        
    }
    
    
    
    func getData() {
        
        let formatterFull = DateFormatter()
        formatterFull.dateFormat = "yyyy-MM-dd HH:mm:ss +0000"
        formatterFull.locale = Locale(identifier: "en_GB")
        
        let formatterDate = DateFormatter()
        formatterDate.dateFormat = "dd-MM-yyyy"
        formatterDate.locale = Locale(identifier: "en_GB")
        
        //fetch data from custom added keywords and return them as an array
        let context = appDelegate.persistentContainer.viewContext
        let keywordFetchRequest = NSFetchRequest<Keywords>(entityName: "Keywords")
        let goalFetchRequest = NSFetchRequest<Goals>(entityName: "Goals")
        let fetchRequestRelation = NSFetchRequest<GoalKeywords>(entityName: "GoalKeywords")
        
        //let predicateRelation = NSPredicate(format: "date == %@", entryToEdit)
        //entryFetchRequest.predicate = predicateRelation
        
        let allGoals = try! context.fetch(goalFetchRequest)
        
        for goal in allGoals {
            
            
            let goalDate = goal.created
            
            if(goalDate == goalToEdit){
                
                let predicateRelation = NSPredicate(format: "goal == %@", goal)
                fetchRequestRelation.predicate = predicateRelation
                
                let manyRelations = try! context.fetch(fetchRequestRelation)
                
                for manyRelation in manyRelations {
                    
                    
                    let strKeywordID = manyRelation.keyword.objectID
                    let predicateKeywords = NSPredicate(format: "SELF = %@", strKeywordID)
                    keywordFetchRequest.predicate = predicateKeywords
                    
                    let relatedKeywords = try! context.fetch(keywordFetchRequest)
                    
                    for keyword in relatedKeywords {
                        
                        
                        arrayGetRateValues.append(manyRelation.rate)
                        arraySavedSelection.append(keyword.title as String)

                        form.txtName.text = goal.title
                        form.txtAbout.text = goal.note
                        
                        if(goal.deadline.isEmpty){
                            boolDeadline = false

                        }
                        else {
                            boolDeadline = true
                            let dateFormat = formatterDate.date(from: goal.deadline)
                            dateDeadline = dateFormat!
                       
                        }
                        
                        
                        
                    }
                    
                    
                }
                
                
            }
            
            
        }
        
    }
    
        
        func getDataKeywords() {
            
            //fetch data from custom added keywords and return them as an array
            let context = appDelegate.persistentContainer.viewContext
            let keywordFetchRequest = NSFetchRequest<Keywords>(entityName: "Keywords")
            // let primarySortDescriptor = NSSortDescriptor(key: "title", ascending: true)
            
            //keywordFetchRequest.sortDescriptors = [primarySortDescriptor]
            let allKeywords = try! context.fetch(keywordFetchRequest)
            
            for key in allKeywords {
                
                let rank = key.ranking
                if(rank != 0){
                    
                    arrayUserKeywords.append(key.title as String)
                    
                }
                
                
            }
        }
        
        
        
        
        // MARK: alerts
        
        func showAlertQuit() {
            
            let refreshAlert = UIAlertController(title: "Go back to your goals", message: "Are you sure you want to quit editing your goals? Your data will be lost", preferredStyle: UIAlertControllerStyle.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Quit", style: .default, handler: { (action: UIAlertAction!) in
                self.popBack()
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Nevermind", style: .cancel, handler: { (action: UIAlertAction!) in
                
            }))
            
            present(refreshAlert, animated: true, completion: nil)
        }
        
        func showAlertFormCheck() {
            
            let refreshAlert = UIAlertController(title: "Empty fields", message: "To add a goal, you must fill in a title.", preferredStyle: UIAlertControllerStyle.alert)
            
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
            
            let title = form.txtName.text
            
            if(title?.isEmpty)!{
                
                showAlertFormCheck()
                
            }
                
            else {
                
                updateData()
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
            // text hasn't changed yet, you have to compute the text AFTER the edit yourself
            let updatedStringTitle = (self.form.txtName.text as NSString?)?.replacingCharacters(in: range, with: string)
            self.form.txtName.text = updatedStringTitle
            
            let updatedStringDescr = (self.form.txtAbout.text as NSString?)?.replacingCharacters(in: range, with: string)
            self.form.txtAbout.text = updatedStringDescr
            // do whatever you need with this updated string (your code)
            
            // always return true so that changes propagate
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
