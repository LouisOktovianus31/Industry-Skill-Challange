//
//  CocoButtonStyle.swift
//  Coco
//
//  Created by Jackie Leonardy on 07/07/25.
//

import Foundation
import SwiftUI

enum CocoButtonStyle {
    case small
    case normal
    case large
    
    var padding: EdgeInsets {
        switch self {
        case .small:
            return .init(
                top: 0,
                leading: 30.0,
                bottom: 0,
                trailing: 30.0
            )
        case .normal:
            return .init(
                top: 0,
                leading: 30.0,
                bottom: 0,
                trailing: 30.0
            )
        case .large:
            return .init(
                top: 0,
                leading: 42.0,
                bottom: 0,
                trailing: 42.0
            )
        }
    }
    
    var height: Double {
        switch self {
        case .small:
            return 28.0
        case .normal:
            return 46.0
        case .large:
            return 56.0
        }
    }
    
    var cornerRadius: Double {
        switch self {
        case .small:
            return 12.0
        case .normal:
            return 20.0
        case .large:
            return 24.0
        }
    }
}

enum CocoButtonType {
    case primary
    case secondary
    case tertiary
    case disabled
    
    var textColor: Color {
        switch self {
        case .primary:
            return Token.additionalColorsWhite.toColor()
        case .secondary:
            return Token.mainColorPrimary.toColor()
        case .tertiary:
            return Token.mainColorPrimary.toColor()
        case .disabled:
            return Token.grayscale60.toColor()
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .primary:
            return Token.mainColorPrimary.toColor()
        case .secondary:
            return Token.additionalColorsWhite.toColor()
        case .tertiary:
            return Token.additionalColorsWhite.toColor()
        case .disabled:
            return Token.grayscale20.toColor()
        }
    }
    
    var borderColor: Color? {
        switch self {
        case .primary:
            return nil
        case .secondary:
            return Token.mainColorPrimary.toColor()
        case .tertiary:
            return nil
        case .disabled:
            return nil
        }
    }
}
