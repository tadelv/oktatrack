//
//  Color+Hex.swift
//  OktaTrack
//
//  Created by Vid on 11/5/19.
//  Copyright © 2019 Delta96. All rights reserved.
//

import SwiftUI

extension UIColor {

    convenience init(hexWithAlpha: UInt32) {
        let red = Double((hexWithAlpha & 0xFF000000) >> 32) / 255.0
        let green = Double((hexWithAlpha & 0xFF0000) >> 16) / 255.0
        let blue = Double((hexWithAlpha & 0xFF00) >> 8) / 255.0
        let alpha = Double((hexWithAlpha & 0xFF)) / 255
        self.init(red: CGFloat(red),
                  green: CGFloat(green),
                  blue: CGFloat(blue),
                  alpha:CGFloat(alpha))
    }

    convenience init(hex: UInt16) {
        self.init(hexWithAlpha:UInt32(hex))
    }
}

extension Color {
    static func pureColor(val: Int) -> Color {
        return Color(UIColor(hexWithAlpha:UInt32(val)))
    }
}
