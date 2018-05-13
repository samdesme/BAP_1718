//
//  createEntryViewController.swift
//  journey
//
//  Created by sam de smedt on 04/05/2018.
//  Copyright © 2018 sam de smedt. All rights reserved.
//

import UIKit
import CoreData

class CreateEntryViewController: UIViewController, CreateStep1Delegate {
    
    //OUTLET REFERENTIONS
    @IBOutlet var viewMain: UIView!
    @IBOutlet weak var backButtonItem: UINavigationItem!
    
    //VARIABLES
    
    //strings
    let strHeader = "create new entry"
    let strLblTitle = "Title"
    
    var value = String()

    let strLblDescr = "Describe your entry"
    let strSeverity = "Rate the severity of your mental issues in this situation (optional)"
    let strMood = "Rate your overall mood"
    let strDateMsg = "how are you?"

    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var arrayUserKeywords = [String]()
    var arraySliderValues = [Int16]()

    
    @IBOutlet var myRadioYesButton:DownStateButton?
    @IBOutlet var myRadioNoButton:DownStateButton?
    
    //view
    let viewDateMsg = UIView()
    let form = Bundle.main.loadNibNamed("CreateStep1", owner: nil, options: nil)?.first as! CreateStep1
    let viewSliders = UIView()
    let viewOptions = UIView()
    var scrollView = UIScrollView()
    
    var currentDateTime = Date()

    //database
    var moodInt : Int16 = 0

    
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
        setUpDateMsg()
        createForm()
        setUpSliders()
        setUpMoods()
        
    }
    
    func createView() {
        self.view.backgroundColor = whiteColor
        scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        scrollView.isScrollEnabled = true
        
    }
    
    // MARK: layout functions
    func setUpDateMsg() {
    
        
        viewDateMsg.frame = CGRect(x: 15, y: 0, width: self.view.frame.size.width - 30, height: 120)
        viewDateMsg.backgroundColor = whiteColor
        
        lblMsg.frame = CGRect(x: 0, y: 40, width: viewDateMsg.frame.size.width, height: 30)
        lblMsg.text = strDateMsg.uppercased()
        lblMsg.font = fontTitleBig
        lblMsg.textAlignment = .center
        viewDateMsg.addSubview(lblMsg)
        
        let date = Date()
        currentDateTime = date
        let formatter = DateFormatter()
        formatter.dateFormat = "E, MMMM d, HH:mm"
        formatter.locale = Locale(identifier: "en_GB")
        let strNow = formatter.string(from: currentDateTime)
        
        lblDate.frame = CGRect(x: 0, y: 40 + 30 + 5, width: viewDateMsg.frame.size.width, height: 25)
        lblDate.text = strNow
        lblDate.textColor = blackColor.withAlphaComponent(0.5)
        lblDate.font = fontMainLight
        lblDate.textAlignment = .center
        viewDateMsg.addSubview(lblDate)
        
        scrollView.addSubview(viewDateMsg)
    }
    
    func createForm() {
        
        //create form view
        form.frame = CGRect(x: 0, y: 120, width: self.view.frame.width, height: (self.view.frame.height/3))
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
    
    func setUpSliders() {
        let lblSliders = UILabel()
        
        getData()
        
        let count = Int(arrayUserKeywords.count)
        let viewHeight = 80 + (60 * count)
        
        viewSliders.frame = CGRect(x: 15, y: 120 + self.view.frame.height/3, width: self.view.frame.width - 30, height: CGFloat(viewHeight))
        //viewSliders.backgroundColor = blueColor.withAlphaComponent(0.2)
        
        lblSliders.frame = CGRect(x: 0, y: 0, width: viewSliders.frame.width, height: 80)
        lblSliders.font = fontLabel
        lblSliders.textColor = blackColor
        lblSliders.textAlignment = .left
        lblSliders.text = strSeverity
        lblSliders.numberOfLines = 0
        
        viewSliders.addSubview(lblSliders)
        
        var yTitle = 0
        var ySlider = 20
        var tag = 1
        
        for keyword in arrayUserKeywords {
        
         let lblTitle = UILabel()
         let lbltag = UILabel()

         lblDisplay = lbltag

         let keywordSlider = UISlider()
            
        lblTitle.frame = CGRect(x: 0, y: 80 + yTitle, width: Int(viewSliders.frame.size.width), height: 20)
        lblTitle.text = "\(keyword)"
        lblTitle.textAlignment = .right
        lblTitle.font = fontInput
        lblTitle.textColor = blackColor
        //lblTitle.backgroundColor = lightGreyColor.withAlphaComponent(0.5)
            
        lblDisplay.frame = CGRect(x: 0, y: 80 + ySlider, width: 60, height: 50)
        lblDisplay.text = "0"
        lblDisplay.textAlignment = .center
        lblDisplay.font = fontMainRegular20
        lblDisplay.tag = tag
        lblDisplay.textColor = blueColor
        
        keywordSlider.frame = CGRect(x: 60, y: 80 + ySlider, width: Int(viewSliders.frame.size.width - 60), height: 40)
        keywordSlider.minimumValue = 0
        keywordSlider.maximumValue = 100
        keywordSlider.tag = 100 + tag
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
    
    func setUpMoods() {
        
        let lblMoodRate = UILabel()
        var x = 0

        let y = 120 + self.view.frame.height/3 + viewSliders.frame.size.height + 30
        
        viewOptions.frame =  CGRect(x: 15, y: y, width: self.view.frame.width - 30, height: 80)
        let columnWidth = (viewOptions.frame.width - 60*5)/4

        lblMoodRate.frame = CGRect(x: 0, y: 0, width: viewOptions.frame.width, height: 20)
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
            btnMood.frame =  CGRect(x: x, y: 30, width: 60, height: 60)
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
        print("\(String(describing: arraySliderValues))")

        
    }
    
    func getSliderValues() {
        let tagCount = arrayUserKeywords.count + 100
        for i in 101...tagCount {
            
                if let slider = viewSliders.viewWithTag(i) as? UISlider {
                    let value = Int(round(slider.value))
                    arraySliderValues.append(Int16(value))
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
                    theLabel.text = String(value)
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
        let dataHelper = DataHelper(context: context)
        
        let title = form.txtName.text
        let entry = form.txtAbout.text
        
        let newEntry = NSEntityDescription.insertNewObject(forEntityName: "Entries", into: appDelegate.persistentContainer.viewContext) as! Entries
        
       // let newSeverity = NSEntityDescription.insertNewObject(forEntityName: "EntryKeyword", into: appDelegate.persistentContainer.viewContext) as! EntryKeyword
        
        let keywords : [Keywords] = dataHelper.getAll()
        
        newEntry.title = title!
        newEntry.entry = entry!
        newEntry.mood = moodInt
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
        
        if((name?.isEmpty)! || (about?.isEmpty)! || moodInt == 0){
            
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

