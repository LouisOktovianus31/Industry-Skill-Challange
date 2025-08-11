//
//  CocoSecureInputTextFieldViewModel.swift
//  Coco
//
//  Created by Jackie Leonardy on 16/07/25.
//

import Foundation
import UIKit

final class CocoSecureInputTextFieldViewModel: ObservableObject {
    @Published var currentTypedText: String = ""
    
    let leadingIcon: UIImage?
    let placeholderText: String
    
    init(
        leadingIcon: UIImage?,
        placeholderText: String,
        currentTypedText: String
    ) {
        self.leadingIcon = leadingIcon
        self.placeholderText = placeholderText
        self.currentTypedText = currentTypedText
    }
}
