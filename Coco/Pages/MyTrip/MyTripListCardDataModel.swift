//
//  MyTripListCardDataModel.swift
//  Coco
//
//  Created by Jackie Leonardy on 14/07/25.
//

import Foundation

struct MyTripListCardDataModel {
    let statusLabel: StatusLabel
    let imageUrl: String
    let dateText: String
    let title: String
    let location: String
    let totalPax: Int
    let price: String
    
    struct StatusLabel {
        let text: String
        let style: CocoStatusLabelStyle
    }
    
    init(bookingDetail: BookingDetails) {
        var bookingStatus: String = bookingDetail.status
        var statusStyle: CocoStatusLabelStyle = .pending
        
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        
        if let targetDate: Date = formatter.date(from: bookingDetail.activityDate) {
            let today: Date = Date()
            
            if targetDate < today {
                bookingStatus = "Completed"
                statusStyle = .success
            }
            else if targetDate > today {
                bookingStatus = "Upcoming"
                statusStyle = .refund
            }
        }
        
        statusLabel = StatusLabel(text: bookingStatus, style: statusStyle)
        imageUrl = bookingDetail.destination.imageUrl ?? ""
        dateText = bookingDetail.activityDate
        title = bookingDetail.activityTitle
        location = bookingDetail.destination.name
        totalPax = bookingDetail.participants
        price = "Rp \(bookingDetail.totalPrice)"
    }
}
