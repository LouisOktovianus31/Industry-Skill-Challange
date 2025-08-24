//
//  CreateBookingByEmailSpec.swift
//  Coco
//
//  Created by Arin Juan Sari on 24/08/25.
//

import Foundation

struct CreateBookingByEmailSpec: JSONEncodable {
    let bookingId: Int
    let emails: [String]
    
    
    private enum CodingKeys: String, CodingKey {
        case bookingId = "booking_id"
        case emails = "emails"
    }
}
