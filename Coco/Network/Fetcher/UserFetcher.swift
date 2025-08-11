//
//  UserFetcher.swift
//  Coco
//
//  Created by Jackie Leonardy on 01/07/25.
//

import Foundation

protocol UserFetcherProtocol: AnyObject {
    func fetchUser(
        completion: @escaping (Result<UserModelArray, NetworkServiceError>) -> Void
    )
}

final class UserFetcher: UserFetcherProtocol {
    init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
    }
    
    func fetchUser(
        completion: @escaping (Result<UserModelArray, NetworkServiceError>) -> Void
    ) {
        networkService.request(
            urlString: UserEndpoint.all.urlString,
            method: .get,
            parameters: [:],
            headers: [:],
            body: nil,
            completion: completion
        )
    }
    
    private let networkService: NetworkServiceProtocol
}
