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
    let strSeverity = "Rate the severity of your mental issues in this situation (opinional)"
    let strMood = "Rate your overall mood"
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var arrayUserKeywords = [String]()
    
    @IBOutlet var myRadioYesButton:DownStateButton?
    @IBOutlet var myRadioNoButton:DownStateButton?
    
    //view
    let form = Bundle.main.loadNibNamed("CreateStep1", owner: nil, options: nil)?.first as! CreateStep1
    let viewSliders = UIView()
    let viewOptions = UIView()
    var scrollView = UIScrollView()

    //database
    var moodInt = Int16()

    
    //labels
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
        createForm()
        setUpSliders()
        setUpMoods()
    }
    
    func createView() {
        self.view.backgroundColor = whiteColor
        
    }
    
    // MARK: layout functions
    
    func createForm() {
        
        scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        scrollView.isScrollEnabled = true
        //scrollView.backgroundColor = blueColor.withAlphaComponent(0.2)

        
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
    
    func setUpSliders() {
        let lblSliders = UILabel()
        
        getData()
        
        let count = Int(arrayUserKeywords.count)
        let viewHeight = 80 + (60 * count)
        
        viewSliders.frame = CGRect(x: 15, y: self.view.frame.height/3, width: self.view.frame.width - 30, height: CGFloat(viewHeight))
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
        var tag = 0
        
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
        keywordSlider.tag = tag
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

        let y = self.view.frame.height/3 + viewSliders.frame.size.height + 30
        
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
        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: form.frame.size.height + viewSliders.frame.size.height + viewOptions.frame.size.height + 50)

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
            
        else {
            
            if (sender.tag == 1111){
                let img = UIImage(named: "ic_mood1_outline")
                sender.setBackgroundImage(img, for: .normal)
            }
            else if (sender.tag == 1112) {
                let img = UIImage(named: "ic_mood2_outline")
                sender.setBackgroundImage(img, for: .normal)
            }
            else if (sender.tag == 1113) {
                let img = UIImage(named: "ic_mood3_outline")
                sender.setBackgroundImage(img, for: .normal)
            }
            else if (sender.tag == 1114) {
                let img = UIImage(named: "ic_mood4_outline")
                sender.setBackgroundImage(img, for: .normal)
            }
            else if (sender.tag == 1115) {
                let img = UIImage(named: "ic_mood5_outline")
                sender.setBackgroundImage(img, for: .normal)
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
    
    
    @objc func sliderValueDidChange(_ sender:UISlider!)
    {
        
        for i in 1...arrayUserKeywords.count {
            
            if (sender.tag == i){
                
                let value = Int(round(sender.value))
                
                if let theLabel = view.viewWithTag(i) as? UILabel {
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
        
        //1 : Zoeken van keyword id's => in array
        
         let keywords : [Keywords] = dataHelper.getAll()
        
       // let i = keywords.index(where: { $0.title == element }) as! Int
       // let toBeUpdated = dataHelper.getById(id: keywords[i].objectID)

        //2 : MANY TO MANY: EntryKeyword => loop: voor elke keyword een entry
        
         let newSeverity = NSEntityDescription.insertNewObject(forEntityName: "EntryKeyword", into: appDelegate.persistentContainer.viewContext) as! EntryKeyword
        
        print("NEW many to many RELATIONS: ")
        print("\(String(describing: newSeverity))")
        
        //3 : new Entry
        
        let newEntry = NSEntityDescription.insertNewObject(forEntityName: "Entries", into: appDelegate.persistentContainer.viewContext) as! Entries
        
 
        
        newEntry.title = title!
        newEntry.entry = entry!
        newEntry.mood = moodInt
        newEntry.keywords = newSeverity
        
        dataHelper.saveChanges()
        
        print("NEW Entry: ")
        print("\(String(describing: newEntry))")
        
        

        
        
        
        /*for (index, element ) in arraySelection.enumerated() {
            
            let i = keywords.index(where: { $0.title == element }) as! Int
            let toBeUpdated = dataHelper.getById(id: keywords[i].objectID)
            
            toBeUpdated?.ranking = Int16(index+1)
            toBeUpdated?.profile = updateProfile!
            toBeUpdated?.entries = EntryKeyword()
            
            dataHelper.update(updatedKeyword: toBeUpdated!)
            
        }*/
        
        
        do {
            
            //printKeywords()
            try context.save()
            print("Saved successfully")
            lblSub.removeFromSuperview()
            createHeaderMain()
            //let profilevc = storyboard?.instantiateViewController(withIdentifier: "profile") as! ProfileViewController
            //self.navigationController?.pushViewController(profilevc, animated: true)
            
            
            
        } catch {
            print("Failed saving")
        }
        
        
    }
    
    func getData() {
        
        //fetch data from custom added keywords and return them as an array
        let context = appDelegate.persistentContainer.viewContext
        let keywordFetchRequest = NSFetchRequest<Keywords>(entityName: "Keywords")
        let primarySortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        keywordFetchRequest.sortDescriptors = [primarySortDescriptor]
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
            let entriesvc = storyboard?.instantiateViewController(withIdentifier: "entries") as! EntriesViewController
            self.navigationController?.pushViewController(entriesvc, animated: false)
            
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

