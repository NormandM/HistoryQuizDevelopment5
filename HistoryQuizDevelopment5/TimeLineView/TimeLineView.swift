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
    @State private var cardIsBeingMoved = [false, false, false, false]
    @State private var allCardsDropped = false
    @State private var badAnsweOffset = CGFloat()
    @State private var messageAfterAnswer = ""
    @State private var count = 0
    @State private var tryAgain = false
    @State private var cardIndex = 0
    @State private var timeRemaining = 120
    @State private var quizStarted = false
    @State private var cardDescription = ""
    @State private var serieNumbers = 0
    @State private var xOffset: CGFloat = 0.0
    @State private var xOffset2: CGFloat = 0.0
    @State private var percentComplete: CGFloat = 0.0
    @State private var answerIsGood = false
    @State private var serieNumberDisplayed = false
    @State private var secondLevelFinished = false
    @State private var numberToFinish = 0
    @State private var secondLevelWrong = false
    @State private var coins = UserDefaults.standard.integer(forKey: "coins")
    @State private var points = UserDefaults.standard.integer(forKey: "points")
    private let timer2 = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var timer0 = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var questionForSeries = QuestionsForSeries()
    init() {
        // this is not the same as manipulating the proxy directly
        let appearance = UINavigationBarAppearance()
        // this overrides everything you have set up earlier.
        appearance.configureWithTransparentBackground()
        
        //           // this only applies to big titles
        appearance.largeTitleTextAttributes = [
            .font : UIFont.systemFont(ofSize: 20),
            NSAttributedString.Key.foregroundColor : UIColor.white
        ]
        appearance.titleTextAttributes = [
            .font : UIFont.systemFont(ofSize: 29),
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
                    if self.secondLevelFinished  && !self.timer0{
                        Image("Pouce haut3")
                            .resizable()
                            .frame(width: geo.size.height/2.5, height: geo.size.height/2.5)
                            .cornerRadius(25)
                            .opacity(self.secondLevelFinished ? 1.0 : 0.0)
                    }else if self.timer0 || (self.allCardsDropped && !self.answerIsGood){
                        Image("Pouce bas")
                            .resizable()
                            .cornerRadius(25)
                            .opacity(self.timer0 || (self.allCardsDropped && !self.answerIsGood) ? 1.0 : 0)
                            .frame(width: geo.size.height/2.5, height: geo.size.height/2.5)
                        HStack {
                            VStack {
                                Text("Back to level 1")
                                    .foregroundColor(.white)
                                Button(action: {
                                    self.presentationMode.wrappedValue.dismiss()
                                }){
                                    Image("0Coin").renderingMode(.original)
                                        .resizable()
                                        .frame(width: geo.size.height/12
                                            , height: geo.size.height/12)
                                }
                                Text("coins")
                                    .foregroundColor(.white)
                            }
                            .offset(x: -geo.size.height/16, y: geo.size.height/9)
                            
                            VStack {
                                Text("Stay on level 2")
                                    .foregroundColor(.white)
                                Button(action: {
                                    self.secondLevelFinished = false
                                    self.timer0 = false
                                    self.secondLevelWrong = false
                                    self.serieNumbers = 0
                                    self.cardDescription = "Try again"
                                    self.messageAfterAnswer = ""
                                    self.allCardsDropped = false
                                    self.percentComplete = 0.0
                                    self.quizStarted = false
                                    self.timeRemaining = 120
                                    for n in 0...3{
                                        self.cardWasDropped[n] = false
                                        self.trayCardDropped[n] = false
                                        self.cardIsBeingMoved[n] = false
                                        self.cardText[n] = ""
                                    }
                                    self.xOffset2 = 0
                                    self.xOffset = 0
                                    self.numberToFinish = 0
                                    self.coins -= 5
                                    UserDefaults.standard.set(self.coins, forKey: "coins")
                                    
                                }){
                                    Image("5Coin").renderingMode(.original)
                                        .resizable()
                                        .frame(width: geo.size.height/12
                                            , height: geo.size.height/12)
                                    
                                }
                                Text("coins")
                                    .foregroundColor(.white)
                            }
                            .offset(x: geo.size.height/16 , y: geo.size.height/9)
                        }
                    }
                    VStack {
                        NavigationLink(destination: QuizView(), isActive: self.$goQuizView){
                            Text("")
                        }
                        .padding()
                        HStack {
                            ZStack {
                                Text(self.cardDescription)
                                    .lineLimit(100)
                                    .scaledFont(name: "Helvetica Neue", size: self.getFont(tryAgain: self.tryAgain || self.serieNumberDisplayed))
                                    .foregroundColor(.black)
                                    .padding()
                                    .frame(width: geo.size.width/1.0, height: geo.size.height/7
                                )
                                    .border(Color.white)
                                    .background(ColorReference.specialGray)
                                    .cornerRadius(20)
                                if self.answerIsGood && self.allCardsDropped{
                                    Text(self.messageAfterAnswer)
                                        .scaledFont(name: "Helvetica Neue", size: self.getFont(tryAgain: self.tryAgain))
                                        .foregroundColor(self.percentComplete == 1.0 ? ColorReference.specialGreen : .clear)
                                    Ellipse()
                                        .trim(from: 0, to: self.percentComplete)
                                        .stroke( ColorReference.specialGreen, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                                        .frame(width: geo.size.height/8.0, height:  geo.size.height/8.0)
                                        .animation(.easeOut(duration: 2.0))
                                        .onAppear {
                                            self.percentComplete = 1.0
                                            self.cardDescription = ""
                                    }
                                }else if !self.answerIsGood && self.allCardsDropped{
                                    Text(self.messageAfterAnswer)
                                        .scaledFont(name: "Helvetica Neue", size: self.getFont(tryAgain: self.tryAgain))
                                        .foregroundColor(self.percentComplete == 1.0 ? ColorReference.specialRed : .clear)
                                    Ellipse()
                                        .trim(from: 0, to: self.percentComplete)
                                        .stroke( ColorReference.specialRed, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                                        .frame(width: geo.size.height/8, height:  geo.size.height/8)
                                        .animation(.easeOut(duration: 2.0))
                                        .onAppear {
                                            self.percentComplete = 1.0
                                            self.cardDescription = ""
                                            self.serieNumberDisplayed = true
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 7.0) {
                                                self.cardDescription = "Serie 2 of 2"
                                            }
                                    }
                                }
                            }
                        }
                        
                        HStack() {
                            Spacer()
                            Card(onEnded: self.cardDropped, index: 0, text: self.cardText[0])
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
                                .offset(x: self.serieNumbers == 0 ? self.xOffset : 0.0)
                                .addBorder(self.cardWasDropped[0] ? Color.clear : Color.white, cornerRadius: 10)
                                .padding(.leading)
                            
                            Spacer()
                            Card(onEnded: self.cardDropped, index: 1, text: self.cardText[1])
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
                                .offset(x: self.serieNumbers == 0 ? self.xOffset : 0.0)
                                .addBorder(self.cardWasDropped[1] ? Color.clear : Color.white, cornerRadius: 10)
                            Spacer()
                            Card(onEnded: self.cardDropped, index: 2, text: self.cardText[2])
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
                                .offset(x: self.serieNumbers == 0 ? self.xOffset : 0.0)
                                .addBorder(self.cardWasDropped[2] ? Color.clear : Color.white, cornerRadius: 10)
                            Spacer()
                            Card(onEnded: self.cardDropped, index: 3, text: self.cardText[3])
                                .frame(width: geo.size.height/6 * 0.6
                                    , height: geo.size.height/6)
                                .allowsHitTesting(false)
                                .overlay(GeometryReader { geo2 in
                                    Color.clear
                                        .overlay(GeometryReader { geo2 in
                                            Color.clear
                                                .onAppear{
                                                    self.cardFrames[3] = geo2.frame(in: .global)
                                            }
                                        })
                                })
                                .opacity(self.cardWasDropped[3] ? 1.0 : 0.0)
                                .offset(x: self.serieNumbers == 0 ? self.xOffset : 0.0)
                                .addBorder(self.cardWasDropped[3] ? Color.clear : Color.white, cornerRadius: 10)
                                .padding(.trailing)
                            Spacer()
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
                            self.allCardsDropped = false
                            
                        }){
                            Text("Start Over")
                                .scaledFont(name: "Helvetica Neue", size: self.fonts.fontDimension)
                                .padding()
                                .background(ColorReference.specialGreen)
                                .cornerRadius(40)
                                .foregroundColor(.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 40)
                                        .stroke(Color.white, lineWidth: 2)
                            )
                        }
                        HStack {
                            Spacer()
                            Card(onChanged: self.cardMoved, onEnded: self.cardDropped,onChangedP: self.cardPushed, onEndedP: self.cardUnpushed, index: 0, text: self.questionForSeries.seriesInfo[self.serieNumbers].trayCardName[0])
                                .frame(width: geo.size.height/6 * 0.6
                                    , height: geo.size.height/6)
                                .overlay(GeometryReader { geo2 in
                                    Color.clear
                                        .overlay(GeometryReader { geo2 in
                                            Color.clear
                                                .onAppear{
                                                    self.trayCardsFrames[0] = geo2.frame(in: .global)
                                            }
                                        })
                                })
                                .zIndex(self.cardIsBeingMoved[0] ? 1.0 : 0.5)
                                .offset(x: self.serieNumbers == 0 ? self.xOffset : 0)
                                .offset(x: self.serieNumbers == 1 ? self.xOffset2 : 0)
                                .opacity(self.trayCardDropped[0] ? 0.0 : 1.0)
                                .padding(.leading)
                            Spacer()
                            Card(onChanged: self.cardMoved, onEnded: self.cardDropped,onChangedP: self.cardPushed, onEndedP: self.cardUnpushed, index: 1, text: self.questionForSeries.seriesInfo[self.serieNumbers].trayCardName[1])
                                .frame(width: geo.size.height/6 * 0.6
                                    , height: geo.size.height/6)
                                .overlay(GeometryReader { geo2 in
                                    Color.clear
                                        .overlay(GeometryReader { geo2 in
                                            Color.clear
                                                .onAppear{
                                                    self.trayCardsFrames[1] = geo2.frame(in: .global)
                                            }
                                        })
                                })
                                .zIndex(self.cardIsBeingMoved[1] ? 1.0 : 0.5)
                                .offset(x: self.serieNumbers == 0 ? self.xOffset : 0)
                                .offset(x: self.serieNumbers == 1 ? self.xOffset2 : 0)
                                .opacity(self.trayCardDropped[1] ? 0.0 : 1.0)
                            Spacer()
                            Card(onChanged: self.cardMoved, onEnded: self.cardDropped,onChangedP: self.cardPushed, onEndedP: self.cardUnpushed, index: 2, text: self.questionForSeries.seriesInfo[self.serieNumbers].trayCardName[2])
                                .frame(width: geo.size.height/6 * 0.6
                                    , height: geo.size.height/6)
                                .overlay(GeometryReader { geo2 in
                                    Color.clear
                                        .overlay(GeometryReader { geo2 in
                                            Color.clear
                                                .onAppear{
                                                    self.trayCardsFrames[2] = geo2.frame(in: .global)
                                            }
                                        })
                                })
                                .zIndex(self.cardIsBeingMoved[2] ? 1.0 : 0.5)
                                .offset(x: self.serieNumbers == 0 ? self.xOffset : 0)
                                .offset(x: self.serieNumbers == 1 ? self.xOffset2 : 0)
                                .opacity(self.trayCardDropped[2] ? 0.0 : 1.0)
                            Spacer()
                            Card(onChanged: self.cardMoved, onEnded: self.cardDropped,onChangedP: self.cardPushed, onEndedP: self.cardUnpushed, index: 3, text: self.questionForSeries.seriesInfo[self.serieNumbers].trayCardName[3])
                                .frame(width: geo.size.height/6 * 0.6
                                    , height: geo.size.height/6)
                                .overlay(GeometryReader { geo2 in
                                    Color.clear
                                        .overlay(GeometryReader { geo2 in
                                            Color.clear
                                                .onAppear{
                                                    self.trayCardsFrames[3] = geo2.frame(in: .global)
                                            }
                                        })
                                })
                                .zIndex(self.cardIsBeingMoved[3] ? 1.0 : 0.5)
                                .offset(x: self.serieNumbers == 0 ? self.xOffset : 0)
                                .offset(x: self.serieNumbers == 1 ? self.xOffset2 : 0)
                                .opacity(self.trayCardDropped[3] ? 0.0 : 1.0)
                                .padding(.trailing)
                            Spacer()
                        }
                        .padding()
                        
                        ZStack{
                            Rectangle()
                                .fill(ColorReference.specialGray)
                                .frame(width: geo.size.width, height: geo.size.height/7
                            )
                            HStack(alignment: .bottom){
                                Spacer()
                                VStack{
                                    ZStack{
                                        Circle()
                                            .foregroundColor(ColorReference.specialOrange)
                                            .frame(width: geo.size.height/12
                                                , height: geo.size.height/12)
                                        
                                        Text("\(self.timeRemaining)")
                                            .onReceive(self.timer2) { _ in
                                                if self.timeRemaining  > 0 && self.quizStarted {
                                                    self.timeRemaining -= 1
                                                }else if self.timeRemaining  == 0 && self.quizStarted {
                                                    self.timer0 = true
                                                }
                                        }
                                        .background(ColorReference.specialOrange)
                                        .scaledFont(name: "Helvetica Neue", size: self.fonts.finalBigFont)
                                    }
                                    Text("Time left")
                                        .scaledFont(name: "Helvetica Neue", size: self.fonts.smallFontDimension )
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
                                    
                                    Text("\(self.coins) coins")
                                        .scaledFont(name: "Helvetica Neue", size: self.fonts.smallFontDimension )
                                }
                                Spacer()
                                VStack{
                                    ZStack{
                                        Circle()
                                            .foregroundColor(ColorReference.specialOrange)
                                            .frame(width: geo.size.height/12
                                                , height: geo.size.height/12)
                                        Text("\(self.points)")
                                            .background(ColorReference.specialOrange)
                                            .scaledFont(name: "Helvetica Neue", size: self.fonts.finalBigFont)
                                    }
                                    Text("Score")
                                        .scaledFont(name: "Helvetica Neue", size: self.fonts.smallFontDimension )
                                }
                                Spacer()
                            }
                        }
                        .padding()
                        .padding()
                    }.blur(radius: self.secondLevelFinished || (self.timer0 || self.secondLevelWrong)  ?  75 : 0.0)
                        .zIndex(-0.5)
                }
            }
            .background(ColorReference.specialGreen)
            .edgesIgnoringSafeArea(.all)
            .navigationBarTitle("What is the right order?", displayMode: .inline)
        }
        .navigationBarBackButtonHidden(true)
        .navigationViewStyle(StackNavigationViewStyle())
    }
    func cardDropped(location: CGPoint, trayIndex: Int, cardAnswer: String) {
        if let match = cardFrames.firstIndex(where: {
            $0.contains(location)
            
        }) {
            self.cardWasDropped[match] = true
            switch match {
            case 0:
                cardText[0] = trayCardText
                playSound(sound: "404015__paul-sinnett__card", type: "wav")
                if trayCardText == questionForSeries.seriesInfo[serieNumbers].rightPositionCard[0]{cardGood[0] = true}
            case 1:
                cardText[1] = trayCardText
                playSound(sound: "404015__paul-sinnett__card", type: "wav")
                if trayCardText == questionForSeries.seriesInfo[serieNumbers].rightPositionCard[1]{cardGood[1] = true}
            case 2:
                cardText[2] = trayCardText
                playSound(sound: "404015__paul-sinnett__card", type: "wav")
                if trayCardText == questionForSeries.seriesInfo[serieNumbers].rightPositionCard[2]{cardGood[2] = true}
            case 3:
                cardText[3] = trayCardText
                playSound(sound: "404015__paul-sinnett__card", type: "wav")
                if trayCardText == questionForSeries.seriesInfo[serieNumbers].rightPositionCard[3]{cardGood[3] = true}
            default:
                print()
            }
            if cardText[0] != "" && cardText[1] != "" && cardText[2] != "" && cardText[3] != ""{
                allCardsDropped = true
            }
            
            if self.cardGood[0] && self.cardGood[1] && self.cardGood[2] && self.cardGood[3] && self.allCardsDropped{
                answerIsGood = true
            }else if self.allCardsDropped{
                answerIsGood = false
                withAnimation(.linear(duration: 2.0)) {
                    secondLevelWrong = !answerIsGood && allCardsDropped
                }
            }
            cardAnimation()
        }
    }
    func cardMoved(location: CGPoint, letter: String) -> DragState {
        if let match = cardFrames.firstIndex(where: {
            $0.contains(location)
        }) {
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
            self.serieNumberDisplayed = true
            self.count = self.count + 1
            if self.count == 1 {cardIndex = match}
            trayCardText = questionForSeries.seriesInfo[serieNumbers].trayCardName[cardIndex]
            cardDescription = questionForSeries.seriesInfo[serieNumbers].cardDescription[cardIndex]
            switch cardIndex {
            case 0:
                cardIsBeingMoved[0] = true
            case 1:
                cardIsBeingMoved[1] = true
            case 2:
                cardIsBeingMoved[2] = true
            case 3:
                cardIsBeingMoved[2] = true
            default:
                print()
            }
        }
        self.timer0 = false
        quizStarted = true
        tryAgain = false
        self.serieNumberDisplayed = false
    }
    func cardUnpushed(location: CGPoint, trayIndex: Int) {
        if serieNumbers == 0 {
            cardDescription = "Serie 1 of 2"
        }else{
            cardDescription = "Serie 2 of 2"
        }
        for n in 0...3 {
            if cardText[n] == questionForSeries.seriesInfo[serieNumbers].trayCardName[0] {self.trayCardDropped[0] = true }
            if cardText[n] == questionForSeries.seriesInfo[serieNumbers].trayCardName[1] {self.trayCardDropped[1] = true }
            if cardText[n] == questionForSeries.seriesInfo[serieNumbers].trayCardName[2] {self.trayCardDropped[2] = true }
            if cardText[n] == questionForSeries.seriesInfo[serieNumbers].trayCardName[3] {self.trayCardDropped[3] = true }
            cardIsBeingMoved[n] = false
            self.count = 0
        }
        self.serieNumberDisplayed = true
        tryAgain = true
    }
    func cardAnimation () {
        if answerIsGood  && !timer0 {
            self.messageAfterAnswer = "Great!"
            playSound(sound: "chime_clickbell_octave_up", type: "mp3")
            withAnimation(.linear(duration: 3.0)) {
                self.xOffset = 2000
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.tryAgain = true
                if self.serieNumbers < 1 {self.serieNumbers = self.serieNumbers + 1}
                self.points = UserDefaults.standard.integer(forKey: "points")
                self.points += 1
                UserDefaults.standard.set(self.points, forKey: "points")
                self.numberToFinish += 1
                for n in 0...3 {
                    self.percentComplete = 0
                    self.allCardsDropped = false
                    self.answerIsGood = false
                    self.cardWasDropped[n] = false
                    self.trayCardDropped[n] = false
                    self.cardGood[n] = false
                    self.cardText[n] = ""
                    print()
                }
                if self.numberToFinish == 2 {
                    self.points = UserDefaults.standard.integer(forKey: "points")
                    self.points += 5
                    UserDefaults.standard.set(self.points, forKey: "points")
                    withAnimation(.linear(duration: 2)){
                        self.secondLevelFinished  = true
                        playSound(sound: "music_harp_gliss_up", type: "wav")
                        
                    }
                    self.timer2.upstream.connect().cancel()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                        self.goQuizView  = true
                    }
                }
            }
        }else if timer0 || allCardsDropped{
            self.timer2.upstream.connect().cancel()
            self.answerIsGood = false
            self.messageAfterAnswer = "Sorry..."
            playSound(sound: "Error Warning", type: "wav")
            withAnimation(.linear(duration: 2)) {
                self.badAnsweOffset = 500
            }
        }
        withAnimation(.linear(duration: 6.0)) {
            self.xOffset2 = 0
        }
        tryAgain = true
    }
    func getFont(tryAgain: Bool) -> CGFloat {
        if tryAgain {
            return fonts.finalBigFont
        }else{
            return fonts.fontDimension
        }
    }
}

struct TimeLineView_Previews: PreviewProvider {
    static var previews: some View {
        TimeLineView()
    }
}
