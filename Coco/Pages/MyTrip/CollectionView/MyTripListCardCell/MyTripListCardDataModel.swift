//
//  MyTripListCardDataModel.swift
//  Coco
//
//  Created by Jackie Leonardy on 14/07/25.
//

import Foundation

struct MyTripListCardDataModel {
    //    let statusLabel: StatusLabel
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
        //        var bookingStatus: String = bookingDetail.status
        //        var statusStyle: CocoStatusLabelStyle = .pending
        var dateResult: String = ""
        var actualDate: Date = Date()
        
        let inputFormatter: DateFormatter = DateFormatter()
        inputFormatter.dateFormat = "YYYY-MM-dd"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        if let date = inputFormatter.date(from: bookingDetail.activityDate) {
            let outputFormatter: DateFormatter = DateFormatter()
            outputFormatter.dateFormat = "EEE, dd MMM yyyy"
            outputFormatter.locale = Locale(identifier: "en_US_POSIX")
            
            dateResult = outputFormatter.string(from: date)
            actualDate = date
            
            //            if targetDate < today {
            //                bookingStatus = "Completed"
            //                statusStyle = .success
            //            }
            //            else if targetDate > today {
            //                bookingStatus = "Upcoming"
            //                statusStyle = .refund
            //            }
        } else {
            dateResult = bookingDetail.activityDate
        }
        
        //        statusLabel = StatusLabel(text: bookingStatus, style: statusStyle)
        id = bookingDetail.bookingId
        imageUrl = bookingDetail.destination.imageUrl ?? ""
        dateText = dateResult
        date = actualDate
        title = bookingDetail.activityTitle
        location = bookingDetail.destination.name
        bookedBy = "Booked by Raissa"
    }
}
