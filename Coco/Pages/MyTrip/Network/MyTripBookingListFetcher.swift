//
//  MyTripBookingListFetcher.swift
//  Coco
//
//  Created by Jackie Leonardy on 14/07/25.
//

import Foundation

protocol MyTripBookingListFetcherProtocol {
    func fetchTripBookingList(request: TripBookingListSpec) async throws -> JSONArray<BookingDetails>
}

final class MyTripBookingListFetcher: MyTripBookingListFetcherProtocol {
    init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
    }
    
    func fetchTripBookingList(request: TripBookingListSpec) async throws -> JSONArray<BookingDetails> {
        try await networkService.request(
            urlString: CreateBookingEndpoint.getBookings.urlString,
            method: .post,
            parameters: [:],
            headers: [:],
            body: request
        )
    }
    
    private let networkService: NetworkServiceProtocol
}
