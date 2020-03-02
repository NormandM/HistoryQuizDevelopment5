//
//  Question.swift
//  HistoryQuizDevelopement3
//
//  Created by Normand Martin on 2020-02-08.
//  Copyright © 2020 Normand Martin. All rights reserved.
//

import Foundation
import SwiftUI
import Combine


struct Sequences  {
//    let sequence = [[0, 15, 19], [14, 19, 20], [10, 14, 18], [1, 10, 16], [6, 16, 17], [3, 6, 11], [1, 3, 9], [4, 9, 12], [2, 4, 7], [5, 7, 13]]
//    let trayCards = [[0, 13 , 19], [14, 17 , 20], [10, 16 , 18], [1, 12 , 16], [6, 14 , 17], [3, 8 , 11], [1, 5 , 9], [4, 7 , 12], [2, 5 , 7], [5, 9 , 13]]
 //   let eventIsEarlier = [false, true, true, false, true, true, false, true, false, false]
//    let rightAnswer = [19, 14, 10, 16, 6, 3, 9, 4, 7, 13]
    let sequence = [[0, 0, 4], [3, 4, 4], [2, 3, 3], [2, 2, 6], [5,6,6], [5, 5, 8], [7, 8, 8], [7, 7, 10], [10, 10, 11], [9, 11, 11], [9,9,14], [13, 14, 14], [12, 13, 13], [12, 12, 16], [15, 16, 16], [15, 15, 18], [18, 18, 19]]
     let trayCards = [4, 3, 2, 6, 5, 8, 7, 10, 11, 9, 14, 13, 12, 16, 15, 18, 19]
    let eventIsEarlier = [false, true, true, false, true, false, true, false, false, true, false, true, true,false, true, false, false]
    let rightAnswer = [4, 3, 2, 6, 5, 8, 7, 10, 11, 9, 14, 13, 12, 16, 15, 18, 19]
}


class Info: Identifiable {
    var id: Int
    var card0Name: String
    var card1Name: String
    var card2Name: String
    var trayCard0Name: String
    var trayCardDescription1: String
    var rightAnswer: String
    var questionNumber: String
    init(id: Int) {
        let sequences = Sequences()
        self.id = id
        card0Name = Event(eventIndex: sequences.sequence[id][0]).name
        card1Name = Event(eventIndex: sequences.sequence[id][1]).name
        card2Name = Event(eventIndex: sequences.sequence[id][2]).name
        trayCard0Name = Event(eventIndex: sequences.trayCards[id]).name
        rightAnswer = Event(eventIndex: sequences.rightAnswer[id]).name
        trayCardDescription1 = Event(eventIndex: sequences.trayCards[id]).description
        questionNumber = String(id)
    }
}
class Timing: Identifiable {
    var id: Int
    var eventIsEarlier: Bool
    init(id: Int) {
        let sequences = Sequences()
        self.id = id
        print(id)
        eventIsEarlier = sequences.eventIsEarlier[id]
    }
}

class CardInfo: ObservableObject {
    @Published var info : [Info]
    
    init() {
        let sequence = Sequences()
        let totalNumber = sequence.trayCards.count
        var arrayOfquestions = [Info]()
        for n in 0...totalNumber - 1 {
            arrayOfquestions.append(Info(id: n))
        }
        self.info = arrayOfquestions
    }
}
class EventTiming: ObservableObject {
    @Published var timing : [Timing]
    init() {
        var arrayTiming = [Timing]()
        let sequence = Sequences()
        let totalNumber = sequence.trayCards.count
        for n in 0...totalNumber - 1 {
            arrayTiming.append(Timing(id: n))
        }
        self.timing = arrayTiming
    }
}
//class RandomTrayIndex {
//    var trayIndex : [Int]
//    init(){
//        trayIndex = [0, 1, 2].shuffled()
//    }
//}







