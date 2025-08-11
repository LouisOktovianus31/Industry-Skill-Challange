//
//  CocoInputTextFieldStyle.swift
//  Coco
//
//  Created by Jackie Leonardy on 06/07/25.
//

import Foundation
import SwiftUI

typealias ImageHandler = (image: UIImage, didTap: (() -> Void)?)

struct CocoInputTextFieldStyle: TextFieldStyle {
    let leadingIcon: UIImage?
    let placeHolder: String?
    let trailingIcon: ImageHandler?
    let shouldInterceptFocus: Bool
    let onFocusedAction: ((Bool) -> Void)?
    
    init(
        leadingIcon: UIImage?,
        placeHolder: String?,
        trailingIcon: ImageHandler?,
        shouldInterceptFocus: Bool,
        onFocusedAction: ((Bool) -> Void)?
    ) {
        self.leadingIcon = leadingIcon
        self.placeHolder = placeHolder
        self.trailingIcon = trailingIcon
        self.shouldInterceptFocus = shouldInterceptFocus
        self.onFocusedAction = onFocusedAction
    }
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        HStack(alignment: .center, spacing: 8.0) {
            if let leadingIcon: UIImage {
                Image(uiImage: leadingIcon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18.0, height: 18.0)
            }
            
            ZStack {
                GeometryReader { proxy in
                    configuration
                        .disabled(shouldInterceptFocus) // Disable interaction if intercepting
                    
                    // Transparent layer to intercept taps
                    if shouldInterceptFocus {
                        Color.clear
                            .contentShape(Rectangle())
                            .frame(width: proxy.size.width - (trailingIcon != nil ? 20.0 : 0), height: 52.0)
                            .onTapGesture {
                                onFocusedAction?(true)
                            }
                    }
                }
            }

            Spacer()
                
            if let trailingIcon: ImageHandler {
                Rectangle()
                    .frame(width: 1.0, height: 18.0)
                    .foregroundStyle(Token.additionalColorsLine.toColor())
                
                Image(uiImage: trailingIcon.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18.0, height: 18.0)
                    .onTapGesture {
                        trailingIcon.didTap?()
                    }
            }
        }
        .padding(.vertical, 14.0)
        .padding(.horizontal, 16.0)
        .background(Token.mainColorSecondary.toColor())
        .clipShape(Capsule(style: .continuous))
    }
}
