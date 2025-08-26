//
//  StateViewData.swift
//  Coco
//
//  Created by Arin Juan Sari on 23/08/25.
//

import Foundation
import UIKit

struct StateViewData {
    var message: String
    var isLoading: Bool
    var image: UIImage?
    
    init(message: String, isLoading: Bool, image: UIImage? = nil) {
        self.message = message
        self.isLoading = isLoading
        self.image = image
    }
    
    init(_ state: StateViewType) {
        switch state {
        case .empty:
            self.message = "Data is empty"
            self.isLoading = false
            self.image = CocoIcon.icEmptyIcon.image
        case .loading:
            self.message = "Loading..."
            self.isLoading = true
            self.image = nil
        case .error:
            self.message = "Something went wrong"
            self.isLoading = false
            self.image = CocoIcon.icEmptyIcon.image
        }
    }
}

enum StateViewType {
    case empty
    case loading
    case error
}
