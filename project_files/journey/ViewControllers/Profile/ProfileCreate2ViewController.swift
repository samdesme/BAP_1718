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
        create2.btnNextShadow.clipsToBounds = false
        create2.btnToStep3.clipsToBounds = false
        create2.btnNextShadow.backgroundColor = nil
        create2.btnToStep3.frame = CGRect(x: 0, y: 0, width: 240, height: 50)
        
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
        
        //keyword view
        create2.viewKeywords.backgroundColor = UIColor.clear
        
        //add view to content view
        viewContent.addSubview(create2)
        
        //add keywords
        setUpKeywords()
        
    }
    
    func setUpKeywords() {
        
        //list all keywords on screen as buttons
        let arrayKeywords = ["General Anxiety", "Social Anxiety", "Depression", "ADHD", "ADD", "Bipolar Disorder", "OCD", "Schizophrenia", "Sexual Abuse", "Verbal Abuse", "Physical Abuse", "Trauma", "Addiction", "Weight Issues", "Autism", "Burn Out", "Anger Management", "LGBT"]
        
        var buttonX: CGFloat = 0
        var buttonY: CGFloat = 10
        
        for keyword in arrayKeywords {
            
            let btnKeyword = UIButton()
            let ySpace: Int = 10
            
            let myString: String = "\(keyword)"
            let size: CGSize = myString.size(withAttributes: [NSAttributedStringKey.font: fontBtnKeyword!])
            let btnWidth = size.width + 20
            let totalWidth = buttonX + btnWidth
            
            if(totalWidth >= create2.viewKeywords.frame.size.width){
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
            
            btnKeyword.layer.cornerRadius = 20
            btnKeyword.layer.borderWidth = 1.5
            btnKeyword.layer.borderColor = blackColor.cgColor
            
            //add button to keyword view
            create2.viewKeywords.addSubview(btnKeyword)
            
        }
        
        
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
    
    func createHeaderStep1() {
        
        //variables
        //let navBar = navigationController?.navigationBar
     
        
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
        createHeaderStep1()
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

