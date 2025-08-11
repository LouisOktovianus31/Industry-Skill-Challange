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
}

extension MyTripViewModel: MyTripViewModelProtocol {
    func onViewWillAppear() {
        actionDelegate?.configureView(datas: [])
        responses = []
        
        Task { @MainActor in
            let response: [BookingDetails] = try await fetcher.fetchTripBookingList(
                request: TripBookingListSpec(userId: UserDefaults.standard.value(forKey: "user-id") as? String ?? "")
            ).values
            
            responses = response
            
            actionDelegate?.configureView(datas: response.map({ listData in
                MyTripListCardDataModel(bookingDetail: listData)
            }))
        }
    }
    
    func onTripListDidTap(at index: Int) {
        guard index < responses.count else { return }
        actionDelegate?.goToBookingDetail(with: responses[index])
    }
}
