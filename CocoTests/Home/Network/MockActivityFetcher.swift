//
//  MockActivityFetcher.swift
//  CocoTests
//
//  Created by Jackie Leonardy on 26/07/25.
//

import Foundation
@testable import Coco

final class MockActivityFetcher: ActivityFetcherProtocol {

    var invokedFetchActivity = false
    var invokedFetchActivityCount = 0
    var invokedFetchActivityParameters: (request: ActivitySearchRequest, Void)?
    var invokedFetchActivityParametersList = [(request: ActivitySearchRequest, Void)]()
    var stubbedFetchActivityCompletionResult: (Result<ActivityModelArray, NetworkServiceError>, Void)?

    func fetchActivity(
        request: ActivitySearchRequest,
        completion: @escaping (Result<ActivityModelArray, NetworkServiceError>) -> Void
    ) {
        invokedFetchActivity = true
        invokedFetchActivityCount += 1
        invokedFetchActivityParameters = (request, ())
        invokedFetchActivityParametersList.append((request, ()))
        if let result = stubbedFetchActivityCompletionResult {
            completion(result.0)
        }
    }

    var invokedFetchTopDestination = false
    var invokedFetchTopDestinationCount = 0
    var stubbedFetchTopDestinationCompletionResult: (Result<ActivityTopDestinationModelArray, NetworkServiceError>, Void)?

    func fetchTopDestination(
        completion: @escaping (Result<ActivityTopDestinationModelArray, NetworkServiceError>) -> Void
    ) {
        invokedFetchTopDestination = true
        invokedFetchTopDestinationCount += 1
        if let result = stubbedFetchTopDestinationCompletionResult {
            completion(result.0)
        }
    }
}
