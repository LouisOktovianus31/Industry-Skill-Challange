//
//  CreateBookingByEmailsResponse.swift
//  Coco
//
//  Created by Arin Juan Sari on 24/08/25.
//

import Foundation

struct CreateBookingByEmailsResponse: JSONDecodable {
    let createdAt, updatedAt: String
    let id: Int
    let userID: String?
    let email: String
    let bookingID: Int
    let status, plannerID: String
    let deletedAt: String?

    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case id
        case userID = "user_id"
        case email
        case bookingID = "booking_id"
        case status
        case plannerID = "planner_id"
        case deletedAt = "deleted_at"
    }
}
