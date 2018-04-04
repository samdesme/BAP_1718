//
//  ProfileViewController.swift
//  journey
//
//  Created by sam de smedt on 25/03/2018.
//  Copyright © 2018 sam de smedt. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, ProfileHeaderDelegate, ProfileInfoDelegate, ProfileKeywordsDelegate {
   
    
    
    //OUTLET REFERENTIONS
    
    //Main
    @IBOutlet var viewMain: UIView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewContent: UIView!
    
    @IBOutlet var viewCreate1: UIView!
    
    // VARIABELS
    
    //gradient layers
    let  gradientLayer = CAGradientLayer()
    let  topGradientLayer = CAGradientLayer()
    let  btnGradientLayer = CAGradientLayer()
    
    //paragraph styles
    let styleTextViewAbout = NSMutableParagraphStyle()
    let styleLabelName = NSMutableParagraphStyle()
 
    
    //strings
    let strHeader = "profile"
    let strAbout = "I'm an extremely organized person who is focused on producing results. While I am always realistic when setting goals, I consistently develop."
    let strFirstName = "Ellen"
    let strBullet = "\u{2022} "
 
    var headerMenu = ProfileHeader()
    var userInfo = ProfileInfo()
    var userKeywords = ProfileKeywords()
    var step1 = ProfileCreate1ViewController()
    

    
   //Load view controller
    override func viewDidLoad() {
        super.viewDidLoad()
             
        
        //Functions
       createView()
        
       
      
    
    }
    
    func createView() {
        
        // HEADER
        viewHeader.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 70)
        headerMenu = Bundle.main.loadNibNamed("ProfileHeader", owner: nil, options: nil)?.first as! ProfileHeader
        headerMenu.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: viewHeader.frame.size.height)
        headerMenu.lblHeader.font = fontHeaderMain
        headerMenu.lblHeader.text = strHeader.uppercased()
        headerMenu.lblHeader.textAlignment = .center
        headerMenu.lblHeader.frame = CGRect(x: 0, y: 15, width: viewHeader.frame.size.width, height: viewHeader.frame.size.height)
        headerMenu.delegate = self
        viewHeader.addSubview(headerMenu)
        
        // CONTENT
        viewContent.backgroundColor = lightGreyColor
        
        profileInfoView()
        profileKeywordView()

        
    }
    
    func profileInfoView() {
        
        // variables
        let attrTextView = [NSAttributedStringKey.paragraphStyle : styleTextViewAbout,
                            NSAttributedStringKey.foregroundColor : whiteColor,
                            NSAttributedStringKey.font : fontMainRegular! ]
        
        // profile info UIView
        userInfo = Bundle.main.loadNibNamed("ProfileInfo", owner: nil, options: nil)?.first as! ProfileInfo
        userInfo.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: (viewContent.frame.size.height/1.9))
        
        // UILabel
        userInfo.lblName.font = fontLblFirstName
        userInfo.lblName.textAlignment = .center
        userInfo.lblName.textColor = whiteColor
        userInfo.lblName.text = strFirstName
        userInfo.lblName.frame = CGRect(x: 15, y: (userInfo.frame.size.height/3)/3, width: userInfo.frame.size.width - 30, height: (userInfo.frame.size.height/3)/2)
        
        // UITextView
        userInfo.txtAbout.backgroundColor = UIColor.clear
        userInfo.txtAbout.textAlignment = .center
        userInfo.txtAbout.isEditable = false
        userInfo.txtAbout.frame = CGRect(x: 15, y: userInfo.frame.size.height/3.2, width: userInfo.frame.size.width - 30, height: userInfo.frame.size.height/2.8)
        
        // UIButton
        userInfo.btnEditInfo.setTitle("Edit",for: .normal)
        userInfo.btnEditInfo.tintColor = whiteColor
        userInfo.btnEditInfo.backgroundColor = .clear
        userInfo.btnEditInfo.layer.cornerRadius = 22.5
        userInfo.btnEditInfo.frame = CGRect(x: (userInfo.frame.size.width - 200)/2, y: (userInfo.frame.size.height/3)*2 + ((userInfo.frame.size.height/3)-40)/2, width: 200, height: 45)
        userInfo.btnEditInfo.titleLabel?.font = fontBtnSmall
        userInfo.btnEditInfo.layer.borderWidth = 2
        userInfo.btnEditInfo.layer.borderColor = whiteColor.cgColor
        
        // add attributes to UITextView
        styleTextViewAbout.lineSpacing = -2
        styleTextViewAbout.alignment = .center
        userInfo.txtAbout.attributedText = NSAttributedString(string: strAbout, attributes:attrTextView)
        
        // add to view as a sub view
        viewContent.addSubview(userInfo)
        
        // add a gradient layer
        userInfo.viewShadow.clipsToBounds = false
        viewContent.clipsToBounds = false
        userInfo.viewShadow.backgroundColor = nil
        userInfo.backgroundColor = UIColor.clear
        
        gradientLayer.frame = userInfo.bounds
        gradientLayer.colors = [purpleColor.cgColor, blueColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        
        // add a drop shadow to the gradient layer
        gradientLayer.shadowOpacity = 0.10
        gradientLayer.shadowRadius = 7.0
        gradientLayer.shadowOffset = CGSize(width: 0.0, height: 7.0)
        
        // edit corner radius op the gradient layer
        gradientLayer.cornerRadius = 50
        gradientLayer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        //add gradient layer to UIView
        userInfo.viewShadow.layer.addSublayer(gradientLayer)
        
        //set up a gradient at the top of the page to create a 3D effect
        userInfo.viewTopGradient.clipsToBounds = false
        userInfo.viewTopGradient.backgroundColor = UIColor.clear
        topGradientLayer.frame = CGRect(x: 0, y: 0, width: userInfo.frame.size.width, height: (userInfo.frame.size.height/3)/2)
        topGradientLayer.colors = [blackColor.withAlphaComponent(0.05).cgColor, UIColor.clear.cgColor]
        topGradientLayer.locations = [ 0.0, 1.0]
        
        //add layer to view
        userInfo.viewTopGradient.layer.addSublayer(topGradientLayer)
        
        
        userInfo.btnEditInfo.addTarget(self,action:#selector(create1),
                                       for:.touchUpInside)
        
       
        
    }
    
    func profileKeywordView() {
        
        // variables
        let y = viewContent.frame.size.height/1.9 + (viewContent.frame.size.height - viewContent.frame.size.height/1.9 - viewContent.frame.size.height/3)/2
        
        // profile keywords UIView
        userKeywords = Bundle.main.loadNibNamed("ProfileKeywords", owner: nil, options: nil)?.first as! ProfileKeywords
        userKeywords.frame = CGRect(x: 15, y: y, width: viewContent.frame.size.width - 30, height: (viewContent.frame.size.height/3))
        userKeywords.backgroundColor = whiteColor
       
        // edit corner radius of the view
        userKeywords.layer.cornerRadius = 25
        
        // add a drop shadow to the view
        userKeywords.layer.shadowColor = blackColor.cgColor
        userKeywords.layer.shadowOffset = CGSize(width: 6, height: 6)
        userKeywords.layer.shadowOpacity = 0.05
        userKeywords.layer.shadowRadius = 5.0
        
        
        // UILabels
        userKeywords.keyword1.textAlignment = .center
        userKeywords.keyword1.font = fontMainRegular19
        userKeywords.keyword1.textColor = blackColor
        userKeywords.keyword1.text = "General Anxiety"
        userKeywords.keyword1.layer.opacity = 1
        //userKeywords.keyword1.backgroundColor = lightBlueColor
        //userKeywords.keyword1.frame = CGRect(x: 0, y: 0, width: 200, height: 30)
        
        userKeywords.keyword2.textAlignment = .center
        userKeywords.keyword2.font = fontMainRegular19
        userKeywords.keyword2.textColor = blackColor
        userKeywords.keyword2.text = "Anger Mangagement"
        userKeywords.keyword2.layer.opacity = 0.5
        //userKeywords.keyword2.frame = CGRect(x: 0, y: 30, width: 200, height: 30)
        
        userKeywords.keyword3.textAlignment = .center
        userKeywords.keyword3.font = fontMainRegular19
        userKeywords.keyword3.textColor = blackColor
        userKeywords.keyword3.text = "Depression"
        userKeywords.keyword3.layer.opacity = 0.25
        //userKeywords.keyword3.frame = CGRect(x: 0, y: 60, width: 200, height: 30)
        
        userKeywords.lblTitle.textAlignment = .center
        userKeywords.lblTitle.font = fontMainLight19
        userKeywords.lblTitle.textColor = blackColor
        userKeywords.lblTitle.text = "Your top 3 biggest mental health struggles"
        userKeywords.lblTitle.layer.opacity = 0.6
        
        
        // UIButton
        userKeywords.viewBtnSadow.clipsToBounds = false
        userKeywords.btnEditKeywords.clipsToBounds = false
        userKeywords.viewBtnSadow.backgroundColor = nil
        
        // add view to content
        viewContent.addSubview(userKeywords)
        
        
        // add gradient to button
        btnGradientLayer.frame = CGRect(x: 0, y: 0, width: 200, height: 45)
        btnGradientLayer.colors = [blueColor.cgColor, lightBlueColor.cgColor]
        btnGradientLayer.locations = [ 0.0, 1.0]
        btnGradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        btnGradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        userKeywords.btnEditKeywords.setTitle("Edit",for: .normal)
        userKeywords.btnEditKeywords.tintColor = whiteColor
        userKeywords.btnEditKeywords.titleLabel?.font = fontBtnSmall
        
        //drop shadow
        btnGradientLayer.shadowOpacity = 0.10
        btnGradientLayer.shadowRadius = 7.0
        btnGradientLayer.shadowOffset = CGSize(width: 0.0, height: 7.0)
        
        //corner radius
        btnGradientLayer.cornerRadius = 22.5
        
        //add layer with gradient & drop shadow to button
        userKeywords.viewBtnSadow.layer.addSublayer(btnGradientLayer)
       
        
    }
    
 
 
    @objc func create1() {
        
          self.navigationController?.pushViewController(step1, animated: true)
        
       
    }

    
    /*
 
    func showProfileInfo(){
        
        //TO DO: function if profile is created
        
        if(){
            lblFirstName.text = "example"
            textViewAbout.text = "example"
            
        }
        else {
            lblFirstName.text = ""
            textViewAbout.text = ""
        }
 
    }
    
 */
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  

   
    
}

