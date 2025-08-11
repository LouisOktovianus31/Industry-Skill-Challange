//
//  NetworkService.swift
//  Coco
//
//  Created by Jackie Leonardy on 30/06/25.
//

import Foundation

protocol NetworkServiceProtocol: AnyObject {
    @discardableResult
    func request<T: JSONDecodable>(
        urlString: String,
        method: HTTPMethod,
        parameters: JSONObject,
        headers: [String: String],
        body: JSONEncodable?,
        completion: @escaping (Result<T, NetworkServiceError>) -> Void
    ) -> URLSessionDataTask?
    
    func request<T: JSONDecodable>(
        urlString: String,
        method: HTTPMethod,
        parameters: JSONObject,
        headers: [String: String],
        body: JSONEncodable?
    ) async throws -> T
}

final class NetworkService: NetworkServiceProtocol {
    static let shared: NetworkService = NetworkService()
    
    private init() { }
    
    @discardableResult
    func request<T: JSONDecodable>(
        urlString: String,
        method: HTTPMethod = .get,
        parameters: JSONObject = [:],
        headers: [String: String] = [:],
        body: JSONEncodable? = nil,
        completion: @escaping (Result<T, NetworkServiceError>) -> Void
    ) -> URLSessionDataTask? {
        guard let url: URL = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let apiKey: String = Secrets.shared.apiKey {
            request.setValue(apiKey, forHTTPHeaderField: "apikey")
            request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        }
        
        if let body: JSONObject = body?.toDictionary() {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            } catch {
                completeOnMain(.failure(.bodyParsingFailed), completion)
                return nil
            }
        }

        let task: URLSessionDataTask = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self else { return }
            NetworkLogger.logResponse(data: data, response: response, error: error)
            
            if let error: Error = error {
                let nsError: NSError = error as NSError
                if nsError.code == NSURLErrorNotConnectedToInternet {
                    completeOnMain(.failure(.noInternetConnection), completion)
                    return
                }
                assertionFailure("Request Failed")
                completeOnMain(.failure(.requestFailed(error)), completion)
                return
            }

            guard let httpResponse: HTTPURLResponse = response as? HTTPURLResponse else {
                assertionFailure("invalid Response")
                completeOnMain(.failure(.invalidResponse), completion)
                return
            }

            guard (200..<300).contains(httpResponse.statusCode) else {
                completeOnMain(.failure(.statusCode(httpResponse.statusCode)), completion)
                return
            }

            // Decode response
            guard let data: Data = data else {
                completeOnMain(.failure(.invalidResponse), completion)
                return
            }

            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])

                if let arrayType = T.self as? JSONArrayProtocol.Type,
                   let jsonArray = jsonObject as? [JSONObject] {
                    do {
                        let typedArray = try arrayType.init(jsonArray: jsonArray)
                        guard let casted = typedArray as? T else {
                            let castError = NSError(
                                domain: "TypeCasting",
                                code: -1,
                                userInfo: [
                                    NSLocalizedDescriptionKey: "Failed to cast \(type(of: typedArray)) to \(T.self)"
                                ]
                            )
                            completeOnMain(.failure(.decodingFailed(castError)), completion)
                            return
                        }
                        completeOnMain(.success(casted), completion)
                    } catch {
                        completeOnMain(.failure(.decodingFailed(error)), completion)
                    }
                    return
                }

                if let jsonDict: JSONObject = jsonObject as? JSONObject {
                    let decoded = try T(json: jsonDict)
                    completeOnMain(.success(decoded), completion)
                    return
                }
            } catch {
                assertionFailure("Decoding has Failed with Error: \(error)")
                completeOnMain(.failure(.decodingFailed(error)), completion)
            }
        }
        
        task.resume()
        return task
    }
    
    func request<T: JSONDecodable>(
        urlString: String,
        method: HTTPMethod,
        parameters: JSONObject,
        headers: [String: String],
        body: JSONEncodable?
    ) async throws -> T {
        try await withCheckedThrowingContinuation { continuation in
            request(
                urlString: urlString,
                method: method,
                parameters: parameters,
                headers: headers,
                body: body
            ) { (result: Result<T, NetworkServiceError>) in
                switch result {
                case .success(let value):
                    continuation.resume(returning: value)
                case .failure(let failure):
                    continuation.resume(throwing: failure)
                }
            }
        }
    }
}

private extension NetworkService {
    func completeOnMain<T>(_ result: Result<T, NetworkServiceError>, _ completion: @escaping (Result<T, NetworkServiceError>) -> Void) {
        DispatchQueue.main.async {
            completion(result)
        }
    }
}
