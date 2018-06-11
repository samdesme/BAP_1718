//
//  ProfileCreate3ViewController.swift
//  journey
//
//  Created by sam de smedt on 13/04/2018.
//  Copyright © 2018 sam de smedt. All rights reserved.
//

import UIKit
import CoreData


class ProfileCreate3ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    
    
    //OUTLET REFERENTIONS
    
    @IBOutlet var viewMain: UIView!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var viewHeader: UIView!
    
    //VARIABLES
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    //strings
    let strHeaderCreate3 = "rank your selection"
    let strLblMain = "Rank your selection from most to less severe"
    let strLblSub = "Drag and drop to rank the keywords"
    
    //arrays
    var arraySelection = [String]()
     var arrayKeywords = [String]()
 
    //view
    let create3 = Bundle.main.loadNibNamed("CreateStep2", owner: nil, options: nil)?.first as! CreateStep2
    
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
        viewCreate3()
        setupPageControl()
    
        
    }
    
    
    func viewCreate3() {
        let navBar = navigationController?.navigationBar

        //let btnFinish = create3.btnToStep3
        self.tabBarController?.tabBar.isHidden = true
        create3.btnToStep3.isHidden = true
        create3.btnNextShadow.isHidden = true
        create3.btnAddKeyword.isHidden = true
        //create form view
        create3.frame = CGRect(x: 0, y: (navBar?.frame.size.height)! + 50, width: self.view.frame.width, height: viewContent.frame.height)
        create3.backgroundColor = whiteColor
        
        // UILabels
        create3.lblMain.font = fontLabel
        create3.lblMain.text = strLblMain
        create3.lblMain.textColor = blackColor
        create3.lblMain.textAlignment = .left
        create3.lblMain.numberOfLines = 0
        
        create3.lblSub.font = fontLabelSub
        create3.lblSub.text = strLblSub
        create3.lblSub.textColor = blackColor.withAlphaComponent(0.8)
        create3.lblSub.textAlignment = .left
        
        //add view to content view
        self.view.addSubview(create3)

        //set up selected keywords
        setUpTableView()
    }
    
    // TO DO
    func setUpTableView() {

        let btnFinish = UIButton()
        let btnNextShadow = UIView()
        
        let tableView: UITableView = UITableView(frame: CGRect(x: 15, y: 120, width: self.view.frame.width - 30, height: viewContent.frame.height/2))
        tableView.tableFooterView = UIView()
        create3.scrollView.isHidden = true
        tableView.backgroundColor = UIColor.clear
        tableView.isScrollEnabled = true
        
        tableView.isEditing = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "keywordCell")
        
        create3.addSubview(tableView)
        
        // UIButton
        var y = Int()
         y = arraySelection.count
        
        if(y >= 5){
            y = 5
        }
        
        let bottomTableView = 100  + 65*y
       
        btnNextShadow.clipsToBounds = false
        btnFinish.clipsToBounds = false
        btnNextShadow.backgroundColor = nil
        btnNextShadow.frame = btnFinish.bounds
        btnFinish.frame = CGRect(x: Int((self.view.frame.size.width - 240)/2), y: Int(bottomTableView) + 50, width: 240, height: 50)
        
        // add gradient to button
        btnGradientLayer.frame = CGRect(x: 0, y: 0, width: 240, height: 50)
        btnGradientLayer.colors = [purpleColor.cgColor, lightPurpleColor.cgColor]
        btnGradientLayer.locations = [ 0.0, 1.0]
        btnGradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        btnGradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        
        btnFinish.setTitle("FINISH",for: .normal)
        btnFinish.tintColor = whiteColor
        btnFinish.titleLabel?.font = fontBtnBig
        btnFinish.addTarget(self,action:#selector(buttonFinish),for:.touchUpInside)
        
        //drop shadow
        btnGradientLayer.shadowOpacity = 0.10
        btnGradientLayer.shadowRadius = 7.0
        btnGradientLayer.shadowOffset = CGSize(width: 0.0, height: 7.0)
        
        //corner radius
        btnGradientLayer.cornerRadius = 25
        
        //add layer with gradient & drop shadow to button
        btnFinish.layer.insertSublayer(btnGradientLayer, at: 0)
        create3.addSubview(btnNextShadow)
        create3.addSubview(btnFinish)
        
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
        //let ySize = (cell.frame.size.height - size.height)/2
        
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
    
    //Button Action is
    @objc func buttonFinish(sender:UIButton!)
    {
        //showAlertRanking()
        saveData()
    }
    
    func saveData() {
        
        let context = appDelegate.persistentContainer.viewContext
        let dataHelper = DataHelper(context: context)
        let newProfile = NSEntityDescription.insertNewObject(forEntityName: "Profile", into: appDelegate.persistentContainer.viewContext) as! Profile
        let keywords : [Keywords] = dataHelper.getAll()
        
        newProfile.name = strNamePassed
        newProfile.about = strAboutPassed
        newProfile.id = 1
        
        dataHelper.saveChanges()
        
        print("NEW PROFILE: ")
        print("\(String(describing: newProfile))")
        
        let profiles : [Profile] = dataHelper.getAllProfiles()
        let updateProfile = dataHelper.getProfileById(id: profiles[0].objectID)
        
        print("TO UPDATE PROFILE: ")
        print("\(String(describing: updateProfile))")
        
        for (index, element ) in arraySelection.enumerated() {
            
            let i = keywords.index(where: { $0.title == element }) as! Int
            let toBeUpdated = dataHelper.getById(id: keywords[i].objectID)
            
            toBeUpdated?.ranking = Int16(index+1)
            toBeUpdated?.profile = updateProfile!
            
            dataHelper.update(updatedKeyword: toBeUpdated!)
            
        }
    
        
        do {
        
            printKeywords()
            try context.save()
            print("Saved successfully")
            lblSubHeader.removeFromSuperview()
            createHeaderMain()
            let profilevc = storyboard?.instantiateViewController(withIdentifier: "profile") as! ProfileViewController
            self.navigationController?.pushViewController(profilevc, animated: true)
            
            
            
        } catch {
            print("Failed saving")
        }
        
        
    }
    
   
    
    func printKeywords() {
        let context = appDelegate.persistentContainer.viewContext
        let dataHelper = DataHelper(context: context)
        let keywords : [Keywords] = dataHelper.getAll()
    
        let i = keywords.index(where: { $0.ranking == 2}) as! Int
        let showRelation = dataHelper.getById(id: keywords[i].objectID)
        
        print("\(String(describing: showRelation))")
        
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
    
    private func setupPageControl() {
        pageControl.currentPage = 2
        pageControl.numberOfPages = 3
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = purpleColor
        pageControl.pageIndicatorTintColor = purpleColor.withAlphaComponent(0.5)
        pageControl.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        
        self.view.insertSubview(pageControl, at: 0)
        self.view.bringSubview(toFront: pageControl)
        
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        let _ = self.navigationController?.popViewController(animated: false)
        lblSubHeader.removeFromSuperview()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        createHeaderSub()
        
    }
    
    
    // ALERTS
    // -----------------------
    
    func showAlertRanking() {
        let stringRepresentation = arraySelection.joined(separator: ",")
        
        let refreshAlert = UIAlertController(title: "Passed data", message: stringRepresentation, preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            print("Handle Ok logic here")
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    
    func showAlert() {
        
        let refreshAlert = UIAlertController(title: "Passed data", message: " ", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            print("Handle Ok logic here")
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    // END ALERTS
    // -----------------------
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}

