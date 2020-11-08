//
//  Entry.swift
//  mindful2
//
//  Created by Himika Dastidar on 2020-11-06.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Entry: Codable, Identifiable {
    @DocumentID var id: String?
    var date: Date
    var mood: Mood
    var activities: [Activity]
    
    init() {
        self.id = ""
        self.date = Date()
        self.mood = Mood(mood: nil)
        self.activities = [Activity(activity: nil)]
    }
}
