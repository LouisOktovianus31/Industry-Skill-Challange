//
//  MyTripViewModelContract.swift
//  Coco
//
//  Created by Jackie Leonardy on 14/07/25.
//

import Foundation

protocol MyTripViewModelAction: AnyObject {
    func contructCollectionView(viewModel: MyTripListCollectionViewModelProtocol)
    func goToBookingDetail(with data: BookingDetails)
    func goToRebookingDetail(with data: BookingDetails)
    func segmentDidChange(to index: Int)
}
protocol MyTripViewModelProtocol: AnyObject {
    var actionDelegate: MyTripViewModelAction? { get set }
    
    func onViewWillAppear()
    
    func applyFilter(_ filter: EventFilter)

    func changeFilter(to filter: EventFilter)
    
    func getCurrentFilter() -> EventFilter
}
