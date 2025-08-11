//
//  HomeSearchFilterTrayDataModel.swift
//  Coco
//
//  Created by Jackie Leonardy on 09/07/25.
//

import Foundation

struct HomeSearchFilterTrayDataModel {
    var filterPillDataState: [HomeSearchFilterPillState] = []
    var priceRangeModel: HomeSearchFilterPriceRangeModel
    
    init(filterPillDataState: [HomeSearchFilterPillState], priceRangeModel: HomeSearchFilterPriceRangeModel) {
        self.filterPillDataState = filterPillDataState
        self.priceRangeModel = priceRangeModel
    }
}
