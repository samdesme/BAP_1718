//
//  ProfileViewController.swift
//  journey
//
//  Created by sam de smedt on 25/03/2018.
//  Copyright © 2018 sam de smedt. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, ProfileHeaderDelegate, ProfileInfoDelegate {
    
    //OUTLET REFERENTIONS
    
    //Main
    @IBOutlet var viewMain: UIView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewContent: UIView!
    
    
    /*
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
     */
    
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
    
    var table = UITableView()

    
   //Load view controller
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Functions
       createView()
    
    }
    
    func createView() {
        
        // paragraph style attributes
        let attrTextView = [NSAttributedStringKey.paragraphStyle : styleTextViewAbout,
                            NSAttributedStringKey.foregroundColor : whiteColor,
                            NSAttributedStringKey.font : fontMainRegular! ]
        
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
        
        
        // profile info view
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
        userInfo.btnEditInfo.layer.cornerRadius = 20
        userInfo.btnEditInfo.frame = CGRect(x: (userInfo.frame.size.width - 200)/2, y: (userInfo.frame.size.height/3)*2 + ((userInfo.frame.size.height/3)-40)/2, width: 200, height: 40)
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
        userInfo.viewTopGradient.layer.addSublayer(topGradientLayer)

        
    }
    
    /*
    func setUpUserInfoCAView() {
        
     
        //BUTTON
        
        btnEditInfo.setTitle("Edit",for: .normal)
        btnEditInfo.tintColor = whiteColor
        btnEditInfo.backgroundColor = .clear
        btnEditInfo.layer.cornerRadius = 24
        btnEditInfo.layer.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
        btnEditInfo.titleLabel?.font = fontBtnSmall
        btnEditInfo.layer.borderWidth = 2
        btnEditInfo.layer.borderColor = whiteColor.cgColor

    }
    
    
    func setUpKeywordUIView() {
        
        //UIVIEW
        
        viewKeywords.backgroundColor = whiteColor
        
        //corner radius
        viewKeywords.layer.cornerRadius = 25
        
        //drop shadow
        viewKeywords.layer.shadowColor = blackColor.cgColor
        viewKeywords.layer.shadowOffset = CGSize(width: 6, height: 6)
        viewKeywords.layer.shadowOpacity = 0.05
        viewKeywords.layer.shadowRadius = 5.0
        
        //LABELS
        
        lblTopThree.textAlignment = .center
        lblTopThree.font = fontMainLight
        lblTopThree.textColor = blackColor
        lblTopThree.text = "Your top 3 biggest mental health struggles"
        lblTopThree.layer.opacity = 0.6
        
    
        /*
        //style the bullet points of each label by making multiple attributes
        //and appending them to each string
        let keyBullet = strBullet
        let multipleAttributes: [NSAttributedStringKey : Any] = [
            NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 20),
            NSAttributedStringKey.foregroundColor: blueColor,
             ]
        let attributedString1 = NSMutableAttributedString(string: keyBullet, attributes: multipleAttributes)
        let attributedString2 = NSMutableAttributedString(string: keyBullet, attributes: multipleAttributes)
        let attributedString3 = NSMutableAttributedString(string: keyBullet, attributes: multipleAttributes)
        let strKey1 = NSMutableAttributedString(string: " Anger Mangagement")
        attributedString1.append(strKey1)
        let strKey2 = NSMutableAttributedString(string: " General Anxiety")
        attributedString2.append(strKey2)
        let strKey3 = NSMutableAttributedString(string: " Depression")
        attributedString3.append(strKey3)*/
        
        //style top 3 keywords
        keyword1.textAlignment = .center
        keyword1.font = fontKeywordRegular
        keyword1.textColor = blackColor
        keyword1.text = "General Anxiety"
        keyword1.layer.opacity = 1
        
        keyword2.textAlignment = .center
        keyword2.font = fontKeywordRegular
        keyword2.textColor = blackColor
        keyword2.text = "Anger Mangagement"
        keyword2.layer.opacity = 0.5
        
        keyword3.textAlignment = .center
        keyword3.font = fontKeywordRegular
        keyword3.textColor = blackColor
        keyword3.text = "Depression"
        keyword3.layer.opacity = 0.25
        
        //BUTTON
        
        viewShadowBtn.clipsToBounds = false
        btnEditKeywords.clipsToBounds = false
        viewShadowBtn.backgroundColor = nil
        
        
        //gradient
        btnGradientLayer.frame = CGRect(x: 0, y: 0, width: 200, height: 45)
        btnGradientLayer.colors = [blueColor.cgColor, lightBlueColor.cgColor]
        btnGradientLayer.locations = [ 0.0, 1.0]
        btnGradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        btnGradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        
        //drop shadow
        btnGradientLayer.shadowOpacity = 0.10
        btnGradientLayer.shadowRadius = 7.0
        btnGradientLayer.shadowOffset = CGSize(width: 0.0, height: 7.0)
        
        //corner radius
        btnGradientLayer.cornerRadius = 24
        
        
        btnEditKeywords.setTitle("Edit",for: .normal)
        btnEditKeywords.tintColor = whiteColor
        btnEditKeywords.titleLabel?.font = fontBtnSmall
       
        //add layer with gradient & drop shadow to UIView
        viewShadowBtn.layer.addSublayer(btnGradientLayer)
        

        
        
    }
    */
    
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

