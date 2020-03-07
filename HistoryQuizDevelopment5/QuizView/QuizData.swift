//
//  QuizData.swift
//  HistoryQuizDevelopment5
//
//  Created by Normand Martin on 2020-03-05.
//  Copyright © 2020 Normand Martin. All rights reserved.
//

import Foundation
import SwiftUI
class QuizData:  ObservableObject{
    @Published var questions: [String]
    @Published var answers: [String]
    init() {
        var allData: [[String]]
        let pListEvent = "InventionsQuiz"
        if let plistPath = Bundle.main.path(forResource: pListEvent, ofType: "plist"),
            let transition = NSArray(contentsOfFile: plistPath){
            allData = transition as! [[String]]
        }else{
            allData = []
        }
        var sequence = [0, 1, 2]
        sequence.shuffle()
        questions = [allData[sequence[0]][0], allData[sequence[1]][0], allData[sequence[2]][0]]
        answers = [allData[sequence[0]][1], allData[sequence[1]][1], allData[sequence[2]][1]]
    }
}
