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

class DashboardViewController:UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var db = Firestore.firestore() // reference to firebase database
    @Published var entryList: [Entry] = []
    @Published var entryRepository = EntryRepository()
    
    var myData = ["first", "second", "third", "fourth", "fifth"]

    //initialize a repository object
    
    //List of 5 latest entries
        //load data and filter the data
    
    //Calendar
    //Graph
    
    override func viewDidLoad(){
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchData()
        
    }
    
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
    }
    
    func fetchData(){
        db.collection("entries").order(by: "date", descending: true).limit(to: 5).getDocuments() { (querySnapshot, err) in
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
                    }
                    self.entryList.append(anEntry) // append to list of entries
                    let tableString = "\(moodStr) - \(activitiesStr) on \(dateStr)"
                    print("~~~~~~~~~~~~~~~~~~~~~~~~~~")
                    print(tableString)
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
        print("------------- list entries function --------------")
        var moodList: [String] = []
        for e in self.entryList {
//            print("MOOD")
            let moodStr = (e.mood.mood) ?? "none"
            print("MOOD: \(moodStr)")
            var allActivities: [String] = []
            for a in (e.activities) {
                let activityStr = (a.activity) ?? ""
                allActivities.append(activityStr)
                print("Activity: \(String(describing: a.activity))")
            }
            let activitiesFormatted = (allActivities.map{String($0)}).joined(separator: ", ") // format list of activities
            
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "MMM dd,yyyy - HH:mm"
            let dateStr = " \(dateFormatterPrint.string(from:e.date))"
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
