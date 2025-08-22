//
//  TripDetailFetcher.swift
//  Coco
//
//  Created by Grachia Uliari on 21/08/25.
//

import Foundation

protocol TripDetailFetcherProtocol {
    func fetchTripDetail(bookingId: Int) async throws -> TripBookingDetails
}

struct TripDetailRequest: JSONEncodable {
    let bookingId: Int
    enum CodingKeys: String, CodingKey {
        case bookingId = "p_booking_id"
    }
}

enum TripDetailEndpoint: EndpointProtocol {
    case getBookingDetails
    var path: String { "rpc/get_booking_details" }
}

final class TripDetailFetcher: TripDetailFetcherProtocol {
    private let network: NetworkServiceProtocol
    init(network: NetworkServiceProtocol = NetworkService.shared) {
        self.network = network
    }
    
    func fetchTripDetail(bookingId: Int) async throws -> TripBookingDetails {
        try await network.request(
            urlString: TripDetailEndpoint.getBookingDetails.urlString,
            method: .post,
            parameters: [:],
            headers: [
                "Content-Type": "application/json",
                "apikey": Secrets.supabaseAnonKey,
                "Authorization": "Bearer \(Secrets.supabaseAnonKey)"
            ],
            body: TripDetailRequest(bookingId: bookingId)
        )
    }
}
