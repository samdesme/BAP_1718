//
//  ProfileCreate2ViewController.swift
//  journey
//
//  Created by sam de smedt on 11/04/2018.
//  Copyright © 2018 sam de smedt. All rights reserved.
//

import UIKit
import CoreData

class ProfileCreate2ViewController: UIViewController, CreateStep2Delegate {
    
    //OUTLET REFERENTIONS
    @IBOutlet var viewMain: UIView!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var backButtonItem: UINavigationItem!
    @IBOutlet weak var pageControl: UIPageControl!
    
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
    
    //view
    let create2 = Bundle.main.loadNibNamed("CreateStep2", owner: nil, options: nil)?.first as! CreateStep2
    
    //labels
    let lblSubHeader = UILabel()
    
    //gradient layers
    let  btnGradientLayer = CAGradientLayer()
    
 
    //Load view controller
    override func viewDidLoad() {
        super.viewDidLoad()
      
        viewCreate2()
        setupPageControl()
        
    }
    
    func viewCreate2() {
        self.tabBarController?.tabBar.isHidden = true
        
        //create form view
        create2.frame = CGRect(x: 0, y: 0, width: viewContent.frame.width, height: viewContent.frame.height)
        create2.backgroundColor = whiteColor
        
        // UILabels
        create2.lblMain.font = fontLabel
        create2.lblMain.text = strLblMain
        create2.lblMain.textColor = blackColor
        create2.lblMain.textAlignment = .left
        
        create2.lblSub.font = fontLabelSub
        create2.lblSub.text = strLblSub
        create2.lblSub.textColor = blackColor.withAlphaComponent(0.8)
        create2.lblSub.textAlignment = .left
        
        // UIButton
        let bottomScrollView = create2.lblMain.frame.size.height + create2.lblSub.frame.size.height + (viewContent.frame.height/4)*3
        
        create2.btnAddKeyword.setTitle(strNewKeyword,for: .normal)
        create2.btnAddKeyword.titleLabel?.font = fontLabel
        create2.btnAddKeyword.titleLabel?.textColor = blackColor
        create2.btnAddKeyword.frame = CGRect(x: (self.view.frame.size.width - 240)/2, y: bottomScrollView + 10, width: 240, height: 20)
        
        create2.btnNextShadow.clipsToBounds = false
        create2.btnToStep3.clipsToBounds = false
        create2.btnNextShadow.backgroundColor = nil
        create2.btnNextShadow.frame = create2.btnToStep3.bounds
        create2.btnToStep3.frame = CGRect(x: (self.view.frame.size.width - 240)/2, y: bottomScrollView + 30 + 10, width: 240, height: 50)
        
        // add gradient to button
        btnGradientLayer.frame = CGRect(x: 0, y: 0, width: 240, height: 50)
        btnGradientLayer.colors = [purpleColor.cgColor, lightPurpleColor.cgColor]
        btnGradientLayer.locations = [ 0.0, 1.0]
        btnGradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        btnGradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        
        create2.btnToStep3.setTitle("NEXT",for: .normal)
        create2.btnToStep3.tintColor = whiteColor
        create2.btnToStep3.titleLabel?.font = fontBtnBig
        
        //drop shadow
        btnGradientLayer.shadowOpacity = 0.10
        btnGradientLayer.shadowRadius = 7.0
        btnGradientLayer.shadowOffset = CGSize(width: 0.0, height: 7.0)
        
        //corner radius
        btnGradientLayer.cornerRadius = 25
        
        //add layer with gradient & drop shadow to button
        create2.btnToStep3.layer.insertSublayer(btnGradientLayer, at: 0)
        
        //add view to content view
        viewContent.addSubview(create2)
        
        //add keywords
        setUpKeywords()
        
    }
    

    func setUpKeywords() {
        
        //list all keywords on screen as buttons
        //let arrayKeywords = ["General Anxiety", "Social Anxiety", "Depression", "Bipolar Disorder", "ADHD", "ADD","Schizophrenia","OCD","Trauma", "Sexual Abuse", "Verbal Abuse", "Physical Abuse", "Addiction", "Weight Issues", "LGBT", "Burn Out", "Anger Management","Autism"]
        
        //fetch all keywords from database
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let dataHelper = DataHelper(context: delegate.managedObjectContext)
        arrayKeywords = dataHelper.fetchAllKeywordsToArray(inputArray: arrayKeywords)
        
        var buttonX: CGFloat = 0
        var buttonY: CGFloat = 10
        
        for keyword in arrayKeywords {
            
            let btnKeyword = UIButton()
            let ySpace: Int = 10
            
            let myString: String = "\(keyword)"
            let size: CGSize = myString.size(withAttributes: [NSAttributedStringKey.font: fontBtnKeyword!])
            let btnWidth = size.width + 20
            let totalWidth = buttonX + btnWidth
            
            if(totalWidth >= create2.scrollView.frame.size.width){
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
            
            
            //add button to keyword view
            create2.scrollView.addSubview(btnKeyword)
            
        }
        
        create2.scrollView.contentSize = CGSize(width: create2.scrollView.frame.size.width , height: buttonY + create2.lblMain.frame.size.height + create2.lblSub.frame.size.height)
        create2.scrollView.backgroundColor = UIColor.clear
        create2.scrollView.frame = CGRect(x: 15, y: 80, width: viewContent.frame.width - 30, height: (viewContent.frame.height/4)*3)
        create2.scrollView.isScrollEnabled = true
        
    }
    
    @objc func selectKeyword(sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            
            print(sender.isSelected)
            
            //styling when selected
            sender.setTitleColor(whiteColor, for: .normal)
            sender.backgroundColor = blueColor
            sender.layer.borderWidth = 0
            
            //add label to array
            arraySelection.append((sender.titleLabel?.text)!)
            
             
        }
            
        else {
            
            print(sender.isSelected)
            
            //styling when deselected
            sender.setTitleColor(blackColor, for: .normal)
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
        create2.btnToStep3.addTarget(self,action:#selector(createSelection),
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
        pageControl.currentPage = 1
        pageControl.numberOfPages = 3
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = purpleColor
        pageControl.pageIndicatorTintColor = purpleColor.withAlphaComponent(0.5)
        pageControl.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        
        viewContent.insertSubview(pageControl, at: 0)
        viewContent.bringSubview(toFront: pageControl)
        
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        let _ = self.navigationController?.popViewController(animated: false)
        lblSubHeader.removeFromSuperview()
        
    }
    
    
    func toStep3() {
        
        lblSubHeader.removeFromSuperview()
        let vc2 = storyboard?.instantiateViewController(withIdentifier: "step3") as! ProfileCreate3ViewController
        vc2.arraySelection = arraySelection
        self.navigationController?.pushViewController(vc2, animated: false)
    }
    
    // SAVE PROFILE INFO
    @objc func createSelection() {
        
        //saveData()
        toStep3()
        
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

