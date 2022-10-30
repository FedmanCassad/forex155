//
//  LeadersDeatailsViewModel.swift
//  Quotex
//
//  Created by Yaşar Ergin on 15.10.2022.
//

import UIKit

final class LeaderDetailsViewModel {
    let userRatingModel: Rating
    let position: Int
    
    var initialHistoryData: [History] = [] {
        didSet {
            makeSectionsData()
        }
    }
    
    var sectionsData: [HistorySection] = []
    
    func makeSectionsData()  {
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd.MM.yyyy"
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "dd MMMM yyyy"
        var sectionDict: [String: [History]] = [:]
        
        initialHistoryData.forEach { history in
            let dateString = inputFormatter.string(from: history.createdAt)
            if sectionDict[dateString] != nil {
                sectionDict[dateString]?.append(history)
            } else {
                sectionDict[dateString] = [history]
            }
        }
        
        var sectionsModel = [HistorySection]()
        for key in sectionDict.keys {
            guard let array = sectionDict[key] else { return }
            sectionsModel.append(.init(title: key, deals: array.sorted(by: { $0.createdAt > $1.createdAt })))
        }
        
        sectionsData = sectionsModel.sorted(by: { $0.title > $1.title })
    }
    
    init(with userRatingModel: Rating, position: Int) {
        self.userRatingModel = userRatingModel
        self.position = position
    }
}
