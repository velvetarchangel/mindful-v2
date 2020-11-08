//
//  EntryListViewModel.swift
//  mindful2
//
//  Created by Himika Dastidar on 2020-11-06.
// **THIS IS NOT DOING ANYTHING YET**

import Foundation
import Combine

class EntryListViewModel: ObservableObject {
    @Published var entryRepository = EntryRepository()
    @Published var entryCellViewModels = [EntryCellViewModel]()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        entryRepository.$entries
            .map{ entries in entries.map{
                entry in EntryCellViewModel(entry : entry)
            }
        }
            .assign(to: \.entryCellViewModels, on: self)
            .store(in: &cancellables)
    }
//    func addEntry(entry: Entry) {
//        entryRepository.addEntry(entry)
//    }
    
}
