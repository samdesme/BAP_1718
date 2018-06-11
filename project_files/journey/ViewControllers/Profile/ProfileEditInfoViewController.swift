//
//  ProfileEditInfoViewController.swift
//  journey
//
//  Created by sam de smedt on 24/04/2018.
//  Copyright © 2018 sam de smedt. All rights reserved.
//

import UIKit
import CoreData

class ProfileEditInfoViewController: UIViewController, CreateStep1Delegate {
    
    //OUTLET REFERENTIONS

    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var backButtonItem: UINavigationItem!
    
    //VARIABLES
    
    //strings
    let strHeaderCreate1 = "Edit general info"
    let strHeader = "profile"
    let strLblName = "What's your name?"
    let strLblAbout = "Describe yourself in a few words"
    
    
    //view
    let editInfo = Bundle.main.loadNibNamed("CreateStep1", owner: nil, options: nil)?.first as! CreateStep1
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    
    //database
    
    //labels
    let lblSub = UILabel()
    let lblMain = UILabel()
    let rect = CGRect()
    
    //gradient layers
    let  btnGradientLayer = CAGradientLayer()
    
    //Load view controller
    override func viewDidLoad() {
        super.viewDidLoad()
        viewCreate1()
        createForm()
        
    }
    
    func viewCreate1() {
        self.view.backgroundColor = whiteColor
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    func createForm() {
        let navBar = navigationController?.navigationBar

        //create form view
        editInfo.frame = CGRect(x: 0, y: (navBar?.frame.size.height)! + 50, width: self.view.frame.width, height: (self.view.frame.height/2))
        editInfo.backgroundColor = whiteColor
        
        // UILabels
        editInfo.lblName.font = fontLabel
        editInfo.lblName.text = strLblName
        editInfo.lblName.textColor = blackColor
        editInfo.lblName.textAlignment = .left
        
        editInfo.lblAbout.font = fontLabel
        editInfo.lblAbout.text = strLblAbout
        editInfo.lblAbout.textColor = blackColor
        editInfo.lblAbout.textAlignment = .left
        
        //UITextView
        editInfo.txtName.layer.cornerRadius = 5
        editInfo.txtName.layer.borderColor = UIColor.gray.withAlphaComponent(0.4).cgColor
        editInfo.txtName.layer.borderWidth = 1
        editInfo.txtName.font = fontInput
        editInfo.txtName.clipsToBounds = true
        
        //UITextfield
        editInfo.txtAbout.layer.cornerRadius = 5
        editInfo.txtAbout.layer.borderColor = UIColor.gray.withAlphaComponent(0.4).cgColor
        editInfo.txtAbout.layer.borderWidth = 1
        editInfo.txtAbout.font = fontInput
        editInfo.txtAbout.clipsToBounds = true
        
        // UIButton
        editInfo.btnNextShadow.isHidden = true
        editInfo.btnToStep2.isHidden = true
       
        
        // add gradient to button
        btnGradientLayer.frame = CGRect(x: 0, y: 0, width: 240, height: 50)
        btnGradientLayer.colors = [purpleColor.cgColor, lightPurpleColor.cgColor]
        btnGradientLayer.locations = [ 0.0, 1.0]
        btnGradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        btnGradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        
        //drop shadow
        btnGradientLayer.shadowOpacity = 0.10
        btnGradientLayer.shadowRadius = 7.0
        btnGradientLayer.shadowOffset = CGSize(width: 0.0, height: 7.0)
        
        //corner radius
        btnGradientLayer.cornerRadius = 25
        
        //add layer with gradient & drop shadow to button
        editInfo.btnToStep2.layer.insertSublayer(btnGradientLayer, at: 0)
        
        //add view to content view
        self.view.addSubview(editInfo)
        
        
    }
    
   
    
    func createHeaderSub() {
        
        //variables
        let navBar = navigationController?.navigationBar
        let frameTitle = CGRect(x: 0, y: 0, width: (navBar?.frame.width)!, height: (navBar?.frame.height)!)
        lblSub.frame = frameTitle
        
        //Create navigation bar for sub views
        navBar?.barStyle = .blackTranslucent
        navBar?.applyNavigationGradient(colors: [blueColor , lightBlueColorHeader])
        lblSub.text = strHeaderCreate1.uppercased()
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
        showAlertQuit()
    }
    
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        let updatedStringName = (self.editInfo.txtName.text as NSString?)?.replacingCharacters(in: range, with: string)
        self.editInfo.txtName.text = updatedStringName
        
        let updatedStringAbout = (self.editInfo.txtAbout.text as NSString?)?.replacingCharacters(in: range, with: string)
        self.editInfo.txtAbout.text = updatedStringAbout
        
        return true
    }
    
    func popBack() {
        lblSub.removeFromSuperview()
        createHeaderMain()
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    func showAlertQuit() {
        
        let refreshAlert = UIAlertController(title: "Go back to profile", message: "Are you sure you want to quit editing your profile? Your data will be lost", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Quit", style: .default, handler: { (action: UIAlertAction!) in
            self.popBack()
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Nevermind", style: .cancel, handler: { (action: UIAlertAction!) in
            
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    func showAlertFormCheck() {
        
        let refreshAlert = UIAlertController(title: "Empty fields", message: "To save your data, you must fill in both fields.", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    
    func saveData() {
        
        let name = editInfo.txtName.text
        let about = editInfo.txtAbout.text
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Profile", in: context)
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        
        
        
        do {
            
            
            newUser.setValue(name, forKey: "name")
            newUser.setValue(about, forKey: "about")
            try context.save()
            
            
            
            
        } catch {
            print("Failed saving")
        }
        
        
        
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
    
    func getData() -> (name: String, about: String) {
        
        var name = String()
        var about = String()
        
        let context = appDelegate.persistentContainer.viewContext
        let dataHelper = DataHelper(context: context)
        let profiles : [Profile] = dataHelper.getAllProfiles()
        
        
        if (profiles.count != 0){
            
            let firstProfile = dataHelper.getProfileById(id: profiles[0].objectID)!
            
            print("\(String(describing: firstProfile))")
            
            name = firstProfile.name
            about = firstProfile.about
            
        }
        else {
            
            name = ""
            about = ""
            
        }
        
        return (name, about)
    }
    
    func fillTextFields() {
        editInfo.txtName.text = getData().name
        editInfo.txtAbout.text = getData().about
    }
    
    func update() {
        let name = editInfo.txtName.text
        let about = editInfo.txtAbout.text
        
        
        let context = appDelegate.persistentContainer.viewContext
        let dataHelper = DataHelper(context: context)

        
        let profiles : [Profile] = dataHelper.getAllProfiles()
        let updateProfile = dataHelper.getProfileById(id: profiles[0].objectID)
        
        updateProfile?.name = name!
        updateProfile?.about = about!
        
        dataHelper.updateProfile(updatedProfile: updateProfile!)
        dataHelper.saveChanges()
        
    }
    
    // TO MAIN PAGE
    @objc func toMainPage() {
        let name = editInfo.txtName.text
        let about = editInfo.txtAbout.text
        
        if((name?.isEmpty)! || (about?.isEmpty)!){
            
            showAlertFormCheck()
            
        }
            
        else {
            
            update()
            lblSub.removeFromSuperview()
            createHeaderMain()
            let profilevc = storyboard?.instantiateViewController(withIdentifier: "profile") as! ProfileViewController
            self.navigationController?.pushViewController(profilevc, animated: false)
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        createHeaderSub()
        fillTextFields()
   
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}

