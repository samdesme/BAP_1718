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

    let  topGradientLayer = CAGradientLayer()
    let btnGradientLayer = CAGradientLayer()
    let  gradientLayer = CAGradientLayer()
    
    var configuration: [String: Any]!

    var chartType: String!
    
    var data: [String : Any]!
    
    var arrCategories = [String]()


  
    var chartView: HIChartView!

    let toolbar = Bundle.main.loadNibNamed("toolbarView", owner: nil, options: nil)?.first as! toolbarView
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    
    var day = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    var month = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    var year = [0,0,0,0,0,0,0,0,0,0,0,0]


    
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
   
        
    }
    
    func setUpGraphView1() {
        
        viewGraph1.frame = CGRect(x: 15, y: 15, width: self.view.frame.size.width - 30, height: (scrollView.frame.size.height/2))
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
    
    func setUpGraph1() {
        
        let lblGraph1 = UILabel()
        
        // Label
        
        lblGraph1.text = "Evolution of your mood on time"
        lblGraph1.frame = CGRect(x: 0, y: 15, width: viewGraph1.frame.size.width, height: 25)
        lblGraph1.textColor = whiteColor
        lblGraph1.textAlignment = .center
        lblGraph1.font = fontLabel
        
        // Toolbar
        
        toolbar.frame = CGRect(x: 0, y: lblGraph1.frame.size.height + 30, width: viewGraph1.frame.size.width, height: 44)
        toolbar.backgroundColor = UIColor.clear

        toolbar.segment.tintColor = whiteColor
        toolbar.segment.frame = CGRect(x: 15, y: 0, width: viewGraph1.frame.size.width - 30, height: 30)
        toolbar.segment.addTarget(self, action: #selector(self.actionSegment), for: .valueChanged)

        toolbar.toolbar.setBackgroundImage(UIImage(), forToolbarPosition: UIBarPosition.any,barMetrics: UIBarMetrics.default)

        toolbar.toolbar.setShadowImage(UIImage(), forToolbarPosition: UIBarPosition.any)
        
        
        
        // Chartview layout
        
        self.chartView = HIChartView(frame: viewGraph1.bounds)
        getData(period: "day")
        chartView.backgroundColor = UIColor.clear
        
        self.chartView = HIChartView(frame: CGRect(x: 15 + 30, y: lblGraph1.frame.size.height + 15 + toolbar.frame.size.height + 30, width: viewGraph1.frame.size.width - 30 - 30, height: viewGraph1.frame.size.height - lblGraph1.frame.size.height - toolbar.frame.size.height - 30*2))
        self.chartView.delegate = self
        
        self.chartView.viewController = self
        
        
        viewGraph1.addSubview(lblGraph1)
        viewGraph1.addSubview(self.chartView!)
        viewGraph1.addSubview(toolbar)
        
        let imgView1 = UIImageView()
        let imgView2 = UIImageView()
        let imgView3 = UIImageView()
        let imgView4 = UIImageView()
        let imgView5 = UIImageView()
        let yView = UIView()
        let scale = self.chartView.frame.size.height/5
        
        yView.frame = CGRect(x: 0, y: lblGraph1.frame.size.height + 15 + toolbar.frame.size.height + 30, width: 30, height: chartView.frame.size.height)
        
        
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
        
        
        yView.addSubview(imgView1)
        yView.addSubview(imgView2)
        yView.addSubview(imgView3)
        yView.addSubview(imgView4)
        yView.addSubview(imgView5)
        
        viewGraph1.addSubview(yView)
        
        
    }
    
    
    //MARK: - Data functions
    
    func getData(period: String) {
        
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
            
            print("entryScale: \(String(describing: entryScale))")
            print("strScale: \(String(describing: strScale))")
            print("-----")

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
        
        self.chartView.options = OptionsProvider.provideOptions(forChartType: "spline", series: arrayData.filter {$0 != 0}, type: "\(period)", xValues: arrCategories)
        
       


    }
    
    //MARK: - Actions

    @IBAction func actionSegment(_ sender: UISegmentedControl) {
    

        switch sender.selectedSegmentIndex {
        case 0:
    
            getData(period: "day")
        case 1:
            getData(period: "month")
        case 2:
           getData(period: "year")
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
            getData(period: "day")
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
        
        getData(period: "day")
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

