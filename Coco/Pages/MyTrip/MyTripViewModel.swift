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
    
    var allTripData: [MyTripListCardDataModel] = []
    private var currentFilter: EventFilter = .upcoming
    
    init(fetcher: MyTripBookingListFetcherProtocol = MyTripBookingListFetcher()) {
        self.fetcher = fetcher
    }
    
    private let fetcher: MyTripBookingListFetcherProtocol
    var responses: [BookingDetails] = []
    private var isError: Bool = false
    
    private(set) lazy var collectionViewModel: MyTripListCollectionViewModelProtocol = {
        let viewModel: MyTripListCollectionViewModel = MyTripListCollectionViewModel()
        viewModel.delegate = self
        
        return viewModel
    }()
}

extension MyTripViewModel: MyTripViewModelProtocol {
    func onViewWillAppear() -> Task<Void, Never> {
        actionDelegate?.contructCollectionView(viewModel: collectionViewModel)
        responses = []
        
        return Task {
            await MainActor.run {
                actionDelegate?.setStateViewData(StateViewData(.loading))
            }
            
            do {
                let response: [BookingDetails] = try await fetcher.fetchTripBookingList(
                    request: TripBookingListSpec(userId: UserDefaults.standard.string(forKey: "user-id") ?? "")
                ).values
                
                let processedData = await Task.detached(priority: .userInitiated) {
                    response
                        .map { MyTripListCardDataModel(bookingDetail: $0) }
                        .sorted { $0.date < $1.date }
                }.value
                
                await MainActor.run {
                    self.responses = response
                    self.allTripData = processedData
                    self.isError = false
                    self.actionDelegate?.setStateViewData(nil)
                    self.applyFilter(self.currentFilter)
                }
            } catch {
                await MainActor.run {
                    self.actionDelegate?.setStateViewData(StateViewData(.error))
                    self.isError = true
                }
            }
        }
    }
    
    func applyFilter(_ filter: EventFilter) {
        if isError { return }
        let today = Date()
        let filteredData: [MyTripListCardDataModel]
        
        switch filter {
        case .upcoming:
            filteredData = allTripData.filter { $0.date >= Calendar.current.startOfDay(for: today) }
            
        case .history:
            filteredData = allTripData.filter { $0.date < Calendar.current.startOfDay(for: today) }
        }
        
        collectionViewModel.updateMyTripListData(filteredData)
        
        if filteredData.isEmpty {
            actionDelegate?.setStateViewData(StateViewData(.empty))
        } else {
            actionDelegate?.setStateViewData(nil)
        }
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
