//
//  BookingResponse.swift
//  Coco
//
//  Created by Grachia Uliari on 21/08/25.
//
import Foundation

// Parser ISO8601 dengan fractional seconds (…000Z)
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
    let date: Date
    let participants: Int
    let totalPrice: Decimal
    let status: String
    let activityTitle: String
    let packageName: String
    let destinationName: String
    let destinationImage: String?
    let importantNotice: String?
    let includedAccessories: [String]
    let memberEmails: [String]

    enum CodingKeys: String, CodingKey {
        case bookingId          = "booking_id"
        case date
        case participants
        case totalPrice         = "total_price"
        case status
        case activityTitle      = "activity_title"
        case packageName        = "package_name"
        case destinationName    = "destination_name"
        case destinationImage   = "destination_image"
        case importantNotice    = "important_notice"
        case includedAccessories = "included_accessories"
        case memberEmails       = "member_emails"
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)

        bookingId = try c.decode(Int.self, forKey: .bookingId)

        // "2024-08-25T00:00:00.000Z" -> Date
        let dateString = try c.decode(String.self, forKey: .date)
        if let d = ISO8601DateFormatter.iso8601Fractional.date(from: dateString)
            ?? ISO8601DateFormatter().date(from: dateString) {
            date = d
        } else {
            throw DecodingError.dataCorruptedError(
                forKey: .date, in: c, debugDescription: "Invalid ISO8601 date: \(dateString)"
            )
        }

        participants = try c.decode(Int.self, forKey: .participants)

        // "3900000.00" (string) -> Decimal (fallback kalau backend kirim number)
        if let priceStr = try? c.decode(String.self, forKey: .totalPrice),
           let dec = Decimal(string: priceStr, locale: Locale(identifier: "en_US_POSIX")) {
            totalPrice = dec
        } else if let dbl = try? c.decode(Double.self, forKey: .totalPrice) {
            totalPrice = Decimal(dbl)
        } else {
            totalPrice = 0
        }

        status            = try c.decode(String.self, forKey: .status)
        activityTitle     = try c.decode(String.self, forKey: .activityTitle)
        packageName       = try c.decode(String.self, forKey: .packageName)
        destinationName   = try c.decode(String.self, forKey: .destinationName)
        destinationImage  = try c.decodeIfPresent(String.self, forKey: .destinationImage)
        importantNotice   = try c.decodeIfPresent(String.self, forKey: .importantNotice)
        includedAccessories = (try? c.decode([String].self, forKey: .includedAccessories)) ?? []
        memberEmails        = (try? c.decode([String].self, forKey: .memberEmails)) ?? []
    }
}



