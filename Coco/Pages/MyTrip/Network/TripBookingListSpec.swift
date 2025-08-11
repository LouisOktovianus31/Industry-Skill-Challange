//
//  TripBookingListSpec.swift
//  Coco
//
//  Created by Jackie Leonardy on 14/07/25.
//

import Foundation

struct TripBookingListSpec: JSONEncodable {
    let userId: String
    
    private enum CodingKeys: String, CodingKey {
        case userId = "p_user_id"
    }
}
