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
    @State private var cardDescription = ""
 //   @ObservedObject var eventTiming = EventTiming()
    @ObservedObject var cardInfo = CardInfo()

    var body: some View {
        NavigationView {
            
        GeometryReader { geo in
            VStack() {
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
                                    print(self.cardInfo.info[self.questionNumber].card0Name)
                            }
                        })
                        .opacity(self.answerIsGood ? 1.0 : 0.0)
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
                                     print(self.cardInfo.info[self.questionNumber].card1Name)
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
                                     print(self.cardInfo.info[self.questionNumber].card2Name)
                            }
                        })
                        .opacity(self.answerIsGood ? 1.0 : 0.0)
                        .offset(x: self.answerIsGood && self.cardSelected ? self.xOffset2 : self.badAnsweOffset)
                        .addBorder(!self.answerIsGood ? Color.white : Color.clear, cornerRadius: 10)
                }
                HStack {
                    Text(self.cardDescription)
                        .lineLimit(100)
                        .scaledFont(name: "Helvetica Neue", size: self.fonts.fontDimension)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: geo.size.width/1.0, height: geo.size.height/3.2
                    )
                        .border(Color.white)
                        .background(ColorReference.specialGray)
                }
                HStack {
                    Card(onChanged: self.cardMoved, onEnded: self.cardDropped,onChangedP: self.cardPushed, onEndedP: self.cardUnpushed ,index: 0, text:  self.cardInfo.info[self.questionNumber].trayCard0Name)
                        .frame(width: geo.size.height/5 * 0.6
                            , height: geo.size.height/5)
                        .overlay(GeometryReader { geo2 in
                            Color.clear
                                .onAppear{
                                    self.trayCardsFrames[0] = geo2.frame(in: .global)
                            }
                            
                        })
                        .offset(x: self.answerIsGood && self.cardSelected   ? 0 : -self.badAnsweOffset)
                        .opacity(self.trayIndex == 0 && self.answerIsGood ? 0 :  self.cardOpacity)
                        .offset(x: self.answerIsGood && self.cardSelected   ? 0.0 : self.badAnsweOffset)
                        .opacity(self.trayIndex == 2 && self.answerIsGood ? 0 :  self.cardOpacity)
                        .padding()
                        .navigationBarItems(leading:
                            HStack {
                                VStack{
                                    Text("Score")
                                        .font(.title)
                                    
                                    
                                    Text("10")
                                        .font(.title)
                                }.foregroundColor(.white)
                                    

                                    .padding(geo.size.width/7)
                            }, trailing:
                            
                            HStack {
                                VStack{
                                    Text("Timer")
                                        .font(.title)
                                    
                                    Text("10")
                                        .font(.title)
                                }.foregroundColor(.white)
                    
                                    .padding(geo.size.width/7)
                            }        )
                    
                    
                    
                }
                
                
            }
        }
        .padding()
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
            print(cardAnswer)
            print(self.cardInfo.info[questionNumber].rightAnswer)
            switch match {
            case 0:
                if self.cardInfo.info[questionNumber].rightAnswer  == cardAnswer {
                    answerIsGood = true
                    playSound(sound: "music_harp_gliss_up", type: "wav")
                    withAnimation(Animation.easeInOut(duration: 2).delay(1)) {
                        print(xOffset0)
                        self.xOffset0 = centerCardPosition - rightCardPosition
                    }
                }else{
                    answerIsGood = false
                }
            case 2:
                if self.cardInfo.info[questionNumber].rightAnswer == cardAnswer {
                    answerIsGood = true
                    withAnimation(Animation.easeInOut(duration: 2.0).delay(1.0)) {
                        self.xOffset2 = centerCardPosition - leftCardPosition
                    }
                    
                }else{
                    answerIsGood = false
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
        if let match = trayCardsFrames.firstIndex(where: {
            $0.contains(location)
        }){
            cardSelected = true
            self.trayIndex = match

            cardDescription = self.cardInfo.info[self.questionNumber].trayCardDescription1


        }
        
    }
    func cardUnpushed(location: CGPoint, trayIndex: Int) {
        cardDescription = ""
    }
    func cardAnimation () {
        if answerIsGood {
            print(self.cardOpacity)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                withAnimation(.linear(duration: 2)) {
                    self.cardOpacity -= 1.0
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                self.questionNumber = self.questionNumber + 1
                self.answerIsGood = false
                self.cardOpacity = 1.0
                self.cardSelected = false
                self.xOffset0 = 0
                self.xOffset2 = 0
            }
        }else{
            withAnimation(.linear(duration: 2)) {
                self.badAnsweOffset = 500
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
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
