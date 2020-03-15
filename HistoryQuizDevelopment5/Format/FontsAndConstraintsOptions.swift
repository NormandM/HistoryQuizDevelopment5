//
//  FontsAndConstraintsOptions.swift
//  French Verbs Quiz
//
//  Created by Normand Martin on 2018-12-10.
//  Copyright © 2018 Normand Martin. All rights reserved.
//

import SwiftUI
struct FontsAndConstraintsOptions {
    let screenDeviceDimension: ScreenDimension
    let multiplierConstraint: CGFloat
    let fontDimension: CGFloat
    let smallFontDimension: CGFloat
    let finalBigFont: CGFloat
    let titalFont: CGFloat
    init() {
        let screenSize = UIScreen.main.bounds
        let surfaceScreen = screenSize.width * screenSize.height
        var multiplier = CGFloat()
        var screenType = ScreenDimension.iPhone5
        var localFont: CGFloat = 0
        var bigFont:CGFloat = 0
        var titalFonts: CGFloat = 0
        var smallLocalFont: CGFloat = 0
        if surfaceScreen < 200000 {
            smallLocalFont = 8
            localFont = 10
            bigFont = 14
            titalFonts = 18
            multiplier = 0.52
        }else if surfaceScreen > 200000 && surfaceScreen < 304600 {
            screenType = .iPhone6
             smallLocalFont = 9
            localFont = 11
            bigFont = 18
            titalFonts = 25
            multiplier = 0.55
        }else if surfaceScreen > 304600 && surfaceScreen < 350000 {
            screenType = .iPhone8Plus
            smallLocalFont = 10
            localFont = 14
            bigFont = 20
            titalFonts = 30
             multiplier = 0.55
        }else if surfaceScreen > 350000 && surfaceScreen < 700000 {
            smallLocalFont = 12
            localFont = 16
            bigFont = 30
            titalFonts = 35
            screenType = .iPhoneX
        }else if surfaceScreen > 700000 && surfaceScreen < 800000{
            smallLocalFont = 12
            localFont = 14
            bigFont = 22
            titalFonts = 40
            screenType = .iPad9
            multiplier = 0.6
        }else if surfaceScreen > 800000 && surfaceScreen < 1000000{
            smallLocalFont = 14
            localFont = 16
            bigFont = 24
            titalFonts = 45
            multiplier = 0.6
        }else if surfaceScreen > 1000000{
            smallLocalFont = 16
            localFont = 28
            bigFont = 30
            titalFonts = 50
            screenType = .iPad12
            multiplier = 0.6
        }
        finalBigFont = bigFont
        smallFontDimension = smallLocalFont
        fontDimension = localFont
        screenDeviceDimension = screenType
        multiplierConstraint = multiplier
        titalFont = titalFonts
    }
}
extension FontsAndConstraintsOptions {
    func device() -> ScreenDimension.RawValue {
        let screenSize = UIScreen.main.bounds
        let surfaceScreen = screenSize.width * screenSize.height
        var deviceType = String ()
        if surfaceScreen < 200000 {            deviceType = ScreenDimension.iPhone5.rawValue
        }else if surfaceScreen > 200000 && surfaceScreen < 304600 {
            deviceType = ScreenDimension.iPhone6.rawValue
        }
        return deviceType
    }
}
extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
extension NSLayoutConstraint {
    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem!, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
}

