//
//  MoodViewController.swift
//  journey
//
//  Created by sam de smedt on 25/03/2018.
//  Copyright © 2018 sam de smedt. All rights reserved.
//

import UIKit
import CoreData
import Highcharts


class MoodViewController: UIViewController, HIChartViewDelegate {
   
    @IBOutlet var viewMain: UIView!
    @IBOutlet weak var viewHeader: UIView!
    
    var scrollView = UIScrollView()
    var viewTopGradient = UIView()
    var viewGraph1 = UIView()
    var viewGraph2 = UIView()


    let  topGradientLayer = CAGradientLayer()
    let btnGradientLayer = CAGradientLayer()
    let  gradientLayer = CAGradientLayer()
    
    var configuration: [String: Any]!
    var chartType: String!
    var data: [String : Any]!
    var arrCategories = [String]()
    var arrMoods = ["1","2","3","4","5"]
    
    var arrCount = Array(repeating: 0, count: 5)

    var day = Array(repeating: 0, count: 24)
    var month = Array(repeating: 0, count: 31)
    var year = Array(repeating: 0, count: 12)
  
    var chartView1: HIChartView!
    var chartView2: HIChartView!


    let toolbar = Bundle.main.loadNibNamed("toolbarView", owner: nil, options: nil)?.first as! toolbarView
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    
   /* var day = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    var month = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    var year = [0,0,0,0,0,0,0,0,0,0,0,0]

     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.addSubview(scrollView)
        
        
        
        /*
        do {
            if let sourceName = self.configuration["source"] as? String,
                let sourcePath = Bundle.main.path(forResource: sourceName, ofType: "json"),
                let sourceData = try? Data(contentsOf: URL(fileURLWithPath: sourcePath)),
                let sourceJson = try JSONSerialization.jsonObject(with: sourceData) as? [String: Any] {
                self.data = sourceJson
            }
        } catch {
            print("Error deserializing JSON: \(error)")
        }
        
        */
        
        tabBarController?.selectedIndex = 0
        self.title = "MOOD"
        self.view.backgroundColor = whiteColor
        
        setUpView()
        
    }
    
    func setUpView() {
        
        // CONTENT
        scrollView.backgroundColor = lightGreyColor
        scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        scrollView.isScrollEnabled = true
        
        //set up a gradient at the top of the page to create a 3D effect
        viewTopGradient.clipsToBounds = false
        viewTopGradient.backgroundColor = UIColor.clear
        topGradientLayer.frame = CGRect(x: 0, y: 15, width: self.view.frame.size.width, height: (self.view.frame.size.height/3)/2)
        topGradientLayer.colors = [blackColor.withAlphaComponent(0.05).cgColor, UIColor.clear.cgColor]
        topGradientLayer.locations = [ 0.0, 1.0]
        
        setUpGraphView1()
        setUpGraphView2()
   
        
    }
    
    func setUpGraphView1() {
        
        viewGraph1.frame = CGRect(x: 15, y: 15, width: self.view.frame.size.width - 30, height: (self.view.frame.size.height  - (tabBarController?.tabBar.frame.size.height)!*2)/5*3 - 60)
        viewGraph1.backgroundColor = whiteColor
        
        // edit corner radius of the view
        viewGraph1.layer.cornerRadius = 25
        
        // add a drop shadow to the view
        gradientLayer.frame = viewGraph1.bounds
        gradientLayer.colors = [purpleColor.cgColor, blueColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        
        // add a drop shadow to the gradient layer
        viewGraph1.layer.shadowColor = blackColor.cgColor
        viewGraph1.layer.shadowOffset = CGSize(width: 6, height: 6)
        viewGraph1.layer.shadowOpacity = 0.05
        //viewGraph1.layer.shadowRadius = 5.0
        viewGraph1.layer.shadowRadius = 10.0
        
        // edit corner radius op the gradient layer
        gradientLayer.cornerRadius = 25
        
        
        viewGraph1.layer.addSublayer(gradientLayer)
        scrollView.addSubview(viewGraph1)
        
        setUpGraph1()
        
    }
    
    func setUpGraphView2() {
        
        viewGraph2.frame = CGRect(x: 15, y: viewGraph1.frame.size.height + 30, width: self.view.frame.size.width - 30, height: (self.view.frame.size.height  - (tabBarController?.tabBar.frame.size.height)!*2)/5*2 - 60)
        viewGraph2.backgroundColor = whiteColor
        
        // edit corner radius of the view
        viewGraph2.layer.cornerRadius = 25
        viewGraph2.layer.shadowColor = blackColor.cgColor
        viewGraph2.layer.shadowOffset = CGSize(width: 6, height: 6)
        viewGraph2.layer.shadowOpacity = 0.05
        //viewGraph1.layer.shadowRadius = 5.0
        viewGraph2.layer.shadowRadius = 10.0
        
        scrollView.addSubview(viewGraph2)
        
        setUpGraph2()
        
    }
    
    func setUpGraph1() {
        
        let lblGraph = UILabel()
        
        // Label
        
        lblGraph.text = "Evolution of your mood on time"
        lblGraph.frame = CGRect(x: 0, y: 15, width: viewGraph1.frame.size.width, height: 25)
        lblGraph.textColor = whiteColor
        lblGraph.textAlignment = .center
        lblGraph.font = fontLabel
        
        // Toolbar
        
        toolbar.frame = CGRect(x: 0, y: lblGraph.frame.size.height + 30, width: viewGraph1.frame.size.width, height: 44)
        toolbar.backgroundColor = UIColor.clear

        toolbar.segment.tintColor = whiteColor
        toolbar.segment.frame = CGRect(x: 15, y: 0, width: viewGraph1.frame.size.width - 30, height: 30)
        toolbar.segment.addTarget(self, action: #selector(self.actionSegment), for: .valueChanged)

        toolbar.toolbar.setBackgroundImage(UIImage(), forToolbarPosition: UIBarPosition.any,barMetrics: UIBarMetrics.default)

        toolbar.toolbar.setShadowImage(UIImage(), forToolbarPosition: UIBarPosition.any)
        
        
        
        // Chartview layout
        
   self.chartView1 = HIChartView(frame: CGRect(x: 15 + 30, y: lblGraph.frame.size.height + 15 + toolbar.frame.size.height + 30, width: viewGraph1.frame.size.width - 30 - 30, height: viewGraph1.frame.size.height - lblGraph.frame.size.height - toolbar.frame.size.height - 30*2))
        
        getDataTime(period: "day")
        
        chartView1.backgroundColor = UIColor.clear
        
     
        self.chartView1.delegate = self
        
        self.chartView1.viewController = self
        
        
        viewGraph1.addSubview(lblGraph)
        viewGraph1.addSubview(self.chartView1!)
        viewGraph1.addSubview(toolbar)
        
        let imgView1 = UIImageView()
        let imgView2 = UIImageView()
        let imgView3 = UIImageView()
        let imgView4 = UIImageView()
        let imgView5 = UIImageView()
        
        let sideView = UIView()
        let scale = self.chartView1.frame.size.height/5
        
        sideView.frame = CGRect(x: 0, y: lblGraph.frame.size.height + 15 + toolbar.frame.size.height + 30, width: 30, height: chartView1.frame.size.height)
        
        
        imgView1.image = UIImage(named: "ic_mood5_white")
        imgView2.image = UIImage(named: "ic_mood4_white")
        imgView3.image = UIImage(named: "ic_mood3_white")
        imgView4.image = UIImage(named: "ic_mood2_white")
        imgView5.image = UIImage(named: "ic_mood1_white")
        
        imgView1.frame = CGRect(x: 15, y: 0, width: 30, height: 30)
        imgView2.frame = CGRect(x: 15, y: scale, width: 30, height: 30)
        imgView3.frame = CGRect(x: 15, y: scale*2, width: 30, height: 30)
        imgView4.frame = CGRect(x: 15, y: scale*3, width: 30, height: 30)
        imgView5.frame = CGRect(x: 15, y: scale*4, width: 30, height: 30)
        
        
        sideView.addSubview(imgView1)
        sideView.addSubview(imgView2)
        sideView.addSubview(imgView3)
        sideView.addSubview(imgView4)
        sideView.addSubview(imgView5)
        
        viewGraph1.addSubview(sideView)
        
        
    }
    
    func setUpGraph2() {
        
        let lblGraph = UILabel()
        
        // Label
        lblGraph.text = "Mood count"
        lblGraph.frame = CGRect(x: 0, y: 15, width: viewGraph2.frame.size.width, height: 25)
        lblGraph.textColor = blackColor
        lblGraph.textAlignment = .center
        lblGraph.font = fontLabel
    
        
        // Chartview layout
        self.chartView2 = HIChartView(frame: CGRect(x: 15, y: lblGraph.frame.size.height, width: viewGraph2.frame.size.width - 30, height: viewGraph2.frame.size.height - lblGraph.frame.size.height - 15))
        
        getDataCount()
        chartView2.backgroundColor = UIColor.clear
        
    
        self.chartView2.delegate = self
        self.chartView2.viewController = self
        
        viewGraph2.addSubview(lblGraph)
        viewGraph2.addSubview(self.chartView2!)
        
        let imgView1 = UIImageView()
        let imgView2 = UIImageView()
        let imgView3 = UIImageView()
        let imgView4 = UIImageView()
        let imgView5 = UIImageView()
        let bottomView = UIView()
        
        let scale = (self.chartView2.frame.size.width - 35)/5
        let height = lblGraph.frame.size.height + self.chartView2.frame.size.height - 25
        
        bottomView.frame = CGRect(x: 55, y: height, width: self.chartView2.frame.size.width, height: 30)
        
        bottomView.backgroundColor = UIColor.clear
        
        imgView1.image = UIImage(named: "ic_mood5_outline")
        imgView2.image = UIImage(named: "ic_mood4_outline")
        imgView3.image = UIImage(named: "ic_mood3_outline")
        imgView4.image = UIImage(named: "ic_mood2_outline")
        imgView5.image = UIImage(named: "ic_mood1_outline")
        
        imgView1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        imgView2.frame = CGRect(x: scale, y: 0, width: 30, height: 30)
        imgView3.frame = CGRect(x: scale*2, y: 0, width: 30, height: 30)
        imgView4.frame = CGRect(x: scale*3, y: 0, width: 30, height: 30)
        imgView5.frame = CGRect(x: scale*4, y: 0, width: 30, height: 30)
        
        
        bottomView.addSubview(imgView1)
        bottomView.addSubview(imgView2)
        bottomView.addSubview(imgView3)
        bottomView.addSubview(imgView4)
        bottomView.addSubview(imgView5)
        
        viewGraph2.addSubview(bottomView)
        
        
    }
    
    //MARK: - Data functions
    
    func getDataTime(period: String) {
        
        arrCategories.removeAll()
        
        var strScale = String()

        var strSuffix = String()

        var arrayData: [Int]!
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        formatter.locale = Locale(identifier: "en_GB")
        
        let formatterToMonth = DateFormatter()
        formatterToMonth.dateFormat = "MMM"
        formatterToMonth.locale = Locale(identifier: "en_GB")
        
        let formatterPeriod = DateFormatter()
        let formatterScale = DateFormatter()
        
        
        let now = Date()
        
        if(period == "day"){
            formatterPeriod.dateFormat = "HH"
            formatterScale.dateFormat = "dd"
            
            strScale = formatterScale.string(from: now)

            strSuffix = "h"
            arrayData = day
        }
        
        if(period == "month"){
            formatterPeriod.dateFormat = "dd"
            formatterScale.dateFormat = "MM"
            
            strScale = formatterScale.string(from: now)
            
            let toDate = formatter.date(from:  "\(strScale)/01/1999")
            let toCurrentMonth = formatterToMonth.string(from: toDate!)
            
            strSuffix = " " + toCurrentMonth
            arrayData = month
        }
        
        if(period == "year"){
            formatterPeriod.dateFormat = "MM"
            formatterScale.dateFormat = "yyyy"
            
            strScale = formatterScale.string(from: now)
            
            strSuffix = ""
            arrayData = year
        }
        
        formatterPeriod.locale = Locale(identifier: "en_GB")
        formatterScale.locale = Locale(identifier: "en_GB")

        
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequestEntries = NSFetchRequest<Entries>(entityName: "Entries")
        
        let primarySortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequestEntries.sortDescriptors = [primarySortDescriptor]
        let allEntries = try! context.fetch(fetchRequestEntries)
        
        
        var averagePerHour = [Int]()
        var i = Int()
        var position = Int()

        
        for entry in allEntries {
            
            let entryPeriod = formatterPeriod.string(from: entry.date)
            let entryScale = formatterScale.string(from: entry.date)
            
            

            if(entryScale == strScale){
                
                let moodInt = Int(entry.mood)
                position = Int(entryPeriod)!
                
                
                if(position == i){
                    averagePerHour.append(moodInt)
                    
                    let sumArray = averagePerHour.reduce(0, +)
                    let avgArrayValue = sumArray / Int(averagePerHour.count)
                    let averageMoodInt = Int(avgArrayValue)
                    
                    arrayData[position] = Int(averageMoodInt)

                }
                
                else{
                    averagePerHour.removeAll()
                    averagePerHour.append(moodInt)

                    arrCategories.append("\(position)" + strSuffix)
                    arrayData[position] = moodInt
                    
                }
                
                
                i = Int(entryPeriod)!
                
                
                
                
            }
            
            
        }
        
        if(period == "year"){
            
            for (index, element) in arrCategories.enumerated() {
                
                let formatterToYear = DateFormatter()
                formatterToYear.dateFormat = "yyyy"
                formatterToYear.locale = Locale(identifier: "en_GB")
                
                let toMonth = formatter.date(from:  "\(element)/01/1999")
                let toString = formatterToMonth.string(from: toMonth!)
                
                let toYear = formatter.date(from:  "01/01/\(strScale)")
                let toCurrentYear = formatterToYear.string(from: toYear!)
                
                arrCategories[index] = toString + " " + toCurrentYear
                
            }
            
           
        }
        
        //print("arrCategories: \(String(describing: arrCategories))")
        //print("arrayData: \(String(describing: arrayData))")
        
        self.chartView1.options = OptionsProvider.provideOptions(forChartType: "spline", series: arrayData.filter {$0 != 0}, xValues: arrCategories)
        

    }
    
    func getDataCount() {
        
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequestEntries = NSFetchRequest<Entries>(entityName: "Entries")
        
        
        let allEntries = try! context.fetch(fetchRequestEntries)
        
        for entry in allEntries {
            
            switch entry.mood {
            case 1:
                arrCount[0] += 1
            case 2:
                arrCount[1] += 1
            case 3:
                arrCount[2] += 1
            case 4:
                arrCount[3] += 1
            default:
                arrCount[4] += 1
            
            }
    

            
     self.chartView2.options = OptionsProvider.provideOptions(forChartType: "column", series: arrCount, xValues: arrMoods)
            
            
        }
        
    }
    
    //MARK: - Actions

    @IBAction func actionSegment(_ sender: UISegmentedControl) {
    

        switch sender.selectedSegmentIndex {
        case 0:
    
            getDataTime(period: "day")
        case 1:
            getDataTime(period: "month")
        case 2:
           getDataTime(period: "year")
        default:
            break
        }
        
    }
    
    /*
    @IBAction func actionSegment(_ sender: UISegmentedControl) {
        var dataName: String = "day"
        var arrayData: [Int]!
        
        switch sender.selectedSegmentIndex {
        case 0:
            dataName = "day"
            arrayData = day
            getDataTime(period: "day")
        case 1:
            dataName = "month"
            arrayData = month
        case 2:
            dataName = "year"
            arrayData = year
        default:
            break
        }
     }
        
        // self.chartView.options = OptionsProvider.provideOptions(forChartType: "spline", series: arrayData.filter {$0 != 0}, type: dataName, xValues: arrCategories)
        
     */
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        getDataTime(period: "day")
    }

    //MARK: - HIChartViewDelegate
    
    func chartViewDidLoad(_ chart: HIChartView!) {
       // print("Did load chart \(chart!)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

