//
//  ProfileCreate1ViewController.swift
//  journey
//
//  Created by sam de smedt on 02/04/2018.
//  Copyright © 2018 sam de smedt. All rights reserved.
//

import UIKit
import CoreData

class ProfileCreate1ViewController: UIViewController, CreateStep1Delegate {
    
    //OUTLET REFERENTIONS
    @IBOutlet var viewStep1: UIView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var backButtonItem: UINavigationItem!
    @IBOutlet weak var pageControl: UIPageControl!
    
    //VARIABLES
    
    //strings
    let strHeaderCreate1 = "general info"
    let strHeader = "profile"
    let strLblName = "What's your name?"
    let strLblAbout = "Describe yourself in a few words"
    
    
    //view
    let create1 = Bundle.main.loadNibNamed("CreateStep1", owner: nil, options: nil)?.first as! CreateStep1
    
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
        setupPageControl()
        
    }
    
    func viewCreate1() {
        self.view.backgroundColor = whiteColor
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    func createForm() {
        
        let navBar = navigationController?.navigationBar

        //create form view
        create1.frame = CGRect(x: 0, y: (navBar?.frame.size.height)! + 50, width: self.view.frame.width, height: (self.view.frame.height/2))
        create1.backgroundColor = whiteColor
        
        // UILabels
        create1.lblName.font = fontLabel
        create1.lblName.text = strLblName
        create1.lblName.textColor = blackColor
        create1.lblName.textAlignment = .left
        
        create1.lblAbout.font = fontLabel
        create1.lblAbout.text = strLblAbout
        create1.lblAbout.textColor = blackColor
        create1.lblAbout.textAlignment = .left
        
        //UITextView
        create1.txtName.layer.cornerRadius = 5
        create1.txtName.layer.borderColor = UIColor.gray.withAlphaComponent(0.4).cgColor
        create1.txtName.layer.borderWidth = 1
        create1.txtName.font = fontInput
        create1.txtName.clipsToBounds = true
        
        //UITextfield
        create1.txtAbout.layer.cornerRadius = 5
        create1.txtAbout.layer.borderColor = UIColor.gray.withAlphaComponent(0.4).cgColor
        create1.txtAbout.layer.borderWidth = 1
        create1.txtAbout.font = fontInput
        create1.txtAbout.clipsToBounds = true
        
        // UIButton
        create1.btnNextShadow.clipsToBounds = false
        create1.btnToStep2.clipsToBounds = false
        create1.btnNextShadow.backgroundColor = nil
         create1.btnToStep2.frame = CGRect(x: 0, y: 0, width: 240, height: 50)
        
        // add gradient to button
        btnGradientLayer.frame = CGRect(x: 0, y: 0, width: 240, height: 50)
        btnGradientLayer.colors = [purpleColor.cgColor, lightPurpleColor.cgColor]
        btnGradientLayer.locations = [ 0.0, 1.0]
        btnGradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        btnGradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
       
        create1.btnToStep2.setTitle("NEXT",for: .normal)
        create1.btnToStep2.tintColor = whiteColor
        create1.btnToStep2.titleLabel?.font = fontBtnBig
        
        //drop shadow
        btnGradientLayer.shadowOpacity = 0.10
        btnGradientLayer.shadowRadius = 7.0
        btnGradientLayer.shadowOffset = CGSize(width: 0.0, height: 7.0)
        
        //corner radius
        btnGradientLayer.cornerRadius = 25
        
        //add layer with gradient & drop shadow to button
        create1.btnToStep2.layer.insertSublayer(btnGradientLayer, at: 0)
        
        //add view to content view
        self.view.addSubview(create1)
        
        
    }
    
    func addTarget() {
        
        //add btn attributes
        create1.btnToStep2.addTarget(self,action:#selector(create),
                                     for:.touchUpInside)
    }
    
    func createHeaderSub() {

        //variables
        let navBar = navigationController?.navigationBar
        let frameTitle = CGRect(x: 0, y: 0, width: (navBar?.frame.size.width)!, height: (navBar?.frame.size.height)!)
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
        let updatedStringName = (self.create1.txtName.text as NSString?)?.replacingCharacters(in: range, with: string)
        self.create1.txtName.text = updatedStringName
        
        let updatedStringAbout = (self.create1.txtAbout.text as NSString?)?.replacingCharacters(in: range, with: string)
        self.create1.txtAbout.text = updatedStringAbout
       
        return true
    }
    
    func popBack() {
        lblSub.removeFromSuperview()
        createHeaderMain()
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    func showAlertQuit() {
        
        let refreshAlert = UIAlertController(title: "Go back to profile", message: "Are you sure you want to quit setting up your profile? Your data will be lost", preferredStyle: UIAlertControllerStyle.alert)
        
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
        
        let name = create1.txtName.text
        let about = create1.txtAbout.text
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
    
    private func setupPageControl() {
        pageControl.currentPage = 0
        pageControl.numberOfPages = 3
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = purpleColor
        pageControl.pageIndicatorTintColor = purpleColor.withAlphaComponent(0.5)
        pageControl.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        
        self.view.insertSubview(pageControl, at: 0)
        self.view.bringSubview(toFront: pageControl)
    
    }
    
    
    func toStep2() {
        let name = create1.txtName.text
        let about = create1.txtAbout.text
        
        if((name?.isEmpty)! || (about?.isEmpty)!){
         
         showAlertFormCheck()
            
         }
         
         else {
            
            lblSub.removeFromSuperview()
            let vc2 = storyboard?.instantiateViewController(withIdentifier: "step2") as! ProfileCreate2ViewController
            vc2.strNamePassed = create1.txtName.text!
            vc2.strAboutPassed = create1.txtAbout.text
            self.navigationController?.pushViewController(vc2, animated: false)
            
        }
        
       
    }
    

    // SAVE PROFILE INFO
    @objc func create() {

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
