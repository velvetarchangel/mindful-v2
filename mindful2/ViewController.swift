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
  
  // mood buttons
  @IBOutlet weak var happyButton: UIButton!
  @IBOutlet weak var contentButton: UIButton!
  @IBOutlet weak var mehButton: UIButton!
  @IBOutlet weak var sadButton: UIButton!
  
  // activity buttons
  @IBOutlet weak var eatBtn: UIButton!
  @IBOutlet weak var sleepBtn: UIButton!
  @IBOutlet weak var exerciseBtn: UIButton!
  @IBOutlet weak var socializeBtn: UIButton!
  @IBOutlet weak var hobbiesBtn: UIButton!
  @IBOutlet weak var relaxBtn: UIButton!
  
  
  var currentMood : Mood = Mood(mood: "")
  //set of activities (if the activity is in the set removes it otherwise adds it)
  var currentActivities = Set<Activity>()
  let db = Firestore.firestore()
  @Published var entryRepository = EntryRepository()
  //Mood button actions on tap
  @IBAction func happyButton(_ sender: UIButton, forEvent event: UIEvent) {
    currentMood.mood = "Happy"
    // change the happy button background color and clear all other button backgrounds
    happyButton.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1)
    contentButton.backgroundColor = nil
    mehButton.backgroundColor = nil
    sadButton.backgroundColor = nil
    print("Current mood is " + currentMood.mood!)
  }
  
  @IBAction func sadButton(_ sender: UIButton, forEvent event: UIEvent) {
    currentMood.mood = "Sad"
    // change the sad button background color and clear all other button backgrounds
    happyButton.backgroundColor = nil
    contentButton.backgroundColor = nil
    mehButton.backgroundColor = nil
    sadButton.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1)
    print("Current mood is " + currentMood.mood!)
  }
  
  @IBAction func mehButton(_ sender: UIButton, forEvent event: UIEvent) {
    currentMood.mood = "Meh"
    // change the meh button background color and clear all other button backgrounds
    happyButton.backgroundColor = nil
    contentButton.backgroundColor = nil
    mehButton.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1)
    sadButton.backgroundColor = nil
    print("Current mood is " + currentMood.mood!)
  }
  
  @IBAction func contentButton(_ sender: UIButton, forEvent event: UIEvent) {
    currentMood.mood = "Content"
    // change the content button background color and clear all other button backgrounds
    happyButton.backgroundColor = nil
    contentButton.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1)
    mehButton.backgroundColor = nil
    sadButton.backgroundColor = nil
    print("Current mood is " + currentMood.mood!)
  }
  
  //Activity Button actions on tap
  @IBAction func eatWellButton(_ sender: UIButton, forEvent event: UIEvent) {
    let eatwell = Activity(activity: "Eat Well")
    
    if(currentActivities.contains(eatwell)){
      currentActivities.remove(eatwell)
      eatBtn.backgroundColor = nil
    }else{
      currentActivities.insert(eatwell)
      eatBtn.backgroundColor = UIColor(red: 0.53, green: 0.57, blue: 0.69, alpha: 0.2)
    }
    print(currentActivities)
  }
  
  @IBAction func sleepWell(_ sender: UIButton, forEvent event: UIEvent) {
    let sleepwell = Activity(activity: "Sleep well")
    
    if(currentActivities.contains(sleepwell)){
      currentActivities.remove(sleepwell)
      sleepBtn.backgroundColor = nil
    }else{
      currentActivities.insert(sleepwell)
      sleepBtn.backgroundColor = UIColor(red: 0.53, green: 0.57, blue: 0.69, alpha: 0.2)
    }
    print(currentActivities)
  }
  
  @IBAction func exercise(_ sender: UIButton, forEvent event: UIEvent) {
    let exercise = Activity(activity: "Exercise")
    
    if(currentActivities.contains(exercise)){
      currentActivities.remove(exercise)
      exerciseBtn.backgroundColor = nil
    }else{
      currentActivities.insert(exercise)
      exerciseBtn.backgroundColor = UIColor(red: 0.53, green: 0.57, blue: 0.69, alpha: 0.2)
    }
    print(currentActivities)
  }
  
  @IBAction func socialize(_ sender: UIButton, forEvent event: UIEvent) {
    let socialize = Activity(activity: "Socialize")
    
    if(currentActivities.contains(socialize)){
      currentActivities.remove(socialize)
      socializeBtn.backgroundColor = nil
    }else{
      currentActivities.insert(socialize)
      socializeBtn.backgroundColor = UIColor(red: 0.53, green: 0.57, blue: 0.69, alpha: 0.2)
    }
    print(currentActivities)
  }
  
  @IBAction func hobbies(_ sender: UIButton, forEvent event: UIEvent) {
    let hobbies = Activity(activity: "Hobbies")
    
    if(currentActivities.contains(hobbies)){
      currentActivities.remove(hobbies)
      hobbiesBtn.backgroundColor = nil
    }else{
      currentActivities.insert(hobbies)
      hobbiesBtn.backgroundColor = UIColor(red: 0.53, green: 0.57, blue: 0.69, alpha: 0.2)
    }
    print(currentActivities)
  }
  
  
  @IBAction func relax(_ sender: Any, forEvent event: UIEvent) {
    let relax = Activity(activity: "Relax")
    
    if(currentActivities.contains(relax)){
      currentActivities.remove(relax)
      relaxBtn.backgroundColor = nil
    }else{
      currentActivities.insert(relax)
      relaxBtn.backgroundColor = UIColor(red: 0.53, green: 0.57, blue: 0.69, alpha: 0.2)
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
