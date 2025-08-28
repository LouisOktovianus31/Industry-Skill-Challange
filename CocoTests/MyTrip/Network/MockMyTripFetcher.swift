//
//  MockMyTripFetcher.swift
//  Coco
//
//  Created by Arin Juan Sari on 26/08/25.
//

import Foundation
@testable import Coco

final class MockMyTripFetcher: MyTripBookingListFetcherProtocol {
    
    var invokeFetchTripBookingList = false
    var invokeFetchTripBookingListCount = 0
    var invokeFetchTripBookingListParameters: (request: Coco.TripBookingListSpec, Void)?
    var invokeFetchTripBookingListParametersList = [(request: Coco.TripBookingListSpec, Void)]()
    var stubbedFetchTripBookingCompletionResult: (Coco.JSONArray<Coco.BookingDetails>, Void)?
    
    func fetchTripBookingList(request: Coco.TripBookingListSpec) async throws -> Coco.JSONArray<Coco.BookingDetails> {
        invokeFetchTripBookingList = true
        invokeFetchTripBookingListCount += 1
        invokeFetchTripBookingListParameters = (request, ())
        invokeFetchTripBookingListParametersList.append((request, ()))
        if let result = stubbedFetchTripBookingCompletionResult {
            return result.0
        }
        
        return try Coco.JSONArray(jsonArray: [])
    }
}
