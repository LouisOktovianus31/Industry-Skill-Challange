//
//  MyTripListCardDataModel.swift
//  Coco
//
//  Created by Jackie Leonardy on 14/07/25.
//

import Foundation

struct MyTripListCardDataModel {
    let id: Int
    let imageUrl: String
    let dateText: String
    let date: Date
    let title: String
    let location: String
    let bookedBy: String
    
    struct StatusLabel {
        let text: String
        let style: CocoStatusLabelStyle
    }
    
    init(bookingDetail: BookingDetails) {
        var dateResult: String = ""
        var actualDate: Date = Date()
        
        let inputFormatter: DateFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        if let date = inputFormatter.date(from: bookingDetail.activityDate) {
            let outputFormatter: DateFormatter = DateFormatter()
            outputFormatter.dateFormat = "EEE, dd MMM yyyy"
            outputFormatter.locale = Locale(identifier: "en_US_POSIX")
            
            dateResult = outputFormatter.string(from: date)
            actualDate = date
        } else {
            dateResult = bookingDetail.activityDate
        }
        
        id = bookingDetail.bookingId
        imageUrl = bookingDetail.destinationImage
        dateText = dateResult
        date = actualDate
        title = bookingDetail.activityTitle
        location = bookingDetail.destinationName
//        bookedBy = "BookedBy: \(bookingDetail.isPlanner ? "You" : bookingDetail.bookedBy)"
        bookedBy = "BookedBy: You"
    }
}
