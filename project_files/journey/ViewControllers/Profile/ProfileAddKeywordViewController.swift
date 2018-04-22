//
//  ProfileAddKeywordViewController.swift
//  journey
//
//  Created by sam de smedt on 18/04/2018.
//  Copyright © 2018 sam de smedt. All rights reserved.
//

import UIKit
import CoreData


class ProfileAddKeywordViewController: UIViewController, CreateStep1Delegate {
    
    
    //OUTLET REFERENTIONS
    
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet var viewMain: UIView!
    
    
    
    //VARIABLES
    //strings
    let strHeader = "add a keyword"
    let strLblMain = "Add an issue you identify with"
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //view
    var form = Bundle.main.loadNibNamed("CreateStep1", owner: nil, options: nil)?.first as! CreateStep1
    
    //labels
    let lblSubHeader = UILabel()
    
    //gradient layers
    let  btnGradientLayer = CAGradientLayer()
    
    //passed data
    var strNamePassed = ""
    var strAboutPassed = ""
    var arraySelection = [String]()
    
    
    //Load view controller
    override func viewDidLoad() {
        super.viewDidLoad()
        viewNewKeyword()
    }
    
    
    func viewNewKeyword() {
        
        //some elements of the view "CreateStep1" will be reused to create this form
        let lblNew = form.lblName
        let txtNew = form.txtName
        
        //hide the elements that aren't used
        form.lblAbout.isHidden = true
        form.txtAbout.isHidden = true
        form.btnNextShadow.isHidden = true
        form.btnToStep2.isHidden = true
        
        //create form view
        self.tabBarController?.tabBar.isHidden = true
        form.frame = CGRect(x: 0, y: 0, width: viewContent.frame.width, height: (viewContent.frame.height/2))
        form.backgroundColor = whiteColor
        
        // UILabels
        lblNew?.font = fontLabel
        lblNew?.text = strLblMain
        lblNew?.textColor = blackColor
        lblNew?.textAlignment = .left
     
        //UITextView
        txtNew?.layer.cornerRadius = 5
        txtNew?.layer.borderColor = UIColor.gray.withAlphaComponent(0.4).cgColor
        txtNew?.layer.borderWidth = 1
        txtNew?.font = fontInput
        txtNew?.clipsToBounds = true
   
        //add view to content view
        viewContent.addSubview(form)
       
    }
    
    func createHeaderSub() {
        
        //variables
        let navBar = navigationController?.navigationBar
        let frameTitle = CGRect(x: 0, y: 0, width: (navBar?.frame.width)!, height: (navBar?.frame.height)!)
        lblSubHeader.frame = frameTitle
        
        //Create navigation bar for sub views
        navBar?.barStyle = .blackTranslucent
        navBar?.applyNavigationGradient(colors: [blueColor , lightBlueColorHeader])
        lblSubHeader.text = strHeader .uppercased()
        lblSubHeader.font = fontHeaderSub
        lblSubHeader.textColor = whiteColor
        lblSubHeader.textAlignment = .center
        
        navBar?.addSubview(lblSubHeader)
        addBackButton()
        addCreateButton()
        
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        //update the value of the textfield when changed
        let updatedStringName = (self.form.txtName.text as NSString?)?.replacingCharacters(in: range, with: string)
        form.txtName.text = updatedStringName
        
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
    
    func addCreateButton() {
        let NavLinkAttr : [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.font : fontBtnNavLink!,
            NSAttributedStringKey.foregroundColor : whiteColor,
            NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue]
        let attributeString = NSMutableAttributedString(string: "Add",
                                                        attributes: NavLinkAttr)
        
        let btnCreate = UIButton(type: .custom)
        //btnCreate.setTitle("Add", for: .normal)
        //btnCreate.setTitleColor(whiteColor, for: .normal)
        //btnCreate.titleLabel?.font = fontBtnNavLink
        btnCreate.setAttributedTitle(attributeString, for: .normal)
        btnCreate.addTarget(self, action: #selector(createNewKeyword), for: .touchUpInside)
        //add btn
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: btnCreate)
    }
    
    @objc func createNewKeyword()
    {
        let newKeyword = form.txtName.text
        
        if((newKeyword?.isEmpty)!){
            
            showAlertFormCheck()
            
        }
            
        else {
            
            saveData()
            
            lblSubHeader.removeFromSuperview()
            let vc2 = storyboard?.instantiateViewController(withIdentifier: "step2") as! ProfileCreate2ViewController
            vc2.strNamePassed = strNamePassed
            vc2.strAboutPassed = strAboutPassed
            vc2.arraySelection = arraySelection
            self.navigationController?.pushViewController(vc2, animated: true)
            
        }
    }

    
    @IBAction func backAction(_ sender: UIButton) {
        let _ = self.navigationController?.popViewController(animated: true)
        lblSubHeader.removeFromSuperview()
    }
    
    func create() {
        
    }
    
    
    
    func saveData() {
    
        let context = appDelegate.persistentContainer.viewContext
        let newKeyword = NSEntityDescription.insertNewObject(forEntityName: "Keywords", into: context) as! Keywords

        let title = form.txtName.text
        do {
            
            newKeyword.title = title!
            newKeyword.addedByUser = true
            try context.save()
            
        } catch {
            print("Failed saving")
        }
        
    }
    
    func showAlertFormCheck() {
        
        let refreshAlert = UIAlertController(title: "Please fill in the field", message: "To add a keyword, You must fill the field.", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        createHeaderSub()
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}

