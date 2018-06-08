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
    var arrayData: [Int]!

    var data: [String : Any]!
    var chartView: HIChartView!

    let toolbar = Bundle.main.loadNibNamed("toolbarView", owner: nil, options: nil)?.first as! toolbarView
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    
    var day = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    let week = [13,9,20,5,25,12,6,13,25,11,20,2,26,5,7,20,19]
    let month = [6,14,20,15,5,12,16,3,25,25,20,3,20,20,10,20,9]
    let year = [3,9,11,5,11,12,6,11,25,1,20,2,26,21,7,13,10]


    
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
        
        getData()
        
        self.chartView = HIChartView(frame: viewGraph1.bounds)
        chartView.backgroundColor = UIColor.clear
        
        self.chartView = HIChartView(frame: CGRect(x: 15, y: lblGraph1.frame.size.height + 15 + toolbar.frame.size.height + 30, width: viewGraph1.frame.size.width - 30, height: viewGraph1.frame.size.height - lblGraph1.frame.size.height - toolbar.frame.size.height - 30*2))
        self.chartView.delegate = self
        
        self.chartView.options = OptionsProvider.provideOptions(forChartType: "spline", series: day, type: "day")
        self.chartView.viewController = self
        
        
        viewGraph1.addSubview(lblGraph1)
        viewGraph1.addSubview(self.chartView!)
        viewGraph1.addSubview(toolbar)
    }
    
    
    //MARK: - Data functions
    
    func getData() {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        formatter.locale = Locale(identifier: "en_GB")
        
        let formatterTime = DateFormatter()
        formatterTime.dateFormat = "HH"
        formatterTime.locale = Locale(identifier: "en_GB")
        
        let now = Date()
        let todayDateStr = formatter.string(from: now)
        
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequestEntries = NSFetchRequest<Entries>(entityName: "Entries")
        
        let primarySortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequestEntries.sortDescriptors = [primarySortDescriptor]
        let allEntries = try! context.fetch(fetchRequestEntries)
        
        
        var averagePerHour = [Int]()
        var i = Int()
        var position = Int()

        
        for entry in allEntries {
            
        
            let entryDate = formatter.string(from: entry.date)
            let entryHour = formatterTime.string(from: entry.date)
            
            
            
            if(entryDate == todayDateStr){
                
                
                position = Int(entryHour)!
                
                if(position == i){
                    averagePerHour.append(Int(entry.mood))
                    
                    let sumArray = averagePerHour.reduce(0, +)
                    let avgArrayValue = sumArray / Int(averagePerHour.count)
                    let averageMoodInt = Int(avgArrayValue)
                    
                    day[position] = Int(averageMoodInt)
                    
                    print("if: \(String(describing: Int(entry.mood) ))")


                }
                
                else{
                    averagePerHour.removeAll()
                    averagePerHour.append(Int(entry.mood))

                    day[position] = Int(entry.mood)
                    print("else: \(String(describing: Int(entry.mood) ))")

                }
                
                
                
                i = Int(entryHour)!

                /*
                if(day[position] != 0){
                    
                    averagePerHour.removeAll()
                    averagePerHour.append(Int(entry.mood))
                    
                    let sumArray = averagePerHour.reduce(0, +)
                    let avgArrayValue = sumArray / Int(averagePerHour.count)
                    let averageMoodInt = Int(avgArrayValue)
                    
                    day[position] = Int(averageMoodInt)
                    
                }
                
                else {
                    day[position] = Int(Int(entry.mood))
                    averagePerHour.append(Int(entry.mood))
                }
                */
                
                //calculate the average mood
                /*
                let sumArray = averagePerHour.reduce(0, +)
                let avgArrayValue = sumArray / Int(averagePerHour.count)
                let averageMoodInt = Int(avgArrayValue)
                */
                
                
               
                
               
                
                

          /*
                
                let position = Int(entryHour)

                
                if(i == position){
                    averagePerHour.append(Int(entry.mood))

                    
                }
                else if(i == 0){
                    
                    averagePerHour.append(Int(entry.mood))

                    
                }
                else{

                    //calculate the average mood
                    let sumArray = averagePerHour.reduce(0, +)
                    let avgArrayValue = sumArray / Int(averagePerHour.count)
                    let averageMoodInt = Int(avgArrayValue)
                    

                    
                    day[i] = Int(averageMoodInt)
                    
                
                
                    
                    
                    averagePerHour.removeAll()
                    
                    averagePerHour.append(Int(entry.mood))

                    
                }
                

                i = position!
                */
                
                
                
            }
            
            
        }
        
        print("\(String(describing: day ))")

    }
    
    //MARK: - Actions

    @IBAction func actionSegment(_ sender: UISegmentedControl) {
        var dataName: String = "day"
        
        switch sender.selectedSegmentIndex {
        case 0:
            dataName = "day"
            arrayData = day
        case 1:
            dataName = "week"
            arrayData = week

        case 2:
            dataName = "month"
            arrayData = month

        case 3:
            dataName = "year"
            arrayData = year
        default:
            break
        }
        
        
        self.chartView.options = OptionsProvider.provideOptions(forChartType: "spline", series: arrayData, type: dataName)
        
    }
    
    
    //MARK: - HIChartViewDelegate
    
    func chartViewDidLoad(_ chart: HIChartView!) {
        print("Did load chart \(chart!)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

