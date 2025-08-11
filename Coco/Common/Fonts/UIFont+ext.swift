//
//  UIFont+ext.swift
//  Coco
//
//  Created by Jackie Leonardy on 03/07/25.
//

import Foundation
import SwiftUI
import UIKit

extension UIFont {
    static func jakartaSans(
        forTextStyle style: UIFont.TextStyle,
        weight: UIFont.Weight = .regular
    ) -> UIFont {
        let pointSize = UIFont.preferredFont(forTextStyle: style).pointSize
        let fontName: String = {
            switch weight {
            case .ultraLight:
                return "PlusJakartaSans-ExtraLight"
            case .thin, .light:
                return "PlusJakartaSans-Light"
            case .regular:
                return "PlusJakartaSans-Regular"
            case .medium:
                return "PlusJakartaSans-Medium"
            case .semibold:
                return "PlusJakartaSans-SemiBold"
            case .bold:
                return "PlusJakartaSans-Bold"
            case .heavy, .black:
                return "PlusJakartaSans-ExtraBold"
            default:
                return "PlusJakartaSans-Regular"
            }
        }()

        guard let customFont = UIFont(name: fontName, size: pointSize) else {
            assertionFailure("❌ Failed to load custom font: \(fontName) check your .ttf file or info.plist registration")
            return UIFont.preferredFont(forTextStyle: style)
        }

        return UIFontMetrics(forTextStyle: style).scaledFont(for: customFont)
    }
    
    func toFont() -> Font {
        Font(self)
    }
}
