//
//  HomeFilterUtil.swift
//  Coco
//
//  Created by Jackie Leonardy on 09/07/25.
//

import Foundation

final class HomeFilterUtil {
    static func doFilter(_ activities: [Activity], filterDataModel: HomeSearchFilterTrayDataModel) -> [Activity] {
        var tempActivities: [Activity] = activities
        
        // filter by pill
        let selectedIds: [Int] = filterDataModel.filterPillDataState
            .filter { $0.isSelected }
            .map { $0.id }
        
        if !selectedIds.isEmpty {
            tempActivities = tempActivities.filter { activity in
                let shouldMatchCancelable = selectedIds.contains(-99999999)
                let shouldMatchAccessory = selectedIds.contains(where: { $0 != -99999999 })

                let matchesCancelable = shouldMatchCancelable && !activity.cancelable.isEmpty
                let matchesAccessory = shouldMatchAccessory &&
                    activity.accessories.contains { selectedIds.contains($0.id) }

                return matchesCancelable || matchesAccessory
            }
        }
        
        // filter by price range
        tempActivities = tempActivities.filter {
            $0.pricing >= filterDataModel.priceRangeModel.minPrice && $0.pricing <= filterDataModel.priceRangeModel.maxPrice
        }
        
        return tempActivities
    }
}
