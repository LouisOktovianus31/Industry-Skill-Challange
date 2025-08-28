//
//  MockInviteTravelerFetcher.swift
//  Coco
//
//  Created by Arin Juan Sari on 27/08/25.
//

import Foundation
@testable import Coco

final class MockInviteTravelerFetcher: InviteTravelerFetcherProtocol {

    var invokeFetchCreateBookingByEmailsList = false
    var invokeFetchCreateBookingByEmailsListCount = 0
    var invokeFetchCreateBookingByEmailsListParameters: (request: Coco.CreateBookingByEmailSpec, Void)?
    var invokeFetchCreateBookingByEmailsListParametersList = [(request: Coco.CreateBookingByEmailSpec, Void)]()
    var stubbedFetchCreateBookingByEmailsCompletionResult: (Coco.JSONArray<Coco.CreateBookingByEmailsResponse>, Void)?
    
    func fetchCreateBookingByEmails(request: Coco.CreateBookingByEmailSpec) async throws -> Coco.JSONArray<Coco.CreateBookingByEmailsResponse> {
        invokeFetchCreateBookingByEmailsList = true
        invokeFetchCreateBookingByEmailsListCount += 1
        invokeFetchCreateBookingByEmailsListParameters = (request, ())
        invokeFetchCreateBookingByEmailsListParametersList.append((request, ()))
        if let result = stubbedFetchCreateBookingByEmailsCompletionResult {
            return result.0
        }
        
        return try Coco.JSONArray(jsonArray: [])

    }
}

