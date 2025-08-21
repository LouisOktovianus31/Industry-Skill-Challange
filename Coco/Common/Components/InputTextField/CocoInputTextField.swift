//
//  CocoInputTextField.swift
//  Coco
//
//  Created by Jackie Leonardy on 06/07/25.
//

import Foundation
import SwiftUI

private let kInputHeight: CGFloat = 52.0

struct CocoInputTextField: View {
    @Binding var currentTypedText: String
    
    private let shouldInterceptFocus: Bool
    private let leadingIcon: UIImage?
    private let trailingIcon: ImageHandler?
    private let placeholder: String?
    
    @FocusState private var isFocused: Bool
    private let onFocusedAction: ((Bool) -> Void)?
    private var onSubmit: ((String) -> Void)?
    
    init(
        leadingIcon: UIImage? = nil,
        currentTypedText: Binding<String>,
        trailingIcon: ImageHandler? = nil,
        placeholder: String?,
        shouldInterceptFocus: Bool = false,
        onFocusedAction: ((Bool) -> Void)? = nil,
        onSubmit: ((String) -> Void)? = nil
    ) {
        self.leadingIcon = leadingIcon
        _currentTypedText = currentTypedText
        self.trailingIcon = trailingIcon
        self.placeholder = placeholder
        self.shouldInterceptFocus = shouldInterceptFocus
        self.onFocusedAction = onFocusedAction
        self.onSubmit = onSubmit
    }
    
    var body: some View {
        TextField(
            placeholder ?? "",
            text: $currentTypedText
        )
        .ignoresSafeArea(.keyboard)
        .textFieldStyle(
            CocoInputTextFieldStyle(
                leadingIcon: leadingIcon,
                placeHolder: placeholder,
                trailingIcon: trailingIcon,
                shouldInterceptFocus: shouldInterceptFocus,
                onFocusedAction: onFocusedAction,
                onSubmit: onSubmit
            )
        )
        .focused($isFocused)
        .onChange(of: isFocused) { isFocused in
            onFocusedAction?(isFocused)
        }
        .font(.jakartaSans(forTextStyle: .body, weight: .medium))
        .frame(height: kInputHeight)
        .onSubmit {
            onSubmit?(currentTypedText)
        }
    }
}
