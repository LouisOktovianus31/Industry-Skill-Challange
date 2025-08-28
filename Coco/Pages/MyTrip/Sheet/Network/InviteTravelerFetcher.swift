//
//  InviteTravelerFetcher.swift
//  Coco
//
//  Created by Arin Juan Sari on 24/08/25.
//

protocol InviteTravelerFetcherProtocol {
//    func fetchCreateBookingByEmails(bookingId: Int, emails: [String]) async throws -> JSONArray<CreateBookingByEmailsResponse>
    
    func fetchCreateBookingByEmails(request: CreateBookingByEmailSpec) async throws -> JSONArray<CreateBookingByEmailsResponse>
}

final class InviteTravelerFetcher: InviteTravelerFetcherProtocol {
    private let network: NetworkServiceProtocol
    init(network: NetworkServiceProtocol = NetworkService.shared) {
        self.network = network
    }
    
    func fetchCreateBookingByEmails(request: CreateBookingByEmailSpec) async throws -> JSONArray<CreateBookingByEmailsResponse> {
        try await network.request(
            urlString: CreateBookingByEmailsEndpoint.create.urlString,
            method: .post,
            parameters: [:],
            headers: [:],
            body: request
        )
    }
}
