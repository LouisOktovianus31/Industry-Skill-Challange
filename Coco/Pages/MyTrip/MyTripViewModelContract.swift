//
//  MyTripViewModelContract.swift
//  Coco
//
//  Created by Jackie Leonardy on 14/07/25.
//

import Foundation

protocol MyTripViewModelAction: AnyObject {
    func configureView(datas: [MyTripListCardDataModel])
    func goToBookingDetail(with data: BookingDetails)
}
protocol MyTripViewModelProtocol: AnyObject {
    var actionDelegate: MyTripViewModelAction? { get set }
    
    func onViewWillAppear()
    func onTripListDidTap(at index: Int)
}
