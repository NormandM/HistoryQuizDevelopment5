//
//  ContentView.swift
//  HistoryQuizDevelopment5
//
//  Created by Normand Martin on 2020-02-24.
//  Copyright © 2020 Normand Martin. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    let fonts = FontsAndConstraintsOptions()
    @State private var cardFrames = [CGRect](repeating: .zero, count: 3)
    @State private var trayCardsFrames = [CGRect](repeating: .zero, count: 3)
    @State private var xOffset0 = CGFloat()
    @State private var xOffset2 = CGFloat()
    @State private var badAnsweOffset = CGFloat()
    @State private var rightCardPosition  = CGFloat()
    @State private var centerCardPosition  = CGFloat()
    @State private var leftCardPosition  = CGFloat()
    @State private var answerIsGood = false
    @State private var trayIndex = 0
    @State private var cardOpacity = 1.0
    @State private var eventIsEarlier = false
    @State private var questionNumber = 0
    @State private var cardSelected = false
    @State private var cardDropped = false
    @State private var cardDescription = ""
    @State private var nextViewPresent = false
    @State var percentComplete: CGFloat = 0.0
    @ObservedObject var eventTiming = EventTiming()
    @ObservedObject var cardInfo = CardInfo()
    let sequence = Sequence()
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                VStack() {
                    NavigationLink(destination: TimeLineView(), isActive: self.$nextViewPresent){
                        Text("")
                    }
                    Spacer()
                        .frame(height: 10)
                    HStack {
                        Card(onEnded: self.cardDropped, index: 0, text: self.cardInfo.info[self.questionNumber].card0Name)
                            .frame(width: geo.size.height/5 * 0.6
                                , height: geo.size.height/5)
                            .zIndex(1.0)
                            .allowsHitTesting(false)
                            .overlay(GeometryReader { geo2 in
                                Color.clear
                                    .coordinateSpace(name: "RightCard")
                                    .onAppear{
                                        self.cardFrames[0] = geo2.frame(in: .global)
                                        self.rightCardPosition = geo2.frame(in: .named("RightCard")).midX
                                        print(self.sequence.sequence)
                                }
                            })
                            .opacity(self.answerIsGood && self.self.eventTiming.timing[self.questionNumber].eventIsEarlier ? 1.0 : 0.0)
                            .offset(x: self.answerIsGood && self.cardSelected   ? self.xOffset0 : -self.badAnsweOffset)
                            .addBorder(!self.answerIsGood ? Color.white : Color.clear, cornerRadius: 10)
                        Card(onEnded: self.cardDropped, index: 1, text:  self.cardInfo.info[self.questionNumber].card1Name)
                            .frame(width: geo.size.height/5 * 0.6
                                , height: geo.size.height/5)
                            .zIndex(0.0)
                            .coordinateSpace(name: "CenterCard")
                            .allowsHitTesting(false).overlay(GeometryReader { geo2 in
                                Color.clear
                                    .onAppear{
                                        self.cardFrames[1] = geo2.frame(in: .global)
                                        self.centerCardPosition = geo2.frame(in: .named("CenterCard")).midX
                                }
                            })
                            .offset(y: self.answerIsGood && self.cardSelected   ? 0 : -self.badAnsweOffset)
                            .padding()
                        
                        Card(onEnded: self.cardDropped, index: 2, text:  self.cardInfo.info[self.questionNumber].card2Name)
                            .frame(width: geo.size.height/5 * 0.6
                                , height: geo.size.height/5)
                            .zIndex(1.0)
                            .coordinateSpace(name: "LeftCard")
                            .allowsHitTesting(false).overlay(GeometryReader { geo2 in
                                Color.clear
                                    .onAppear{
                                        self.cardFrames[2] = geo2.frame(in: .global)
                                        self.leftCardPosition = geo2.frame(in: .named("LeftCard")).midX
                                }
                            })
                            .opacity(self.answerIsGood && !self.self.eventTiming.timing[self.questionNumber].eventIsEarlier ? 1.0 : 0.0)
                            .offset(x: self.answerIsGood && self.cardSelected ? self.xOffset2 : self.badAnsweOffset)
                            .addBorder(!self.answerIsGood ? Color.white : Color.clear, cornerRadius: 10)
                    }
                    HStack {
                        ZStack {
                            Text(self.cardDescription)
                                .lineLimit(100)
                                .scaledFont(name: "Helvetica Neue", size: self.fonts.fontDimension)
                                .foregroundColor(.black)
                                .padding()
                                .frame(width: geo.size.width/1.0, height: geo.size.height/3.2
                            )
                                .border(Color.white)
                                .background(ColorReference.specialGray)
                                .cornerRadius(20)
                                .padding()
                            if self.answerIsGood && self.cardDropped{
                                Text("Great!")
                                    .scaledFont(name: "Helvetica Neue", size: self.fonts.finalBigFont)
                                    .foregroundColor(self.percentComplete == 1.0 ? ColorReference.specialGreen : .clear)
                                Ellipse()
                                    .trim(from: 0, to: self.percentComplete)
                                    .stroke( ColorReference.specialGreen, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                                    .frame(width: geo.size.height/4, height:  geo.size.height/4)
                                    .animation(.easeOut(duration: 2.0))
                                    .onAppear {
                                        self.percentComplete = 1.0
                                }
                            }else if !self.answerIsGood && self.cardDropped {
                                Text("Sorry...")
                                    .scaledFont(name: "Helvetica Neue", size: self.fonts.finalBigFont)
                                    .foregroundColor(self.percentComplete == 1.0 ? ColorReference.specialRed : .clear)
                                Ellipse()
                                    .trim(from: 0, to: self.percentComplete)
                                    .stroke( ColorReference.specialRed, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                                    .frame(width: geo.size.height/4, height:  geo.size.height/4)
                                    .animation(.easeOut(duration: 2.0))
                                    .onAppear {
                                        self.percentComplete = 1.0
                                }
                            }
                        }
                    }
                    HStack {
                        Card(onChanged: self.cardMoved, onEnded: self.cardDropped,onChangedP: self.cardPushed, onEndedP: self.cardUnpushed ,index: 0, text:  self.cardInfo.info[self.questionNumber].trayCard0Name)
                            .frame(width: geo.size.height/5 * 0.6
                                , height: geo.size.height/5)
                            .opacity(self.trayIndex == 0 && self.answerIsGood ? 0 :  self.cardOpacity)
                            .offset(x: self.answerIsGood && self.cardSelected   ? 0.0 : self.badAnsweOffset)
                            .padding()
                    }
                }

            }
            .background(ColorReference.specialGreen)
            .edgesIgnoringSafeArea(.all)
            
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    // Functions
    func cardDropped(location: CGPoint, trayIndex: Int, cardAnswer: String){
        if let match = cardFrames.firstIndex(where: {
            $0.contains(location)
        }) {
            cardDropped = true
            switch match {
            case 0:
                if  self.eventTiming.timing[self.questionNumber].eventIsEarlier{
                    answerIsGood = true
                    playSound(sound: "music_harp_gliss_up", type: "wav")
                    withAnimation(Animation.easeInOut(duration: 2).delay(1)) {
                        self.xOffset0 = centerCardPosition - rightCardPosition
                    }
                }else{
                    answerIsGood = false
                    playSound(sound: "Error Warning", type: "wav")
                }
            case 2:
                if !self.eventTiming.timing[self.questionNumber].eventIsEarlier {
                    answerIsGood = true
                    playSound(sound: "music_harp_gliss_up", type: "wav")
                    withAnimation(Animation.easeInOut(duration: 2.0).delay(1.0)) {
                        self.xOffset2 = centerCardPosition - leftCardPosition
                    }
                    
                }else{
                    answerIsGood = false
                    playSound(sound: "Error Warning", type: "wav")
                }
            default:
                print("bad")
            }
        }
        cardAnimation()
    }
    func cardMoved(location: CGPoint, letter: String) -> DragState {
        if let match = cardFrames.firstIndex(where: {
            $0.contains(location)
        }) {
            if match == 0 || match == 2 {
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
        cardSelected = true
        cardDescription = self.cardInfo.info[self.questionNumber].trayCardDescription1
        
    }
    func cardUnpushed(location: CGPoint, trayIndex: Int) {
        cardDescription = ""
    }
    func cardAnimation () {
        if answerIsGood {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self.questionNumber = self.questionNumber + 1
                self.answerIsGood = false
                self.cardDropped = false
                self.cardOpacity = 1.0
                self.cardSelected = false
                self.xOffset0 = 0
                self.xOffset2 = 0
                self.percentComplete = 0
               // if self.questionNumber == self.eventTiming.timing.count - 1 {self.nextViewPresent = true}
               if self.questionNumber == 1 {self.nextViewPresent = true}
            }
        }else{
            withAnimation(.linear(duration: 2)) {
                self.badAnsweOffset = 500
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self.cardSelected = false
                self.cardDropped = false
                self.percentComplete = 0
                self.questionNumber = 0
                self.badAnsweOffset = 0
                self.xOffset0 = 0
                self.xOffset2 = 0
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
