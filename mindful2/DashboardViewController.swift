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
    var fillDefaultColors : [String: UIColor] = [:]
    var newestEntry : [String: Entry] = [:]
    let moodToImage : [String : UIImage?] = ["Happy" : UIImage(named: "happy.png")]

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
    

    // sets the maximum date that the user can select - maximum date is set to current date, which user cannot select beyond
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
    // actions upon selecting a date
    @IBOutlet weak var popUp: UIView!
    @IBOutlet public weak var moodImage: UIImageView!
    @IBOutlet public weak var Activity1: UIImageView!
    @IBOutlet public weak var Activity2: UIImageView!
    @IBOutlet public weak var Activity3: UIImageView!
    @IBOutlet public weak var Activity4: UIImageView!
    @IBOutlet public weak var Activity5: UIImageView!
    
    func getActivityImage(activity: String) -> UIImage? {
        let _ = ["Sleep well" : UIImage(named: "Sleep.png"), "Hobbies" : UIImage(named: "Hobby.png"), "Relax" : UIImage(named: "Meditate.png"), "Socialize" : UIImage(named: "People.png"),"Eat Well" : UIImage(named: "Apple.png"),"Exercise" : UIImage(named: "dumbell.png")]
        if(activity == "Sleep well"){
            return UIImage(named: "Sleep.png")
        }else if(activity == "Hobbies") {
            return UIImage(named: "Hobby.png")
        }else if(activity == "Relax"){
            return UIImage(named: "Meditate.png")
        }else if(activity == "Socialize"){
            return UIImage(named: "People.png")
        }else if(activity == "Eat Well"){
            return UIImage(named: "Apple.png")
        }else if(activity == "Exercise"){
            return UIImage(named: "dumbell.png")
        }
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        calendarFormatter.dateFormat = "yyyy-MM-dd"

        for entry in entryList {
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "yyyy-MM-dd"
            //let dateStr = " \(dateFormat.string(from:entry.date))"
            
            var moodThatDay = ""
            // if the selected date matches the date the entry was created
            if ((calendarFormatter.string(from: date)) == (dateFormat.string(from:entry.date))) {
                
                // check if the date already exists in the dictionary
                if (self.newestEntry[dateFormat.string(from:entry.date)] == nil) {
                    if(entry.mood.mood != nil) {
                        moodThatDay = (entry.mood.mood)!
                        self.moodImage.image = nil
                        if(moodThatDay == "Happy"){
                            self.moodImage.image =  UIImage(named: "happy.png")!
                        }else if(moodThatDay == "Sad") {
                            self.moodImage.image = UIImage(named: "bad.png")
                        }else if(moodThatDay == "Content") {
                            self.moodImage.image = UIImage(named: "content.png")
                        }else if(moodThatDay == "Meh"){
                            self.moodImage.image = UIImage(named: "meh.png")
                        }
                    }
                    //print("date matches entry: \(moodThatDay)")
                    
                    var allActivities: [String] = []

                    for a in (entry.activities) {
                        let activityStr = (a.activity) ?? ""
                        allActivities.append(activityStr)
                    }
                    self.Activity1.image = nil
                    self.Activity2.image = nil
                    self.Activity3.image = nil
                    self.Activity4.image = nil
                    self.Activity5.image = nil
                    if(allActivities.count > 0){
                        self.Activity1.image = getActivityImage(activity: allActivities[0])
                    }
                    if(allActivities.count > 1){
                        self.Activity2.image = getActivityImage(activity: allActivities[1])
                    }
                    if(allActivities.count > 2){
                        self.Activity3.image = getActivityImage(activity: allActivities[2])
                    }
                    if(allActivities.count > 3){
                        self.Activity4.image = getActivityImage(activity: allActivities[3])
                    }
                    if(allActivities.count > 4){
                        self.Activity5.image = getActivityImage(activity: allActivities[4])
                    }
                    self.newestEntry[dateFormat.string(from:entry.date)] = entry
                }
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
                    
                    var dateStr = ""        //THIS IS FOR THE TABLEVIEW
                    var bgDateStr = ""      // THIS IS FOR THE BACKGROUND FILL ARRAY
                    if (entry?.date != nil) {
                        
                        let dateFormatterPrint = DateFormatter()
                        dateFormatterPrint.dateFormat = "MMM dd,yyyy - HH:mm"
                        
                        let bgDateFormatterPrint = DateFormatter()
                        bgDateFormatterPrint.dateFormat = "yyyy/MM/dd"
                        
                        anEntry.date = (entry?.date)!
                        
                        dateStr = " \(dateFormatterPrint.string(from: anEntry.date))"
                        bgDateStr = "\(bgDateFormatterPrint.string(from: anEntry.date))"
                        if (self.fillDefaultColors[bgDateStr] == nil){
                            if (anEntry.mood.mood == "Happy"){
                                self.fillDefaultColors[bgDateStr] =  UIColor(red: 0.40, green: 0.75, blue: 0.65, alpha: 1.00)
                            }else if (anEntry.mood.mood == "Meh"){
                                self.fillDefaultColors[bgDateStr] = UIColor(red: 0.98, green: 0.72, blue: 0.48, alpha: 1.00)
                            }else if (anEntry.mood.mood == "Sad") {
                                self.fillDefaultColors[bgDateStr] = UIColor(red: 0.98, green: 0.54, blue: 0.48, alpha: 1.00)
                            }else if (anEntry.mood.mood == "Content") {
                                self.fillDefaultColors[bgDateStr] = UIColor(red: 0.62, green: 0.80, blue: 0.75, alpha: 1.00)
                            }
                        }
                        //print("ENTRY DATE: \((entry?.date)!)")
                    }
                    self.entryList.append(anEntry) // append to list of entries
                    let tableString = "\(moodStr) - \(activitiesStr) on \(dateStr)"
//                    print("~~~~~~~~~~~~~~~~~~~~~~~~~~")
//                    print(tableString)
                    entryData.append(tableString)
//                    self.myData = entryData
                    self.tableView.reloadData()
                    self.Calendar.reloadData()
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
