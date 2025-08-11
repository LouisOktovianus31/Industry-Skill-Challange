//
//  TripDetailViewModel.swift
//  Coco
//
//  Created by Jackie Leonardy on 17/07/25.
//

import Foundation

final class TripDetailViewModel {
    weak var actionDelegate: TripDetailViewModelAction?
    
    init(data: BookingDetails) {
        self.data = data
    }
    
    private let data: BookingDetails
}

extension TripDetailViewModel: TripDetailViewModelProtocol {
    func onViewDidLoad() {
        actionDelegate?.configureView(dataModel: BookingDetailDataModel(bookingDetail: data))
    }
}
