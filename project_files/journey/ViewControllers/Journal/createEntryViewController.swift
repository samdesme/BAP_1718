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
    let strLblDescr = "Describe your entry"
    let strSeverity = "Rate the severity of your mental issues in this situation (opinional)"
    let strRate = "Rate your overall mood"

    
    //view
    let form = Bundle.main.loadNibNamed("CreateStep1", owner: nil, options: nil)?.first as! CreateStep1
    let viewActions = UIView()
    
    //database
    
    //labels
    let lblSub = UILabel()
    let lblMain = UILabel()
    var lblDisplay = UILabel()

    //gradient layers
    let  btnGradientLayer = CAGradientLayer()
    
    //Load view controller
    override func viewDidLoad() {
        super.viewDidLoad()
      
        createView()
        createForm()
        setUpSliders()
        //setUpMoods()
    }
    
    func createView() {
        self.view.backgroundColor = whiteColor
        
    }
    
    // MARK: layout functions
    
    func createForm() {
        
        let navBar = navigationController?.navigationBar
        
        //create form view
        form.frame = CGRect(x: 0, y: (navBar?.frame.size.height)! + 50, width: self.view.frame.width, height: (self.view.frame.height/3))
        form.backgroundColor = purpleColor.withAlphaComponent(0.1)
        
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
        form.txtAbout.layer.borderColor = UIColor.gray.withAlphaComponent(0.4).cgColor
        form.txtAbout.layer.borderWidth = 1
        form.txtAbout.font = fontInput
        form.txtAbout.clipsToBounds = true
        
        // UIButton
        form.btnNextShadow.isHidden = true
        form.btnToStep2.isHidden = true
        
        //add view to content view
        self.view.addSubview(form)
    }
    
    func setUpSliders() {
        
        let navBar = navigationController?.navigationBar

        let keywordSlider = UISlider()
        getData()
        
        viewActions.frame = CGRect(x: 15, y: (navBar?.frame.size.height)! + 50 + self.view.frame.height/3 + 25, width: self.view.frame.width - 30, height: self.view.frame.height/3)
        viewActions.backgroundColor = lightGreyColor
        
        lblDisplay.frame = CGRect(x: 0, y: 0, width: 60, height: 20)
        keywordSlider.frame = CGRect(x: 60, y: 0, width: viewActions.frame.size.width - 60, height: 20)
        
        keywordSlider.minimumValue = 0
        keywordSlider.maximumValue = 100
        keywordSlider.value = 0
        keywordSlider.isContinuous = true
        keywordSlider.tintColor = blueColor
        keywordSlider.addTarget(self, action: #selector(self.sliderValueDidChange(_:)), for: .valueChanged)

        lblDisplay.font = fontMainRegular20
        lblDisplay.textColor = blueColor
        
        viewActions.addSubview(lblDisplay)
        viewActions.addSubview(keywordSlider)

        self.view.addSubview(viewActions)
        
    }
    
    @objc func sliderValueDidChange(_ sender:UISlider!)
    {
        print("Slider value changed")
        
        let value = round(sender.value)
        lblDisplay.text = String(value)
        
        // Use this code below only if you want UISlider to snap to values step by step
        //let roundedStepValue = round(sender.value / step) * step
        //sender.value = roundedStepValue
        
        //print("Slider step value \(Int(roundedStepValue))")
    }
    
    func setUpMoods() {

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
        
        
    }
    
    func getData() {
        
        
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

