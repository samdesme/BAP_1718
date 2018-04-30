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
    @IBOutlet weak var viewHeader: UIView!
   // @IBOutlet weak var tableView: UITableView!
    var selectedDate : String = ""
    var dateToSave = Date()
    
    @IBOutlet weak var calendar: FSCalendar!

    var datePicker = UIDatePicker()

    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var listTask:[Events] = []
    var alert = UIAlertController()

    let  topGradientLayer = CAGradientLayer()
    let btnGradientLayer = CAGradientLayer()
    let  gradientLayer = CAGradientLayer()
    
    var viewTopGradient = UIView()
    var viewCalendar = UIView()
    var viewTableContainer = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        createCalendarView()
        tabBarController?.selectedIndex = 0
        self.title = "CALENDAR"
        self.view.backgroundColor = lightGreyColor
        self.view.isUserInteractionEnabled = true
        
    }
    
    func createCalendarView() {
        
        let navBar = navigationController?.navigationBar
        
        // CONTENT
        self.view.backgroundColor = lightGreyColor
        
        //self.datePicker.datePickerMode = .time
        let currentDate = Date()  //5 -  get the current date
        datePicker.minimumDate = currentDate  //6- set the current date/time as a minimum
        datePicker.date = currentDate //7 - defaults to current time but shows how to use it.

        //set up a gradient at the top of the page to create a 3D effect
        viewTopGradient.clipsToBounds = false
        viewTopGradient.backgroundColor = UIColor.clear
        topGradientLayer.frame = CGRect(x: 0, y: (navBar?.frame.size.height)!, width: self.view.frame.size.width, height: (self.view.frame.size.height/3)/2)
        topGradientLayer.colors = [blackColor.withAlphaComponent(0.05).cgColor, UIColor.clear.cgColor]
        topGradientLayer.locations = [ 0.0, 1.0]
        
        //self.view.addSubview(viewTopGradient)
        //viewTopGradient.layer.addSublayer(topGradientLayer)
        
        createCalendar()
        setUpTableView()

    }
    

    func createCalendar() {
        
        let navBar = navigationController?.navigationBar
    
        viewCalendar.frame = CGRect(x: 15, y: (navBar?.frame.size.height)!*2, width: self.view.frame.size.width - 30, height: (self.view.frame.size.height/3))
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
        
        gradientLayer.frame = CGRect(x: 15, y: (navBar?.frame.size.height)!*2, width: self.view.frame.size.width - 30, height: (self.view.frame.size.height/3))
        
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
    
        //add gradient layer to UIView
        self.view.addSubview(viewCalendar)
    }
    
    func setUpTableView() {
        let navBar = navigationController?.navigationBar
        let btnAdd = UIButton()
        
        //containerview fot tableview
        viewTableContainer.frame = CGRect(x: 15, y: (navBar?.frame.size.height)!*2 + viewCalendar.frame.size.height + 15, width: self.view.frame.size.width - 30, height: viewCalendar.frame.size.height/1.5)
        viewTableContainer.clipsToBounds = false
        viewTableContainer.backgroundColor = whiteColor
        viewTableContainer.layer.cornerRadius = 25
        viewTableContainer.layer.shadowColor = blackColor.cgColor
        viewTableContainer.layer.shadowOffset = CGSize(width: 6, height: 6)
        viewTableContainer.layer.shadowOpacity = 0.05
        viewTableContainer.layer.shadowRadius = 10.0
        
        self.view.addSubview(viewTableContainer)

       let tableView = UITableView()
        
         //tableView.frame = viewTableContainer.bounds
        tableView.frame = CGRect(x: 0, y: 0, width: viewTableContainer.bounds.width, height: viewTableContainer.bounds.height - 22.5 - 15)
        //tableView.frame.size.height = viewTableContainer.frame.size.height - 250

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellEvent")
        tableView.isScrollEnabled = true
        tableView.layer.cornerRadius = 25
        tableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        //tableView.tableFooterView = UIView()

        viewTableContainer.addSubview(tableView)
        
        // UIButton: Add Event
        btnAdd.addTarget(self,action:#selector(addEvent), for:.touchUpInside)
        btnAdd.frame = CGRect(x: (viewTableContainer.frame.size.width - 200)/2, y: viewTableContainer.bounds.height - 22.5, width: 200, height: 45)
        
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
    
    
    // MARK: data functions
    
    func saveEvent(date : Date){
        
        let formatterDate = DateFormatter()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "dd-MM-yyyy hh:mm a"
        formatterDate.dateFormat = "dd-MM-yyyy"
        let dateOnly = formatter.string(from: date)
        let result = formatter.string(from: date)
        
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
            
          /*  let event = Events(context: context)
            event.note = note!
            event.date = date */
            
            //let newEvent = NSEntityDescription.insertNewObject(forEntityName: "Events", into: self.appDelegate.persistentContainer.viewContext) as! Events
  
            let newEvent = dataHelper.createEvent(title: title!, note: note!, date: self.dateToSave)
            
            //dataHelper.saveChanges()
            
            print("\(String(describing: newEvent))")
            //self.printEvents()
            /*
            do {
                try context.save()
                //self.listTask.append(event)
                
                /*
                let indexPath = IndexPath(row: self.listTask.count-1 , section: 0)
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: [indexPath], with: .automatic)
                self.tableView.endUpdates()
                */
                
            }
            catch{
                print(error)
            }*/
            
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func printEvents() {
        let context = appDelegate.persistentContainer.viewContext
        let dataHelper = DataHelper(context: context)
        let events : [Events] = dataHelper.getAllEvents()
        print("ALL EVENTS -----------------------")
        print(events)
        print("END ALL EVENTS -----------------------")
    }
    
    func editEvent(indexTask : IndexPath){
        
        let eventSelected = self.listTask[indexTask.row]
        alert = UIAlertController(title: "Edit Task TO DO", message: nil, preferredStyle: .alert)
        alert.view.tintColor = lightGreyColor
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.placeholder = "Your Task"
            textField.textAlignment = .center
            textField.text = eventSelected.note
            textField.font = fontInput
            textField.addConstraint(textField.heightAnchor.constraint(equalToConstant: 40))
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Choose Category"
            textField.textAlignment = .center
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            let dateFetch = formatter.string(from: eventSelected.date)
            
            textField.text = dateFetch
            textField.inputView = self.datePicker
            textField.font = fontInput
            textField.addConstraint(textField.heightAnchor.constraint(equalToConstant: 20))
            
            /*
             // TO DO: ToolBar
            let toolBar = UIToolbar()
            toolBar.barStyle = .default
            toolBar.isTranslucent = true
            toolBar.tintColor = lightGreyColor
            toolBar.sizeToFit()
            
            // Adding Button ToolBar
            let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(homeTask.doneClick))
            let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            doneButton.setTitleTextAttributes([NSAttributedStringKey.font: font18regular!], for: .normal)
            doneButton.tintColor = baseColor
            toolBar.setItems([spaceButton, doneButton], animated: false)
            toolBar.isUserInteractionEnabled = true
            textField.inputAccessoryView = toolBar
             */
        }
        
        /*
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak alert] (_) in
            let context = self.appDelegate.persistentContainer.viewContext
            let eventsFetchRequest = NSFetchRequest<Events>(entityName: "Events")

            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            let descr = textField?.text
            let categ = alert?.textFields![1].text
            var searchResults: [Events] = []
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Events")
          
            let allEvents = try! context.fetch(eventsFetchRequest)
                for event in allEvents {
                   // TO DO
                }
           
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            let range = NSMakeRange(0, self.tableView.numberOfSections)
            let sections = NSIndexSet(indexesIn: range)
            self.tableView.reloadSections(sections as IndexSet, with: .automatic)
            
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
        
        */
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
        let timestamp = task.date
    
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let time = formatter.string(from: timestamp)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellEvent", for: indexPath) as! cellEvent
        
        cell.lblTitle.text = title
        cell.lblTime.text = time
       
        return cell
        
    }

    
    // MARK:- UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        tableView.deselectRow(at: indexPath, animated: true)
        //        if indexPath.section == 0 {
        //            let scope: FSCalendarScope = (indexPath.row == 0) ? .month : .week
        //            self.calendar.setScope(scope, animated: true)
        //        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
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
                tableView.beginUpdates()
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.endUpdates()
                
           
        }
        delete.backgroundColor = .red
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            // code to implement the edit task goes here
            self.editEvent(indexTask: indexPath)
        
            
        }
        edit.backgroundColor = UIColor(netHex: 0xF2A104)
        
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
