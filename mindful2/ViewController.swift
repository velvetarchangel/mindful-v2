//
//  MoodLogViewController.swift
//  mindful2
//
//  Created by Himika Dastidar on 2020-11-04.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class ViewController:UIViewController{

  @IBOutlet weak var currentDate: UILabel!
  
  var currentMood : Mood = Mood(mood: "")
  //set of activities (if the activity is in the set removes it otherwise adds it)
  var currentActivities = Set<Activity>()
  let db = Firestore.firestore()
  @Published var entryRepository = EntryRepository()
  //Mood buttons
  @IBAction func happyButton(_ sender: UIButton, forEvent event: UIEvent) {
    currentMood.mood = "Happy"
    print("Current mood is " + currentMood.mood!)
  }
  
  @IBAction func sadButton(_ sender: UIButton, forEvent event: UIEvent) {
    currentMood.mood = "Sad"
    print("Current mood is " + currentMood.mood!)
  }
  
  @IBAction func mehButton(_ sender: UIButton, forEvent event: UIEvent) {
    currentMood.mood = "Meh"
    print("Current mood is " + currentMood.mood!)
  }
  
  @IBAction func contentButton(_ sender: UIButton, forEvent event: UIEvent) {
    currentMood.mood = "Content"
    print("Current mood is " + currentMood.mood!)
  }
  
  //Activity Buttons
  @IBAction func eatWellButton(_ sender: UIButton, forEvent event: UIEvent) {
    let eatwell = Activity(activity: "Eat Well")
    
    if(currentActivities.contains(eatwell)){
      currentActivities.remove(eatwell)
    }else{
      currentActivities.insert(eatwell)
    }
    print(currentActivities)
  }
  
  @IBAction func sleepWell(_ sender: UIButton, forEvent event: UIEvent) {
    let sleepwell = Activity(activity: "Sleep well")
    
    if(currentActivities.contains(sleepwell)){
      currentActivities.remove(sleepwell)
    }else{
      currentActivities.insert(sleepwell)
    }
    print(currentActivities)
  }
  
  @IBAction func exercise(_ sender: UIButton, forEvent event: UIEvent) {
    let exercise = Activity(activity: "Exercise")
    
    if(currentActivities.contains(exercise)){
      currentActivities.remove(exercise)
    }else{
      currentActivities.insert(exercise)
    }
    print(currentActivities)
  }
  
  @IBAction func socialize(_ sender: UIButton, forEvent event: UIEvent) {
    let socialize = Activity(activity: "Socialize")
    
    if(currentActivities.contains(socialize)){
      currentActivities.remove(socialize)
    }else{
      currentActivities.insert(socialize)
    }
    print(currentActivities)
  }
  
  @IBAction func hobbies(_ sender: UIButton, forEvent event: UIEvent) {
    let hobbies = Activity(activity: "Hobbies")
    
    if(currentActivities.contains(hobbies)){
      currentActivities.remove(hobbies)
    }else{
      currentActivities.insert(hobbies)
    }
    print(currentActivities)
  }
  
  
  @IBAction func relax(_ sender: Any, forEvent event: UIEvent) {
    let relax = Activity(activity: "Relax")
    
    if(currentActivities.contains(relax)){
      currentActivities.remove(relax)
    }else{
      currentActivities.insert(relax)
    }
    print(currentActivities)
  }
  
  @IBAction func addEntry(_ sender: UIButton, forEvent event: UIEvent) {
    var currentEntry = Entry()
    //set the params
    currentEntry.mood = currentMood
    currentEntry.activities = Array(currentActivities)
    currentEntry.date = Date()
    
    //use the repository to add the entry
    entryRepository.addEntry(currentEntry)
    
  }
  /*
   Button that will move the view to the dashboard view
   */
  @IBAction func goToDasboard(_ sender: UIButton, forEvent event: UIEvent){
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let secondVC = storyboard.instantiateViewController(identifier: "Dashboard2")
    
    secondVC.modalPresentationStyle = .fullScreen
    secondVC.modalTransitionStyle = .crossDissolve
    
    present(secondVC, animated: true, completion: nil)
  }
  
  func setCurrentDate() {
    let dateFormatterPrint = DateFormatter()
    dateFormatterPrint.dateFormat = "MMM dd, yyyy"

    let exactlyCurrentTime: Date = Date()
    currentDate.text = " \(dateFormatterPrint.string(from: exactlyCurrentTime))"
    }

  override func viewDidLoad() {
    print("Initial view loaded")
    //set the current date on the label
    setCurrentDate()
  }
    
}
