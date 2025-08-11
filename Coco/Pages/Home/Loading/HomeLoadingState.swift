//
//  HomeLoadingState.swift
//  Coco
//
//  Created by Jackie Leonardy on 06/07/25.
//

import Foundation
import SwiftUI

final class HomeLoadingState: ObservableObject {
    // for view usage only
    @Published var _percentage: CGFloat = 0
        
    var percentage: CGFloat {
        get { _percentage }
        set { _percentage = min(max(newValue, 0), 100) }
    }
}
