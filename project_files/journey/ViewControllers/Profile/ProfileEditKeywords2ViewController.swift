//
//  ProfileEditKeywords2ViewController.swift
//  journey
//
//  Created by sam de smedt on 24/04/2018.
//  Copyright © 2018 sam de smedt. All rights reserved.
//


//
//  ProfileCreate2ViewController.swift
//  journey
//
//  Created by sam de smedt on 11/04/2018.
//  Copyright © 2018 sam de smedt. All rights reserved.
//

import UIKit
import CoreData

class ProfileEditKeywords2ViewController: UIViewController, CreateStep2Delegate {
    
    //OUTLET REFERENTIONS
    @IBOutlet weak var backButtonItem: UINavigationItem!
    @IBOutlet weak var viewContent: UIView!
    
    
    //VARIABLES
    //strings
    let strHeaderCreate2 = "choose keywords"
    let strLblMain = "Issues I identify with"
    let strLblSub = "Tab the options below"
    let strNewKeyword = "I don't see my issue here..."
    
    //passed data
    var strNamePassed = ""
    var strAboutPassed = ""
    
    //arrays
    var arraySelection = [String]()
    var arrayKeywords = [String]()
    var arrayCustomKeywords = [String]()
    
    var buttonX: CGFloat = 0
    var buttonY: CGFloat = 10
    
    //view
    let editKeyword2 = Bundle.main.loadNibNamed("CreateStep2", owner: nil, options: nil)?.first as! CreateStep2
    
    
    //labels
    let lblSubHeader = UILabel()
    
    //gradient layers
    let  btnGradientLayer = CAGradientLayer()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    //Load view controller
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewCreate2()
    }
    
    func viewCreate2() {
         let navBar = navigationController?.navigationBar
        
        let keywordAttr : [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.font : fontLabel!,
            NSAttributedStringKey.foregroundColor : blackColor,
            NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue]
        let attributeString = NSMutableAttributedString(string: strNewKeyword,
                                                        attributes: keywordAttr)
        
        self.tabBarController?.tabBar.isHidden = true
        
        //create form view
        editKeyword2.frame = CGRect(x: 0, y: (navBar?.frame.size.height)! + 50, width: self.view.frame.width, height: self.view.frame.height)
        editKeyword2.backgroundColor = whiteColor
        
        // UILabels
        editKeyword2.lblMain.font = fontLabel
        editKeyword2.lblMain.text = strLblMain
        editKeyword2.lblMain.textColor = blackColor
        editKeyword2.lblMain.textAlignment = .left
        
        editKeyword2.lblSub.font = fontLabelSub
        editKeyword2.lblSub.text = strLblSub
        editKeyword2.lblSub.textColor = blackColor.withAlphaComponent(0.8)
        editKeyword2.lblSub.textAlignment = .left
        
        // UIButton
        let bottomScrollView = editKeyword2.lblMain.frame.size.height + editKeyword2.lblSub.frame.size.height + (self.view.frame.height/4)*3
        
        editKeyword2.btnAddKeyword.setAttributedTitle(attributeString, for: .normal)
        editKeyword2.btnAddKeyword.titleLabel?.textColor = blackColor
        editKeyword2.btnAddKeyword.frame = CGRect(x: (self.view.frame.size.width - 240)/2, y: bottomScrollView, width: 240, height: 20)
        
        editKeyword2.btnNextShadow.isHidden = true
        editKeyword2.btnToStep3.isHidden = true
        
        //add view to content view
        self.view.addSubview(editKeyword2)
        
        //add keywords
        setUpKeywords()
        
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
        btnCreate.addTarget(self, action: #selector(toRanking), for: .touchUpInside)
        //add btn
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: btnCreate)
    }
    
    func setUpKeywords() {
        
        
        //get data from arrays
        getData()
        //getSelection()
        
        buttonX = 0
        buttonY = 10
        
        for keyword in arrayKeywords {
            let btnKeyword = UIButton()
            let ySpace: Int = 10
            
            if(!btnKeyword.isDescendant(of: editKeyword2.scrollView)) {
                
                let myString: String = "\(keyword)"
                let size: CGSize = myString.size(withAttributes: [NSAttributedStringKey.font: fontBtnKeyword!])
                let btnWidth = size.width + 20
                let totalWidth = buttonX + btnWidth
                
                if(totalWidth > self.view.frame.size.width - 35){
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
                
                
                if(arraySelection.contains("\(keyword)")){
                    btnKeyword.isSelected = true
                    
                    //styling when selected
                    btnKeyword.setTitleColor(whiteColor, for: .normal)
                    btnKeyword.titleLabel?.font = fontMainMedium
                    btnKeyword.backgroundColor = blueColor
                    btnKeyword.layer.borderWidth = 0
                    
                }
                //add button to keyword view
                editKeyword2.scrollView.addSubview(btnKeyword)
            }
            
            
        }
        
        for custom in arrayCustomKeywords {
            
            let btnKeyword2 = UIButton()
            let btnRemove = UIButton()
            let ySpace: Int = 10
            
            let myString: String = "\(custom)"
            let size: CGSize = myString.size(withAttributes: [NSAttributedStringKey.font: fontBtnKeyword!])
            let btnWidth = size.width + 20 + 40
            let totalWidth = buttonX + btnWidth
            
            if(totalWidth > self.view.frame.size.width - 35){
                buttonY = buttonY + 40 + CGFloat(ySpace)
                buttonX = 0
            }
            
            btnKeyword2.frame = CGRect(x: buttonX, y: buttonY, width: btnWidth, height: 40)
            buttonX = buttonX + btnWidth + 10
            
            btnKeyword2.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 40)
            btnKeyword2.setTitle("\(custom)",for: .normal)
            btnKeyword2.titleLabel?.font = fontBtnKeyword
            btnKeyword2.setTitleColor(blackColor, for: .normal)
            btnKeyword2.titleLabel?.textAlignment = .center
            btnKeyword2.backgroundColor = whiteColor
            btnKeyword2.isSelected = false
            
            btnRemove.frame = CGRect(x: btnWidth - 30 - 10, y: 5, width: 30, height: 30)
            btnRemove.titleLabel?.font = fontMainRegular
            btnRemove.setTitle("X", for: .normal)
            btnRemove.setTitleColor(blackColor, for: .normal)
            btnRemove.layer.cornerRadius = 15
            //btnRemove.layer.borderWidth = 1
            //btnRemove.layer.borderColor = whiteColor.cgColor
            btnRemove.backgroundColor = lightGreyColor
            btnRemove.addTarget(self,action:#selector(deleteData),
                                for:.touchUpInside)
            btnRemove.isSelected = false
            
            btnKeyword2.addTarget(self,action:#selector(selectKeyword),
                                  for:.touchUpInside)
            
            btnKeyword2.isEnabled = true
            btnKeyword2.layer.cornerRadius = 20
            btnKeyword2.layer.borderWidth = 1.5
            btnKeyword2.layer.borderColor = blackColor.cgColor
            
            if(arraySelection.contains("\(custom)")){
                btnKeyword2.isSelected = true
                
                //styling when selected
                btnKeyword2.setTitleColor(whiteColor, for: .normal)
                btnKeyword2.titleLabel?.font = fontMainMedium
                btnKeyword2.backgroundColor = blueColor
                btnKeyword2.layer.borderWidth = 0
                
            }
            
            btnKeyword2.addSubview(btnRemove)
            
            //add button to keyword view
            editKeyword2.scrollView.addSubview(btnKeyword2)
            
        }
        editKeyword2.scrollView.isScrollEnabled = true
        editKeyword2.scrollView.contentSize = CGSize(width: editKeyword2.scrollView.frame.size.width , height: buttonY + 80)
        editKeyword2.scrollView.backgroundColor = UIColor.clear
        editKeyword2.scrollView.frame = CGRect(x: 15, y: 80, width: self.view.frame.width - 30, height: (self.view.frame.height/3)*1.8)
        
        
    }
    
    
    
    func getData() {
        
        let dataHelper = DataHelper(context: appDelegate.managedObjectContext)
        
        
        //fetch data from custom added keywords and return them as an array
        let context = appDelegate.persistentContainer.viewContext
        let keywordFetchRequest = NSFetchRequest<Keywords>(entityName: "Keywords")
        let primarySortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        //empty array before fetching updated data
        arrayCustomKeywords.removeAll()
        arrayKeywords.removeAll()
        
        //first check if the database is empty
        let results:NSArray? = try! context.fetch(keywordFetchRequest) as NSArray
        if(results?.count == 0){
            dataHelper.seedDataStore()
        }
        
        let allKeywords = try! context.fetch(keywordFetchRequest)
        
        keywordFetchRequest.sortDescriptors = [primarySortDescriptor]
        
        for key in allKeywords {
            let bool = key.addedByUser as Bool
            
            if(bool == true){
                
                arrayCustomKeywords.append(key.title as String)
                
            }
            else{
                
                arrayKeywords.append(key.title as String)
                
            }
            
        }
    }
    
    func getSelection() {
        arraySelection.removeAll()
        
        //fetch the user's selected keywords and return them as an array
        let context = appDelegate.persistentContainer.viewContext
        let keywordFetchRequest = NSFetchRequest<Keywords>(entityName: "Keywords")
        let primarySortDescriptor = NSSortDescriptor(key: "ranking", ascending: true)
        
        keywordFetchRequest.sortDescriptors = [primarySortDescriptor]
        
        let allKeywords = try! context.fetch(keywordFetchRequest)
        
        for key in allKeywords {
            let ranking = key.ranking
            
            //append only if the keyword is linked to the profile (all keywords that have a ranking value)
            if(ranking != 0){
                arraySelection.append(key.title as String)
            }
        }
        
    }
    
    @objc func toRanking() {
        lblSubHeader.removeFromSuperview()
        let rankingvc = storyboard?.instantiateViewController(withIdentifier: "editKeywordRange") as! ProfileEditKeywords1ViewController
        print(arraySelection)
        rankingvc.arraySelection = arraySelection
        self.navigationController?.pushViewController(rankingvc, animated: false)
    }
    
    @objc func deleteData(sender: UIButton) {
        let context = appDelegate.persistentContainer.viewContext
        let dataHelper = DataHelper(context: context)
        let keywords : [Keywords] = dataHelper.getAll()
        
        
        //get the superview of the clicked button via sender
        let btn = getCellForView(view: sender)
        
        
        //remove label from array
        if let indexValue = arraySelection.index(of: (btn?.titleLabel?.text)!) {
            arraySelection.remove(at: indexValue)
        }
        
        //if superview if UIButton, get the text of the titlelable of that button
        let title = btn?.titleLabel?.text as String!
        
        //find out the index of the object in [Keywords] that matches that title
        let i = keywords.index(where: { $0.title == title }) as! Int
        let toBeDeleted = dataHelper.getById(id: keywords[i].objectID)
        
        //delete that object
        do {
            
            dataHelper.delete(id: toBeDeleted!.objectID)
            try context.save()
            
            editKeyword2.scrollView.removeSubviews()
            setUpKeywords()
            
            
            
        } catch {
            print("Failed deleting")
        }
        
        
        
    }
    
    
    
    
    func getCellForView(view:UIView) -> UIButton?
    {
        //function to easily get access to superview of UI item
        var superView = view.superview
        
        while superView != nil
        {
            if superView is UIButton
            {
                return superView as? UIButton
            }
            else
            {
                superView = superView?.superview
            }
        }
        
        return nil
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
    
    func addTarget() {
        
        //add btn attributes
        editKeyword2.btnAddKeyword.addTarget(self,action:#selector(toNewKeyword),
                                        for:.touchUpInside)
    }
    
    
    
    
    func addKeyword() {
        
    }
    
    func createHeaderSub() {
        
        //variables
        let navBar = navigationController?.navigationBar
        let frameTitle = CGRect(x: 0, y: 0, width: (navBar?.frame.width)!, height: (navBar?.frame.height)!)
        lblSubHeader.frame = frameTitle
        
        //Create navigation bar for sub views
        navBar?.barStyle = .blackTranslucent
        navBar?.applyNavigationGradient(colors: [blueColor , lightBlueColorHeader])
        lblSubHeader.text = strHeaderCreate2.uppercased()
        lblSubHeader.font = fontHeaderSub
        lblSubHeader.textColor = whiteColor
        lblSubHeader.textAlignment = .center
        
        navBar?.addSubview(lblSubHeader)
        addBackButton()
        addSaveButton()
        
    }
    
    
    
    
    
    func showAlert() {
        
        let refreshAlert = UIAlertController(title: "Passed data", message: "Name:" + strNamePassed + ", About:" + strAboutPassed, preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            print("Handle Ok logic here")
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    func showAlertSelectionCheck() {
        
        let refreshAlert = UIAlertController(title: "Nothing selected", message: "To continue to the next step, you must make a selection.", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            
        }))
        
        present(refreshAlert, animated: true, completion: nil)
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

    
    @IBAction func backAction(_ sender: UIButton) {
        let _ = self.navigationController?.popViewController(animated: false)
        lblSubHeader.removeFromSuperview()
        
    }
    
    
    
    
    func toStep3() {
        
        if(!arraySelection.isEmpty){
            lblSubHeader.removeFromSuperview()
            let vc3 = storyboard?.instantiateViewController(withIdentifier: "step3") as! ProfileCreate3ViewController
            vc3.arraySelection = arraySelection
            vc3.strNamePassed = strNamePassed
            vc3.strAboutPassed = strAboutPassed
            self.navigationController?.pushViewController(vc3, animated: false)
        }
        else {
            showAlertSelectionCheck()
        }
        
    }
    
    // SAVE PROFILE INFO
    @objc func createSelection() {
        
        //saveData()
        toStep3()
        
    }
    
    @objc func toNewKeyword() {
        
        lblSubHeader.removeFromSuperview()
        let vcAdd = storyboard?.instantiateViewController(withIdentifier: "newkeyword") as! ProfileAddKeywordViewController
        vcAdd.strNamePassed = strNamePassed
        vcAdd.strAboutPassed = strAboutPassed
        vcAdd.arraySelection = arraySelection
        self.navigationController?.pushViewController(vcAdd, animated: true)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        createHeaderSub()
        addTarget()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}

