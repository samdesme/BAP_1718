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
    var chartView: HIChartView!

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
        
        viewGraph1.frame = CGRect(x: 15, y: 15, width: self.view.frame.size.width - 30, height: (self.view.frame.size.height/3))
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
        
        let day = [
        16,
        14,
        20,
        15,
        25,
        12,
        16,
        13,
        25,
        25,
        20,
        23,
        26,
        25,
        17,
        20,
        19
        ]
        
        
        self.chartView = HIChartView(frame: viewGraph1.bounds)
        chartView.backgroundColor = UIColor.clear
        
        self.chartView = HIChartView(frame: CGRect(x: 5.0, y: 5.0, width: self.view.frame.size.width - 20, height: 240.0))
        self.chartView.delegate = self
        
        
        self.chartView.options = OptionsProvider.provideOptions(forChartType: "spline", series: day, type: "day")
        self.chartView.viewController = self
        
        viewGraph1.addSubview(self.chartView!)
    }
    
    func setUpGraphJson() {
        
        self.chartView = HIChartView(frame: viewGraph1.bounds)
        chartView.backgroundColor = UIColor.clear
        
        var tmpOptions = self.configuration!
        tmpOptions["exporting"] = true
        
        self.chartView = HIChartView(frame: CGRect(x: 5.0, y: 5.0, width: self.view.frame.size.width - 20, height: 240.0))
        self.chartView.delegate = self
        
        let series = self.data["day"] as! [Int]
        var sum: Int = 0
        for number in series {
            sum += number
        }
        
        tmpOptions["subtitle"] = "\(sum) \(tmpOptions["unit"]!)"
        
        //self.chartView.options = OptionsProvider.provideOptions(forChartType: tmpOptions, series: series, type: "day")
        self.chartView.viewController = self
        
        viewGraph1.addSubview(self.chartView!)
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

