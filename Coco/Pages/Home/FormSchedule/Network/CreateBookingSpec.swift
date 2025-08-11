//
//  CreateBookingSpec.swift
//  Coco
//
//  Created by Jackie Leonardy on 12/07/25.
//

import Foundation

struct CreateBookingSpec: JSONEncodable {
    let packageId: Int
    let bookingDate: String
    let participants: Int
    let userId: String
    
    private enum CodingKeys: String, CodingKey {
        case packageId = "p_package_id"
        case bookingDate = "p_booking_date"
        case participants = "p_participants"
        case userId = "p_user_id"
    }
    
    init(packageId: Int, bookingDate: Date, participants: Int, userId: String) {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        
        self.packageId = packageId
        self.bookingDate = formatter.string(from: bookingDate)
        self.participants = participants
        self.userId = userId
    }
}
