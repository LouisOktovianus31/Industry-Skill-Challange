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
    let startTime: String?
    let destinationName: String
    let destinationImage: String
    let totalPrice: Double?
    let packageName: String?
    let participants: Int?
    let activityDate: String
    let activityTitle: String
    let bookingCreatedAt: String?
    let address: String?
    let host: HostPackage?
    let user: UserBooking?
    let facilities: [String]?
    
    enum CodingKeys: String, CodingKey {
        case status
        case bookingId = "booking_id"
        case startTime = "start_time"
        case destinationName = "destination_name"
        case destinationImage = "destination_image"
        case totalPrice = "total_price"
        case packageName = "package_name"
        case participants
        case activityDate = "date"
        case activityTitle = "activity_title"
        case bookingCreatedAt = "booking_created_at"
        case address
        case host
        case user
        case facilities
    }
}

struct HostPackage: JSONDecodable {
    let id: Int
    let name: String
    let email: String?
    let phone: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case phone
    }
}

struct UserBooking: JSONDecodable {
    let id: Int
    let name: String
    let email: String?
    let groupId: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case groupId = "group_id"
    }
}

struct Traveler: Hashable{
    let id: UUID = .init()
    let name: String
}
