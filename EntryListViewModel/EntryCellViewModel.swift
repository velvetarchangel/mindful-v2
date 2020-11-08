//
//  EntryCellViewModel.swift
//  mindful2
//
//  Created by Himika Dastidar on 2020-11-06.
// **THIS IS NOT DOING ANYTHING YET***

import Foundation
import Combine

class EntryCellViewModel: ObservableObject, Identifiable  {
    //Picture , Date, Activities
    @Published var entry: Entry
    var id: String = ""
    private var cancellables = Set<AnyCancellable>()
    
    init(entry: Entry) {
        self.entry = entry
    }
    
  }

