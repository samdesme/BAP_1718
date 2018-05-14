//
//  CreateGoalViewController.swift
//  journey
//
//  Created by sam de smedt on 14/05/2018.
//  Copyright © 2018 sam de smedt. All rights reserved.
//

import UIKit
import CoreData

class CreateGoalViewController: UIViewController, CreateStep1Delegate {
    
    //OUTLET REFERENTIONS
    @IBOutlet var viewMain: UIView!
    @IBOutlet weak var backButtonItem: UINavigationItem!
    
    
    //VARIABLES
    
    //strings
    let strHeader = "create a new goal"
    let strLblTitle = "Title"
    
    var value = String()
    
    let strLblDescr = "Add a note (opinional)"
    let strMood = "Rate your overall mood"
    let strDateMsg = "how are you?"
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var arrayUserKeywords = [String]()
    var arraySliderValues = [Int16]()
    var datePicker = UIDatePicker()
    var txtFieldDate = UITextField()
    var arraySelection = [String]()

    
    //view
    let form = Bundle.main.loadNibNamed("CreateStep1", owner: nil, options: nil)?.first as! CreateStep1
    var scrollView = UIScrollView()

    let viewSwitch = UIView()
    var viewKeywords = UIView()


    let viewOptions = UIView()
    var currentDateTime = Date()
    var switchAction = UISwitch()
    
    //labels
    let lblMsg = UILabel()
    let lblDate = UILabel()
    let lblSub = UILabel()
    let lblMain = UILabel()
    var lblDisplay = UILabel()
    var lblDeadline = UILabel()

    //gradient layers
    let  btnGradientLayer = CAGradientLayer()
    
    //Load view controller
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(scrollView)
        
        self.datePicker.datePickerMode = UIDatePickerMode.date
        self.datePicker.locale = Locale(identifier: "en_GB")
        
        let currentDate = Date()
        self.datePicker.minimumDate = currentDate
        self.datePicker.date = currentDate
        
      createView()
        
    }
    
    func createView() {
        let navBar = navigationController?.navigationBar
        self.view.backgroundColor = whiteColor
        
        scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        scrollView.isScrollEnabled = true
        //scrollView.backgroundColor = blueColor.withAlphaComponent(0.2)
        
        createForm()
        setUpSwitch()
        setUpButtons()
        
        let bottom = (navBar?.frame.size.height)! + form.frame.size.height + viewSwitch.frame.size.height + viewSwitch.frame.size.height + viewKeywords.frame.size.height + 15
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

        viewSwitch.frame = CGRect(x: 15, y: self.view.frame.height/3, width: self.view.frame.width - 30, height: 50)

        lblSwitch.frame = CGRect(x: 0, y: 0, width: viewSwitch.frame.size.width/2, height: 20)
        lblSwitch.text = "Add deadline?"
        lblSwitch.textAlignment = .left
        lblSwitch.font = fontLabel
        lblSwitch.textColor = blackColor
        
        switchAction.frame = CGRect(x: viewSwitch.frame.size.width - 50, y: 0, width: 50, height: 20)
        switchAction.setOn(false, animated:true)
        switchAction.addTarget(self, action: #selector(buttonClicked), for: .valueChanged)
        
        txtFieldDate.frame = CGRect(x: 0, y: lblSwitch.frame.height + 20, width: viewSwitch.frame.size.width, height: 50)
        txtFieldDate.inputView = self.datePicker
        txtFieldDate.textAlignment = .right
        txtFieldDate.isUserInteractionEnabled = true
        txtFieldDate.addTarget(self, action: #selector(textFieldDidBeginEditing), for: .touchUpInside);
        txtFieldDate.isHidden = true
        txtFieldDate.font = fontMainRegular19
        txtFieldDate.textColor = blackColor
        
        txtFieldDate.layer.cornerRadius = 5
        txtFieldDate.layer.borderColor = UIColor.gray.withAlphaComponent(0.4).cgColor
        txtFieldDate.layer.borderWidth = 1
        
        lblDeadline.frame = CGRect(x: 0, y: lblSwitch.frame.height + 20, width: viewSwitch.frame.size.width/2, height: 50)
        lblDeadline.backgroundColor = UIColor.clear
        lblDeadline.text = "Deadline: "
        lblDeadline.textAlignment = .left
        lblDeadline.font = fontMainRegular19
        lblDeadline.textColor = blackColor
 
        
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
        
        viewSwitch.addSubview(lblSwitch)
        viewSwitch.addSubview(txtFieldDate)
        viewSwitch.addSubview(switchAction)
        viewSwitch.addSubview(lblDeadline)
        scrollView.addSubview(viewSwitch)
    }
    
    @objc func doneClick(sender: UITextField){
        txtFieldDate.resignFirstResponder()

    }
    
    @objc func textFieldDidBeginEditing(textField: UITextField) {
        textField.backgroundColor = lightGreyColor.withAlphaComponent(0.5)
    }
    
    @objc func buttonClicked(sender: UIButton) {
        if switchAction.isOn {
            
            print("Switch is on")
            switchAction.setOn(false, animated:true)
            txtFieldDate.isHidden = true

            

            
        } else {
            switchAction.setOn(true, animated:true)
            txtFieldDate.isHidden = false


        }
    }
    
 
    
    @objc func datePickerValueChanged(datePicker: UIDatePicker) {
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd"
        dateformatter.locale = Locale(identifier: "en_GB")
        
        let dateGoals = dateformatter.string(from: datePicker.date)

        txtFieldDate.text = dateGoals
        
    }
    
    func setUpButtons() {
        let lblKeywords = UILabel()
        
        getData()
        
        
        viewKeywords.frame = CGRect(x: 15, y: 100 + self.view.frame.height/3, width: self.view.frame.width - 30, height: 0)
        
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
            
            viewKeywords.addSubview(btnKeyword)


            
        }
        viewKeywords.frame.size.height = buttonY + 80
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
            arraySelection.append((sender.titleLabel?.text)!)
            
            
        }
            
        else {
            
            print(sender.isSelected)
            
            //styling when deselected
            sender.setTitleColor(blackColor, for: .normal)
            sender.titleLabel?.font = fontBtnKeyword
            sender.backgroundColor = whiteColor
            sender.layer.borderWidth = 1.5
            
            
            //remove label from array
            if let indexValue = arraySelection.index(of: (sender.titleLabel?.text)!) {
                arraySelection.remove(at: indexValue)
            }
        }
        
        
    }
   
 
    
    func getSliderValues() {
        let tagCount = arrayUserKeywords.count + 100
        for i in 101...tagCount {
            
            /*
            
            if let slider = viewSliders.viewWithTag(i) as? UISlider {
                let value = Int(round(slider.value))
                arraySliderValues.append(Int16(value))
                print("\(Decimal(value))")
            }
             */
            
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
        let dataHelper = DataHelper(context: context)
        
        let title = form.txtName.text
        let entry = form.txtAbout.text
        
        let newEntry = NSEntityDescription.insertNewObject(forEntityName: "Entries", into: appDelegate.persistentContainer.viewContext) as! Entries
        
        // let newSeverity = NSEntityDescription.insertNewObject(forEntityName: "EntryKeyword", into: appDelegate.persistentContainer.viewContext) as! EntryKeyword
        
        let keywords : [Keywords] = dataHelper.getAll()
        
        newEntry.title = title!
        newEntry.entry = entry!
        newEntry.edited = false
        newEntry.date = currentDateTime
        
        dataHelper.saveChanges()
        
        getSliderValues()
        print("\(String(describing: arraySliderValues))")
        
        let savedEntry = dataHelper.getEntryById(id: newEntry.objectID)
        
        print("saved ENTRY: ")
        print("\(String(describing: savedEntry))")
        
        
        for (index, element) in arrayUserKeywords.enumerated() {
            
            let i = keywords.index(where: { $0.title == element }) as! Int
            let keywordObject = dataHelper.getById(id: keywords[i].objectID)
            let sliderValue = arraySliderValues[index]
            
            let newRelation = dataHelper.createSeverity(keyword: keywordObject!, entry: savedEntry!, severity: sliderValue)
            dataHelper.saveChanges()
            
            print("new MANY to MANY relation: ")
            print("\(String(describing: newRelation))")
            
            
            
            
        }
        
        do {
            
            try context.save()
            print("Saved successfully")
            
            
            
        } catch {
            print("Failed saving")
        }
        
        
    }
    
    func getData() {
        
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
        
        let name = form.txtName.text
        let about = form.txtAbout.text
        
        if((name?.isEmpty)! || (about?.isEmpty)!){
            
            showAlertFormCheck()
            
        }
            
        else {
            
            saveData()
            lblSub.removeFromSuperview()
            createHeaderMain()
            self.tabBarController?.tabBar.alpha = 1
            
            //let entriesvc = storyboard?.instantiateViewController(withIdentifier: "tabbar") as! JournalTabBarController
            //entriesvc.tabBarController?.selectedIndex = 1
            //self.navigationController?.pushViewController(entriesvc, animated: true)
            
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


