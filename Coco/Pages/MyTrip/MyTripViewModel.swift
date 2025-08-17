//
//  MyTripViewModel.swift
//  Coco
//
//  Created by Jackie Leonardy on 14/07/25.
//

import Foundation

final class MyTripViewModel {
    weak var actionDelegate: (any MyTripViewModelAction)?
    
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
            
            collectionViewModel.updateMyTripListData(response.map({ listData in
                MyTripListCardDataModel(bookingDetail: listData)
            }))
        }
    }
}

extension MyTripViewModel: MyTripListCollectionViewModelDelegate {
    func notifyCollectionViewTripItemDidTap(_ dataModel: MyTripListCardDataModel, indexPath: IndexPath) {
        guard indexPath.row < responses.count else { return }
        actionDelegate?.goToBookingDetail(with: responses[indexPath.row])
    }
}
