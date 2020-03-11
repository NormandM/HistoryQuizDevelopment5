//
//  QuizView.swift
//  HistoryQuizDevelopment5
//
//  Created by Normand Martin on 2020-03-01.
//  Copyright © 2020 Normand Martin. All rights reserved.
//

import SwiftUI

struct QuizView: View {
    @State private var cardFrames = [CGRect](repeating: .zero, count: 4)
    @State private var trayCardsFrames = [CGRect](repeating: .zero, count: 4)
       @State private var cardGood = [false, false, false]
    @State private var trayCardDropped = [false, false, false]
    @State private var trayCardText = ""
    @State private var cardWasDropped = [false, false, false]
    @State private var goQuizView = false
    @State private var cardText = ["", "", "", "", ""]
    @State private var cardIsBeingMoved = [true, true, true]
    @State private var count = 0
    @State private var cardIndex = 0
    @ObservedObject var quizData = QuizData()
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                VStack {
                    HStack {
                        Text(self.quizData.questions[0])
                            .padding()
                        Spacer()
                        Card(onChanged: self.cardMoved, onEnded: self.cardDropped,onChangedP: self.cardPushed, onEndedP: self.cardUnpushed ,index: 0, text: self.cardText[0])
                            .frame(width: geo.size.height/6 * 0.6
                                , height: geo.size.height/6)
                            .allowsHitTesting(false)
                            .overlay(GeometryReader { geo2 in
                                Color.clear
                                    .overlay(GeometryReader { geo2 in
                                        Color.clear
                                            .onAppear{
                                                self.cardFrames[0] = geo2.frame(in: .global)
                                        }
                                    })
                            })
                            .opacity(self.cardWasDropped[0] ? 1.0 : 0.0)
                            .addBorder(Color.white, cornerRadius: 10)
                        .padding()
                        
                    }
                    HStack {
                        Text(self.quizData.questions[1])
                            .padding()
                        Spacer()
                        Card(onChanged: self.cardMoved, onEnded: self.cardDropped,onChangedP: self.cardPushed, onEndedP: self.cardUnpushed ,index: 1, text: self.cardText[1])
                            .frame(width: geo.size.height/6 * 0.6
                                , height: geo.size.height/6)
                            .allowsHitTesting(false)
                            .overlay(GeometryReader { geo2 in
                                Color.clear
                                    .overlay(GeometryReader { geo2 in
                                        Color.clear
                                            .onAppear{
                                                self.cardFrames[1] = geo2.frame(in: .global)
                                        }
                                    })
                            })
                            .opacity(self.cardWasDropped[1] ? 1.0 : 0.0)
                            .addBorder(Color.white, cornerRadius: 10)
                        .padding()
                        
                    }
                    HStack {
                        Text(self.quizData.questions[2])
                            .padding()
                        Spacer()
                        Card(onChanged: self.cardMoved, onEnded: self.cardDropped,onChangedP: self.cardPushed, onEndedP: self.cardUnpushed ,index: 2, text: self.cardText[2])
                            .frame(width: geo.size.height/6 * 0.6
                                , height: geo.size.height/6)
                            .allowsHitTesting(false)
                            .overlay(GeometryReader { geo2 in
                                Color.clear
                                    .overlay(GeometryReader { geo2 in
                                        Color.clear
                                            .onAppear{
                                                self.cardFrames[2] = geo2.frame(in: .global)
                                        }
                                    })
                            })
                            .opacity(self.cardWasDropped[2] ? 1.0 : 0.0)
                            .addBorder(Color.white, cornerRadius: 10)
                        .padding()
                        
                    }
                    VStack {
                        HStack {
                        ForEach(0..<3) { number in
                            Card(onChanged: self.cardMoved, onEnded: self.cardDropped,onChangedP: self.cardPushed, onEndedP: self.cardUnpushed, index: number, text: self.quizData.answers[number])
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
                    if trayCardText == quizData.answers[0]{cardGood[0] = true}
                case 1:
                    cardText[1] = trayCardText
                    if trayCardText == quizData.answers[1]{cardGood[1] = true}
                case 2:
                    cardText[2] = trayCardText
                    if trayCardText == quizData.answers[2]{cardGood[2] = true}
                default:
                    print()
                }
                if self.cardGood[0] && self.cardGood[1] && self.cardGood[2] {
                    print("isGood")
                }
            }
        }
        func cardMoved(location: CGPoint, letter: String) -> DragState {
            if let match = cardFrames.firstIndex(where: {
                $0.contains(location)
            }) {
                print("moving")
                if match == 0 || match == 1 || match == 2{
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
                trayCardText = quizData.answers[cardIndex]
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
            for n in 0...2 {
                if cardText[n] == quizData.answers[0]{self.trayCardDropped[0] = true }
                if cardText[n] == quizData.answers[1] {self.trayCardDropped[1] = true }
                if cardText[n] == quizData.answers[2] {self.trayCardDropped[2] = true }
                cardIsBeingMoved[n] = false
                self.count = 0
                
            }
        }
    

}
struct QuizView_Previews: PreviewProvider {
    static var previews: some View {
        QuizView()
    }
}

