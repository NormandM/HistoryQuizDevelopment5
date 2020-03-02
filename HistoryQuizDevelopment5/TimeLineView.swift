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
    @State private var Card0Good = false
    @State private var Card1Good = false
    @State private var Card2Good = false
    @State private var cardGood = [false, false, false, false]
    @State private var trayCardMoved = [false, false, false, false]
    @State private var trayCardDropped = [false, false, false, false]
    @State private var Card3Good = false
    @State private var carDroppedText = ["", "", "", ""]
    @State private var cardPosition = 0
    @State private var cardMoved = 0
    @State private var startOver = false
    @State private var answerIsGood = false
    @State private var goQuizView = false
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
                        Card(onEnded: self.cardDropped, index: number, text: self.questionForSeries.cardName[number])
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
                            .opacity(self.cardGood[number] ? 1.0 : 0.0)
                            .addBorder(Color.white, cornerRadius: 10)
                    }
                }
                .padding()
                Button(action: {
                    for n in 0...3{
                       self.cardGood[n] = false
                        self.trayCardDropped[n] = false
                        self.trayCardMoved[n] = false
                    }
                     self.answerIsGood = false
                    
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
                            .opacity(self.trayCardDropped[number] && self.answerIsGood ? 0.0 : 1.0)
                    }
                }
            }
        }
        .background(ColorReference.specialGreen)
        .edgesIgnoringSafeArea(.all)
        }.navigationBarBackButtonHidden(true)
    }
    func cardDropped(location: CGPoint, trayIndex: Int, cardAnswer: String) {
        if let match = cardFrames.firstIndex(where: {
            $0.contains(location)
            
        }) {
            print(self.questionForSeries.cardName[0])
            print(cardAnswer)
            cardPosition = match
            answerIsGood = true
            switch match {
            case 0:
                if self.questionForSeries.cardName[0] == cardAnswer{self.cardGood[0] = true}
            case 1:
                if self.questionForSeries.cardName[1] == cardAnswer{self.cardGood[1] = true}
            case 2:
                if self.questionForSeries.cardName[2] == cardAnswer{self.cardGood[2] = true}
            case 3:
                if self.questionForSeries.cardName[3] == cardAnswer{self.cardGood[3] = true}
            default:
                print()
            }
            if self.cardGood[0] && self.cardGood[1] && self.cardGood[2] && self.cardGood[3] {
                print("Good answer")
                 self.goQuizView  = true
            }
            for n in 0...3  {
                switch n {
                case 0:
                    trayCardDropped[0] = trayCardMoved[0]
                case 1:
                    trayCardDropped[1] = trayCardMoved[1]
                case 2:
                    trayCardDropped[2] = trayCardMoved[2]
                case 3:
                    trayCardDropped[3] = trayCardMoved[3]
                default:
                    print()
                }
            }
        }
    }
    func cardMoved(location: CGPoint, letter: String) -> DragState {
        if let match = cardFrames.firstIndex(where: {
            $0.contains(location)
        }) {
            cardMoved = match
            // print("cardMoved: \(cardMoved)")
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
            switch match {
            case 0:
                trayCardMoved[0] = true
            case 1:
                trayCardMoved[1] = true
            case 2:
                trayCardMoved[2] = true
            case 3:
                trayCardMoved[3] = true
            default:
                print()
            }
        }
    }
    func cardUnpushed(location: CGPoint, trayIndex: Int) {
        
    }
    
}

struct TimeLineView_Previews: PreviewProvider {
    static var previews: some View {
        TimeLineView()
    }
}
