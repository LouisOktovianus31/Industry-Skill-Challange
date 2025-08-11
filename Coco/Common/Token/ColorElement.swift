//
//  ColorElement.swift
//  Coco
//
//  Created by Jackie Leonardy on 03/07/25.
//

import Foundation
import UIKit

/// PropertyWrapper to dynamically get the color based on user interface dark / light thmee
@propertyWrapper struct ColorElement {
    var wrappedValue: UIColor {
        get {
            return UIColor { theme in
                switch theme.userInterfaceStyle {
                case .dark:
                    return dark
                case .light:
                    return light
                default:
                    return light
                }
            }
        }
    }
    
    let light: UIColor
    let dark: UIColor
    
    init(light: UIColor, dark: UIColor) {
        self.light = light
        self.dark = dark
    }
    
    init(color: UIColor) {
        light = color
        dark = color
    }
}
