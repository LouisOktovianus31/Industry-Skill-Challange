//
//  HomeSearchFilterPriceRangeModel.swift
//  Coco
//
//  Created by Jackie Leonardy on 09/07/25.
//

import Foundation
import SwiftUI

final class HomeSearchFilterPriceRangeModel: ObservableObject {
    @Published var minPrice: Double
    @Published var maxPrice: Double

    let range: ClosedRange<Double>
    let step: Double

    init(minPrice: Double, maxPrice: Double, range: ClosedRange<Double>, step: Double = 1) {
        self.minPrice = minPrice
        self.maxPrice = maxPrice
        self.range = range
        self.step = step
    }
}
