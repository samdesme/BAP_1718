//
//  CalendarViewController.swift
//  journey
//
//  Created by sam de smedt on 27/04/2018.
//  Copyright © 2018 sam de smedt. All rights reserved.
//

import UIKit
import FSCalendar
import CoreData


class CalendarViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate {
    
    
    @IBOutlet var viewMain: UIView!
    var tableView: UITableView = UITableView()
    var selectedDate : String = ""
    var dateToSave = Date()
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var viewHeader: UIView!
    
    var datePicker = UIDatePicker()

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var listTask:[Events] = []
    var alert = UIAlertController()

    let  topGradientLayer = CAGradientLayer()
    let btnGradientLayer = CAGradientLayer()
    let  gradientLayer = CAGradientLayer()
    
     var scrollView = UIScrollView()
    
    var viewTopGradient = UIView()
    var viewCalendar = UIView()
    var viewTableContainer = UIView()
    var viewEntryCount = UIView()
    var viewTaskCount = UIView()
    var viewGoalCount = UIView()

    
    fileprivate lazy var scopeGesture: UIPanGestureRecognizer = {
        [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: self.calendar, action: #selector(self.calendar.handleScopeGesture(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.addSubview(scrollView)
        tableView.register(UINib(nibName: "eventCell", bundle: nil), forCellReuseIdentifier: "eventCell")
        createCalendarView()
        tabBarController?.selectedIndex = 0
        
        self.title = "CALENDAR"
        self.view.backgroundColor = whiteColor
        self.view.isUserInteractionEnabled = true
          fetchData()
        
    }
    
    func createCalendarView() {
        
        // CONTENT
        scrollView.backgroundColor = lightGreyColor
        scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        scrollView.isScrollEnabled = true
        

        
        let currentDate = Date()  //5 -  get the current date
        datePicker.minimumDate = currentDate  //6- set the current date/time as a minimum
        datePicker.date = currentDate //7 - defaults to current time but shows how to use it.

        //set up a gradient at the top of the page to create a 3D effect
        viewTopGradient.clipsToBounds = false
        viewTopGradient.backgroundColor = UIColor.clear
        topGradientLayer.frame = CGRect(x: 0, y: 15, width: self.view.frame.size.width, height: (self.view.frame.size.height/3)/2)
        topGradientLayer.colors = [blackColor.withAlphaComponent(0.05).cgColor, UIColor.clear.cgColor]
        topGradientLayer.locations = [ 0.0, 1.0]
        
        createCalendar()
        setUpTableView()
        setUpEntryCount()
        setUpTaskCount()
        setUpGoalCount()

    }
    
    func printEvents() {
        let context = appDelegate.persistentContainer.viewContext
        let dataHelper = DataHelper(context: context)
        let events : [Events] = dataHelper.getAllEvents()
        print("ALL EVENTS -----------------------")
        print(events)
        print("END ALL EVENTS -----------------------")
    }
    
    func createCalendar() {
        
        viewCalendar.frame = CGRect(x: 15, y: 15, width: self.view.frame.size.width - 30, height: (self.view.frame.size.height/3))
        viewCalendar.backgroundColor = whiteColor
        
        // edit corner radius of the view
        viewCalendar.layer.cornerRadius = 25
        
        // add a drop shadow to the view
        gradientLayer.frame = viewCalendar.bounds
        gradientLayer.colors = [purpleColor.cgColor, blueColor.cgColor]
        
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        
        // add a drop shadow to the gradient layer
        viewCalendar.layer.shadowColor = blackColor.cgColor
        viewCalendar.layer.shadowOffset = CGSize(width: 6, height: 6)
        viewCalendar.layer.shadowOpacity = 0.05
        //viewCalendar.layer.shadowRadius = 5.0
        viewCalendar.layer.shadowRadius = 10.0
        
        // edit corner radius op the gradient layer
        gradientLayer.cornerRadius = 25
        
        gradientLayer.frame = CGRect(x: 15, y: 15, width: self.view.frame.size.width - 30, height: (self.view.frame.size.height/3))
        
        viewCalendar.layer.addSublayer(gradientLayer)
        
        viewCalendar.bounds = viewCalendar.frame.insetBy(dx: 20.0, dy: 0.0)
        
        let calendar = FSCalendar(frame: viewCalendar.bounds)
        
        calendar.appearance.weekdayTextColor = whiteColor
        calendar.appearance.headerTitleColor = whiteColor
        calendar.appearance.titleDefaultColor = whiteColor
        //calendar.appearance.titlePlaceholderColor = whiteColor.withAlphaComponent(0.5)
        calendar.showsPlaceholders = false
        
        calendar.appearance.titleSelectionColor = whiteColor
        
        calendar.weekdayHeight = 30
        calendar.appearance.selectionColor = UIColor.clear
        
        calendar.appearance.titleTodayColor = blueColor
        calendar.appearance.todayColor = whiteColor
        
        calendar.appearance.borderSelectionColor = whiteColor
        calendar.firstWeekday = 2
        
        calendar.appearance.titleFont = font17Med
        calendar.appearance.headerTitleFont = font18Med
        
        calendar.appearance.weekdayFont = fontHeaderMain
        calendar.appearance.weekdayTextColor = whiteColor

        calendar.appearance.useVeryShortWeekdaySymbols = true
        calendar.bottomBorder.alpha = 0
        
        calendar.dataSource = self
        calendar.delegate = self
        viewCalendar.insertSubview(calendar, at: 1)
        self.calendar = calendar
        
        calendar.select(Date())
        calendar.accessibilityIdentifier = "calendar"
    
        //add gradient layer to UIView
        scrollView.addSubview(viewCalendar)
    }
    
    func setUpTableView() {

        let btnAdd = UIButton()

        //containerview fot tableview
        viewTableContainer.frame = CGRect(x: 15, y: 15 + viewCalendar.frame.size.height + 15, width: self.view.frame.size.width - 30, height: viewCalendar.frame.size.height/1.5)
        viewTableContainer.clipsToBounds = false
        viewTableContainer.backgroundColor = whiteColor
        viewTableContainer.layer.cornerRadius = 25
        viewTableContainer.layer.shadowColor = blackColor.cgColor
        viewTableContainer.layer.shadowOffset = CGSize(width: 6, height: 6)
        viewTableContainer.layer.shadowOpacity = 0.05
        viewTableContainer.layer.shadowRadius = 10.0
        
        scrollView.addSubview(viewTableContainer)
        
        tableView.frame = CGRect(x: 0, y: 0, width: viewTableContainer.bounds.width, height: viewTableContainer.bounds.height - 75)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = true
        tableView.layer.cornerRadius = 25
        tableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        viewTableContainer.addSubview(tableView)
 
        // UIButton: Add Event
        btnAdd.addTarget(self,action:#selector(addEvent), for:.touchUpInside)
        btnAdd.frame = CGRect(x: (viewTableContainer.frame.size.width - 200)/2, y: viewTableContainer.bounds.height - 45 - 15, width: 200, height: 45)
        
        // add gradient to button
        btnGradientLayer.frame = CGRect(x: 0, y: 0, width: 200, height: 45)
        btnGradientLayer.colors = [blueColor.cgColor, lightBlueColor.cgColor]
        btnGradientLayer.locations = [ 0.0, 1.0]
        btnGradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        btnGradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        btnGradientLayer.cornerRadius = 22.5
        
        btnAdd.layer.addSublayer(btnGradientLayer)
        btnAdd.setTitle("Add",for: .normal)
        btnAdd.tintColor = whiteColor
        btnAdd.titleLabel?.font = fontBtnSmall
        
        viewTableContainer.addSubview(btnAdd)

    }
    
    func setUpEntryCount() {
        
        let btnViewEntries = UIButton()
        let y = 30 + viewCalendar.frame.size.height + viewCalendar.frame.size.height/1.5 + 15
        let btnViewGradient = CAGradientLayer()
        let entryIcon = UIView()
        let entryCounter = UIView()
        let lblIcon = UILabel()
        let lblCounter = UILabel()

        //containerview fot tableview
        viewEntryCount.frame = CGRect(x: 15, y: y, width: self.view.frame.size.width - 30, height: viewCalendar.frame.size.height/1.5)
        viewEntryCount.clipsToBounds = false
        viewEntryCount.backgroundColor = whiteColor
        viewEntryCount.layer.cornerRadius = 25
        viewEntryCount.layer.shadowColor = blackColor.cgColor
        viewEntryCount.layer.shadowOffset = CGSize(width: 6, height: 6)
        viewEntryCount.layer.shadowOpacity = 0.05
        viewEntryCount.layer.shadowRadius = 10.0
        
        scrollView.addSubview(viewEntryCount)
        
        // UIButton: Add Event
        btnViewEntries.addTarget(self,action:#selector(toEntries), for:.touchUpInside)
        btnViewEntries.frame = CGRect(x: (viewTableContainer.frame.size.width - 200)/2, y: viewEntryCount.bounds.height - 45 - 15, width: 200, height: 45)
        
        // add gradient to button
        btnViewGradient.frame = CGRect(x: 0, y: 0, width: 200, height: 45)
        btnViewGradient.colors = [blueColor.cgColor, lightBlueColor.cgColor]
        btnViewGradient.locations = [ 0.0, 1.0]
        btnViewGradient.startPoint = CGPoint(x: 0, y: 0.5)
        btnViewGradient.endPoint = CGPoint(x: 1, y: 0.5)
        btnViewGradient.cornerRadius = 22.5
        
        btnViewEntries.layer.addSublayer(btnViewGradient)
        
        btnViewEntries.setTitle("View",for: .normal)
        btnViewEntries.tintColor = whiteColor
        btnViewEntries.titleLabel?.font = fontBtnSmall
        
        entryIcon.frame = CGRect(x: 0, y: 0, width: viewEntryCount.frame.size.width/2, height: viewEntryCount.frame.size.height - 60)
        entryIcon.backgroundColor = UIColor.clear
        entryIcon.addBorder(toSide: .Right, withColor: blackColor.cgColor, andThickness: 0.5)
        
        let aspect = viewEntryCount.frame.size.height - 45
        
        lblIcon.frame = CGRect(x: 0, y: 0, width: entryIcon.frame.size.width, height: aspect/3)
        lblIcon.textAlignment = .center
        lblIcon.font = fontMainLight
        lblIcon.text = "Overall Mood"
        
        let imgMood = UIImage(named: "ic_mood4")
        let imgMoodView = UIImageView(image: imgMood)
        imgMoodView.frame = CGRect(x: (entryIcon.frame.size.width - 60)/2, y: (aspect - 45)/2, width: 60, height: 60)

        entryIcon.addSubview(imgMoodView)
        entryIcon.addSubview(lblIcon)
        viewEntryCount.addSubview(entryIcon)
        
        entryCounter.frame = CGRect(x: viewEntryCount.frame.size.width/2, y: 0, width: viewEntryCount.frame.size.width/2, height: viewEntryCount.frame.size.height)
        entryCounter.backgroundColor = UIColor.clear
        lblCounter.frame = CGRect(x: 0, y: 0, width: entryCounter.frame.size.width, height: viewEntryCount.frame.size.height/4)
        lblCounter.textAlignment = .center
        lblCounter.font = fontMainLight
        lblCounter.text = "Entries"
        
        let lblCount = UILabel()
        lblCount.text = "4"
        lblCount.textAlignment = .center
        lblCount.font = fontCounter
        lblCount.textColor = purpleColor
        lblCount.frame = CGRect(x: (entryIcon.frame.size.width - 60)/2, y: (aspect - 45)/2, width: 60, height: 60)
        
        entryCounter.addSubview(lblCount)
        entryCounter.addSubview(lblCounter)
        viewEntryCount.addSubview(entryCounter)
        
        viewEntryCount.addSubview(btnViewEntries)
        
    }
    
    func setUpTaskCount() {
        
        let btnViewTaskManager = UIButton()
        let y = 30 + viewCalendar.frame.size.height + viewCalendar.frame.size.height/1.5 + 15 + viewEntryCount.frame.size.height + 15
        let btnViewGradient2 = CAGradientLayer()
        
        //containerview fot tableview
        viewTaskCount.frame = CGRect(x: 15, y: y, width: (viewEntryCount.frame.size.width/2) - 7.5, height: viewEntryCount.frame.size.height)
        viewTaskCount.clipsToBounds = false
        viewTaskCount.backgroundColor = whiteColor
        viewTaskCount.layer.cornerRadius = 25
        viewTaskCount.layer.shadowColor = blackColor.cgColor
        viewTaskCount.layer.shadowOffset = CGSize(width: 6, height: 6)
        viewTaskCount.layer.shadowOpacity = 0.05
        viewTaskCount.layer.shadowRadius = 10.0
        
        scrollView.addSubview(viewTaskCount)
        
        // UIButton: Add Event
        btnViewTaskManager.addTarget(self,action:#selector(addEvent), for:.touchUpInside)
        btnViewTaskManager.frame = CGRect(x: 15, y: viewTaskCount.bounds.height - 45 - 15, width: viewTaskCount.frame.size.width - 30, height: 45)
        
        // add gradient to button
        btnViewGradient2.frame = CGRect(x: 0, y: 0, width: btnViewTaskManager.frame.size.width, height: 45)
        btnViewGradient2.colors = [blueColor.cgColor, lightBlueColor.cgColor]
        btnViewGradient2.locations = [ 0.0, 1.0]
        btnViewGradient2.startPoint = CGPoint(x: 0, y: 0.5)
        btnViewGradient2.endPoint = CGPoint(x: 1, y: 0.5)
        btnViewGradient2.cornerRadius = 22.5
        
        btnViewTaskManager.layer.addSublayer(btnViewGradient2)
        
        btnViewTaskManager.setTitle("View",for: .normal)
        btnViewTaskManager.tintColor = whiteColor
        btnViewTaskManager.titleLabel?.font = fontBtnSmall
        
        viewTaskCount.addSubview(btnViewTaskManager)

        let taskCount = UIView()
        let lbltitle = UILabel()
        let lblCounter = UILabel()
        
        taskCount.frame = CGRect(x: 0, y: 0, width: viewTaskCount.frame.size.width, height: viewTaskCount.frame.size.height)
        taskCount.backgroundColor = UIColor.clear
        
        let aspect = taskCount.frame.size.height - 45
        let width = taskCount.frame.size.width
        
        lbltitle.frame = CGRect(x: 0, y: 0, width: width, height: aspect/3)
        lbltitle.textAlignment = .center
        lbltitle.font = fontMainLight
        lbltitle.text = "Completed Tasks"
        
        lblCounter.frame = CGRect(x: 0, y: (aspect - 45)/2, width: width, height: 60)
        lblCounter.text = "4/7"
        lblCounter.textAlignment = .center
        lblCounter.font = fontCounter
        lblCounter.textColor = purpleColor
        
        taskCount.addSubview(lbltitle)
        taskCount.addSubview(lblCounter)
        viewTaskCount.addSubview(taskCount)
        
    }
    
    func setUpGoalCount() {
        
        let btnViewGoals = UIButton()
        let y = 30 + viewCalendar.frame.size.height + viewCalendar.frame.size.height/1.5 + 15 + viewEntryCount.frame.size.height + 15
        let btnViewGradient3 = CAGradientLayer()
        
        //containerview fot tableview
        viewGoalCount.frame = CGRect(x: 15 + viewTaskCount.frame.size.width + 15, y: y, width: viewTaskCount.frame.size.width, height: viewTaskCount.frame.size.height)
        viewGoalCount.clipsToBounds = false
        viewGoalCount.backgroundColor = whiteColor
        viewGoalCount.layer.cornerRadius = 25
        viewGoalCount.layer.shadowColor = blackColor.cgColor
        viewGoalCount.layer.shadowOffset = CGSize(width: 6, height: 6)
        viewGoalCount.layer.shadowOpacity = 0.05
        viewGoalCount.layer.shadowRadius = 10.0
        
        scrollView.addSubview(viewGoalCount)
        
        // UIButton: Add Event
        btnViewGoals.addTarget(self,action:#selector(addEvent), for:.touchUpInside)
        btnViewGoals.frame = CGRect(x: 15, y: viewGoalCount.bounds.height - 45 - 15, width: viewGoalCount.frame.size.width - 30, height: 45)
        
        // add gradient to button
        btnViewGradient3.frame = CGRect(x: 0, y: 0, width: btnViewGoals.frame.size.width, height: 45)
        btnViewGradient3.colors = [blueColor.cgColor, lightBlueColor.cgColor]
        btnViewGradient3.locations = [ 0.0, 1.0]
        btnViewGradient3.startPoint = CGPoint(x: 0, y: 0.5)
        btnViewGradient3.endPoint = CGPoint(x: 1, y: 0.5)
        btnViewGradient3.cornerRadius = 22.5
        
        btnViewGoals.layer.addSublayer(btnViewGradient3)
        
        btnViewGoals.setTitle("View",for: .normal)
        btnViewGoals.tintColor = whiteColor
        btnViewGoals.titleLabel?.font = fontBtnSmall
        
        viewGoalCount.addSubview(btnViewGoals)
        
        let taskCount = UIView()
        let lbltitle = UILabel()
        let lblCounter = UILabel()
        
        taskCount.frame = CGRect(x: 0, y: 0, width: viewGoalCount.frame.size.width, height: viewGoalCount.frame.size.height)
        taskCount.backgroundColor = UIColor.clear
        
        let aspect = taskCount.frame.size.height - 45
        let width = taskCount.frame.size.width
        
        lbltitle.frame = CGRect(x: 0, y: 0, width: width, height: aspect/3)
        lbltitle.textAlignment = .center
        lbltitle.font = fontMainLight
        lbltitle.text = "Goals"
        
        lblCounter.frame = CGRect(x: 0, y: (aspect - 45)/2, width: width, height: 60)
        lblCounter.text = "1"
        lblCounter.textAlignment = .center
        lblCounter.font = fontCounter
        lblCounter.textColor = purpleColor
        
        taskCount.addSubview(lbltitle)
        taskCount.addSubview(lblCounter)
        viewGoalCount.addSubview(taskCount)
        
        let totalHeight = 30 + viewCalendar.frame.size.height + viewCalendar.frame.size.height/1.5 + 15 + viewEntryCount.frame.size.height + 15 + viewGoalCount.frame.size.height + 15
        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: totalHeight)

        
    }
    
    // MARK: functions that get data per calendar date
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        //print("did select date \(self.dateFormatter.string(from: date))")
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        //print(formatter.string(from: date))
        //let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
        //print("selected dates is \(selectedDates)")
        fetchData()
        let range = NSMakeRange(0, tableView.numberOfSections)
        let sections = NSIndexSet(indexesIn: range)
        tableView.reloadSections(sections as IndexSet, with: .automatic)
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
    }
    
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        //print("\(self.dateFormatter.string(from: calendar.currentPage))")
    }
    
    // MARK: data functions
    
    func deleteRow(){
        
        let context = appDelegate.persistentContainer.viewContext

        let dataHelper = DataHelper(context: context)
        let events : [Events] = dataHelper.getAllEvents()
        let i = events.index(where: { $0.title == "" }) as! Int
        let toBeDeleted = dataHelper.getEventById(id: events[i].objectID)
        
        do {
            
            dataHelper.delete(id: toBeDeleted!.objectID)
            try context.save()
            
            
        } catch {
            print("Failed deleting")
        }
    }
    
    
    func fetchData(){
        listTask.removeAll()
        let context = appDelegate.persistentContainer.viewContext

        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let stringFetch = formatter.string(from: calendar.selectedDate!)
        var records:[Events] = []
        
        // Create Fetch Request
        let fetchRequest = NSFetchRequest<Events>(entityName: "Events")
        
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Add Predicate
        let predicate = NSPredicate(format: "date = %@", stringFetch)
        fetchRequest.predicate = predicate
        
        records = try! context.fetch(fetchRequest) as [Events]
        
        if(records == listTask) {
            return
        }
        else{
            listTask.removeAll()
            for record in records {
                print("new event detected")
                listTask.append(record)
            }
            let range = NSMakeRange(0, tableView.numberOfSections)
            let sections = NSIndexSet(indexesIn: range)
            tableView.reloadSections(sections as IndexSet, with: .automatic)
        }
        
      
    }
    
    
    func saveEvent(date : Date){
        
        let formatterDate = DateFormatter()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "dd-MM-yyyy hh:mm a"
        formatterDate.dateFormat = "dd-MM-yyyy"
        let result = formatter.string(from: date)
        let dateOnly = formatterDate.string(from: date)
        
        let context = appDelegate.persistentContainer.viewContext
        let dataHelper = DataHelper(context: context)

        //self.datePicker.datePickerMode = .time
        self.datePicker.datePickerMode = UIDatePickerMode.time
        self.datePicker.locale = Locale(identifier: "en_GB")
        
        alert = UIAlertController(title: "New event: " + dateOnly, message: nil, preferredStyle: .alert)
        alert.view.tintColor = purpleColor
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.placeholder = "Title"
            textField.textAlignment = .center
            textField.font = fontInput
            textField.addConstraint(textField.heightAnchor.constraint(equalToConstant: 40))
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Add a note"
            textField.textAlignment = .center
            textField.font = fontInput
            textField.addConstraint(textField.heightAnchor.constraint(equalToConstant: 40))
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Add time"
            textField.textAlignment = .center
            textField.inputView = self.datePicker
            textField.font = fontInput
            textField.addConstraint(textField.heightAnchor.constraint(equalToConstant: 20))
            self.datePicker.addTarget(self, action: #selector(self.myDateView(sender:)), for: .valueChanged)
            
            // ToolBar
            let toolBar = UIToolbar()
            toolBar.barStyle = UIBarStyle.default
            toolBar.isTranslucent = true
            toolBar.tintColor = blueColor
            toolBar.sizeToFit()
            
            // Adding Button ToolBar
            let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(CalendarViewController.doneClick))
            let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            doneButton.setTitleTextAttributes([NSAttributedStringKey.font: fontHeaderSub!], for: .normal)
            doneButton.tintColor = blackColor
            toolBar.setItems([spaceButton, doneButton], animated: false)
            toolBar.isUserInteractionEnabled = true
            textField.inputAccessoryView = toolBar
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak alert] (_) in
            
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            let title = textField?.text
            let note = alert?.textFields![1].text

            //let timePick = result
            let newEvent = dataHelper.createEvent(title: title!, note: note!, date: dateOnly, time: self.dateToSave)
            
            dataHelper.saveChanges()
            
            print("\(String(describing: newEvent))")
            //self.printEvents()
        
                self.listTask.append(newEvent)
                
            
                let indexPath = IndexPath(row: self.listTask.count-1 , section: 0)
         
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: [indexPath], with: .automatic)
                self.tableView.endUpdates()
            
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
        
    }
    

    
    func editEvent(indexTask : IndexPath){
        
        let eventSelected = self.listTask[indexTask.row]
        let context = appDelegate.persistentContainer.viewContext
        
        self.datePicker.datePickerMode = UIDatePickerMode.time
        self.datePicker.locale = Locale(identifier: "en_GB")
        
        let formatter = DateFormatter()
         formatter.locale = Locale(identifier: "en_GB")
        formatter.dateFormat = "HH:mm"
        let timeToString = formatter.string(from: eventSelected.time.addingTimeInterval(-120.0 * 60.0))
        
        alert = UIAlertController(title: "Update event: ", message: nil, preferredStyle: .alert)
        alert.view.tintColor = purpleColor
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.placeholder = "Title"
            textField.textAlignment = .center
            textField.text = eventSelected.title
            textField.font = fontInput
            textField.addConstraint(textField.heightAnchor.constraint(equalToConstant: 40))
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Your notes"
            textField.textAlignment = .center
            textField.text = eventSelected.note
            textField.font = fontInput
            textField.addConstraint(textField.heightAnchor.constraint(equalToConstant: 40))
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Time"
            textField.textAlignment = .center
            textField.text = timeToString
            textField.inputView = self.datePicker
            textField.font = fontInput
            textField.addConstraint(textField.heightAnchor.constraint(equalToConstant: 20))
            self.datePicker.addTarget(self, action: #selector(self.myDateView(sender:)), for: .valueChanged)
            
            // ToolBar
            let toolBar = UIToolbar()
            toolBar.barStyle = UIBarStyle.default
            toolBar.isTranslucent = true
            toolBar.tintColor = blueColor
            toolBar.sizeToFit()
            
            // Adding Button ToolBar
            let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(CalendarViewController.doneClick))
            let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            doneButton.setTitleTextAttributes([NSAttributedStringKey.font: fontHeaderSub!], for: .normal)
            doneButton.tintColor = blackColor
            toolBar.setItems([spaceButton, doneButton], animated: false)
            toolBar.isUserInteractionEnabled = true
            textField.inputAccessoryView = toolBar
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak alert] (_) in
            
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            let title = textField?.text
            let note = alert?.textFields![1].text
            
            var searchResults: [Events] = []
            let fetchRequest = NSFetchRequest<Events>(entityName: "Events")
            do {
                searchResults = try context.fetch(fetchRequest)
                for task in searchResults {
                    if task == eventSelected{
                        task.title = title!
                        self.listTask[indexTask.row].title = title!
                      
                        task.note = note!
                        self.listTask[indexTask.row].note = note!
                        
                        task.time = self.dateToSave
                        self.listTask[indexTask.row].time = self.dateToSave
                       
                    }
                }
            } catch {
                print("Error with request: \(error)")
            }
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            let range = NSMakeRange(0, self.tableView.numberOfSections)
            let sections = NSIndexSet(indexesIn: range)
            self.tableView.reloadSections(sections as IndexSet, with: .automatic)
            
            
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
 
    }
    
    // MARK:- UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listTask.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let task = listTask[indexPath.row]
        let title = task.title
        let timestamp = task.time
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! eventCell
        let formatter = DateFormatter()
        
        formatter.dateFormat = "HH:mm"
        formatter.locale = Locale(identifier: "en_GB")
        let dateInterval = timestamp.addingTimeInterval(-120.0 * 60.0)

        
        let time = formatter.string(from: dateInterval)
        print("\(String(describing: cell))")
        
        //time
        cell.lblTime.text = time
        cell.lblTime.textAlignment = .center
        cell.lblTime.font = fontMainLight
        //cell.bounds = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 120)
        cell.textLabel?.font = fontMainRegular

        //title
        cell.lblTitle.text = title
        cell.lblTitle.font = fontMainRegular
        
        return cell
        
    }
    
    // MARK:- UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52.5
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let task = self.listTask[indexPath.row]
        let context = appDelegate.persistentContainer.viewContext
        let dataHelper = DataHelper(context: context)
        
        
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { (action, indexPath) in
            // code to delete the item goes here
            dataHelper.deleteEvent(id: task.objectID)
            
            dataHelper.saveChanges()
            self.listTask.remove(at: indexPath.row)
            
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.tableView.endUpdates()
            
            
        }
        delete.backgroundColor = .red
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            // code to implement the edit task goes here
            self.editEvent(indexTask: indexPath)
            
            
        }
        edit.backgroundColor = purpleColor
        
        
        return [delete, edit]
    }
    
    
    // MARK: actions
    
    @objc func addEvent(){
        let date = calendar.selectedDate
        if(date == nil){
            saveEvent(date: calendar.today!)
        }
        else {
            saveEvent(date: date!)
        }
        
    }
    
    @objc func doneClick(sender: UITextField){
        alert.textFields![2].resignFirstResponder()
        alert.textFields![2].text = selectedDate
    }
    
    // TO ENTRIES (second tab)
    @objc func toEntries() {
         self.tabBarController?.selectedIndex = 1
    }
    
    //MARK: - Instance Methods
    func getDateFromPicker(date:Date){
        let dateFormatter = DateFormatter()//3
        dateFormatter.locale = Locale(identifier: "en_GB")
        
        let theDateFormat = DateFormatter.Style.short //5
        let theTimeFormat = DateFormatter.Style.short//6
        
        //dateFormatter.dateStyle = theDateFormat
        dateFormatter.timeStyle = theTimeFormat//9
        
        let value: String =  dateFormatter.string(from: date)

        dateToSave = date.addingTimeInterval(120.0 * 60.0)
        selectedDate = value
        
        print("TO SAVE: \(dateToSave)")
        print("Selected value \(value)")
    }
    
    @IBAction func myDateView(sender: UIDatePicker) {
        getDateFromPicker(date: sender.date)
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
