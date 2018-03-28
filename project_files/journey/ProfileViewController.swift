//
//  ProfileViewController.swift
//  journey
//
//  Created by sam de smedt on 25/03/2018.
//  Copyright © 2018 sam de smedt. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    //OUTLET REFERENTIONS
    
    //general info view
    @IBOutlet var viewProfile: UIView!
    @IBOutlet weak var viewShadow: UIView!
    @IBOutlet weak var navBarProfile: UIView!
    @IBOutlet weak var viewProfieInfo: UIView!
    @IBOutlet weak var lblHeaderProfile: UILabel!
    @IBOutlet weak var lblFirstName: UILabel!
    @IBOutlet weak var textViewAbout: UITextView!
    @IBOutlet weak var btnEditInfo: UIButton!
    @IBOutlet weak var viewKeywords: UIView!
    @IBOutlet weak var viewTopGradient: UIView!
    
    //keywords view
    @IBOutlet weak var keyword1: UILabel!
    @IBOutlet weak var keyword2: UILabel!
    @IBOutlet weak var keyword3: UILabel!
    @IBOutlet weak var btnEditKeywords: UIButton!
    @IBOutlet weak var lblTopThree: UILabel!
    @IBOutlet weak var viewShadowBtn: UIView!
    
    // VARIABELS
    let  gradientLayer = CAGradientLayer()
    let  topGradientLayer = CAGradientLayer()
    let  btnGradientLayer = CAGradientLayer()
    
    
    let strHeader = "profile"
    let styleTextViewAbout = NSMutableParagraphStyle()
    let styleLabelName = NSMutableParagraphStyle()
    let strAbout = "I'm an extremely organized person who is focused on producing results. While I am always realistic when setting goals, I consistently develop."
    let strFirstName = "Ellen"
  
    
    
    //Convert UILayer to CALayer to create shadows and gradients
    var caLayer: CALayer {
        return viewShadow.layer
    }
    var caLayerBtn: CALayer {
        return viewShadowBtn.layer
    }
    
   //Load view controller
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Functions
        setUpProfile()
        setUpMainNavBar()
        setUpUserInfoCAView()
        setUpKeywordUIView()
        setUpTopGradient()
    
    }
    
    
    func setUpUserInfoCAView() {
        
        //Set up bounds & styling for UIView (general user info)
        viewShadow.clipsToBounds = false
        viewProfieInfo.clipsToBounds = false
        viewShadow.backgroundColor = nil
        
        //Add gradient
        gradientLayer.frame = viewShadow.bounds
        gradientLayer.colors = [purpleColor.cgColor, blueColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        
        //Add drop shadow
        gradientLayer.shadowOpacity = 0.10
        gradientLayer.shadowRadius = 7.0
        gradientLayer.shadowOffset = CGSize(width: 0.0, height: 7.0)
        
        //Bottom corner radius
        gradientLayer.cornerRadius = 50
        gradientLayer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        //Add gradient layer to UIView
        viewShadow.layer.addSublayer(gradientLayer)

        //lblFirstName.setLineSpacing(lineSpacing: 2.0)
        lblFirstName.font = fontLblFirstName
        lblFirstName.textAlignment = .center
        lblFirstName.textColor = whiteColor
        lblFirstName.text = strFirstName
        
        //Textview: about
        textViewAbout.backgroundColor = UIColor.clear
        styleTextViewAbout.lineSpacing = -5
        styleTextViewAbout.alignment = .center
        let attrTextView = [NSAttributedStringKey.paragraphStyle : styleTextViewAbout,
                          NSAttributedStringKey.foregroundColor : whiteColor,
                          NSAttributedStringKey.font : fontMainLight! ]
        textViewAbout.attributedText = NSAttributedString(string: strAbout, attributes:attrTextView)
       
        //Button: edit general user info
        btnEditInfo.setTitle("Edit",for: .normal)
        btnEditInfo.tintColor = whiteColor
        btnEditInfo.backgroundColor = .clear
        btnEditInfo.layer.cornerRadius = 25
        btnEditInfo.titleLabel?.font = fontBtnSmall
        btnEditInfo.layer.borderWidth = 2
        btnEditInfo.layer.borderColor = whiteColor.cgColor

    }
    
    func setUpTopGradient() {
        
        //set up a gradient at the top of the page to create a 3D effect
        viewTopGradient.clipsToBounds = false
        viewTopGradient.backgroundColor = nil
        topGradientLayer.frame = viewTopGradient.bounds
        topGradientLayer.colors = [cgColorTransBlack05, UIColor.clear.cgColor]
        topGradientLayer.locations = [ 0.0, 1.0]
        viewTopGradient.layer.addSublayer(topGradientLayer)
        
    }
    
    func setUpKeywordUIView() {
        
        //SET UP UIVIEW
        viewKeywords.backgroundColor = whiteColor
        
        //corner radius
        viewKeywords.layer.cornerRadius = 25
        
        //drop shadow
        viewKeywords.layer.shadowColor = blackColor.cgColor
        viewKeywords.layer.shadowOffset = CGSize(width: 6, height: 6)
        viewKeywords.layer.shadowOpacity = 0.05
        viewKeywords.layer.shadowRadius = 5.0
        
        //SET UP LABELS
        lblTopThree.textAlignment = .center
        lblTopThree.font = fontMainLight
        lblTopThree.textColor = blackColor
        lblTopThree.text = "Your top 3 biggest mental health struggles"
        
        keyword1.textAlignment = .left
        keyword1.font = fontKeywordRegular
        keyword1.textColor = blackColor
        keyword1.text = "keyword 1"
        
        keyword2.textAlignment = .left
        keyword2.font = fontKeywordRegular
        keyword2.textColor = blackColor
        keyword2.text = "keyword 2"
        
        keyword3.textAlignment = .left
        keyword3.font = fontKeywordRegular
        keyword3.textColor = blackColor
        keyword3.text = "keyword 3"
        
        //SET UP BUTTON
        btnEditKeywords.setTitle("Edit",for: .normal)
        btnEditKeywords.tintColor = whiteColor
        btnEditKeywords.backgroundColor = .clear
       // btnEditKeywords.layer.cornerRadius = 25
        btnEditKeywords.titleLabel?.font = fontBtnSmall
        btnEditKeywords.clipsToBounds = true
        
        
        //add gradient

        btnGradientLayer.frame = btnEditKeywords.bounds
        btnGradientLayer.colors = [blueColor.cgColor, whiteColor.cgColor]
        btnGradientLayer.locations = [ 0.0, 1.0]
        //btnGradientLayer.startPoint = CGPoint(x: 1, y: 0)
        //btnGradientLayer.endPoint = CGPoint(x: 0, y: 1)
        
        
        viewShadowBtn.backgroundColor = nil
        viewShadowBtn.clipsToBounds = false
        viewShadowBtn.frame = btnGradientLayer.bounds
        
        //Add drop shadow
        btnGradientLayer.shadowOpacity = 0.10
        btnGradientLayer.shadowRadius = 7.0
        btnGradientLayer.shadowOffset = CGSize(width: 0.0, height: 7.0)
        
        //Bottom corner radius
        btnGradientLayer.cornerRadius = 25
   
        viewShadowBtn.layer.addSublayer(btnGradientLayer)
        
        
     
        
        
    }
    
    func setUpMainNavBar() {
        
        //set up main navigation bar
        navBarProfile.backgroundColor = whiteColor
        lblHeaderProfile.text = strHeader.uppercased()
        lblHeaderProfile.font = fontHeaderMain
        lblHeaderProfile.textColor = blackColor
    }
    
    func showProfileInfo(){
        
        //TO DO: function if profile is created
        /*
        if(){
            lblFirstName.text = "example"
            textViewAbout.text = "example"
            
        }
        else {
            lblFirstName.text = ""
            textViewAbout.text = ""
        }
        */
    }
    
    func setUpProfile() {
     
        viewProfile.backgroundColor = lightGreyColor
     
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  


}

