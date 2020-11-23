//
//  DashboardViewController.swift
//  mindful2
//
//  Created by Himika Dastidar on 2020-11-08.
//
import Foundation
import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift
import FSCalendar

class DashboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance
{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var Calendar: FSCalendar!
    var db = Firestore.firestore() // reference to firebase database
    @Published var entryList: [Entry] = [] // when you pull data it will go here
    @Published var entryRepository = EntryRepository()
    
    var myData = ["first", "second", "third", "fourth", "fifth"]
    var calendarFormatter = DateFormatter()
    let fillDefaultColors = ["2020/10/08": UIColor.purple, "2020/10/06": UIColor.green, "2020/10/18": UIColor.cyan, "2020/10/22": UIColor.yellow, "2020/11/08": UIColor.purple, "2015/11/06": UIColor.green, "2015/11/18": UIColor.cyan, "2020/11/22": UIColor.yellow, "2020/12/08": UIColor.purple, "2020/12/06": UIColor.green, "2020/12/18": UIColor.cyan, "2020/12/22": UIColor.magenta]
    
    //MARK :- Delete later
    var event = ["2020-11-08", "2020-11-09"]
    
    override func viewDidLoad(){
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        Calendar.delegate = self
        Calendar.dataSource = self
        Calendar.scrollDirection = .horizontal
        Calendar.register(FSCalendarCell.self, forCellReuseIdentifier: "calendarcell")
        fetchData()
    }
    
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
    }
    
    
    //DATE FORMATTERS
    fileprivate lazy var dateFormatter1: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    fileprivate lazy var dateFormatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    //MARK :- Calendar Functions
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        let key = self.dateFormatter1.string(from: date)
        if let color = self.fillDefaultColors[key] {
            return color
        }
        return nil
    }

    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = Calendar.dequeueReusableCell(withIdentifier: "calendarcell", for: date, at: position)
        cell.clipsToBounds = true
        cell.contentMode = .center
        return cell
    }
    
    /*
        This function is supposed to keep an array of dates and figure out which color each one should be. It should populate the fill default array which can then be read in order to fill out the colors on the calendar.
     */
    func populateFillDefaultColors() {
        
    }
    
    // sets the maximum date that the user can select - maximum date is set to current date, which user cannot select beyond
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
    @IBOutlet weak var dateSelectedLabel: UILabel!
    // actions upon selecting a date
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        calendarFormatter.dateFormat = "yyyy-MM-dd"
        //print("Date Selected == \(calendarFormatter.string(from: date))")
        for entry in entryList {
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "yyyy-MM-dd"
            let dateStr = " \(dateFormat.string(from:entry.date))"
            
            // if current date ac
            if ((calendarFormatter.string(from: date)) == (dateFormat.string(from:entry.date))) {
                // print o that matches the date
                let moodThatDay = (entry.mood.mood)!
                //print("date matches entry: \(moodThatDay)")
                
                var allActivities: [String] = []
                for a in (entry.activities) {
                    let activityStr = (a.activity) ?? ""
                    allActivities.append(activityStr)
                }
                let activitiesFormatted = (allActivities.map{String($0)}).joined(separator: ", ") // format list of activities
                //print("moods that matches entry: \(activitiesFormatted)")
                let entryThatDay = "\(moodThatDay) - \(activitiesFormatted)"
                dateSelectedLabel.text = "\(entryThatDay)"
            }
        }
    }
    
    func fetchData(){
        db.collection("entries").order(by: "date", descending: true).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                var entryData: [String] = []
                for document in querySnapshot!.documents {
                    let entry = try? document.data(as: Entry.self) // data as entry, but has a lot of Optional() wrapping inside
                    var anEntry = Entry() // create an entry object
                    
                    var moodStr = "none"
                    if (entry?.mood != nil) {
                        var addMood : Mood = Mood(mood: "") // new mood
                        let moodWrap = (entry?.mood)! // unwrap optional
                        moodStr = (moodWrap.mood)! // mood as a string
                        addMood.mood = moodStr // add mood
                        anEntry.mood = addMood
//                        print("MOOD: \(moodStr)")
                    }
                    
                    var activitiesStr = ""
                    if (entry?.activities != nil) {
                        var addActivities = [Activity]()
                        let activityWrap = (entry?.activities)! // this gives a list of activities
                        var activityList = [String]() // activity as a list
                        for e in activityWrap {
//                            print("ACTIVITY: \(e.activity)") // prints Optional("acitvitiy")
                            let act = (e.activity)! // unwrap optional activity
                            //print("UNWRAPPED: \(act)")
                            let anActivity = Activity(activity: act)
                            activityList.append(act)
                            addActivities.append(anActivity)
                        }
                        anEntry.activities = addActivities
                        // comma delimit list of activities
                        activitiesStr = (activityList.map{String($0)}).joined(separator: ", ")
                    }
                    
                    var dateStr = ""
                    if (entry?.date != nil) {
                        let dateFormatterPrint = DateFormatter()
                        dateFormatterPrint.dateFormat = "MMM dd,yyyy - HH:mm"
                        
                        anEntry.date = (entry?.date)!
//                        print("Date: \(anEntry.date)")
                        dateStr = " \(dateFormatterPrint.string(from: anEntry.date))"
                        //print("ENTRY DATE: \((entry?.date)!)")
                    }
                    self.entryList.append(anEntry) // append to list of entries
                    let tableString = "\(moodStr) - \(activitiesStr) on \(dateStr)"
//                    print("~~~~~~~~~~~~~~~~~~~~~~~~~~")
//                    print(tableString)
                    entryData.append(tableString)
//                    self.myData = entryData
                    self.tableView.reloadData()
                }
//                print("----------TESTESTESTESTESTESTEST----------")
//                self.myData = entryData
//                for e in self.entryList {
//                    print(e)
//                }
                self.listEntries()
            }
        }
    }
    
    // test to list all entries in a list of Entries
    func listEntries() {
//        print("------------- list entries function --------------")
        var moodList: [String] = []
        for e in self.entryList {
//            print("MOOD")
            let moodStr = (e.mood.mood) ?? "none"
//            print("MOOD: \(moodStr)")
            var allActivities: [String] = []
            for a in (e.activities) {
                let activityStr = (a.activity) ?? ""
                allActivities.append(activityStr)
//                print("Activity: \(String(describing: a.activity))")
            }
            let activitiesFormatted = (allActivities.map{String($0)}).joined(separator: ", ") // format list of activities
            
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "MMM dd,yyyy - HH:mm"
            let dateStr = " \(dateFormatterPrint.string(from:e.date))"
            //print("DATE: \(dateStr)")
            let tableString = "\(dateStr)\n\(moodStr) - \(activitiesFormatted)"
            moodList.append(tableString)
        }
        myData = moodList
    }

    func tableView(_ tableview: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.numberOfLines = 0;
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.text = myData[indexPath.row]
        return cell
    }
}
