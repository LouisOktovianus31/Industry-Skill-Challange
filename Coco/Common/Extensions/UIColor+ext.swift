//
//  UIColor+ext.swift
//  Coco
//
//  Created by Jackie Leonardy on 03/07/25.
//

import Foundation
import UIKit
import SwiftUI

extension UIColor {
    static func from(_ hex: String) -> UIColor {
        let red, green, blue, alpha: CGFloat
        
        // Trim and switch offset
        let trimmedHexColor: String = {
            if hex.hasPrefix("#") {
                let startIndex: String.Index = hex.index(hex.startIndex, offsetBy: 1)
                return String(hex[startIndex...])
            }
            return hex
        }()
        
        let scanner: Scanner = Scanner(string: trimmedHexColor)
        var hexNumber: UInt64 = 0
        guard scanner.scanHexInt64(&hexNumber) else {
            assertionFailure("\(hex) is not a valid format")
            return .black
        }
        
        switch trimmedHexColor.count {
        case 6: // RRGGBB
            red   = CGFloat((hexNumber & 0xFF0000) >> 16) / 255
            green = CGFloat((hexNumber & 0x00FF00) >> 8) / 255
            blue  = CGFloat(hexNumber & 0x0000FF) / 255
            alpha = 1.0

        case 8: // RRGGBBAA
            red   = CGFloat((hexNumber & 0xFF000000) >> 24) / 255
            green = CGFloat((hexNumber & 0x00FF0000) >> 16) / 255
            blue  = CGFloat((hexNumber & 0x0000FF00) >> 8) / 255
            alpha = CGFloat(hexNumber & 0x000000FF) / 255

        default:
            assertionFailure("\(hex) must be 6 or 8 characters long")
            return .black
        }

        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    func toColor() -> Color {
        Color(self)
    }
}
