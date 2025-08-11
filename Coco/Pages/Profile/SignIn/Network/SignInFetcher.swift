//
//  SignInFetcher.swift
//  Coco
//
//  Created by Jackie Leonardy on 16/07/25.
//

import Foundation

protocol SignInFetcherProtocol {
    func signIn(spec: SignInSpec, completion: @escaping (Result<SignInResponse, NetworkServiceError>) -> Void)
}

final class SignInFetcher: SignInFetcherProtocol {
    init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
    }
    
    func signIn(spec: SignInSpec, completion: @escaping (Result<SignInResponse, NetworkServiceError>) -> Void) {
        networkService.request(
            urlString: UserEndpoint.signIn.urlString,
            method: .post,
            parameters: [:],
            headers: [:],
            body: spec,
            completion: completion
        )
    }
    
    private let networkService: NetworkServiceProtocol
}
