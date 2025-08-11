//
//  HomeSearchBarViewModel.swift
//  Coco
//
//  Created by Jackie Leonardy on 06/07/25.
//

import Foundation
import SwiftUI

protocol HomeSearchBarViewModelDelegate: AnyObject {
    func notifyHomeSearchBarDidTap(isTypeAble: Bool, viewModel: HomeSearchBarViewModel)
}

final class HomeSearchBarViewModel: ObservableObject {
    weak var delegate: HomeSearchBarViewModelDelegate?
    
    @Published var currentTypedText: String = ""
    
    let leadingIcon: UIImage?
    let trailingIcon: ImageHandler?
    let isTypeAble: Bool
    let placeholderText: String
    
    init(
        leadingIcon: UIImage?,
        placeholderText: String,
        currentTypedText: String,
        trailingIcon: ImageHandler?,
        isTypeAble: Bool,
        delegate: HomeSearchBarViewModelDelegate?
    ) {
        self.leadingIcon = leadingIcon
        self.placeholderText = placeholderText
        self.currentTypedText = currentTypedText
        self.trailingIcon = trailingIcon
        self.isTypeAble = isTypeAble
        self.delegate = delegate
    }
    
    func onTextFieldFocusDidChange(to newFocus: Bool) {
        guard newFocus else { return }
        delegate?.notifyHomeSearchBarDidTap(isTypeAble: isTypeAble, viewModel: self)
    }
}
