//
//  HomeSearchFilterPillState.swift
//  Coco
//
//  Created by Jackie Leonardy on 09/07/25.
//

import Foundation
import SwiftUI

final class HomeSearchFilterPillState: ObservableObject, Identifiable {
    let id: Int
    let title: String
    @Published var isSelected: Bool
    
    init(id: Int, title: String, isSelected: Bool) {
        self.id = id
        self.title = title
        self.isSelected = isSelected
    }
    
    var textColor: Color {
        isSelected ? Token.mainColorPrimary.toColor() : Token.additionalColorsBlack.toColor()
    }
    
    var borderColor: Color {
        isSelected ? Token.mainColorPrimary.toColor() : Token.additionalColorsLine.toColor()
    }
}
