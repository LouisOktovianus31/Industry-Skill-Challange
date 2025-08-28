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
    func setStateViewData(_ stateData: StateViewData?)
}
protocol MyTripViewModelProtocol: AnyObject {
    var actionDelegate: MyTripViewModelAction? { get set }
    
    func onViewWillAppear() -> Task<Void, Never>
    
    func applyFilter(_ filter: EventFilter)

    func changeFilter(to filter: EventFilter)
    
    func getCurrentFilter() -> EventFilter
}
