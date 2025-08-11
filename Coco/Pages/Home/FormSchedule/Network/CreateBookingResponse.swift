//
//  CreateBookingResponse.swift
//  Coco
//
//  Created by Jackie Leonardy on 12/07/25.
//

import Foundation

struct CreateBookingResponse: JSONDecodable {
    let message: String
    let success: Bool
    let bookingDetails: BookingDetails

    enum CodingKeys: String, CodingKey {
        case message
        case success
        case bookingDetails = "booking_details"
    }
}

struct BookingDetails: JSONDecodable {
    let status: String
    let bookingId: Int
    let startTime: String
    let destination: BookingDestination
    let totalPrice: Double
    let packageName: String
    let participants: Int
    let activityDate: String
    let activityTitle: String
    let bookingCreatedAt: String
    let address: String

    enum CodingKeys: String, CodingKey {
        case status
        case bookingId = "booking_id"
        case startTime = "start_time"
        case destination
        case totalPrice = "total_price"
        case packageName = "package_name"
        case participants
        case activityDate = "activity_date"
        case activityTitle = "activity_title"
        case bookingCreatedAt = "booking_created_at"
        case address
    }
}

struct BookingDestination: JSONDecodable {
    let id: Int
    let name: String
    let imageUrl: String?
    let description: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case imageUrl = "image_url"
        case description
    }
}
