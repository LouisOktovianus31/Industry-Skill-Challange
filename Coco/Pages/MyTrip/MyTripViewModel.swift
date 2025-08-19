//
//  MyTripViewModel.swift
//  Coco
//
//  Created by Jackie Leonardy on 14/07/25.
//

import Foundation
import UIKit

enum EventFilter {
    case upcoming
    case history
}

final class MyTripViewModel {
    weak var actionDelegate: (any MyTripViewModelAction)?
    
    private var allTripData: [MyTripListCardDataModel] = []
    private var currentFilter: EventFilter = .upcoming
    
    init(fetcher: MyTripBookingListFetcherProtocol = MyTripBookingListFetcher()) {
        self.fetcher = fetcher
    }
    
    private let fetcher: MyTripBookingListFetcherProtocol
    private var responses: [BookingDetails] = []
    
    private(set) lazy var collectionViewModel: MyTripListCollectionViewModelProtocol = {
        let viewModel: MyTripListCollectionViewModel = MyTripListCollectionViewModel()
        viewModel.delegate = self
        
        return viewModel
    }()
}

extension MyTripViewModel: MyTripViewModelProtocol {
    func onViewWillAppear() {
        actionDelegate?.contructCollectionView(viewModel: collectionViewModel)
        responses = []
        
        Task { @MainActor in
            let response: [BookingDetails] = try await fetcher.fetchTripBookingList(
                request: TripBookingListSpec(userId: UserDefaults.standard.value(forKey: "user-id") as? String ?? "")
            ).values
            
            responses = response
            
            allTripData = response
                .map({ listData in
                    MyTripListCardDataModel(bookingDetail: listData)
                })
                .sorted { $0.date < $1.date }
            
            applyFilter(currentFilter)
        }
    }
    
    func applyFilter(_ filter: EventFilter) {
        let today = Date()
        let filteredData: [MyTripListCardDataModel]
        
        switch filter {
        case .upcoming:
            filteredData = allTripData.filter { $0.date >= Calendar.current.startOfDay(for: today) }
            
        case .history:
            filteredData = allTripData.filter { $0.date < Calendar.current.startOfDay(for: today) }
        }
        
        collectionViewModel.updateMyTripListData(filteredData)
    }
    
    func changeFilter(to filter: EventFilter) {
        currentFilter = filter
        applyFilter(filter)
    }
    
    func getCurrentFilter() -> EventFilter {
        return currentFilter
    }
}

extension MyTripViewModel: MyTripListCollectionViewModelDelegate {
    func notifyCollectionViewTripItemRebookDidTap(_ id: Int) {
        if let bookingDetails = responses.first(where: { $0.bookingId == id }) {
            actionDelegate?.goToRebookingDetail(with: bookingDetails)
        }
    }
    
    func notifyCollectionViewTripItemDidTap(_ id: Int) {
        if let bookingDetails = responses.first(where: { $0.bookingId == id }) {
            actionDelegate?.goToBookingDetail(with: bookingDetails)
        }
    }
}
