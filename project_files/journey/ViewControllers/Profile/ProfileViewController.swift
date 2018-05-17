//
//  ProfileViewController.swift
//  journey
//
//  Created by sam de smedt on 25/03/2018.
//  Copyright © 2018 sam de smedt. All rights reserved.
//

import UIKit
import CoreData

class ProfileViewController: UIViewController, ProfileHeaderDelegate, ProfileInfoDelegate, ProfileTopKeywordsDelegate {
   
    //OUTLET REFERENTIONS
    @IBOutlet var viewMain: UIView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewContent: UIView!
    

    //VARIABELS
    
    //gradient layers
    let  gradientLayer = CAGradientLayer()
    let  topGradientLayer = CAGradientLayer()
    let  btnGradientLayer = CAGradientLayer()
    
    //paragraph styles
    let styleTextViewAbout = NSMutableParagraphStyle()
    let styleLabelName = NSMutableParagraphStyle()
    
    //labels
    let lbl = UILabel()
    
    //arrays
     var arrayTop3 = [String]()
 
    //strings
    let strHeader = "profile"
    let strHeaderCreate1 = "step 1"
    let strBullet = "\u{2022} "
 
    //views
    //var userInfo = ProfileInfo()
    var userKeywords = ProfileTopKeywords()
    var step1 = ProfileCreate1ViewController()
    
    let userInfo = Bundle.main.loadNibNamed("ProfileInfo", owner: nil, options: nil)?.first as! ProfileInfo

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
   //Load view controller
    override func viewDidLoad() {
        super.viewDidLoad()
        //createData()
        //Functions
        createProfileView()
        profileInfoView()
        profileKeywordView()
        
    }
    
    func createHeaderMain() {
        
        //variables
        let navBar = navigationController?.navigationBar
        let frameTitle = CGRect(x: 0, y: (navBar?.frame.height)!/2 - 5, width: (navBar?.frame.width)!, height: (navBar?.frame.height)!/2)
        lbl.frame = frameTitle
        
        //Create navigation bar
        navBar?.backgroundColor = whiteColor
        lbl.alpha = 1
        lbl.text = strHeader.uppercased()
        lbl.font = fontHeaderMain
        lbl.textAlignment = .center
        navBar?.addSubview(lbl)
        
    }
    
    func createProfileView() {
      

        
        // CONTENT
        self.view.backgroundColor = lightGreyColor
      
    }
    
    
    
    func getData() -> (name: String, about: String) {
     
        var name = String()
        var about = String()
        
        let context = appDelegate.persistentContainer.viewContext
        //let request = NSFetchRequest<Profile>(entityName: "Profile")
        //request.predicate = NSPredicate(format: "age = %@", "12")
        //request.returnsObjectsAsFaults = false
        //let profile = NSEntityDescription.insertNewObject(forEntityName: "Profile", into: context) as! Profile
        
        let dataHelper = DataHelper(context: context)
        let profiles : [Profile] = dataHelper.getAllProfiles()
        
       
        if (profiles.count != 0){
            
            let firstProfile = dataHelper.getProfileById(id: profiles[0].objectID)!
            
           // print("\(String(describing: firstProfile))")
            
            name = firstProfile.name
            about = firstProfile.about
            //printKeywords()
            
        }
        else {
            
            name = ""
            about = ""
            
        }
        
        return (name, about)
    }
    
   
    
    
    func checkProfileExists() -> Bool {
        if (getData().name == "" && getData().name == "") {
            return false
        } else {
            return true
        }
    }
    
    func profileInfo() {
        
        let attrTextView = [NSAttributedStringKey.paragraphStyle : styleTextViewAbout,
                            NSAttributedStringKey.foregroundColor : whiteColor,
                            NSAttributedStringKey.font : fontMainRegular! ]
        
        var name = String()
        var about = String()
        var btnTitle = String()
        
        
        // SET UP VIEW
        // profile info UIView
        userInfo.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: (self.view.frame.size.height/1.9))
        
        if checkProfileExists() {
            name = getData().name
            about = getData().about
            btnTitle = "Edit"
            userInfo.btnEditInfo.addTarget(self,action:#selector(editInfo), for:.touchUpInside)
            userInfo.lblName.frame = CGRect(x: 15, y: userInfo.frame.size.height/3.9, width: userInfo.frame.size.width - 30, height: (userInfo.frame.size.height/3)/2)
            userInfo.txtAbout.frame = CGRect(x: 15, y: (userInfo.frame.size.height - (userInfo.frame.size.height/3)/2)/2, width: userInfo.frame.size.width - 30, height: userInfo.frame.size.height/3)


            
        } else {
            name = "Welcome."
            about = "Create your profile to begin"
            btnTitle = "Create"
            
            //add btn attributes
            userInfo.btnEditInfo.addTarget(self,action:#selector(create1), for:.touchUpInside)
            userInfo.lblName.frame = CGRect(x: 15, y: userInfo.frame.size.height/3, width: userInfo.frame.size.width - 30, height: (userInfo.frame.size.height/3)/2)
            userInfo.txtAbout.frame = CGRect(x: 15, y: userInfo.frame.size.height/2, width: userInfo.frame.size.width - 30, height: userInfo.frame.size.height/2.8)
        }
        
        
        // UILabel
        userInfo.lblName.text = name
        userInfo.lblName.font = fontLblFirstName
        userInfo.lblName.textAlignment = .center
        userInfo.lblName.textColor = whiteColor
        
        
        // UITextView
        userInfo.txtAbout.attributedText = NSAttributedString(string: about, attributes:attrTextView)
        userInfo.txtAbout.backgroundColor = UIColor.clear
        userInfo.txtAbout.textAlignment = .center
        userInfo.txtAbout.isEditable = false
        
        // UIButton
        userInfo.btnEditInfo.setTitle(btnTitle,for: .normal)
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
        
        // add to view as a sub view
        self.view.addSubview(userInfo)
        
    }
    func profileInfoView() {
        
        profileInfo()
        
        // SET UP VIEW
        // profile info UIView
        
        // add a gradient layer
        userInfo.viewShadow.clipsToBounds = false
        self.view.clipsToBounds = false
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
        
    }
    
    func profileKeywordView() {
        
        // variables
        let y = self.view.frame.size.height/1.9 + (self.view.frame.size.height - self.view.frame.size.height/1.9 - self.view.frame.size.height/3)/2
        
        // profile keywords UIView
        userKeywords = Bundle.main.loadNibNamed("ProfileTopKeywords", owner: nil, options: nil)?.first as! ProfileTopKeywords
        userKeywords.frame = CGRect(x: 15, y: y, width: self.view.frame.size.width - 30, height: (self.view.frame.size.height/3))
        userKeywords.backgroundColor = whiteColor
       
        // edit corner radius of the view
        userKeywords.layer.cornerRadius = 25
        
        // add a drop shadow to the view
        userKeywords.layer.shadowColor = blackColor.cgColor
        userKeywords.layer.shadowOffset = CGSize(width: 6, height: 6)
        userKeywords.layer.shadowOpacity = 0.05
        userKeywords.layer.shadowRadius = 5.0
        
        // UILabels
        userKeywords.lblTitle.textAlignment = .center
        userKeywords.lblTitle.font = fontMainLight19
        userKeywords.lblTitle.textColor = blackColor
        userKeywords.lblTitle.text = "Your top 3 biggest mental health struggles"
        userKeywords.lblTitle.layer.opacity = 0.6
        
        displayUserKeywords()

        if checkProfileExists() {
            userKeywords.btnEditKeywords.addTarget(self,action:#selector(editKeywords), for:.touchUpInside)
            userKeywords.frame = CGRect(x: 15, y: y, width: self.view.frame.size.width - 30, height: self.view.frame.size.height/3.9)
            userKeywords.viewBtnSadow.layer.addSublayer(btnGradientLayer)
        } else {
            userKeywords.frame = CGRect(x: 15, y: y, width: self.view.frame.size.width - 30, height: (self.view.frame.size.height/3.7) )
            userKeywords.btnEditKeywords.isHidden = true
        }
        
        // UIButton
        userKeywords.viewBtnSadow.clipsToBounds = false
        userKeywords.btnEditKeywords.clipsToBounds = false
        userKeywords.viewBtnSadow.backgroundColor = nil
        
        // add view to content
        self.view.addSubview(userKeywords)
        
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
        
    }

    func printKeywords() {
        let context = appDelegate.persistentContainer.viewContext
        let dataHelper = DataHelper(context: context)
        let keywords : [Keywords] = dataHelper.getAll()
        let sev : [EntryKeywords] = dataHelper.getAllSeverities()

        
        let i = keywords.index(where: { $0.ranking == 1}) as! Int
    

        let showRelation = dataHelper.getById(id: keywords[i].objectID)
        //let showEntry = dataHelper.getSeverityById(id: sev[i2].objectID)



        print("\(String(describing: keywords))")

        
    }
    
    //display top 3 biggest struggles after profile setup
    func displayUserKeywords() {
        let context = appDelegate.persistentContainer.viewContext
        let dataHelper = DataHelper(context: context)
        let keywords : [Keywords] = dataHelper.getAll()
        
        let rank1 =  userKeywords.keyword1
        let rank2 =  userKeywords.keyword2
        let rank3 =  userKeywords.keyword3
        
       if( keywords.index(where: { $0.ranking == 1}) != nil){
                
          for i in 1..<4 {
                    
            let place = keywords.index(where: { $0.ranking == i}) as! Int
            let item = dataHelper.getById(id: keywords[place].objectID)
            arrayTop3.append(item?.title as! String)
                
            }
        
        rank1?.text = arrayTop3[0]
        rank2?.text = arrayTop3[1]
        rank3?.text = arrayTop3[2]
        
        rank1?.textColor = blackColor
        rank2?.textColor = blackColor
        rank3?.textColor = blackColor
        
        }
        
       else {
        
        rank1?.text = ""
        rank2?.text = "No data yet ..."
        rank3?.text = ""
        
        rank1?.textColor = blackColor.withAlphaComponent(0.5)
        rank2?.textColor = blackColor.withAlphaComponent(0.5)
        rank3?.textColor = blackColor.withAlphaComponent(0.5)
        
        }
        
        rank1?.textAlignment = .center
        rank1?.font = fontMainRegular20
        rank1?.layer.opacity = 1
        
        rank2?.textAlignment = .center
        rank2?.font = fontMainRegular20
        rank2?.layer.opacity = 0.5
        
        rank3?.textAlignment = .center
        rank3?.font = fontMainRegular20
        rank3?.layer.opacity = 0.25
        
    }
    

    // CREATE STEP 1
    @objc func create1() {
        let vc1 = storyboard?.instantiateViewController(withIdentifier: "step1") as! ProfileCreate1ViewController
        self.navigationController?.pushViewController(vc1, animated: true)
        lbl.alpha = 0
    }
    
    // EDIT INFO
    @objc func editInfo() {
        let vcInfo = storyboard?.instantiateViewController(withIdentifier: "editInfo") as! ProfileEditInfoViewController
        self.navigationController?.pushViewController(vcInfo, animated: true)
        lbl.alpha = 0
    }
    
    // EDIT KEYWORDS
    @objc func editKeywords() {
        let vcKeywords = storyboard?.instantiateViewController(withIdentifier: "editKeywordRange") as! ProfileEditKeywords1ViewController
        self.navigationController?.pushViewController(vcKeywords, animated: true)
        lbl.alpha = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createHeaderMain()
        profileInfo()
        self.tabBarController?.tabBar.isHidden = false
        self.navigationItem.setHidesBackButton(true, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  

   
    
}

