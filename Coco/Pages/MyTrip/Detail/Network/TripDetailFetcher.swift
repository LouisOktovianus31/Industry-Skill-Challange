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
    let userId: String
    enum CodingKeys: String, CodingKey {
        case bookingId = "booking_id"
        case userId = "user_id"
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
        guard let userId = UserDefaults.standard.string(forKey: "user-id") else {
                    throw NSError(domain: "TripDetailFetcher", code: -1, userInfo: [NSLocalizedDescriptionKey: "User ID not found"])
                }
        
        return try await network.request(
            urlString: CreateBookingEndpoint.getBookingDetails.urlString,
            method: .post,
            parameters: [:],
            headers: [:],
            body: TripDetailRequest(bookingId: bookingId, userId: userId)
        )
    }
}
