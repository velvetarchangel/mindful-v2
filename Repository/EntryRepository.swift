//
//  EntryRepository.swift
//  mindful2
//
//  Created by Himika Dastidar on 2020-11-06.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

class EntryRepository: ObservableObject {
    let db = Firestore.firestore()
    @Published var entries = [Entry]()
    
    init(){
        loadData()
    }
    
    func loadData() {
        db.collection("entries").addSnapshotListener {(querySnapshot,error) in
            if let querySnapshot = querySnapshot {
                self.entries = querySnapshot.documents.compactMap { document in try? document.data(as: Entry.self)
                }
            }
        }
    }
    
    func addEntry(_ entry: Entry){
        do{
            let _ = try db.collection("entries").addDocument(from: entry)
        }
        catch{
            fatalError("Unable to encode entry: \(error.localizedDescription)")
        }
    }
}

