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
    private var error: Bool = false
    private var errorMessage: String?
    
    init(
        leadingIcon: UIImage? = nil,
        currentTypedText: Binding<String>,
        trailingIcon: ImageHandler? = nil,
        placeholder: String?,
        shouldInterceptFocus: Bool = false,
        onFocusedAction: ((Bool) -> Void)? = nil,
        onSubmit: ((String) -> Void)? = nil,
        error: Bool = false,
        errorMessage: String? = nil
    ) {
        self.leadingIcon = leadingIcon
        _currentTypedText = currentTypedText
        self.trailingIcon = trailingIcon
        self.placeholder = placeholder
        self.shouldInterceptFocus = shouldInterceptFocus
        self.onFocusedAction = onFocusedAction
        self.onSubmit = onSubmit
        self.error = error
        self.errorMessage = errorMessage
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
                onFocusedAction: onFocusedAction
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
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(error ? Color.red : Color.gray.opacity(0.3), lineWidth: 1)
        )
        
        if error, let errorMessage = errorMessage {
            Text(errorMessage)
                .font(.footnote)
                .foregroundColor(.red)
                .padding(.horizontal, 4)
        }
    }
}
