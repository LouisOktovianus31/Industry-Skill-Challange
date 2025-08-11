//
//  CreateBookingFetcher.swift
//  Coco
//
//  Created by Jackie Leonardy on 12/07/25.
//

import Foundation

protocol CreateBookingFetcherProtocol {
    func createBooking(request: CreateBookingSpec) async throws -> CreateBookingResponse
}

final class CreateBookingFetcher: CreateBookingFetcherProtocol {
    init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
    }
    
    func createBooking(request: CreateBookingSpec) async throws -> CreateBookingResponse {
        try await networkService.request(
            urlString: CreateBookingEndpoint.create.urlString,
            method: .post,
            parameters: [:],
            headers: [:],
            body: request
        )
    }
    
    private let networkService: NetworkServiceProtocol
}
