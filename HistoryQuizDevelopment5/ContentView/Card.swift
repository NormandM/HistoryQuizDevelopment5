//
//  Card.swift
//  HistoryQuizDevelopement2
//
//  Created by Normand Martin on 2019-12-21.
//  Copyright © 2019 Normand Martin. All rights reserved.
//

import SwiftUI
import Combine
enum DragState {
    case unknown
    case good
    case bad
}

struct Card: View {
    let fonts = FontsAndConstraintsOptions()
    @State private var dragAmount = CGSize.zero
    @State private var dragState = DragState.unknown
    @State private var touching = false
    @State private var gradient = Gradient(colors: [ColorReference.specialOrange, ColorReference.specialGray])
    var onChanged: ((CGPoint, String) -> DragState)?
    var onEnded: ((CGPoint, Int, String) -> Void)?
    var onChangedP: ((CGPoint, Int) -> ())?
    var onEndedP: ((CGPoint,Int) -> Void)?
    var index: Int
    var text: String
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: gradient, startPoint: .topLeading, endPoint: .bottomTrailing)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            VStack(alignment: .center) {
                Text(text)
                    .scaledFont(name: "Helvetica Neue", size: fonts.smallFontDimension )
                    .padding(5)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
            }
        }
        .aspectRatio(0.6, contentMode: .fit)
        .offset(dragAmount)
        .shadow(radius: dragAmount == .zero ? 0 : 10)
        .shadow(radius: dragAmount == .zero ? 0 : 10)
        .gesture(
            DragGesture(minimumDistance: 0, coordinateSpace: .global)
                .onChanged({
                    self.onChangedP?($0.location, self.index)
                })
                .onEnded({
                    self.onEndedP?($0.location, self.index)
                })
        )
            .simultaneousGesture(
                (
                    DragGesture(coordinateSpace: .global)
                        .onChanged {
                            self.dragAmount = $0.translation
                            self.dragState = self.onChanged?($0.location, self.text) ?? .unknown
                            self.touching = true
                    }
                    .onEnded {
                        if self.dragState == .good {
                            self.touching = false
                            self.onEnded?($0.location, self.index, self.text)
                            self.dragAmount = .zero
                        }else{
                            withAnimation(.spring()){
                                self.dragAmount = .zero
                            }
                        }
                    }
                    
                )
        )
            .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
    }
}

struct Card_Previews: PreviewProvider {
    static var previews: some View {
        Card(index: 0, text: "")
    }
}

