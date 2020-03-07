//
//  Seuquence.swift
//  HistoryQuizDevelopment5
//
//  Created by Normand Martin on 2020-03-04.
//  Copyright © 2020 Normand Martin. All rights reserved.
//

import Foundation
import SwiftUI
struct Sequence {
    let sequence: [[Int]]
    let isEarlier: [Bool]
    let trayCards: [Int]
    init() {
        var allEvents = [[Int]]()
        var transitionBool = [Bool]()
        var transitionTrayCards = [Int]()
        let pListEvent = "InventionsSequence"
        if let plistPath = Bundle.main.path(forResource: pListEvent, ofType: "plist"),
            let transition = NSArray(contentsOfFile: plistPath){
            allEvents = transition as! [[Int]]
        }else{
            allEvents = []
        }
        for events in allEvents {
            if events[0] == events[1] && events[1] < events[2]{
                transitionBool.append(false)
                transitionTrayCards.append(events[2])
            }else if events[1] == events[2] && events[1] > events [0]{
                transitionBool.append(true)
                transitionTrayCards.append(events[0])
            }else{
                print("error")
                print(events[0])
                 print(events[1])
                 print(events[2])
            }
        }
        sequence = allEvents
        isEarlier = transitionBool
        trayCards = transitionTrayCards
    }
}
