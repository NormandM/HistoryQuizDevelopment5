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
    @State private var percentComplete: CGFloat = 0.0
    @State private var tryAgain = false
    @State private var timeRemaining = 120
    @State private var quizStarted = false
    @State private var messageAfterAnswer = ""
    @State private var firstLevelFinished = false
    @State private var numberCardsDisplayed = false
    @State private var timer0 = false
    let timer = Timer.publish(every: 1, on: .main, in: .default).autoconnect()
    @ObservedObject var eventTiming = EventTiming()
    @ObservedObject var cardInfo = CardInfo()
    let sequence = Sequence()
    init() {
        // this is not the same as manipulating the proxy directly
        let appearance = UINavigationBarAppearance()
        // this overrides everything you have set up earlier.
        appearance.configureWithTransparentBackground()
        
        // this only applies to big titles
        appearance.largeTitleTextAttributes = [
            .font : UIFont.systemFont(ofSize: 20),
            NSAttributedString.Key.foregroundColor : UIColor.white
        ]
        // this only applies to small titles
        appearance.titleTextAttributes = [
            .font : UIFont.systemFont(ofSize: 30),
            NSAttributedString.Key.foregroundColor : UIColor.white
        ]
        //In the following two lines you make sure that you apply the style for good
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().standardAppearance = appearance
        // This property is not present on the UINavigationBarAppearance
        // object for some reason and you have to leave it til the end
        UINavigationBar.appearance().tintColor = .white
    }
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                ZStack {
                    Image("success")
                        .resizable()
                        .frame(width: geo.size.height/2.5, height: geo.size.height/2.5)
                        .opacity(self.firstLevelFinished ? 1.0 : 0.0)
                    VStack() {
                        NavigationLink(destination: TimeLineView(), isActive: self.$nextViewPresent){
                            Text("")
                        }
                        HStack {
                            ZStack {
                                Text(self.cardDescription)
                                    .lineLimit(100)
                                    .scaledFont(name: "Helvetica Neue", size: self.getFont(tryAgain: self.tryAgain || self.numberCardsDisplayed))
                                    .foregroundColor(.black)
                                    .padding()
                                    .frame(width: geo.size.width/1.0
                                        , height: geo.size.height/7.0
                                )
                                    .background(ColorReference.specialGray)
                                    .cornerRadius(20)
                                    .padding()
                                if self.answerIsGood && self.cardDropped{
                                    
                                    Text(self.messageAfterAnswer)
                                        .scaledFont(name: "Helvetica Neue", size: self.fonts.finalBigFont)
                                        .foregroundColor(self.percentComplete == 1.0 ? ColorReference.specialGreen : .clear)
                                    Ellipse()
                                        .trim(from: 0, to: self.percentComplete)
                                        .stroke( ColorReference.specialGreen, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                                        .frame(width: geo.size.height/8.0, height:  geo.size.height/8.0)
                                        .animation(.easeOut(duration: 2.0))
                                        .onAppear {
                                            print("timer")
                                            self.percentComplete = 1.0
                                            self.cardDescription = ""
                                            self.numberCardsDisplayed = true
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                                
                                                self.cardDescription = "Cards left: \(9 - self.questionNumber)"
                                            }
                                    }
                                }else if !self.answerIsGood && self.cardDropped{
                                    Text(self.messageAfterAnswer)
                                        .scaledFont(name: "Helvetica Neue", size: self.fonts.finalBigFont)
                                        .foregroundColor(self.percentComplete == 1.0 ? ColorReference.specialRed : .clear)
                                    Ellipse()
                                        .trim(from: 0, to: self.percentComplete)
                                        .stroke( ColorReference.specialRed, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                                        .frame(width: geo.size.height/8, height:  geo.size.height/8)
                                        .animation(.easeOut(duration: 2.0))
                                        .onAppear {
                                            self.percentComplete = 1.0
                                            self.cardDescription = ""
                                    }
                                }
                            }
                        }
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
                                .offset(x: self.answerIsGood && self.cardSelected   ? 0 : self.badAnsweOffset)
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
                            Card(onChanged: self.cardMoved, onEnded: self.cardDropped,onChangedP: self.cardPushed, onEndedP: self.cardUnpushed ,index: 0, text:  self.cardInfo.info[self.questionNumber].trayCard0Name)
                                .frame(width: geo.size.height/5 * 0.6
                                    , height: geo.size.height/5)
                                .opacity(self.trayIndex == 0 && self.answerIsGood ? 0 :  self.cardOpacity)
                                .offset(x: self.answerIsGood && self.cardSelected   ? 0.0 : self.badAnsweOffset)
                                .padding()
                        }
                        .padding()
                        ZStack{
                            Rectangle()
                                .fill(ColorReference.specialGray)
                                .frame(width: geo.size.width, height: geo.size.height/7)
                            HStack(alignment: .bottom){
                                Spacer()
                                VStack{
                                    ZStack{
                                        Circle()
                                            .foregroundColor(ColorReference.specialOrange)
                                            .frame(width: geo.size.height/12
                                                , height: geo.size.height/12)
                                        
                                        Text("\(self.timeRemaining)")
                                            .onReceive(self.timer) { _ in
                                                if self.timeRemaining  > 0 && self.quizStarted {
                                                    self.timeRemaining -= 1
                                                }else if self.timeRemaining  == 0 && self.quizStarted {
                                                    self.cardAnimation()
                                                    self.timer0 = true
                                                }
                                        }
                                        .background(ColorReference.specialOrange)
                                        .scaledFont(name: "Helvetica Neue", size: self.fonts.finalBigFont)
                                    }
                                    Text("Time left")
                                }
                                Spacer()
                                VStack {
                                    Button(action: {
                                        print()
                                    }){
                                        Image("FinalCoin").renderingMode(.original)
                                            .resizable()
                                            .frame(width: geo.size.height/12
                                                , height: geo.size.height/12)
                                    }
                                    Text("Buy Coins")
                                }
                                Spacer()
                                VStack{
                                    ZStack{
                                        Circle()
                                            .foregroundColor(ColorReference.specialOrange)
                                            .frame(width: geo.size.height/12
                                                , height: geo.size.height/12)
                                        Text("10")
                                            .background(ColorReference.specialOrange)
                                            .scaledFont(name: "Helvetica Neue", size: self.fonts.finalBigFont)
                                    }
                                    Text("Score")
                                }
                                Spacer()
                            }
                        }
                    }.blur(radius: self.firstLevelFinished ?  75 : 0.0)
                }
            }
            .background(ColorReference.specialGreen)
            .edgesIgnoringSafeArea(.all)
            .navigationBarTitle("Earlier or Later?", displayMode: .inline)
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
                    playSound(sound: "Incoming Text 01", type: "wav")
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
                    playSound(sound: "Incoming Text 01", type: "wav")
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
        self.numberCardsDisplayed = false
        self.timer0 = false
        quizStarted = true
        tryAgain = false
        cardSelected = true
        cardDescription = self.cardInfo.info[self.questionNumber].trayCardDescription1
    }
    func cardUnpushed(location: CGPoint, trayIndex: Int) {
        self.numberCardsDisplayed = true
        self.cardDescription = "Cards left: \(9 - self.questionNumber)"
    }
    func cardAnimation () {
        if answerIsGood && !timer0{
            self.messageAfterAnswer = "Great!"
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self.questionNumber = self.questionNumber + 1
                self.answerIsGood = false
                self.cardDropped = false
                self.cardOpacity = 1.0
                self.cardSelected = false
                self.xOffset0 = 0
                self.xOffset2 = 0
                self.percentComplete = 0
                if self.questionNumber == self.eventTiming.timing.count - 1 {
                    self.firstLevelFinished = true
                    self.quizStarted = false
                    playSound(sound: "music_harp_gliss_up", type: "wav")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                        self.nextViewPresent = true
                        self.timer.upstream.connect().cancel()
                    }
                }
                // if self.questionNumber == 1 {self.nextViewPresent = true}
            }
        }else{
            self.answerIsGood = false
            self.messageAfterAnswer = "Sorry..."
            withAnimation(.linear(duration: 2)) {
                self.badAnsweOffset = 500
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.cardSelected = false
                self.cardDropped = false
                self.percentComplete = 0
                self.questionNumber = 0
                self.badAnsweOffset = 0
                self.xOffset0 = 0
                self.xOffset2 = 0
                self.tryAgain = true
                self.quizStarted = false
                self.timeRemaining = 120
                if self.timer0 {
                    self.cardDescription = "Time out. Try again!"
                }else{
                    self.cardDescription  = "Try again!"
                }
            }
        }
    }
    func getFont(tryAgain: Bool) -> CGFloat {
        if tryAgain {
            print("getting fonts")
            return fonts.finalBigFont
        }else{
            return fonts.fontDimension
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
