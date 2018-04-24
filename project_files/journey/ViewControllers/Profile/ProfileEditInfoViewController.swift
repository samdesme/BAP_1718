//
//  ProfileEditInfoViewController.swift
//  journey
//
//  Created by sam de smedt on 24/04/2018.
//  Copyright © 2018 sam de smedt. All rights reserved.
//

//
//  ProfileCreate1ViewController.swift
//  journey
//
//  Created by sam de smedt on 02/04/2018.
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
        viewContent.backgroundColor = whiteColor
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    func createForm() {
        
        //create form view
        editInfo.frame = CGRect(x: 0, y: 0, width: viewContent.frame.width, height: (viewContent.frame.height/2))
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
        viewContent.addSubview(editInfo)
        
        
    }
    
    func addTarget() {
        
        //add btn attributes
        editInfo.btnToStep2.addTarget(self,action:#selector(create),
                                     for:.touchUpInside)
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
        // text hasn't changed yet, you have to compute the text AFTER the edit yourself
        let updatedStringName = (self.editInfo.txtName.text as NSString?)?.replacingCharacters(in: range, with: string)
        self.editInfo.txtName.text = updatedStringName
        
        let updatedStringAbout = (self.editInfo.txtAbout.text as NSString?)?.replacingCharacters(in: range, with: string)
        self.editInfo.txtAbout.text = updatedStringAbout
        // do whatever you need with this updated string (your code)
        
        
        // always return true so that changes propagate
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
        
        let refreshAlert = UIAlertController(title: "Empty fields", message: "To continue to the next step, you must fill in both fields.", preferredStyle: UIAlertControllerStyle.alert)
        
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
    
    
    func toStep2() {
        let name = editInfo.txtName.text
        let about = editInfo.txtAbout.text
        
        if((name?.isEmpty)! || (about?.isEmpty)!){
            
            showAlertFormCheck()
            
        }
            
        else {
            
            lblSub.removeFromSuperview()
            let vc2 = storyboard?.instantiateViewController(withIdentifier: "step2") as! ProfileCreate2ViewController
            vc2.strNamePassed = editInfo.txtName.text!
            vc2.strAboutPassed = editInfo.txtAbout.text
            self.navigationController?.pushViewController(vc2, animated: false)
            
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
        //btnCreate.setTitle("Add", for: .normal)
        //btnCreate.setTitleColor(whiteColor, for: .normal)
        //btnCreate.titleLabel?.font = fontBtnNavLink
        btnCreate.setAttributedTitle(attributeString, for: .normal)
        btnCreate.addTarget(self, action: #selector(toMainPage), for: .touchUpInside)
        //add btn
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: btnCreate)
    }
    
    // TO MAIN PAGE
    @objc func toMainPage() {
        lblSub.removeFromSuperview()
        createHeaderMain()
        let profilevc = storyboard?.instantiateViewController(withIdentifier: "profile") as! ProfileViewController
        self.navigationController?.pushViewController(profilevc, animated: true)
    }
    
    
    // SAVE PROFILE INFO
    @objc func create() {
        
        //saveData()
        toStep2()
        
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

