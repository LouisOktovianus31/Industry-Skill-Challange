//
//  Formatters.swift
//  Coco
//
//  Created by Grachia Uliari on 13/08/25.
//

import Foundation

enum Formatters {
    static let apiDateParser: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = .init(identifier: .gregorian) // calendar modern
        formatter.locale   = .init(identifier: "en_US_POSIX") // spy tdk terpengaruh bhs dan location user iphone
        formatter.timeZone = .gmt
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    static let tripDateDisplay: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale   = .current
        formatter.timeZone = .current
        formatter.dateFormat = "EEE, dd MMM yyyy"
        return formatter
    }()
    
    static let idrCurrency: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = .init(identifier: "id_ID")
        formatter.maximumFractionDigits = 0
        return formatter
    }()
    
    static func idr(_ amount: Double) -> String {
        idrCurrency.string(from: NSNumber(value: amount)) ?? "Rp \(Int(amount))"
    }
}
