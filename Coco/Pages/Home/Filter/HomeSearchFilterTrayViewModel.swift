//
//  HomeSearchFilterTrayViewModel.swift
//  Coco
//
//  Created by Jackie Leonardy on 09/07/25.
//

import Combine
import Foundation
import SwiftUI

final class HomeSearchFilterTrayViewModel: ObservableObject {
    let filterDidApplyPublisher: PassthroughSubject<HomeSearchFilterTrayDataModel, Never> = PassthroughSubject()
    
    @Published var dataModel: HomeSearchFilterTrayDataModel
    @Published var applyButtonTitle: String
    
    private let activities: [Activity]
    private var cancellables: Set<AnyCancellable> = Set()
    
    init(dataModel: HomeSearchFilterTrayDataModel, activities: [Activity]) {
        self.dataModel = dataModel
        self.activities = activities
        
        let tempActivity: [Activity] = HomeFilterUtil.doFilter(activities, filterDataModel: dataModel)
        applyButtonTitle = Self.getTitle(tempActivity)
    }
    
    func filterDidApply() {
        filterDidApplyPublisher.send(dataModel)
    }
    
    func updateApplyButtonTitle() {
        let tempActivity: [Activity] = HomeFilterUtil.doFilter(activities, filterDataModel: dataModel)
        applyButtonTitle = Self.getTitle(tempActivity)
    }
}

private extension HomeSearchFilterTrayViewModel {
    static func getTitle(_ activities: [Activity]) -> String {
        "Apply Filter (\(activities.count))"
    }
}
