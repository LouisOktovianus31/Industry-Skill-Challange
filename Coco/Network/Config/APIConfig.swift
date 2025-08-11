//
//  APIConfig.swift
//  Coco
//
//  Created by Jackie Leonardy on 30/06/25.
//

import Foundation

enum APIConfig {
    static let baseURL = "https://guffnieowbgkilwcjkks.supabase.co/rest/v1/"
}

protocol EndpointProtocol {
    var path: String { get }
    var urlString: String { get }
    var url: URL? { get }
}

extension EndpointProtocol {
    var urlString: String {
        return APIConfig.baseURL + path
    }

    var url: URL? {
        return URL(string: urlString)
    }
}
