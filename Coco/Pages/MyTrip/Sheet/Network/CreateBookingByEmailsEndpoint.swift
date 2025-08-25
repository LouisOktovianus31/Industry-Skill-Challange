//
//  CreateBookingByEmailsEndpoint.swift
//  Coco
//
//  Created by Arin Juan Sari on 24/08/25.
//

import Foundation

enum CreateBookingByEmailsEndpoint: EndpointProtocol {
    case create
    
    var path: String {
        switch self {
        case .create:
            return "rpc/create_user_bookings"
        }
    }
}
