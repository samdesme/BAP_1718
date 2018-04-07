//
//  ProfileCreate1ViewController.swift
//  journey
//
//  Created by sam de smedt on 02/04/2018.
//  Copyright © 2018 sam de smedt. All rights reserved.
//

import UIKit

class ProfileCreate1ViewController: UIViewController {
    
    //OUTLET REFERENTIONS
    @IBOutlet var viewStep1: UIView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var backButtonItem: UINavigationItem!
    
    //VARIABLES
    
    //strings
    let strHeaderCreate1 = "step 1"
    let strHeader = "profile"
    
    //labels
    let lblSub = UILabel()
    let lblMain = UILabel()
    let rect = CGRect()
    
    
    //Load view controller
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // View loads from viewWillAppear()
    }
    
    func viewCreate1() {
        self.view.backgroundColor = whiteColor
        createHeaderSub()
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
        let _ = self.navigationController?.popViewController(animated: true)
        lblSub.removeFromSuperview()
        createHeaderMain()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        viewCreate1()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
