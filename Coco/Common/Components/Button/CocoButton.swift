//
//  CocoButton.swift
//  Coco
//
//  Created by Jackie Leonardy on 07/07/25.
//

import Foundation
import SwiftUI

enum TextOrImage {
    case text(String)
    case image(Image)
}

struct CocoButton: View {
    @Environment(\.isStretch) var isStretch: Bool
    
    private let action: () -> Void
    private let text: TextOrImage
    
    private let style: CocoButtonStyle
    private let type: CocoButtonType
    
    init(
        action: @escaping () -> Void,
        text: TextOrImage,
        style: CocoButtonStyle,
        type: CocoButtonType
    ) {
        self.action = action
        self.text = text
        self.style = style
        self.type = type
    }
    
    init(
        action: @escaping () -> Void,
        image: Image,
        style: CocoButtonStyle,
        type: CocoButtonType
    ) {
        self.action = action
        self.text = .image(image)
        self.style = style
        self.type = type
    }
    
    init(
        action: @escaping () -> Void,
        text: String,
        style: CocoButtonStyle,
        type: CocoButtonType
    ) {
        self.action = action
        self.text = .text(text)
        self.style = style
        self.type = type
    }
    
    var body: some View {
        Button(action: action) {
            switch text {
            case .text(let string):
                Text(string)
                    .font(.jakartaSans(forTextStyle: .body, weight: .semibold))
                    .frame(maxWidth: isStretch ? .infinity : nil)
            case .image(let image):
                image
                    .resizable()
                    .frame(width: 32, height: 32)
            }
            
        }
        .disabled(type == .disabled)
        .buttonStyle(CocoButtonStyleConfiguration(style: style, type: type))
    }
}

struct CocoButtonStyleConfiguration: ButtonStyle {
    init(style: CocoButtonStyle, type: CocoButtonType) {
        self.style = style
        self.type = type
    }
    
    private let style: CocoButtonStyle
    private let type: CocoButtonType
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(style.padding)
            .frame(height: style.height)
            .foregroundColor(type.textColor)
            .background(type.backgroundColor)
            .cornerRadius(style.cornerRadius)
            .overlay {
                RoundedRectangle(cornerRadius: style.cornerRadius)
                    .strokeBorder(type.borderColor ?? .clear, lineWidth: 1.0)
            }
    }
}

final class CocoButtonHostingController: UIHostingController<AnyView> {
    init(
        action: @escaping () -> Void,
        text: String,
        style: CocoButtonStyle,
        type: CocoButtonType,
        isStretch: Bool = true
    ) {
        let view = CocoButton(action: action, text: text, style: style, type: type)
            .environment(\.isStretch, isStretch)
        
        super.init(rootView: AnyView(view))
    }
    
    init(
        action: @escaping () -> Void,
        image: Image,
        style: CocoButtonStyle,
        type: CocoButtonType,
        isStretch: Bool = true
    ) {
        let view = CocoButton(action: action, image: image, style: style, type: type)
            .environment(\.isStretch, isStretch) // Inject environment here
        
        super.init(rootView: AnyView(view))
    }
    
    @MainActor @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
