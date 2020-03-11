//
//  TimeLineView.swift
//  HistoryQuizDevelopment5
//
//  Created by Normand Martin on 2020-02-28.
//  Copyright © 2020 Normand Martin. All rights reserved.
//

import SwiftUI

struct TimeLineView: View {
    let fonts = FontsAndConstraintsOptions()
    @State private var cardFrames = [CGRect](repeating: .zero, count: 4)
    @State private var trayCardsFrames = [CGRect](repeating: .zero, count: 4)
    @State private var cardGood = [false, false, false, false]
    @State private var trayCardDropped = [false, false, false, false]
    @State private var trayCardText = ""
    @State private var cardWasDropped = [false, false, false, false]
    @State private var goQuizView = false
    @State private var cardText = ["", "", "", "", ""]
    @State private var cardIsBeingMoved = [true, true, true, true]
    @State private var count = 0
    @State private var cardIndex = 0
    @ObservedObject var questionForSeries = QuestionsForSeries()
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                VStack {
                    NavigationLink(destination: QuizView(), isActive: self.$goQuizView){
                        Text("")
                    }
                    
                    HStack {
                        ForEach(0..<4) { number in
                            Card(onEnded: self.cardDropped, index: number, text: self.cardText[number])
                                .frame(width: geo.size.height/6 * 0.6
                                    , height: geo.size.height/6)
                                .allowsHitTesting(false)
                                .overlay(GeometryReader { geo2 in
                                    Color.clear
                                        .overlay(GeometryReader { geo2 in
                                            Color.clear
                                                .onAppear{
                                                    self.cardFrames[number] = geo2.frame(in: .global)
                                            }
                                        })
                                })
                                .opacity(self.cardWasDropped[number] ? 1.0 : 0.0)
                                .addBorder(Color.white, cornerRadius: 10)
                        }
                    }
                    .padding()
                    Button(action: {
                        for n in 0...3{
                            self.cardGood[n] = false
                            self.trayCardDropped[n] = false
                            self.cardWasDropped[n] = false
                        }
                        self.trayCardText = ""
                        self.cardText = ["", "", "", "", ""]
                        
                    }){
                        Text("Start Over")
                            .padding()
                    }
                    .background(Capsule().stroke(lineWidth: 2))
                    .foregroundColor(.white)
                    HStack {
                        Text("Test")
                            .lineLimit(100)
                            .scaledFont(name: "Helvetica Neue", size: self.fonts.fontDimension)
                            .foregroundColor(.black)
                            .padding()
                            .frame(width: geo.size.width/1.1, height: geo.size.height/3.2
                        )
                            .border(Color.white)
                            .background(ColorReference.specialGray)
                            .cornerRadius(20)
                            .padding()
                    }
                    HStack {
                        ForEach(0..<4) { number in
                            Card(onChanged: self.cardMoved, onEnded: self.cardDropped,onChangedP: self.cardPushed, onEndedP: self.cardUnpushed, index: number, text: self.questionForSeries.trayCardName[number])
                                .frame(width: geo.size.height/6 * 0.6
                                    , height: geo.size.height/6)
                                .overlay(GeometryReader { geo2 in
                                    Color.clear
                                        .overlay(GeometryReader { geo2 in
                                            Color.clear
                                                .onAppear{
                                                    self.trayCardsFrames[number] = geo2.frame(in: .global)
                                            }
                                        })
                                })
                                .zIndex(self.cardIsBeingMoved[number] ? 1.0 : 0.5)
                                .opacity(self.trayCardDropped[number] ? 0.0 : 1.0)
                        }
                    }
                }
            }
            .background(ColorReference.specialGreen)
            .edgesIgnoringSafeArea(.all)
        }
        .navigationBarBackButtonHidden(true)
        .navigationViewStyle(StackNavigationViewStyle())
        
    }
    func cardDropped(location: CGPoint, trayIndex: Int, cardAnswer: String) {
        if let match = cardFrames.firstIndex(where: {
            $0.contains(location)
        }) {
            self.cardWasDropped[match] = true
            print(match)
            switch match {
            case 0:
                cardText[0] = trayCardText
                if trayCardText == questionForSeries.cardName[0]{cardGood[0] = true}
            case 1:
                cardText[1] = trayCardText
                if trayCardText == questionForSeries.cardName[1]{cardGood[1] = true}
            case 2:
                cardText[2] = trayCardText
                if trayCardText == questionForSeries.cardName[2]{cardGood[2] = true}
            case 3:
                cardText[3] = trayCardText
                if trayCardText == questionForSeries.cardName[3]{cardGood[3] = true}
            default:
                print()
            }
            if self.cardGood[0] && self.cardGood[1] && self.cardGood[2] && self.cardGood[3] {
                self.goQuizView  = true
            }
        }
    }
    func cardMoved(location: CGPoint, letter: String) -> DragState {
        if let match = cardFrames.firstIndex(where: {
            $0.contains(location)
        }) {
            print("isBeingMoved: \(match)")
            if match == 0 || match == 1 || match == 2 || match == 3{
                return .good
            }else{
                return .bad
            }
        }
        else {
            return .unknown
        }
    }
    func cardPushed(location: CGPoint, trayIndex: Int){
        if let match = trayCardsFrames.firstIndex(where: {
            $0.contains(location)
        }) {
            self.count = self.count + 1
            if self.count == 1 {cardIndex = match}
            trayCardText = questionForSeries.trayCardName[cardIndex]
            switch cardIndex {
            case 0:
                cardIsBeingMoved[0] = true
            case 1:
                cardIsBeingMoved[1] = true
            case 2:
                cardIsBeingMoved[2] = true
            default:
                print()
            }
        }
    }
    func cardUnpushed(location: CGPoint, trayIndex: Int) {
        print("unpushed")
        for n in 0...3 {
            if cardText[n] == questionForSeries.trayCardName[0] {self.trayCardDropped[0] = true }
            if cardText[n] == questionForSeries.trayCardName[1] {self.trayCardDropped[1] = true }
            if cardText[n] == questionForSeries.trayCardName[2] {self.trayCardDropped[2] = true }
            if cardText[n] == questionForSeries.trayCardName[3] {self.trayCardDropped[3] = true }
            cardIsBeingMoved[n] = false
             self.count = 0
        }
    }
}

struct TimeLineView_Previews: PreviewProvider {
    static var previews: some View {
        TimeLineView()
    }
}
