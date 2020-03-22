//
//  QuestionForSeries.swift
//  HistoryQuizDevelopment5
//
//  Created by Normand Martin on 2020-03-02.
//  Copyright © 2020 Normand Martin. All rights reserved.
//

import Foundation
struct Series {
    var list = [[1,4, 5, 8], [6, 7, 8, 9]]
}
struct SeriesInfo:  Identifiable {
    var id: Int
    var trayCardName: [String]
    var cardName: [String]
    var cardDescription: [String]
    var rightPositionCard: [String]
    init(id: Int) {
        self.id = id
        let series = Series()
        let list = series.list[id]
        var arrayName = [String]()
        var arrayDescription = [String]()
        let shuffledList = list.shuffled()
        print(shuffledList)
        var arrayRightPositionCard = [String]()
        for n in 0...3{
            arrayName.append(Event(eventIndex: shuffledList[n]).name)
            arrayDescription.append(Event(eventIndex: shuffledList[n]).description)
            arrayRightPositionCard.append(Event(eventIndex: list[n]).name)
        }
        cardName = arrayName
        print(cardName)
        trayCardName = arrayName
        cardDescription = arrayDescription
        rightPositionCard = arrayRightPositionCard
    }
}
class QuestionsForSeries: ObservableObject {
    @Published var seriesInfo : [SeriesInfo]
    init() {
        var arraySeriesInfo = [SeriesInfo]()
        for n in 0...1 {
            arraySeriesInfo.append(SeriesInfo(id: n))
        }
        seriesInfo = arraySeriesInfo
        print(seriesInfo)
    }
    
}

