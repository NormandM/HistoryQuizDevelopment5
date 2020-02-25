//
//  Extensions.swift
//  HistoryQuizDevelopement2
//
//  Created by Normand Martin on 2020-01-28.
//  Copyright © 2020 Normand Martin. All rights reserved.
//

import Foundation
import SwiftUI
extension View {
    public func addBorder<S>(_ content: S, width: CGFloat = 1, cornerRadius: CGFloat) -> some View where S : ShapeStyle {
        return overlay(RoundedRectangle(cornerRadius: cornerRadius).stroke(content, lineWidth: width))
    }
}
