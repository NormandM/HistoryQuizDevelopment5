//
//  QuestionForSeries.swift
//  HistoryQuizDevelopment5
//
//  Created by Normand Martin on 2020-03-02.
//  Copyright © 2020 Normand Martin. All rights reserved.
//

import Foundation
struct Series {
    let list = [6, 7, 8, 9]
}
class QuestionsForSeries:  ObservableObject {
    @Published var trayCardName: [String]
    @Published var cardName: [String]
    init() {
        let series = Series()
        let list = series.list
        var arrayName = [String]()
        for n in 0...3{
            arrayName.append(Event(eventIndex: list[n]).name)
        }
        
        cardName = arrayName
        arrayName.shuffle()
        trayCardName = arrayName
    }
}
