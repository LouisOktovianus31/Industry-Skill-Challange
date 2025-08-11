//
//  HomeViewModelContract.swift
//  Coco
//
//  Created by Jackie Leonardy on 06/07/25.
//

import Foundation

protocol HomeViewModelNavigationDelegate: AnyObject {
   func notifyHomeDidSelectActivity()
}

protocol HomeViewModelAction: AnyObject {
    func constructCollectionView(viewModel: some HomeCollectionViewModelProtocol)
    func constructLoadingState(state: HomeLoadingState)
    func constructNavBar(viewModel: HomeSearchBarViewModel)
    
    func toggleLoadingView(isShown: Bool, after: CGFloat)
    func activityDidSelect(data: ActivityDetailDataModel)
    
    func openSearchTray(
        selectedQuery: String,
        latestSearches: [HomeSearchSearchLocationData]
    )
    func openFilterTray(_ viewModel: HomeSearchFilterTrayViewModel)
    func dismissTray()
}

protocol HomeViewModelProtocol: AnyObject {
    var actionDelegate: HomeViewModelAction? { get set }
    var navigationDelegate: HomeViewModelNavigationDelegate? { get set }
    
    func onViewDidLoad()
    func onSearchDidApply(_ queryText: String)
}
