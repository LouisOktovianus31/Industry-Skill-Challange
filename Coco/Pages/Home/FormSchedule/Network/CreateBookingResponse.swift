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
//    let userId: Int
    let plannerName: String?
    let isPlanner: Bool?
    let startTime: String?
    let destination: BookingDestination?
    let destinationName: String?
    let destinationImage: String?
    let totalPrice: Double?
    let packageName: String?
    let participants: Int?
    let activityDate: String?
    let activityDate2: String? // INI BUAT DATE DI CREATE BOOKING
    let activityTitle: String?
    let bookingCreatedAt: String?
    let address: String?
    let host: HostPackage?
    let user: UserBooking?
    let facilities: [String]?
    let includedAccessories: [String] = []
    
    enum CodingKeys: String, CodingKey {
        case status
        case bookingId = "booking_id"
//        case userId = "user_id"
        case plannerName = "planner_name"
        case startTime = "start_time"
        case destination
        case destinationName = "destination_name"
        case destinationImage = "destination_image"
        case isPlanner = "is_planner"
        case totalPrice = "total_price"
        case packageName = "package_name"
        case participants
        case activityDate2 = "activity_date"
        case activityDate = "date"
        case activityTitle = "activity_title"
        case bookingCreatedAt = "booking_created_at"
        case address
        case host
        case user
        case facilities
        case includedAccessories = "included_accessories"
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
    let name: String?
    let email: String
}

extension BookingDetails {
    // Bridge dari TripBookingDetails (detail RPC) ke BookingDetails (format lama UI)
    init(trip: TripBookingDetails) {
        self.status           = trip.status
//        self.userId          = trip.userId
        self.bookingId        = trip.bookingId
        self.plannerName      = trip.plannerName
        self.isPlanner        = false
        // Tidak ada di TripBookingDetails → set ke nil
        self.startTime        = nil
        
        self.destinationName  = trip.destinationName
        self.destinationImage = trip.destinationImage ?? ""
        
        // Decimal → Double
        self.totalPrice       = (trip.totalPrice as NSDecimalNumber).doubleValue
        
        // TripBookingDetails punya String non-optional, struct lama optional → ok
        self.packageName      = trip.packageName
        self.participants     = trip.participants
        
        // Date → "yyyy-MM-dd" (menyesuaikan Formatters.apiDateParser)
        self.activityDate     = Formatters.apiDateParser.string(from: trip.date)
        self.activityDate2     = nil
        
        self.activityTitle    = trip.activityTitle
        
        // Tidak ada di TripBookingDetails → set ke nil/default
        self.bookingCreatedAt = nil
        self.address          = trip.destinationName
        self.host             = nil
        self.user             = nil
        self.destination = nil
        
        // Nama berbeda: includedAccessories → facilities
        self.facilities       = trip.includedAccessories
        //        self.includedAccessories = trip.includedAccessories
        
    }
    
    /// Fallback aman saat data belum ada
    static let empty = BookingDetails(
        status: "",
        bookingId: 0,
//        userId: 0,
        plannerName: "",
        isPlanner: false,
        startTime: nil,
        destination: nil,
        destinationName: "",
        destinationImage: "",
        totalPrice: 0,
        packageName: nil,
        participants: 0,
        activityDate: "",
        activityDate2: "",
        activityTitle: "",
        bookingCreatedAt: nil,
        address: nil,
        host: nil,
        user: nil,
        facilities: []
    )
}
