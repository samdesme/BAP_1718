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
    
    //view
    let create2 = Bundle.main.loadNibNamed("CreateStep2", owner: nil, options: nil)?.first as! CreateStep2
    
    //labels
    let lblSub = UILabel()


    //Load view controller
    override func viewDidLoad() {
        super.viewDidLoad()
        viewCreate2()
        setupPageControl()
        
    }
    
    func viewCreate2() {
        viewContent.backgroundColor = whiteColor
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    func addKeyword() {
        
    }
    
    func createHeaderSub() {
        
        //variables
        let navBar = navigationController?.navigationBar
        let frameTitle = CGRect(x: 0, y: 0, width: (navBar?.frame.width)!, height: (navBar?.frame.height)!)
        lblSub.frame = frameTitle
        
        //Create navigation bar for sub views
        navBar?.barStyle = .blackTranslucent
        navBar?.applyNavigationGradient(colors: [blueColor , lightBlueColorHeader])
        lblSub.text = strHeaderCreate2.uppercased()
        lblSub.font = fontHeaderSub
        lblSub.textColor = whiteColor
        lblSub.textAlignment = .center
        
        navBar?.addSubview(lblSub)
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
        let _ = self.navigationController?.popViewController(animated: true)
        lblSub.removeFromSuperview()
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

