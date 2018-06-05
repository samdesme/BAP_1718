//
//  ProfileEditKeyword1ViewController.swift
//  journey
//
//  Created by sam de smedt on 24/04/2018.
//  Copyright © 2018 sam de smedt. All rights reserved.
//

//
//  ProfileCreate3ViewController.swift
//  journey
//
//  Created by sam de smedt on 13/04/2018.
//  Copyright © 2018 sam de smedt. All rights reserved.
//

import UIKit
import CoreData


class ProfileEditKeywords1ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    //OUTLET REFERENTIONS
    @IBOutlet weak var backButtonItem: UINavigationItem!
    @IBOutlet weak var viewContent: UIView!
    
    //VARIABLES
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //strings
    let strHeaderCreate3 = "rank your selection"
    let strLblMain = "Rank your selection from most to less severe"
    let strLblSub = "Drag and drop to rank the keywords"
    let strKeyword2 = "Edit your selection"
    
    //arrays
    var arraySelection = [String]()
    var arrayKeywords = [String]()
    
    //view
    let editKeyword1 = Bundle.main.loadNibNamed("CreateStep2", owner: nil, options: nil)?.first as! CreateStep2
    
    //passed data
    var strNamePassed = ""
    var strAboutPassed = ""
    
    //labels
    let lblMain = UILabel()
    let lblSubHeader = UILabel()
    
    //gradient layers
    let  btnGradientLayer = CAGradientLayer()
    
    //Load view controller
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
      viewCreate3()
      
        
    }
    
    
    func viewCreate3() {
        let navBar = navigationController?.navigationBar

        self.tabBarController?.tabBar.isHidden = true
        editKeyword1.btnToStep3.isHidden = true
        editKeyword1.btnNextShadow.isHidden = true
        editKeyword1.btnAddKeyword.isHidden = true
        editKeyword1.scrollView.isHidden = true
        
        //create form view
        editKeyword1.frame = CGRect(x: 0, y: (navBar?.frame.size.height)! + 50, width: self.view.frame.width, height: self.view.frame.height)
        editKeyword1.backgroundColor = whiteColor
        
        // UILabels
        editKeyword1.lblMain.font = fontLabel
        editKeyword1.lblMain.text = strLblMain
        editKeyword1.lblMain.textColor = blackColor
        editKeyword1.lblMain.textAlignment = .left
        editKeyword1.lblMain.numberOfLines = 0
        
        editKeyword1.lblSub.font = fontLabelSub
        editKeyword1.lblSub.text = strLblSub
        editKeyword1.lblSub.textColor = blackColor.withAlphaComponent(0.8)
        editKeyword1.lblSub.textAlignment = .left
        
        //add view to content view
        self.view.addSubview(editKeyword1)
        
        setUpTableView()
        
    }
    

    func setUpTableView() {
        
        let btnSelection = UIButton()
        let keywordAttr : [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.font : fontLabel!,
            NSAttributedStringKey.foregroundColor : blackColor,
            NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue]
        let attributeString = NSMutableAttributedString(string: strKeyword2,
                                                        attributes: keywordAttr)
        let tableView: UITableView = UITableView(frame: CGRect(x: 15, y: 120, width: self.view.frame.width - 30, height: self.view.frame.height/2))
        
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.clear
        tableView.isScrollEnabled = true
        
        tableView.isEditing = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "keywordCell")
        
        editKeyword1.addSubview(tableView)
        
        // UIButton
        var y = Int()
        y = arraySelection.count
        
        if(y >= 5){
            y = 5
        }
        
        let bottomTableView = 150  + 65*y
        

        btnSelection.frame = CGRect(x: Int((self.view.frame.size.width - 240)/2), y: Int(bottomTableView) + 50, width: 240, height: 50)
        
                    //set up link that navigates to keyword selection
            btnSelection.setAttributedTitle(attributeString, for: .normal)
        btnSelection.titleLabel?.textColor = blackColor
        btnSelection.frame = CGRect(x: Int((self.view.frame.size.width - 240)/2), y: bottomTableView, width: 240, height: 20)
        
        
        btnSelection.addTarget(self,action:#selector(toSelection),
                               for:.touchUpInside)
        
        editKeyword1.addSubview(btnSelection)
    }
    
    func getData() {
        //arraySelection.removeAll()
        if(arraySelection.count == 0){
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
       
        
    }
    
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arraySelection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "keywordCell", for: indexPath)
        
        let keywordTitle = arraySelection[indexPath.row]
        cell.textLabel?.text = keywordTitle
        cell.textLabel?.font = fontBtnKeyword
        cell.textLabel?.textColor = whiteColor
        cell.textLabel?.textAlignment = .center
        
        //for button:
        
        let myString: String = (cell.textLabel?.text)!
        let size: CGSize = myString.size(withAttributes: [NSAttributedStringKey.font: fontBtnKeyword!])
        let titleWidth = CGFloat(size.width)
        
        let btn = CALayer()
        btn.backgroundColor = blueColor.cgColor
        btn.frame = CGRect(x: (self.view.frame.size.width - titleWidth - 30)/2 - 25 , y: 12, width: titleWidth + 30, height: 40)
        btn.cornerRadius = 20
        cell.backgroundView = UIView()
        cell.backgroundView?.layer.insertSublayer(btn, at: 0)
        
        let rank = UILabel()
        rank.frame = CGRect(x: 0, y: 12, width: 40, height: 40)
        rank.text = "\(indexPath.row + 1)"
        rank.textColor = purpleColor
        rank.font = fontBtnKeyword
        rank.textAlignment = .center
        rank.layer.backgroundColor = whiteColor.cgColor
        rank.layer.borderWidth = 2
        rank.layer.borderColor = purpleColor.cgColor
        rank.layer.cornerRadius = 20
        cell.contentView.addSubview(rank)
        
        
        return cell
    }
    
    // MARK: - Reordering
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let movedObject = self.arraySelection[sourceIndexPath.row]
        arraySelection.remove(at: sourceIndexPath.row)
        arraySelection.insert(movedObject, at: destinationIndexPath.row)
        NSLog("%@", "\(sourceIndexPath.row) => \(destinationIndexPath.row) \(arraySelection)")
        
        tableView.reloadData()
        
    }
    
    

    func createHeaderMain() {
        
        //variables
        let navBar = navigationController?.navigationBar
        
        //Edit navigation bar back to main settings
        navBar?.barStyle = .default
        navBar?.applyNavigationGradient(colors: [whiteColor , whiteColor])
        navBar?.addSubview(lblMain)
        
    }
    
    func createHeaderSub() {
        
        //variables
        let navBar = navigationController?.navigationBar
        let frameTitle = CGRect(x: 0, y: 0, width: (navBar?.frame.width)!, height: (navBar?.frame.height)!)
        lblSubHeader.frame = frameTitle
        
        //Create navigation bar for sub views
        navBar?.barStyle = .blackTranslucent
        navBar?.applyNavigationGradient(colors: [blueColor , lightBlueColorHeader])
        lblSubHeader.text = strHeaderCreate3.uppercased()
        lblSubHeader.font = fontHeaderSub
        lblSubHeader.textColor = whiteColor
        lblSubHeader.textAlignment = .center
        
        navBar?.addSubview(lblSubHeader)
        addBackButton()
        addSaveButton()
        
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
    
    func addSaveButton() {
        let NavLinkAttr : [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.font : fontBtnNavLink!,
            NSAttributedStringKey.foregroundColor : whiteColor,
            NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue]
        let attributeString = NSMutableAttributedString(string: "Save",
                                                        attributes: NavLinkAttr)
        
        let btnCreate = UIButton(type: .custom)
        //btnCreate.setTitle("Add", for: .normal)
        //btnCreate.setTitleColor(whiteColor, for: .normal)
        //btnCreate.titleLabel?.font = fontBtnNavLink
        btnCreate.setAttributedTitle(attributeString, for: .normal)
        btnCreate.addTarget(self, action: #selector(buttonFinish), for: .touchUpInside)
        //add btn
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: btnCreate)
    }
    
    // SAVE EDIT
    
    @objc func buttonFinish(sender:UIButton!)
    {
        //showAlertRanking()
        updateData()
    }
    
    func updateData() {
        
        let context = appDelegate.persistentContainer.viewContext
        let dataHelper = DataHelper(context: context)
        let keywords : [Keywords] = dataHelper.getAll()
 
        
        for (index, element ) in arraySelection.enumerated() {
            
            let i = keywords.index(where: { $0.title == element }) as! Int
            let toBeUpdated = dataHelper.getById(id: keywords[i].objectID)
            
            toBeUpdated?.ranking = Int16(index+1)
            
            dataHelper.update(updatedKeyword: toBeUpdated!)
            
        }
        
        
        do {
            
            try context.save()
            print("Saved successfully")
            toMainPage()
            
            
            
        } catch {
            print("Failed saving")
        }
        
        
    }
    
    func popBack() {
        lblSubHeader.removeFromSuperview()
        createHeaderMain()
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    func toMainPage() {
        lblSubHeader.removeFromSuperview()
        createHeaderMain()
        let profilevc = storyboard?.instantiateViewController(withIdentifier: "profile") as! ProfileViewController
        self.navigationController?.pushViewController(profilevc, animated: false)
    }
    
    // TRIGGERED ACTIONS
    
    @objc func toSelection() {
        lblSubHeader.removeFromSuperview()
        let selectionvc = storyboard?.instantiateViewController(withIdentifier: "editKeywordSelection") as! ProfileEditKeywords2ViewController
        selectionvc.arraySelection = arraySelection
        self.navigationController?.pushViewController(selectionvc, animated: true)
    }
    
    // CANCEL EDIT
    @IBAction func backAction(_ sender: UIButton) {
       showAlertQuit()
    }
    
    
    // ALERTS
    
    func showAlertQuit() {
        
        let refreshAlert = UIAlertController(title: "Go back to profile", message: "Are you sure you want to quit editing your profile? Your data will be lost", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Quit", style: .default, handler: { (action: UIAlertAction!) in
            self.popBack()
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Nevermind", style: .cancel, handler: { (action: UIAlertAction!) in
            
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    
    // OVERRIDES
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createHeaderSub()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}


