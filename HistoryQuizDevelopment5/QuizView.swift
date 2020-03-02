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
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                VStack {
                    HStack {
                        Text("FirstQuestion")
                            .padding()
                        Spacer()
                        Card(onChanged: self.cardMoved, onEnded: self.cardDropped,onChangedP: self.cardPushed, onEndedP: self.cardUnpushed ,index: 0, text: "Test")
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
                            .opacity(0.0)
                            .addBorder(Color.white, cornerRadius: 10)
                        .padding()
                        
                    }
                    HStack {
                        Text("FirstQuestion")
                            .padding()
                        Spacer()
                        Card(onChanged: self.cardMoved, onEnded: self.cardDropped,onChangedP: self.cardPushed, onEndedP: self.cardUnpushed ,index: 0, text: "Test")
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
                            .opacity(0.0)
                            .addBorder(Color.white, cornerRadius: 10)
                        .padding()
                        
                    }
                    HStack {
                        Text("FirstQuestion")
                            .padding()
                        Spacer()
                        Card(onChanged: self.cardMoved, onEnded: self.cardDropped,onChangedP: self.cardPushed, onEndedP: self.cardUnpushed ,index: 0, text: "Test")
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
                            .opacity(0.0)
                            .addBorder(Color.white, cornerRadius: 10)
                        .padding()
                        
                    }
                    VStack {
                        HStack {
                        ForEach(0..<3) { number in
                            Card(onChanged: self.cardMoved, onEnded: self.cardDropped,onChangedP: self.cardPushed, onEndedP: self.cardUnpushed, index: number, text: "text")
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
                                
                        }
                        
                    }

                    
                }
                }
            }
            .background(ColorReference.specialGreen)
            .edgesIgnoringSafeArea(.all)
            
        }.navigationBarBackButtonHidden(true)
    }
    
    func cardDropped(location: CGPoint, trayIndex: Int, cardAnswer: String) {
        
    }
    func cardMoved(location: CGPoint, letter: String) -> DragState {
        return .good
    }
    func cardPushed(location: CGPoint, trayIndex: Int) {
        
    }
    func cardUnpushed(location: CGPoint, trayIndex: Int) {
    }
}
struct QuizView_Previews: PreviewProvider {
    static var previews: some View {
        QuizView()
    }
}

