//
//  QuizView.swift
//  HistoryQuizDevelopment5
//
//  Created by Normand Martin on 2020-03-01.
//  Copyright © 2020 Normand Martin. All rights reserved.
//

import SwiftUI

struct QuizView: View {
    let fonts = FontsAndConstraintsOptions()
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
    private let timer2 = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var cardIndex = 0
    @State private var timeRemaining = 120
    @State private var quizStarted = false
    @ObservedObject var quizData = QuizData()
    @State private var timer0 = false
    @State private var coins = UserDefaults.standard.integer(forKey: "coins")
    @State private var points = UserDefaults.standard.integer(forKey: "points")
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
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Text(self.quizData.questions[0])
                            .frame(width: geo.size.width/1.5, height: geo.size.height/15, alignment: .leading)
                            .foregroundColor(.white)

                        Card(onChanged: self.cardMoved, onEnded: self.cardDropped,onChangedP: self.cardPushed, onEndedP: self.cardUnpushed ,index: 0, text: self.cardText[0])
                            .frame(width: geo.size.height/7
                                * 0.6
                                , height: geo.size.height/7)
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
                        Spacer()
                    }
                    .padding(.bottom)
                    HStack {
                        Spacer()
                        Text(self.quizData.questions[1])
                            .frame(width: geo.size.width/1.5, height: geo.size.height/15, alignment: .leading)
                            .foregroundColor(.white)
                        Card(onChanged: self.cardMoved, onEnded: self.cardDropped,onChangedP: self.cardPushed, onEndedP: self.cardUnpushed ,index: 1, text: self.cardText[1])
                            .frame(width: geo.size.height/7 * 0.6
                                , height: geo.size.height/7)
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
    
                        Spacer()
                    }
                    .padding(.bottom)
                    HStack {
                        Spacer()
                        Text(self.quizData.questions[2])
                            .frame(width: geo.size.width/1.5, height: geo.size.height/15, alignment: .leading)
                            .foregroundColor(.white)
                        Card(onChanged: self.cardMoved, onEnded: self.cardDropped,onChangedP: self.cardPushed, onEndedP: self.cardUnpushed ,index: 2, text: self.cardText[2])
                            .frame(width: geo.size.height/7 * 0.6
                                , height: geo.size.height/7)
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
                        Spacer()
                        
                    }
                    .padding(.bottom)
                    VStack {
                        HStack {
                             Spacer()
                                Card(onChanged: self.cardMoved, onEnded: self.cardDropped,onChangedP: self.cardPushed, onEndedP: self.cardUnpushed, index: 0, text: self.quizData.answers[0])
                                    .frame(width: geo.size.height/7 * 0.6
                                        , height: geo.size.height/7)
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
                                    .opacity(self.trayCardDropped[0] ? 0.0 : 1.0)
                                     Spacer()
                                Card(onChanged: self.cardMoved, onEnded: self.cardDropped,onChangedP: self.cardPushed, onEndedP: self.cardUnpushed, index: 1, text: self.quizData.answers[1])
                                    .frame(width: geo.size.height/7 * 0.6
                                        , height: geo.size.height/7)
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
                                    .opacity(self.trayCardDropped[1] ? 0.0 : 1.0)
                                     Spacer()
                                Card(onChanged: self.cardMoved, onEnded: self.cardDropped,onChangedP: self.cardPushed, onEndedP: self.cardUnpushed, index: 2, text: self.quizData.answers[2])
                                    .frame(width: geo.size.height/7 * 0.6
                                        , height: geo.size.height/7)
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
                                    .opacity(self.trayCardDropped[2] ? 0.0 : 1.0)
                                    Spacer()

                            
                        }
                        .padding(.bottom)
                        
                        ZStack(){
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
                        
                        
                    }
                }
            }
            .background(ColorReference.specialGreen)
            .edgesIgnoringSafeArea(.all)
            .navigationBarTitle("What are the right dates?", displayMode: .inline)
            
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

