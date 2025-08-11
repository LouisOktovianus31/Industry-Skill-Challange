//
//  UserEndpoint.swift
//  Coco
//
//  Created by Jackie Leonardy on 01/07/25.
//

import Foundation

enum UserEndpoint: EndpointProtocol {
    case all
    case signIn

    var path: String {
        switch self {
        case .all:
            return "users"
        case .signIn:
            return "rpc/login"
        }
    }
}
