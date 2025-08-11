//
//  HomeSearchSearchTrayViewModel.swift
//  Coco
//
//  Created by Jackie Leonardy on 08/07/25.
//

import Foundation
import SwiftUI

struct HomeSearchSearchLocationData {
    let id: Int
    let name: String
}

final class HomeSearchSearchTrayViewModel: ObservableObject {
    @Published var searchBarViewModel: HomeSearchBarViewModel
    @Published var popularLocations: [HomeSearchSearchLocationData] = []
    
    init(searchBarViewModel: HomeSearchBarViewModel, activityFetcher: ActivityFetcherProtocol = ActivityFetcher()) {
        self.searchBarViewModel = searchBarViewModel
        self.activityFetcher = activityFetcher
    }
    
    @MainActor
    func onAppear() {
        activityFetcher.fetchTopDestination() { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let response):
                self.popularLocations = response.values.map { HomeSearchSearchLocationData(id: $0.id, name: $0.name) }
            case .failure(let failure):
                break
            }
        }
    }
    
    private let activityFetcher: ActivityFetcherProtocol
}
