//
//  BookingResponse.swift
//  Coco
//
//  Created by Grachia Uliari on 21/08/25.
//
import Foundation

private extension ISO8601DateFormatter {
    static let iso8601Fractional: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        f.timeZone = TimeZone(secondsFromGMT: 0)
        return f
    }()
}

struct TripBookingDetails: JSONDecodable {
    let bookingId: Int
//    let userId: Int
    let date: Date
    let plannerName: String
    let participants: Int
    let totalPrice: Decimal
    let status: String
    let activityTitle: String
    let packageName: String
    let destinationName: String
    let destinationImage: String?
    let longitude: Double
    let latitude: Double
    let importantNotice: String?
    let includedAccessories: [String]
    let memberEmails: [String]
    
    // MARK: - Memberwise init supaya bisa bikin placeholder
    init(
        bookingId: Int,
//        userId: Int,
        date: Date,
        plannerName: String,
        participants: Int,
        totalPrice: Decimal,
        status: String,
        activityTitle: String,
        packageName: String,
        destinationName: String,
        destinationImage: String?,
        longitude: Double,
        latitude: Double,
        importantNotice: String?,
        includedAccessories: [String],
        memberEmails: [String]
    ) {
        self.bookingId = bookingId
//        self.userId = userId
        self.date = date
        self.plannerName = plannerName
        self.participants = participants
        self.totalPrice = totalPrice
        self.status = status
        self.activityTitle = activityTitle
        self.packageName = packageName
        self.destinationName = destinationName
        self.destinationImage = destinationImage
        self.longitude = longitude
        self.latitude = latitude
        self.importantNotice = importantNotice
        self.includedAccessories = includedAccessories
        self.memberEmails = memberEmails
    }
    
    enum CodingKeys: String, CodingKey {
        case bookingId          = "booking_id"
//        case userId             = "user_id"
        case date
        case plannerName       = "planner_name"
        case participants
        case totalPrice         = "total_price"
        case status
        case activityTitle      = "activity_title"
        case packageName        = "package_name"
        case destinationName    = "destination_name"
        case destinationImage   = "destination_image"
        case longitude
        case latitude
        case importantNotice    = "important_notice"
        case includedAccessories = "included_accessories"
        case memberEmails       = "member_emails"
    }
    
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        
        bookingId = try c.decode(Int.self, forKey: .bookingId)
        
//        userId = try c.decode(Int.self, forKey: .userId)
        
        // "2024-08-25T00:00:00.000Z" -> Date
        let dateString = try c.decode(String.self, forKey: .date)
        if let d = ISO8601DateFormatter.iso8601Fractional.date(from: dateString)
            ?? ISO8601DateFormatter().date(from: dateString) {
            date = d
        } else {
            throw DecodingError.dataCorruptedError(
                forKey: .date, in: c,
                debugDescription: "Invalid ISO8601 date: \(dateString)"
            )
        }
        
        participants = try c.decode(Int.self, forKey: .participants)
        
        // "3900000.00" -> Decimal (fallback ke number)
        if let priceStr = try? c.decode(String.self, forKey: .totalPrice),
           let dec = Decimal(string: priceStr, locale: Locale(identifier: "en_US_POSIX")) {
            totalPrice = dec
        } else if let dbl = try? c.decode(Double.self, forKey: .totalPrice) {
            totalPrice = Decimal(dbl)
        } else {
            totalPrice = 0
        }
        
        plannerName = try c.decodeIfPresent(String.self, forKey: .plannerName) ?? ""
        status           = try c.decode(String.self, forKey: .status)
        activityTitle    = try c.decode(String.self, forKey: .activityTitle)
        packageName      = try c.decode(String.self, forKey: .packageName)
        destinationName  = try c.decode(String.self, forKey: .destinationName)
        destinationImage = try c.decodeIfPresent(String.self, forKey: .destinationImage)
        
        // longitude & latitude bisa string atau number
        func decodeCoord(_ key: CodingKeys) throws -> Double {
            if let s = try? c.decode(String.self, forKey: key),
               let v = Double(s) { return v }
            if let v = try? c.decode(Double.self, forKey: key) { return v }
            return 0
        }
        longitude = try decodeCoord(.longitude)
        latitude  = try decodeCoord(.latitude)
        
        importantNotice    = try c.decodeIfPresent(String.self, forKey: .importantNotice)
        includedAccessories = (try? c.decode([String].self, forKey: .includedAccessories)) ?? []
        memberEmails        = (try? c.decode([String].self, forKey: .memberEmails)) ?? []
    }
}

private extension TripBookingDetails {
    static var placeholderForInit: TripBookingDetails {
        .init(
            bookingId: 0,
//            userId: 0,
            date: Date(),
            plannerName: "-",
            participants: 0,
            totalPrice: 0,
            status: "-",
            activityTitle: "-",
            packageName: "-",
            destinationName: "-",
            destinationImage: nil,
            longitude: 0,
            latitude: 0,
            importantNotice: nil,
            includedAccessories: [],
            memberEmails: []
        )
    }
}
