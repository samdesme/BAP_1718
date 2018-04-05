//
//  ProfileCreate1ViewController.swift
//  journey
//
//  Created by sam de smedt on 02/04/2018.
//  Copyright © 2018 sam de smedt. All rights reserved.
//

import UIKit

class ProfileCreate1ViewController: UIViewController {
    
    @IBOutlet var viewStep1: UIView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var backButtonItem: UINavigationItem!
    
    //VARIABLES
    let strHeaderCreate1 = "step 1"
    
    let lbl = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        viewCreate1()
    
    }
    func viewCreate1() {
        
        self.view.backgroundColor = whiteColor
        createHeaderSub()
        
        
        
    }
    
    func createHeaderSub() {
        
        //variables
        let navBar = navigationController?.navigationBar
        let frameTitle = CGRect(x: 0, y: 0, width: (navBar?.frame.width)!, height: (viewHeader.frame.height))
        lbl.frame = frameTitle
        //lbl.backgroundColor = blueColor
        
        //Create navigation bar
        lbl.text = strHeaderCreate1.uppercased()
        lbl.font = fontHeaderMain
        lbl.textAlignment = .center
       
        navBar?.addSubview(lbl)
        addBackButton()
        
    }
    
    func addBackButton() {
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "btnBackWhite.png"), for: .normal)
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(whiteColor, for: .normal)
        backButton.addTarget(self, action: #selector(self.backAction(_:)), for: .touchUpInside)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
